---
ia-translate: true
title: Firebase
description: >-
  Conecte seu app Flutter ao Firebase para autenticação, Cloud Firestore,
  Firebase SQL Connect, armazenamento em nuvem, recursos de IA e funções
  Dart serverless.
---

Firebase é a plataforma de desenvolvimento de apps do Google que fornece serviços
de backend gerenciados para apps Flutter em dispositivos móveis, web e desktop.
Cada serviço do Firebase está disponível como um plugin Flutter do Firebase
separado no pub.dev, para que você possa adicionar apenas os serviços de que seu app precisa:

| Serviço | Caso de uso | Pacote |
|---|---|---|
| [Cloud Firestore][] | Banco de dados de documentos NoSQL com sincronização em tempo real e cache offline integrado | [`cloud_firestore`][] |
| [Firebase SQL Connect][] | Banco de dados PostgreSQL gerenciado com SDKs Dart gerados e com segurança de tipos | [`firebase_data_connect`][] |
| [Firebase Authentication][firebase-auth] | Login de usuários com e-mail, telefone e provedores como Google ou Apple | [`firebase_auth`][] |
| [Cloud Storage for Firebase][firebase-storage] | Uploads e downloads de arquivos para fotos, vídeos e documentos de usuários | [`firebase_storage`][] |
| [Firebase AI Logic][firebase-ai] | Acesso direto do cliente aos modelos Gemini e Imagen | [`firebase_ai`][] |
| [Cloud Functions for Firebase][firebase-functions-dart] | Lógica de backend serverless escrita em JavaScript, TypeScript, Python ou Dart (experimental) | [`cloud_functions`][] (cliente), [`firebase_functions`][] (servidor) |
| [Firebase Crashlytics][crashlytics] | Relatórios de falhas e diagnósticos em tempo real | [`firebase_crashlytics`][] |

{:.table .table-striped}

Para uma lista completa de pacotes suportados e disponibilidade por plataforma,
confira [Plugins Flutter do Firebase disponíveis][Firebase plugins].

## Conectar um app Flutter ao Firebase

Para registrar seu app Flutter em um projeto Firebase e gerar
arquivos de configuração de plataforma, use a Firebase CLI e a FlutterFire CLI:

1. Instale a [Firebase CLI][] e faça login na sua Conta do Google:

   ```console
   $ firebase login
   ```

2. Instale a FlutterFire CLI globalmente:

   ```console
   $ dart pub global activate flutterfire_cli
   ```

3. Na raiz do seu projeto Flutter, adicione o plugin core e execute
   o fluxo de configuração:

   ```console
   $ flutter pub add firebase_core
   $ flutterfire configure
   ```

   Este comando registra seus apps por plataforma no seu projeto
   Firebase e gera `lib/firebase_options.dart`.

4. Inicialize o Firebase em `lib/main.dart` antes de chamar `runApp()`:

   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'package:flutter/material.dart';
   import 'firebase_options.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(const MyApp());
   }
   ```

Para instruções detalhadas de configuração por plataforma, consulte
[Adicionar o Firebase ao seu app Flutter][started].

## Autenticar usuários com Firebase Authentication

O [Firebase Authentication][firebase-auth] suporta login com e-mail
e senha, números de telefone, sessões anônimas e provedores de
identidade federada como Google, Apple e GitHub.

Para adicionar o Firebase Authentication ao seu app, instale [`firebase_auth`][]:

```console
$ flutter pub add firebase_auth
```

Você pode escutar `FirebaseAuth.instance.authStateChanges()` com um
`StreamBuilder` para reagir sempre que um usuário fizer login ou logout:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomeScreen(user: snapshot.data!);
        }
        // Your own sign-in UI.
        return const SignInScreen();
      },
    );
  }
}

Future<UserCredential> signInWithEmail(String email, String password) {
  return FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
```

Para saber mais, confira
[Começar a usar o Firebase Authentication no Flutter][firebase-auth] ou
o [codelab de autenticação com FirebaseUI][auth-codelab].

## Armazenar e sincronizar dados NoSQL com Cloud Firestore

O [Cloud Firestore][] é a opção padrão recomendada quando seu app precisa de um
banco de dados NoSQL escalável que sincroniza dados entre dispositivos em tempo real e
oferece cache e persistência offline, como em apps de chat,
ferramentas colaborativas ou apps de serviço de campo que precisam continuar funcionando
com uma conexão instável. Para comparar o Cloud Firestore com
opções de armazenamento relacional e local, confira
[Escolher um banco de dados para seu app Flutter][choose-db].

Para adicionar o Cloud Firestore ao seu projeto, execute:

```console
$ flutter pub add cloud_firestore
```

