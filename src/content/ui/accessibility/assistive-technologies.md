---
ia-translate: true
title: Tecnologias assistivas
description: >-
  Informações sobre tecnologias assistivas para desenvolvedores Flutter.
---

## Resumo

Tecnologias assistivas são essenciais para tornar o conteúdo digital acessível a
indivíduos com deficiências. Este documento fornece uma visão geral de duas categorias
principais de tecnologias assistivas relevantes para o desenvolvimento Flutter: leitores
de tela para usuários com deficiências visuais e ferramentas de suporte à mobilidade para
aqueles com limitações motoras. Ao entender e testar com essas
tecnologias, você pode garantir que sua aplicação Flutter forneça uma experiência mais inclusiva
e amigável para todos.

## Leitores de tela

Para dispositivos móveis, leitores de tela ([TalkBack][TalkBack], [VoiceOver][VoiceOver])
permitem que usuários com deficiência visual recebam feedback falado sobre
o conteúdo da tela e interajam com a UI usando
gestos em dispositivos móveis e atalhos de teclado no desktop.
Ative o VoiceOver ou TalkBack no seu dispositivo móvel e
navegue pelo seu app.

**Para ativar o leitor de tela no seu dispositivo, complete os seguintes passos:**

{% tabs %}
{% tab "TalkBack on Android" %}

1. No seu dispositivo, abra **Settings**.
2. Selecione **Accessibility** e depois **TalkBack**.
3. Ative ou desative 'Use TalkBack'.
4. Selecione Ok.

Para aprender como encontrar e customizar os recursos de
acessibilidade do Android, veja o seguinte vídeo.

{% ytEmbed 'FQyj_XTl01w', 'Customize Pixel and Android accessibility features' %}

{% endtab %}
{% tab "VoiceOver on iPhone" %}

1. No seu dispositivo, abra **Settings > Accessibility > VoiceOver**
2. Ative ou desative a configuração VoiceOver

Para aprender como encontrar e customizar os recursos de
acessibilidade do iOS, veja o seguinte vídeo.

{% ytEmbed 'ROIe49kXOc8', 'How to navigate your iPhone or iPad with VoiceOver' %}

{% endtab %}
{% tab "Browsers" %}

Para web, os seguintes leitores de tela são atualmente suportados:

Navegadores móveis:

* iOS - VoiceOver
* Android - TalkBack

Navegadores desktop:

* macOS - VoiceOver
* Windows - JAWs & NVDA

Usuários de leitores de tela na web devem alternar o
botão "Enable accessibility" para construir a árvore de semântica.
Usuários podem pular esta etapa se você habilitar programaticamente a
acessibilidade automaticamente para seu app usando esta API:

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

Windows vem com um leitor de tela chamado Narrator
mas alguns desenvolvedores recomendam usar o mais popular
leitor de tela NVDA. Para aprender sobre como usar o NVDA para testar
apps Windows, confira
[Screen Readers 101 For Front-End Developers (Windows)][nvda].

[nvda]: https://get-evinced.com/blog/screen-readers-101-for-front-end-developers-windows

Em um Mac, você pode usar a versão desktop do VoiceOver,
que está incluída no macOS.

{% ytEmbed '5R-6WvAihms', 'Screen reader basics: VoiceOver' %}

No Linux, um leitor de tela popular é chamado Orca.
Ele vem pré-instalado em algumas distribuições
e está disponível em repositórios de pacotes como `apt`.
Para aprender sobre como usar o Orca, confira
[Getting started with Orca screen reader on Gnome desktop][orca].

[orca]: https://www.a11yproject.com/posts/getting-started-with-orca

{% endtab %}
{% endtabs %}

<br/>

Confira a seguinte [demonstração em vídeo][video demo] para ver como
usar o VoiceOver com o web app [Flutter Gallery][Flutter Gallery], agora arquivado.

Os widgets padrão do Flutter geram uma árvore de acessibilidade automaticamente.
No entanto, se seu app precisa de algo diferente,
ela pode ser customizada usando o [widget `Semantics`][`Semantics` widget].

Quando houver texto em seu app que deve ser falado
com uma voz específica, informe ao leitor de tela
qual voz usar chamando [`TextSpan.locale`][`TextSpan.locale`].
`MaterialApp.locale` e `Localizations.override`
afetarão as vozes do leitor de tela a partir da versão 3.38 do flutter.
Normalmente, o leitor de tela usa a voz do sistema
exceto onde você a define explicitamente com `TextSpan.locale`.

[Flutter Gallery]: {{site.gallery-archive}}
[`TextSpan.locale`]: {{site.api}}/flutter/painting/TextSpan/locale.html
[`Semantics` widget]: {{site.api}}/flutter/widgets/Semantics-class.html
[TalkBack]: https://support.google.com/accessibility/android/answer/6283677?hl=en
[VoiceOver]: https://www.apple.com/lae/accessibility/iphone/vision/
[video demo]: {{site.yt.watch}}?v=A6Sx0lBP8PI

## Suporte à mobilidade

Para usuários com destreza ou força manual limitada, recursos de suporte à mobilidade
podem ser úteis. Tanto Android quanto iOS oferecem uma variedade de ferramentas projetadas para tornar
a navegação e controle mais fáceis.
Esses recursos permitem que os usuários operem seus dispositivos através de interruptores externos,
comandos de voz ou menus simplificados na tela.

Android fornece Switch Access, Voice Access e Accessibility Menu,
enquanto iOS oferece Switch Control, Voice Control e AssistiveTouch.
Entender essas ferramentas ajuda a criar
apps que são usáveis por pessoas com diversas habilidades físicas.

<table class="table table-striped">
  <thead>
    <tr>
      <th>OS</th>
      <th>Recursos </th>
      <th>Funções</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Android</td>
      <td><strong>Switch Access</strong> </td>
      <td>Como um método de entrada alternativo, você pode usar Switch Access e Camera Switches</td>
    </tr>
    <tr>
      <td>Android</td>
      <td><strong>Voice Access</strong> </td>
      <td>Controle seu dispositivo com sua voz</td>
    </tr>
    <tr>
      <td>Android</td>
      <td><strong>Accessibility Menu</strong> </td>
      <td>Um menu flutuante na tela que fornece botões simplificados para controlar funções essenciais do telefone.</td>
    </tr>
    <tr>
      <td>iOS</td>
      <td><strong>Switch Control</strong> </td>
      <td>Use interruptores como métodos de entrada alternativos</td>
    </tr>
    <tr>
      <td>iOS</td>
      <td><strong>Voice Control</strong> </td>
      <td>Controle seu dispositivo com sua voz</td>
    </tr>
    <tr>
      <td>iOS</td>
      <td><strong>AssistiveTouch</strong> </td>
      <td>Use AssistiveTouch para substituir gestos com múltiplos dedos ou ações de botões físicos</td>
    </tr>
  </tbody>
</table>
