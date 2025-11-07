---
ia-translate: true
title: Acessibilidade
description: Informações sobre o suporte de acessibilidade no Flutter.
---

Garantir que os apps sejam acessíveis a uma ampla gama de usuários é uma parte essencial da construção de um app de alta qualidade. Aplicações mal projetadas criam barreiras para pessoas de todas as idades. A [Convenção da ONU sobre os Direitos das Pessoas com Deficiências][CRPD] declara o imperativo moral e legal para garantir acesso universal a sistemas de informação; países ao redor do mundo aplicam a acessibilidade como um requisito; e empresas reconhecem as vantagens comerciais de maximizar o acesso aos seus serviços.

Recomendamos fortemente que você inclua uma lista de verificação de acessibilidade como um critério-chave antes de lançar seu app. O Flutter está comprometido em apoiar desenvolvedores na criação de apps mais acessíveis, e inclui suporte de acessibilidade de primeira classe no framework, além daquele fornecido pelo sistema operacional subjacente, incluindo:

[**Fontes grandes**][]
: Renderizar widgets de texto com tamanhos de fonte especificados pelo usuário

[**Leitores de tela**][]
: Comunicar feedback falado sobre o conteúdo da UI

[**Contraste suficiente**][]
: Renderizar widgets com cores que têm contraste suficiente

Detalhes desses recursos são discutidos abaixo.

## Inspecionando o suporte de acessibilidade

Além de testar esses tópicos específicos, recomendamos usar scanners de acessibilidade automáticos:

* Para Android:
    1. Instale o [Accessibility Scanner][] para Android
    1. Ative o Accessibility Scanner em
       **Android Settings > Accessibility >
       Accessibility Scanner > On**
    1. Navegue até o ícone de botão 'checkbox' do Accessibility Scanner
       para iniciar uma varredura

* Para iOS:
    1. Abra a pasta `iOS` do seu app Flutter no Xcode
    1. Selecione um Simulator como o destino e clique no botão **Run**
    1. No Xcode, selecione
       **Xcode > Open Developer Tools > Accessibility Inspector**
    1. No Accessibility Inspector,
       selecione **Inspection > Enable Point to Inspect**,
       e então selecione os vários elementos da interface do usuário no
       app Flutter em execução para inspecionar seus atributos de acessibilidade
    1. No Accessibility Inspector,
       selecione **Audit** na barra de ferramentas, e então
       selecione **Run Audit** para obter um relatório de possíveis problemas

* Para web:
    1. Abra o Chrome DevTools (ou ferramentas similares em outros navegadores)
    2. Inspecione a árvore HTML contendo os atributos ARIA gerados pelo Flutter.
    3. No Chrome, a aba "Elements" tem uma sub-aba "Accessibility"
       que pode ser usada para inspecionar os dados exportados para a árvore de semântica

## Fontes grandes

Tanto o Android quanto o iOS contêm configurações do sistema para configurar os tamanhos de fonte desejados usados pelos apps. Os widgets de texto do Flutter respeitam essa configuração do sistema operacional ao determinar os tamanhos de fonte.

Os tamanhos de fonte são calculados automaticamente pelo Flutter com base na configuração do sistema operacional. No entanto, como desenvolvedor, você deve garantir que seu layout tenha espaço suficiente para renderizar todo o seu conteúdo quando os tamanhos de fonte são aumentados. Por exemplo, você pode testar todas as partes do seu app em um dispositivo de tela pequena configurado para usar a maior configuração de fonte.

### Exemplo

As duas capturas de tela a seguir mostram o template padrão de app Flutter renderizado com a configuração de fonte padrão do iOS, e com a maior configuração de fonte selecionada nas configurações de acessibilidade do iOS.

<div class="row">
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-regular-fonts.png", caption:"Default font setting", img-class:"border" %}
  </div>
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-large-fonts.png", caption:"Largest accessibility font setting", img-class:"border" %}
  </div>
</div>

## Leitores de tela

Para mobile, leitores de tela ([TalkBack][], [VoiceOver][]) permitem que usuários com deficiência visual obtenham feedback falado sobre o conteúdo da tela e interajam com a UI usando gestos no mobile e atalhos de teclado no desktop. Ative o VoiceOver ou TalkBack no seu dispositivo móvel e navegue pelo seu app.

**Para ativar o leitor de tela no seu dispositivo, complete os seguintes passos:**

{% tabs %}
{% tab "TalkBack on Android" %}

1. No seu dispositivo, abra **Settings**.
2. Selecione **Accessibility** e então **TalkBack**.
3. Ative ou desative 'Use TalkBack'.
4. Selecione Ok.

