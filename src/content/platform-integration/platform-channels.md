---
ia-translate: true
title: Escrevendo código customizado específico da plataforma
short-title: Código específico da plataforma
description: Aprenda como escrever código customizado específico da plataforma em seu app.
---

<?code-excerpt path-base="platform_integration"?>

Este guia descreve como escrever código customizado específico da plataforma.
Algumas funcionalidades específicas da plataforma estão disponíveis
através de pacotes existentes;
veja [using packages][].

[using packages]: /packages-and-plugins/using-packages

:::note
As informações nesta página são válidas para a maioria das plataformas,
mas código específico da plataforma para web geralmente usa
[JS interoperability][] ou a [`dart:html` library][] em vez disso.
:::

Flutter usa um sistema flexível que permite que você chame
APIs específicas da plataforma em uma linguagem que funciona diretamente
com essas APIs:

* Kotlin ou Java no Android
* Swift ou Objective-C no iOS
* C++ no Windows
* Objective-C no macOS
* C no Linux

O suporte integrado do Flutter para APIs específicas da plataforma
não depende de geração de código,
mas sim de um estilo flexível de passagem de mensagens.
Alternativamente, você pode usar o pacote [Pigeon][pigeon]
para [enviar mensagens typesafe estruturadas][sending structured typesafe messages]
com geração de código:

* A parte Flutter do app envia mensagens para seu _host_,
  a parte não-Dart do app, por meio de um platform channel.

* O _host_ escuta no platform channel e recebe a mensagem.
  Ele então chama qualquer número de APIs específicas da plataforma&mdash;usando
  a linguagem de programação nativa&mdash;e envia uma resposta de volta ao
  _client_, a parte Flutter do app.

:::note
Este guia aborda o uso do mecanismo de platform channel
se você precisa usar as APIs da plataforma em uma linguagem não-Dart.
Mas você também pode escrever código Dart específico da plataforma
em seu app Flutter inspecionando a
propriedade [`defaultTargetPlatform`][].
[Platform adaptations][] lista algumas
adaptações específicas da plataforma que Flutter
executa automaticamente para você no framework.
:::

