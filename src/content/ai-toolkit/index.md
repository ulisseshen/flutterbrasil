---
ia-translate: true
title: AI Toolkit
description: >
  Aprenda como adicionar o chatbot AI Toolkit ao seu
  aplicativo Flutter.
next:
  title: Experiência do usuário
  path: /ai-toolkit/user-experience
revised: true
---

Olá e bem-vindo ao Flutter AI Toolkit!

O AI Toolkit é um conjunto de widgets relacionados ao chat de IA que facilitam
a adição de uma janela de chat de IA ao seu aplicativo Flutter. O AI Toolkit
é organizado em torno de uma API abstrata de provedor
de LLM para facilitar a troca do provedor de LLM que você gostaria
que seu provedor de chat usasse.
Ele já vem com suporte para duas integrações de provedores de LLM:
Google Gemini AI e Firebase Vertex AI.

## Principais recursos

* **Chat multi-turn**: Mantém o contexto em várias interações.
* **Respostas de streaming**: Exibe respostas de IA em tempo real
  à medida que são geradas.
* **Exibição de rich text**: Suporta texto formatado em mensagens de chat.
* **Entrada de voz**: Permite que os usuários insiram prompts usando a fala.
* **Anexos multimídia**: Permite o envio e o recebimento de
  vários tipos de mídia.
* **Estilo personalizado**: Oferece ampla personalização para corresponder ao
  design do seu aplicativo.
* **Serialização/desserialização de chat**: Armazene e recupere conversas
  entre sessões de aplicativos.
* **Widgets de resposta personalizados**: Apresente componentes de UI especializados
  para apresentar respostas de LLM.
* **Suporte LLM plugável**: Implemente uma interface simples para
  conectar seu próprio LLM.
* **Suporte multiplataforma**: Compatível com plataformas Android,
    iOS, web e macOS.

## Demonstração Online

Aqui está a demonstração online hospedando o AI Toolkit:

<a href="https://flutter-ai-toolkit-examp-60bad.web.app/">
<img src="/assets/images/docs/ai-toolkit/ai-toolkit-app.png" alt="Aplicativo de demonstração de IA">
</a>

O [código-fonte desta demonstração][src-code] está disponível no repositório no GitHub.

[src-code]: {{site.github}}/flutter/ai/blob/main/example/lib/demo/demo.dart

## Começar

<ol>
<li><b>Instalação</b>

Adicione as seguintes dependências ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_ai_toolkit: ^latest_version
  google_generative_ai: ^latest_version # você pode optar por usar Gemini,
  firebase_core: ^latest_version        # ou Vertex AI ou ambos
```
</li>

<li><b>Configuração do Gemini AI</b>

O toolkit oferece suporte tanto ao Google Gemini AI
quanto ao Firebase Vertex AI como provedores de LLM. Para usar
o Google Gemini AI,
[obtenha uma chave de API][] do Gemini AI Studio.
Tenha cuidado para não incluir esta chave no seu repositório de código-fonte
para evitar acesso não autorizado.

[obtenha uma chave de API]: https://aistudio.google.com/app/apikey

Você também precisará escolher um nome de modelo Gemini
específico para usar na criação de uma instância do modelo
Gemini. O exemplo a seguir usa gemini-1.5-flash, mas você pode
escolher em um [conjunto cada vez maior de modelos][models].

[models]: https://ai.google.dev/gemini-api/docs/models/gemini


```dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

... // coisas do app aqui

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: GeminiProvider(
            model: GenerativeModel(
              model: 'gemini-1.5-flash',
              apiKey: 'GEMINI-API-KEY',
            ),
          ),
        ),
      );
}
```

A classe `GenerativeModel` vem do
pacote `google_generative_ai`.
O AI Toolkit se baseia neste pacote com o `GeminiProvider`,
que conecta o Gemini AI ao `LlmChatView`, o widget de nível
superior que fornece uma conversa de chat baseada
em LLM com seus usuários.

Para um exemplo completo, confira [`gemini.dart`][] no GitHub.

[`gemini.dart`]: {{site.github}}/flutter/ai/blob/main/example/lib/gemini/gemini.dart
</li>

<li><b>Configuração do Vertex AI</b>

Embora o Gemini AI seja útil para prototipagem rápida,
a solução recomendada para aplicativos de produção é
o Vertex AI no Firebase. Isso elimina a necessidade
de uma chave de API no seu aplicativo cliente e a substitui
por um projeto Firebase mais seguro.
Para usar o Vertex AI no seu projeto,
siga as etapas descritas na documentação
[Começar com a API Gemini usando os SDKs do Vertex AI no Firebase][vertex].

[vertex]: https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter

Depois de concluir, integre o novo projeto Firebase ao seu aplicativo Flutter
usando a ferramenta `flutterfire CLI`, conforme descrito na documentação
[Adicionar o Firebase ao seu aplicativo Flutter][firebase].

[firebase]: https://firebase.google.com/docs/flutter/setup

Depois de seguir estas instruções,
você está pronto para usar o Firebase Vertex AI no seu aplicativo Flutter.
Comece inicializando o Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

// ... outras importações

import 'firebase_options.dart'; // de `flutterfire config`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

// ... coisas do app aqui
```

