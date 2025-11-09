---
ia-translate: true
title: AI Toolkit
description: >
  Aprenda como adicionar o chatbot AI Toolkit
  ao seu aplicativo Flutter.
next:
  title: User experience
  path: /ai-toolkit/user-experience
---

Olá e bem-vindo ao Flutter AI Toolkit!

:::note
Estas páginas estão agora desatualizadas. Elas serão
atualizadas em breve mas, enquanto isso, esteja ciente de que os
pacotes `google_generative_ai` e `vertexai_firebase`
estão depreciados e substituídos por [`package:firebase_ai`][].
:::

[`package:firebase_ai`]: {{site.pub-pkg}}/firebase_ai

O AI Toolkit é um conjunto de widgets relacionados a chat de IA que facilitam
adicionar uma janela de chat de IA ao seu app Flutter.
O AI Toolkit é organizado em torno de uma API abstrata
de provedor LLM para facilitar a troca do
provedor LLM que você gostaria que seu provedor de chat usasse.
Pronto para uso, ele vem com suporte para duas integrações de
provedor LLM: Google Gemini AI e Firebase Vertex AI.

## Recursos principais

* **Chat multi-turno**: Mantém contexto em múltiplas interações.
* **Respostas em streaming**: Exibe respostas de IA em
  tempo real conforme são geradas.
* **Exibição de texto rico**: Suporta texto formatado em mensagens de chat.
* **Entrada por voz**: Permite aos usuários inserir prompts usando fala.
* **Anexos multimídia**: Permite enviar e
  receber vários tipos de mídia.
* **Estilização personalizada**: Oferece extensa customização para
  combinar com o design do seu app.
* **Serialização/desserialização de chat**: Armazene e recupere conversas
  entre sessões do app.
* **Widgets de resposta personalizados**: Introduza componentes de UI especializados
  para apresentar respostas LLM.
* **Suporte a LLM plugável**: Implemente uma interface simples para conectar
  seu próprio LLM.
* **Suporte multiplataforma**: Compatível com plataformas Android, iOS, web
  e macOS.

## Demo Online

Aqui está a demo online hospedando o AI Toolkit:

<a href="https://flutter-ai-toolkit-examp-60bad.web.app/">
<img src="/assets/images/docs/ai-toolkit/ai-toolkit-app.png" alt="AI demo app">
</a>

O [código-fonte desta demo][src-code] está disponível no repositório no GitHub.

Ou, você pode abri-la no [Firebase Studio][],
o workspace e IDE de IA full-stack do Google que roda na nuvem:

<a href="https://studio.firebase.google.com/new?template=https%3A%2F%2Fgithub.com%2Fflutter%2Fai">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.firebasestudio.dev/btn/try_light_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.firebasestudio.dev/btn/try_dark_32.svg">
    <img
      height="32"
      alt="Try in Firebase Studio"
      src="https://cdn.firebasestudio.dev/btn/try_blue_32.svg">
  </picture>
</a>

[src-code]: {{site.github}}/flutter/ai/blob/main/example/lib/demo/demo.dart
[Firebase Studio]: https://firebase.studio/

## Primeiros passos

<ol>
<li><b>Instalação</b>

Adicione as seguintes dependências ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_ai_toolkit: ^latest_version
  google_generative_ai: ^latest_version # você pode escolher usar Gemini,
  firebase_core: ^latest_version        # ou Vertex AI ou ambos
```
</li>

<li><b>Configuração do Gemini AI</b>

O toolkit suporta tanto Google Gemini AI quanto
Firebase Vertex AI como provedores LLM.
Para usar o Google Gemini AI,
[obtenha uma chave API][] do Gemini AI Studio.
Tenha cuidado para não fazer check-in desta chave no repositório
de código-fonte para prevenir acesso não autorizado.

[obtenha uma chave API]: https://aistudio.google.com/app/apikey

Você também precisará escolher um nome de modelo Gemini específico
para usar na criação de uma instância do modelo Gemini.
O exemplo a seguir usa `gemini-2.0-flash`,
mas você pode escolher de um [conjunto de modelos em expansão][models].

[models]: https://ai.google.dev/gemini-api/docs/models/gemini


```dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// ... código do app aqui

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: GeminiProvider(
            model: GenerativeModel(
              model: 'gemini-2.0-flash',
              apiKey: 'GEMINI-API-KEY',
            ),
          ),
        ),
      );
}
```

A classe `GenerativeModel` vem do
pacote `google_generative_ai`.
O AI Toolkit se baseia neste pacote com
o `GeminiProvider`, que conecta o Gemini AI ao
`LlmChatView`, o widget de nível superior que fornece uma
conversa de chat baseada em LLM com seus usuários.

Para um exemplo completo, confira [`gemini.dart`][] no GitHub.

[`gemini.dart`]: {{site.github}}/flutter/ai/blob/main/example/lib/gemini/gemini.dart
</li>

<li><b>Configuração do Vertex AI</b>

Enquanto o Gemini AI é útil para prototipagem rápida,
a solução recomendada para apps de produção é
Vertex AI no Firebase. Isso elimina a necessidade
de uma chave API em seu app cliente e a substitui
por um projeto Firebase mais seguro.
Para usar Vertex AI em seu projeto,
siga os passos descritos na
documentação [Get started with the Gemini API using the Vertex AI in Firebase SDKs][vertex].

[vertex]: https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter

Quando isso estiver completo, integre o novo projeto Firebase
no seu app Flutter usando a ferramenta `flutterfire CLI`,
conforme descrito na documentação [Add Firebase to your Flutter app][firebase].

[firebase]: https://firebase.google.com/docs/flutter/setup

Após seguir estas instruções,
você está pronto para usar Firebase Vertex AI em seu app Flutter.
Comece inicializando o Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
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

Com o Firebase devidamente inicializado em seu app Flutter,
você está agora pronto para criar uma instância do provedor Vertex:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // cria a visualização de chat, passando o provedor Vertex
        body: LlmChatView(
          provider: VertexProvider(
            chatModel: FirebaseVertexAI.instance.generativeModel(
              model: 'gemini-2.0-flash',
            ),
          ),
        ),
      );
}
```


