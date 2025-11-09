---
ia-translate: true
title: Adicionar uma tela Flutter a um app Android
shortTitle: Adicionar uma tela Flutter
description: >
  Aprenda como adicionar uma única tela Flutter ao seu app Android existente.
---

Este guia descreve como adicionar uma única tela Flutter a um
app Android existente. Uma tela Flutter pode ser adicionada como uma tela normal e
opaca, ou como uma tela translúcida e transparente.
Ambas as opções são descritas neste guia.

## Adicionar uma tela Flutter normal

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-screen/add-single-flutter-screen_header.png' alt="Add Flutter Screen Header">

### Passo 1: Adicionar FlutterActivity ao AndroidManifest.xml

O Flutter fornece [`FlutterActivity`][`FlutterActivity`] para exibir uma
experiência Flutter dentro de um app Android. Como qualquer outra [`Activity`][`Activity`],
`FlutterActivity` deve ser registrada no seu
`AndroidManifest.xml`. Adicione o seguinte XML ao seu
arquivo `AndroidManifest.xml` sob sua tag `application`:

```xml
<activity
  android:name="io.flutter.embedding.android.FlutterActivity"
  android:theme="@style/LaunchTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize"
  />
```

A referência a `@style/LaunchTheme` pode ser substituída
por qualquer tema Android que você queira aplicar à sua `FlutterActivity`.
A escolha do tema determina as cores aplicadas ao
chrome do sistema Android, como a barra de navegação do Android, e à
cor de fundo da `FlutterActivity` logo antes
da UI Flutter se renderizar pela primeira vez.

### Passo 2: Lançar FlutterActivity

Com `FlutterActivity` registrada no seu arquivo de manifesto,
adicione código para lançar `FlutterActivity` de qualquer ponto
no seu app que você queira. O exemplo a seguir mostra
`FlutterActivity` sendo lançada de um `OnClickListener`.

:::note
Certifique-se de usar o seguinte import:

```java
import io.flutter.embedding.android.FlutterActivity;
```
:::

<Tabs key="android-framework">
<Tab name="Jetpack Compose">

```kotlin title="ExistingActivity.kt"
MyButton(onClick = {
    startActivity(
        FlutterActivity.createDefaultIntent(this)
    )
})

@Composable
fun MyButton(onClick: () -> Unit) {
    Button(onClick = onClick) {
        Text("Launch Flutter!")
    }
}
```

</Tab>
<Tab name="Kotlin">

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity.createDefaultIntent(this)
  )
}
```

</Tab>
<Tab name="Java">

```java title="ExistingActivity.java"
myButton.setOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity.createDefaultIntent(currentActivity)
    );
  }
});
```

</Tab>
</Tabs>

O exemplo anterior assume que seu entrypoint Dart
é chamado `main()`, e sua rota inicial do Flutter é '/'.
O entrypoint Dart não pode ser alterado usando `Intent`,
mas a rota inicial pode ser alterada usando `Intent`.
O exemplo a seguir demonstra como lançar uma
`FlutterActivity` que inicialmente renderiza uma rota
personalizada no Flutter.

<Tabs key="android-framework">
<Tab name="Jetpack Compose">

```kotlin title="ExistingActivity.kt"
MyButton(onClick = {
  startActivity(
    FlutterActivity
      .withNewEngine()
      .initialRoute("/my_route")
      .build(this)
  )
})

@Composable
fun MyButton(onClick: () -> Unit) {
    Button(onClick = onClick) {
        Text("Launch Flutter!")
    }
}
```

</Tab>
<Tab name="Kotlin">

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity
      .withNewEngine()
      .initialRoute("/my_route")
      .build(this)
  )
}
```

</Tab>
<Tab name="Java">

```java title="ExistingActivity.java"
myButton.addOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity
        .withNewEngine()
        .initialRoute("/my_route")
        .build(currentActivity)
      );
  }
});
```

</Tab>
</Tabs>

Substitua `"/my_route"` pela sua rota inicial desejada.

