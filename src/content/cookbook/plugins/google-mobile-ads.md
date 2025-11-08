---
title: Adicionar anúncios ao seu app ou jogo Flutter mobile
short-title: Mostrar anúncios
description: Como usar o pacote google_mobile_ads para mostrar anúncios no Flutter.
ia-translate: true
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


Muitos desenvolvedores usam publicidade para monetizar seus apps e jogos mobile.
Isso permite que seu app seja baixado gratuitamente,
o que melhora a popularidade do app.

![An illustration of a smartphone showing an ad](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para adicionar anúncios ao seu projeto Flutter, use
[AdMob](https://admob.google.com/home/),
a plataforma de publicidade mobile do Google.
Esta receita demonstra como usar o
pacote [`google_mobile_ads`]({{site.pub-pkg}}/google_mobile_ads)
para adicionar um banner de anúncio ao seu app ou jogo.

:::note
Além do AdMob, o pacote `google_mobile_ads` também suporta
Ad Manager, uma plataforma destinada a grandes publishers. Integrar Ad
Manager se assemelha a integrar AdMob, mas não será coberto nesta
receita de cookbook. Para usar Ad Manager, siga a
[documentação do Ad Manager]({{site.developers}}/ad-manager/mobile-ads-sdk/flutter/quick-start).
:::

<a id="1-get-admob-app-ids"></a>
## 1. Obter IDs de App do AdMob

1.  Vá para [AdMob](https://admob.google.com/) e configure uma
    conta. Isso pode levar algum tempo porque você precisa fornecer
    informações bancárias, assinar contratos, e assim por diante.

2.  Com a conta do AdMob pronta, crie dois *Apps* no AdMob: um para
    Android e um para iOS.

3.  Abra a seção **App settings**.

4.  Obtenha os *IDs de App* do AdMob tanto para o app Android quanto para o iOS.
    Eles se parecem com `ca-app-pub-1234567890123456~1234567890`. Note o
    til (`~`) entre os dois números.
    {% comment %} https://support.google.com/admob/answer/7356431 for future reference {% endcomment %}

    ![Screenshot from AdMob showing the location of the App ID](/assets/images/docs/cookbook/ads-app-id.png)

## 2. Configuração específica de plataforma

Atualize suas configurações Android e iOS para incluir seus IDs de App.

{% comment %}
    Content below is more or less a copypaste from devsite:
    https://developers.google.com/admob/flutter/quick-start#platform_specific_setup
{% endcomment %}

### Android

Adicione seu ID de app do AdMob ao seu app Android.

1.  Abra o arquivo `android/app/src/main/AndroidManifest.xml` do app.

2.  Adicione uma nova tag `<meta-data>`.

3.  Defina o elemento `android:name` com o valor
    `com.google.android.gms.ads.APPLICATION_ID`.

4.  Defina o elemento `android:value` com o valor do seu próprio ID de app
    do AdMob que você obteve no passo anterior.
    Inclua-os entre aspas como mostrado:

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

Adicione seu ID de app do AdMob ao seu app iOS.

1.  Abra o arquivo `ios/Runner/Info.plist` do seu app.

2.  Envolva `GADApplicationIdentifier` com uma tag `key`.

3.  Envolva seu ID de app do AdMob com uma tag `string`. Você criou este ID de App
    do AdMob no [passo 1](#1-get-admob-app-ids).

    ```xml
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-################~##########</string>
    ```

## 3. Adicionar o plugin `google_mobile_ads`

Para adicionar o plugin `google_mobile_ads` como uma dependência, execute
`flutter pub add`:

```console
$ flutter pub add google_mobile_ads
```

:::note
Depois de adicionar o plugin, seu app Android pode falhar ao compilar com um
`DexArchiveMergerException`:

```plaintext
Error while merging dex archives:
The number of method references in a .dex file cannot exceed 64K.
```

Para resolver isso, execute o comando `flutter run` no terminal, não
através de um plugin de IDE. A ferramenta `flutter` pode detectar o problema e perguntar
se deve tentar resolvê-lo. Responda `y`, e o problema desaparece.
Você pode retornar a executar seu app de uma IDE depois disso.

![Screenshot of the `flutter` tool asking about multidex support](/assets/images/docs/cookbook/ads-multidex.png)
:::

## 4. Inicializar o Mobile Ads SDK

Você precisa inicializar o Mobile Ads SDK antes de carregar anúncios.

1.  Chame `MobileAds.instance.initialize()` para inicializar o Mobile Ads
    SDK.

    <?code-excerpt "lib/main.dart (main)"?>
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      unawaited(MobileAds.instance.initialize());
    
      runApp(const MyApp());
    }
    ```

Execute a etapa de inicialização na inicialização, como mostrado acima,
para que o SDK do AdMob tenha tempo suficiente para inicializar antes de ser necessário.

:::note
`MobileAds.instance.initialize()` retorna um `Future` mas, da
forma como o SDK é construído, você não precisa fazer `await` nele.
Se você tentar carregar um anúncio antes que esse `Future` seja completado,
o SDK esperará graciosamente até a inicialização, e _então_ carregará o anúncio.
Você pode fazer await do `Future`
se quiser saber o momento exato em que o SDK do AdMob estiver pronto.
:::

## 5. Carregar um banner de anúncio

Para mostrar um anúncio, você precisa solicitá-lo do AdMob.

Para carregar um banner de anúncio, construa uma instância de `BannerAd`, e
chame `load()` nela.

:::note
O seguinte trecho de código refere-se a campos como `adSize`, `adUnitId`
e `_bannerAd`. Isso tudo fará mais sentido em um passo posterior.
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

Para ver um exemplo completo, confira o último passo desta receita.


## 6. Mostrar banner de anúncio

Uma vez que você tenha uma instância carregada de `BannerAd`, use `AdWidget` para mostrá-la.

```dart
AdWidget(ad: _bannerAd)
```

É uma boa ideia envolver o widget em um `SafeArea` (para que nenhuma parte
do anúncio seja obstruída por entalhes do dispositivo) e um `SizedBox` (para que ele tenha
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
          ? const SizedBox()
          // The actual ad.
          : AdWidget(ad: _bannerAd!),
    ),
  );
}
```

Você deve descartar um anúncio quando não precisar mais acessá-lo. A melhor
prática para quando chamar `dispose()` é depois que o `AdWidget` for
removido da árvore de widgets ou no
callback `BannerAdListener.onAdFailedToLoad()`.

<?code-excerpt "lib/my_banner_ad.dart (dispose)"?>
```dart
_bannerAd?.dispose();
```


## 7. Configurar anúncios

Para mostrar algo além de anúncios de teste, você precisa registrar unidades de anúncio.

1.  Abra [AdMob](https://admob.google.com/).

2.  Crie uma *Ad unit* para cada um dos apps do AdMob.

    ![Screenshot of the location of Ad Units in AdMob web UI](/assets/images/docs/cookbook/ads-ad-unit.png)

    Isso solicita o formato da Ad unit. O AdMob fornece muitos formatos
    além de banner ads --- intersticiais, anúncios recompensados, app open ads, e
    assim por diante.
    A API para esses é similar, e documentada na
    [documentação do AdMob]({{site.developers}}/admob/flutter/quick-start)
    e através de
    [amostras oficiais](https://github.com/googleads/googleads-mobile-flutter/tree/main/samples/admob).

3.  Escolha banner ads.

4.  Obtenha os *IDs de Ad unit* tanto para o app Android quanto para o iOS.
    Você pode encontrá-los na seção **Ad units**. Eles se parecem com algo
    como `ca-app-pub-1234567890123456/1234567890`. O formato se assemelha
    ao *App ID* mas com uma barra (`/`) entre os dois números. Isso
    distingue um *ID de Ad unit* de um *ID de App*.

    ![Screenshot of an Ad Unit ID in AdMob web UI](/assets/images/docs/cookbook/ads-ad-unit-id.png)

5.  Adicione esses *IDs de Ad unit* ao construtor de `BannerAd`,
    dependendo da plataforma do app alvo.

    <?code-excerpt "lib/my_banner_ad.dart (adUnitId)"?>
    ```dart
    final String adUnitId = Platform.isAndroid
        // Use this ad unit on Android...
        ? 'ca-app-pub-3940256099942544/6300978111'
        // ... or this one on iOS.
        : 'ca-app-pub-3940256099942544/2934735716';
    ```

## 8. Toques finais

Para exibir os anúncios em um app ou jogo publicado (ao contrário de cenários de debug ou
teste), seu app deve atender requisitos adicionais:

1.  Seu app deve ser revisado e aprovado antes de poder servir anúncios
    totalmente.
    Siga as [diretrizes de preparação de app](https://support.google.com/admob/answer/10564477) do AdMob.
    Por exemplo, seu app deve estar listado em pelo menos uma das
    lojas suportadas como Google Play Store ou Apple App Store.

2.  Você deve [criar um `app-ads.txt`](https://support.google.com/admob/answer/9363762)
    e publicá-lo no seu site de desenvolvedor.

![An illustration of a smartphone showing an ad](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para aprender mais sobre monetização de app e jogo,
visite os sites oficiais
do [AdMob](https://admob.google.com/)
e [Ad Manager](https://admanager.google.com/).


## 9. Exemplo completo

O seguinte código implementa um simples stateful widget que carrega um
banner de anúncio e o mostra.

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
            ? const SizedBox()
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

Por exemplo, você pode carregá-lo em um `ChangeNotifier`, um BLoC, um controller,
ou o que mais você estiver usando para estado de nível de app. Dessa forma, você pode
pré-carregar um banner de anúncio com antecedência, e tê-lo pronto para mostrar quando o
usuário navegar para uma nova tela.

Verifique que você carregou a instância de `BannerAd` antes de mostrá-la com
um `AdWidget`, e que você descarta a instância quando ela não é mais
necessária.
:::