A classe `FirebaseVertexAI` vem do
pacote `firebase_vertexai`. O AI Toolkit
constrói a classe `VertexProvider` para expor
Vertex AI ao `LlmChatView`.
Note que você fornece um nome de modelo
([você tem várias opções][options] para escolher),
mas você não fornece uma chave API.
Tudo isso é tratado como parte do projeto Firebase.

Para um exemplo completo, confira [vertex.dart][] no GitHub.

[options]: https://firebase.google.com/docs/vertex-ai/gemini-models#available-model-names
[vertex.dart]: {{site.github}}/flutter/ai/blob/main/example/lib/vertex/vertex.dart
</li>

<li><b>Configurar permissões do dispositivo</b>

Para permitir que seus usuários aproveitem recursos como entrada por voz e
anexos de mídia, certifique-se de que seu app tem as permissões necessárias:

* **Acesso à rede:**
  Para habilitar acesso à rede no macOS,
  adicione o seguinte aos seus arquivos `*.entitlements`:

  ```xml
  <plist version="1.0">
    <dict>
      ...
      <key>com.apple.security.network.client</key>
      <true/>
    </dict>
  </plist>
  ```

  Para habilitar acesso à rede no Android,
  certifique-se de que seu arquivo `AndroidManifest.xml` contém o seguinte:

  ```xml
  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
      ...
      <uses-permission android:name="android.permission.INTERNET"/>
  </manifest>
  ```

* **Acesso ao microfone**: Configure de acordo com as
  [instruções de configuração de permissão do pacote record][record].
* **Seleção de arquivo**: Siga as [instruções do plugin file_selector][file].
* **Seleção de imagem**: Para tirar uma foto _ou_ selecionar uma foto de seu
  dispositivo, consulte as
  [instruções de instalação do plugin image_picker][image_picker].
* **Foto na web**: Para tirar uma foto na web, configure o app
  de acordo com as [instruções de configuração do plugin camera][camera].

[camera]: {{site.pub-pkg}}/camera#setup
[file]: {{site.pub-pkg}}/file_selector#usage
[image_picker]: {{site.pub-pkg}}/image_picker#installation
[record]: {{site.pub-pkg}}/record#setup-permissions-and-others
</li>
</ol>

## Exemplos

Para executar os [apps de exemplo][] no repositório,
você precisará substituir os arquivos `example/lib/gemini_api_key.dart`
e `example/lib/firebase_options.dart`,
ambos os quais são apenas marcadores de posição. Eles são necessários
para habilitar os projetos de exemplo na pasta `example/lib`.

**gemini_api_key.dart**

A maioria dos apps de exemplo depende de uma chave API do Gemini,
então para que eles funcionem, você precisará conectar sua chave API
no arquivo `example/lib/gemini_api_key.dart`.
Você pode obter uma chave API no [Gemini AI Studio][].

:::note
**Tenha cuidado para não fazer check-in do arquivo `gemini_api_key.dart` no seu repositório git.**
:::

**firebase_options.dart**

Para usar o [app de exemplo Vertex AI][vertex-ex],
coloque seus detalhes de configuração do Firebase
no arquivo `example/lib/firebase_options.dart`.
Você pode fazer isso com a ferramenta `flutterfire CLI` conforme descrito
na documentação [Add Firebase to your Flutter app][add-fb]
**a partir do diretório `example`**.

:::note
**Tenha cuidado para não fazer check-in do arquivo `firebase_options.dart`
no seu repositório git.**
:::

## Feedback!

Ao longo do caminho, conforme você usa este pacote,
por favor [registre problemas e solicitações de recursos][file-issues] bem como
envie qualquer [código que você gostaria de contribuir][submit].
Queremos seu feedback e suas contribuições
para garantir que o AI Toolkit seja tão robusto e útil
quanto pode ser para seus apps do mundo real.

[add-fb]: https://firebase.google.com/docs/flutter/setup
[example apps]: {{site.github}}/flutter/ai/tree/main/example/lib
[file-issues]: {{site.github}}/flutter/ai/issues
[Gemini AI Studio]: https://aistudio.google.com/app/apikey
[submit]: {{site.github}}/flutter/ai/pulls
[vertex-ex]: {{site.github}}/flutter/ai/blob/main/example/lib/vertex/vertex.dart
