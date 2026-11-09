<!-- ia-translate: true -->

O conceito de rota inicial está disponível ao configurar um
`FlutterActivity` ou um `FlutterFragment` com um novo `FlutterEngine`.
No entanto, `FlutterActivity` e `FlutterFragment` não oferecem o
conceito de rota inicial ao usar um engine em cache.
Isso acontece porque um engine em cache deve já estar executando código Dart,
o que significa que é tarde demais para configurar a rota inicial.

Desenvolvedores que quiserem que o engine em cache comece com uma rota inicial
personalizada podem configurar o `FlutterEngine` em cache para usar essa rota
logo antes de executar o entrypoint do Dart. O exemplo a seguir demonstra o uso
de uma rota inicial com um engine em cache:

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

Ao definir a rota inicial do canal de navegação, o `FlutterEngine` associado
exibe a rota desejada na primeira execução da função Dart `runApp()`.

Alterar a propriedade de rota inicial do canal de navegação depois da
primeira execução de `runApp()` não tem efeito.
Desenvolvedores que quiserem usar o mesmo `FlutterEngine` entre diferentes
`Activity`s e `Fragment`s, alternando a rota entre essas telas, precisam
configurar um method channel e instruir explicitamente o código Dart a alterar
as rotas do `Navigator`.
