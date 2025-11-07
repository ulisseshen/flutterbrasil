---
ia-translate: true
title: "Chamando APIs JetPack"
description: "Use as mais recentes APIs Android do seu código Dart"
---

<?code-excerpt path-base="platform_integration"?>

Apps Flutter rodando no Android sempre podem fazer uso das
APIs mais recentes no primeiro dia em que são lançadas no Android, não
importa o quê. Esta página descreve as formas disponíveis para invocar
APIs específicas do Android.

## Usar uma solução existente

Na maioria dos cenários, você pode usar um plugin (como mostrado na próxima seção)
para invocar APIs nativas sem escrever qualquer boilerplate customizado ou
código de cola você mesmo.

### Usar um plugin

Usar um plugin geralmente é a forma mais fácil de acessar APIs
nativas, independentemente de onde seu app Flutter está rodando. Para
usar plugins, visite [pub.dev][pub] e busque
o tópico que você precisa. A maioria das funcionalidades nativas, incluindo acessar
hardware comum como GPS, câmera ou contadores de passos são
suportadas por plugins robustos.

Para orientação completa sobre adicionar plugins ao seu app Flutter,
veja a [documentação Using packages][packages].

[packages]: /packages-and-plugins/using-packages
[pub]: {{site.pub}}

Nem todas as funcionalidades nativas são suportadas por plugins, especialmente
imediatamente após seu lançamento. Em qualquer cenário onde
sua funcionalidade nativa desejada não é coberta por um pacote no
[pub.dev][pub], continue para as seções seguintes.

## Criando uma solução customizada

Nem todos os cenários e APIs serão suportados por
soluções existentes; mas felizmente, você sempre pode adicionar qualquer
suporte que você precise. As próximas seções descrevem duas formas diferentes
de chamar código nativo do Dart.

:::note
Nenhuma solução abaixo é inerentemente melhor ou pior que
plugins existentes, porque todos os plugins usam uma das seguintes
duas opções.
:::

### Chamar código nativo diretamente via FFI

A forma mais direta e eficiente de invocar APIs nativas é
chamando a API diretamente, via FFI. Isso vincula seu executável Dart
a qualquer código nativo especificado em tempo de compilação, permitindo que você
o chame diretamente da UI thread através de uma pequena quantidade de código
de cola. Na maioria dos casos, [ffigen][ffigen] ou [jnigen][jnigen] são
úteis para escrever este código de cola.

Para orientação completa sobre chamar código nativo diretamente do
seu app Flutter, veja a [documentação FFI][ffi].

Nos próximos meses, a equipe Dart espera tornar este processo
mais fácil com suporte direto para chamar APIs nativas usando a
abordagem FFI, mas sem qualquer necessidade de o desenvolvedor escrever
código de cola.

[ffi]: {{site.dart-site}}/interop/c-interop
[ffigen]: {{site.pub}}/packages/ffigen
[jnigen]: {{site.pub}}/packages/jnigen


### Adicionar um MethodChannel

[`MethodChannel`][methodchannels-api-docs]s são uma forma alternativa
de apps Flutter invocarem código nativo arbitrário.
Ao contrário da solução FFI descrita no passo anterior,
MethodChannels são sempre assíncronos, o que
pode ou não importar para você, dependendo do seu caso de uso. Assim como
com FFI e chamadas diretas a código nativo, usar um `MethodChannel`
requer uma pequena quantidade de código de cola para traduzir seus objetos Dart
em objetos nativos e então de volta novamente. Na maioria dos casos,
[`pkg:pigeon`][pigeon] é útil para escrever este código de cola.

Para orientação completa sobre adicionar MethodChannels ao seu app
Flutter, veja a [documentação de `MethodChannel`s][methodchannels].

[methodchannels]: /platform-integration/platform-channels
[methodchannels-api-docs]: {{site.api}}/flutter/services/MethodChannel-class.html
[pigeon]: {{site.pub}}/packages/pigeon