[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html
[pigeon]: {{site.pub-pkg}}/pigeon

<a id="channels-and-platform-threading"></a>
## Visão geral da arquitetura: platform channels {:#architecture}

Mensagens são passadas entre o client (UI)
e host (plataforma) usando platform
channels como ilustrado neste diagrama:

![Platform channels architecture](/assets/images/docs/PlatformChannels.png){:width="100%"}

Mensagens e respostas são passadas assincronamente,
para garantir que a interface do usuário permaneça responsiva.

:::note
Mesmo que Flutter envie mensagens de e para Dart assincronamente,
sempre que você invocar um método de channel, você deve invocar esse método na
thread principal da plataforma. Veja a [seção sobre threading][section on threading]
para mais informações.
:::

No lado do client, [`MethodChannel`][] habilita o envio de
mensagens que correspondem a chamadas de método. No lado da plataforma,
`MethodChannel` no Android ([`MethodChannelAndroid`][]) e
`FlutterMethodChannel` no iOS ([`MethodChanneliOS`][])
habilitam o recebimento de chamadas de método e o envio de volta de um
resultado. Essas classes permitem que você desenvolva um platform plugin
com muito pouco código 'boilerplate'.

:::note
Se desejado, chamadas de método também podem ser enviadas na direção reversa,
com a plataforma agindo como client para métodos implementados em Dart.
Para um exemplo concreto, confira o plugin [`quick_actions`][].
:::

### Suporte a tipos de dados e codecs do platform channel {:#codec}

Os platform channels padrão usam um codec de mensagem padrão que suporta
serialização binária eficiente de valores simples tipo JSON, como booleans,
números, Strings, byte buffers e Lists e Maps destes
(veja [`StandardMessageCodec`][] para detalhes).
A serialização e desserialização desses valores de e para
mensagens acontece automaticamente quando você envia e recebe valores.

A tabela a seguir mostra como valores Dart são recebidos no
lado da plataforma e vice-versa:

{% tabs "platform-channel-language" %}
{% tab "Kotlin" %}

| Dart              | Kotlin        |
| ----------------- | ------------- |
| `null`            | `null`        |
| `bool`            | `Boolean`     |
| `int` (<=32 bits) | `Int`         |
| `int` (>32 bits)  | `Long`        |
| `double`          | `Double`      |
| `String`          | `String`      |
| `Uint8List`       | `ByteArray`   |
| `Int32List`       | `IntArray`    |
| `Int64List`       | `LongArray`   |
| `Float32List`     | `FloatArray`  |
| `Float64List`     | `DoubleArray` |
| `List`            | `List`        |
| `Map`             | `HashMap`     |

{:.table .table-striped}

{% endtab %}
{% tab "Java" %}

| Dart              | Java                  |
| ----------------- | --------------------- |
| `null`            | `null`                |
| `bool`            | `java.lang.Boolean`   |
| `int` (<=32 bits) | `java.lang.Integer`   |
| `int` (>32 bits)  | `java.lang.Long`      |
| `double`          | `java.lang.Double`    |
| `String`          | `java.lang.String`    |
| `Uint8List`       | `byte[]`              |
| `Int32List`       | `int[]`               |
| `Int64List`       | `long[]`              |
| `Float32List`     | `float[]`             |
| `Float64List`     | `double[]`            |
| `List`            | `java.util.ArrayList` |
| `Map`             | `java.util.HashMap`   |

{:.table .table-striped}

{% endtab %}
{% tab "Swift" %}

| Dart              | Swift                                     |
| ----------------- | ----------------------------------------- |
| `null`            | `nil` (`NSNull` when nested)              |
| `bool`            | `NSNumber(value: Bool)`                   |
| `int` (<=32 bits) | `NSNumber(value: Int32)`                  |
| `int` (>32 bits)  | `NSNumber(value: Int)`                    |
| `double`          | `NSNumber(value: Double)`                 |
| `String`          | `String`                                  |
| `Uint8List`       | `FlutterStandardTypedData(bytes: Data)`   |
| `Int32List`       | `FlutterStandardTypedData(int32: Data)`   |
| `Int64List`       | `FlutterStandardTypedData(int64: Data)`   |
| `Float32List`     | `FlutterStandardTypedData(float32: Data)` |
| `Float64List`     | `FlutterStandardTypedData(float64: Data)` |
| `List`            | `Array`                                   |
| `Map`             | `Dictionary`                              |

{:.table .table-striped}

{% endtab %}
{% tab "Obj-C" %}

| Dart              | Objective-C                                      |
| ----------------- | ------------------------------------------------ |
| `null`            | `nil` (`NSNull` when nested)                     |
| `bool`            | `NSNumber numberWithBool:`                       |
| `int` (<=32 bits) | `NSNumber numberWithInt:`                        |
| `int` (>32 bits)  | `NSNumber numberWithLong:`                       |
| `double`          | `NSNumber numberWithDouble:`                     |
| `String`          | `NSString`                                       |
| `Uint8List`       | `FlutterStandardTypedData typedDataWithBytes:`   |
| `Int32List`       | `FlutterStandardTypedData typedDataWithInt32:`   |
| `Int64List`       | `FlutterStandardTypedData typedDataWithInt64:`   |
| `Float32List`     | `FlutterStandardTypedData typedDataWithFloat32:` |
| `Float64List`     | `FlutterStandardTypedData typedDataWithFloat64:` |
| `List`            | `NSArray`                                        |
| `Map`             | `NSDictionary`                                   |

{:.table .table-striped}

{% endtab %}
{% tab "C++" %}

| Dart               | C++                                                        |
| ------------------ | ---------------------------------------------------------- |
| `null`             | `EncodableValue()`                                         |
| `bool`             | `EncodableValue(bool)`                                     |
| `int` (<=32 bits)  | `EncodableValue(int32_t)`                                  |
| `int` (>32 bits)   | `EncodableValue(int64_t)`                                  |
| `double`           | `EncodableValue(double)`                                   |
| `String`           | `EncodableValue(std::string)`                              |
| `Uint8List`        | `EncodableValue(std::vector<uint8_t>)`                     |
| `Int32List`        | `EncodableValue(std::vector<int32_t>)`                     |
| `Int64List`        | `EncodableValue(std::vector<int64_t>)`                     |
| `Float32List`      | `EncodableValue(std::vector<float>)`                       |
| `Float64List`      | `EncodableValue(std::vector<double>)`                      |
| `List`             | `EncodableValue(std::vector<EncodableValue>)`              |
| `Map`              | `EncodableValue(std::map<EncodableValue, EncodableValue>)` |

{:.table .table-striped}

{% endtab %}
{% tab "C" %}

| Dart               | C (GObject)                 |
| ------------------ | --------------------------- |
| `null`             | `FlValue()`                 |
| `bool`             | `FlValue(bool)`             |
| `int`              | `FlValue(int64_t)`          |
| `double`           | `FlValue(double)`           |
| `String`           | `FlValue(gchar*)`           |
| `Uint8List`        | `FlValue(uint8_t*)`         |
| `Int32List`        | `FlValue(int32_t*)`         |
| `Int64List`        | `FlValue(int64_t*)`         |
| `Float32List`      | `FlValue(float*)`           |
| `Float64List`      | `FlValue(double*)`          |
| `List`             | `FlValue(FlValue)`          |
| `Map`              | `FlValue(FlValue, FlValue)` |

{:.table .table-striped}

{% endtab %}
{% endtabs %}

## Exemplo: Chamando código específico da plataforma usando platform channels {:#example}

O código a seguir demonstra como chamar
uma API específica da plataforma para recuperar e exibir
o nível atual da bateria. Ele usa
a API `BatteryManager` do Android,
a API `device.batteryLevel` do iOS,
a API `GetSystemPowerStatus` do Windows
e a API `UPower` do Linux com uma única
mensagem de plataforma, `getBatteryLevel()`.

O exemplo adiciona o código específico da plataforma dentro
do próprio app principal. Se você quiser reutilizar o
código específico da plataforma para múltiplos apps,
o passo de criação do projeto é ligeiramente diferente
(veja [developing packages][plugins]),
mas o código do platform channel
ainda é escrito da mesma forma.

:::note
O código-fonte completo e executável para este exemplo está
disponível em [`/examples/platform_channel/`][]
para Android com Java, iOS com Objective-C,
Windows com C++ e Linux com C.
Para iOS com Swift,
veja [`/examples/platform_channel_swift/`][].
:::

### Passo 1: Criar um novo projeto de app {:#example-project}

Comece criando um novo app:

* Em um terminal execute: `flutter create batterylevel`

Por padrão, nosso template suporta escrever código Android usando Kotlin
ou código iOS usando Swift. Para usar Java ou Objective-C,
use as flags `-i` e/ou `-a`:

* Em um terminal execute: `flutter create -i objc -a java batterylevel`

### Passo 2: Criar o client Flutter da plataforma {:#example-client}

A classe `State` do app mantém o estado atual do app.
Estenda isso para manter o estado atual da bateria.

Primeiro, construa o channel. Use um `MethodChannel` com um único
método de plataforma que retorna o nível da bateria.

Os lados client e host de um channel são conectados através
de um nome de channel passado no construtor do channel.
Todos os nomes de channel usados em um único app devem
ser únicos; prefixe o nome do channel com um 'prefixo de
domínio' único, por exemplo: `samples.flutterbrasil.dev/battery`.

<?code-excerpt "platform_channels/lib/platform_channels.dart (import)"?>
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
```

<?code-excerpt "platform_channels/lib/platform_channels.dart (my-home-page-state)"?>
```dart
class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  // Get battery level.
```

Em seguida, invoque um método no method channel,
especificando o método concreto para chamar usando
o identificador `String` `getBatteryLevel`.
A chamada pode falhar&mdash;por exemplo,
se a plataforma não suporta a
API da plataforma (como ao executar em um simulador),
então envolva a chamada `invokeMethod` em uma declaração try-catch.

Use o resultado retornado para atualizar o estado da interface do usuário em `_batteryLevel`
dentro de `setState`.

<?code-excerpt "platform_channels/lib/platform_channels.dart (get-battery)"?>
```dart
// Get battery level.
String _batteryLevel = 'Unknown battery level.';

Future<void> _getBatteryLevel() async {
  String batteryLevel;
  try {
    final result = await platform.invokeMethod<int>('getBatteryLevel');
    batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    batteryLevel = "Failed to get battery level: '${e.message}'.";
  }

  setState(() {
    _batteryLevel = batteryLevel;
  });
}
```

Finalmente, substitua o método `build` do template para
conter uma pequena interface de usuário que exibe o estado
da bateria em uma string e um botão para atualizar o valor.

<?code-excerpt "platform_channels/lib/platform_channels.dart (build)"?>
```dart
@override
Widget build(BuildContext context) {
  return Material(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
          Text(_batteryLevel),
        ],
      ),
    ),
  );
}
```

### Passo 3: Adicionar uma implementação específica da plataforma Android

{% tabs "android-language" %}
{% tab "Kotlin" %}

Comece abrindo a parte host Android do seu app Flutter
no Android Studio:

1. Inicie o Android Studio

1. Selecione o item de menu **File > Open...**

1. Navegue até o diretório que contém seu app Flutter
   e selecione a pasta **android** dentro dele. Clique em **OK**.

1. Abra o arquivo `MainActivity.kt` localizado na pasta **kotlin** na
   visualização Project.

Dentro do método `configureFlutterEngine()`, crie um `MethodChannel` e chame
`setMethodCallHandler()`. Certifique-se de usar o mesmo nome de channel
que foi usado no lado client do Flutter.

```kotlin title="MainActivity.kt"
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.flutterbrasil.dev/battery"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // This method is invoked on the main thread.
      // TODO
    }
  }
}
```

Adicione o código Kotlin Android que usa as APIs de bateria do Android para
recuperar o nível da bateria. Este código é exatamente o mesmo que você
escreveria em um app Android nativo.

Primeiro, adicione os imports necessários no topo do arquivo:

```kotlin title="MainActivity.kt"
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
```

Em seguida, adicione o seguinte método na classe `MainActivity`,
abaixo do método `configureFlutterEngine()`:

```kotlin title="MainActivity.kt"
  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }
