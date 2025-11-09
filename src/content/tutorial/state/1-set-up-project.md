---
ia-translate: true
title: Configure seu projeto
description: Instruções sobre como criar um novo app Flutter.
permalink: /tutorial/set-up-state-app/
sitemap: false
---

Neste tutorial, você aprenderá como trabalhar com dados em um app Flutter.
Você construirá um app que busca e exibe resumos de artigos da
[API da Wikipedia][Wikipedia API].

<img src="/assets/images/docs/tutorial/wikipedia_app.png" height="500px"
style="border:1px solid black" alt="Uma captura de tela do app leitor
da Wikipedia completo mostrando um artigo com imagem, título,
descrição e texto de extrato.">

Este tutorial explora:

* Fazendo requisições HTTP no Flutter
* Gerenciando estado da aplicação com `ChangeNotifier`
* Usando o padrão de arquitetura MVVM
* Criando interfaces de usuário responsivas que atualizam automaticamente quando
  os dados mudam


Este tutorial assume que você completou o [tutorial Getting Started
do Dart][Dart Getting Started tutorial] e o [tutorial introdutório do Flutter][introductory Flutter tutorial], e portanto
não explica conceitos como HTTP, JSON ou fundamentos de widgets.

:::note Apoie a Wikipedia
A Wikipedia é um recurso valioso, fornecendo acesso gratuito
ao conhecimento humano através de milhões de artigos escritos
colaborativamente por voluntários em todo o mundo. Considere [doar para a
Wikipedia][donating to Wikipedia] para ajudar a manter este recurso incrível gratuito e acessível
para todos.
:::

## Criar um novo projeto Flutter

Crie um novo projeto Flutter usando a [Flutter CLI][Flutter CLI]. No seu
terminal, execute o seguinte comando para criar um app Flutter mínimo:

```bash
$ flutter create wikipedia_reader --empty
```

## Adicionar dependências necessárias

Seu app precisa de dois [pacotes][packages] para trabalhar com requisições HTTP e
dados da Wikipedia. Adicione-os ao seu projeto:

```shell
$ cd wikipedia_reader
$ flutter pub add http dartpedia
```

O [pacote `http`][`http` package] fornece ferramentas para fazer requisições HTTP, enquanto
o pacote `dartpedia` contém modelos de dados para trabalhar com
as respostas da API da Wikipedia.

## Examinar o código inicial

Abra `lib/main.dart` e substitua o código existente por esta estrutura
básica, que adiciona importações necessárias que o app usa.

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wikipedia Flutter'),
        ),
        body: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
```

Este código fornece uma estrutura básica do app com uma barra de título e
conteúdo placeholder. As importações no topo incluem tudo que você
precisa para requisições HTTP, parsing de JSON e modelos de dados da Wikipedia.

## Executar seu app

Teste se tudo funciona executando seu app:

```bash
$ flutter run -d chrome
```

Você deverá ver um app simples com "Wikipedia Flutter" na barra do app
e "Loading..." no centro da tela.

[Wikipedia API]: https://en.wikipedia.org/api/rest_v1/
[donating to Wikipedia]: https://donate.wikimedia.org/
[introductory Flutter tutorial]: /tutorial/create-an-app/
[Dart Getting Started tutorial]: {{site.dart-site}}/tutorial
[Flutter CLI]: /reference/flutter-cli
[packages]: /packages-and-plugins/using-packages
[`http` package]: {{site.pub}}/packages/http
