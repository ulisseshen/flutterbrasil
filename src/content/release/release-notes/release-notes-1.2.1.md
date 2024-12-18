---
ia-translate: true
title: Notas de versão do Flutter 1.2.1
short-title: Notas de versão 1.2.1
description: Notas de versão do Flutter 1.2.1.
---

Nossa prioridade número 1 desde o lançamento do Flutter v1.0 tem sido continuar a abordar questões de alta prioridade relatadas tanto pelos desenvolvedores do Flutter quanto pela própria equipe do Flutter. Isso inclui o envio de 672 pull requests no motor e framework do Flutter desde dezembro (temos estado ocupados!). Destacamos os novos recursos e mudanças que consideramos notáveis abaixo. Os maiores vieram de nossas tags Framework e Tool, mas também encontramos e corrigimos alguns problemas Severos também.

## Framework

Para complementar o suporte de animação do Flutter, esta versão adiciona mais algumas funções de easing padrão:

[#25788](https://github.com/flutter/flutter/pull/25788) Adicionar funções de easing de Robert Penner

Para integrar mais totalmente com o Android, esta versão adiciona suporte para [Android App Bundles][], um novo formato de empacotamento que ajuda na redução do tamanho do aplicativo e possibilita novos recursos como a entrega dinâmica para aplicativos Android:

[#24440](https://github.com/flutter/flutter/pull/24440) Adicionando suporte para android app bundle

Para integrar mais totalmente com o iOS, esta versão adiciona vários novos recursos e correções para iOS, incluindo um novo CupertinoTheme:

[#25183](https://github.com/flutter/flutter/pull/25183) Adicionar navigatorKey ao CupertinoTabView

[#25593](https://github.com/flutter/flutter/pull/25593) Deixar o CupertinoTabScaffold lidar também com as inserções do teclado

[#24876](https://github.com/flutter/flutter/pull/24876) Adiciona um efeito de fade in e out, arredonda cantos, corrige o offset e corrige a altura do cursor no iOS

[#23759](https://github.com/flutter/flutter/pull/23759) Adiciona CupertinoTheme

Além do suporte ao tema iOS Cupertino, esta versão continua a aprimorar também o tema Material:

[#24169](https://github.com/flutter/flutter/pull/24169) [Material] Elevação com tema em diálogos

[#25339](https://github.com/flutter/flutter/pull/25339) [Material] TextStyles com tema para AlertDialog

Para integrar mais totalmente com fatores de forma de desktop como tablets Android e ChromeOS, bem como suporte para web e sistema operacional de desktop, esta versão constrói mais suporte para teclado e mouse como dispositivos de entrada de primeira classe:

[#7758](https://github.com/flutter/engine/pull/7758) Implementação recomendada da implementação de combinação de caracteres

[#27853](https://github.com/flutter/flutter/pull/27853) Conectar eventos de caracteres e pontos de código não modificados ao tratamento de eventos de tecla bruta do Android

[#27620](https://github.com/flutter/flutter/pull/27620) Adicionar um gerador de código de tecla de teclado

[#27627](https://github.com/flutter/flutter/pull/27627) Adicionando suporte para eventos de tecla lógica e física

[#6961](https://github.com/flutter/engine/pull/6961) Adicionar suporte a eventos de hover ao engine

[#24830](https://github.com/flutter/flutter/pull/24830) Implementar suporte a hover para ponteiros de mouse

Como os widgets são a principal forma de interagir com os usuários no Flutter, esta versão continua a adicionar recursos e correções ao conjunto de widgets do Flutter com atenção especial ao [SliverAppBar](https://api.flutter.dev/flutter/material/SliverAppBar-class.html):

[#26021](https://github.com/flutter/flutter/pull/26021) Corrigir opacidade do título do SliverAppBar e testar todos os casos

[#26101](https://github.com/flutter/flutter/pull/26101) Corrigir um crash de encaixe flutuante do SliverAppBar

[#25091](https://github.com/flutter/flutter/pull/25091) Adicionar animações à documentação do SliverAppBar

[#24736](https://github.com/flutter/flutter/pull/24736) Fornecer mais alguns locais para o FAB

[#25585](https://github.com/flutter/flutter/pull/25585) Expor a API de fallback de fonte em TextStyle, Roll engine 54a3577c0139..215ca1560088

[#24457](https://github.com/flutter/flutter/pull/24457) Revisar gestos Android e iOS no Material TextField

[#24554](https://github.com/flutter/flutter/pull/24554) Adiciona detector e reconhecedor de gestos de pressão forçada

[#23919](https://github.com/flutter/flutter/pull/23919) Permitir a detecção de toques em TabBar

[#25384](https://github.com/flutter/flutter/pull/25384) Adiciona suporte para cursor flutuante

[#24976](https://github.com/flutter/flutter/pull/24976) Suporte a texto de dica multi-linha do TextField

[#26332](https://github.com/flutter/flutter/pull/26332) Strut: controle afinado sobre as alturas mínimas de linha de texto, permite forçar a altura da linha para ser uma altura especificada

E, finalmente, à medida que o uso do Flutter continua a crescer em todo o mundo, continuamos a aprimorar o suporte para localizações em vários idiomas, incluindo ucraniano, polonês, suaíli e galego nesta versão.

[#25394](https://github.com/flutter/flutter/pull/25394) Atualizar localizações

[#27506](https://github.com/flutter/flutter/pull/27506) Adicionado suporte para suaíli (material_sw.arb)

[#27352](https://github.com/flutter/flutter/pull/24876) Incluindo a língua galega

## Plug-Ins

Assim como no framework e no próprio engine, continuamos a focar na qualidade dos plugins também:

[flutter/engine#7317](https://github.com/flutter/engine/pull/7317) Corrigir GrContext obsoleto para visualizações de plataforma iOS

[flutter/engine#7558](https://github.com/flutter/engine/pull/7558) Corrigir eventos de toque perdidos para visualizações de plataforma iOS

[flutter/plugins#1157](https://github.com/flutter/plugins/pull/1157) [google_maps_flutter] Corrigir problema de posicionamento da câmera no iOS

[flutter/plugins#1176](https://github.com/flutter/plugins/pull/1176) [firebase_auth] Corrigir autenticação de telefone Firebase no Android

[flutter/plugins#1037](https://github.com/flutter/plugins/pull/1037) [camera] Salvar orientação da foto no iOS

[flutter/plugins#1129](https://github.com/flutter/plugins/pull/1129) [android_alarm_manager] Corrigir problemas de "inicialização em segundo plano não permitida", enfileirar eventos que são recebidos muito cedo

[flutter/plugins#1051](https://github.com/flutter/plugins/pull/1051) [image_picker] Corrigir crash no iOS quando o seletor é tocado várias vezes

O plugin webview_flutter obteve um canal de comunicação entre Dart e JavaScript:

[flutter/plugins#1116](https://github.com/flutter/plugins/pull/1116) Adicionar canais JavaScript do WebView (lado Dart)

[flutter/plugins#1130](https://github.com/flutter/plugins/pull/1130) Implementação Android de canais JavaScript do WebView

[flutter/plugins#1139](https://github.com/flutter/plugins/pull/1139) Canais JavaScript do WebView - implementação iOS

[lutter/plugins1021](https://github.com/flutter/plugins/pull/1021) avaliação javascript ios/android

Fizemos progresso na construção do plugin de compra no aplicativo (que ainda está em pré-lançamento):

[#1057](https://github.com/flutter/plugins/pull/1057) [IAP] Verificar se o processador de pagamento está disponível

[#1084](https://github.com/flutter/plugins/pull/1084) [IAP] Buscar SkuDetails do Google Play

[#1068](https://github.com/flutter/plugins/pull/1068) Lista de produtos IAP ios

[#1172](https://github.com/flutter/plugins/pull/1172) [In_app_purchase] adicionar tradutores objc de pagamento

## Dart

O lançamento contém um novo SDK Dart que fornece suporte para uma nova sintaxe de literais de conjunto e aumenta o desempenho AOT em 10-20% reduzindo a sobrecarga de chamar construtores ou métodos estáticos:

[#37](https://github.com/dart-lang/language/issues/37) Set Literal

[#33274](https://github.com/dart-lang/sdk/issues/33274) Adicionar suporte para instruções "nuas": pool de objetos global, chamadas estáticas relativas a pc, chamadas indiretas mais rápidas, potencial compartilhamento de código

## Tool

Adicionamos várias novas ferramentas e novos recursos às ferramentas existentes nesta versão.

Esta versão continua a melhorar as mensagens de erro em várias ferramentas:

[#26107](https://github.com/flutter/flutter/pull/26107) Melhores mensagens de erro para a flag --dynamic da ferramenta flutter

[#26084](https://github.com/flutter/flutter/pull/26084) Melhorar a mensagem ao salvar dados de treinamento de compilação

[#25863](https://github.com/flutter/flutter/pull/25863) Mensagens mais amigáveis ao usar patch dinâmico

Esta versão também adiciona suporte para Java 1.8:

[#25470](https://github.com/flutter/flutter/pull/25470) Suporte Java 1.8

## Severo

Nesta versão, encontramos e corrigimos alguns problemas graves da versão anterior, incluindo dois crashes e uma degradação de desempenho.

Crashes

[#7314](https://github.com/flutter/flutter/issues/7314) Crash do Flutter na inicialização (metabug)

Desempenho

[#25381](https://github.com/flutter/flutter/pull/25381) Adicionar teste de desempenho de opacidade de exclusão ao laboratório de dispositivos

## Mudanças significativas

Em um esforço para continuar a melhorar o Flutter desde a versão 1.0 para atender às necessidades dos clientes, tivemos que fazer algumas mudanças significativas:

### [#8769](https://github.com/flutter/flutter/pull/8769) Renomear ListItem para ListTile, documentar a geometria de altura fixa do ListTile

Muitos desenvolvedores ficaram confusos com o fato de que o ListItem tinha altura fixa. Renomeamos para ListTile, para indicar que (como outros tiles) sua altura é fixa, e a documentação foi atualizada para dizer claramente isso sobre o ListTile. Você precisará renomear as instâncias da classe ListItem para ListTile em seu código.

### [#7518](https://github.com/flutter/engine/pull/7518) Atualizar o caminho padrão de flutter_assets para incorporação no iOS

Os assets do Flutter para aplicativos iOS agora são encontrados em Frameworks/App.framework/flutter_assets em vez de flutter_assets. A ferramenta de linha de comando do flutter deve cuidar dessa diferença, mas se você estiver escrevendo um aplicativo AddToApp para iOS que compartilha assets com o Flutter, você precisará estar ciente dessa mudança.

### [#27697](https://github.com/flutter/flutter/pull/27697) Correção do Cursor do Cupertino TextField

O padrão de cursorColor do CupertinoTextField agora corresponde ao tema do aplicativo. Se isso for indesejável, os desenvolvedores podem usar a propriedade cupertinoOverrideTheme de ThemeData para fornecer uma substituição específica do Cupertino usando um objeto CupertinoThemeData, por exemplo:

```dart
Widget build(BuildContext context) {
  // Definir dados do tema para substituição no construtor de CupertinoThemeData
  Theme.of(context).cupertinoOverrideTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF42A5F5)
  );
  return Text(
    'Exemplo',
    style: Theme.of(context).textTheme.title,
  );
}
```

### [#23424](https://github.com/flutter/flutter/pull/23424) Ensinar comportamentos de início de arrasto ao DragGestureRecognizer

Por padrão, o callback onStart de um detector de gestos de arrastar será chamado com a localização de onde um gesto de arrastar é detectado (ou seja, após arrastar um certo número de pixels) em vez de na localização de toque para baixo. Para usar a funcionalidade antiga com um determinado reconhecedor de gestos de arrastar, a variável dragStartBehavior do reconhecedor deve ser definida como DragStartBehavior.down, por exemplo, inclua a linha em negrito abaixo ao declarar seu GestureDecorator:

```dart
GestureDectector(
  dragStartBehavior: DragStartBehavior.down,
  onVerticalDragDown: myDragDown
  onVerticalDragEnd: myDragEnd,
  onVerticalDragStart: myDragStart,
  onVerticalDragUpdate: myDragUpdate,
  onVerticalDragCancel: myDragCancel,
  onHorizontalDragDown: myDragDown
  onHorizontalDragEnd: myDragEnd,
  onHorizontalDragStart: myDragStart,
  onHorizontalDragUpdate: myDragUpdate,
  onHorizontalDragCancel: myDragCancel,
// Outros campos…
```

### [#26238](https://github.com/flutter/flutter/pull/26238) Remover o TwoLevelList há muito descontinuado

Removeu o widget TwoLevelList há muito descontinuado; use ListView com ExpansionTile em vez disso. Veja [este exemplo](https://github.com/flutter/flutter/blob/v1.2.1/examples/catalog/lib/expansion_tile_sample.dart) para um exemplo que usa ExpansionTile.

###[#7442](https://github.com/flutter/engine/pull/7442) Mover a rasterização Picture.toImage para a thread da GPU

Picture.toImage agora retorna um `Future<Image>` em vez disso. Isso permite que a rasterização da imagem ocorra na thread da GPU, melhorando o desempenho em muitos casos e garantindo resultados corretos. No mínimo, você precisará declarar os métodos que invocam instâncias de Picture como async e usar await, assim:

```dart
void usePictureImage(Picture p) async {
  var image = await p.toImage();
  // Faça algo com os pixels na imagem….
}
```

No entanto, seu aplicativo pode estar executando outras ações assíncronas e você deve considerar como deseja lidar com o processamento de imagens sob essa perspectiva. Para mais informações sobre o suporte do Dart para programação assíncrona e a classe Future, consulte [https://www.dartlang.org/tutorials/language/futures.](https://www.dartlang.org/tutorials/language/futures)

### [#7567](https://github.com/flutter/engine/pull/7567) Renomear FlutterResult em embedder.h

Na API Embedder, o tipo FlutterResult foi renomeado para FlutterEngineResult para explicar melhor seu propósito. Você precisará renomear todas as instâncias do primeiro para o último.

### [#7414](https://github.com/flutter/engine/pull/7414) Implementação do Strut

Renomear dart:ui ParagraphStyle.lineHeight para ParagraphStyle.height. A propriedade ParagraphStyle.lineHeight anteriormente não fazia nada e foi renomeada para permanecer consistente com TextStyle.height. Você precisará renomear todas as instâncias do primeiro para o último.

## Regressões

Logo após nosso lançamento 1.2, encontramos duas regressões:

* [#28640](https://github.com/flutter/flutter/issues/28640) NoSuchMethodError: android.view.MotionEvent.isFromSource

[flutter/flutter#24830](https://github.com/flutter/flutter/pull/24830) ("Implementar suporte a hover para ponteiros de mouse.") está usando uma API Android que não existe em dispositivos mais antigos. Isso pode causar um crash no Android 4.1 (Jellybean) e 4.1 (Jellybean MR1).

* [#28484](https://github.com/flutter/flutter/issues/28484) Renderização de widget estranha desde a atualização do Flutter

Isso pode causar problemas de renderização ao carregar certas imagens em dispositivos iOS físicos.

Para obter uma correção para essas regressões, assim que o beta 1.3 for lançado em março, você pode mudar para o canal beta e executar um "flutter upgrade" na linha de comando. No momento da escrita deste documento, isso o atualizará para pelo menos a versão 1.3.8, que inclui [flutter/engine#8006](https://github.com/flutter/engine/pull/8006) ("Proteger contra o uso da API Android não definida nos níveis de API 16 e 17") e o commit Skia que corrige o problema de renderização. Para o problema de crash, as duas versões afetadas do Android têm mais de dez anos e representam no máximo 2,5% dos usuários do Android, poucos dos quais provavelmente instalarão novos aplicativos Android, sejam eles Flutter ou não. Mesmo assim, odiamos deixar regressões conhecidas em uma versão estável, mas após muito debate interno, decidimos que era a melhor forma de proceder para os desenvolvedores Flutter e seus usuários de aplicativos.

Nossa correção ideal para qualquer problema sério é criar uma versão "hotfix", pegando uma versão existente e "cherry picking" as correções que gostaríamos de aplicar. A capacidade de fazer hotfix de uma versão estável existente é algo que implementamos para 1.2, mas ainda não atingimos a qualidade de produção. A consequência disso é que, se tivéssemos criado uma nova versão estável "1.2.1-a" com a correção para as regressões, teríamos deixado todos os nossos usuários presos naquela branch; a atualização para branches futuras exigiria que os usuários removessem e reinstalassem o Flutter do zero, o que era claramente inaceitável. Estamos trabalhando muito para validar nossa capacidade de fazer hotfix no 1.3+ para que não tenhamos esse problema novamente.

Outra opção teria sido trazer o 1.3 para uma versão estável. Nossa política atual é lançar uma nova versão estável apenas uma vez por trimestre para reduzir a rotatividade para os desenvolvedores Flutter. No momento da escrita deste documento, a versão pré-estável 1.3 contém 104 commits de framework (e ainda mais commits de engine, Dart e Skia), qualquer um dos quais representa um risco para como seus aplicativos atuais estão sendo executados. Para reduzir esse risco, deixamos as versões em beta por um mês, deixamos os desenvolvedores testá-las e só promovemos as versões para o canal estável quando estamos confiantes nelas. É assim que mantemos a estabilidade nas versões trimestrais.

Nosso próximo lançamento estável está atualmente planejado para maio de 2019, que é o primeiro lançamento estável que incluirá a correção para essa regressão. Se você for afetado por [#28640](https://github.com/flutter/flutter/issues/28640) e achar que a solução alternativa para usar a versão 1.3 pré-lançamento não é uma opção para você, informe-nos em [flutter/flutter#29235](https://github.com/flutter/flutter/issues/29235). Da mesma forma, se você for afetado por [#28484](https://github.com/flutter/flutter/issues/28484), informe-nos em [flutter/flutter/#29360](https://github.com/flutter/flutter/issues/29360). Se descobrirmos que há muito feedback da comunidade Flutter de que tomamos a decisão errada aqui, usaremos seu feedback para reavaliar. Afinal, o Flutter é um esforço da comunidade e suas opiniões são importantes.

## Lançamentos de ferramentas

Além das mudanças no framework do Flutter na versão 1.2, fizemos vários lançamentos de ferramentas no mesmo período, sobre os quais você pode ler aqui:

*   Suporte Dart & Flutter para Visual Studio Code: versões [2.21](https://dartcode.org/releases/v2-21/), [2.22](https://dartcode.org/releases/v2-22/), [2.23](https://dartcode.org/releases/v2-23/) e [2.24](https://dartcode.org/releases/v2-24/).
*   Suporte Dart & Flutter para IntelliJ & Android Studio: lançamentos de [janeiro de 2019](https://groups.google.com/forum/#!searchin/flutter-dev/nilay%7Csort:date/flutter-dev/VCfGRhDsHgs/JcYKxkxHBAAJ) e [fevereiro de 2019](https://groups.google.com/forum/#!searchin/flutter-dev/nilay%7Csort:date/flutter-dev/VCfGRhDsHgs/JcYKxkxHBAAJ).
*   Dart DevTools [lançamento alfa](/tools/devtools).

## Lista completa de problemas

Você pode ver [a lista completa de PRs enviados nesta versão](/release/release-notes/changelogs/changelog-1.2.1).

[Android App Bundles]: https://developer.android.com/guide/app-bundle/
