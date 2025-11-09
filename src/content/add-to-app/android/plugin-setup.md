---
ia-translate: true
title: Gerencie plugins e dependências em add-to-app
shortTitle: Configuração de plugin
description: >
  Aprenda como usar plugins e compartilhar as
  dependências de biblioteca do seu plugin com seu app existente.
---

Este guia descreve como configurar seu projeto para consumir
plugins e como gerenciar suas dependências de biblioteca Gradle
entre seu app Android existente e os plugins do seu módulo Flutter.

## A. Cenário simples

Nos casos simples:

* Seu módulo Flutter usa um plugin que não tem dependências
  adicionais do Android Gradle porque ele apenas usa APIs do
  sistema operacional Android, como o plugin camera.
* Seu módulo Flutter usa um plugin que tem uma dependência do
  Android Gradle, como
  [ExoPlayer do plugin video_player][ExoPlayer from the video_player plugin],
  mas seu app Android existente não dependia do ExoPlayer.

Não são necessárias etapas adicionais. Seu módulo add-to-app
funcionará da mesma forma que um app Flutter completo.
Se você integrar usando Android Studio,
subprojeto Gradle ou AARs,
as bibliotecas Android Gradle transitivas são automaticamente
agrupadas conforme necessário no seu app externo existente.

## B. Plugins que precisam de edições no projeto

Alguns plugins exigem que você faça algumas edições no
lado Android do seu projeto.

Por exemplo, as instruções de integração para o
plugin [firebase_crashlytics][firebase_crashlytics] requerem edições manuais
no arquivo `build.gradle` do seu projeto wrapper Android.

Para apps Flutter completos, essas edições são feitas no
diretório `/android/` do seu projeto Flutter.

No caso de um módulo Flutter, existem apenas arquivos Dart
no seu projeto de módulo. Execute essas edições de arquivo
Android Gradle no seu app Android externo existente,
em vez de no seu módulo Flutter.

:::note
Leitores atentos podem notar que o diretório do módulo Flutter
também contém um diretório `.android` e um `.ios`. Esses diretórios
são gerados pela ferramenta Flutter e são destinados apenas a
fazer o bootstrap do Flutter em bibliotecas Android ou iOS genéricas.
Eles não devem ser editados ou incluídos no controle de versão.
Isso permite que o Flutter melhore o ponto de integração caso
haja bugs ou atualizações necessárias com novas versões do Gradle,
Android, Android Gradle Plugin, etc.

Para usuários avançados, se for necessária mais modularidade e você
não deve vazar conhecimento das dependências do seu módulo Flutter
no seu app host externo, você pode reempacotar e reembalar a biblioteca
Gradle do seu módulo Flutter dentro de outra biblioteca Android Gradle
nativa que depende da biblioteca Gradle do módulo Flutter.
Você pode fazer suas alterações específicas do Android, como editar o
AndroidManifest.xml, arquivos Gradle ou adicionar mais arquivos Java
nessa biblioteca wrapper.
:::

## C. Mesclando bibliotecas

O cenário que requer um pouco mais de atenção é se
seu aplicativo Android existente já depende da
mesma biblioteca Android que seu módulo Flutter
depende (transitivamente via um plugin).

Por exemplo, o Gradle do seu app existente pode já ter:

```groovy title="ExistingApp/app/build.gradle"
…
dependencies {
    …
    implementation("com.crashlytics.sdk.android:crashlytics:2.10.1")
    …
}
…
```

E seu módulo Flutter também depende de
[firebase_crashlytics][firebase_crashlytics] via `pubspec.yaml`:

```yaml title="flutter_module/pubspec.yaml"
…
dependencies:
  …
  firebase_crashlytics: ^0.1.3
  …
…
```

Este uso do plugin adiciona transitivamente uma dependência Gradle novamente via
o próprio [arquivo Gradle][Gradle file] do firebase_crashlytics v0.1.3:

```groovy title="firebase_crashlytics_via_pub/android/build.gradle
…
dependencies {
    …
    implementation("com.crashlytics.sdk.android:crashlytics:2.9.9")
    …
}
…
```

As duas dependências `com.crashlytics.sdk.android:crashlytics`
podem não ser a mesma versão. Neste exemplo,
o app host solicitou v2.10.1 e o plugin do módulo
Flutter solicitou v2.9.9.

Por padrão, o Gradle v5
[resolve conflitos de versão de dependência][resolves dependency version conflicts]
usando a versão mais recente da biblioteca.

Isso geralmente é ok, desde que não haja mudanças
incompatíveis na API ou implementação entre as versões.
Por exemplo, você pode usar a nova biblioteca Crashlytics
no seu app existente da seguinte forma:

```groovy title="ExistingApp/app/build.gradle"
…
dependencies {
    …
    implementation("com.google.firebase:firebase-crashlytics:17.0.0-beta03")
    …
}
…
```

Esta abordagem não funcionará, pois há grandes diferenças de API
entre a versão v17.0.0-beta03 e v2.9.9 da biblioteca Gradle do Crashlytics.

Para bibliotecas Gradle que seguem versionamento semântico,
você geralmente pode evitar erros de compilação e tempo de execução
usando a mesma versão semântica principal no seu
app existente e plugin do módulo Flutter.


[ExoPlayer from the video_player plugin]: {{site.repo.packages}}/blob/main/packages/video_player/video_player_android/android/build.gradle
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[Gradle file]: {{site.github}}/firebase/flutterfire/blob/bdb95fcacf7cf077d162d2f267eee54a8b0be3bc/packages/firebase_crashlytics/android/build.gradle#L40
[resolves dependency version conflicts]: https://docs.gradle.org/current/userguide/dependency_resolution.html#sub:resolution-strategy