```

Finalmente, complete o método `setMethodCallHandler()` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`.
A implementação deste método de plataforma chama o
código Android escrito no passo anterior e retorna uma resposta para ambos
os casos de sucesso e erro usando o argumento `result`.
Se um método desconhecido é chamado, reporte isso em vez disso.

Remova o seguinte código:

```kotlin title="MainActivity.kt"
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // This method is invoked on the main thread.
      // TODO
    }
```

E substitua pelo seguinte:

```kotlin title="MainActivity.kt"
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // This method is invoked on the main thread.
      call, result ->
      if (call.method == "getBatteryLevel") {
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }
```

{% endtab %}
{% tab "Java" %}

Comece abrindo a parte host Android do seu app Flutter
no Android Studio:

1. Inicie o Android Studio

1. Selecione o item de menu **File > Open...**

1. Navegue até o diretório que contém seu app Flutter
   e selecione a pasta **android** dentro dele. Clique em **OK**.

1. Abra o arquivo `MainActivity.java` localizado na pasta **java** na
   visualização Project.

Em seguida, crie um `MethodChannel` e defina um `MethodCallHandler`
dentro do método `configureFlutterEngine()`.
Certifique-se de usar o mesmo nome de channel que foi usado no
lado client do Flutter.

```java title="MainActivity.java"
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutterbrasil.dev/battery";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // This method is invoked on the main thread.
            // TODO
          }
        );
  }
}
```

