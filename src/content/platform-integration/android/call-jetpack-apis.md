---
ia-translate: true
title: "Chamando APIs JetPack"
description: "Use as APIs Android mais recentes do seu código Dart"
---

<?code-excerpt path-base="platform_integration"?>

Apps Flutter rodando no Android sempre podem fazer uso das
APIs mais recentes no primeiro dia em que são lançadas no Android, não
importa o quê. Esta página descreve as formas disponíveis para invocar
APIs específicas do Android.

## Use uma solução existente

Na maioria dos cenários, você pode usar um plugin (como mostrado na próxima seção)
para invocar APIs nativas sem escrever qualquer código boilerplate ou
glue code personalizado você mesmo.

### Use um plugin

Usar um plugin é frequentemente a forma mais fácil de acessar APIs
nativas, independentemente de onde seu app Flutter esteja rodando. Para
usar plugins, visite [pub.dev][pub] e busque pelo
tópico que você precisa. A maioria dos recursos nativos, incluindo acesso
a hardware comum como GPS, câmera ou contadores de passos são
suportados por plugins robustos.

Para orientação completa sobre adicionar plugins ao seu app Flutter,
veja a [documentação Usando pacotes][packages].

[packages]: /packages-and-plugins/using-packages
[pub]: {{site.pub}}

Nem todos os recursos nativos são suportados por plugins, especialmente
imediatamente após seu lançamento. Em qualquer cenário onde
seu recurso nativo desejado não é coberto por um pacote no
[pub.dev][pub], continue para as seções seguintes.

## Criando uma solução personalizada

Nem todos os cenários e APIs serão suportados por
soluções existentes; mas felizmente, você sempre pode adicionar qualquer
suporte que precisar. As próximas seções descrevem duas formas diferentes
de chamar código nativo do Dart.

:::note
Nenhuma das soluções abaixo é inerentemente melhor ou pior que
plugins existentes, porque todos os plugins usam uma das duas
opções seguintes.
:::

### Chame código nativo diretamente via FFI

A forma mais direta e eficiente de invocar APIs nativas é
chamando a API diretamente, via FFI. Isso vincula seu executável Dart
a qualquer código nativo especificado em tempo de compilação, permitindo que você
chame-o diretamente da thread de UI através de uma pequena quantidade de glue
code. Na maioria dos casos, [ffigen][ffigen] ou [jnigen][jnigen] são
úteis para escrever esse glue code.

Para orientação completa sobre chamar código nativo diretamente do
seu app Flutter, veja a [documentação FFI][ffi].

Nos próximos meses, a equipe Dart espera tornar esse processo
mais fácil com suporte direto para chamar APIs nativas usando a
abordagem FFI, mas sem qualquer necessidade do desenvolvedor escrever
glue code.

[ffi]: {{site.dart-site}}/interop/c-interop
[ffigen]: {{site.pub}}/packages/ffigen
[jnigen]: {{site.pub}}/packages/jnigen


### Adicione um MethodChannel

[`MethodChannel`][methodchannels-api-docs]s são uma forma alternativa
de apps Flutter invocarem código nativo arbitrário.
Diferentemente da solução FFI descrita no passo anterior,
MethodChannels são sempre assíncronos, o que
pode ou não importar para você, dependendo do seu caso de uso. Assim
como com FFI e chamadas diretas a código nativo, usar um `MethodChannel`
requer uma pequena quantidade de glue code para traduzir seus objetos Dart
em objetos nativos, e então de volta novamente. Na maioria dos casos,
[`pkg:pigeon`][pigeon] é útil para escrever esse glue code.

Para orientação completa sobre adicionar MethodChannels ao seu app
Flutter, veja a [documentação `MethodChannel`s][methodchannels].

[methodchannels]: /platform-integration/platform-channels
[methodchannels-api-docs]: {{site.api}}/flutter/services/MethodChannel-class.html
[pigeon]: {{site.pub}}/packages/pigeon
