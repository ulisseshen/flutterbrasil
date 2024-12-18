---
title: Plugins em testes Flutter
short-title: Testes de plugins
description: Adicionando plugins como parte dos seus testes Flutter.
ia-translate: true
---

:::note
Para aprender como evitar crashes de um plugin ao
testar seu aplicativo Flutter, continue lendo.
Para aprender como testar o código do seu plugin, confira
[Testando plugins][].
:::

[Testando plugins]: /testing/testing-plugins

Quase todos os [plugins Flutter][] têm duas partes:

* Código Dart, que fornece a API que seu código chama.
* Código escrito em uma linguagem específica da plataforma (ou "host"),
  como Kotlin ou Swift, que implementa essas APIs.

Na verdade, o código nativo (ou host) distingue
um pacote de plugin de um pacote padrão.

[plugins Flutter]: /packages-and-plugins/using-packages

Construir e registrar a parte host de um plugin
faz parte do processo de construção do aplicativo Flutter,
então os plugins só funcionam quando seu código está rodando
em seu aplicativo, como com `flutter run`
ou ao executar [testes de integração][].
Ao executar [testes unitários Dart][] ou
[testes de widget][], o código host não está disponível.
Se o código que você está testando chama algum plugin,
isso geralmente resulta em erros como o seguinte:

```console
MissingPluginException(No implementation found for method someMethodName on channel some_channel_name)
```

[testes unitários Dart]: /cookbook/testing/unit/introduction
[testes de integração]: /cookbook/testing/integration/introduction
[testes de widget]: {{site.api}}/flutter/flutter_test/flutter_test-library.html

:::note
Implementações de plugin que [usam apenas Dart][]
funcionarão em testes unitários. Isso é um detalhe
de implementação do plugin, no entanto,
então os testes não devem depender disso.
:::

[usam apenas Dart]: /packages-and-plugins/developing-packages#dart-only-platform-implementations

Ao testar unitariamente código que usa plugins,
existem várias opções para evitar essa exceção.
As seguintes soluções estão listadas em ordem de preferência.

## Envolva o plugin

Na maioria dos casos, a melhor abordagem é envolver as chamadas
de plugin em sua própria API,
e fornecer uma maneira de fazer [mocking][] de sua própria API em testes.

Isso tem várias vantagens:

* Se a API do plugin mudar,
  você não precisará atualizar seus testes.
* Você está testando apenas seu próprio código,
  então seus testes não podem falhar devido ao comportamento de
  um plugin que você está usando.
* Você pode usar a mesma abordagem, independentemente de
  como o plugin é implementado,
  ou mesmo para dependências de pacotes não-plugin.

[mocking]: /cookbook/testing/unit/mocking

## Faça mocking da API pública do plugin

Se a API do plugin já for baseada em instâncias de classe,
você pode fazer mocking diretamente, com as seguintes ressalvas:

* Isso não funcionará se o plugin usar
  funções não-classe ou métodos estáticos.
* Os testes precisarão ser atualizados quando
  a API do plugin mudar.

## Faça mocking da interface da plataforma do plugin

Se o plugin for um [plugin federado][],
ele incluirá uma interface de plataforma que permite
registrar implementações de sua lógica interna.
Você pode registrar um mock dessa implementação de interface de plataforma
em vez da API pública com as seguintes ressalvas:

* Isso não funcionará se o plugin não for federado.
* Seus testes incluirão parte do código do plugin,
  então o comportamento do plugin pode causar problemas para seus testes.
  Por exemplo, se um plugin grava arquivos como parte de um
  cache interno, o comportamento do seu teste pode mudar
  com base em se você executou o teste anteriormente.
* Os testes podem precisar ser atualizados quando a interface da plataforma mudar.

Um exemplo de quando isso pode ser necessário é
fazer mocking da implementação de um plugin usado por
um pacote do qual você depende,
em vez do seu próprio código,
então você não pode mudar como ele é chamado.
No entanto, se possível,
você deve fazer mocking da dependência que usa o plugin.

[plugin federado]: /packages-and-plugins/developing-packages#federated-plugins

## Faça mocking do canal da plataforma

Se o plugin usa [canais de plataforma][],
você pode fazer mocking dos canais de plataforma usando
[`TestDefaultBinaryMessenger`][].
Isso só deve ser usado se, por algum motivo,
nenhum dos métodos acima estiver disponível,
pois ele tem várias desvantagens:

* Apenas implementações que usam canais de plataforma
  podem ser mockadas. Isso significa que, se algumas implementações
  não usam canais de plataforma,
  seus testes usarão inesperadamente
  implementações reais quando executados em algumas plataformas.
* Canais de plataforma são geralmente detalhes de implementação interna
  de plugins.
  Eles podem mudar substancialmente, mesmo
  em uma atualização de correção de bugs para um plugin,
  quebrando seus testes inesperadamente.
* Canais de plataforma podem diferir em cada implementação
  de um plugin federado. Por exemplo,
  você pode configurar canais de plataforma mock para
  fazer os testes passarem em uma máquina Windows,
  e então descobrir que eles falham se executados no macOS ou Linux.
* Canais de plataforma não são fortemente tipados.
  Por exemplo, canais de método geralmente usam dicionários
  e você precisa ler a implementação do plugin
  para saber quais são as strings-chave e os tipos de valor.

Devido a essas limitações, `TestDefaultBinaryMessenger`
é principalmente útil nos testes internos
de implementações de plugin,
em vez de testes de código que usam plugins.

Você também pode querer verificar
[Testando plugins][].

[canais de plataforma]: /platform-integration/platform-channels
[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[Testando plugins]: /testing/testing-plugins
