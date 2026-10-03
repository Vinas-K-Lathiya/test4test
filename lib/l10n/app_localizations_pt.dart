// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get saved => 'Salvo';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Próximo';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get you => 'você';

  @override
  String get required => 'Obrigatório';

  @override
  String get open => 'Abrir';

  @override
  String get install => 'Instalar';

  @override
  String get leave => 'Sair';

  @override
  String get accept => 'Aceitar';

  @override
  String get reject => 'Recusar';

  @override
  String get confirmAction => 'Confirmar';

  @override
  String get errDeviceInUse =>
      'Este celular já está vinculado a outra conta do TestPact. Uma conta por aparelho mantém os grupos justos.';

  @override
  String get errBanned =>
      'Sua conta não pode entrar em novos grupos agora. Você pode enviar um recurso.';

  @override
  String get errAlreadyInGroup =>
      'Você já está em um grupo. Termine-o primeiro.';

  @override
  String get errAppNotFound => 'Esse app não existe mais.';

  @override
  String get errAppealOpen => 'Você já tem um recurso aguardando análise.';

  @override
  String get errAlreadyRated => 'Você já avaliou este feedback.';

  @override
  String get errIntegrity =>
      'Este aparelho não passou na verificação de integridade do Google Play. Use um celular real com o app instalado pelo Google Play.';

  @override
  String get errNetwork =>
      'Sem conexão. Verifique sua internet e tente de novo.';

  @override
  String get errGeneric => 'Algo deu errado. Tente novamente.';

  @override
  String get levelProbation => 'Em observação';

  @override
  String get levelNewcomer => 'Novato';

  @override
  String get levelMember => 'Membro';

  @override
  String get levelTrusted => 'Confiável';

  @override
  String get levelTopTester => 'Top tester';

  @override
  String get reasonNotInstalled => 'Não instalou meu app';

  @override
  String get reasonUninstalled => 'Desinstalou durante o teste';

  @override
  String get reasonNotOpening => 'Não abre os apps todo dia';

  @override
  String get reasonEmailNotAdded => 'Não adicionou meu e-mail ao teste';

  @override
  String get reasonSpam => 'Spam ou abuso';

  @override
  String get reasonFakeFeedback => 'Feedback falso ou copiado';

  @override
  String get reasonOther => 'Outro';

  @override
  String get catBug => 'Bug';

  @override
  String get catUx => 'Design / UX';

  @override
  String get catIdea => 'Ideia';

  @override
  String get catPraise => 'Elogio';

  @override
  String get catOther => 'Outro';

  @override
  String get badgeFirstPact => 'Primeiro pacto';

  @override
  String get badgeVeteran => 'Veterano (5 grupos)';

  @override
  String get badgePerfect => 'Sequência perfeita';

  @override
  String get badgeHelpful => 'Revisor útil';

  @override
  String get badgeTopTester => 'Top tester';

  @override
  String get removedSetup => 'configuração não concluída a tempo';

  @override
  String get removedInactive => 'inativo por 3 dias';

  @override
  String get removedReported => 'denúncias confirmadas pelo admin';

  @override
  String get removedLeft => 'saiu do grupo';

  @override
  String get removedCancelled => 'grupo cancelado';

  @override
  String get removedEnded => 'grupo encerrado';

  @override
  String get removedOther => 'removido';

  @override
  String trustAdmin(String reason) {
    return 'Ajuste do admin: $reason';
  }

  @override
  String get trustGroupCompleted => 'Concluiu um grupo';

  @override
  String get trustActiveDay => 'Abriu todos os apps do dia';

  @override
  String get trustMissedDay => 'Perdeu um dia';

  @override
  String get trustHelpfulFeedback => 'Feedback marcado como útil';

  @override
  String get trustKickedInactive => 'Removido por inatividade';

  @override
  String get trustKickedReported => 'Removido após denúncias confirmadas';

  @override
  String get trustSetupFailed => 'Configuração não concluída';

  @override
  String get trustLeftGroup => 'Saiu cedo de um grupo';

  @override
  String get trustFalseReport => 'Denúncia recusada pelo admin';

  @override
  String get trustAppealAccepted => 'Recurso aceito';

  @override
  String get statusSetup => 'Configuração';

  @override
  String get statusActive => 'Em teste';

  @override
  String get statusCompleted => 'Concluído';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get stateSetup => 'Configurando';

  @override
  String get stateActive => 'Testando';

  @override
  String get stateSuspended => 'Em análise';

  @override
  String get stateRemoved => 'Removido';

  @override
  String get stateCompleted => 'Concluído';

  @override
  String get language => 'Idioma';

  @override
  String get tagline =>
      'Testers reais. Feedback real.\nPasse no teste fechado do Google Play em conjunto.';

  @override
  String get signInBullet1 =>
      'Entre em um grupo de até 20 desenvolvedores Android';

  @override
  String get signInBullet2 =>
      'Instalações e uso diário são verificados no aparelho';

  @override
  String get signInBullet3 =>
      'Dê e receba feedback honesto que melhora seu app';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get terms => 'Termos';

  @override
  String get ob1Title => 'Um pacto entre desenvolvedores';

  @override
  String get ob1P1 =>
      'O Google exige 12 testers inscritos por 14 dias antes de uma conta pessoal nova ir para produção.';

  @override
  String get ob1P2 =>
      'Você entra em um grupo. Todos se adicionam como testers e instalam os apps de todos.';

  @override
  String get ob1P3 =>
      'Por 16 dias você abre cada app da sua lista todos os dias. Os outros fazem o mesmo com o seu.';

  @override
  String get ob2Title => 'Justo para todos';

  @override
  String get ob2P1 =>
      'Seu app só aparece para os outros depois que você adiciona os e-mails deles: primeiro dê, depois receba.';

  @override
  String get ob2P2 =>
      'Sua pontuação de confiança sobe quando você testa todo dia e dá feedback útil, e cai quando não.';

  @override
  String get ob2P3 =>
      'Membros inativos recebem avisos e são removidos após 3 dias sem atividade. Denúncias são comparadas com dados reais de uso.';

  @override
  String get ob3Title => 'Comprove seus testes automaticamente';

  @override
  String get ob3P1 =>
      'O TestPact verifica apenas os apps atribuídos a você: se estão instalados e quantos minutos foram usados hoje.';

  @override
  String get ob3P2 => 'Nada sobre seus outros apps é lido ou enviado.';

  @override
  String get usageAccessTitle => 'Acesso ao uso';

  @override
  String get usageAccessBody =>
      'Permite ao TestPact contar os minutos que você passa nos apps atribuídos, para você ganhar crédito mesmo abrindo pela tela inicial.';

  @override
  String get granted => 'Concedido ✓';

  @override
  String get notGranted => 'Não concedido, toque para ativar';

  @override
  String get grantUsageAccess => 'Conceder acesso ao uso';

  @override
  String get notificationsTitle => 'Lembretes';

  @override
  String get notificationsBody =>
      'Lembretes diários e novidades do grupo para você nunca perder um dia.';

  @override
  String get allowNotifications => 'Permitir notificações';

  @override
  String get getStarted => 'Começar';

  @override
  String get settingUp => 'Preparando sua conta…';

  @override
  String get signOut => 'Sair da conta';

  @override
  String get tabHome => 'Início';

  @override
  String get tabMyApps => 'Meus apps';

  @override
  String get tabFeedback => 'Feedback';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get admin => 'Admin';

  @override
  String get settings => 'Configurações';

  @override
  String get addApp => 'Adicionar app';

  @override
  String get bannedTitle => 'Conta restrita';

  @override
  String bannedBody(int count) {
    return 'Você tem $count advertências, então não pode entrar em novos grupos. Se acha que é um erro, envie um recurso.';
  }

  @override
  String get appeal => 'Recorrer';

  @override
  String strikesTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count advertências',
      one: '1 advertência',
    );
    return '$_temp0 na sua conta';
  }

  @override
  String get strikesBody =>
      'Com 3 advertências você não pode entrar em novos grupos. Advertências vêm de remoções por inatividade ou denúncias confirmadas.';

  @override
  String get howItWorks => 'Como funciona';

  @override
  String get googleRuleTitle => 'A regra do Google Play';

  @override
  String get googleRuleBody =>
      'Contas pessoais de desenvolvedor criadas após 13 de novembro de 2023 precisam de pelo menos 12 testers inscritos por 14 dias seguidos. Os grupos começam com 20 pessoas e duram 16 dias, então você tem folga. O Google também verifica se os testers realmente usaram o app: não basta instalar, abra e explore.';

  @override
  String hello(String name) {
    return 'Olá, $name 👋';
  }

  @override
  String get joinCardTitle => 'Pronto para encontrar testers?';

  @override
  String get joinCardBody =>
      'Entre na fila. Assim que houver desenvolvedores suficientes, seu grupo é criado automaticamente.';

  @override
  String get joinCardNoApps =>
      'Primeiro adicione o app que você quer testar, com o link do teste fechado.';

  @override
  String get joinGroup => 'Entrar em um grupo';

  @override
  String get addYourApp => 'Adicione seu app';

  @override
  String get inQueueTitle => 'Você está na fila';

  @override
  String inQueueBody(String app, String tier) {
    return 'Aguardando para colocar $app em um grupo $tier. Avisaremos quando estiver pronto.';
  }

  @override
  String get tierTrusted => 'confiável';

  @override
  String get tierStarter => 'inicial';

  @override
  String queueWaiting(int count, int size) {
    return '$count de $size desenvolvedores aguardando';
  }

  @override
  String queueJoinedAt(String time) {
    return 'Entrou em $time';
  }

  @override
  String get leaveQueue => 'Sair da fila';

  @override
  String dayOf(int day, int total) {
    return 'Dia $day de $total';
  }

  @override
  String groupTitle(String id) {
    return 'Grupo #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'Abertos hoje: $opened de $total';
  }

  @override
  String get setupDoneWaiting =>
      'Configuração concluída ✓ Aguardando os outros.';

  @override
  String get setupTodo =>
      'Conclua a configuração: adicione os e-mails e instale os apps de todos.';

  @override
  String get suspendedBody =>
      'Você está em análise após várias denúncias. Um admin está verificando seus dados de atividade.';

  @override
  String get openGroup => 'Abrir grupo';

  @override
  String get step1Title => 'Adicione seu app';

  @override
  String get step1Body =>
      'Nome, pacote e seu link de inscrição no teste fechado.';

  @override
  String get step2Title => 'Entre na fila';

  @override
  String get step2Body =>
      'Grupos de 20 se formam sozinhos. Testers confiáveis são agrupados entre si.';

  @override
  String get step3Title => 'Configure em 48 h';

  @override
  String get step3Body =>
      'Cole os e-mails de todos no Play Console, depois entre e instale cada app.';

  @override
  String get step4Title => 'Teste todo dia por 16 dias';

  @override
  String get step4Body =>
      'Abra cada app diariamente e deixe feedback real. Verificamos no aparelho.';

  @override
  String get step5Title => 'Peça produção';

  @override
  String get step5Body =>
      'Ganhe pontos de confiança e selos e solicite acesso à produção no Play Console.';

  @override
  String get rule1 =>
      'Vou adicionar o e-mail de cada membro ao meu teste fechado em até 48 horas.';

  @override
  String get rule2 => 'Vou instalar o app de cada membro e mantê-lo até o fim.';

  @override
  String get rule3 =>
      'Vou abrir cada app todos os dias por 16 dias e dar feedback honesto.';

  @override
  String get rule4 =>
      'Entendo que membros inativos são removidos e perdem pontos de confiança.';

  @override
  String get chooseApp => 'Qual app deve ser testado?';

  @override
  String get yourCommitment => 'Seu compromisso';

  @override
  String get joinedQueue => 'Você está na fila!';

  @override
  String get joinQueue => 'Entrar na fila';

  @override
  String get noAppsTitle => 'Nenhum app ainda';

  @override
  String get noAppsBody =>
      'Adicione o app que você quer testar. Você vai precisar do link de inscrição do teste fechado no Play Console.';

  @override
  String get deleteAppTitle => 'Excluir este app?';

  @override
  String get deleteAppBody =>
      'Grupos que já o incluem mantêm uma cópia. Você pode adicioná-lo de novo depois.';

  @override
  String get editApp => 'Editar app';

  @override
  String get appIcon => 'Toque para definir o ícone';

  @override
  String get appName => 'Nome do app';

  @override
  String get packageName => 'Nome do pacote';

  @override
  String get invalidPackage => 'Digite um pacote válido, ex.: com.example.app';

  @override
  String get optInLink => 'Link de inscrição no teste fechado';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → link \"Join on the web\".';

  @override
  String get invalidOptIn => 'Deve ser um link play.google.com/apps/testing/…';

  @override
  String get shortDescription => 'Descrição curta';

  @override
  String get testNotes => 'O que os testers devem experimentar?';

  @override
  String get testNotesHelp =>
      'ex.: \"Crie uma conta e adicione 2 itens ao carrinho\". Aparece para os testers todo dia.';

  @override
  String get closedTestTipTitle => 'Antes de entrar';

  @override
  String get closedTestTipBody =>
      'Crie uma faixa de teste fechado, envie uma versão, publique e defina os testers como lista de e-mails. Os e-mails do seu grupo vão lá.';

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabSetup => 'Configuração';

  @override
  String get tabMembers => 'Membros';

  @override
  String get tabActivity => 'Atividade';

  @override
  String get leaveGroup => 'Sair do grupo';

  @override
  String get leaveGroupTitle => 'Sair deste grupo?';

  @override
  String get leaveGroupBody =>
      'Os outros deixarão de testar seu app e você perderá pontos de confiança. Não dá para desfazer.';

  @override
  String youWereRemoved(String reason) {
    return 'Você foi removido: $reason.';
  }

  @override
  String get youCompleted =>
      'Você concluiu este grupo 🏆 Agora pode solicitar acesso à produção no Play Console.';

  @override
  String get setupDeadlinePassed =>
      'O prazo de configuração acabou. Processando…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return 'Faltam $hours h $minutes min para concluir a configuração';
  }

  @override
  String get setupExplain =>
      'Quem não concluir é substituído pela fila. O teste começa quando todos estiverem prontos.';

  @override
  String get step1AddEmails =>
      'Passo 1 · Adicione testers ao seu teste fechado';

  @override
  String addEmailsBody(int count) {
    return 'Copie os $count e-mails e cole na lista de e-mails do seu teste fechado no Play Console.';
  }

  @override
  String get copyAllEmails => 'Copiar todos os e-mails';

  @override
  String copied(int count) {
    return '$count e-mails copiados';
  }

  @override
  String get emailsConfirmed => 'E-mails adicionados';

  @override
  String get iAddedEveryone => 'Adicionei todos';

  @override
  String get confirmEmailsTitle => 'Você adicionou todos os e-mails?';

  @override
  String confirmEmailsBody(int count) {
    return 'Confirme que os $count e-mails estão na lista de testers do seu teste fechado e que a alteração foi salva. Os membros podem denunciar você se não conseguirem entrar.';
  }

  @override
  String get yesAdded => 'Sim, todos adicionados';

  @override
  String get emailsHowTo =>
      'Play Console → seu app → Testing → Closed testing → Testers → Email list → colar → Save.';

  @override
  String step2InstallApps(int done, int total) {
    return 'Passo 2 · Entre e instale os apps ($done/$total)';
  }

  @override
  String get checkAgain => 'Verificar de novo';

  @override
  String waitingForOwners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros ainda não adicionaram',
      one: '1 membro ainda não adicionou',
    );
    return '$_temp0 os e-mails do grupo. Os apps deles aparecem aqui quando fizerem isso.';
  }

  @override
  String get noAppsYet => 'Ainda não há apps para instalar.';

  @override
  String byName(String name) {
    return 'de $name';
  }

  @override
  String get joinTest => 'Entrar no teste';

  @override
  String get newMembersTitle => 'Novo membro entrou';

  @override
  String get newMembersBody =>
      'Adicione os novos e-mails ao seu teste fechado e instale o app. Abra a aba Configuração.';

  @override
  String get usageAccessOffTitle => 'O acesso ao uso está desativado';

  @override
  String get usageAccessOffBody =>
      'Só contam os apps abertos pelo botão Abrir. Ative o acesso ao uso para ganhar crédito também ao abri-los pela tela inicial.';

  @override
  String get yourTestList => 'Sua lista de testes';

  @override
  String get todayTitle => 'Testes de hoje';

  @override
  String get todayDone => 'Tudo pronto por hoje 🎉';

  @override
  String get todayDoneBody => 'Ótimo trabalho. Volte amanhã.';

  @override
  String todayBody(int needed) {
    return 'Abra pelo menos $needed apps e use cada um por um tempo.';
  }

  @override
  String dayResetsAt(String time) {
    return 'O novo dia começa às $time';
  }

  @override
  String get notInstalled => 'Não instalado';

  @override
  String openedMinutes(int minutes) {
    return 'Aberto hoje · $minutes min';
  }

  @override
  String get notOpenedYet => 'Não aberto hoje';

  @override
  String feedbackGivenCount(int count) {
    return 'Feedback ($count)';
  }

  @override
  String get giveFeedback => 'Feedback';

  @override
  String get statMembers => 'Membros';

  @override
  String get statOnTrack => 'Em dia hoje';

  @override
  String get statRemoved => 'Removidos';

  @override
  String get membersLegend =>
      '🟢 em dia  🟡 pendente  🔴 dias perdidos  ⚪ saiu';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'e-mails $emails · instalados $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'instalados $installed/$total · abertos $opened/$total · feedback $feedback';
  }

  @override
  String missedInARow(int count) {
    return '$count dia(s) seguidos sem atividade';
  }

  @override
  String get lastDays => 'Últimos dias';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get openInPlay => 'Abrir na Play Store';

  @override
  String get reportMember => 'Denunciar';

  @override
  String get reportSent =>
      'Denúncia enviada. Obrigado por manter os grupos justos.';

  @override
  String reportTitle(String name) {
    return 'Denunciar $name';
  }

  @override
  String get reportExplain =>
      'Só agimos quando vários membros denunciam E nossos dados de uso concordam. Denúncias falsas custam pontos de confiança.';

  @override
  String get detailsOptional => 'Detalhes (opcional)';

  @override
  String get addScreenshot => 'Adicionar captura';

  @override
  String get screenshotAdded => 'Captura adicionada ✓';

  @override
  String get sendReport => 'Enviar denúncia';

  @override
  String get noActivity => 'Nenhuma atividade ainda';

  @override
  String evFormed(int count) {
    return 'Grupo formado com $count desenvolvedores';
  }

  @override
  String evJoined(String name) {
    return '$name entrou no grupo';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name adicionou os e-mails de todos';
  }

  @override
  String get evStarted => 'Teste iniciado: dia 1';

  @override
  String evMemberActive(String name) {
    return '$name concluiu a configuração e começou a testar';
  }

  @override
  String evWarning(String name) {
    return '$name perdeu 2 dias seguidos (último aviso)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name foi removido ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name está em análise pelo admin';
  }

  @override
  String evReinstated(String name) {
    return '$name foi liberado e voltou';
  }

  @override
  String get evCompleted => 'Grupo concluído 🏆';

  @override
  String get evCancelled => 'Grupo cancelado';

  @override
  String get feedbackSent => 'Feedback enviado. Obrigado!';

  @override
  String feedbackFor(String app) {
    return 'Feedback: $app';
  }

  @override
  String get developerAsks => 'O desenvolvedor pede que você experimente';

  @override
  String get rating => 'Avaliação';

  @override
  String get category => 'Categoria';

  @override
  String get yourFeedback => 'Seu feedback';

  @override
  String get feedbackHint =>
      'O que funcionou, o que quebrou, o que confundiu? Seja específico: telas, passos, aparelho.';

  @override
  String get feedbackMin => 'Pelo menos 20 caracteres';

  @override
  String get sendFeedback => 'Enviar feedback';

  @override
  String get received => 'Recebidos';

  @override
  String get given => 'Enviados';

  @override
  String get noFeedbackReceived => 'Nenhum feedback ainda';

  @override
  String get noFeedbackReceivedBody =>
      'O feedback dos testers do seu grupo aparece aqui.';

  @override
  String get noFeedbackGiven => 'Você ainda não deu feedback';

  @override
  String get noFeedbackGivenBody =>
      'Use o botão Feedback em cada app na aba Hoje do seu grupo.';

  @override
  String fromOnApp(String name, String app) {
    return '$name sobre $app';
  }

  @override
  String get wasHelpful => 'Isso foi útil?';

  @override
  String get markedHelpful =>
      'Você marcou como útil (+2 de confiança para a pessoa)';

  @override
  String get markedNotHelpful => 'Marcado como não útil';

  @override
  String get groupHistory => 'Grupos';

  @override
  String get noGroupsYet => 'Nenhum grupo ainda.';

  @override
  String get trustHistory => 'Histórico de confiança';

  @override
  String get noTrustHistory => 'Nenhuma alteração ainda.';

  @override
  String get trustScore => 'Pontuação de confiança';

  @override
  String pointsToNext(int points) {
    return '$points pontos para o próximo nível';
  }

  @override
  String get statCompleted => 'Grupos concluídos';

  @override
  String get statCompletionRate => 'Taxa de conclusão';

  @override
  String get statDailyActivity => 'Atividade diária';

  @override
  String get statActiveDays => 'Dias ativos';

  @override
  String get statFeedback => 'Feedbacks dados';

  @override
  String get statHelpful => 'Feedbacks úteis';

  @override
  String get badges => 'Selos';

  @override
  String get noBadges => 'Conclua seu primeiro grupo para ganhar um selo.';

  @override
  String get systemLanguage => 'Padrão do sistema';

  @override
  String get general => 'Geral';

  @override
  String get about => 'Sobre';

  @override
  String get contactSupport => 'Falar com o suporte';

  @override
  String get rateApp => 'Avaliar o TestPact';

  @override
  String get account => 'Conta';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountTitle => 'Excluir sua conta?';

  @override
  String get deleteAccountBody =>
      'Seu perfil, apps e pontuação de confiança serão excluídos para sempre. Se estiver em um grupo, você será removido dele.';

  @override
  String get appealTitle => 'Recorrer de uma decisão';

  @override
  String get appealExplain =>
      'Explique o que aconteceu. Um admin analisa cada recurso. Se aceito, uma advertência é removida e você recupera alguns pontos de confiança.';

  @override
  String get appealHint =>
      'O que aconteceu? Inclua datas e qualquer coisa que nos ajude a verificar.';

  @override
  String get appealSent => 'Recurso enviado';

  @override
  String get sendAppeal => 'Enviar recurso';

  @override
  String get yourAppeals => 'Seus recursos';

  @override
  String get appealOpen => 'Aguardando análise';

  @override
  String get appealAccepted => 'Aceito';

  @override
  String get appealRejected => 'Recusado';

  @override
  String get adminReviews => 'Análises';

  @override
  String get adminAppeals => 'Recursos';

  @override
  String get adminUsers => 'Usuários';

  @override
  String get noteOptional => 'Nota para o usuário (opcional)';

  @override
  String get nothingToReview => 'Nada para analisar 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'Dados de uso: $active dias ativos, $missed dias perdidos';
  }

  @override
  String get rejectReports => 'Recusar denúncias';

  @override
  String get confirmKick => 'Confirmar e remover';

  @override
  String get searchByEmail => 'Buscar usuário por e-mail';

  @override
  String get userNotFound => 'Nenhum usuário com esse e-mail.';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'Confiança $trust · advertências $strikes · banido: $banned';
  }

  @override
  String get ban => 'Banir';

  @override
  String get unban => 'Desbanir';

  @override
  String get adjustTrust => 'Ajustar confiança';

  @override
  String get notificationsInbox => 'Notificações';

  @override
  String get markAllRead => 'Marcar tudo como lido';

  @override
  String get noNotifications => 'Nenhuma notificação ainda';

  @override
  String get noNotificationsBody =>
      'Novidades do grupo, lembretes, avisos e alertas de feedback aparecem aqui.';

  @override
  String get notificationSettings => 'Notificações';

  @override
  String get notifPermissionOff =>
      'As notificações do TestPact estão desativadas';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get notifDaily => 'Lembretes diários';

  @override
  String get notifDailySub =>
      'Lembrete à noite se os apps de hoje ainda não foram abertos, e prazos de configuração';

  @override
  String get notifGroup => 'Novidades do grupo';

  @override
  String get notifGroupSub =>
      'Grupo formado, teste iniciado, novos membros, conclusão';

  @override
  String get notifFeedback => 'Feedback';

  @override
  String get notifFeedbackSub => 'Quando alguém deixa feedback no seu app';

  @override
  String get notifImportantNote =>
      'Avisos e remoções são sempre enviados, para você não perder nada que afete sua vaga.';

  @override
  String get noInternetTitle => 'Sem conexão com a internet';

  @override
  String get noInternetBody =>
      'Verifique seu Wi-Fi ou dados móveis. O TestPact reconecta automaticamente assim que você voltar a ficar online.';

  @override
  String get checkingConnection => 'Verificando…';

  @override
  String get backOnline => 'Online novamente';

  @override
  String get updateRequiredTitle => 'Atualização necessária';

  @override
  String get updateRequiredBody =>
      'Esta versão do TestPact não é mais suportada. Atualize para continuar testando com seu grupo.';

  @override
  String get updateAvailableTitle => 'Atualização disponível';

  @override
  String get updateAvailableBody =>
      'Uma nova versão do TestPact está pronta, com melhorias e correções.';

  @override
  String get updateNow => 'Atualizar agora';

  @override
  String get later => 'Mais tarde';

  @override
  String get updateDownloaded =>
      'Atualização baixada. Reinicie para concluir a instalação.';

  @override
  String get restart => 'Reiniciar';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get welcomeBack => 'Que bom ver você de novo!';

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get more => 'Mais';

  @override
  String get filterAll => 'Todos';

  @override
  String get statusTesting => 'Em teste';

  @override
  String get inQueueShort => 'Na fila';

  @override
  String get statusReady => 'Pronto';

  @override
  String get memberDone => 'Feito';

  @override
  String get memberTesting => 'Testando';

  @override
  String get memberPending => 'Pendente';

  @override
  String get todaysTasks => 'Tarefas de hoje';

  @override
  String tasksCompleted(int total, int done) {
    return '$total apps · $done/$total concluídos';
  }

  @override
  String groupMembersCount(int count) {
    return 'Membros do grupo ($count)';
  }

  @override
  String get recentActivity => 'Atividade recente';

  @override
  String badgesEarned(int earned, int total) {
    return '$earned de $total conquistados';
  }
}
