---
ia-translate: true
title: Jank de compilação de shader
short-title: Jank de shader
description: O que é jank de shader e como minimizá-lo.
---

{% render docs/performance.md %}

Se as animações no seu aplicativo móvel parecem instáveis,
mas apenas na primeira execução,
isso provavelmente se deve à compilação de shader.
A solução de longo prazo do Flutter para
o jank de compilação de shader é o [Impeller][],
que é o renderizador padrão no iOS.
Você pode visualizar o Impeller no Android passando
`--enable-impeller` para `flutter run`.

[Impeller]: /perf/impeller

Enquanto trabalhamos para tornar o Impeller totalmente pronto para produção,
você pode mitigar o jank de compilação de shader agrupando
shaders pré-compilados com um aplicativo iOS.
Infelizmente, essa abordagem não funciona bem no Android
devido aos shaders pré-compilados serem específicos do dispositivo ou da GPU.
O ecossistema de hardware Android é grande o suficiente para que os
shaders pré-compilados específicos da GPU agrupados com um aplicativo
funcionem apenas em um pequeno subconjunto de dispositivos,
e provavelmente piorarão o jank nos outros dispositivos,
ou até mesmo criarão erros de renderização.

Além disso, observe que não estamos planejando fazer
melhorias na experiência do desenvolvedor para criar
shaders pré-compilados descritos abaixo. Em vez disso,
estamos concentrando nossas energias em soluções mais robustas
para este problema que o Impeller oferece.

## O que é jank de compilação de shader?

Um shader é um trecho de código que é executado em uma
GPU (unidade de processamento gráfico).
Quando o backend gráfico Skia que o Flutter usa para renderização
vê uma nova sequência de comandos de desenho pela primeira vez,
às vezes ele gera e compila um
shader de GPU personalizado para essa sequência de comandos.
Isso permite que essa sequência e sequências potencialmente semelhantes
sejam renderizadas o mais rápido possível.

Infelizmente, a geração e compilação de shader do Skia
acontece em sequência com a carga de trabalho do frame.
A compilação pode custar até algumas centenas de milissegundos
enquanto um frame suave precisa ser desenhado em 16 milissegundos
para um display de 60 fps (frames por segundo).
Portanto, uma compilação pode fazer com que dezenas de frames
sejam perdidos, e diminuir o fps de 60 para 6.
Isso é _jank de compilação_.
Após a conclusão da compilação,
a animação deve ser suave.

Por outro lado, o Impeller gera e compila todos os
shaders necessários quando construímos o Flutter Engine.
Portanto, aplicativos executados no Impeller já possuem
todos os shaders de que precisam, e os shaders podem ser usados
sem introduzir jank nas animações.

A evidência definitiva para a presença de jank de compilação de shader
é definir `GrGLProgramBuilder::finalize` no rastreamento
com `--trace-skia` habilitado.
A captura de tela a seguir mostra um exemplo de rastreamento de linha do tempo.

![Uma captura de tela de rastreamento verificando o jank](/assets/images/docs/perf/render/tracing.png){:width="100%"}

## O que queremos dizer com "primeira execução"?

No iOS, "primeira execução" significa que o usuário pode ver
jank quando uma animação ocorre pela primeira vez toda vez
que o usuário abre o aplicativo do zero.

## Como usar o aquecimento SkSL

O Flutter fornece ferramentas de linha de comando
para desenvolvedores de aplicativos coletarem shaders que possam ser necessários
para usuários finais no formato SkSL (Skia Shader Language).
Os shaders SkSL podem ser empacotados no aplicativo,
e aquecidos (pré-compilados) quando um usuário final abre o aplicativo pela primeira vez,
reduzindo assim o jank de compilação
em animações posteriores.
Use as seguintes instruções para coletar
e empacotar os shaders SkSL:

<ol>
<li>

Execute o aplicativo com `--cache-sksl` ativado
para capturar shaders em SkSL:

