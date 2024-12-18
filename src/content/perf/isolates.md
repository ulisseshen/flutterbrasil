---
ia-translate: true
title: Concorrência e Isolates
description: Multithreading em Flutter usando isolates Dart.
---

<?code-excerpt path-base="perf/concurrency/isolates/"?>

Todo o código Dart é executado em [isolates]({{site.dart-site}}/language/concurrency),
que são semelhantes a threads,
mas diferem no fato de que os isolates têm sua própria memória isolada.
Eles não compartilham estado de forma alguma,
e só podem se comunicar por mensagens.
Por padrão,
os aplicativos Flutter fazem todo o seu trabalho em um único isolate –
o isolate principal.
Na maioria dos casos, esse modelo permite uma programação mais simples e
é rápido o suficiente para que a UI do aplicativo não fique sem resposta.

Às vezes, porém,
os aplicativos precisam realizar cálculos excepcionalmente grandes
que podem causar "jank na UI" (movimento instável).
Se seu aplicativo está enfrentando jank por esse motivo,
você pode mover esses cálculos para um isolate auxiliar.
Isso permite que o ambiente de tempo de execução subjacente
execute o cálculo simultaneamente
com o trabalho do isolate da UI principal
e aproveita os dispositivos multi-core.

Cada isolate tem sua própria memória
e seu próprio loop de eventos.
O loop de eventos processa
eventos na ordem em que são adicionados a uma fila de eventos.
No isolate principal,
esses eventos podem ser qualquer coisa, desde o tratamento de um toque do usuário na UI,
até a execução de uma função,
até a pintura de um frame na tela.
A figura a seguir mostra um exemplo de fila de eventos
com 3 eventos aguardando para serem processados.

![O diagrama do isolate principal](/assets/images/docs/development/concurrency/basics-main-isolate.png){:width="50%"}

Para uma renderização suave,
o Flutter adiciona um evento de "pintar frame" à fila de eventos
60 vezes por segundo (para um dispositivo de 60Hz).
Se esses eventos não forem processados a tempo,
o aplicativo apresentará jank na UI,
ou pior,
ficará totalmente sem resposta.