Adicione o código Java Android que usa as APIs de bateria do Android para
recuperar o nível da bateria. Este código é exatamente o mesmo que você
escreveria em um app Android nativo.

Primeiro, adicione os imports necessários no topo do arquivo:

```java title="MainActivity.java"
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
```

Então adicione o seguinte como um novo método na classe activity,
abaixo do método `configureFlutterEngine()`:

```java title="MainActivity.java"
  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }
```

Finalmente, complete o método `setMethodCallHandler()` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`. A implementação deste
método de plataforma chama o código Android escrito
no passo anterior e retorna uma resposta para ambos
os casos de sucesso e erro usando o argumento `result`.
Se um método desconhecido é chamado, reporte isso em vez disso.

Remova o seguinte código:

```java title="MainActivity.java"
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // This method is invoked on the main thread.
            // TODO
          }
      );
```

E substitua pelo seguinte:

```java title="MainActivity.java"
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // This method is invoked on the main thread.
            if (call.method.equals("getBatteryLevel")) {
              int batteryLevel = getBatteryLevel();

              if (batteryLevel != -1) {
                result.success(batteryLevel);
              } else {
                result.error("UNAVAILABLE", "Battery level not available.", null);
              }
            } else {
              result.notImplemented();
            }
          }
      );
```

{% endtab %}
{% endtabs %}

Agora você deve poder executar o app no Android. Se estiver usando o Android
Emulator, defina o nível da bateria no painel Extended Controls
acessível através do botão **...** na barra de ferramentas.

### Passo 4: Adicionar uma implementação específica da plataforma iOS

{% tabs "darwin-language" %}
{% tab "Swift" %}

Comece abrindo a parte host iOS do seu app Flutter no Xcode:

1. Inicie o Xcode.

1. Selecione o item de menu **File > Open...**.

1. Navegue até o diretório que contém seu app Flutter e selecione a pasta **ios**
   dentro dele. Clique em **OK**.

Adicione suporte para Swift na configuração padrão do template que usa Objective-C:

1. **Expanda Runner > Runner** no navegador de projeto.

1. Abra o arquivo `AppDelegate.swift` localizado em **Runner > Runner**
   no navegador de projeto.

Sobrescreva a função `application:didFinishLaunchingWithOptions:` e crie
um `FlutterMethodChannel` vinculado ao nome do channel
`samples.flutterbrasil.dev/battery`:

```swift title="AppDelegate.swift"
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutterbrasil.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      // Handle battery messages.
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

Em seguida, adicione o código Swift do iOS que usa as APIs de bateria do iOS para recuperar
o nível da bateria. Este código é exatamente o mesmo que você
escreveria em um app iOS nativo.

Adicione o seguinte como um novo método no final de `AppDelegate.swift`:

```swift title="AppDelegate.swift"
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil))
  } else {
    result(Int(device.batteryLevel * 100))
  }
}
```

Finalmente, complete o método `setMethodCallHandler()` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`.
A implementação deste método de plataforma chama
o código iOS escrito no passo anterior. Se um método desconhecido
é chamado, reporte isso em vez disso.

```swift title="AppDelegate.swift"
batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // This method is invoked on the UI thread.
  guard call.method == "getBatteryLevel" else {
    result(FlutterMethodNotImplemented)
    return
  }
  self?.receiveBatteryLevel(result: result)
})
```

{% endtab %}
{% tab "Objective-C" %}

Comece abrindo a parte host iOS do app Flutter no Xcode:

1. Inicie o Xcode.

1. Selecione o item de menu **File > Open...**.

1. Navegue até o diretório que contém seu app Flutter
   e selecione a pasta **ios** dentro dele. Clique em **OK**.

1. Certifique-se de que os projetos Xcode compilam sem erros.

1. Abra o arquivo `AppDelegate.m`, localizado em **Runner > Runner**
   no navegador de projeto.

Crie um `FlutterMethodChannel` e adicione um handler dentro do método `application
didFinishLaunchingWithOptions:`.
Certifique-se de usar o mesmo nome de channel
que foi usado no lado client do Flutter.

```objc title="AppDelegate.m"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.flutterbrasil.dev/battery"
                                          binaryMessenger:controller.binaryMessenger];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    // This method is invoked on the UI thread.
    // TODO
  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
