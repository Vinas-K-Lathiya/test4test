#!/usr/bin/env python3
"""Generates lib/l10n/app_<lang>.arb from tool/strings_*.py. English is the template (with placeholder metadata)."""
import importlib.util, json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "tool"))
from strings_en import EN  # noqa: E402

def write(lang, table):
    out = {"@@locale": lang}
    for key, (en_text, ph) in EN.items():
        out[key] = table.get(key, en_text) if lang != "en" else en_text
        if lang == "en" and ph:
            out["@" + key] = {"placeholders": {p: {"type": t} for p, t in ph.items()}}
    path = os.path.join(ROOT, "lib", "l10n", f"app_{lang}.arb")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
        f.write("\n")
    missing = [k for k in EN if lang != "en" and k not in table]
    extra = [k for k in table if k not in EN]
    print(f"{lang}: {len(EN)} keys, missing {len(missing)}, extra {len(extra)}", missing[:5], extra[:5])

write("en", {})
for lang in ["hi", "gu", "mr", "es", "pt"]:
    p = os.path.join(ROOT, "tool", f"strings_{lang}.py")
    if os.path.exists(p):
        spec = importlib.util.spec_from_file_location(f"s_{lang}", p)
        m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
        write(lang, m.T)
