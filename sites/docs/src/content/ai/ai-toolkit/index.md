---
ia-translate: true
title: Flutter AI Toolkit
shortTitle: AI Toolkit
description: >
  Aprenda como adicionar o chatbot AI Toolkit
  ao seu aplicativo Flutter.
next:
  title: User experience
  path: /ai/ai-toolkit/user-experience
---

Olá e bem-vindo ao Flutter AI Toolkit!

O AI Toolkit é um conjunto de widgets relacionados a chat de IA que facilitam
adicionar uma janela de chat de IA ao seu app Flutter. O AI Toolkit é organizado em torno de uma
API abstrata de provedor LLM para facilitar a troca do provedor LLM que
você gostaria que seu provedor de chat usasse. Pronto para uso, ele vem com suporte para
[Firebase AI Logic][].

[Firebase AI Logic]: https://firebase.google.com/docs/ai-logic

## Recursos principais {:#key-features}

* **Chat multi-turno**: Mantém contexto em múltiplas interações.
* **Respostas em streaming**: Exibe respostas de IA em tempo real conforme são
  geradas.
* **Exibição de texto rico**: Suporta texto formatado em mensagens de chat.
* **Entrada por voz**: Permite aos usuários inserir prompts usando fala.
* **Anexos multimídia**: Permite enviar e receber vários tipos de mídia.
* **Function calling**: Suporta chamadas de ferramentas (tool calls) ao provedor LLM.
* **Estilização personalizada**: Oferece extensa customização para combinar com o design do seu app.
* **Serialização/desserialização de chat**: Armazene e recupere conversas
  entre sessões do app.
* **Widgets de resposta personalizados**: Introduza componentes de UI especializados para apresentar
  respostas LLM.
* **Suporte a LLM plugável**: Implemente uma interface simples para conectar seu próprio
  LLM.
* **Suporte multiplataforma**: Compatível com plataformas Android, iOS, web e
  macOS.

## Demo {:#demo}

Veja como fica o exemplo de demonstração hospedando o AI Toolkit:

<img src="/assets/images/docs/ai-toolkit/ai-toolkit-app.png" alt="App de demonstração de IA">

O [código-fonte desta demo][src-code] está disponível no repositório no GitHub.

[src-code]: https://github.com/flutter/ai/blob/main/example/lib/demo/demo.dart

## Primeiros passos {:#get-started}

<ol>
<li><b>Instalação</b>

Adicione as seguintes dependências ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_ai_toolkit: ^latest_version
  firebase_ai: ^latest_version
  firebase_core: ^latest_version
```
</li>

<li><b>Configuração</b>

O AI Toolkit suporta tanto a Gemini Developer API (para prototipagem) quanto o
endpoint de produção do Firebase AI Logic. Ambos exigem um projeto Firebase e que o
pacote `firebase_core` seja inicializado, conforme descrito na documentação [Get started with
the Gemini API using the Firebase AI Logic SDKs][firebase_ai].

[firebase_ai]:
    https://firebase.google.com/docs/ai-logic/get-started?platform=flutter

Quando isso estiver completo, integre o novo projeto Firebase no seu app Flutter
usando a ferramenta `flutterfire CLI`, conforme descrito na documentação [Add Firebase to your
Flutter app][firebase].

[firebase]: https://firebase.google.com/docs/flutter/setup

Após seguir estas instruções, você está pronto para usar o Firebase para integrar IA
no seu app Flutter. Comece inicializando o Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// ... outros imports

import 'firebase_options.dart'; // de `flutterfire config`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

// ...código do app aqui
```

Com o Firebase devidamente inicializado no seu app Flutter, você está agora pronto para
criar uma instância do provedor Firebase. Você pode fazer isso de duas formas. Para
prototipagem, considere o endpoint do Gemini AI:

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// ... código do app aqui

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // cria a visualização de chat, passando o provedor Firebase
        body: LlmChatView(
          provider: FirebaseProvider(
            // Usa o endpoint do Google AI
            model: FirebaseAI.googleAI().generativeModel(
              model: 'gemini-2.5-flash',
            ),
          ),
        ),
      );
}
```

A classe `FirebaseProvider` expõe o SDK do Firebase AI Logic ao
`LlmChatView`. Note que você fornece um nome de modelo ([você tem várias
opções][options] para escolher), mas você não fornece uma chave de API. Tudo
isso é tratado como parte do projeto Firebase.

Para cargas de trabalho de produção, é fácil trocar para o endpoint de produção do Firebase AI Logic:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: FirebaseProvider(
            // Usa o endpoint de produção
            model: FirebaseAI.vertexAI().generativeModel(
              model: 'gemini-2.5-flash',
            ),
          ),
        ),
      );
}
```


