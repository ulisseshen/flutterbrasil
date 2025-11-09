---
ia-translate: true
title: Configure Flutter para suas necessidades
shortTitle: Configuração personalizada
description: >-
  Instale e configure Flutter para seu ambiente de desenvolvimento
  e plataformas de destino preferidos.
showBanner: false
sitemap: false
---

Para começar a desenvolver com Flutter,
siga estes passos para instalar e configurar Flutter
para seu ambiente de desenvolvimento e plataforma de destino preferidos.

Se você planeja usar VS Code ou outro editor derivado de Code - OSS,
considere seguir o [início rápido do Flutter][Flutter quick start].

[Flutter quick start]: /get-started/quick

## Instale e configure Flutter {: #install}

Para começar a desenvolver apps com Flutter,
instale o Flutter SDK no seu dispositivo de desenvolvimento.
Escolha um dos seguintes métodos de instalação:

<div class="card-grid">
  <a class="card outlined-card" href="/install/with-vs-code" target="_blank">
    <div class="card-header">
      <span class="card-title">Install with VS Code</span>
      <span class="card-subtitle">Recomendado</span>
    </div>
    <div class="card-content">
      <p>Use VS Code para configurar rapidamente seu ambiente de desenvolvimento Flutter.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/install/manual" target="_blank">
    <div class="card-header">
      <span class="card-title">Install manually</span>
      <span class="card-subtitle">Para versões específicas</span>
    </div>
    <div class="card-content">
      <p>Instale e configure manualmente uma versão específica do Flutter SDK.</p>
    </div>
  </a>
</div>

## Configure uma IDE ou editor {: #editor}

Para a melhor experiência de desenvolvimento com Flutter,
instale uma IDE ou editor com suporte para Dart e Flutter.
Algumas opções populares incluem VS Code, Android Studio,
Firebase Studio e outros editores baseados em Code OSS.

<div class="card-grid wide">
 <a class="card outlined-card" href="/tools/vs-code#setup" target="_blank">
   <div class="card-header">
     <span class="card-title">VS Code</span>
   </div>
   <div class="card-content">
     <p>Configure o suporte a Flutter no VS Code.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/tools/android-studio#setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Android Studio</span>
   </div>
   <div class="card-content">
     <p>Configure o suporte a Flutter no Android Studio.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/tools/android-studio#setup" target="_blank">
   <div class="card-header">
     <span class="card-title">IntelliJ</span>
   </div>
   <div class="card-content">
     <p>Configure o suporte a Flutter em uma IDE baseada em IntelliJ.</p>
   </div>
 </a>
 <a class="card outlined-card" href="https://studio.firebase.google.com/new/flutter" target="_blank">
   <div class="card-header">
     <span class="card-title">Firebase Studio</span>
   </div>
   <div class="card-content">
     <p>Crie um novo workspace Flutter no Firebase Studio.</p>
   </div>
 </a>
</div>

## Configure uma plataforma de destino {: #target-platform}

Uma vez que você instalou Flutter com sucesso,
configure o desenvolvimento para pelo menos uma plataforma de destino
para continuar sua jornada com Flutter.

Recomendamos [desenvolver para a web][web-setup]{: target="_blank"} primeiro, pois
não requer configuração adicional além de um navegador apropriado.
Você sempre pode configurar o desenvolvimento para plataformas de destino adicionais mais tarde.

<div class="card-grid wide">
 <a class="card outlined-card" href="/platform-integration/android/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target Android</span>
     <span class="card-subtitle">Em qualquer dispositivo</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para Android.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/platform-integration/ios/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target iOS</span>
     <span class="card-subtitle">Somente no macOS</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para iOS.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/platform-integration/web/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target Web</span>
     <span class="card-subtitle">Em qualquer dispositivo</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para a web.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/platform-integration/windows/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target Windows</span>
     <span class="card-subtitle">Somente no Windows</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para Windows desktop.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/platform-integration/macos/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target macOS</span>
     <span class="card-subtitle">Somente no macOS</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para macOS desktop.</p>
   </div>
 </a>
 <a class="card outlined-card" href="/platform-integration/linux/setup" target="_blank">
   <div class="card-header">
     <span class="card-title">Target Linux</span>
     <span class="card-subtitle">Somente no Linux</span>
   </div>
   <div class="card-content">
     <p>Configure seu ambiente de desenvolvimento para construir apps Flutter para Linux desktop.</p>
   </div>
 </a>
</div>

[web-setup]: /platform-integration/web/setup

## Continue sua jornada Flutter {: #next-steps}

**Parabéns!**
Agora que você instalou Flutter, configurou uma IDE ou editor,
e configurou o desenvolvimento para uma plataforma de destino,
você pode continuar sua jornada de aprendizado Flutter.

Siga o codelab [Construindo seu primeiro app][Building your first app],
configure o desenvolvimento para uma [plataforma de destino adicional][additional target platform], ou
explore alguns desses outros recursos de aprendizado.

{% render "docs/get-started/setup-next-steps.html", site:site %}

[Building your first app]: /get-started/codelab
[additional target platform]: /platform-integration#setup
