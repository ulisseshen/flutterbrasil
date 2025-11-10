<!-- ia-translate: true -->

O conceito de rota inicial está disponível ao configurar uma
`FlutterActivity` ou um `FlutterFragment` com um novo `FlutterEngine`.
No entanto, `FlutterActivity` e `FlutterFragment` não oferecem o
conceito de rota inicial ao usar um engine em cache.
Isso ocorre porque um engine em cache é esperado que já esteja
executando código Dart, o que significa que é tarde demais para configurar a
rota inicial.

Desenvolvedores que gostariam que seu engine em cache começasse
com uma rota inicial personalizada podem configurar seu
`FlutterEngine` em cache para usar uma rota inicial personalizada logo antes de
executar o entrypoint Dart. O exemplo a seguir
demonstra o uso de uma rota inicial com um engine em cache:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyApplication.kt"
class MyApplication : Application() {
  lateinit var flutterEngine : FlutterEngine
  override fun onCreate() {
    super.onCreate()
    // Instantiate a FlutterEngine.
    flutterEngine = FlutterEngine(this)
    // Configure an initial route.
    flutterEngine.navigationChannel.setInitialRoute("your/route/here");
    // Start executing Dart code to pre-warm the FlutterEngine.
    flutterEngine.dartExecutor.executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )
    // Cache the FlutterEngine to be used by FlutterActivity or FlutterFragment.
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
  @Override
  public void onCreate() {
    super.onCreate();
    // Instantiate a FlutterEngine.
    flutterEngine = new FlutterEngine(this);
    // Configure an initial route.
    flutterEngine.getNavigationChannel().setInitialRoute("your/route/here");
    // Start executing Dart code to pre-warm the FlutterEngine.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
      DartEntrypoint.createDefault()
    );
    // Cache the FlutterEngine to be used by FlutterActivity or FlutterFragment.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine);
  }
}
```

</Tab>
</Tabs>

Ao definir a rota inicial do canal de navegação, o
`FlutterEngine` associado exibe a rota desejada na execução inicial da
função Dart `runApp()`.

Alterar a propriedade de rota inicial do canal de navegação
após a execução inicial de `runApp()` não tem efeito.
Desenvolvedores que gostariam de usar o mesmo `FlutterEngine`
entre diferentes `Activity`s e `Fragment`s e alternar
a rota entre essas telas precisam configurar um method channel e
instruir explicitamente seu código Dart para alterar rotas do `Navigator`.
