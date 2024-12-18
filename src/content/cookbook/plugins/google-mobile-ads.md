---
ia-translate: true
title: Adicione anúncios ao seu aplicativo ou jogo móvel Flutter
short-title: Exibir anúncios
description: Como usar o pacote google_mobile_ads para exibir anúncios no Flutter.
---

<?code-excerpt path-base="cookbook/plugins/google_mobile_ads"?>

{% comment %}
  This partly duplicates the AdMob documentation
  here: https://developers.google.com/admob/flutter/quick-start
  
  The added value of this page is that it's more straightforward for
  someone who just has a Flutter app or game and wants to add
  monetization to it.
  
  In short, this is a friendlier --- though not as comprehensive ---
  introduction to ads in Flutter.
{% endcomment %}

Muitos desenvolvedores usam publicidade para monetizar seus aplicativos e jogos móveis.
Isso permite que seu aplicativo seja baixado gratuitamente,
o que melhora a popularidade do aplicativo.

![Uma ilustração de um smartphone mostrando um anúncio](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para adicionar anúncios ao seu projeto Flutter, use
[AdMob](https://admob.google.com/home/),
a plataforma de publicidade móvel do Google.
Esta receita demonstra como usar o
[`google_mobile_ads`]({{site.pub-pkg}}/google_mobile_ads)
pacote para adicionar um anúncio banner ao seu aplicativo ou jogo.

:::note
Além do AdMob, o pacote `google_mobile_ads` também suporta
Ad Manager, uma plataforma destinada a grandes editores. Integrar o Ad
Manager se assemelha à integração do AdMob, mas não será abordado neste
receita do cookbook. Para usar o Ad Manager, siga a
[documentação do Ad Manager]({{site.developers}}/ad-manager/mobile-ads-sdk/flutter/quick-start).
:::

## 1. Obtenha IDs de aplicativos do AdMob

1.  Acesse [AdMob](https://admob.google.com/) e configure um
    conta. Isso pode levar algum tempo porque você precisa fornecer
    informações bancárias, assinar contratos e assim por diante.

2.  Com a conta do AdMob pronta, crie dois *Aplicativos* no AdMob: um para
    Android e um para iOS.

3.  Abra a seção **Configurações do aplicativo**.

4.  Obtenha os *IDs de aplicativos* do AdMob para o aplicativo Android e o aplicativo iOS.
    Eles se parecem com `ca-app-pub-1234567890123456~1234567890`. Observe o
    til (`~`) entre os dois números.
    {% comment %} https://support.google.com/admob/answer/7356431 para referência futura {% endcomment %}

    ![Captura de tela do AdMob mostrando a localização do ID do aplicativo](/assets/images/docs/cookbook/ads-app-id.png)

## 2. Configuração específica da plataforma

Atualize suas configurações do Android e iOS para incluir seus IDs de aplicativo.

{% comment %}
    Content below is more or less a copypaste from devsite: 
    https://developers.google.com/admob/flutter/quick-start#platform_specific_setup
{% endcomment %}

### Android

Adicione o ID do seu aplicativo AdMob ao seu aplicativo Android.

1.  Abra o arquivo `android/app/src/main/AndroidManifest.xml` do aplicativo.

2.  Adicione uma nova tag `<meta-data>`.

3.  Defina o elemento `android:name` com o valor de
    `com.google.android.gms.ads.APPLICATION_ID`.

4.  Defina o elemento `android:value` com o valor do seu próprio aplicativo AdMob
    ID que você obteve na etapa anterior.
    Inclua-os entre aspas, como mostrado:

    ```xml
    <manifest>
        <application>
            ...
    
            <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
            <meta-data
                android:name="com.google.android.gms.ads.APPLICATION_ID"
                android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
        </application>
    </manifest>
    ```

### iOS

Adicione o ID do seu aplicativo AdMob ao seu aplicativo iOS.

1.  Abra o arquivo `ios/Runner/Info.plist` do seu aplicativo.

2.  Envolva `GADApplicationIdentifier` com uma tag `key`.

3.  Envolva o ID do seu aplicativo AdMob com uma tag `string`. Você criou este AdMob
    ID do aplicativo na [etapa 1](#1-get-admob-app-ids).

    ```xml
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-################~##########</string>
    ```

## 3. Adicione o plugin `google_mobile_ads`

Para adicionar o plugin `google_mobile_ads` como uma dependência, execute
`flutter pub add`:

```console
$ flutter pub add google_mobile_ads
```

:::note
Depois de adicionar o plugin, seu aplicativo Android pode falhar na compilação com um
`DexArchiveMergerException`:

```plaintext
Error while merging dex archives:
The number of method references in a .dex file cannot exceed 64K.
```

Para resolver isso, execute o comando `flutter run` no terminal, não
através de um plugin IDE. A ferramenta `flutter` pode detectar o problema e perguntar
se ele deve tentar resolvê-lo. Responda `y` e o problema desaparece.
Você pode voltar a executar seu aplicativo de um IDE depois disso.

![Captura de tela da ferramenta `flutter` perguntando sobre suporte multidex](/assets/images/docs/cookbook/ads-multidex.png)
:::

## 4. Inicialize o SDK de anúncios para dispositivos móveis

Você precisa inicializar o SDK de anúncios para dispositivos móveis antes de carregar os anúncios.

1.  Chame `MobileAds.instance.initialize()` para inicializar os anúncios para dispositivos móveis
    SDK.

    <?code-excerpt "lib/main.dart (main)"?>
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      unawaited(MobileAds.instance.initialize());
    
      runApp(MyApp());
    }
    ```

Execute a etapa de inicialização na inicialização, como mostrado acima,
para que o SDK do AdMob tenha tempo suficiente para inicializar antes de ser necessário.

:::note
`MobileAds.instance.initialize()` retorna um `Future`, mas, o
maneira como o SDK é construído, você não precisa `await`.
Se você tentar carregar um anúncio antes que esse `Future` seja concluído,
o SDK aguardará normalmente até a inicialização e _então_ carregará o anúncio.
Você pode aguardar o `Future`
se você quiser saber o momento exato em que o SDK do AdMob está pronto.
:::

## 5. Carregue um anúncio banner

Para exibir um anúncio, você precisa solicitá-lo ao AdMob.

Para carregar um anúncio banner, construa uma instância `BannerAd` e
chame `load()` nele.

:::note
O seguinte trecho de código se refere a campos como `adSize`, `adUnitId`
e `_bannerAd`. Tudo isso fará mais sentido em uma etapa posterior.
:::

<?code-excerpt "lib/my_banner_ad.dart (loadAd)"?>
```dart
/// Loads a banner ad.
void _loadAd() {
  final bannerAd = BannerAd(
    size: widget.adSize,
    adUnitId: widget.adUnitId,
    request: const AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (ad) {
        if (!mounted) {
          ad.dispose();
          return;
        }
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (ad, error) {
        debugPrint('BannerAd failed to load: $error');
        ad.dispose();
      },
    ),
  );

  // Start loading.
  bannerAd.load();
}
```

Para ver um exemplo completo, confira a última etapa desta receita.

## 6. Exibir anúncio banner

Depois de ter uma instância carregada de `BannerAd`, use `AdWidget` para exibi-la.

```dart
AdWidget(ad: _bannerAd)
```

É uma boa ideia envolver o widget em um `SafeArea` (para que nenhuma parte do
anúncio seja obstruído por entalhes do dispositivo) e um `SizedBox` (para que ele tenha
seu tamanho especificado e constante antes e depois do carregamento).

<?code-excerpt "lib/my_banner_ad.dart (build)"?>
```dart
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: SizedBox(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      child: _bannerAd == null
          // Nothing to render yet.
          ? SizedBox()
          // The actual ad.
          : AdWidget(ad: _bannerAd!),
    ),
  );
}
```

Você deve descartar um anúncio quando não precisar mais acessá-lo. O melhor
prática para quando chamar `dispose()` é depois que o `AdWidget` é
removido da árvore de widgets ou no
callback `BannerAdListener.onAdFailedToLoad()`.

<?code-excerpt "lib/my_banner_ad.dart (dispose)"?>
```dart
_bannerAd?.dispose();
```

## 7. Configurar anúncios

Para exibir algo além dos anúncios de teste, você deve registrar unidades de anúncios.

1.  Abra [AdMob](https://admob.google.com/).

2.  Crie uma *Unidade de anúncio* para cada um dos aplicativos AdMob.

    ![Captura de tela da localização das unidades de anúncio na interface do usuário da Web do AdMob](/assets/images/docs/cookbook/ads-ad-unit.png)

    Isso pergunta sobre o formato da unidade de anúncio. O AdMob oferece muitos formatos
    além de anúncios em banner --- intersticiais, anúncios com recompensa, anúncios de abertura de aplicativo e
    assim por diante.
    A API para eles é semelhante e documentada no
    [documentação do AdMob]({{site.developers}}/admob/flutter/quick-start)
    e através
    [amostras oficiais](https://github.com/googleads/googleads-mobile-flutter/tree/main/samples/admob).

3.  Escolha anúncios em banner.

4.  Obtenha os *IDs de unidades de anúncio* para o aplicativo Android e o aplicativo iOS.
    Você pode encontrá-los na seção **Unidades de anúncio**. Eles parecem algo
    como `ca-app-pub-1234567890123456/1234567890`. O formato se assemelha
    o *ID do aplicativo*, mas com uma barra (`/`) entre os dois números. Isso
    distingue um *ID de unidade de anúncio* de um *ID de aplicativo*.

    ![Captura de tela de um ID de unidade de anúncio na interface do usuário da Web do AdMob](/assets/images/docs/cookbook/ads-ad-unit-id.png)

5.  Adicione esses *IDs de unidades de anúncio* ao construtor de `BannerAd`,
    dependendo da plataforma do aplicativo de destino.

    <?code-excerpt "lib/my_banner_ad.dart (adUnitId)"?>
    ```dart
    final String adUnitId = Platform.isAndroid
        // Use this ad unit on Android...
        ? 'ca-app-pub-3940256099942544/6300978111'
        // ... or this one on iOS.
        : 'ca-app-pub-3940256099942544/2934735716';
    ```

## 8. Toques finais

Para exibir os anúncios em um aplicativo ou jogo publicado (em vez de depurar ou
cenários de teste), seu aplicativo deve atender a requisitos adicionais:

1.  Seu aplicativo deve ser revisado e aprovado antes que possa atender totalmente
    anúncios.
    Siga as [diretrizes de prontidão de aplicativos](https://support.google.com/admob/answer/10564477) do AdMob.
    Por exemplo, seu aplicativo deve estar listado em pelo menos uma das
    lojas suportadas, como Google Play Store ou Apple App Store.

2.  Você deve [criar um `app-ads.txt`](https://support.google.com/admob/answer/9363762)
    arquivo e publique-o em seu site de desenvolvedor.

![Uma ilustração de um smartphone mostrando um anúncio](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para saber mais sobre monetização de aplicativos e jogos,
visite os sites oficiais
do [AdMob](https://admob.google.com/)
e [Ad Manager](https://admanager.google.com/).

## 9. Exemplo completo

O código a seguir implementa um widget stateful simples que carrega um
anúncio banner e mostra.

<?code-excerpt "lib/my_banner_ad.dart"?>
```dart
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;

  /// The AdMob ad unit to show.
  ///
  /// TODO: replace this test ad unit with your own ad unit
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/6300978111'
      // ... or this one on iOS.
      : 'ca-app-pub-3940256099942544/2934735716';

  MyBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        child: _bannerAd == null
            // Nothing to render yet.
            ? SizedBox()
            // The actual ad.
            : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }
}
```

:::tip
Em muitos casos, você vai querer carregar o anúncio _fora_ de um widget.

Por exemplo, você pode carregá-lo em um `ChangeNotifier`, um BLoC, um controlador,
ou qualquer outra coisa que você esteja usando para o estado do nível do aplicativo. Dessa forma, você pode
pré-carregar um anúncio banner com antecedência e tê-lo pronto para exibir quando o
usuário navega para uma nova tela.

Verifique se você carregou a instância `BannerAd` antes de exibi-la com
um `AdWidget`, e que você descarte a instância quando ela não for mais
necessário.
:::
