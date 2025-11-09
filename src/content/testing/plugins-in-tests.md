---
ia-translate: true
title: Plugins em testes Flutter
shortTitle: Testes de plugin
description: Adicionando plugin como parte de seus testes Flutter.
---

:::note
Para aprender como evitar crashes de um plugin ao
testar seu app Flutter, continue lendo.
Para aprender como testar o código do seu plugin, confira
[Testing plugins][Testing plugins].
:::

[Testing plugins]: /testing/testing-plugins

Quase todos os [Flutter plugins][Flutter plugins] têm duas partes:

* Código Dart, que fornece a API que seu código chama.
* Código escrito em uma linguagem específica de plataforma (ou "host"),
  como Kotlin ou Swift, que implementa essas APIs.

Na verdade, o código em linguagem nativa (ou host) distingue
um package de plugin de um package padrão.

[Flutter plugins]: /packages-and-plugins/using-packages

Compilar e registrar a porção host de um plugin
faz parte do processo de build da aplicação Flutter,
então os plugins só funcionam quando seu código está rodando
em sua aplicação, como com `flutter run`
ou ao executar [integration tests][integration tests].
Ao executar [Dart unit tests][Dart unit tests] ou
[widget tests][widget tests], o código host não está disponível.
Se o código que você está testando chama quaisquer plugins,
isso geralmente resulta em erros como o seguinte:

```console
MissingPluginException(No implementation found for method someMethodName on channel some_channel_name)
```

[Dart unit tests]: /cookbook/testing/unit/introduction
[integration tests]: /cookbook/testing/integration/introduction
[widget tests]: {{site.api}}/flutter/flutter_test/flutter_test-library.html

:::note
Implementações de plugin que [only use Dart][only use Dart]
funcionarão em unit tests. Este é um detalhe de implementação
do plugin, no entanto,
então os testes não devem depender disso.
:::

[only use Dart]: /packages-and-plugins/developing-packages#dart-only-platform-implementations

Ao fazer unit testing de código que usa plugins,
existem várias opções para evitar essa exceção.
As seguintes soluções estão listadas em ordem de preferência.

## Wrap the plugin

Na maioria dos casos, a melhor abordagem é encapsular as chamadas do plugin
em sua própria API,
e fornecer uma maneira de fazer [mocking][mocking] da sua própria API em testes.

Isso tem várias vantagens:

* Se a API do plugin mudar,
  você não precisará atualizar seus testes.
* Você está testando apenas seu próprio código,
  então seus testes não podem falhar devido ao comportamento de
  um plugin que você está usando.
* Você pode usar a mesma abordagem independentemente de
  como o plugin é implementado,
  ou até mesmo para dependências de packages que não são plugins.

[mocking]: /cookbook/testing/unit/mocking

## Mock the plugin's public API

Se a API do plugin já é baseada em instâncias de classe,
você pode fazer mock dela diretamente, com as seguintes ressalvas:

* Isso não funcionará se o plugin usar
  funções que não são de classe ou métodos estáticos.
* Os testes precisarão ser atualizados quando
  a API do plugin mudar.

## Mock the plugin's platform interface

Se o plugin é um [federated plugin][federated plugin],
ele incluirá uma platform interface que permite
registrar implementações de sua lógica interna.
Você pode registrar um mock dessa implementação de platform interface
ao invés da API pública com as
seguintes ressalvas:

* Isso não funcionará se o plugin não for federado.
* Seus testes incluirão parte do código do plugin,
  então o comportamento do plugin pode causar problemas para seus testes.
  Por exemplo, se um plugin grava arquivos como parte de um
  cache interno, o comportamento do seu teste pode mudar
  com base em se você executou o teste anteriormente.
* Os testes podem precisar ser atualizados quando a platform interface mudar.

Um exemplo de quando isso pode ser necessário é
fazer mock da implementação de um plugin usado por
um package do qual você depende,
em vez do seu próprio código,
então você não pode mudar como ele é chamado.
No entanto, se possível,
você deve fazer mock da dependência que usa o plugin em vez disso.

[federated plugin]: /packages-and-plugins/developing-packages#federated-plugins

## Mock the platform channel

Se o plugin usa [platform channels][platform channels],
você pode fazer mock dos platform channels usando
[`TestDefaultBinaryMessenger`][`TestDefaultBinaryMessenger`].
Isso só deve ser usado se, por algum motivo,
nenhum dos métodos acima estiver disponível,
pois possui várias desvantagens:

* Apenas implementações que usam platform channels
  podem ser mockadas. Isso significa que se algumas implementações
  não usarem platform channels,
  seus testes usarão inesperadamente
  implementações reais quando executados em algumas plataformas.
* Platform channels são geralmente detalhes de implementação
  internos de plugins.
  Eles podem mudar substancialmente até mesmo
  em uma atualização de correção de bug de um plugin,
  quebrando seus testes inesperadamente.
* Platform channels podem diferir em cada implementação
  de um federated plugin. Por exemplo,
  você pode configurar mock platform channels para
  fazer os testes passarem em uma máquina Windows,
  e então descobrir que eles falham se executados no macOS ou Linux.
* Platform channels não são fortemente tipados.
  Por exemplo, method channels frequentemente usam dicionários
  e você tem que ler a implementação do plugin
  para saber quais são as strings de chave e tipos de valor.

Devido a essas limitações, `TestDefaultBinaryMessenger`
é principalmente útil nos testes internos
de implementações de plugins,
em vez de testes de código usando plugins.

Você também pode querer conferir
[Testing plugins][Testing plugins].

[platform channels]: /platform-integration/platform-channels
[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[Testing plugins]: /testing/testing-plugins
