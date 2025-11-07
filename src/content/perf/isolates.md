---
ia-translate: true
title: Concorrência e isolates
description: Multithreading em Flutter usando isolates Dart.
---

<?code-excerpt path-base="perf/concurrency/isolates/"?>

Todo código Dart executa em [isolates]({{site.dart-site}}/language/concurrency),
que são similares a threads,
mas diferem pois isolates têm sua própria memória isolada.
Eles não compartilham estado de forma alguma,
e só podem se comunicar por mensagens.
Por padrão,
apps Flutter fazem todo seu trabalho em um único isolate –
o isolate principal (main isolate).
Na maioria dos casos, esse modelo permite programação mais simples e
é rápido o suficiente para que a UI da aplicação não se torne não responsiva.

Às vezes, porém,
aplicações precisam realizar computações excepcionalmente grandes
que podem causar "UI jank" (movimento travado).
Se seu app está experimentando jank por essa razão,
você pode mover essas computações para um isolate auxiliar.
Isso permite que o ambiente de runtime subjacente
execute a computação concorrentemente
com o trabalho do isolate principal da UI
e aproveita dispositivos multi-core.

Cada isolate tem sua própria memória
e seu próprio event loop.
O event loop processa
eventos na ordem em que são adicionados a uma fila de eventos.
No isolate principal,
esses eventos podem ser qualquer coisa desde lidar com um usuário tocando na UI,
até executar uma função,
até pintar um frame na tela.
A figura a seguir mostra um exemplo de fila de eventos
com 3 eventos esperando para serem processados.

![The main isolate diagram](/assets/images/docs/development/concurrency/basics-main-isolate.png){:width="50%"}

Para renderização suave,
Flutter adiciona um evento "paint frame" à fila de eventos
60 vezes por segundo (para um dispositivo de 60Hz).
Se esses eventos não forem processados a tempo,
a aplicação experimenta UI jank,
ou pior,
se torna completamente não responsiva.

