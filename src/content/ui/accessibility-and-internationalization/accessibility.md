---
ia-translate: true
title: Acessibilidade
description: Informações sobre o suporte de acessibilidade do Flutter.
---

Garantir que os aplicativos sejam acessíveis a uma ampla gama de usuários é uma
parte essencial da criação de um aplicativo de alta qualidade. Aplicativos mal
projetados criam barreiras para pessoas de todas as idades. A [Convenção da ONU
sobre os Direitos das Pessoas com Deficiência][CRPD] afirma o imperativo moral
e legal de garantir o acesso universal aos sistemas de informação; países ao
redor do mundo impõem a acessibilidade como um requisito; e as empresas
reconhecem as vantagens comerciais de maximizar o acesso aos seus serviços.

Incentivamos fortemente que você inclua uma lista de verificação de acessibilidade
como um critério fundamental antes de lançar seu aplicativo. O Flutter está
comprometido em apoiar os desenvolvedores na criação de aplicativos mais
acessíveis e inclui suporte de framework de primeira classe para acessibilidade,
além do fornecido pelo sistema operacional subjacente, incluindo:

[**Fontes grandes**][]
: Renderizar widgets de texto com tamanhos de fonte especificados pelo
  usuário

[**Leitores de tela**][]
: Comunicar feedback falado sobre o conteúdo da UI

[**Contraste suficiente**][]
: Renderizar widgets com cores que tenham contraste suficiente

Os detalhes desses recursos são discutidos abaixo.

## Inspecionando o suporte de acessibilidade

Além de testar esses tópicos específicos, recomendamos o uso de scanners de
acessibilidade automatizados:

* Para Android:
    1. Instale o [Accessibility Scanner][] para Android
    1. Ative o Accessibility Scanner em
       **Configurações do Android > Acessibilidade >
       Accessibility Scanner > Ativado**
    1. Navegue até o botão de ícone 'checkbox' do Accessibility Scanner
       para iniciar uma verificação

* Para iOS:
    1. Abra a pasta `iOS` do seu aplicativo Flutter no Xcode
    1. Selecione um Simulador como destino e clique no botão **Executar**
    1. No Xcode, selecione
       **Xcode > Open Developer Tools > Accessibility Inspector**
    1. No Accessibility Inspector,
       selecione **Inspection > Enable Point to Inspect**,
       e então selecione os vários elementos da interface do usuário no
       aplicativo Flutter em execução para inspecionar seus atributos de
       acessibilidade
    1. No Accessibility Inspector,
       selecione **Audit** na barra de ferramentas e selecione
       **Run Audit** para obter um relatório de possíveis problemas

* Para web:
    1. Abra o Chrome DevTools (ou ferramentas semelhantes em outros
       navegadores)
    2. Inspecione a árvore HTML que contém os atributos ARIA gerados pelo
       Flutter.
    3. No Chrome, a aba "Elements" possui uma sub-aba "Accessibility"
       que pode ser usada para inspecionar os dados exportados para a árvore
       semântica

## Fontes grandes

Tanto o Android quanto o iOS contêm configurações de sistema para configurar os
tamanhos de fonte desejados usados pelos aplicativos. Os widgets de texto do
Flutter respeitam essa configuração do SO ao determinar os tamanhos da fonte.

Os tamanhos da fonte são calculados automaticamente pelo Flutter com base na
configuração do SO. No entanto, como desenvolvedor, você deve se certificar de
que seu layout tenha espaço suficiente para renderizar todo o seu conteúdo
quando os tamanhos da fonte forem aumentados. Por exemplo, você pode testar
todas as partes do seu aplicativo em um dispositivo de tela pequena configurado
para usar a maior configuração de fonte.

### Exemplo

As duas capturas de tela a seguir mostram o modelo de aplicativo Flutter
padrão renderizado com a configuração de fonte iOS padrão e com a maior
configuração de fonte selecionada nas configurações de acessibilidade do iOS.

<div class="row">
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-regular-fonts.png", caption:"Configuração de fonte padrão", img-class:"border" %}
  </div>
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-large-fonts.png", caption:"Maior configuração de fonte de acessibilidade", img-class:"border" %}
  </div>
</div>

## Leitores de tela

Para dispositivos móveis, os leitores de tela ([TalkBack][], [VoiceOver][])
permitem que usuários com deficiência visual obtenham feedback falado sobre o
conteúdo da tela e interajam com a UI usando gestos no celular e atalhos de
teclado no desktop. Ative o VoiceOver ou TalkBack em seu dispositivo móvel e
navegue pelo seu aplicativo.

**Para ativar o leitor de tela em seu dispositivo, conclua as seguintes etapas:**

{% tabs %}
{% tab "TalkBack no Android" %}

1. No seu dispositivo, abra **Configurações**.
2. Selecione **Acessibilidade** e depois **TalkBack**.
3. Ative ou desative "Usar TalkBack".
4. Selecione Ok.

Para saber como encontrar e personalizar os recursos de acessibilidade do
Android, veja o vídeo a seguir.