Com o Firebase inicializado corretamente no seu aplicativo Flutter,
você agora está pronto para criar uma instância do provedor Vertex:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // crie a visualização de chat, passando o provedor Vertex
        body: LlmChatView(
          provider: VertexProvider(
            chatModel: FirebaseVertexAI.instance.generativeModel(
              model: 'gemini-1.5-flash',
            ),
          ),
        ),
      );
}
```


A classe `FirebaseVertexAI` vem do pacote `firebase_vertexai`.
O AI Toolkit constrói a classe `VertexProvider`
para expor o Vertex AI ao `LlmChatView`.
Observe que você fornece um nome de modelo ([você tem várias opções][options] para escolher),
mas não fornece uma chave de API.
Tudo isso é tratado como parte do projeto Firebase.

Para um exemplo completo, confira [vertex.dart][] no GitHub.

[options]: https://firebase.google.com/docs/vertex-ai/gemini-models#available-model-names
[vertex.dart]: {{site.github}}/flutter/ai/blob/main/example/lib/vertex/vertex.dart
</li>

<li><b>Configurar permissões do dispositivo</b>

Para permitir que seus usuários aproveitem recursos como
entrada de voz e anexos de mídia, certifique-se de que seu
aplicativo tenha as permissões necessárias:

* **Acesso ao microfone**: Configure de acordo com as
  [instruções de configuração de permissão do pacote record][record].
* **Seleção de arquivo**: Siga as [instruções do plugin file_selector][file].
* **Seleção de imagem**: Para tirar uma foto _ou_ selecionar uma foto do seu
  dispositivo, consulte as
  [instruções de instalação do plugin image_picker][image_picker].
* **Foto da web**: Para tirar uma foto na web, configure o aplicativo
  de acordo com as [instruções de configuração do plugin camera][camera].

[camera]: {{site.pub-pkg}}/camera#setup
[file]: {{site.pub-pkg}}/file_selector#usage
[image_picker]: {{site.pub-pkg}}/image_picker#installation
[record]: {{site.pub-pkg}}/record#setup-permissions-and-others
</li>
</ol>

## Exemplos

Para executar os [aplicativos de exemplo][] no repositório,
você precisará substituir os arquivos `example/lib/gemini_api_key.dart`
e `example/lib/firebase_options.dart`, que são apenas
espaços reservados. Eles são necessários para
ativar os projetos de exemplo na pasta `example/lib`.

**gemini_api_key.dart**

A maioria dos aplicativos de exemplo depende de uma chave de API Gemini,
portanto, para que eles funcionem, você precisará inserir sua chave de API
no arquivo `example/lib/gemini_api_key.dart`.
Você pode obter uma chave de API no [Gemini AI Studio][].

:::note
**Tenha cuidado para não incluir o arquivo `gemini_api_key.dart` no seu repositório git.**
:::

**firebase_options.dart**

Para usar o [aplicativo de exemplo do Vertex AI][vertex-ex],
coloque os detalhes de configuração do Firebase
no arquivo `example/lib/firebase_options.dart`.
Você pode fazer isso com a ferramenta `flutterfire CLI`
conforme descrito na documentação [Adicionar o Firebase ao seu aplicativo Flutter][add-fb]
**de dentro do diretório `example`**.

:::note
**Tenha cuidado para não incluir o arquivo `firebase_options.dart`
no seu repositório git.**
:::

## Feedback!

Ao longo do caminho, ao usar este pacote, por favor,
[registre problemas e solicitações de recursos][file-issues],
bem como envie qualquer [código que você gostaria de contribuir][submit].
Queremos seu feedback e suas contribuições para garantir
que o AI Toolkit seja o mais robusto e útil possível
para seus aplicativos do mundo real.

[add-fb]: https://firebase.google.com/docs/flutter/setup
[aplicativos de exemplo]: {{site.github}}/flutter/ai/tree/main/example/lib
[file-issues]: {{site.github}}/flutter/ai/issues
[Gemini AI Studio]: https://aistudio.google.com/app/apikey
[submit]: {{site.github}}/flutter/ai/pulls
[vertex-ex]: {{site.github}}/flutter/ai/blob/main/example/lib/vertex/vertex.dart