Para aprender como encontrar e personalizar os recursos de acessibilidade do Android, veja o seguinte vídeo.

{% ytEmbed 'FQyj_XTl01w', 'Customize Pixel and Android accessibility features' %}

{% endtab %}
{% tab "VoiceOver on iPhone" %}

1. No seu dispositivo, abra **Settings > Accessibility > VoiceOver**
2. Ative ou desative a configuração VoiceOver

Para aprender como encontrar e personalizar os recursos de acessibilidade do iOS, veja o seguinte vídeo.

{% ytEmbed 'ROIe49kXOc8', 'How to navigate your iPhone or iPad with VoiceOver' %}

{% endtab %}
{% tab "Browsers" %}

Para web, os seguintes leitores de tela são atualmente suportados:

Mobile browsers:

* iOS - VoiceOver
* Android - TalkBack

Desktop browsers:

* macOS - VoiceOver
* Windows - JAWs & NVDA

Usuários de leitores de tela na web devem alternar o botão "Enable accessibility" para construir a árvore de semântica. Os usuários podem pular esta etapa se você habilitar programaticamente a acessibilidade automaticamente para seu app usando esta API:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
  SemanticsBinding.instance.ensureSemantics();
}
```

{% endtab %}
{% tab "Desktop" %}

O Windows vem com um leitor de tela chamado Narrator, mas alguns desenvolvedores recomendam usar o leitor de tela NVDA, mais popular. Para aprender sobre usar o NVDA para testar apps Windows, confira [Screen Readers 101 For Front-End Developers (Windows)][nvda].

[nvda]: https://get-evinced.com/blog/screen-readers-101-for-front-end-developers-windows

Em um Mac, você pode usar a versão desktop do VoiceOver, que está incluída no macOS.

{% ytEmbed '5R-6WvAihms', 'Screen reader basics: VoiceOver' %}

No Linux, um leitor de tela popular é chamado Orca. Ele vem pré-instalado com algumas distribuições e está disponível em repositórios de pacotes como `apt`. Para aprender sobre usar o Orca, confira [Getting started with Orca screen reader on Gnome desktop][orca].

[orca]: https://www.a11yproject.com/posts/getting-started-with-orca

{% endtab %}
{% endtabs %}

<br/>

Confira o seguinte [vídeo demo][] para ver Victor Tsaran, usando o VoiceOver com o [Flutter Gallery][] web app agora arquivado.

Os widgets padrão do Flutter geram uma árvore de acessibilidade automaticamente. No entanto, se seu app precisa de algo diferente, pode ser personalizado usando o [widget `Semantics`][].

Quando há texto em seu app que deve ser pronunciado com uma voz específica, informe ao leitor de tela qual voz usar chamando [`TextSpan.locale`][]. Observe que `MaterialApp.locale` e `Localizations.override` não afetam qual voz o leitor de tela usa. Geralmente, o leitor de tela usa a voz do sistema, exceto onde você a define explicitamente com `TextSpan.locale`.

[Flutter Gallery]: {{site.gallery-archive}}
[`TextSpan.locale`]: {{site.api}}/flutter/painting/TextSpan/locale.html

## Contraste suficiente

O contraste de cores suficiente torna o texto e as imagens mais fáceis de ler. Além de beneficiar usuários com várias deficiências visuais, o contraste de cores suficiente ajuda todos os usuários ao visualizar uma interface em dispositivos em condições extremas de iluminação, como quando exposto à luz solar direta ou em uma tela com baixo brilho.

A [W3C recomenda][]:

* Pelo menos 4.5:1 para texto pequeno (abaixo de 18 pontos regular ou 14 pontos negrito)
* Pelo menos 3.0:1 para texto grande (18 pontos e acima regular ou 14 pontos e acima negrito)

## Construindo com acessibilidade em mente

Garantir que seu app possa ser usado por todos significa construir acessibilidade nele desde o início. Para alguns apps, isso é mais fácil dizer do que fazer. No vídeo abaixo, dois de nossos engenheiros levam um app mobile de um estado de acessibilidade terrível para um que aproveita os widgets integrados do Flutter para oferecer uma experiência dramaticamente mais acessível.

{% ytEmbed 'bWbBgbmAdQs', 'Building Flutter apps with accessibility in mind' %}

## Testando acessibilidade no mobile

Teste seu app usando a [Accessibility Guideline API][] do Flutter. Esta API verifica se a UI do seu app atende às recomendações de acessibilidade do Flutter. Isso cobre recomendações para contraste de texto, tamanho de destino e rótulos de destino.

O seguinte trecho mostra como usar a Guideline API em um widget de exemplo chamado `AccessibleApp`:

<?code-excerpt "accessibility/test/a11y_test.dart"?>
```dart title="test/a11y_test.dart"
import 'package:flutter_test/flutter_test.dart';
import 'package:your_accessible_app/main.dart';

