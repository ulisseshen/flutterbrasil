---
title: Adicionando assets e imagens
description: Como usar imagens (e outros assets) em seu app Flutter.
short-title: Assets e imagens
ia-translate: true
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

O Flutter usa o arquivo [`pubspec.yaml`][],
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
[Variantes de imagens assets com resolução adaptável](#resolution-aware) são a única exceção.
Para adicionar arquivos localizados em subdiretórios, crie uma entrada por diretório.
:::

:::note
A indentação é importante em YAML. Se você ver um erro como
`Error: unable to find directory entry in pubspec.yaml`
então você _pode_ ter indentado incorretamente em seu
arquivo pubspec. Considere o seguinte exemplo [incorreto]:
```yaml
flutter:
assets:
  - directory/
```
A linha `assets:` deve ser indentada exatamente
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
do asset está localizado. A ordem em que os assets são
declarados não importa. O nome real do diretório usado
(`assets` no primeiro exemplo ou `directory` no exemplo
acima) não importa.

Durante um build, o Flutter coloca os assets em um arquivo
especial chamado _asset bundle_ que os apps leem
em tempo de execução.

### Transformação automática de arquivos de assets em tempo de build

O Flutter suporta o uso de um pacote Dart para transformar arquivos de assets ao construir seu app.
Para fazer isso, especifique os arquivos de assets e o pacote transformador em seu arquivo pubspec.
Para aprender como fazer isso e escrever seus próprios pacotes de transformação de assets, veja
[Transformando assets em tempo de build][Transforming assets at build time].

### Empacotamento condicional de assets baseado em flavor do app

Se seu projeto utiliza a [funcionalidade de flavors][flavors feature], você pode configurar assets
individuais para serem empacotados apenas em certos flavors do seu app.
Para mais informações, confira [Empacotando assets condicionalmente baseado em flavor][Conditionally bundling assets based on flavor].

## Carregando assets

Seu app pode acessar seus assets através de um
objeto [`AssetBundle`][].

Os dois métodos principais em um asset bundle permitem que você carregue um
asset string/texto (`loadString()`) ou um asset imagem/binário (`load()`)
do bundle, dado uma chave lógica. A chave lógica mapeia para o caminho
do asset especificado no arquivo `pubspec.yaml` em tempo de build.

### Carregando assets de texto

Cada app Flutter tem um objeto [`rootBundle`][]
para fácil acesso ao asset bundle principal.
É possível carregar assets diretamente usando o
`rootBundle` global estático de
`package:flutter/services.dart`.

No entanto, é recomendado obter o `AssetBundle`
para o `BuildContext` atual usando
[`DefaultAssetBundle`][], em vez do asset
bundle padrão que foi construído com o app; essa
abordagem permite que um widget pai substitua um
`AssetBundle` diferente em tempo de execução,
o que pode ser útil para cenários de localização ou teste.

Normalmente, você usará `DefaultAssetBundle.of()`
para carregar indiretamente um asset, por exemplo um arquivo JSON,
do `rootBundle` em tempo de execução do app.

{% comment %}
  Need example here to show obtaining the AssetBundle for the current
  BuildContext using DefaultAssetBundle.of
{% endcomment %}

Fora do contexto de um `Widget`, ou quando um handle
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

Para carregar uma imagem, use a classe [`AssetImage`][]
no método `build()` de um widget.

Por exemplo, seu app pode carregar a imagem de fundo
das declarações de assets nos exemplos anteriores:

<?code-excerpt "main.dart (background-image)"?>
```dart
return const Image(image: AssetImage('assets/background.png'));
```

### Assets de imagens com resolução adaptável {:#resolution-aware}

O Flutter pode carregar imagens com resolução apropriada para
a [proporção de pixels do dispositivo][device pixel ratio] atual.

[`AssetImage`][] mapeará um asset lógico solicitado
para aquele que mais se aproxima da
[proporção de pixels do dispositivo][device pixel ratio] atual.

Para que esse mapeamento funcione, os assets devem ser organizados
de acordo com uma estrutura de diretório específica:

```plaintext
.../image.png
.../Mx/image.png
.../Nx/image.png
...etc.
```

Onde _M_ e _N_ são identificadores numéricos que correspondem
à resolução nominal das imagens contidas dentro.
Em outras palavras, eles especificam a proporção de pixels do dispositivo para
a qual as imagens são destinadas.

Neste exemplo, `image.png` é considerado o *asset principal*,
enquanto `Mx/image.png` e `Nx/image.png` são considerados
*variantes*.

O asset principal é assumido como correspondente a uma resolução de 1.0.
Por exemplo, considere o seguinte layout de assets para uma
imagem chamada `my_icon.png`:

```plaintext
.../my_icon.png       (mdpi baseline)
.../1.5x/my_icon.png  (hdpi)
.../2.0x/my_icon.png  (xhdpi)
.../3.0x/my_icon.png  (xxhdpi)
.../4.0x/my_icon.png  (xxxhdpi)
```

Em dispositivos com proporção de pixels de 1.8, o asset
`.../2.0x/my_icon.png` é escolhido.
Para um dispositivo com proporção de pixels de 2.7, o asset
`.../3.0x/my_icon.png` é escolhido.

Se a largura e altura da imagem renderizada não forem especificadas
no widget `Image`, a resolução nominal é usada para escalar
o asset de forma que ele ocupe a mesma quantidade de espaço na tela
que o asset principal ocuparia, apenas com resolução maior.
Ou seja, se `.../my_icon.png` é 72px por 72px, então
`.../3.0x/my_icon.png` deve ser 216px por 216px;
mas ambos renderizam em 72px por 72px (em pixels lógicos),
se largura e altura não forem especificadas.

:::note
[Proporção de pixels do dispositivo][Device pixel ratio] depende de [MediaQueryData.size][], que requer ter
[MaterialApp][] ou [CupertinoApp][] como ancestral do seu [`AssetImage`][].
:::

#### Empacotamento de assets de imagens com resolução adaptável {:#resolution-aware-bundling}

Você só precisa especificar o asset principal ou seu diretório pai
na seção `assets` do `pubspec.yaml`.
O Flutter empacota as variantes para você.
Cada entrada deve corresponder a um arquivo real, com exceção da
entrada do asset principal. Se a entrada do asset principal não corresponder
a um arquivo real, então o asset com a resolução mais baixa
é usado como fallback para dispositivos com proporção de pixels
abaixo dessa resolução. A entrada ainda deve
ser incluída no manifesto `pubspec.yaml`, no entanto.

Qualquer coisa usando o asset bundle padrão herda a consciência de resolução
ao carregar imagens. (Se você trabalhar com algumas das classes
de nível mais baixo, como [`ImageStream`][] ou [`ImageCache`][],
você também notará parâmetros relacionados à escala.)

### Imagens assets em dependências de pacotes {:#from-packages}

Para carregar uma imagem de uma dependência de [pacote][package],
o argumento `package` deve ser fornecido para [`AssetImage`][].

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

Se o asset desejado for especificado no arquivo `pubspec.yaml`
do pacote, ele é empacotado automaticamente com a
aplicação. Em particular, assets usados pelo próprio pacote
devem ser especificados em seu `pubspec.yaml`.

Um pacote também pode optar por ter assets em sua pasta `lib/`
que não são especificados em seu arquivo `pubspec.yaml`.
Nesse caso, para que essas imagens sejam empacotadas,
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

Assets Flutter estão prontamente disponíveis para código da plataforma
usando o `AssetManager` no Android e `NSBundle` no iOS.

### Carregando assets Flutter no Android

No Android os assets estão disponíveis através da
API [`AssetManager`][]. A chave de busca usada em,
por exemplo [`openFd`][], é obtida de
`lookupKeyForAsset` em [`PluginRegistry.Registrar`][] ou
`getLookupKeyForAsset` em [`FlutterView`][].
`PluginRegistry.Registrar` está disponível ao desenvolver um plugin
enquanto `FlutterView` seria a escolha ao desenvolver um
app incluindo uma platform view.

Como exemplo, suponha que você especificou o seguinte
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

Para acessar `icons/heart.png` do seu código Java de plugin,
faça o seguinte:

```java
AssetManager assetManager = registrar.context().getAssets();
String key = registrar.lookupKeyForAsset("icons/heart.png");
AssetFileDescriptor fd = assetManager.openFd(key);
```

### Carregando assets Flutter no iOS

No iOS os assets estão disponíveis através do [`mainBundle`][].
A chave de busca usada em, por exemplo [`pathForResource:ofType:`][],
é obtida de `lookupKeyForAsset` ou `lookupKeyForAsset:fromPackage:`
em [`FlutterPluginRegistrar`][], ou `lookupKeyForAsset:` ou
`lookupKeyForAsset:fromPackage:` em [`FlutterViewController`][].
`FlutterPluginRegistrar` está disponível ao desenvolver
um plugin enquanto `FlutterViewController` seria a escolha
ao desenvolver um app incluindo uma platform view.

Como exemplo, suponha que você tenha as configurações Flutter de acima.

Para acessar `icons/heart.png` do seu código Objective-C de plugin você
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
[plugin `video_player`][`video_player` plugin] no pub.dev.

O plugin [`ios_platform_images`][] no pub.dev encapsula
essa lógica em uma categoria conveniente. Você busca
uma imagem da seguinte forma:

**Objective-C:**
```objc
[UIImage flutterImageWithName:@"icons/heart.png"];
```

**Swift:**
```swift
UIImage.flutterImageNamed("icons/heart.png")
```

### Carregando imagens iOS no Flutter

Ao implementar Flutter
[adicionando-o a um app iOS existente][add-to-app],
você pode ter imagens hospedadas no iOS que deseja
usar no Flutter. Para fazer isso,
use o plugin [`ios_platform_images`][]
disponível no pub.dev.

## Assets de plataforma

Há outras ocasiões para trabalhar com assets nos
projetos de plataforma diretamente. Abaixo estão dois casos comuns
onde assets são usados antes do framework Flutter ser
carregado e executado.

### Atualizando o ícone do app

Atualizar o ícone de lançamento de uma aplicação Flutter funciona
da mesma forma que atualizar ícones de lançamento em aplicações
Android ou iOS nativas.

![Ícone de lançamento](/assets/images/docs/assets-and-images/icon.png)

#### Android

No diretório raiz do seu projeto Flutter, navegue até
`.../android/app/src/main/res`. As várias pastas de recursos bitmap
como `mipmap-hdpi` já contêm imagens placeholder
chamadas `ic_launcher.png`. Substitua-as por seus
assets desejados respeitando o tamanho de ícone recomendado por
densidade de tela conforme indicado pelo [Guia do Desenvolvedor Android][Android Developer Guide].

![Localização do ícone Android](/assets/images/docs/assets-and-images/android-icon-path.png)

:::note
Se você renomear os arquivos `.png`, você também deve atualizar o
nome correspondente no atributo `android:icon` da tag `<application>`
do seu `AndroidManifest.xml`.
:::

#### iOS

No diretório raiz do seu projeto Flutter,
navegue até `.../ios/Runner`. O
diretório `Assets.xcassets/AppIcon.appiconset` já contém
imagens placeholder. Substitua-as por imagens de tamanho
apropriado conforme indicado por seus nomes de arquivo, conforme ditado pelas
[Diretrizes de Interface Humana][Human Interface Guidelines] da Apple.
Mantenha os nomes de arquivo originais.

![Localização do ícone iOS](/assets/images/docs/assets-and-images/ios-icon-path.png)

### Atualizando a tela de lançamento

<p align="center">
  <img src="/assets/images/docs/assets-and-images/launch-screen.png" alt="Tela de lançamento" />
</p>

O Flutter também usa mecanismos nativos da plataforma para desenhar
telas de lançamento transicionais para seu app Flutter enquanto o
framework Flutter carrega. Esta tela de lançamento persiste até
o Flutter renderizar o primeiro frame da sua aplicação.

:::note
Isso implica que se você não chamar [`runApp()`][] na
função `main()` do seu app (ou mais especificamente,
se você não chamar [`FlutterView.render()`][] em resposta a
[`PlatformDispatcher.onDrawFrame`][]),
a tela de lançamento persiste para sempre.
:::

[`FlutterView.render()`]: {{site.api}}/flutter/dart-ui/FlutterView/render.html
[`PlatformDispatcher.onDrawFrame`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onDrawFrame.html

#### Android

Para adicionar uma tela de lançamento (também conhecida como "splash screen") ao seu
app Flutter, navegue até `.../android/app/src/main`.
Em `res/drawable/launch_background.xml`,
use este [drawable de lista de camadas][layer list drawable] XML para customizar
a aparência da sua tela de lançamento. O template existente fornece
um exemplo de adicionar uma imagem ao meio de uma tela branca
em código comentado. Você pode descomentá-lo ou usar outros
[drawables][] para alcançar o efeito pretendido.

Para mais detalhes, veja
[Adicionando uma splash screen ao seu app Android][Adding a splash screen to your Android app].

#### iOS

Para adicionar uma imagem ao centro da sua "splash screen",
navegue até `.../ios/Runner`.
Em `Assets.xcassets/LaunchImage.imageset`,
coloque imagens chamadas `LaunchImage.png`,
`LaunchImage@2x.png`, `LaunchImage@3x.png`.
Se você usar nomes de arquivo diferentes,
atualize o arquivo `Contents.json` no mesmo diretório.

Você também pode customizar totalmente seu storyboard de tela de lançamento
no Xcode abrindo `.../ios/Runner.xcworkspace`.
Navegue até `Runner/Runner` no Project Navigator e
coloque imagens abrindo `Assets.xcassets` ou faça qualquer
customização usando o Interface Builder em
`LaunchScreen.storyboard`.

![Adicionando ícones de lançamento no Xcode](/assets/images/docs/assets-and-images/ios-launchscreen-xcode.png){:width="100%"}

Para mais detalhes, veja
[Adicionando uma splash screen ao seu app iOS][Adding a splash screen to your iOS app].


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
[`ios_platform_images`]: {{site.pub}}/packages/ios_platform_images
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
[Conditionally bundling assets based on flavor]: /deployment/flavors#conditionally-bundling-assets-based-on-flavor
[flavors feature]: /deployment/flavors
