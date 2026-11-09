---
ia-translate: true
title: Adicione anúncios ao seu app ou jogo Flutter móvel
shortTitle: Mostrar anúncios
description: Como usar o pacote google_mobile_ads para mostrar anúncios no Flutter.
---

<?code-excerpt path-base="cookbook/plugins/google_mobile_ads"?>

{% comment %}
  Esta página duplica parcialmente a documentação do AdMob
  disponível em: https://developers.google.com/admob/flutter/quick-start

  O valor agregado desta página é ser mais direta para
  quem tem apenas um app ou jogo Flutter e quer adicionar
  monetização a ele.

  Em resumo, esta é uma introdução mais amigável, embora não tão completa,
  sobre anúncios no Flutter.
{% endcomment %}


Muitos desenvolvedores usam publicidade para monetizar seus apps
e jogos móveis. Isso permite que o app seja baixado gratuitamente,
o que melhora a popularidade do app.

![Uma ilustração de um smartphone mostrando um anúncio](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para adicionar anúncios ao seu projeto Flutter, use
o [AdMob](https://admob.google.com/home/),
a plataforma de publicidade móvel do Google.
Esta receita demonstra como usar o pacote
[`google_mobile_ads`]({{site.pub-pkg}}/google_mobile_ads)
para adicionar um anúncio de banner ao seu app ou jogo.

:::note
Além do AdMob, o pacote `google_mobile_ads` também oferece suporte ao
Ad Manager, uma plataforma destinada a grandes publishers. Integrar o
Ad Manager é parecido com integrar o AdMob, mas não será abordado nesta
receita do cookbook. Para usar o Ad Manager, siga a
[documentação do Ad Manager]({{site.developers}}/ad-manager/mobile-ads-sdk/flutter/quick-start).
:::

## 1. Obtenha os App IDs do AdMob {:#1-get-admob-app-ids}

1.  Acesse o [AdMob](https://admob.google.com/) e configure uma
    conta. Isso pode levar algum tempo, porque você precisa informar
    dados bancários, assinar contratos e assim por diante.

2.  Com a conta do AdMob pronta, crie dois *Apps* no AdMob: um para
    Android e outro para iOS.

3.  Abra a seção **Configurações do app**.

4.  Obtenha os *App IDs* do AdMob tanto para o app Android quanto para o app
    iOS. Eles têm o formato `ca-app-pub-1234567890123456~1234567890`. Observe o
    til (`~`) entre os dois números.
    {% comment %} https://support.google.com/admob/answer/7356431 para referência futura {% endcomment %}

    ![Captura de tela do AdMob mostrando onde está o App ID](/assets/images/docs/cookbook/ads-app-id.png)

## 2. Configuração específica da plataforma {:#2-platform-specific-setup}

Atualize as configurações do Android e do iOS para incluir os seus App IDs.

{% comment %}
    O conteúdo abaixo é, mais ou menos, uma cópia do devsite:
    https://developers.google.com/admob/flutter/quick-start#platform_specific_setup
{% endcomment %}

### Android

Adicione o seu App ID do AdMob ao app Android.

1.  Abra o arquivo `android/app/src/main/AndroidManifest.xml` do app.

2.  Adicione uma nova tag `<meta-data>`.

3.  Defina o elemento `android:name` com o valor
    `com.google.android.gms.ads.APPLICATION_ID`.

4.  Defina o elemento `android:value` com o valor do seu próprio App ID
    do AdMob, obtido no passo anterior.
    Inclua-o entre aspas, como mostrado:

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

Adicione o seu App ID do AdMob ao app iOS.

1.  Abra o arquivo `ios/Runner/Info.plist` do seu app.

2.  Envolva `GADApplicationIdentifier` com uma tag `key`.

3.  Envolva o seu App ID do AdMob com uma tag `string`. Você criou esse App ID
    do AdMob no [passo 1](#1-get-admob-app-ids).

    ```xml
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-################~##########</string>
    ```

## 3. Adicione o plugin google_mobile_ads {:#3-add-the-google_mobile_ads-plugin}

Para adicionar o plugin `google_mobile_ads` como dependência, execute
`flutter pub add`:

```console
$ flutter pub add google_mobile_ads
```

:::note
Depois de adicionar o plugin, o app Android pode falhar ao compilar com uma
`DexArchiveMergerException`:

```plaintext
Error while merging dex archives:
The number of method references in a .dex file cannot exceed 64K.
```

Para resolver isso, execute o comando `flutter run` no terminal, e não
por meio de um plugin de IDE. A ferramenta `flutter` pode detectar o problema e
perguntar se deve tentar resolvê-lo. Responda `y`, e o problema desaparece.
Depois disso, você pode voltar a executar o app pela IDE.

![Captura de tela da ferramenta `flutter` perguntando sobre suporte a multidex](/assets/images/docs/cookbook/ads-multidex.png)
:::

## 4. Inicialize o Mobile Ads SDK {:#4-initialize-the-mobile-ads-sdk}

Você precisa inicializar o Mobile Ads SDK antes de carregar anúncios.

1.  Chame `MobileAds.instance.initialize()` para inicializar o Mobile Ads
    SDK.

    <?code-excerpt "lib/main.dart (main)"?>
    ```dart
    void main() {
      WidgetsFlutterBinding.ensureInitialized();
      unawaited(MobileAds.instance.initialize());
    
      runApp(const MyApp());
    }
    ```

Execute a etapa de inicialização na inicialização do app, como mostrado acima,
para que o SDK do AdMob tenha tempo suficiente para ser inicializado antes de ser necessário.

:::note
`MobileAds.instance.initialize()` retorna um `Future`, mas, pela forma
como o SDK foi construído, você não precisa usar `await` nele.
Se você tentar carregar um anúncio antes que esse `Future` seja concluído,
o SDK aguardará de forma transparente a inicialização e, _então_, carregará o anúncio.
Você pode usar `await` no `Future`
se quiser saber o momento exato em que o SDK do AdMob está pronto.
:::

## 5. Carregue um banner {:#5-load-a-banner-ad}

Para mostrar um anúncio, você precisa solicitá-lo ao AdMob.

Para carregar um anúncio de banner, crie uma instância de `BannerAd` e
chame `load()` nela.

:::note
O trecho de código a seguir se refere a campos como `adSize`, `adUnitId`
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


## 6. Mostre o banner {:#6-show-banner-ad}

Depois de ter uma instância carregada de `BannerAd`, use `AdWidget` para exibi-la.

```dart
AdWidget(ad: _bannerAd)
```

É uma boa ideia envolver o widget em um `SafeArea` (para que nenhuma parte do
anúncio fique obstruída por entalhes do dispositivo) e em um `SizedBox` (para que ele tenha
o tamanho constante especificado antes e depois do carregamento).

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
prática para decidir quando chamar `dispose()` é depois que o `AdWidget` é
removido da árvore de widgets ou no callback
`BannerAdListener.onAdFailedToLoad()`.

<?code-excerpt "lib/my_banner_ad.dart (dispose)"?>
```dart
_bannerAd?.dispose();
```


## 7. Configure os anúncios {:#7-configure-ads}

Para mostrar qualquer coisa além de anúncios de teste, você precisa registrar as unidades de anúncio.

1.  Acesse o [AdMob](https://admob.google.com/).

2.  Crie uma *unidade de anúncio* para cada um dos apps do AdMob.

    ![Captura de tela da localização das unidades de anúncio na interface web do AdMob](/assets/images/docs/cookbook/ads-ad-unit.png)

    Isso pede o formato da unidade de anúncio. O AdMob oferece muitos formatos
    além de banners: intersticiais, anúncios com recompensa, anúncios de abertura do app e
    assim por diante.
    A API para esses formatos é semelhante e está documentada na
    [documentação do AdMob]({{site.developers}}/admob/flutter/quick-start)
    e em
    [exemplos oficiais](https://github.com/googleads/googleads-mobile-flutter/tree/main/samples/admob).

3.  Escolha anúncios de banner.

4.  Obtenha os *IDs das unidades de anúncio* tanto para o app Android quanto para o app
    iOS. Você pode encontrá-los na seção **Unidades de anúncio**. Eles têm um formato
    parecido com `ca-app-pub-1234567890123456/1234567890`. O formato é semelhante
    ao do *App ID*, mas com uma barra (`/`) entre os dois números. Isso
    diferencia um *ID de unidade de anúncio* de um *App ID*.

    ![Captura de tela de um ID de unidade de anúncio na interface web do AdMob](/assets/images/docs/cookbook/ads-ad-unit-id.png)

5.  Adicione esses *IDs das unidades de anúncio* ao construtor de `BannerAd`,
    de acordo com a plataforma de destino do app.

    <?code-excerpt "lib/my_banner_ad.dart (adUnitId)"?>
    ```dart
    final String adUnitId = Platform.isAndroid
        // Use this ad unit on Android...
        ? 'ca-app-pub-3940256099942544/6300978111'
        // ... or this one on iOS.
        : 'ca-app-pub-3940256099942544/2934735716';
    ```

## 8. Ajustes finais {:#8-final-touches}

Para exibir os anúncios em um app ou jogo publicado (e não em cenários de depuração ou teste),
seu app precisa atender a requisitos adicionais:

1.  Seu app precisa ser revisado e aprovado antes de poder veicular
    anúncios por completo.
    Siga as [diretrizes de prontidão de apps](https://support.google.com/admob/answer/10564477)
    do AdMob.
    Por exemplo, seu app precisa estar listado em pelo menos uma das
    lojas compatíveis, como a Google Play Store ou a Apple App Store.

2.  Você precisa [criar um arquivo `app-ads.txt`](https://support.google.com/admob/answer/9363762)
    e publicá-lo no site do seu desenvolvedor.

![Uma ilustração de um smartphone mostrando um anúncio](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Para saber mais sobre monetização de apps e jogos,
visite os sites oficiais
do [AdMob](https://admob.google.com/)
e do [Ad Manager](https://admanager.google.com/).


## 9. Exemplo completo {:#9-complete-example}

O código a seguir implementa um widget com estado simples que carrega um
anúncio de banner e o exibe.

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

  MyBannerAdWidget({super.key, this.adSize = AdSize.banner});

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

Por exemplo, você pode carregá-lo em um `ChangeNotifier`, em um BLoC, em um controller
ou em qualquer outra ferramenta que use para o estado em nível de app. Assim, você pode
pré-carregar um anúncio de banner com antecedência e deixá-lo pronto para exibir quando o
usuário navegar para uma nova tela.

Verifique se você carregou a instância de `BannerAd` antes de exibi-la com
um `AdWidget`, e se descarta a instância quando ela não for mais
necessária.
:::