O exemplo a seguir adiciona um documento de tarefa a uma coleção `tasks` e
transmite os resultados da consulta em tempo real para uma `ListView`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addTask(String title) {
  return FirebaseFirestore.instance.collection('tasks').add({
    'title': title,
    'completed': false,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // Create the stream once so that it isn't recreated on every rebuild.
  final Stream<QuerySnapshot<Map<String, dynamic>>> _tasksStream =
      FirebaseFirestore.instance
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _tasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();
            return ListTile(
              title: Text(data['title'] as String? ?? ''),
            );
          },
        );
      },
    );
  }
}
```

A persistência offline é habilitada por padrão no Android e nas plataformas
Apple (e pode ser habilitada na web), para que seu app possa ler e
gravar documentos em cache sem conexão de rede e sincronizar
automaticamente as mudanças quando a conectividade voltar. Para começar, siga o
[guia de início rápido do Cloud Firestore][firestore-quickstart].

## Consultar dados SQL relacionais com Firebase SQL Connect

Se o seu app precisa de um banco de dados relacional, o [Firebase SQL Connect][]
(antigo Firebase Data Connect) fornece um banco de dados PostgreSQL
gerenciado e gera um SDK Dart com segurança de tipos construído sobre o
pacote [`firebase_data_connect`][].

Para instalar o plugin, execute:

```console
$ flutter pub add firebase_data_connect
```

Para comparar o SQL Connect com o Cloud Firestore e o SQLite local, confira
[Escolher um banco de dados para seu app Flutter][choose-db]. Para configurar um
backend SQL Connect e chamá-lo a partir do Flutter, siga o guia para
[usar SDKs Flutter gerados][sql-connect-flutter].

## Compartilhar código Dart com um backend Firebase serverless

Quando seu app precisa de lógica personalizada no servidor, gatilhos em segundo plano ou
acesso administrativo aos serviços do Firebase, você pode escrever
[Cloud Functions for Firebase em Dart][firebase-functions-dart] usando
os pacotes [`firebase_functions`][] e [`firebase_admin_sdk`][].

:::note
O suporte a Dart no Cloud Functions for Firebase é experimental.
Você precisa habilitar o experimento `dartfunctions` na Firebase CLI
antes de executar `firebase init functions`, e as APIs podem mudar
antes de uma versão estável.
:::

Usar Dart tanto no seu frontend Flutter quanto no seu backend Firebase permite
compartilhar um único pacote Dart para modelos de dados, serialização JSON
e regras de validação entre cliente e servidor. Para aprender como
estruturar um workspace com pacote compartilhado, confira
[Compartilhando código entre apps Flutter e backends Dart][dart-server].

## Recursos Flutter e Firebase

Para saber mais sobre como construir apps Flutter com Firebase, confira os
seguintes recursos oficiais e da comunidade.

### Documentação e codelabs

* [Adicionar o Firebase ao seu app Flutter][started]
* [Escolher um banco de dados para seu app Flutter][choose-db]
* [Codelab Conheça o Firebase para Flutter][codelab1]
* [Adicionar um fluxo de autenticação de usuário usando FirebaseUI][auth-codelab]
* [Documentação do Firebase AI Logic][firebase-ai]
* [Use Firebase para hospedar seu app Flutter na web][article]

### Vídeos

* [Vídeo workshop Conheça o Firebase para Flutter][workshop]
* [Usando Firestore como backend para seu app Flutter][video]
* [Live Coding Firebase Authentication com Flutter][video2]

[article]: {{site.flutter-blog}}/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469
[auth-codelab]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps
[choose-db]: /data-and-backend/persistence/choose-a-database
[Cloud Firestore]: {{site.firebase}}/docs/firestore
[`cloud_firestore`]: {{site.pub-pkg}}/cloud_firestore
[`cloud_functions`]: {{site.pub-pkg}}/cloud_functions
[codelab1]: {{site.codelabs}}/codelabs/firebase-get-to-know-flutter
[crashlytics]: {{site.firebase}}/docs/crashlytics/flutter/get-started
[dart-server]: {{site.dart-site}}/server#sharing-code-between-flutter-apps-and-dart-backends
[firebase-ai]: {{site.firebase}}/docs/ai-logic/get-started
[`firebase_ai`]: {{site.pub-pkg}}/firebase_ai
[`firebase_admin_sdk`]: {{site.pub-pkg}}/firebase_admin_sdk
[firebase-auth]: {{site.firebase}}/docs/auth/flutter/start
[`firebase_auth`]: {{site.pub-pkg}}/firebase_auth
[Firebase CLI]: {{site.firebase}}/docs/cli
[`firebase_crashlytics`]: {{site.pub-pkg}}/firebase_crashlytics
[`firebase_data_connect`]: {{site.pub-pkg}}/firebase_data_connect
[firebase-functions-dart]: {{site.firebase}}/docs/functions/start-dart
[`firebase_functions`]: {{site.pub-pkg}}/firebase_functions
[Firebase plugins]: {{site.firebase}}/docs/flutter/setup#available-plugins
[Firebase SQL Connect]: {{site.firebase}}/docs/sql-connect
[firebase-storage]: {{site.firebase}}/docs/storage/flutter/start
[`firebase_storage`]: {{site.pub-pkg}}/firebase_storage
[firestore-quickstart]: {{site.firebase}}/docs/firestore/quickstart
[sql-connect-flutter]: {{site.firebase}}/docs/sql-connect/flutter-sdk
[started]: {{site.firebase}}/docs/flutter/setup
[video]: {{site.yt.watch}}/DqJ_KjFzL9I&t#38s
[video2]: {{site.yt.watch}}/OlcYP6UXlm8
[workshop]: {{site.yt.watch}}/4wunbF29Kkg
