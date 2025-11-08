---
ia-translate: true
title: Atualizando o Flutter
short-title: Atualizando
description: Como atualizar o Flutter.
---

Não importa qual canal de versão do Flutter
você siga, você pode usar o comando `flutter` para atualizar seu
Flutter SDK ou os pacotes dos quais seu app depende.

## Atualizando o Flutter SDK

Para atualizar o Flutter SDK use o comando `flutter upgrade`:

```console
$ flutter upgrade
```

Este comando obtém a versão mais recente do Flutter SDK
que está disponível em seu canal Flutter atual.

Se você está usando o canal **stable**
e quer uma versão ainda mais recente do Flutter SDK,
mude para o canal **beta** usando `flutter channel beta`,
e então execute `flutter upgrade`.

### Mantendo-se informado

Publicamos [migration guides][] para mudanças incompatíveis conhecidas.

Enviamos anúncios sobre essas mudanças para a
[Flutter announcements mailing list][flutter-announce].

Para evitar ser afetado por versões futuras do Flutter,
considere enviar seus testes para nosso [test registry][].


## Mudando canais do Flutter

Flutter tem dois canais de versão:
**stable** e **beta**.

### O canal **stable**

Recomendamos o canal **stable** para novos usuários
e para versões de apps em produção.
A equipe atualiza este canal aproximadamente a cada três meses.
O canal pode receber correções ocasionais
para problemas de alta severidade ou alto impacto.

A integração contínua para os plugins e pacotes da equipe do Flutter
inclui testes contra a última versão **stable**.

A documentação mais recente para o branch **stable**
está em: <https://api.flutterbrasil.dev>

### O canal **beta**

O canal **beta** tem a última versão estável.
Esta é a versão mais recente do Flutter que testamos intensamente.
Este canal passou por todos os nossos testes públicos,
foi verificado contra suítes de teste para produtos Google que usam Flutter,
e foi examinado contra [contributed private test suites][test registry].
O canal **beta** recebe correções regulares
para resolver problemas importantes recém-descobertos.

O canal **beta** é essencialmente o mesmo que o canal **stable**
mas atualizado mensalmente ao invés de trimestralmente.
De fato, quando o canal **stable** é atualizado,
ele é atualizado para a última versão **beta**.

### Outros canais

Atualmente temos um outro canal, **main** (anteriormente conhecido como **master**).
Pessoas que [contribute to Flutter][] usam este canal.

Este canal não é tão completamente testado quanto
os canais **beta** e **stable**.

Não recomendamos usar este canal já que
é mais provável que contenha regressões sérias.

A documentação mais recente para o branch **main**
está em: <https://main-api.flutterbrasil.dev>

### Mudando canais

Para visualizar seu canal atual, use o seguinte comando:

```console
$ flutter channel
```

Para mudar para outro canal, use `flutter channel <channel-name>`.
Uma vez que você mudou seu canal, use `flutter upgrade`
para baixar o Flutter SDK mais recente e pacotes dependentes para aquele canal.
Por exemplo:

```console
$ flutter channel beta
$ flutter upgrade
```


## Mudando para uma versão específica do Flutter

Para mudar para uma versão específica do Flutter:

1. Encontre sua **versão do Flutter** desejada no [Flutter SDK archive][].

1. Navegue para o Flutter SDK:

   ```console
   $ cd /path/to/flutter
   ```

   :::tip
   Você pode encontrar o caminho do Flutter SDK usando `flutter doctor --verbose`.
   :::

1. Use `git checkout` para mudar para sua **versão do Flutter** desejada:

   ```console
   $ git checkout <Flutter version>
   ```


## Atualizando pacotes

Se você modificou seu arquivo `pubspec.yaml`, ou quer atualizar
apenas os pacotes dos quais seu app depende
(ao invés de ambos os pacotes e o Flutter em si),
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
a [documentação do `pub outdated` do Dart]({{site.dart-site}}/tools/pub/cmd/pub-outdated).

```console
$ flutter pub outdated
```

[Flutter SDK archive]: /release/archive
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[pubspec.yaml]: {{site.dart-site}}/tools/pub/pubspec
[test registry]: {{site.repo.organization}}/tests
[contribute to Flutter]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[migration guides]: /release/breaking-changes
