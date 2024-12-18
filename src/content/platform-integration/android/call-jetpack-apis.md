---
ia-translate: true
title: "Chamando APIs do JetPack"
description: "Use as APIs mais recentes do Android a partir do seu código Dart"
---

<?code-excerpt path-base="platform_integration"?>

Aplicativos Flutter em execução no Android sempre podem usar as
APIs mais recentes no primeiro dia em que são lançadas no Android,
não importa o quê. Esta página descreve as formas disponíveis
para invocar APIs específicas do Android.

## Usar uma solução existente

Na maioria dos cenários, você pode usar um plugin (como mostrado na
próxima seção) para invocar APIs nativas sem escrever nenhum
boilerplate personalizado ou código de ligação.

### Usar um plugin

Usar um plugin costuma ser a maneira mais fácil de acessar APIs
nativas, independentemente de onde seu aplicativo Flutter esteja
sendo executado. Para usar plugins, visite [pub.dev][pub] e
pesquise o tópico que você precisa. A maioria dos recursos
nativos, incluindo o acesso a hardware comum como GPS, a câmera ou
contadores de passos, são suportados por plugins robustos.

Para obter orientação completa sobre como adicionar plugins ao seu
aplicativo Flutter, consulte a [documentação Usando packages][packages].

[packages]: /packages-and-plugins/using-packages
[pub]: {{site.pub}}

Nem todos os recursos nativos são suportados por plugins,
especialmente imediatamente após o lançamento. Em qualquer
cenário em que o recurso nativo desejado não seja coberto por um
pacote em [pub.dev][pub], continue para as seções seguintes.

## Criando uma solução personalizada

Nem todos os cenários e APIs serão suportados por soluções
existentes; mas, felizmente, você sempre pode adicionar qualquer
suporte que precisar. As próximas seções descrevem duas maneiras
diferentes de chamar código nativo do Dart.

:::note
Nenhuma das soluções abaixo é inerentemente melhor ou pior do
que os plugins existentes, porque todos os plugins usam uma das
duas opções a seguir.
:::

### Chamar código nativo diretamente via FFI

A maneira mais direta e eficiente de invocar APIs nativas é
chamando a API diretamente, via FFI. Isso vincula seu executável
Dart a qualquer código nativo especificado em tempo de
compilação, permitindo que você o chame diretamente da thread da
UI por meio de uma pequena quantidade de código de ligação. Na
maioria dos casos, [ffigen][ffigen] ou [jnigen][jnigen] são úteis
na escrita desse código de ligação.

Para obter orientação completa sobre como chamar diretamente o
código nativo do seu aplicativo Flutter, consulte a [documentação
FFI][ffi].

Nos próximos meses, a equipe Dart espera tornar este processo
mais fácil com suporte direto para chamar APIs nativas usando a
abordagem FFI, mas sem qualquer necessidade de o desenvolvedor
escrever código de ligação.

[ffi]: {{site.dart-site}}/interop/c-interop
[ffigen]: {{site.pub}}/packages/ffigen
[jnigen]: {{site.pub}}/packages/jnigen

### Adicionar um MethodChannel

[`MethodChannel`][methodchannels-api-docs]s são uma maneira
alternativa de aplicativos Flutter invocarem código nativo
arbitrário. Ao contrário da solução FFI descrita na etapa
anterior, os MethodChannels são sempre assíncronos, o que pode ou
não ser importante para você, dependendo do seu caso de uso. Assim
como com FFI e chamadas diretas para código nativo, usar um
`MethodChannel` requer uma pequena quantidade de código de
ligação para traduzir seus objetos Dart em objetos nativos e, em
seguida, de volta. Na maioria dos casos, [`pkg:pigeon`][pigeon] é
útil na escrita desse código de ligação.

Para obter orientação completa sobre como adicionar MethodChannels
ao seu aplicativo Flutter, consulte a documentação [`MethodChannel`s][methodchannels].

[methodchannels]: /platform-integration/platform-channels
[methodchannels-api-docs]: {{site.api}}/flutter/services/MethodChannel-class.html
[pigeon]: {{site.pub}}/packages/pigeon
