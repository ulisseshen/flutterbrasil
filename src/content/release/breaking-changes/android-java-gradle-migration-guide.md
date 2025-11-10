---
ia-translate: true
title: Guia de migração Android Java Gradle
description: >
  Como migrar seu app Android se você encontrar
  um erro de execução ou compilação do Gradle.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Se você recentemente atualizou o Android Studio para a versão
Flamingo e executou ou compilou um app Android existente,
você pode ter encontrado um erro similar ao seguinte:

```sh
Caused by: org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:
```

A saída do terminal para este erro é
similar ao seguinte:


```sh
FAILURE: Build failed with an exception.

* Where:
Build file '…/example/android/build.gradle'
* What went wrong:
Could not compile build file '…/example/android/build.gradle'.
> startup failed:
  General error during conversion: Unsupported class file major version 61

  java.lang.IllegalArgumentException: Unsupported class file major version 61
  	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:189)
  	at groovyjarjarasm.asm.ClassReader.<init>(ClassReader.java:170)
  	[…
  	 …
  	 … 209 more lines of Groovy and Gradle stack trace …
  	 …
  	 …]
  	at java.base/java.lang.Thread.run(Thread.java:833)
```

Este erro ocorre porque o Android Studio Flamingo
atualiza seu SDK Java incluído da versão 11 para 17.
Flutter usa a versão do Java incluída com
o Android Studio para compilar apps Android.
Versões do Gradle [anteriores à 7.3][prior to 7.3] não podem executar
quando usam Java 17.

**Você pode corrigir este erro atualizando seu projeto Gradle
para uma versão compatível (7.3 até 7.6.1, inclusive)
usando uma das seguintes abordagens.**

[prior to 7.3]: https://docs.gradle.org/current/userguide/compatibility.html#java

## Solução #1: Correção guiada usando Android Studio

Atualize a versão do Gradle no Android Studio Flamingo
da seguinte forma:

1. No Android Studio, abra a pasta `android`.
   Isto deve trazer o seguinte diálogo:

   ![Dialog prompting you to upgrade Gradle](/assets/images/docs/releaseguide/android-studio-flamingo-upgrade-alert.png){:width="50%"}

   Atualize para uma versão do Gradle entre 7.3 até 7.6.1, inclusive.

1. Siga o workflow guiado para atualizar o Gradle.

   ![Workflow to upgrade Gradle](/assets/images/docs/releaseguide/android-studio-flamingo-gradle-upgrade.png){:width="85%"}

## Solução #2: Correção manual na linha de comando

Faça o seguinte a partir do topo do seu projeto Flutter.

1. Vá para o diretório Android do seu projeto.

   ```console
   $ cd android
   ```

1. Atualize o Gradle para a versão preferida. Escolha entre 7.3 até 7.6.1, inclusive.

   ```console
   $ ./gradlew wrapper --gradle-version=7.6.1
   ```

## Você não atualizou o Android Studio e ainda tem um erro de Java
O erro aparece similar a `Unsupported class file major version 65`.
Esta é uma indicação de que sua versão do Java é mais recente do que a versão do
gradle que você está executando pode lidar. Existe um conjunto não óbvio de dependências
envolvendo AGP, Java e Gradle.

### Solução 1: Android Studio
A maneira mais fácil de resolver este problema é usar o assistente de atualização AGP do Android Studio.
Para usar, selecione seu arquivo `build.gradle` de nível superior no Android Studio e então selecione
Tools -> AGP Upgrade Assistant.

### Solução 2: Linha de comando
Execute `flutter analyze --suggestions` para ver se suas versões de AGP, Java e Gradle são compatíveis.
Se o Gradle precisar ser atualizado, você pode atualizá-lo com `./gradlew wrapper --gradle-version=SOMEGRADLEVERSION`
onde SOMEGRADLEVERSION é a versão (você pode usar uma versão mais recente)
sugerida por `flutter analyze`.

Para encontrar a versão do Java sendo usada, execute `flutter doctor`.
Em um Mac, você pode encontrar as versões do Java que o SO conhece com `/usr/libexec/java_home -V`.
Para definir a versão do Java que todos os projetos Flutter usam, execute `flutter config --jdk-dir=SOMEJAVAPATH`
onde SOMEJAVAPATH é um caminho para uma versão do Java como `/opt/homebrew/Cellar/openjdk@17/17.0.13/libexec/openjdk.jdk/Contents/Home`

## Notas

Algumas notas para estar ciente:

* Repita este passo para cada app Android afetado.
* Este problema pode ser encontrado por aqueles que
  _não_ baixam Java e o Android SDK através
  do Android Studio.
  Se você atualizou manualmente seu SDK Java para
  a versão 17 mas não atualizou o Gradle, você pode
  também encontrar este problema. A correção é a mesma:
  atualize o Gradle para uma versão entre 7.3 e 7.6.1.
* Sua máquina de desenvolvimento _pode_ conter mais
  de uma cópia do SDK Java:
  * O app Android Studio inclui uma versão do Java,
    que o Flutter usa por padrão.
  * Se você não tem o Android Studio instalado,
    Flutter depende da versão definida pela
    variável de ambiente `JAVA_HOME` do seu script shell.
  * Se `JAVA_HOME` não está definido, Flutter procura
    por qualquer executável `java` em seu path.
    O comando `flutter doctor -v` reporta qual versão
    do Java é usada.
* Se você atualizar o Gradle para uma versão _mais recente_ do que 7.6.1,
  você pode (embora seja improvável) encontrar problemas
  que resultam de mudanças no Gradle, como
  [classes Gradle depreciadas][deprecated Gradle classes], ou mudanças na
  estrutura de arquivos do Android, como
  [separar ApplicationId de PackageName][splitting out ApplicationId from PackageName].
  Se isso ocorrer, faça downgrade para uma versão do Gradle
  entre 7.3 e 7.6.1, inclusive.
* Atualizar para Flutter 3.10 não corrigirá este problema.

[deprecated Gradle classes]: https://docs.gradle.org/7.6/javadoc/deprecated-list.html
[issue 122609]: {{site.repo.flutter}}/issues/122609
[splitting out ApplicationId from PackageName]: http://tools.android.com/tech-docs/new-build-system/applicationid-vs-packagename