```

Em seguida, adicione o código Objective-C do iOS que usa as APIs de bateria do iOS para
recuperar o nível da bateria. Este código é exatamente o mesmo que você
escreveria em um app iOS nativo.

Adicione o seguinte método na classe `AppDelegate`, logo antes de `@end`:

```objc title="AppDelegate.m"
- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}
```

Finalmente, complete o método `setMethodCallHandler()` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`. A implementação deste
método de plataforma chama o código iOS escrito no passo anterior
e retorna uma resposta para ambos os casos de sucesso e erro usando
o argumento `result`. Se um método desconhecido é chamado, reporte isso em vez disso.

```objc title="AppDelegate.m"
__weak typeof(self) weakSelf = self;
[batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
  // This method is invoked on the UI thread.
  if ([@"getBatteryLevel" isEqualToString:call.method]) {
    int batteryLevel = [weakSelf getBatteryLevel];

    if (batteryLevel == -1) {
      result([FlutterError errorWithCode:@"UNAVAILABLE"
                                 message:@"Battery level not available."
                                 details:nil]);
    } else {
      result(@(batteryLevel));
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}];
```

{% endtab %}
{% endtabs %}

Agora você deve poder executar o app no iOS.
Se estiver usando o iOS Simulator,
note que ele não suporta APIs de bateria
e o app exibe 'Battery level not available'.

### Passo 5: Adicionar uma implementação específica da plataforma Windows

Comece abrindo a parte host Windows do seu app Flutter no Visual Studio:

1. Execute `flutter build windows` no diretório do seu projeto uma vez para gerar
   o arquivo de solução do Visual Studio.

1. Inicie o Visual Studio.

1. Selecione **Open a project or solution**.

1. Navegue até o diretório que contém seu app Flutter, depois para a pasta **build**,
   depois para a pasta **windows** e então selecione o arquivo `batterylevel.sln`.
   Clique em **Open**.

Adicione a implementação C++ do método platform channel:

1. Expanda **batterylevel > Source Files** no Solution Explorer.

1. Abra o arquivo `flutter_window.cpp`.

Primeiro, adicione os includes necessários no topo do arquivo, logo
após `#include "flutter_window.h"`:

```cpp title="flutter_window.cpp"
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>
```

Edite o método `FlutterWindow::OnCreate` e crie
um `flutter::MethodChannel` vinculado ao nome do channel
`samples.flutterbrasil.dev/battery`:

```cpp title="flutter_window.cpp"
bool FlutterWindow::OnCreate() {
  // ...
  RegisterPlugins(flutter_controller_->engine());

  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "samples.flutterbrasil.dev/battery",
      &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        // TODO
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  return true;
}
```

Em seguida, adicione o código C++ que usa as APIs de bateria do Windows para
recuperar o nível da bateria. Este código é exatamente o mesmo que
você escreveria em uma aplicação Windows nativa.

Adicione o seguinte como uma nova função no topo de
`flutter_window.cpp` logo após a seção `#include`:

```cpp title="flutter_window.cpp"
static int GetBatteryLevel() {
  SYSTEM_POWER_STATUS status;
  if (GetSystemPowerStatus(&status) == 0 || status.BatteryLifePercent == 255) {
    return -1;
  }
  return status.BatteryLifePercent;
}
```

Finalmente, complete o método `setMethodCallHandler()` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`.
A implementação deste método de plataforma chama
o código Windows escrito no passo anterior. Se um método desconhecido
é chamado, reporte isso em vez disso.

Remova o seguinte código:

```cpp title="flutter_window.cpp"
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        // TODO
      });
```

E substitua pelo seguinte:

```cpp title="flutter_window.cpp"
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        if (call.method_name() == "getBatteryLevel") {
          int battery_level = GetBatteryLevel();
          if (battery_level != -1) {
            result->Success(battery_level);
          } else {
            result->Error("UNAVAILABLE", "Battery level not available.");
          }
        } else {
          result->NotImplemented();
        }
      });