{% ytEmbed 'FQyj_XTl01w', 'Personalizar os recursos de acessibilidade do Pixel e do Android' %}

{% endtab %}
{% tab "VoiceOver no iPhone" %}

1. No seu dispositivo, abra **Configurações > Acessibilidade > VoiceOver**
2. Ative ou desative a configuração VoiceOver

Para saber como encontrar e personalizar os recursos de acessibilidade do iOS,
veja o vídeo a seguir.

{% ytEmbed 'ROIe49kXOc8', 'Como navegar em seu iPhone ou iPad com VoiceOver' %}

{% endtab %}
{% tab "Navegadores" %}

Para web, os seguintes leitores de tela são suportados atualmente:

Navegadores móveis:

* iOS - VoiceOver
* Android - TalkBack

Navegadores de desktop:

* macOS - VoiceOver
* Windows - JAWs & NVDA

Os usuários de leitores de tela na web devem alternar o botão "Ativar
acessibilidade" para construir a árvore semântica. Os usuários podem pular
esta etapa se você habilitar automaticamente a acessibilidade para seu
aplicativo usando esta API:

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

O Windows vem com um leitor de tela chamado Narrador, mas alguns
desenvolvedores recomendam usar o leitor de tela NVDA, mais popular. Para
saber mais sobre como usar o NVDA para testar aplicativos do Windows,
confira [Leitores de tela 101 para desenvolvedores front-end (Windows)][nvda].

[nvda]: https://get-evinced.com/blog/screen-readers-101-for-front-end-developers-windows

Em um Mac, você pode usar a versão desktop do VoiceOver, que está incluída no
macOS.

{% ytEmbed '5R-6WvAihms', 'Noções básicas sobre leitor de tela: VoiceOver' %}

No Linux, um leitor de tela popular é chamado Orca. Ele vem pré-instalado em
algumas distribuições e está disponível em repositórios de pacotes como `apt`.
Para saber mais sobre como usar o Orca, confira [Começando com o leitor de tela
Orca no desktop Gnome][orca].

[orca]: https://www.a11yproject.com/posts/getting-started-with-orca

{% endtab %}
{% endtabs %}

<br/>

Confira a seguinte [demonstração em vídeo][] para ver Victor Tsaran, usando o
VoiceOver com o agora arquivado aplicativo web [Flutter Gallery][].

Os widgets padrão do Flutter geram uma árvore de acessibilidade
automaticamente. No entanto, se o seu aplicativo precisar de algo diferente,
ele pode ser personalizado usando o widget [`Semantics`][].

Quando houver texto em seu aplicativo que deve ser verbalizado com uma voz
específica, informe ao leitor de tela qual voz usar chamando
[`TextSpan.locale`][]. Observe que `MaterialApp.locale` e
`Localizations.override` não afetam qual voz o leitor de tela usa.
Geralmente, o leitor de tela usa a voz do sistema, exceto onde você a define
explicitamente com `TextSpan.locale`.

[Flutter Gallery]: {{site.gallery-archive}}
[`TextSpan.locale`]: {{site.api}}/flutter/painting/TextSpan/locale.html

## Contraste suficiente

Contraste de cor suficiente torna o texto e as imagens mais fáceis de ler. Além
de beneficiar usuários com várias deficiências visuais, contraste de cor
suficiente ajuda todos os usuários ao visualizar uma interface em dispositivos
em condições extremas de iluminação, como quando expostos à luz solar direta
ou em uma tela com brilho baixo.

O [W3C recomenda][]:

* Pelo menos 4,5:1 para texto pequeno (abaixo de 18 pontos regular ou 14
  pontos em negrito)
* Pelo menos 3,0:1 para texto grande (18 pontos e acima regular ou 14
  pontos e acima em negrito)

## Construindo com acessibilidade em mente

Garantir que seu aplicativo possa ser usado por todos significa incorporar a
acessibilidade desde o início. Para alguns aplicativos, isso é mais fácil falar
do que fazer. No vídeo abaixo, dois de nossos engenheiros levam um aplicativo
móvel de um estado terrível de acessibilidade para um que aproveita os widgets
integrados do Flutter para oferecer uma experiência dramaticamente mais
acessível.

{% ytEmbed 'bWbBgbmAdQs', 'Criando aplicativos Flutter com acessibilidade em mente' %}

## Testando a acessibilidade no celular

Teste seu aplicativo usando a [API de Diretrizes de Acessibilidade][]. Esta
API verifica se a UI do seu aplicativo atende às recomendações de
acessibilidade do Flutter. Isso abrange recomendações para contraste de texto,
tamanho do alvo e rótulos do alvo.

O trecho a seguir mostra como usar a API de Diretrizes em um widget de amostra
nomeado `AccessibleApp`:

