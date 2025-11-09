O conceito de uma rota inicial está disponível ao configurar uma
`FlutterActivity` ou um `FlutterFragment` com um novo `FlutterEngine`.
No entanto, `FlutterActivity` e `FlutterFragment` não oferecem o
conceito de uma rota inicial ao usar um engine em cache.
Isso ocorre porque um engine em cache deve já estar
executando código Dart, o que significa que é tarde demais para configurar a
rota inicial.

Desenvolvedores que desejam que seu engine em cache comece
com uma rota inicial personalizada podem configurar seu
`FlutterEngine` em cache para usar uma rota inicial personalizada pouco antes
de executar o entrypoint Dart. O seguinte exemplo
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
Desenvolvedores que desejam usar o mesmo `FlutterEngine`
entre diferentes `Activity`s e `Fragment`s e alternar
a rota entre essas exibições precisam configurar um method channel e
instruir explicitamente seu código Dart para alterar as rotas do `Navigator`.