O uso do método factory `withNewEngine()`
configura uma `FlutterActivity` que internamente cria
sua própria instância de [`FlutterEngine`][`FlutterEngine`]. Isso vem com um
tempo de inicialização não trivial. A abordagem alternativa
é instruir `FlutterActivity` a usar um `FlutterEngine`
pré-aquecido e em cache, o que minimiza o
tempo de inicialização do Flutter. Essa abordagem é discutida a seguir.

### Passo 3: (Opcional) Usar um FlutterEngine em cache

Cada `FlutterActivity` cria seu próprio `FlutterEngine`
por padrão. Cada `FlutterEngine` tem um tempo de
aquecimento não trivial. Isso significa que lançar uma
`FlutterActivity` padrão vem com um breve atraso antes que sua
experiência Flutter se torne visível. Para minimizar este atraso,
você pode aquecer um `FlutterEngine` antes de chegar à
sua `FlutterActivity`, e então você pode usar
seu `FlutterEngine` pré-aquecido em vez disso.

Para pré-aquecer um `FlutterEngine`, encontre um local
razoável no seu app para instanciar um `FlutterEngine`.
O exemplo a seguir arbitrariamente pré-aquece um
`FlutterEngine` na classe `Application`:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyApplication.kt"
class MyApplication : Application() {
  lateinit var flutterEngine : FlutterEngine

  override fun onCreate() {
    super.onCreate()

    // Instantiate a FlutterEngine.
    flutterEngine = FlutterEngine(this)

    // Start executing Dart code to pre-warm the FlutterEngine.
    flutterEngine.dartExecutor.executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )

    // Cache the FlutterEngine to be used by FlutterActivity.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine)
  }
}
```

</Tab>
<Tab name="Java">

```java title="MyApplication.java"
public class MyApplication extends Application {
  public FlutterEngine flutterEngine;

  @Override
  public void onCreate() {
    super.onCreate();
    // Instantiate a FlutterEngine.
    flutterEngine = new FlutterEngine(this);

    // Start executing Dart code to pre-warm the FlutterEngine.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
      DartEntrypoint.createDefault()
    );

    // Cache the FlutterEngine to be used by FlutterActivity.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine);
  }
}
```

</Tab>
</Tabs>

O ID passado para o [`FlutterEngineCache`][`FlutterEngineCache`] pode ser o que você quiser.
Certifique-se de passar o mesmo ID para qualquer `FlutterActivity`
ou [`FlutterFragment`][`FlutterFragment`] que deve usar o `FlutterEngine` em cache.
Usar `FlutterActivity` com um `FlutterEngine` em cache
é discutido a seguir.

:::note
Para aquecer um `FlutterEngine`, você deve executar um
entrypoint Dart. Tenha em mente que no momento em que
`executeDartEntrypoint()` é invocado,
seu método de entrypoint Dart começa a executar.
Se seu entrypoint Dart invoca `runApp()`
para executar um app Flutter, então seu app Flutter se comporta como se estivesse
executando em uma janela de tamanho zero até que este
`FlutterEngine` seja anexado a uma `FlutterActivity`,
`FlutterFragment`, ou `FlutterView`. Certifique-se de que seu app
se comporte apropriadamente entre o momento em que você o aquece e
o momento em que você exibe o conteúdo Flutter.
:::

Com um `FlutterEngine` pré-aquecido e em cache, você agora precisa
instruir sua `FlutterActivity` a usar o `FlutterEngine`
em cache em vez de criar um novo.
Para fazer isso, use o builder `withCachedEngine()`
de `FlutterActivity`:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity
      .withCachedEngine("my_engine_id")
      .build(this)
  )
}
```

</Tab>
<Tab name="Java">

```java title="ExistingActivity.java"
myButton.addOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity
        .withCachedEngine("my_engine_id")
        .build(currentActivity)
      );
  }
});
```

</Tab>
</Tabs>

Ao usar o método factory `withCachedEngine()`,
passe o mesmo ID que você usou ao fazer cache do
`FlutterEngine` desejado.

Agora, quando você lança `FlutterActivity`,
há significativamente menos atraso na
exibição do conteúdo Flutter.