![Diagrama de jank de evento](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

Sempre que um processo não pode ser concluído em um intervalo de frame,
o tempo entre dois frames,
é uma boa ideia descarregar o trabalho para outro isolate
para garantir que o isolate principal possa produzir 60 frames por segundo.
Quando você cria um isolate no Dart,
ele pode processar o trabalho simultaneamente com o isolate principal,
sem bloqueá-lo.

Você pode ler mais sobre como os isolates
e o loop de eventos funcionam no Dart na
[página de concorrência][] da documentação do Dart.

[página de concorrência]: {{site.dart-site}}/language/concurrency

{% ytEmbed 'vl_AaCgudcY', 'Isolates e o loop de eventos | Flutter em Foco' %}

## Casos de uso comuns para isolates

Existe apenas uma regra rígida para quando você deve usar isolates,
e isso é quando cálculos grandes estão fazendo com que seu aplicativo Flutter
experimente jank na UI.
Esse jank acontece quando há qualquer cálculo que leva mais tempo do que
o intervalo de frame do Flutter.

![Diagrama de jank de evento](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

Qualquer processo _poderia_ levar mais tempo para ser concluído,
dependendo da implementação
e dos dados de entrada,
tornando impossível criar uma lista exaustiva de
quando você precisa considerar o uso de isolates.

Dito isso, os isolates são comumente usados para o seguinte:

- Leitura de dados de um banco de dados local
- Envio de notificações push
- Análise e decodificação de grandes arquivos de dados
- Processamento ou compressão de fotos, arquivos de áudio e arquivos de vídeo
- Conversão de arquivos de áudio e vídeo
- Quando você precisa de suporte assíncrono ao usar FFI
- Aplicação de filtragem a listas ou sistemas de arquivos complexos

## Passagem de mensagens entre isolates

Os isolates do Dart são uma implementação do [modelo Ator][].
Eles só podem se comunicar uns com os outros por passagem de mensagens,
o que é feito com objetos [`Port`][].
Quando as mensagens são "passadas" entre si,
elas geralmente são copiadas do isolate de envio para o
isolate de recebimento.
Isso significa que qualquer valor passado para um isolate,
mesmo que mutado nesse isolate,
não altera o valor no isolate original.

Os únicos [objetos que não são copiados quando passados][] para um isolate
são objetos imutáveis que não podem ser alterados de qualquer forma,
como uma String ou um byte não modificável.
Quando você passa um objeto imutável entre isolates,
uma referência a esse objeto é enviada pela porta,
em vez de o objeto ser copiado,
para melhor desempenho.
Como os objetos imutáveis não podem ser atualizados,
isso efetivamente retém o comportamento do modelo ator.

[`Port` objects]: {{site.dart.api}}/dart-isolate/ReceivePort-class.html
[objetos que não são copiados quando passados]: {{site.dart.api}}/dart-isolate/SendPort/send.html

Uma exceção a esta regra é
quando um isolate sai quando envia uma mensagem usando o método `Isolate.exit`.
Como o isolate de envio não existirá após enviar a mensagem,
ele pode passar a propriedade da mensagem de um isolate para o outro,
garantindo que apenas um isolate possa acessar a mensagem.

As duas primitivas de nível mais baixo que enviam mensagens são `SendPort.send`,
que faz uma cópia de uma mensagem mutável ao enviar,
e `Isolate.exit`,
que envia a referência à mensagem.
Tanto `Isolate.run` quanto `compute`
usam `Isolate.exit` por baixo dos panos.

## Isolates de curta duração

A maneira mais fácil de mover um processo para um isolate no Flutter é com
o método `Isolate.run`.
Este método cria um isolate,
passa um callback para o isolate criado para iniciar algum cálculo,
retorna um valor do cálculo,
e então desliga o isolate quando o cálculo é concluído.
Tudo isso acontece simultaneamente com o isolate principal,
e não o bloqueia.

![Diagrama do isolate](/assets/images/docs/development/concurrency/isolate-bg-worker.png){:width="50%"}

O método `Isolate.run` requer um único argumento,
uma função callback,
que é executada no novo isolate.
A assinatura da função deste callback deve ter exatamente
um argumento obrigatório, sem nome.
Quando o cálculo é concluído,
ele retorna o valor do callback para o isolate principal,
e sai do isolate criado.

Por exemplo,
considere este código que carrega um grande blob JSON de um arquivo,
e converte esse JSON em objetos Dart personalizados.
Se o processo de decodificação json não fosse descarregado para um novo isolate,
este método faria com que a UI
ficasse sem resposta por vários segundos.

<?code-excerpt "lib/main.dart (isolate-run)"?>
```dart
// Produz uma lista de 211.640 objetos de fotos.
// (O arquivo JSON tem ~20MB.)
Future<List<Photo>> getPhotos() async {
  final String jsonString = await rootBundle.loadString('assets/photos.json');
  final List<Photo> photos = await Isolate.run<List<Photo>>(() {
    final List<Object?> photoData = jsonDecode(jsonString) as List<Object?>;
    return photoData.cast<Map<String, Object?>>().map(Photo.fromJson).toList();
  });
  return photos;
}
```

Para um passo a passo completo de como usar Isolates para
analisar JSON em segundo plano, veja [esta receita do cookbook][].

[esta receita do cookbook]: /cookbook/networking/background-parsing

## Isolates com estado e de longa duração

Isolates de curta duração são convenientes de usar,
mas há uma sobrecarga de desempenho necessária para criar novos isolates,
e para copiar objetos de um isolate para outro.
Se você estiver fazendo o mesmo cálculo usando `Isolate.run` repetidamente,
você pode ter um melhor desempenho criando isolates que não saiam imediatamente.

Para fazer isso, você pode usar um punhado de APIs relacionadas a isolates de nível mais baixo que
`Isolate.run` abstrai:

- [`Isolate.spawn()`][] e [`Isolate.exit()`][]
- [`ReceivePort`][] e [`SendPort`][]
- Método [`send()`][]

Quando você usa o método `Isolate.run`,
o novo isolate é desligado imediatamente depois que
retorna uma única mensagem para o isolate principal.
Às vezes, você precisará de isolates que sejam de longa duração,
e pode passar várias mensagens entre si ao longo do tempo.
No Dart, você pode conseguir isso com a API Isolate
e Portas.
Esses isolates de longa duração são coloquialmente conhecidos como _background workers_.

Isolates de longa duração são úteis quando você tem um processo específico que
precisa ser executado repetidamente durante o tempo de vida do seu aplicativo,
ou se você tem um processo que é executado durante um período de tempo
e precisa gerar vários valores de retorno para o isolate principal.

Ou, você pode usar [worker_manager][] para gerenciar isolates de longa duração.

[worker_manager]: {{site.pub-pkg}}/worker_manager

### ReceivePorts e SendPorts

Configure a comunicação de longa duração entre isolates com duas classes
(além de Isolate):
[`ReceivePort`][] e [`SendPort`][].
Essas portas são a única maneira pela qual os isolates podem se comunicar entre si.

`Ports` se comportam de forma semelhante a `Streams`,
em que o `StreamController`
ou `Sink` é criado em um isolate,
e o listener é configurado no outro isolate.
Nesta analogia,
o `StreamConroller` é chamado de `SendPort`,
e você pode "adicionar" mensagens com o método `send()`.
`ReceivePort`s são os listeners,
e quando esses listeners recebem uma nova mensagem,
eles chamam um callback fornecido com a mensagem como um argumento.

Para uma explicação detalhada sobre como configurar a comunicação bidirecional
entre o isolate principal
e um worker isolate,
siga os exemplos na [documentação do Dart][].

[documentação do Dart]: {{site.dart-site}}/language/concurrency

## Usando plugins de plataforma em isolates

A partir do Flutter 3.7, você pode usar plugins de plataforma em isolates em segundo plano.
Isso abre muitas possibilidades para descarregar cálculos pesados,
dependentes da plataforma, para um isolate que não bloqueará sua UI.
Por exemplo, imagine que você está criptografando dados
usando uma API host nativa
(como uma API Android no Android, uma API iOS no iOS e assim por diante).
Anteriormente, [o marshaling de dados][] para a plataforma host poderia desperdiçar tempo do thread da UI,
e agora pode ser feito em um isolate em segundo plano.

Isolates de canal de plataforma usam a API [`BackgroundIsolateBinaryMessenger`][].
O snippet a seguir mostra um exemplo de uso
do pacote `shared_preferences` em um isolate em segundo plano.

<?code-excerpt "lib/isolate_binary_messenger.dart"?>
```dart
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Identifique o isolate raiz para passar para o isolate em segundo plano.
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
}

Future<void> _isolateMain(RootIsolateToken rootIsolateToken) async {
  // Registre o isolate em segundo plano com o isolate raiz.
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  // Agora você pode usar o plugin shared_preferences.
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  print(sharedPreferences.getBool('isDebug'));
}
```

## Limitações de Isolates

Se você está vindo para o Dart de uma linguagem com multithreading,
é razoável esperar que os isolates se comportem como threads,
mas esse não é o caso.
Isolates têm seus próprios campos globais,
e só podem se comunicar com passagem de mensagens,
garantindo que objetos mutáveis em um isolate sejam acessíveis apenas
em um único isolate.
Portanto, os isolates são limitados pelo acesso à sua própria memória.
Por exemplo,
se você tem um aplicativo com uma variável global mutável chamada `configuration`,
ela é copiada como um novo campo global em um isolate criado.
Se você alterar essa variável no isolate criado,
ela permanecerá intocada no isolate principal.
Isso é verdade mesmo se você passar o objeto `configuration` como uma mensagem
para o novo isolate.
É assim que os isolates devem funcionar,
e é importante ter isso em mente ao considerar o uso de isolates.

### Plataformas web e compute

Plataformas web Dart, incluindo Flutter web,
não suportam isolates.
Se você estiver visando a web com seu aplicativo Flutter,
você pode usar o método `compute` para garantir que seu código seja compilado.
O método [`compute()`][] executa o cálculo em
a thread principal na web,
mas cria uma nova thread em dispositivos móveis.
Em plataformas móveis e desktop
`await compute(fun, message)`
é equivalente a `await Isolate.run(() => fun(message))`.

Para mais informações sobre concorrência na web,
confira a [documentação de concorrência][] no dart.dev.

[documentação de concorrência]: {{site.dart-site}}/language/concurrency

### Sem acesso `rootBundle` ou métodos `dart:ui`

Todas as tarefas da UI e o próprio Flutter estão acoplados ao isolate principal.
Portanto,
você não pode acessar assets usando `rootBundle` em isolates criados,
nem pode executar nenhum widget
ou trabalho de UI em isolates criados.

### Mensagens de plugin limitadas da plataforma host para o Flutter

Com canais de plataforma de isolate em segundo plano,
você pode usar canais de plataforma em isolates para enviar mensagens para a plataforma host
(por exemplo, Android ou iOS),
e receber respostas para essas mensagens.
No entanto, você não pode receber mensagens não solicitadas da plataforma host.

Como exemplo,
você não pode configurar um listener Firestore de longa duração em um isolate em segundo plano,
porque o Firestore usa canais de plataforma para enviar atualizações para o Flutter,
que são não solicitadas.
Você pode, no entanto, consultar o Firestore para obter uma resposta em segundo plano.

## Mais informações

Para mais informações sobre isolates, confira os seguintes recursos:

- Se você estiver usando muitos isolates, considere a classe [IsolateNameServer][] no Flutter,
ou o pacote pub que clona a funcionalidade para aplicativos Dart que não usam
Flutter.
- Os Isolates do Dart são uma implementação do [modelo Ator][].
- [isolate_agents][] é um pacote que abstrai Portas e torna mais fácil criar isolates de longa duração.
- Leia mais sobre o anúncio da API `BackgroundIsolateBinaryMessenger` [anúncio][].

[anúncio]: {{site.flutter-medium}}/introducing-background-isolate-channels-7a299609cad8
[modelo Ator]: https://en.wikipedia.org/wiki/Actor_model
[isolate_agents]: {{site.medium}}/@gaaclarke/isolate-agents-easy-isolates-for-flutter-6d75bf69a2e7
[marshaling de dados]: https://en.wikipedia.org/wiki/Marshalling_(computer_science)
[`compute()`]: {{site.api}}/flutter/foundation/compute.html
[`Isolate.spawn()`]: {{site.dart.api}}/dart-isolate/Isolate/spawn.html
[`Isolate.exit()`]: {{site.dart.api}}/dart-isolate/Isolate/exit.html
[`ReceivePort`]: {{site.dart.api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart.api}}/dart-isolate/SendPort-class.html
[`send()`]: {{site.dart.api}}/dart-isolate/SendPort/send.html
[`BackgroundIsolateBinaryMessenger`]: {{site.api}}/flutter/services/BackgroundIsolateBinaryMessenger-class.html
[IsolateNameServer]: {{site.api}}/flutter/dart-ui/IsolateNameServer-class.html