void main() {
  testWidgets('Follows a11y guidelines', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(const AccessibleApp());

    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
```

Para experimentar esses testes, execute-os no app que você cria no codelab [Write your first Flutter app](/get-started/codelab). Cada botão na tela principal desse app serve como um destino tocável com texto renderizado em uma fonte de 18 pontos.

Você pode adicionar testes da Guideline API ao lado de outros [testes de widget][], ou em um arquivo separado, como `test/a11y_test.dart` neste exemplo.

[Accessibility Guideline API]: {{site.api}}/flutter/flutter_test/AccessibilityGuideline-class.html
[testes de widget]: /testing/overview#widget-tests

## Testando acessibilidade na web

Você pode depurar a acessibilidade visualizando os nós semânticos criados para seu app web usando o seguinte flag de linha de comando nos modos profile e release:

```console
flutter run -d chrome --profile --dart-define=FLUTTER_WEB_DEBUG_SHOW_SEMANTICS=true
```

Com o flag ativado, os nós semânticos aparecem em cima dos widgets; você pode verificar que os elementos semânticos estão posicionados onde deveriam estar. Se os nós semânticos estiverem posicionados incorretamente, por favor [registre um relatório de bug][].

## Lista de verificação de lançamento de acessibilidade

Aqui está uma lista não exaustiva de coisas a considerar ao preparar seu app para lançamento.

* **Interações ativas**. Certifique-se de que todas as interações ativas fazem algo. Qualquer botão que possa ser pressionado deve fazer algo quando pressionado. Por exemplo, se você tem um callback no-op para um evento `onPressed`, altere-o para mostrar um `SnackBar` na tela explicando qual controle você acabou de pressionar.
* **Teste de leitor de tela**. O leitor de tela deve ser capaz de descrever todos os controles na página quando você toca neles, e as descrições devem ser inteligíveis. Teste seu app com [TalkBack][] (Android) e [VoiceOver][] (iOS).
* **Razões de contraste**. Encorajamos você a ter uma razão de contraste de pelo menos 4.5:1 entre controles ou texto e o fundo, com exceção de componentes desabilitados. As imagens também devem ser verificadas quanto ao contraste suficiente.
* **Mudança de contexto**. Nada deve mudar o contexto do usuário automaticamente enquanto digita informações. Geralmente, os widgets devem evitar mudar o contexto do usuário sem algum tipo de ação de confirmação.
* **Destinos tocáveis**. Todos os destinos tocáveis devem ter pelo menos 48x48 pixels.
* **Erros**. Ações importantes devem poder ser desfeitas. Em campos que mostram erros, sugira uma correção se possível.
* **Teste de deficiência de visão de cores**. Os controles devem ser utilizáveis e legíveis em modos de daltonismo e escala de cinza.
* **Fatores de escala**. A UI deve permanecer legível e utilizável em fatores de escala muito grandes para tamanho de texto e escala de exibição.

## Saiba mais

Para saber mais sobre Flutter e acessibilidade, confira os seguintes artigos escritos por membros da comunidade:

* [A deep dive into Flutter's accessibility widgets][]
* [Semantics in Flutter][]
* [Flutter: Crafting a great experience for screen readers][]

[CRPD]: https://www.un.org/development/desa/disabilities/convention-on-the-rights-of-persons-with-disabilities/article-9-accessibility.html
[A deep dive into Flutter's accessibility widgets]: {{site.medium}}/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc
[Flutter: Crafting a great experience for screen readers]: https://blog.gskinner.com/archives/2022/09/flutter-crafting-a-great-experience-for-screen-readers.html
[Accessibility Scanner]: https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en
[**Fontes grandes**]: #large-fonts
[**Leitores de tela**]: #screen-readers
[Semantics in Flutter]: https://www.didierboelens.com/2018/07/semantics/
[widget `Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[**Contraste suficiente**]: #sufficient-contrast
[TalkBack]: https://support.google.com/accessibility/android/answer/6283677?hl=en
[W3C recomenda]: https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html
[VoiceOver]: https://www.apple.com/lae/accessibility/iphone/vision/
[vídeo demo]: {{site.yt.watch}}?v=A6Sx0lBP8PI
[registre um relatório de bug]: https://goo.gle/flutter_web_issue
