---
ia-translate: true
title: Guia de migração do Android Java Gradle
description: >
  Como migrar seu aplicativo Android se você tiver um erro de
  execução ou build do Gradle.
---

## Resumo

Se você atualizou recentemente o Android Studio para a versão
Flamingo e executou ou construiu um aplicativo Android existente,
você pode ter se deparado com um erro semelhante ao seguinte:

![Caixa de diálogo de erro no Android Studio Flamingo: MultipleCompilationErrorsException](/assets/images/docs/releaseguide/android-studio-flamingo-error.png){:width="80%"}

A saída do terminal para este erro é
semelhante ao seguinte:

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
atualiza seu SDK Java agrupado de 11 para 17.
O Flutter usa a versão do Java agrupada com
o Android Studio para construir aplicativos Android.
Versões do Gradle [anteriores a 7.3][] não podem ser executadas
ao usar Java 17.

**Você pode corrigir esse erro atualizando seu projeto Gradle
para uma versão compatível (7.3 a 7.6.1, inclusive)
usando uma das seguintes abordagens.**

[anteriores a 7.3]: https://docs.gradle.org/current/userguide/compatibility.html#java

## Solução #1: Correção guiada usando o Android Studio

Atualize a versão do Gradle no Android Studio Flamingo
da seguinte forma:

1. No Android Studio, abra a pasta `android`.
   Isso deve abrir a seguinte caixa de diálogo:

   ![Caixa de diálogo solicitando que você atualize o Gradle](/assets/images/docs/releaseguide/android-studio-flamingo-upgrade-alert.png){:width="50%"}

   Atualize para uma versão do Gradle entre 7.3 e 7.6.1, inclusive.

1. Siga o fluxo de trabalho guiado para atualizar o Gradle.

   ![Fluxo de trabalho para atualizar o Gradle](/assets/images/docs/releaseguide/android-studio-flamingo-gradle-upgrade.png){:width="85%"}

## Solução #2: Correção manual na linha de comando

Faça o seguinte a partir do topo do seu projeto Flutter.

1. Vá para o diretório Android do seu projeto.

   ```console
   $ cd android
   ```

1. Atualize o Gradle para a versão preferida. Escolha entre 7.3 e 7.6.1, inclusive.

   ```console
   $ ./gradlew wrapper --gradle-version=7.6.1
   ```

## Notas

Algumas observações a serem consideradas:

* Repita esta etapa para cada aplicativo Android afetado.
* Este problema pode ser experimentado por aqueles que
  _não_ baixam o Java e o SDK do Android através do
  Android studio.
  Se você atualizou manualmente seu SDK Java para
  a versão 17, mas não atualizou o Gradle, você também pode
  encontrar este problema. A correção é a mesma:
  atualize o Gradle para uma versão entre 7.3 e 7.6.1.
* Sua máquina de desenvolvimento _pode_ conter mais
  de uma cópia do SDK Java:
  * O aplicativo Android Studio inclui uma versão do Java,
    que o Flutter usa por padrão.
  * Se você não tiver o Android Studio instalado,
    o Flutter depende da versão definida pela variável
    de ambiente `JAVA_HOME` do seu shell script.
  * Se `JAVA_HOME` não estiver definida, o Flutter procura
    por qualquer executável `java` no seu caminho.
    Depois que [issue 122609][] for aplicada, o comando
    `flutter doctor -v` relatará qual versão do Java é usada.
* Se você atualizar o Gradle para uma versão _mais recente_ que 7.6.1,
  você pode (embora seja improvável) encontrar problemas
  que resultam de mudanças no Gradle, como
  [classes Gradle depreciadas][], ou mudanças na
  estrutura de arquivos do Android, como
  [separar ApplicationId de PackageName][].
  Se isso ocorrer, faça o downgrade para uma versão do Gradle
  entre 7.3 e 7.6.1, inclusive.
* A atualização para o Flutter 3.10 não corrigirá esse problema.

[classes Gradle depreciadas]: https://docs.gradle.org/7.6/javadoc/deprecated-list.html
[issue 122609]: {{site.repo.flutter}}/issues/122609
[separar ApplicationId de PackageName]: http://tools.android.com/tech-docs/new-build-system/applicationid-vs-packagename
