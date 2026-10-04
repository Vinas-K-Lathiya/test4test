package com.vlathiya.device_bridge

import android.app.AppOpsManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.os.Build
import android.os.Process
import android.provider.Settings
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Native helpers used for testing verification. Everything is limited to the package names the
 * Dart side passes in (the apps assigned to this user) - we never enumerate other installed apps.
 */
class DeviceBridgePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var ctx: Context
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        ctx = binding.applicationContext
        createNotificationChannel()
        channel = MethodChannel(binding.binaryMessenger, NAME).also { it.setMethodCallHandler(this) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    /** Channel used by FCM notifications (declared as default in the app manifest). */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = ctx.getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(
                NotificationChannel("testpact_default", "Group updates", NotificationManager.IMPORTANCE_HIGH)
            )
        }
    }

    companion object {
        const val NAME = "testpact/device"
        // UsageEvents.Event ACTIVITY_RESUMED (a.k.a. MOVE_TO_FOREGROUND), ACTIVITY_PAUSED, ACTIVITY_STOPPED.
        private const val EVENT_RESUMED = 1
        private const val EVENT_PAUSED = 2
        private const val EVENT_STOPPED = 23
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "deviceId" -> result.success(
                    Settings.Secure.getString(ctx.contentResolver, Settings.Secure.ANDROID_ID) ?: ""
                )
                "installed" -> {
                    val pkgs = call.argument<List<String>>("packages") ?: emptyList()
                    result.success(pkgs.associateWith { isInstalled(it) })
                }
                "hasUsageAccess" -> result.success(hasUsageAccess())
                "openUsageAccessSettings" -> {
                    val i = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    ctx.startActivity(i)
                    result.success(true)
                }
                "privateDns" -> {
                    // Android 9+: hostname is non-null only in "Private DNS provider hostname" mode.
                    var active = false
                    var server: String? = null
                    if (Build.VERSION.SDK_INT >= 28) {
                        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                        val lp = cm.getLinkProperties(cm.activeNetwork)
                        active = lp?.isPrivateDnsActive == true
                        server = lp?.privateDnsServerName
                    }
                    // The global setting reflects the user's choice even when no network is up.
                    val mode = try {
                        Settings.Global.getString(ctx.contentResolver, "private_dns_mode")
                    } catch (e: Exception) { null }
                    val specifier = try {
                        Settings.Global.getString(ctx.contentResolver, "private_dns_specifier")
                    } catch (e: Exception) { null }
                    if (server == null && mode == "hostname" && !specifier.isNullOrBlank()) server = specifier
                    result.success(mapOf("active" to active, "server" to server, "mode" to mode))
                }
                "openNetworkSettings" -> {
                    val i = Intent(Settings.ACTION_WIRELESS_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    ctx.startActivity(i)
                    result.success(true)
                }
                "openNotificationSettings" -> {
                    val i = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                        .putExtra(Settings.EXTRA_APP_PACKAGE, ctx.packageName)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    ctx.startActivity(i)
                    result.success(true)
                }
                "usageSince" -> {
                    val pkgs = (call.argument<List<String>>("packages") ?: emptyList()).toSet()
                    val start = (call.argument<Number>("startMillis") ?: 0L).toLong()
                    result.success(usageSince(pkgs, start))
                }
                "launch" -> {
                    val pkg = call.argument<String>("package") ?: ""
                    val intent = ctx.packageManager.getLaunchIntentForPackage(pkg)
                    if (intent == null) {
                        result.success(false)
                    } else {
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        ctx.startActivity(intent)
                        result.success(true)
                    }
                }
                "integrityToken" -> {
                    val nonce = call.argument<String>("nonce") ?: ""
                    val projectNumber = (call.argument<Number>("cloudProjectNumber") ?: 0L).toLong()
                    val builder = IntegrityTokenRequest.builder().setNonce(nonce)
                    if (projectNumber > 0) builder.setCloudProjectNumber(projectNumber)
                    IntegrityManagerFactory.create(ctx).requestIntegrityToken(builder.build())
                        .addOnSuccessListener { result.success(it.token()) }
                        .addOnFailureListener { result.error("integrity", it.message, null) }
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("device", e.message, null)
        }
    }

    private fun isInstalled(pkg: String): Boolean = try {
        if (Build.VERSION.SDK_INT >= 33) {
            ctx.packageManager.getPackageInfo(pkg, PackageManager.PackageInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            ctx.packageManager.getPackageInfo(pkg, 0)
        }
        true
    } catch (e: PackageManager.NameNotFoundException) {
        false
    }

    private fun hasUsageAccess(): Boolean {
        val ops = ctx.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= 29) {
            ops.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        } else {
            @Suppress("DEPRECATION")
            ops.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), ctx.packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    /**
     * Foreground minutes and number of launches for each package since [start], computed from
     * raw resume/pause events so it is accurate across day boundaries.
     */
    private fun usageSince(pkgs: Set<String>, start: Long): Map<String, Map<String, Long>> {
        val out = pkgs.associateWith { mutableMapOf("minutes" to 0L, "opens" to 0L) }
        if (!hasUsageAccess() || pkgs.isEmpty()) return out
        val usm = ctx.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val now = System.currentTimeMillis()
        val events = usm.queryEvents(start, now)
        val fgSince = HashMap<String, Long>()
        val lastPause = HashMap<String, Long>()
        val totalMs = HashMap<String, Long>()
        val ev = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(ev)
            val pkg = ev.packageName ?: continue
            if (pkg !in pkgs) continue
            when (ev.eventType) {
                EVENT_RESUMED -> {
                    if (fgSince[pkg] == null) {
                        fgSince[pkg] = ev.timeStamp
                        // Moving between screens of the same app is not a new "open".
                        val paused = lastPause[pkg]
                        if (paused == null || ev.timeStamp - paused > 5_000L) {
                            out[pkg]!!["opens"] = out[pkg]!!["opens"]!! + 1
                        }
                    }
                }
                EVENT_PAUSED, EVENT_STOPPED -> {
                    val s = fgSince.remove(pkg)
                    if (s != null) {
                        totalMs[pkg] = (totalMs[pkg] ?: 0L) + (ev.timeStamp - s)
                        lastPause[pkg] = ev.timeStamp
                    }
                }
            }
        }
        // Still in the foreground right now.
        for ((pkg, s) in fgSince) totalMs[pkg] = (totalMs[pkg] ?: 0L) + (now - s)
        for ((pkg, ms) in totalMs) out[pkg]!!["minutes"] = ms / 60000L
        return out
    }
}