<?code-excerpt "accessibility/test/a11y_test.dart"?>
```dart title="test/a11y_test.dart"
import 'package:flutter_test/flutter_test.dart';
import 'package:your_accessible_app/main.dart';

void main() {
  testWidgets('Segue as diretrizes de a11y', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(const AccessibleApp());

    // Verifica se os nós clicáveis têm um tamanho mínimo de 48 por 48 pixels
    // para Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Verifica se os nós clicáveis têm um tamanho mínimo de 44 por 44 pixels
    // para iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    // Verifica se os alvos de toque com uma ação de toque ou pressão longa
    // estão rotulados.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Verifica se os nós semânticos atendem aos níveis mínimos de contraste
    // de texto. O contraste de texto recomendado é de 3:1 para textos maiores
    // (18 pontos e acima regular).
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
```

Para experimentar esses testes, execute-os no aplicativo que você cria no
codelab [Escreva seu primeiro aplicativo Flutter](/get-started/codelab). Cada
botão na tela principal desse aplicativo serve como um alvo clicável com texto
renderizado em uma fonte de 18 pontos.

Você pode adicionar testes da API de Diretrizes junto com outros [testes de
widget][], ou em um arquivo separado, como `test/a11y_test.dart` neste exemplo.

[API de Diretrizes de Acessibilidade]: {{site.api}}/flutter/flutter_test/AccessibilityGuideline-class.html
[testes de widget]: /testing/overview#widget-tests

## Testando a acessibilidade na web

Você pode depurar a acessibilidade visualizando os nós semânticos criados
para seu aplicativo web usando o seguinte sinalizador de linha de comando nos
modos de perfil e lançamento:

```console
flutter run -d chrome --profile --dart-define=FLUTTER_WEB_DEBUG_SHOW_SEMANTICS=true
```

Com o sinalizador ativado, os nós semânticos aparecem no topo dos widgets;
você pode verificar se os elementos semânticos estão colocados onde deveriam
estar. Se os nós semânticos estiverem posicionados incorretamente,
[registre um relatório de bug][].

## Lista de verificação de lançamento de acessibilidade

Aqui está uma lista não exaustiva de coisas a considerar ao preparar seu
aplicativo para lançamento.

* **Interações ativas**. Certifique-se de que todas as interações ativas
  façam algo. Qualquer botão que possa ser pressionado deve fazer algo quando
  pressionado. Por exemplo, se você tiver um callback no-op para um evento
  `onPressed`, altere-o para mostrar um `SnackBar` na tela explicando qual
  controle você acabou de pressionar.
* **Teste de leitor de tela**. O leitor de tela deve ser capaz de descrever
  todos os controles na página quando você toca neles e as descrições devem
  ser inteligíveis. Teste seu aplicativo com [TalkBack][] (Android) e
  [VoiceOver][] (iOS).
* **Taxas de contraste**. Incentivamos você a ter uma taxa de contraste de
  pelo menos 4,5:1 entre controles ou texto e o fundo, com exceção de
  componentes desabilitados. As imagens também devem ser verificadas quanto a
  contraste suficiente.
* **Troca de contexto**. Nada deve mudar o contexto do usuário
  automaticamente ao digitar informações. Geralmente, os widgets devem
  evitar mudar o contexto do usuário sem algum tipo de ação de confirmação.
* **Alvos clicáveis**. Todos os alvos clicáveis devem ter pelo menos 48x48
  pixels.
* **Erros**. Ações importantes devem poder ser desfeitas. Em campos que
  mostram erros, sugira uma correção, se possível.
* **Teste de deficiência de visão de cores**. Os controles devem ser
  utilizáveis e legíveis nos modos daltônico e em escala de cinza.
* **Fatores de escala**. A UI deve permanecer legível e utilizável com
  fatores de escala muito grandes para tamanho do texto e escala de exibição.

## Aprenda mais

Para saber mais sobre Flutter e acessibilidade, confira os seguintes artigos
escritos por membros da comunidade:

* [Um mergulho profundo nos widgets de acessibilidade do Flutter][]
* [Semântica no Flutter][]
* [Flutter: Criando uma ótima experiência para leitores de tela][]

[CRPD]: https://www.un.org/development/desa/disabilities/convention-on-the-rights-of-persons-with-disabilities/article-9-accessibility.html
[Um mergulho profundo nos widgets de acessibilidade do Flutter]: {{site.medium}}/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc
[Flutter: Criando uma ótima experiência para leitores de tela]: https://blog.gskinner.com/archives/2022/09/flutter-crafting-a-great-experience-for-screen-readers.html
[Accessibility Scanner]: https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en
[**Fontes grandes**]: #large-fonts
[**Leitores de tela**]: #screen-readers
[Semântica no Flutter]: https://www.didierboelens.com/2018/07/semantics/
[`Semantics` widget]: {{site.api}}/flutter/widgets/Semantics-class.html
[**Contraste suficiente**]: #sufficient-contrast
[TalkBack]: https://support.google.com/accessibility/android/answer/6283677?hl=en
[W3C recomenda]: https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html
[VoiceOver]: https://www.apple.com/lae/accessibility/iphone/vision/
[demonstração em vídeo]: {{site.yt.watch}}?v=A6Sx0lBP8PI
[registre um relatório de bug]: https://goo.gle/flutter_web_issue