![Event jank diagram](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

Sempre que um processo não pode ser completado em um frame gap,
o tempo entre dois frames,
é uma boa ideia transferir o trabalho para outro isolate
para garantir que o isolate principal possa produzir 60 frames por segundo.
Quando você cria um isolate no Dart,
ele pode processar o trabalho concorrentemente com o isolate principal,
sem bloqueá-lo.

Você pode ler mais sobre como isolates
e o event loop funcionam no Dart na
[página de concorrência][concurrency page] da documentação
do Dart.

[concurrency page]: {{site.dart-site}}/language/concurrency

{% ytEmbed 'vl_AaCgudcY', 'Isolates and the event loop | Flutter in Focus' %}

## Casos de uso comuns para isolates

Há apenas uma regra rígida para quando você deve usar isolates,
e é quando grandes computações estão fazendo sua aplicação Flutter
experimentar UI jank.
Esse jank acontece quando há qualquer computação que leva mais tempo do que
o frame gap do Flutter.

![Event jank diagram](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

Qualquer processo _poderia_ levar mais tempo para completar,
dependendo da implementação
e dos dados de entrada,
tornando impossível criar uma lista exaustiva de
quando você precisa considerar usar isolates.

Dito isso, isolates são comumente usados para o seguinte:

- Ler dados de um banco de dados local
- Enviar notificações push
- Analisar e decodificar arquivos de dados grandes
- Processar ou comprimir fotos, arquivos de áudio e arquivos de vídeo
- Converter arquivos de áudio e vídeo
- Quando você precisa de suporte assíncrono ao usar FFI
- Aplicar filtragem a listas complexas ou sistemas de arquivos

## Passagem de mensagens entre isolates

Os isolates do Dart são uma implementação do [modelo Actor][Actor model].
Eles só podem se comunicar uns com os outros por passagem de mensagens,
que é feita com [objetos `Port`][`Port` objects].
Quando mensagens são "passadas" entre si,
elas são geralmente copiadas do isolate remetente para o
isolate receptor.
Isso significa que qualquer valor passado para um isolate,
mesmo se modificado nesse isolate,
não muda o valor no isolate original.

Os únicos [objetos que não são copiados quando passados][objects that aren't copied when passed] para um isolate
são objetos imutáveis que não podem ser alterados de qualquer forma,
como uma String ou um byte não modificável.
Quando você passa um objeto imutável entre isolates,
uma referência a esse objeto é enviada através da porta,
em vez do objeto ser copiado,
para melhor desempenho.
Como objetos imutáveis não podem ser atualizados,
isso efetivamente retém o comportamento do modelo actor.

[`Port` objects]: {{site.dart.api}}/dart-isolate/ReceivePort-class.html
[objects that aren't copied when passed]: {{site.dart.api}}/dart-isolate/SendPort/send.html

Uma exceção a esta regra é
quando um isolate sai ao enviar uma mensagem usando o método `Isolate.exit`.
Como o isolate remetente não existirá após enviar a mensagem,
ele pode passar a propriedade da mensagem de um isolate para o outro,
garantindo que apenas um isolate possa acessar a mensagem.

As duas primitivas de nível mais baixo que enviam mensagens são `SendPort.send`,
que faz uma cópia de uma mensagem mutável ao enviá-la,
e `Isolate.exit`,
que envia a referência para a mensagem.
Tanto `Isolate.run` quanto `compute`
usam `Isolate.exit` nos bastidores.

## Isolates de curta duração

A maneira mais fácil de mover um processo para um isolate no Flutter é com
o método `Isolate.run`.
Este método cria um isolate,
passa um callback para o isolate criado para iniciar alguma computação,
retorna um valor da computação,
e então desliga o isolate quando a computação está completa.
Tudo isso acontece concorrentemente com o isolate principal,
e não o bloqueia.

![Isolate diagram](/assets/images/docs/development/concurrency/isolate-bg-worker.png){:width="50%"}

O método `Isolate.run` requer um único argumento,
uma função de callback,
que é executada no novo isolate.
A assinatura de função deste callback deve ter exatamente
um argumento obrigatório e sem nome.
Quando a computação completa,
ela retorna o valor do callback de volta para o isolate principal,
e sai do isolate criado.

Por exemplo,
considere este código que carrega um blob JSON grande de um arquivo,
e converte esse JSON em objetos Dart customizados.
Se o processo de decodificação json não fosse transferido para um novo isolate,
este método faria com que a UI
se tornasse não responsiva por vários segundos.

<?code-excerpt "lib/main.dart (isolate-run)"?>
```dart
// Produces a list of 211,640 photo objects.
// (The JSON file is ~20MB.)
Future<List<Photo>> getPhotos() async {
  final String jsonString = await rootBundle.loadString('assets/photos.json');
  final List<Photo> photos = await Isolate.run<List<Photo>>(() {
    final List<Object?> photoData = jsonDecode(jsonString) as List<Object?>;
    return photoData.cast<Map<String, Object?>>().map(Photo.fromJson).toList();
  });
  return photos;
}
```

Para um passo a passo completo de usar Isolates para
analisar JSON em segundo plano, veja [esta receita do cookbook][this cookbook recipe].

[this cookbook recipe]: /cookbook/networking/background-parsing

## Isolates stateful de longa duração

Isolates de curta duração são convenientes de usar,
mas há overhead de desempenho necessário para criar novos isolates,
e para copiar objetos de um isolate para outro.
Se você está fazendo a mesma computação usando `Isolate.run` repetidamente,
você pode ter melhor desempenho criando isolates que não saem imediatamente.

Para fazer isso, você pode usar um punhado de APIs de nível mais baixo relacionadas a isolates que
`Isolate.run` abstrai:

- [`Isolate.spawn()`][] e [`Isolate.exit()`][]
- [`ReceivePort`][] e [`SendPort`][]
- Método [`send()`][]

Quando você usa o método `Isolate.run`,
o novo isolate desliga imediatamente após
retornar uma única mensagem para o isolate principal.
Às vezes, você precisará de isolates de longa duração,
e que possam passar múltiplas mensagens entre si ao longo do tempo.
No Dart, você pode fazer isso com a API Isolate
e Ports.
Esses isolates de longa duração são coloquialmente conhecidos como _background workers_.

Isolates de longa duração são úteis quando você tem um processo específico que
precisa ser executado repetidamente durante a vida útil de sua aplicação,
ou se você tem um processo que executa durante um período de tempo
e precisa produzir múltiplos valores de retorno para o isolate principal.

Ou, você pode usar [worker_manager][] para gerenciar isolates de longa duração.

[worker_manager]: {{site.pub-pkg}}/worker_manager

### ReceivePorts e SendPorts

Configure comunicação de longa duração entre isolates com duas classes
(além de Isolate):
[`ReceivePort`][] e [`SendPort`][].
Essas portas são a única forma de isolates se comunicarem entre si.

`Ports` se comportam similarmente a `Streams`,
em que o `StreamController`
ou `Sink` é criado em um isolate,
e o listener é configurado no outro isolate.
Nesta analogia,
o `StreamController` é chamado de `SendPort`,
e você pode "adicionar" mensagens com o método `send()`.
`ReceivePort`s são os listeners,
e quando esses listeners recebem uma nova mensagem,
eles chamam um callback fornecido com a mensagem como argumento.

Para uma explicação aprofundada sobre configurar comunicação bidirecional
entre o isolate principal
e um isolate worker,
siga os exemplos na [documentação do Dart][Dart documentation].

[Dart documentation]: {{site.dart-site}}/language/concurrency

## Usando plugins de plataforma em isolates

A partir do Flutter 3.7, você pode usar plugins de plataforma em isolates de segundo plano.
Isso abre muitas possibilidades para transferir computações pesadas,
dependentes de plataforma para um isolate que não bloqueará sua UI.
Por exemplo, imagine que você está criptografando dados
usando uma API nativa do host
(como uma API Android no Android, uma API iOS no iOS, e assim por diante).
Anteriormente, [marshaling de dados][marshaling data] para a plataforma host poderia desperdiçar tempo da thread da UI,
e agora pode ser feito em um isolate de segundo plano.

Isolates de canal de plataforma usam a API [`BackgroundIsolateBinaryMessenger`][].
O seguinte trecho mostra um exemplo de usar
o pacote `shared_preferences` em um isolate de segundo plano.

<?code-excerpt "lib/isolate_binary_messenger.dart"?>
```dart
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Identify the root isolate to pass to the background isolate.
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
}

Future<void> _isolateMain(RootIsolateToken rootIsolateToken) async {
  // Register the background isolate with the root isolate.
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  // You can now use the shared_preferences plugin.
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  print(sharedPreferences.getBool('isDebug'));
}
```

## Limitações dos Isolates

Se você está vindo para o Dart de uma linguagem com multithreading,
é razoável esperar que isolates se comportem como threads,
mas esse não é o caso.
Isolates têm seus próprios campos globais,
e só podem se comunicar com passagem de mensagens,
garantindo que objetos mutáveis em um isolate sejam sempre acessíveis
apenas em um único isolate.
Portanto, isolates são limitados por seu acesso à sua própria memória.
Por exemplo,
se você tem uma aplicação com uma variável global mutável chamada `configuration`,
ela é copiada como um novo campo global em um isolate criado.
Se você modificar essa variável no isolate criado,
ela permanece intocada no isolate principal.
Isso é verdade mesmo se você passar o objeto `configuration` como uma mensagem
para o novo isolate.
É assim que isolates são destinados a funcionar,
e é importante ter isso em mente quando você considera usar isolates.

### Plataformas web e compute

Plataformas web Dart, incluindo Flutter web,
não suportam isolates.
Se você está visando a web com seu app Flutter,
você pode usar o método `compute` para garantir que seu código compile.
O método [`compute()`][] executa a computação na
main thread na web,
mas cria uma nova thread em dispositivos móveis.
Em plataformas móveis e desktop
`await compute(fun, message)`
é equivalente a `await Isolate.run(() => fun(message))`.

Para mais informações sobre concorrência na web,
confira a [documentação de concorrência][concurrency documentation] em dart.dev.

[concurrency documentation]: {{site.dart-site}}/language/concurrency

### Sem acesso ao `rootBundle` ou métodos `dart:ui`

Todas as tarefas de UI e o próprio Flutter estão acoplados ao isolate principal.
Portanto,
você não pode acessar assets usando `rootBundle` em isolates criados,
nem pode realizar qualquer trabalho de widget
ou UI em isolates criados.

### Mensagens limitadas de plugin da plataforma host para Flutter

Com canais de plataforma de isolate de segundo plano,
você pode usar canais de plataforma em isolates para enviar mensagens para a plataforma host
(por exemplo, Android ou iOS),
e receber respostas a essas mensagens.
No entanto, você não pode receber mensagens não solicitadas da plataforma host.

Como exemplo,
você não pode configurar um listener Firestore de longa duração em um isolate de segundo plano,
porque Firestore usa canais de plataforma para enviar atualizações para Flutter,
que não são solicitadas.
Você pode, no entanto, consultar Firestore para uma resposta em segundo plano.

## Mais informações

Para mais informações sobre isolates, confira os seguintes recursos:

- Se você está usando muitos isolates, considere a classe [IsolateNameServer][] no Flutter,
ou o pacote pub que clona a funcionalidade para aplicações Dart que não usam
Flutter.
- Isolates do Dart são uma implementação do [modelo Actor][Actor model].
- [isolate_agents][] é um pacote que abstrai Ports e facilita a criação de isolates de longa duração.
- Leia mais sobre o anúncio da API `BackgroundIsolateBinaryMessenger` [aqui][announcement].

[announcement]: {{site.flutter-medium}}/introducing-background-isolate-channels-7a299609cad8
[Actor model]: https://en.wikipedia.org/wiki/Actor_model
[isolate_agents]: {{site.medium}}/@gaaclarke/isolate-agents-easy-isolates-for-flutter-6d75bf69a2e7
[marshaling data]: https://en.wikipedia.org/wiki/Marshalling_(computer_science)
[`compute()`]: {{site.api}}/flutter/foundation/compute.html
[`Isolate.spawn()`]: {{site.dart.api}}/dart-isolate/Isolate/spawn.html
[`Isolate.exit()`]: {{site.dart.api}}/dart-isolate/Isolate/exit.html
[`ReceivePort`]: {{site.dart.api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart.api}}/dart-isolate/SendPort-class.html
[`send()`]: {{site.dart.api}}/dart-isolate/SendPort/send.html
[`BackgroundIsolateBinaryMessenger`]: {{site.api}}/flutter/services/BackgroundIsolateBinaryMessenger-class.html
[IsolateNameServer]: {{site.api}}/flutter/dart-ui/IsolateNameServer-class.html
