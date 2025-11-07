---
title: Comunique-se com WebSockets
description: Como conectar a um web socket.
ia-translate: true
---

<?code-excerpt path-base="cookbook/networking/web_sockets/"?>

Além de requisições HTTP normais,
você pode se conectar a servidores usando `WebSockets`.
`WebSockets` permitem comunicação bidirecional com um servidor
sem polling.

Neste exemplo, conecte-se a um
[servidor WebSocket de teste patrocinado por Lob.com][test WebSocket server sponsored by Lob.com].
O servidor envia de volta a mesma mensagem que você envia para ele.
Esta receita usa os seguintes passos:

  1. Conecte-se a um servidor WebSocket.
  2. Ouça mensagens do servidor.
  3. Envie dados para o servidor.
  4. Feche a conexão WebSocket.

## 1. Conecte-se a um servidor WebSocket

O pacote [`web_socket_channel`][] fornece as
ferramentas necessárias para se conectar a um servidor WebSocket.

O pacote fornece um `WebSocketChannel`
que permite ouvir mensagens
do servidor e enviar mensagens para o servidor.

No Flutter, use a seguinte linha para
criar um `WebSocketChannel` que se conecta a um servidor:

<?code-excerpt "lib/main.dart (connect)" replace="/_channel/channel/g"?>
```dart
final channel = WebSocketChannel.connect(
  Uri.parse('wss://echo.websocket.events'),
);
```

## 2. Ouça mensagens do servidor

Agora que você estabeleceu uma conexão,
ouça as mensagens do servidor.

Depois de enviar uma mensagem para o servidor de teste,
ele envia a mesma mensagem de volta.

Neste exemplo, use um widget [`StreamBuilder`][]
para ouvir novas mensagens e um
widget [`Text`][] para exibi-las.

<?code-excerpt "lib/main.dart (StreamBuilder)" replace="/_channel/channel/g"?>
```dart
StreamBuilder(
  stream: channel.stream,
  builder: (context, snapshot) {
    return Text(snapshot.hasData ? '${snapshot.data}' : '');
  },
)
```

### Como isso funciona

O `WebSocketChannel` fornece um
[`Stream`][] de mensagens do servidor.

A classe `Stream` é uma parte fundamental do pacote `dart:async`.
Ela fornece uma maneira de ouvir eventos assíncronos de uma fonte de dados.
Diferente de `Future`, que retorna uma única resposta assíncrona,
a classe `Stream` pode entregar muitos eventos ao longo do tempo.

O widget [`StreamBuilder`][] se conecta a um `Stream`
e pede ao Flutter para reconstruir toda vez que
recebe um evento usando a função `builder()` fornecida.

## 3. Envie dados para o servidor

Para enviar dados para o servidor,
`add()` mensagens ao `sink` fornecido
pelo `WebSocketChannel`.

<?code-excerpt "lib/main.dart (add)" replace="/_channel/channel/g;/_controller.text/'Hello!'/g"?>
```dart
channel.sink.add('Hello!');
```

### Como isso funciona

O `WebSocketChannel` fornece um
[`StreamSink`][] para enviar mensagens ao servidor.

A classe `StreamSink` fornece uma maneira geral de adicionar eventos síncronos ou assíncronos
a uma fonte de dados.

## 4. Feche a conexão WebSocket

Depois de terminar de usar o WebSocket, feche a conexão:

<?code-excerpt "lib/main.dart (close)" replace="/_channel/channel/g"?>
```dart
channel.sink.close();
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
```
![Web sockets demo](/assets/images/docs/cookbook/web-sockets.gif){:.site-mobile-screenshot}


[`Stream`]: {{site.api}}/flutter/dart-async/Stream-class.html
[`StreamBuilder`]: {{site.api}}/flutter/widgets/StreamBuilder-class.html
[`StreamSink`]: {{site.api}}/flutter/dart-async/StreamSink-class.html
[test WebSocket server sponsored by Lob.com]: https://www.lob.com/blog/websocket-org-is-down-here-is-an-alternative
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`web_socket_channel`]: {{site.pub-pkg}}/web_socket_channel
