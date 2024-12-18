---
ia-translate: true
title: Atualizando o Flutter
short-title: Atualizando
description: Como atualizar o Flutter.
---

Não importa qual dos canais de lançamento do Flutter
você siga, você pode usar o comando `flutter` para atualizar seu
SDK do Flutter ou os pacotes dos quais seu aplicativo depende.

## Atualizando o SDK do Flutter

Para atualizar o SDK do Flutter, use o comando `flutter upgrade`:

```console
$ flutter upgrade
```

Este comando obtém a versão mais recente do SDK do Flutter
que está disponível em seu canal atual do Flutter.

Se você estiver usando o canal **stable**
e quiser uma versão ainda mais recente do SDK do Flutter,
mude para o canal **beta** usando `flutter channel beta`
e então execute `flutter upgrade`.

### Mantendo-se informado

Nós publicamos [guias de migração][] para mudanças
que causam quebras de compatibilidade conhecidas.

Enviamos anúncios sobre essas mudanças para a
[lista de e-mail de anúncios do Flutter][flutter-announce].

Para evitar que futuras versões do Flutter quebrem seu código,
considere enviar seus testes para nosso [registro de testes][].

## Trocando os canais do Flutter

O Flutter tem dois canais de lançamento:
**stable** e **beta**.

### O canal **stable**

Recomendamos o canal **stable** para novos usuários
e para lançamentos de aplicativos em produção.
A equipe atualiza este canal cerca de três meses.
O canal pode receber hotfixes ocasionais
para problemas de alta severidade ou alto impacto.

A integração contínua para os plugins e pacotes da equipe do Flutter
inclui testes em relação à versão **stable** mais recente.

A documentação mais recente para o ramo **stable**
está em: <https://api.flutter.dev>

### O canal **beta**

O canal **beta** tem a versão estável mais recente.
Esta é a versão mais recente do Flutter que testamos exaustivamente.
Este canal passou por todos os nossos testes públicos,
foi verificado em relação a suítes de testes para produtos do Google que usam Flutter,
e foi analisado em relação a [suítes de testes privadas contribuídas][registro de testes].
O canal **beta** recebe hotfixes regulares
para tratar de problemas importantes recém-descobertos.

O canal **beta** é essencialmente o mesmo que o canal **stable**,
mas atualizado mensalmente em vez de trimestralmente.
Na verdade, quando o canal **stable** é atualizado,
ele é atualizado para a versão **beta** mais recente.

### Outros canais

Atualmente, temos outro canal, o **main** (anteriormente conhecido como **master**).
Pessoas que [contribuem para o Flutter][] usam este canal.

Este canal não é tão exaustivamente testado quanto os canais
**beta** e **stable**.

Não recomendamos usar este canal, pois
é mais provável que contenha regressões sérias.

A documentação mais recente para o ramo **main**
está em: <https://main-api.flutter.dev>

### Trocando de canal

Para ver seu canal atual, use o seguinte comando:

```console
$ flutter channel
```

Para mudar para outro canal, use `flutter channel <nome-do-canal>`.
Depois de mudar seu canal, use `flutter upgrade`
para baixar o SDK do Flutter e os pacotes dependentes mais recentes para aquele canal.
Por exemplo:

```console
$ flutter channel beta
$ flutter upgrade
```

## Trocando para uma versão específica do Flutter

Para trocar para uma versão específica do Flutter:

1. Encontre a **versão do Flutter** desejada no [arquivo do SDK do Flutter][].

2. Navegue até o SDK do Flutter:

   ```console
   $ cd /caminho/para/o/flutter
   ```

   :::tip
   Você pode encontrar o caminho do SDK do Flutter usando `flutter doctor --verbose`.
   :::

3. Use `git checkout` para trocar para a **versão do Flutter** desejada:

   ```console
   $ git checkout <Versão do Flutter>
   ```

## Atualizando pacotes

Se você modificou seu arquivo `pubspec.yaml`, ou se você quiser atualizar
apenas os pacotes dos quais seu aplicativo depende
(em vez de atualizar os pacotes e o Flutter em si),
então use um dos comandos `flutter pub`.

Para atualizar para as _versões compatíveis mais recentes_ de
todas as dependências listadas no arquivo `pubspec.yaml`,
use o comando `upgrade`:

```console
$ flutter pub upgrade
```

Para atualizar para a _versão mais recente possível_ de
todas as dependências listadas no arquivo `pubspec.yaml`,
use o comando `upgrade --major-versions`:

```console
$ flutter pub upgrade --major-versions
```

Isso também atualiza automaticamente as restrições
no arquivo `pubspec.yaml`.

Para identificar dependências de pacotes desatualizadas e obter conselhos
sobre como atualizá-las, use o comando `outdated`. Para detalhes, consulte
a documentação do Dart [`pub outdated`]({{site.dart-site}}/tools/pub/cmd/pub-outdated).

```console
$ flutter pub outdated
```

[arquivo do SDK do Flutter]: /release/archive
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[pubspec.yaml]: {{site.dart-site}}/tools/pub/pubspec
[registro de testes]: {{site.repo.organization}}/tests
[contribuir para o Flutter]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[guias de migração]: /release/breaking-changes