```console
flutter run --profile --cache-sksl
```

Se o mesmo aplicativo foi executado anteriormente
sem `--cache-sksl`, então o
flag `--purge-persistent-cache` pode ser necessário:

```console
flutter run --profile --cache-sksl --purge-persistent-cache
```

Este flag remove caches de shader não-SkSL mais antigos que
poderiam interferir na captura de shader SkSL.
Ele também limpa os shaders SkSL, então use-o *apenas* na primeira
execução de `--cache-sksl`.
</li>

<li>

Brinque com o aplicativo para acionar o máximo de animações
possível; particularmente aquelas com jank de compilação.

</li>

<li>

Pressione `M` na linha de comando de `flutter run` para
gravar os shaders SkSL capturados em um arquivo chamado algo como
`flutter_01.sksl.json`.
Para melhores resultados,
capture shaders SkSL em um dispositivo iOS real.
Um shader capturado em um simulador provavelmente não funcionará corretamente
em hardware real.

</li>

<li>

Compile o aplicativo com o aquecimento SkSL usando o seguinte,
conforme apropriado:

```console
flutter build ios --bundle-sksl-path flutter_01.sksl.json
```

Se ele for construído para um teste de driver como `test_driver/app.dart`,
certifique-se de também especificar `--target=test_driver/app.dart`
(por exemplo, `flutter build ios --bundle-sksl-path
flutter_01.sksl.json --target=test_driver/app.dart`).

</li>

<li> Teste o aplicativo recém-construído.
</li>
</ol>

Alternativamente, você pode escrever alguns testes de integração para
automatizar as três primeiras etapas usando um único comando.
Por exemplo:

```console
flutter drive --profile --cache-sksl --write-sksl-on-exit flutter_01.sksl.json -t test_driver/app.dart
```

Com tais [testes de integração][],
você pode obter os novos SkSLs de forma fácil e confiável
quando o código do aplicativo muda,
ou quando o Flutter é atualizado.
Tais testes também podem ser usados para verificar a mudança de desempenho
antes e depois do aquecimento SkSL.
Melhor ainda, você pode colocar esses testes em um
sistema CI (integração contínua) para que os
SkSLs sejam gerados e testados automaticamente durante a vida útil de um aplicativo.

[testes de integração]: /cookbook/testing/integration/introduction

:::note
O pacote integration_test agora é a maneira recomendada
para escrever testes de integração. Consulte a página
[Testes de integração](/testing/integration-tests/)
para obter detalhes.
:::

Pegue a versão original do [Flutter Gallery][] como exemplo.
O sistema CI está configurado para gerar SkSLs para cada commit do Flutter,
e verifica o desempenho, no teste [`transitions_perf_test.dart`][].
Para mais detalhes,
confira as tarefas [`flutter_gallery_sksl_warmup__transition_perf`][] e
[`flutter_gallery_sksl_warmup__transition_perf_e2e_ios32`][].

[Flutter Gallery]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flutter_gallery
[`flutter_gallery_sksl_warmup__transition_perf`]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_sksl_warmup__transition_perf.dart
[`flutter_gallery_sksl_warmup__transition_perf_e2e_ios32`]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_sksl_warmup__transition_perf_e2e_ios32.dart
[`transitions_perf_test.dart`]: {{site.repo.flutter}}/blob/master/dev/integration_tests/flutter_gallery/test_driver/transitions_perf_test.dart

O pior tempo de rasterização de frame é uma métrica útil de
tais testes de integração para indicar a gravidade do shader
jank de compilação.
Por exemplo,
as etapas acima reduzem o jank de compilação de shader do Flutter Gallery
e acelera seu pior tempo de rasterização de frame em um
Moto G4 de ~90 ms para ~40 ms. No iPhone 4s,
é reduzido de ~300 ms para ~80 ms. Isso leva à diferença visual
como ilustrado no início deste artigo.
