---
ia-translate: true
title: Adicionando assets e imagens
description: Como usar imagens (e outros assets) em seu app Flutter.
short-title: Assets e imagens
---

<?code-excerpt path-base="ui/assets_and_images/lib"?>

Aplicativos Flutter podem incluir tanto código quanto _assets_
(às vezes chamados de recursos). Um asset é um arquivo
que é empacotado e implantado com seu aplicativo,
e é acessível em tempo de execução. Tipos comuns de assets incluem
dados estáticos (por exemplo, arquivos JSON),
arquivos de configuração, ícones e imagens
(JPEG, WebP, GIF, WebP/GIF animado, PNG, BMP e WBMP).

## Especificando assets

O Flutter usa o arquivo [`pubspec.yaml`][],
localizado na raiz do seu projeto,
para identificar os assets necessários para um aplicativo.

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
Apenas os arquivos localizados diretamente no diretório são incluídos.
[Variantes de imagem de assets com reconhecimento de resolução](#resolution-aware) são a única exceção.
Para adicionar arquivos localizados em subdiretórios, crie uma entrada por diretório.
:::

:::note
A indentação é importante em YAML. Se você vir um erro como
`Error: unable to find directory entry in pubspec.yaml`
então você _pode_ ter indentado incorretamente no seu
arquivo pubspec. Considere o seguinte exemplo [quebrado]:
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

### Agrupamento de Assets

A subseção `assets` da seção `flutter`
especifica os arquivos que devem ser incluídos no aplicativo.
Cada asset é identificado por um caminho explícito
(relativo ao arquivo `pubspec.yaml`) onde o asset
arquivo está localizado. A ordem em que os assets são
declarados não importa. O nome do diretório real usado
(`assets` no primeiro exemplo ou `directory` no exemplo acima)
não importa.

Durante uma build, o Flutter coloca os assets em um especial
arquivo chamado _asset bundle_ que os aplicativos leem
em tempo de execução.

### Transformação automática de arquivos de assets em tempo de build

O Flutter suporta o uso de um pacote Dart para transformar arquivos de assets ao construir seu aplicativo.
Para fazer isso, especifique os arquivos de assets e o pacote de transformação em seu arquivo pubspec.
Para aprender como fazer isso e escrever seus próprios pacotes de transformação de assets, consulte
[Transformando assets em tempo de build][].

### Agrupamento condicional de assets baseado no flavor do aplicativo

Se o seu projeto utiliza o [recurso de flavors][], você pode configurar
assets individuais para serem agrupados apenas em determinados flavors do seu aplicativo.
Para mais informações, confira [Agrupando assets condicionalmente baseado no flavor].

## Carregando assets

Seu aplicativo pode acessar seus assets por meio de um
objeto [`AssetBundle`][].

Os dois principais métodos em um asset bundle permitem que você carregue um
asset de string/texto (`loadString()`) ou um asset de imagem/binário (`load()`)
do bundle, dado uma chave lógica. A chave lógica mapeia para o caminho
para o asset especificado no arquivo `pubspec.yaml` no tempo de build.

### Carregando assets de texto

Cada aplicativo Flutter tem um objeto [`rootBundle`][]
para fácil acesso ao asset bundle principal.
É possível carregar assets diretamente usando o
`rootBundle` global estático de
`package:flutter/services.dart`.

No entanto, é recomendado obter o `AssetBundle`
para o `BuildContext` atual usando
[`DefaultAssetBundle`][], em vez do default
asset bundle que foi construído com o aplicativo; esta
abordagem permite que um widget pai substitua um
`AssetBundle` diferente em tempo de execução,
o que pode ser útil para cenários de localização ou teste.

Normalmente, você usará `DefaultAssetBundle.of()`
para carregar indiretamente um asset, por exemplo, um arquivo JSON,
do `rootBundle` em tempo de execução do aplicativo.

{% comment %}
  Need example here to show obtaining the AssetBundle for the current
  BuildContext using DefaultAssetBundle.of
{% endcomment %}

Fora de um contexto de `Widget`, ou quando um handle
para um `AssetBundle` não está disponível,
você pode usar `rootBundle` para carregar diretamente esses assets.
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

Por exemplo, seu aplicativo pode carregar o fundo
imagem das declarações de assets no exemplo anterior:

<?code-excerpt "main.dart (background-image)"?>
```dart
return const Image(image: AssetImage('assets/background.png'));
```

### Assets de imagem com reconhecimento de resolução {:#resolution-aware}

O Flutter pode carregar imagens apropriadas para resolução
para a [taxa de pixels do dispositivo][] atual.

[`AssetImage`][] mapeará um asset lógico solicitado
para um que corresponda mais de perto ao atual
[taxa de pixels do dispositivo][].

Para que esse mapeamento funcione, os assets devem ser organizados
de acordo com uma estrutura de diretórios específica:

```plaintext
.../image.png
.../Mx/image.png
.../Nx/image.png
...etc.
```

Onde _M_ e _N_ são identificadores numéricos que correspondem
à resolução nominal das imagens contidas em.
Em outras palavras, eles especificam a taxa de pixels do dispositivo para a qual
as imagens são destinadas.

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

Em dispositivos com uma taxa de pixel de dispositivo de 1.8, o asset
`.../2.0x/my_icon.png` é escolhido.
Para uma taxa de pixel do dispositivo de 2.7, o asset
`.../3.0x/my_icon.png` é escolhido.

Se a largura e a altura da imagem renderizada não forem especificadas
no widget `Image`, a resolução nominal é usada para escalar
o asset para que ocupe a mesma quantidade de espaço na tela
como o asset principal teria, apenas com uma resolução maior.
Ou seja, se `.../my_icon.png` tem 72px por 72px, então
`.../3.0x/my_icon.png` deve ter 216px por 216px;
mas ambos renderizam em 72px por 72px (em pixels lógicos),
se largura e altura não forem especificados.

:::note
[Taxa de pixel do dispositivo][] depende de [MediaQueryData.size][], que exige ter
[MaterialApp][] ou [CupertinoApp][] como um ancestral do seu [`AssetImage`][].
:::

#### Agrupamento de assets de imagem com reconhecimento de resolução {:#resolution-aware-bundling}

Você só precisa especificar o asset principal ou seu diretório pai
na seção `assets` de `pubspec.yaml`.
O Flutter agrupa as variantes para você.
Cada entrada deve corresponder a um arquivo real, com exceção da
entrada do asset principal. Se a entrada do asset principal não corresponder
a um arquivo real, então o asset com a menor resolução
é usado como fallback para dispositivos com pixel do dispositivo
taxas abaixo dessa resolução. A entrada ainda deve
ser incluída no manifesto `pubspec.yaml`, no entanto.

Qualquer coisa que use o asset bundle padrão herda a resolução
consciência ao carregar imagens. (Se você trabalhar com algumas das mais baixas
classes de nível, como [`ImageStream`][] ou [`ImageCache`][],
você também notará parâmetros relacionados à escala.)

### Imagens de asset em dependências de pacotes {:#from-packages}

Para carregar uma imagem de uma dependência de [pacote][],
o argumento `package` deve ser fornecido para [`AssetImage`][].

Por exemplo, suponha que seu aplicativo dependa de um pacote
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

Os assets usados pelo próprio pacote também devem ser buscados
usando o argumento `package` como acima.

#### Agrupamento de assets de pacotes

Se o asset desejado for especificado no arquivo `pubspec.yaml`
do pacote, ele é agrupado automaticamente com o
aplicativo. Em particular, os assets usados pelo pacote
em si devem ser especificados em seu `pubspec.yaml`.

Um pacote também pode optar por ter assets em seu `lib/`
pasta que não são especificados em seu arquivo `pubspec.yaml`.
Nesse caso, para que essas imagens sejam agrupadas,
o aplicativo tem que especificar quais incluir em seu
`pubspec.yaml`. Por exemplo, um pacote chamado `fancy_backgrounds`
pode ter os seguintes arquivos:

```plaintext
.../lib/backgrounds/background1.png
.../lib/backgrounds/background2.png
.../lib/backgrounds/background3.png
```

Para incluir, digamos, a primeira imagem, o `pubspec.yaml` do
aplicativo deve especificá-lo na seção `assets`:

```yaml
flutter:
  assets:
    - packages/fancy_backgrounds/backgrounds/background1.png
```

O `lib/` está implícito,
portanto, não deve ser incluído no caminho do asset.

Se você estiver desenvolvendo um pacote, para carregar um asset dentro do pacote, especifique-o no `pubspec.yaml` do pacote:

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

Os assets do Flutter estão prontamente disponíveis para o código da plataforma
usando o `AssetManager` no Android e `NSBundle` no iOS.

### Carregando assets do Flutter no Android

No Android, os assets estão disponíveis por meio do
API [`AssetManager`][]. A chave de pesquisa usada em,
por exemplo [`openFd`][], é obtida de
`lookupKeyForAsset` em [`PluginRegistry.Registrar`][] ou
`getLookupKeyForAsset` em [`FlutterView`][].
`PluginRegistry.Registrar` está disponível ao desenvolver um plugin
enquanto `FlutterView` seria a escolha ao desenvolver um
aplicativo incluindo uma view de plataforma.

Como um exemplo, suponha que você tenha especificado o seguinte
em seu pubspec.yaml

```yaml
flutter:
  assets:
    - icons/heart.png
```

Isso reflete a seguinte estrutura em seu aplicativo Flutter.

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

### Carregando assets do Flutter no iOS

No iOS, os assets estão disponíveis através do [`mainBundle`][].
A chave de pesquisa usada em, por exemplo [`pathForResource:ofType:`][],
é obtida de `lookupKeyForAsset` ou `lookupKeyForAsset:fromPackage:`
em [`FlutterPluginRegistrar`][], ou `lookupKeyForAsset:` ou
`lookupKeyForAsset:fromPackage:` em [`FlutterViewController`][].
`FlutterPluginRegistrar` está disponível ao desenvolver
um plugin, enquanto `FlutterViewController` seria a escolha
ao desenvolver um aplicativo incluindo uma view de plataforma.

Como um exemplo, suponha que você tenha a configuração do Flutter acima.

Para acessar `icons/heart.png` do seu código de plugin Objective-C você
faria o seguinte:

```objc
NSString* key = [registrar lookupKeyForAsset:@"icons/heart.png"];
NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
```

Para acessar `icons/heart.png` do seu aplicativo Swift você
faria o seguinte:

```swift
let key = controller.lookupKey(forAsset: "icons/heart.png")
let mainBundle = Bundle.main
let path = mainBundle.path(forResource: key, ofType: nil)
```

Para um exemplo mais completo, veja a implementação do
Flutter [`video_player` plugin][] no pub.dev.

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

Ao implementar o Flutter
[adicionando-o a um aplicativo iOS existente][add-to-app],
você pode ter imagens hospedadas no iOS que você
quer usar no Flutter. Para realizar
isso, use o plugin [`ios_platform_images`][]
disponível no pub.dev.

## Assets da plataforma

Existem outras ocasiões para trabalhar com assets no
projetos de plataforma diretamente. Abaixo estão dois casos comuns
onde os assets são usados antes que o framework Flutter seja
carregado e em execução.

### Atualizando o ícone do aplicativo

Atualizar o ícone de inicialização de um aplicativo Flutter funciona
da mesma forma que atualizar ícones de inicialização em aplicativos
nativos Android ou iOS.

![Ícone de inicialização](/assets/images/docs/assets-and-images/icon.png)

#### Android

No diretório raiz do seu projeto Flutter, navegue até
`.../android/app/src/main/res`. As várias pastas de recursos
de bitmap como `mipmap-hdpi` já contêm placeholders
imagens chamadas `ic_launcher.png`. Substitua-as pelo seu
assets desejados respeitando o tamanho de ícone recomendado por
densidade de tela, conforme indicado pelo [Guia do desenvolvedor Android][].

![Localização do ícone Android](/assets/images/docs/assets-and-images/android-icon-path.png)

:::note
Se você renomear os arquivos `.png`, você também deve atualizar o
nome correspondente no seu `AndroidManifest.xml`'s
atributo `android:icon` da tag `<application>`.
:::

#### iOS

No diretório raiz do seu projeto Flutter,
navegue até `.../ios/Runner`. O
diretório `Assets.xcassets/AppIcon.appiconset` já contém
imagens de espaço reservado. Substitua-as pelas
imagens de tamanho adequado, conforme indicado pelo nome do arquivo,
conforme ditado pelas [Diretrizes de interface humana][] da Apple.
Mantenha os nomes de arquivos originais.

![Localização do ícone iOS](/assets/images/docs/assets-and-images/ios-icon-path.png)

### Atualizando a tela de inicialização

<p align="center">
  <img src="/assets/images/docs/assets-and-images/launch-screen.png" alt="Tela de inicialização" />
</p>

O Flutter também usa mecanismos de plataforma nativa para desenhar
telas de inicialização de transição para seu aplicativo Flutter enquanto o
framework Flutter carrega. Esta tela de inicialização persiste até que
Flutter renderiza o primeiro frame do seu aplicativo.

:::note
Isso implica que se você não chamar [`runApp()`][] no
função `main()` do seu aplicativo (ou mais especificamente,
se você não chamar [`FlutterView.render()`][] em resposta a
[`PlatformDispatcher.onDrawFrame`][]),
a tela de inicialização persiste para sempre.
:::

[`FlutterView.render()`]: {{site.api}}/flutter/dart-ui/FlutterView/render.html
[`PlatformDispatcher.onDrawFrame`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onDrawFrame.html

#### Android

Para adicionar uma tela de inicialização (também conhecida como "splash screen") ao seu
aplicativo Flutter, navegue até `.../android/app/src/main`.
Em `res/drawable/launch_background.xml`,
use este [drawable de lista de camadas][] XML para personalizar
a aparência de sua tela de inicialização. O modelo existente fornece
um exemplo de como adicionar uma imagem ao meio de um splash branco
tela em código comentado. Você pode descomentá-la ou usar outras
[drawables][] para atingir o efeito pretendido.

Para mais detalhes, consulte
[Adicionando uma tela de inicialização ao seu aplicativo Android][].

#### iOS

Para adicionar uma imagem ao centro de sua "splash screen",
navegue até `.../ios/Runner`.
Em `Assets.xcassets/LaunchImage.imageset`,
adicione imagens nomeadas `LaunchImage.png`,
`LaunchImage@2x.png`, `LaunchImage@3x.png`.
Se você usar nomes de arquivos diferentes,
atualize o arquivo `Contents.json` no mesmo diretório.

Você também pode personalizar totalmente seu storyboard de tela de inicialização
no Xcode, abrindo `.../ios/Runner.xcworkspace`.
Navegue até `Runner/Runner` no Project Navigator e
adicione imagens abrindo `Assets.xcassets` ou faça qualquer
personalização usando o Interface Builder em
`LaunchScreen.storyboard`.

![Adicionando ícones de inicialização no Xcode](/assets/images/docs/assets-and-images/ios-launchscreen-xcode.png){:width="100%"}

Para mais detalhes, consulte
[Adicionando uma tela de inicialização ao seu aplicativo iOS][].

[add-to-app]: /add-to-app/ios
[Adicionando uma tela de inicialização ao seu aplicativo Android]: /platform-integration/android/splash-screen
[Adicionando uma tela de inicialização ao seu aplicativo iOS]: /platform-integration/ios/splash-screen
[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[`AssetImage`]: {{site.api}}/flutter/painting/AssetImage-class.html
[`DefaultAssetBundle`]: {{site.api}}/flutter/widgets/DefaultAssetBundle-class.html
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`ImageStream`]: {{site.api}}/flutter/painting/ImageStream-class.html
[Guia do desenvolvedor Android]: {{site.android-dev}}/training/multiscreen/screendensities
[`AssetManager`]: {{site.android-dev}}/reference/android/content/res/AssetManager
[taxa de pixels do dispositivo]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[Taxa de pixel do dispositivo]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[drawables]: {{site.android-dev}}/guide/topics/resources/drawable-resource
[`FlutterPluginRegistrar`]: {{site.api}}/ios-embedder/protocol_flutter_plugin_registrar-p.html
[`FlutterView`]: {{site.api}}/javadoc/io/flutter/view/FlutterView.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[Diretrizes de interface humana]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons
[`ios_platform_images`]: {{site.pub}}/packages/ios_platform_images
[drawable de lista de camadas]: {{site.android-dev}}/guide/topics/resources/drawable-resource#LayerList
[`mainBundle`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410786-mainbundle
[`openFd`]: {{site.android-dev}}/reference/android/content/res/AssetManager#openFd(java.lang.String)
[pacote]: /packages-and-plugins/using-packages
[`pathForResource:ofType:`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410989-pathforresource
[`PluginRegistry.Registrar`]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
[`pubspec.yaml`]: {{site.dart-site}}/tools/pub/pubspec
[`rootBundle`]: {{site.api}}/flutter/services/rootBundle.html
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`video_player` plugin]: {{site.pub}}/packages/video_player
[MediaQueryData.size]: {{site.api}}/flutter/widgets/MediaQueryData/size.html
[MaterialApp]: {{site.api}}/flutter/material/MaterialApp-class.html
[CupertinoApp]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[Transformando assets em tempo de build]: /ui/assets/asset-transformation
[Agrupando assets condicionalmente baseado no flavor]: /deployment/flavors#conditionally-bundling-assets-based-on-flavor
[recurso de flavors]: /deployment/flavors