Para um exemplo completo, confira os exemplos [gemini.dart] e [vertex.dart][].

[options]:
    https://firebase.google.com/docs/ai-logic/models
[gemini.dart]:
    https://github.com/flutter/ai/blob/main/example/lib/gemini/gemini.dart
[vertex.dart]:
    https://github.com/flutter/ai/blob/main/example/lib/vertex/vertex.dart
</li>

<li><b>Configure as permissões do dispositivo</b>

Para permitir que seus usuários aproveitem recursos como entrada por voz e anexos
de mídia, certifique-se de que seu app tenha as permissões necessárias:

* **Acesso à rede:** Para habilitar acesso à rede no macOS, adicione o seguinte aos
  seus arquivos `*.entitlements`:

  ```xml
  <plist version="1.0">
    <dict>
      ...
      <key>com.apple.security.network.client</key>
      <true/>
    </dict>
  </plist>
  ```

  Para habilitar acesso à rede no Android, certifique-se de que seu arquivo `AndroidManifest.xml`
  contém o seguinte:

  ```xml
  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
      ...
      <uses-permission android:name="android.permission.INTERNET"/>
  </manifest>
  ```

* **Acesso ao microfone**: Configure de acordo com as [instruções de configuração de
  permissão do pacote record][record].
* **Seleção de arquivo**: Siga as [instruções do plugin file_selector][file].
* **Seleção de imagem**: Para tirar uma foto _ou_ selecionar uma foto de seu
  dispositivo, consulte as [instruções de instalação do plugin
  image_picker][image_picker].
* **Foto na web**: Para tirar uma foto na web, configure o app de acordo com
  as [instruções de configuração do plugin camera][camera].

[camera]: {{site.pub-pkg}}/camera#setup
[file]: {{site.pub-pkg}}/file_selector#usage
[image_picker]: {{site.pub-pkg}}/image_picker#installation
[record]: {{site.pub-pkg}}/record#setup-permissions-and-others
</li>
</ol>

## Exemplos {:#examples}

**firebase_options.dart**

Para usar o [app de exemplo do Firebase AI Logic][vertex-ex],
coloque seus detalhes de configuração do Firebase no arquivo
`example/lib/firebase_options.dart`.
Você pode fazer isso com a ferramenta `flutterfire CLI` conforme descrito na
documentação [Add Firebase to your Flutter app][add-fb]
**a partir do diretório `example`**.

:::note Considerações de segurança para `firebase_options.dart`

Se o seu app Flutter chama as APIs do Gemini diretamente do cliente,
não faça commit de `firebase_options.dart` em um repositório público.
Qualquer pessoa poderia reutilizar a configuração do seu app para enviar requisições ao seu endpoint de IA,
consumindo cota e potencialmente gerando custos de cobrança.

Embora este guia mostre chamadas diretas do lado do cliente por simplicidade, para apps
de produção você deve rotear as requisições de IA por meio de um serviço de backend (por exemplo, [Cloud
Functions for Firebase](https://firebase.google.com/docs/functions), [Cloud
Run](https://cloud.google.com/run) ou seu próprio servidor). Nessa configuração, o
backend — não o cliente — controla o acesso, e incluir
`firebase_options.dart` no seu repositório é seguro.

Você também deve revisar e seguir a [checklist de segurança do Firebase](https://firebase.google.com/support/guides/security-checklist).
:::

## Feedback {:#feedback}

Ao longo do caminho, conforme você usa este pacote, por favor [registre problemas e solicitações
de recursos][file-issues] bem como envie qualquer [código que você gostaria de
contribuir][submit]. Queremos seu feedback e suas contribuições para garantir que
o AI Toolkit seja tão robusto e útil quanto pode ser para seus apps do mundo
real.

[add-fb]: https://firebase.google.com/docs/flutter/setup
[example apps]: https://github.com/flutter/ai/tree/main/example/lib
[file-issues]: https://github.com/flutter/ai/issues
[submit]: https://github.com/flutter/ai/pulls
[vertex-ex]: https://github.com/flutter/ai/blob/main/example/lib/vertex/vertex.dart
