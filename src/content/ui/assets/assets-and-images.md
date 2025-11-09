---
ia-translate: true
title: Adicionando assets e imagens
description: Como usar imagens (e outros assets) em seu app Flutter.
shortTitle: Assets e imagens
---

<?code-excerpt path-base="ui/assets_and_images/lib"?>

Apps Flutter podem incluir tanto código quanto _assets_
(às vezes chamados de recursos). Um asset é um arquivo
que é empacotado e implantado com seu app,
e é acessível em tempo de execução. Tipos comuns de assets incluem
dados estáticos (por exemplo, arquivos JSON),
arquivos de configuração, ícones e imagens
(JPEG, WebP, GIF, WebP/GIF animados, PNG, BMP e WBMP).

## Especificando assets

Flutter usa o arquivo [`pubspec.yaml`][`pubspec.yaml`],
localizado na raiz do seu projeto,
para identificar assets requeridos por um app.

Aqui está um exemplo:

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

Para incluir todos os assets em um diretório,
especifique o nome do diretório com o caractere `/` no final:

```yaml
flutter:
  assets:
    - directory/
    - directory/subdirectory/
```

:::note
Apenas arquivos localizados diretamente no diretório são incluídos.
[Variantes de imagens de assets resolution-aware](#resolution-aware) são a única exceção.
Para adicionar arquivos localizados em subdiretórios, crie uma entrada por diretório.
:::

:::note
Indentação importa em YAML. Se você ver um erro como
`Error: unable to find directory entry in pubspec.yaml`
então você _pode_ ter indentado incorretamente no seu
arquivo pubspec. Considere o seguinte exemplo [incorreto]:
```yaml
flutter:
assets:
  - directory/
```
A linha `assets:` deve ser indentada por exatamente
dois espaços abaixo da linha `flutter:`:
```yaml
flutter:
  assets:
    - directory/
```
:::

### Empacotamento de assets

A subseção `assets` da seção `flutter`
especifica arquivos que devem ser incluídos com o app.
Cada asset é identificado por um caminho explícito
(relativo ao arquivo `pubspec.yaml`) onde o arquivo
de asset está localizado. A ordem na qual os assets são
declarados não importa. O nome real do diretório usado
(`assets` no primeiro exemplo ou `directory` no exemplo acima)
não importa.

Durante uma compilação, Flutter coloca assets em um arquivo
especial chamado _asset bundle_ que apps leem
em tempo de execução.

### Transformação automática de arquivos de assets no momento da compilação

Flutter suporta o uso de um pacote Dart para transformar arquivos de assets ao compilar seu app.
Para fazer isso, especifique os arquivos de assets e o pacote transformador no seu arquivo pubspec.
Para aprender como fazer isso e escrever seus próprios pacotes de transformação de assets, veja
[Transforming assets at build time][Transforming assets at build time].

## Carregando assets

Seu app pode acessar seus assets através de um
objeto [`AssetBundle`][`AssetBundle`].

Os dois principais métodos em um asset bundle permitem que você carregue um
asset de string/texto (`loadString()`) ou um asset de imagem/binário (`load()`)
do bundle, dado uma chave lógica. A chave lógica mapeia para o caminho
do asset especificado no arquivo `pubspec.yaml` no momento da compilação.

### Carregando assets de texto

Cada app Flutter tem um objeto [`rootBundle`][`rootBundle`]
para fácil acesso ao asset bundle principal.
É possível carregar assets diretamente usando o
global static `rootBundle` de
`package:flutter/services.dart`.

No entanto, é recomendado obter o `AssetBundle`
para o `BuildContext` atual usando
[`DefaultAssetBundle`][`DefaultAssetBundle`], ao invés do asset
bundle padrão que foi compilado com o app; esta
abordagem permite que um widget pai substitua um
`AssetBundle` diferente em tempo de execução,
o que pode ser útil para cenários de localização ou testes.

Tipicamente, você usará `DefaultAssetBundle.of()`
para carregar indiretamente um asset, por exemplo um arquivo JSON,
do `rootBundle` em tempo de execução do app.

{% comment %}
  Need example here to show obtaining the AssetBundle for the current
  BuildContext using DefaultAssetBundle.of
{% endcomment %}

Fora de um contexto `Widget`, ou quando um handle
para um `AssetBundle` não está disponível,
você pode usar `rootBundle` para carregar tais assets diretamente.
Por exemplo:

<?code-excerpt "main.dart (root-bundle-load)"?>
```dart
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}
```

### Carregando imagens

Para carregar uma imagem, use a classe [`AssetImage`][`AssetImage`]
no método `build()` de um widget.

Por exemplo, seu app pode carregar a imagem
de fundo das declarações de assets no exemplo anterior:

<?code-excerpt "main.dart (background-image)"?>
```dart
return const Image(image: AssetImage('assets/background.png'));
```

### Assets de imagens resolution-aware {:#resolution-aware}

Flutter pode carregar imagens com resolução apropriada para
a [device pixel ratio][device pixel ratio] atual.

[`AssetImage`][`AssetImage`] mapeará um asset lógico solicitado
para um que corresponda mais de perto à
[device pixel ratio][device pixel ratio] atual.

Para este mapeamento funcionar, assets devem ser organizados
de acordo com uma estrutura de diretório específica:

```plaintext
.../image.png
.../Mx/image.png
.../Nx/image.png
...etc.
```

Onde _M_ e _N_ são identificadores numéricos que correspondem
à resolução nominal das imagens contidas dentro.
Em outras palavras, eles especificam a device pixel ratio para
a qual as imagens são destinadas.

Neste exemplo, `image.png` é considerado o *asset principal*,
enquanto `Mx/image.png` e `Nx/image.png` são consideradas
*variantes*.

O asset principal é assumido corresponder a uma resolução de 1.0.
Por exemplo, considere o seguinte layout de assets para uma
imagem chamada `my_icon.png`:

```plaintext
.../my_icon.png       (mdpi baseline)
.../1.5x/my_icon.png  (hdpi)
.../2.0x/my_icon.png  (xhdpi)
.../3.0x/my_icon.png  (xxhdpi)
.../4.0x/my_icon.png  (xxxhdpi)
```

Em dispositivos com uma device pixel ratio de 1.8, o asset
`.../2.0x/my_icon.png` é escolhido.
Para uma device pixel ratio de 2.7, o asset
`.../3.0x/my_icon.png` é escolhido.

Se a largura e altura da imagem renderizada não forem especificadas
no widget `Image`, a resolução nominal é usada para escalar
o asset para que ele ocupe a mesma quantidade de espaço na tela
que o asset principal ocuparia, apenas com uma resolução maior.
Ou seja, se `.../my_icon.png` tem 72px por 72px, então
`.../3.0x/my_icon.png` deve ter 216px por 216px;
mas ambos renderizam em 72px por 72px (em pixels lógicos),
se largura e altura não forem especificadas.

:::note
[Device pixel ratio][Device pixel ratio] depende de [MediaQueryData.size][MediaQueryData.size], que requer ter
[MaterialApp][MaterialApp] ou [CupertinoApp][CupertinoApp] como ancestral do seu [`AssetImage`][`AssetImage`].
:::

#### Empacotamento de assets de imagens resolution-aware {:#resolution-aware-bundling}

Você só precisa especificar o asset principal ou seu diretório pai
na seção `assets` do `pubspec.yaml`.
Flutter empacota as variantes para você.
Cada entrada deve corresponder a um arquivo real, com exceção da
entrada do asset principal. Se a entrada do asset principal não corresponder
a um arquivo real, então o asset com a menor resolução
é usado como fallback para dispositivos com device pixel
ratios abaixo dessa resolução. A entrada ainda deve
ser incluída no manifesto `pubspec.yaml`, no entanto.

Qualquer coisa usando o asset bundle padrão herda awareness de resolução
ao carregar imagens. (Se você trabalhar com algumas das classes de
nível mais baixo, como [`ImageStream`][`ImageStream`] ou [`ImageCache`][`ImageCache`],
você também notará parâmetros relacionados à escala.)

### Imagens de assets em dependências de pacotes {:#from-packages}

Para carregar uma imagem de uma dependência de [package][package],
o argumento `package` deve ser fornecido para [`AssetImage`][`AssetImage`].

Por exemplo, suponha que sua aplicação dependa de um pacote
chamado `my_icons`, que tem a seguinte estrutura de diretórios:

```plaintext
.../pubspec.yaml
.../icons/heart.png
.../icons/1.5x/heart.png
.../icons/2.0x/heart.png
...etc.
```

Para carregar a imagem, use:

<?code-excerpt "main.dart (package-image)"?>
```dart
return const AssetImage('icons/heart.png', package: 'my_icons');
```

Assets usados pelo próprio pacote também devem ser buscados
usando o argumento `package` como acima.

#### Empacotamento de assets de pacotes

Se o asset desejado é especificado no arquivo `pubspec.yaml`
do pacote, ele é empacotado automaticamente com a
aplicação. Em particular, assets usados pelo próprio
pacote devem ser especificados em seu `pubspec.yaml`.

Um pacote também pode escolher ter assets em sua pasta `lib/`
que não são especificados em seu arquivo `pubspec.yaml`.
Neste caso, para que essas imagens sejam empacotadas,
a aplicação deve especificar quais incluir em seu
`pubspec.yaml`. Por exemplo, um pacote chamado `fancy_backgrounds`
poderia ter os seguintes arquivos:

```plaintext
.../lib/backgrounds/background1.png
.../lib/backgrounds/background2.png
.../lib/backgrounds/background3.png
```

Para incluir, digamos, a primeira imagem, o `pubspec.yaml` da
aplicação deve especificá-la na seção `assets`:

```yaml
flutter:
  assets:
    - packages/fancy_backgrounds/backgrounds/background1.png
```

O `lib/` é implícito,
então não deve ser incluído no caminho do asset.

Se você está desenvolvendo um pacote, para carregar um asset dentro do pacote, especifique-o no `pubspec.yaml` do pacote:

```yaml
flutter:
  assets:
    - assets/images/
```

Para carregar a imagem dentro do seu pacote, use:

```dart
return const AssetImage('packages/fancy_backgrounds/backgrounds/background1.png');
```

## Compartilhando assets com a plataforma subjacente

Assets Flutter estão prontamente disponíveis para código de plataforma
usando o `AssetManager` no Android e `NSBundle` no iOS.

### Carregando assets Flutter no Android

No Android os assets estão disponíveis através da
API [`AssetManager`][`AssetManager`]. A chave de lookup usada em,
por exemplo [`openFd`][`openFd`], é obtida de
`lookupKeyForAsset` em [`PluginRegistry.Registrar`][`PluginRegistry.Registrar`] ou
`getLookupKeyForAsset` em [`FlutterView`][`FlutterView`].
`PluginRegistry.Registrar` está disponível ao desenvolver um plugin
enquanto `FlutterView` seria a escolha ao desenvolver um
app incluindo uma platform view.

Como um exemplo, suponha que você especificou o seguinte
em seu pubspec.yaml

```yaml
flutter:
  assets:
    - icons/heart.png
```

Isso reflete a seguinte estrutura em seu app Flutter.

```plaintext
.../pubspec.yaml
.../icons/heart.png
...etc.
```

Para acessar `icons/heart.png` do seu código de plugin Java,
faça o seguinte:

```java
AssetManager assetManager = registrar.context().getAssets();
String key = registrar.lookupKeyForAsset("icons/heart.png");
AssetFileDescriptor fd = assetManager.openFd(key);
```

### Carregando assets Flutter no iOS

No iOS os assets estão disponíveis através do [`mainBundle`][`mainBundle`].
A chave de lookup usada em, por exemplo [`pathForResource:ofType:`][`pathForResource:ofType:`],
é obtida de `lookupKeyForAsset` ou `lookupKeyForAsset:fromPackage:`
em [`FlutterPluginRegistrar`][`FlutterPluginRegistrar`], ou `lookupKeyForAsset:` ou
`lookupKeyForAsset:fromPackage:` em [`FlutterViewController`][`FlutterViewController`].
`FlutterPluginRegistrar` está disponível ao desenvolver
um plugin enquanto `FlutterViewController` seria a escolha
ao desenvolver um app incluindo uma platform view.

Como um exemplo, suponha que você tenha a configuração Flutter de acima.

Para acessar `icons/heart.png` do seu código de plugin Objective-C você
faria o seguinte:

```objc
NSString* key = [registrar lookupKeyForAsset:@"icons/heart.png"];
NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
```

Para acessar `icons/heart.png` do seu app Swift você
faria o seguinte:

```swift
let key = controller.lookupKey(forAsset: "icons/heart.png")
let mainBundle = Bundle.main
let path = mainBundle.path(forResource: key, ofType: nil)
```

Para um exemplo mais completo, veja a implementação do
plugin Flutter [`video_player` plugin][`video_player` plugin] no pub.dev.

### Carregando imagens iOS no Flutter

Ao implementar Flutter
[adicionando-o a um app iOS existente][add-to-app],
você pode ter imagens hospedadas no iOS que deseja
usar no Flutter. Para realizar
isso, use [platform channels][platform channels] para passar os dados da imagem
para Dart como `FlutterStandardTypedData`.

## Assets de plataforma

Existem outras ocasiões para trabalhar com assets nos
projetos de plataforma diretamente. Abaixo estão dois casos comuns
onde assets são usados antes que o framework Flutter seja
carregado e executando.

### Atualizando o ícone do app

Atualizar o ícone de lançamento de uma aplicação Flutter funciona
da mesma forma que atualizar ícones de lançamento em aplicações
nativas Android ou iOS.

![Launch icon](/assets/images/docs/assets-and-images/icon.png)

#### Android

No diretório raiz do seu projeto Flutter, navegue para
`.../android/app/src/main/res`. As várias pastas de recursos
bitmap como `mipmap-hdpi` já contêm imagens placeholder
chamadas `ic_launcher.png`. Substitua-as com seus
assets desejados respeitando o tamanho de ícone recomendado por
densidade de tela conforme indicado pelo [Android Developer Guide][Android Developer Guide].

![Android icon location](/assets/images/docs/assets-and-images/android-icon-path.png)

:::note
Se você renomear os arquivos `.png`, você também deve atualizar o
nome correspondente no atributo `android:icon` da tag `<application>`
do seu `AndroidManifest.xml`.
:::

#### iOS

No diretório raiz do seu projeto Flutter,
navegue para `.../ios/Runner`. O diretório
`Assets.xcassets/AppIcon.appiconset` já contém
imagens placeholder. Substitua-as com imagens de tamanho
apropriado conforme indicado por seus nomes de arquivo conforme ditado pelas
[Human Interface Guidelines][Human Interface Guidelines] da Apple.
Mantenha os nomes de arquivo originais.

![iOS icon location](/assets/images/docs/assets-and-images/ios-icon-path.png)

### Atualizando a tela de lançamento

<p align="center">
  <img src="/assets/images/docs/assets-and-images/launch-screen.png" alt="Launch screen" />
</p>

Flutter também usa mecanismos de plataforma nativa para desenhar
telas de lançamento transicionais para seu app Flutter enquanto o
framework Flutter carrega. Esta tela de lançamento persiste até
Flutter renderizar o primeiro frame de sua aplicação.

:::note
Isso implica que se você não chamar [`runApp()`][`runApp()`] na
função `main()` do seu app (ou mais especificamente,
se você não chamar [`FlutterView.render()`][`FlutterView.render()`] em resposta a
[`PlatformDispatcher.onDrawFrame`][`PlatformDispatcher.onDrawFrame`]),
a tela de lançamento persiste para sempre.
:::

[`FlutterView.render()`]: {{site.api}}/flutter/dart-ui/FlutterView/render.html
[`PlatformDispatcher.onDrawFrame`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onDrawFrame.html

#### Android

Para adicionar uma tela de lançamento (também conhecida como "splash screen") ao seu
aplicativo Flutter, navegue para `.../android/app/src/main`.
Em `res/drawable/launch_background.xml`,
use este [layer list drawable][layer list drawable] XML para customizar
a aparência da sua tela de lançamento. O template existente fornece
um exemplo de adicionar uma imagem ao meio de uma splash
screen branca em código comentado. Você pode descomentar ou usar outros
[drawables][drawables] para alcançar o efeito desejado.

Para mais detalhes, veja
[Adding a splash screen to your Android app][Adding a splash screen to your Android app].

#### iOS

Para adicionar uma imagem ao centro da sua "splash screen",
navegue para `.../ios/Runner`.
Em `Assets.xcassets/LaunchImage.imageset`,
coloque imagens chamadas `LaunchImage.png`,
`LaunchImage@2x.png`, `LaunchImage@3x.png`.
Se você usar nomes de arquivo diferentes,
atualize o arquivo `Contents.json` no mesmo diretório.

Você também pode customizar completamente seu storyboard de tela de lançamento
no Xcode abrindo `.../ios/Runner.xcworkspace`.
Navegue para `Runner/Runner` no Project Navigator e
coloque imagens abrindo `Assets.xcassets` ou faça qualquer
customização usando o Interface Builder em
`LaunchScreen.storyboard`.

![Adding launch icons in Xcode](/assets/images/docs/assets-and-images/ios-launchscreen-xcode.png){:width="100%"}

Para mais detalhes, veja
[Adding a splash screen to your iOS app][Adding a splash screen to your iOS app].


[add-to-app]: /add-to-app/ios
[Adding a splash screen to your Android app]: /platform-integration/android/splash-screen
[Adding a splash screen to your iOS app]: /platform-integration/ios/splash-screen
[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[`AssetImage`]: {{site.api}}/flutter/painting/AssetImage-class.html
[`DefaultAssetBundle`]: {{site.api}}/flutter/widgets/DefaultAssetBundle-class.html
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`ImageStream`]: {{site.api}}/flutter/painting/ImageStream-class.html
[Android Developer Guide]: {{site.android-dev}}/training/multiscreen/screendensities
[`AssetManager`]: {{site.android-dev}}/reference/android/content/res/AssetManager
[device pixel ratio]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[Device pixel ratio]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[drawables]: {{site.android-dev}}/guide/topics/resources/drawable-resource
[`FlutterPluginRegistrar`]: {{site.api}}/ios-embedder/protocol_flutter_plugin_registrar-p.html
[`FlutterView`]: {{site.api}}/javadoc/io/flutter/view/FlutterView.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons
[platform channels]: /platform-integration/platform-channels
[layer list drawable]: {{site.android-dev}}/guide/topics/resources/drawable-resource#LayerList
[`mainBundle`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410786-mainbundle
[`openFd`]: {{site.android-dev}}/reference/android/content/res/AssetManager#openFd(java.lang.String)
[package]: /packages-and-plugins/using-packages
[`pathForResource:ofType:`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410989-pathforresource
[`PluginRegistry.Registrar`]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
[`pubspec.yaml`]: {{site.dart-site}}/tools/pub/pubspec
[`rootBundle`]: {{site.api}}/flutter/services/rootBundle.html
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`video_player` plugin]: {{site.pub}}/packages/video_player
[MediaQueryData.size]: {{site.api}}/flutter/widgets/MediaQueryData/size.html
[MaterialApp]: {{site.api}}/flutter/material/MaterialApp-class.html
[CupertinoApp]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[Transforming assets at build time]: /ui/assets/asset-transformation
[flavors feature]: /deployment/flavors