:::note
Ao usar um `FlutterEngine` em cache, esse `FlutterEngine` sobrevive a qualquer
`FlutterActivity` ou `FlutterFragment` que o exibe. Tenha em
mente que o código Dart começa a executar assim que você pré-aquece o
`FlutterEngine`, e continua executando após a destruição da sua
`FlutterActivity`/`FlutterFragment`. Para parar a execução e limpar recursos,
obtenha seu `FlutterEngine` do `FlutterEngineCache` e destrua o
`FlutterEngine` com `FlutterEngine.destroy()`.
:::

:::note
Performance de runtime não é a única razão pela qual você pode
pré-aquecer e fazer cache de um `FlutterEngine`.
Um `FlutterEngine` pré-aquecido executa código Dart independentemente
de uma `FlutterActivity`, o que permite que tal `FlutterEngine`
seja usado para executar código Dart arbitrário a qualquer momento.
Lógica de aplicação não relacionada à UI pode ser executada em um `FlutterEngine`,
como networking e cache de dados, e em comportamento em background
dentro de um `Service` ou em outro lugar. Ao usar um `FlutterEngine`
para executar comportamento em background, certifique-se de aderir a todas as
restrições do Android sobre execução em background.
:::

:::note
As builds debug/release do Flutter têm características de
performance drasticamente diferentes. Para avaliar a performance
do Flutter, use uma build de release.
:::

#### Rota inicial com um engine em cache

{% render "docs/add-to-app/android-initial-route-cached-engine.md" %}

## Adicionar uma tela Flutter translúcida

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-screen/add-single-flutter-screen-transparent_header.png' alt="Add Flutter Screen With Translucency Header">

A maioria das experiências Flutter em tela cheia são opacas.
No entanto, alguns apps gostariam de implementar uma tela
Flutter que se parece com um modal, por exemplo,
um diálogo ou bottom sheet. O Flutter suporta
`FlutterActivity`s translúcidas out of the box.

Para tornar sua `FlutterActivity` translúcida,
faça as seguintes mudanças no processo regular de
criar e lançar uma `FlutterActivity`.

### Passo 1: Usar um tema com translucidez

O Android requer uma propriedade de tema especial para `Activity`s que renderizam
com um background translúcido. Crie ou atualize um tema Android com a
seguinte propriedade:

```xml
<style name="MyTheme" parent="@style/MyParentTheme">
  <item name="android:windowIsTranslucent">true</item>
</style>
```

Então, aplique o tema translúcido à sua `FlutterActivity`.

```xml
<activity
  android:name="io.flutter.embedding.android.FlutterActivity"
  android:theme="@style/MyTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize"
  />
```

Sua `FlutterActivity` agora suporta translucidez.
Em seguida, você precisa lançar sua `FlutterActivity`
com suporte explícito à transparência.

### Passo 2: Iniciar FlutterActivity com transparência

Para lançar sua `FlutterActivity` com um background transparente,
passe o `BackgroundMode` apropriado para o `IntentBuilder`:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="ExistingActivity.kt"
// Using a new FlutterEngine.
startActivity(
  FlutterActivity
    .withNewEngine()
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(this)
);

// Using a cached FlutterEngine.
startActivity(
  FlutterActivity
    .withCachedEngine("my_engine_id")
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(this)
);
```

</Tab>
<Tab name="Java">

```java title="ExistingActivity.java"
// Using a new FlutterEngine.
startActivity(
  FlutterActivity
    .withNewEngine()
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(context)
);

// Using a cached FlutterEngine.
startActivity(
  FlutterActivity
    .withCachedEngine("my_engine_id")
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(context)
);
```

</Tab>
</Tabs>

Você agora tem uma `FlutterActivity` com um background transparente.

:::note
Certifique-se de que seu conteúdo Flutter também inclui um
background translúcido. Se sua UI Flutter pinta uma
cor de background sólida, então ainda parecerá como se
sua `FlutterActivity` tivesse um background opaco.
:::

[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`Activity`]: {{site.android-dev}}/reference/android/app/Activity
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterEngineCache`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngineCache.html
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
