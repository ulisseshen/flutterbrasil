---
title: Construa e integre com múltiplas plataformas
shortTitle: Integração de plataforma
description: >-
  Aprenda como desenvolver para diferentes plataformas e
  integrar com recursos específicos de plataforma em aplicativos Flutter.
ia-translate: true
---

O Flutter permite que você construa, teste e implante aplicativos bonitos, compilados nativamente,
multiplataforma a partir de uma única base de código.

## Visão geral

O Flutter e seus pacotes principais frequentemente suportam e integram automaticamente
com as [supported platforms][] oficialmente suportadas pelo Flutter.
Algumas plataformas exigem que você [configure ferramentas adicionais](#setup),
mas uma vez que seu ambiente de desenvolvimento esteja configurado,
os aplicativos Flutter geralmente são funcionais em todas as plataformas imediatamente.

Ocasionalmente, você precisa integrar com funcionalidades específicas da plataforma.
Por exemplo, você pode querer usar uma biblioteca nativa que está
disponível apenas no iOS e iPadOS.
Para muitos casos de uso, você pode encontrar e usar um dos muitos [Flutter plugins][]
fornecidos pela equipe do Flutter e pela incrível comunidade Flutter.
Se nenhum deles atender às suas necessidades, você pode
[write platform-specific code][] e até mesmo [create your own plugin][].

:::tip
Se você está explorando a construção de seu aplicativo para múltiplas plataformas,
considere também construir sua UI com [adaptive and responsive design][] em mente.
:::

[supported platforms]: /reference/supported-platforms
[Flutter plugins]: /packages-and-plugins/using-packages
[write platform-specific code]: /platform-integration/platform-channels
[create your own plugin]: /packages-and-plugins/developing-packages
[adaptive and responsive design]: /ui/adaptive-responsive/

## Configure o desenvolvimento de plataforma {:#setup}

Embora os aplicativos Flutter possam ser construídos para uma variedade de [supported platforms][]
com poucas ou nenhuma modificação no seu código,
seu ambiente de desenvolvimento pode exigir configuração adicional
ao direcionar uma nova plataforma.

Para configurar o desenvolvimento para uma plataforma adicional,
selecione a plataforma a seguir:

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/android/setup">
    <div class="card-header">
      <span class="card-title">Target Android</span>
      <span class="card-subtitle">On any device</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para Android.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/setup">
    <div class="card-header">
      <span class="card-title">Target iOS</span>
      <span class="card-subtitle">On macOS only</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para iOS.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/web/setup">
    <div class="card-header">
      <span class="card-title">Target Web</span>
      <span class="card-subtitle">On any device</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para a web.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/windows/setup">
    <div class="card-header">
      <span class="card-title">Target Windows</span>
      <span class="card-subtitle">On Windows only</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para Windows.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/macos/setup">
    <div class="card-header">
      <span class="card-title">Target macOS</span>
      <span class="card-subtitle">On macOS only</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para macOS.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/linux/setup">
    <div class="card-header">
      <span class="card-title">Target Linux</span>
      <span class="card-subtitle">On Linux only</span>
    </div>
    <div class="card-content">
      <p>Configure seu ambiente de desenvolvimento para construir aplicativos Flutter para Linux.</p>
    </div>
  </a>
</div>

## Integre com cada plataforma {:#integrate}

Se a situação que você está tentando resolver não é
coberta por um [Flutter plugin][] existente,
confira os guias a seguir para aprender como
integrar com cada uma das plataformas suportadas.

[Flutter plugin]: /packages-and-plugins/using-packages#searching-for-packages

### Integre com Android {:#android}

Aprenda como adicionar integrações personalizadas com Android ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/android/splash-screen">
    <div class="card-header">
      <span class="card-title">Add a splash screen</span>
    </div>
    <div class="card-content">
      <p>Aprenda como adicionar uma splash screen ao seu aplicativo no Android.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/predictive-back">
    <div class="card-header">
      <span class="card-title">Support predictive back</span>
    </div>
    <div class="card-content">
      <p>Aprenda como adicionar o gesto de voltar preditivo ao seu aplicativo no Android.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/call-jetpack-apis">
    <div class="card-header">
      <span class="card-title">Call JetPack APIs</span>
    </div>
    <div class="card-content">
      <p>Aprenda como usar as APIs Android mais recentes no seu aplicativo a partir do Dart.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/c-interop">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como vincular a código C nativo do seu aplicativo no Android.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/platform-views">
    <div class="card-header">
      <span class="card-title">Embed an Android view</span>
    </div>
    <div class="card-content">
      <p>Aprenda como hospedar views nativas do Android no seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/compose-activity">
    <div class="card-header">
      <span class="card-title">Launch a Compose activity</span>
    </div>
    <div class="card-content">
      <p>Aprenda como iniciar uma activity Jetpack Compose do seu aplicativo.</p>
    </div>
  </a>
</div>

### Integre com iOS {:#ios}

Aprenda como adicionar integrações personalizadas com iOS ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/ios/launch-screen">
    <div class="card-header">
      <span class="card-title">Add a launch screen</span>
    </div>
    <div class="card-content">
      <p>Aprenda como adicionar uma launch screen ao seu aplicativo no iOS.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/apple-frameworks">
    <div class="card-header">
      <span class="card-title">Leverage system frameworks</span>
    </div>
    <div class="card-content">
      <p>Aprenda sobre plugins que suportam funcionalidades de frameworks nativos do iOS.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/c-interop">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como vincular a código C, Objective-C e Swift nativo do seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/platform-views">
    <div class="card-header">
      <span class="card-title">Embed an iOS view</span>
    </div>
    <div class="card-content">
      <p>Aprenda como hospedar views nativas do iOS no seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/app-extensions">
    <div class="card-header">
      <span class="card-title">Add an app extension</span>
    </div>
    <div class="card-content">
      <p>Aprenda como adicionar uma extensão de aplicativo iOS ao seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/ios/ios-latest">
    <div class="card-header">
      <span class="card-title">Support new iOS features</span>
    </div>
    <div class="card-content">
      <p>Aprenda sobre o suporte do Flutter para recursos novos ou futuros do iOS.</p>
    </div>
  </a>
</div>

### Integre com a web {:#web}

Aprenda como adicionar integrações personalizadas com a
plataforma web ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/web/initialization">
    <div class="card-header">
      <span class="card-title">Customize app initialization</span>
    </div>
    <div class="card-content">
      <p>Personalize como seu aplicativo Flutter é inicializado na web.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/android/c-interop">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como vincular a código C nativo do seu aplicativo no Android.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/web/web-content-in-flutter">
    <div class="card-header">
      <span class="card-title">Embed web content</span>
    </div>
    <div class="card-content">
      <p>Aprenda como incorporar conteúdo web nativo no seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/web/embedding-flutter-web">
    <div class="card-header">
      <span class="card-title">Embed your app</span>
    </div>
    <div class="card-content">
      <p>Aprenda como incorporar seu aplicativo Flutter em outro aplicativo web.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/web/wasm/">
    <div class="card-header">
      <span class="card-title">Compile to WebAssembly</span>
    </div>
    <div class="card-content">
      <p>Aprenda como aproveitar o WebAssembly no seu aplicativo Flutter web.</p>
    </div>
  </a>
  <a class="card outlined-card" href="{{site.dart-site}}/interop/js-interop" target="_blank">
    <div class="card-header">
      <span class="card-title">
        <span>Interop with JavaScript</span>
        <span class="material-symbols" aria-hidden="true" style="font-size: 1rem;" translate="no">open_in_new</span>
      </span>
    </div>
    <div class="card-content">
      <p>Aprenda como integrar com JavaScript a partir do seu código Dart.</p>
    </div>
  </a>
</div>

### Integre com Windows {:#windows}

Aprenda como adicionar integrações personalizadas com Windows ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/windows/building/#integrating-with-windows">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como vincular a código C nativo do seu aplicativo no Windows.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/windows/building/#distributing-windows-apps">
    <div class="card-header">
      <span class="card-title">Distribute your app</span>
    </div>
    <div class="card-content">
      <p>Aprenda sobre diferentes opções para distribuir seu aplicativo no Windows.</p>
    </div>
  </a>
  <a class="card outlined-card" href="platform-integration/windows/building#supporting-windows-ui-guidelines">
    <div class="card-header">
      <span class="card-title">Follow Windows UI conventions</span>
    </div>
    <div class="card-content">
      <p>Aprenda diferentes técnicas para integrar com a aparência do Windows.</p>
    </div>
  </a>
</div>

### Integre com macOS {:#macos}

Aprenda como adicionar integrações personalizadas com macOS ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/macos/c-interop">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como vincular a código C, Objective-C e Swift nativo do seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/macos/platform-views">
    <div class="card-header">
      <span class="card-title">Embed a macOS view</span>
    </div>
    <div class="card-content">
      <p>Aprenda como hospedar views nativas do macOS no seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/macos/building#entitlements-and-the-app-sandbox">
    <div class="card-header">
      <span class="card-title">Set up macOS entitlements</span>
    </div>
    <div class="card-content">
      <p>Aprenda como habilitar capacidades e serviços específicos para seu aplicativo.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/macos/building#integrating-with-macos-look-and-feel">
    <div class="card-header">
      <span class="card-title">Integrate with the macOS visual style</span>
    </div>
    <div class="card-content">
      <p>Aprenda diferentes técnicas para integrar com a aparência do macOS.</p>
    </div>
  </a>
</div>

### Integre com Linux {:#linux}

Aprenda como adicionar integrações personalizadas com Linux ao seu aplicativo Flutter.

<div class="card-grid">
  <a class="card outlined-card" href="/platform-integration/linux/building#integrate-with-linux">
    <div class="card-header">
      <span class="card-title">Bind to native code</span>
    </div>
    <div class="card-content">
      <p>Aprenda como usar e vincular a bibliotecas e código nativos do Linux.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/platform-integration/linux/building#prepare-linux-apps-for-distribution">
    <div class="card-header">
      <span class="card-title">Prepare for distribution</span>
    </div>
    <div class="card-content">
      <p>Prepare seu aplicativo Flutter para distribuição a usuários Linux.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/deployment/linux/">
    <div class="card-header">
      <span class="card-title">Deploy to the Snap Store</span>
    </div>
    <div class="card-content">
      <p>Aprenda como implantar seu aplicativo desktop Linux na Snap Store.</p>
    </div>
  </a>
</div>