```

Agora você deve poder executar a aplicação no Windows.
Se seu dispositivo não tem uma bateria,
ele exibe 'Battery level not available'.

### Passo 6: Adicionar uma implementação específica da plataforma macOS

Comece abrindo a parte host macOS do seu app Flutter no Xcode:

1. Inicie o Xcode.

1. Selecione o item de menu **File > Open...**.

1. Navegue até o diretório que contém seu app Flutter e selecione a pasta **macos**
   dentro dele. Clique em **OK**.

Adicione a implementação Swift do método platform channel:

1. **Expanda Runner > Runner** no navegador de projeto.

1. Abra o arquivo `MainFlutterWindow.swift` localizado em **Runner > Runner**
   no navegador de projeto.

Primeiro, adicione o import necessário no topo do arquivo, logo após
`import FlutterMacOS`:

```swift title="MainFlutterWindow.swift"
import IOKit.ps
```

Crie um `FlutterMethodChannel` vinculado ao nome do channel
`samples.flutterbrasil.dev/battery` no método `awakeFromNib`:

```swift title="MainFlutterWindow.swift"
  override func awakeFromNib() {
    // ...
    self.setFrame(windowFrame, display: true)
  
    let batteryChannel = FlutterMethodChannel(
      name: "samples.flutterbrasil.dev/battery",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    batteryChannel.setMethodCallHandler { (call, result) in
      // This method is invoked on the UI thread.
      // Handle battery messages.
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
```

Em seguida, adicione o código Swift do macOS que usa as APIs de bateria IOKit para recuperar
o nível da bateria. Este código é exatamente o mesmo que você
escreveria em um app macOS nativo.

Adicione o seguinte como um novo método no final de `MainFlutterWindow.swift`:

```swift title="MainFlutterWindow.swift"
private func getBatteryLevel() -> Int? {
  let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
  let sources: Array<CFTypeRef> = IOPSCopyPowerSourcesList(info).takeRetainedValue() as Array
  if let source = sources.first {
    let description =
      IOPSGetPowerSourceDescription(info, source).takeUnretainedValue() as! [String: AnyObject]
    if let level = description[kIOPSCurrentCapacityKey] as? Int {
      return level
    }
  }
  return nil
}
```

Finalmente, complete o método `setMethodCallHandler` adicionado anteriormente.
Você precisa lidar com um único método de plataforma, `getBatteryLevel()`,
então teste isso no argumento `call`.
A implementação deste método de plataforma chama
o código macOS escrito no passo anterior. Se um método desconhecido
é chamado, reporte isso em vez disso.

```swift title="MainFlutterWindow.swift"
batteryChannel.setMethodCallHandler { (call, result) in
  switch call.method {
  case "getBatteryLevel":
    guard let level = getBatteryLevel() else {
      result(
        FlutterError(
          code: "UNAVAILABLE",
          message: "Battery level not available",
          details: nil))
     return
    }
    result(level)
  default:
    result(FlutterMethodNotImplemented)
  }
}
```

Agora você deve poder executar a aplicação no macOS.
Se seu dispositivo não tem uma bateria,
ele exibe 'Battery level not available'.

### Passo 7: Adicionar uma implementação específica da plataforma Linux

Para este exemplo você precisa instalar os headers de desenvolvedor do `upower`.
Isso provavelmente está disponível na sua distribuição, por exemplo com:

```console
sudo apt install libupower-glib-dev
```

Comece abrindo a parte host Linux do seu app Flutter no editor
de sua escolha. As instruções abaixo são para o Visual Studio Code com as
extensões "C/C++" e "CMake" instaladas, mas podem ser ajustadas para outros IDEs.

1. Inicie o Visual Studio Code.

1. Abra o diretório **linux** dentro do seu projeto.

1. Escolha **Yes** no prompt perguntando: `Would you like to configure project "linux"?`.
   Isso habilita o autocomplete C++.

1. Abra o arquivo `runner/my_application.cc`.

Primeiro, adicione os includes necessários no topo do arquivo, logo
após `#include <flutter_linux/flutter_linux.h>`:

```c title="runner/my_application.cc"
#include <math.h>
#include <upower.h>
```

Adicione um `FlMethodChannel` à struct `_MyApplication`:

```c title="runnner/my_application.cc"
struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  FlMethodChannel* battery_channel;
};
```

Certifique-se de limpá-lo em `my_application_dispose`:

```c title="runner/my_application.cc"
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_object(&self->battery_channel);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}
```

Edite o método `my_application_activate` e inicialize
`battery_channel` usando o nome do channel
`samples.flutterbrasil.dev/battery`, logo após a chamada a
`fl_register_plugins`:

```c title="runner/my_application.cc"
static void my_application_activate(GApplication* application) {
  // ...
  fl_register_plugins(FL_PLUGIN_REGISTRY(self->view));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->battery_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "samples.flutterbrasil.dev/battery", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      self->battery_channel, battery_method_call_handler, self, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(self->view));
}
```

Em seguida, adicione o código C que usa as APIs de bateria do Linux para
recuperar o nível da bateria. Este código é exatamente o mesmo que
você escreveria em uma aplicação Linux nativa.

Adicione o seguinte como uma nova função no topo de
`my_application.cc` logo após a linha `G_DEFINE_TYPE`:

```c title="runner/my_application.cc"
static FlMethodResponse* get_battery_level() {
  // Find the first available battery and report that.
  g_autoptr(UpClient) up_client = up_client_new();
  g_autoptr(GPtrArray) devices = up_client_get_devices2(up_client);
  if (devices->len == 0) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "UNAVAILABLE", "Device does not have a battery.", nullptr));
  }

  UpDevice* device = UP_DEVICE(g_ptr_array_index(devices, 0));
  double percentage = 0;
  g_object_get(device, "percentage", &percentage, nullptr);

  g_autoptr(FlValue) result =
      fl_value_new_int(static_cast<int64_t>(round(percentage)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}
```

Finalmente, adicione a função `battery_method_call_handler` referenciada
na chamada anterior a `fl_method_channel_set_method_call_handler`.
Você precisa lidar com um único método de plataforma, `getBatteryLevel`,
então teste isso no argumento `method_call`.
A implementação desta função chama
o código Linux escrito no passo anterior. Se um método desconhecido
é chamado, reporte isso em vez disso.

Adicione o seguinte código após a função `get_battery_level`:

```cpp title="runner/my_application.cpp"
static void battery_method_call_handler(FlMethodChannel* channel,
                                        FlMethodCall* method_call,
                                        gpointer user_data) {
  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(fl_method_call_get_name(method_call), "getBatteryLevel") == 0) {
    response = get_battery_level();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error)) {
    g_warning("Failed to send response: %s", error->message);
  }
}
```

Agora você deve poder executar a aplicação no Linux.
Se seu dispositivo não tem uma bateria,
ele exibe 'Battery level not available'.

## Platform channels typesafe usando Pigeon {:#pigeon}

O exemplo anterior usa `MethodChannel`
para comunicação entre o host e o client,
o que não é typesafe. Chamar e receber
mensagens depende do host e client declararem
os mesmos argumentos e tipos de dados para que as mensagens funcionem.
Você pode usar o pacote [Pigeon][pigeon] como
uma alternativa ao `MethodChannel`
para gerar código que envia mensagens de uma
maneira estruturada e typesafe.

Com [Pigeon][pigeon], o protocolo de mensagens é definido
em um subconjunto de Dart que então gera código de mensagens
para Android, iOS, macOS ou Windows. Você pode encontrar um exemplo mais completo
e mais informações na página do [`pigeon`][pigeon]
no pub.dev.

Usar [Pigeon][pigeon] elimina a necessidade de combinar
strings entre host e client
para os nomes e tipos de dados das mensagens.
Ele suporta: classes aninhadas, agrupamento de
mensagens em APIs, geração de
código wrapper assíncrono e envio de mensagens
em ambas as direções. O código gerado é legível
e garante que não há conflitos entre
múltiplos clients de diferentes versões.
Linguagens suportadas são Objective-C, Java, Kotlin, C++
e Swift (com interop Objective-C).

### Exemplo Pigeon

**Arquivo Pigeon:**

<?code-excerpt "pigeon/lib/pigeon_source.dart (search)"?>
```dart
import 'package:pigeon/pigeon.dart';

class SearchRequest {
  final String query;

  SearchRequest({required this.query});
}

class SearchReply {
  final String result;

  SearchReply({required this.result});
}

@HostApi()
abstract class Api {
  @async
  SearchReply search(SearchRequest request);
}
```

**Uso em Dart:**

<?code-excerpt "pigeon/lib/use_pigeon.dart (use-api)"?>
```dart
import 'generated_pigeon.dart';

Future<void> onClick() async {
  SearchRequest request = SearchRequest(query: 'test');
  Api api = SomeApi();
  SearchReply reply = await api.search(request);
  print('reply: ${reply.result}');
}
```

## Separar código específico da plataforma do código UI {:#separate}

Se você espera usar seu código específico da plataforma
em múltiplos apps Flutter, você pode considerar
separar o código em um platform plugin localizado
em um diretório fora da sua aplicação principal.
Veja [developing packages][] para detalhes.

## Publicar código específico da plataforma como um pacote {:#publish}

Para compartilhar seu código específico da plataforma com outros desenvolvedores
no ecossistema Flutter, veja [publishing packages][].

## Channels e codecs customizados

Além do `MethodChannel` mencionado acima,
você também pode usar o mais básico
[`BasicMessageChannel`][], que suporta passagem de
mensagens assíncrona básica usando um codec de mensagem customizado.
Você também pode usar as classes especializadas [`BinaryCodec`][],
[`StringCodec`][] e [`JSONMessageCodec`][],
ou criar seu próprio codec.

Você também pode conferir um exemplo de codec customizado
no plugin [`cloud_firestore`][],
que é capaz de serializar e desserializar muitos mais
tipos do que os tipos padrão.

## Channels e threading da plataforma

Ao invocar channels no lado da plataforma destinados ao Flutter,
invoque-os na thread principal da plataforma.
Ao invocar channels no Flutter destinados ao lado da plataforma,
invoque-os de qualquer `Isolate` que seja o `Isolate`
raiz, _ou_ que esteja registrado como um `Isolate` de background.
Os handlers para o lado da plataforma podem executar na thread principal da plataforma
ou podem executar em uma thread de background se usar uma Task Queue.
Você pode invocar os handlers do lado da plataforma assincronamente
e em qualquer thread.

:::note
No Android, a thread principal da plataforma às vezes é
chamada de "main thread", mas é tecnicamente definida
como [the UI thread][]. Anote métodos que precisam
ser executados na UI thread com `@UiThread`.
No iOS, essa thread é oficialmente
referida como [the main thread][].
:::

### Usando plugins e channels de isolates de background

Plugins e channels podem ser usados por qualquer `Isolate`, mas esse `Isolate` tem que ser
um `Isolate` raiz (o criado pelo Flutter) ou registrado como um `Isolate`
de background para um `Isolate` raiz.

O exemplo a seguir mostra como registrar um `Isolate` de background para
usar um plugin de um `Isolate` de background.

```dart
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _isolateMain(RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getBool('isDebug'));
}

void main() {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
}
```

### Executando handlers de channel em threads de background

Para que um handler do lado da plataforma de um channel
execute em uma thread de background, você deve usar a
API Task Queue. Atualmente, esta funcionalidade é suportada
apenas no iOS e Android.

Em Kotlin:

```kotlin
override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
  val taskQueue =
      flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
  channel = MethodChannel(flutterPluginBinding.binaryMessenger,
                          "com.example.foo",
                          StandardMethodCodec.INSTANCE,
                          taskQueue)
  channel.setMethodCallHandler(this)
}
```

Em Java:

```java
@Override
public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
  BinaryMessenger messenger = binding.getBinaryMessenger();
  BinaryMessenger.TaskQueue taskQueue =
      messenger.makeBackgroundTaskQueue();
  channel =
      new MethodChannel(
          messenger,
          "com.example.foo",
          StandardMethodCodec.INSTANCE,
          taskQueue);
  channel.setMethodCallHandler(this);
}
```

Em Swift:

:::note
Na versão 2.10, a API Task Queue está disponível apenas no canal `master`
para iOS.
:::

```swift
public static func register(with registrar: FlutterPluginRegistrar) {
  let taskQueue = registrar.messenger().makeBackgroundTaskQueue?()
  let channel = FlutterMethodChannel(name: "com.example.foo",
                                     binaryMessenger: registrar.messenger(),
                                     codec: FlutterStandardMethodCodec.sharedInstance(),
                                     taskQueue: taskQueue)
  let instance = MyPlugin()
  registrar.addMethodCallDelegate(instance, channel: channel)
}
```

Em Objective-C:

:::note
Na versão 2.10, a API Task Queue está disponível apenas no canal `master`
para iOS.
:::

```objc
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  NSObject<FlutterTaskQueue>* taskQueue =
      [[registrar messenger] makeBackgroundTaskQueue];
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"com.example.foo"
                                  binaryMessenger:[registrar messenger]
                                            codec:[FlutterStandardMethodCodec sharedInstance]
                                        taskQueue:taskQueue];
  MyPlugin* instance = [[MyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
```

### Saltando para a UI thread no Android

Para cumprir o requisito de UI thread dos channels,
você pode precisar saltar de uma thread de background
para a UI thread do Android para executar um método de channel.
No Android, você pode fazer isso usando `post()` em um
`Runnable` no `Looper` da UI thread do Android,
o que faz com que o `Runnable` execute na
thread principal na próxima oportunidade.

Em Kotlin:

```kotlin
Handler(Looper.getMainLooper()).post {
  // Call the desired channel message here.
}
```

Em Java:

```java
new Handler(Looper.getMainLooper()).post(new Runnable() {
  @Override
  public void run() {
    // Call the desired channel message here.
  }
});
```

### Saltando para a main thread no iOS

Para cumprir o requisito de main thread do channel,
você pode precisar saltar de uma thread de background para
a main thread do iOS para executar um método de channel.
Você pode fazer isso no iOS executando um
[block][] na [dispatch queue][] principal:

Em Objective-C:

```objc
dispatch_async(dispatch_get_main_queue(), ^{
  // Call the desired channel message here.
});
```

Em Swift:

```swift
DispatchQueue.main.async {
  // Call the desired channel message here.
}
```

[`BasicMessageChannel`]: {{site.api}}/flutter/services/BasicMessageChannel-class.html
[`BinaryCodec`]: {{site.api}}/flutter/services/BinaryCodec-class.html
[block]: {{site.apple-dev}}/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithBlocks/WorkingwithBlocks.html
[`cloud_firestore`]: {{site.github}}/firebase/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore_platform_interface/lib/src/method_channel/utils/firestore_message_codec.dart
[`dart:html` library]: {{site.dart.api}}/dart-html/dart-html-library.html
[developing packages]: /packages-and-plugins/developing-packages
[plugins]: /packages-and-plugins/developing-packages#plugin
[dispatch queue]: {{site.apple-dev}}/documentation/dispatch/dispatchqueue
[`/examples/platform_channel/`]: {{site.repo.flutter}}/tree/main/examples/platform_channel
[`/examples/platform_channel_swift/`]: {{site.repo.flutter}}/tree/main/examples/platform_channel_swift
[JS interoperability]: {{site.dart-site}}/web/js-interop
[`JSONMessageCodec`]: {{site.api}}/flutter/services/JSONMessageCodec-class.html
[`MethodChannel`]: {{site.api}}/flutter/services/MethodChannel-class.html
[`MethodChannelAndroid`]: {{site.api}}/javadoc/io/flutter/plugin/common/MethodChannel.html
[`MethodChanneliOS`]: {{site.api}}/ios-embedder/interface_flutter_method_channel.html
[Platform adaptations]: /platform-integration/platform-adaptations
[publishing packages]: /packages-and-plugins/developing-packages#publish
[`quick_actions`]: {{site.pub}}/packages/quick_actions
[section on threading]: #channels-and-platform-threading
[`StandardMessageCodec`]: {{site.api}}/flutter/services/StandardMessageCodec-class.html
[`StringCodec`]: {{site.api}}/flutter/services/StringCodec-class.html
[the main thread]: {{site.apple-dev}}/documentation/uikit?language=objc
[the UI thread]: {{site.android-dev}}/guide/components/processes-and-threads#Threads
[sending structured typesafe messages]: #pigeon
