---
ia-translate: true
title: Plugins em testes Flutter
short-title: Plugin tests
description: Adicionar plugin como parte dos seus testes Flutter.
---

:::note
Para aprender como evitar crashes de um plugin ao
testar seu app Flutter, continue lendo.
Para aprender como testar o código do seu plugin, confira
[Testing plugins][].
:::

[Testing plugins]: /testing/testing-plugins

Quase todos os [plugins Flutter][Flutter plugins] têm duas partes:

* Código Dart, que fornece a API que seu código chama.
* Código escrito em uma linguagem específica da plataforma (ou "host"),
  como Kotlin ou Swift, que implementa essas APIs.

Na verdade, o código em linguagem nativa (ou host) distingue
um pacote de plugin de um pacote padrão.

[Flutter plugins]: /packages-and-plugins/using-packages

Construir e registrar a porção host de um plugin
faz parte do processo de build da aplicação Flutter,
então plugins só funcionam quando seu código está executando
em sua aplicação, como com `flutter run`
ou ao executar [integration tests][].
Ao executar [Dart unit tests][] ou
[widget tests][], o código host não está disponível.
Se o código que você está testando chama algum plugin,
isso geralmente resulta em erros como o seguinte:

```console
MissingPluginException(No implementation found for method someMethodName on channel some_channel_name)
```

[Dart unit tests]: /cookbook/testing/unit/introduction
[integration tests]: /cookbook/testing/integration/introduction
[widget tests]: {{site.api}}/flutter/flutter_test/flutter_test-library.html

:::note
Implementações de plugins que [usam apenas Dart][only use Dart]
funcionarão em unit tests. Este é um detalhe de implementação
do plugin, no entanto,
então os testes não devem depender disso.
:::

[only use Dart]: /packages-and-plugins/developing-packages#dart-only-platform-implementations

Ao testar unitariamente código que usa plugins,
existem várias opções para evitar esta exceção.
As seguintes soluções estão listadas em ordem de preferência.

## Encapsular o plugin

Na maioria dos casos, a melhor abordagem é encapsular chamadas de plugin
na sua própria API,
e fornecer uma maneira de [mockar][mocking] sua própria API em testes.

Isso tem várias vantagens:

* Se a API do plugin mudar,
  você não precisará atualizar seus testes.
* Você está testando apenas seu próprio código,
  então seus testes não podem falhar devido ao comportamento de
  um plugin que você está usando.
* Você pode usar a mesma abordagem independentemente de
  como o plugin é implementado,
  ou mesmo para dependências de pacotes que não sejam plugins.

[mocking]: /cookbook/testing/unit/mocking

## Mockar a API pública do plugin

Se a API do plugin já é baseada em instâncias de classe,
você pode mocká-la diretamente, com as seguintes ressalvas:

* Isso não funcionará se o plugin usar
  funções que não sejam de classe ou métodos estáticos.
* Os testes precisarão ser atualizados quando
  a API do plugin mudar.

## Mockar a interface de plataforma do plugin

Se o plugin é um [plugin federado][federated plugin],
ele incluirá uma interface de plataforma que permite
registrar implementações de sua lógica interna.
Você pode registrar um mock dessa implementação da interface de plataforma
em vez da API pública com as
seguintes ressalvas:

* Isso não funcionará se o plugin não for federado.
* Seus testes incluirão parte do código do plugin,
  então o comportamento do plugin pode causar problemas para seus testes.
  Por exemplo, se um plugin grava arquivos como parte de um
  cache interno, o comportamento do seu teste pode mudar
  com base em se você executou o teste anteriormente.
* Os testes podem precisar ser atualizados quando a interface de plataforma mudar.

Um exemplo de quando isso pode ser necessário é
mockar a implementação de um plugin usado por
um pacote do qual você depende,
em vez do seu próprio código,
então você não pode mudar como ele é chamado.
No entanto, se possível,
você deve mockar a dependência que usa o plugin em vez disso.

[federated plugin]: /packages-and-plugins/developing-packages#federated-plugins

## Mockar o canal de plataforma

Se o plugin usa [platform channels][],
você pode mockar os canais de plataforma usando
[`TestDefaultBinaryMessenger`][].
Isso só deve ser usado se, por alguma razão,
nenhum dos métodos acima estiver disponível,
pois tem várias desvantagens:

* Apenas implementações que usam canais de plataforma
  podem ser mockadas. Isso significa que se algumas implementações
  não usarem canais de plataforma,
  seus testes usarão inesperadamente
  implementações reais quando executados em algumas plataformas.
* Canais de plataforma geralmente são detalhes internos de implementação
  dos plugins.
  Eles podem mudar substancialmente mesmo
  em uma atualização de correção de bug para um plugin,
  quebrando seus testes inesperadamente.
* Canais de plataforma podem diferir em cada implementação
  de um plugin federado. Por exemplo,
  você pode configurar canais de plataforma mock para
  fazer os testes passarem em uma máquina Windows,
  então descobrir que eles falham se executados no macOS ou Linux.
* Canais de plataforma não são fortemente tipados.
  Por exemplo, canais de método frequentemente usam dicionários
  e você tem que ler a implementação do plugin
  para saber quais são as strings-chave e tipos de valor.

Devido a essas limitações, `TestDefaultBinaryMessenger`
é principalmente útil nos testes internos
de implementações de plugins,
em vez de testes de código usando plugins.

Você também pode querer conferir
[Testing plugins][].

[platform channels]: /platform-integration/platform-channels
[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[Testing plugins]: /testing/testing-plugins
