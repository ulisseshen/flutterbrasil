---
ia-translate: true
title: Adicione conquistas e tabelas de classificação ao seu jogo mobile
description: >
  Como usar o plugin games_services para adicionar funcionalidade ao seu jogo.
---

<?code-excerpt path-base="cookbook/games/achievements_leaderboards"?>

Jogadores têm várias motivações para jogar jogos.
Em linhas gerais, existem quatro motivações principais:
[imersão, conquista, cooperação e competição][immersion, achievement, cooperation, and competition].
Não importa o jogo que você construa, alguns jogadores querem *conquistar* nele.
Isso pode ser troféus ganhos ou segredos desbloqueados.
Alguns jogadores querem *competir* nele.
Isso pode ser alcançar pontuações altas ou realizar speedruns.
Essas duas ideias se relacionam com os conceitos de *conquistas* e *tabelas de classificação*.

![A simple graphic representing the four types of motivation explained above](/assets/images/docs/cookbook/types-of-gamer-motivations.png){:.site-illustration}

Ecossistemas como a App Store e Google Play fornecem
serviços centralizados para conquistas e tabelas de classificação.
Jogadores podem visualizar conquistas de todos os seus jogos em um só lugar e
desenvolvedores não precisam reimplementá-los para cada jogo.

Esta receita demonstra como usar o [pacote `games_services`][`games_services` package]
para adicionar funcionalidade de conquistas e tabela de classificação ao seu jogo mobile.

[`games_services` package]: {{site.pub-pkg}}/games_services
[immersion, achievement, cooperation, and competition]: https://meditations.metavert.io/p/game-player-motivations

## 1. Habilite os serviços da plataforma

Para habilitar os serviços de jogos, configure o *Game Center* no iOS e
o *Google Play Games Services* no Android.

### iOS

Para habilitar o Game Center (GameKit) no iOS:

1.  Abra seu projeto Flutter no Xcode.
    Abra `ios/Runner.xcworkspace`

2.  Selecione o projeto **Runner** raiz.

3.  Vá para a aba **Signing & Capabilities**.

4.  Clique no botão `+` para adicionar **Game Center** como uma capability.

5.  Feche o Xcode.

6.  Se você ainda não fez isso,
    registre seu jogo no [App Store Connect][App Store Connect]
    e na seção **My App** pressione o ícone `+`.

    ![Screenshot of the + button in App Store Connect](/assets/images/docs/cookbook/app-store-add-app-button.png)

7.  Ainda no App Store Connect, procure a seção *Game Center*. Você
    pode encontrá-la em **Services** no momento desta escrita. Na página **Game
    Center**, você pode querer configurar uma tabela de classificação e várias
    conquistas, dependendo do seu jogo. Anote os IDs das
    tabelas de classificação e conquistas que você criar.

[App Store Connect]: https://appstoreconnect.apple.com/

### Android

Para habilitar o *Play Games Services* no Android:

1.  Se você ainda não fez isso, vá para o [Google Play Console][Google Play Console]
    e registre seu jogo lá.

    ![Screenshot of the 'Create app' button in Google Play Console](/assets/images/docs/cookbook/google-play-create-app.png)

2.  Ainda no Google Play Console, selecione *Play Games Services* → *Setup
    and management* → *Configuration* no menu de navegação e
    siga as instruções.

      * Isso leva uma quantidade significativa de tempo e paciência.
        Entre outras coisas, você precisará configurar uma
        tela de consentimento OAuth no Google Cloud Console.
        Se em algum momento você se sentir perdido, consulte o
        [guia oficial do Play Games Services][Play Games Services guide].

        ![Screenshot showing the Games Services section in Google Play Console](/assets/images/docs/cookbook/play-console-play-games-services.png)

3.  Quando terminar, você pode começar a adicionar tabelas de classificação e conquistas em
    **Play Games Services** → **Setup and management**. Crie exatamente o
    mesmo conjunto que você criou no lado iOS. Anote os IDs.

4.  Vá para **Play Games Services → Setup and management → Publishing**.

5.  Clique em **Publish**. Não se preocupe, isso não publica realmente seu
    jogo. Isso publica apenas as conquistas e a tabela de classificação. Uma vez que uma
    tabela de classificação, por exemplo, é publicada dessa forma, ela não pode ser
    despublicada.

6.  Vá para **Play Games Services** **→ Setup and management →
    Configuration → Credentials**.

7.  Encontre o botão **Get resources**.
    Ele retorna um arquivo XML com os IDs do Play Games Services.

    ```xml
    <!-- THIS IS JUST AN EXAMPLE -->
    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <!--app_id-->
        <string name="app_id" translatable="false">424242424242</string>
        <!--package_name-->
        <string name="package_name" translatable="false">dev.flutter.tictactoe</string>
        <!--achievement First win-->
        <string name="achievement_first_win" translatable="false">sOmEiDsTrInG</string>
        <!--leaderboard Highest Score-->
        <string name="leaderboard_highest_score" translatable="false">sOmEiDsTrInG</string>
    </resources>
    ```

8.  Adicione um arquivo em `android/app/src/main/res/values/games-ids.xml`
    contendo o XML que você recebeu no passo anterior.

[Google Play Console]: https://play.google.com/console/
[Play Games Services guide]: {{site.developers}}/games/services/console/enabling

## 2. Faça login no serviço de jogos

Agora que você configurou o *Game Center* e o *Play Games Services*, e
tem seus IDs de conquistas e tabelas de classificação prontos, é finalmente hora do Dart.

1.  Adicione uma dependência no [pacote `games_services`]({{site.pub-pkg}}/games_services).

    ```console
    $ flutter pub add games_services
    ```

2.  Antes de poder fazer qualquer outra coisa, você precisa fazer login do
    jogador no serviço de jogos.

    <?code-excerpt "lib/various.dart (signIn)"?>
    ```dart
    try {
      await GamesServices.signIn();
    } on PlatformException catch (e) {
      // ... deal with failures ...
    }
    ```

O login acontece em segundo plano. Leva vários segundos, então
não chame `signIn()` antes de `runApp()` ou os jogadores serão forçados a
olhar para uma tela em branco toda vez que iniciarem seu jogo.

As chamadas de API para a API `games_services` podem falhar por diversos
motivos. Portanto, toda chamada deve ser envolvida em um bloco try-catch como
no exemplo anterior. O restante desta receita omite o tratamento de exceções
para maior clareza.

:::tip
É uma boa prática criar um controller. Este seria um
`ChangeNotifier`, um bloc, ou alguma outra peça de lógica que envolve
a funcionalidade bruta do plugin `games_services`.
:::


## 3. Desbloqueie conquistas

1.  Registre conquistas no Google Play Console e App Store Connect,
    e anote seus IDs. Agora você pode conceder qualquer uma dessas
    conquistas do seu código Dart:

    <?code-excerpt "lib/various.dart (unlock)"?>
    ```dart
    await GamesServices.unlock(
      achievement: Achievement(
        androidID: 'your android id',
        iOSID: 'your ios id',
      ),
    );
    ```

    A conta do jogador no Google Play Games ou Apple Game Center agora
    lista a conquista.

2.  Para exibir a UI de conquistas do seu jogo, chame a
    API `games_services`:

    <?code-excerpt "lib/various.dart (showAchievements)"?>
    ```dart
    await GamesServices.showAchievements();
    ```

    Isso exibe a UI de conquistas da plataforma como uma sobreposição sobre seu jogo.

3.  Para exibir as conquistas na sua própria UI, use
    [`GamesServices.loadAchievements()`][`GamesServices.loadAchievements()`].

[`GamesServices.loadAchievements()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadAchievements.html

## 4. Envie pontuações

Quando o jogador termina uma partida, seu jogo pode enviar o resultado
dessa sessão de jogo para uma ou mais tabelas de classificação.

Por exemplo, um jogo de plataforma como Super Mario pode enviar tanto a
pontuação final quanto o tempo levado para completar o nível, para duas
tabelas de classificação separadas.

1.  No primeiro passo, você registrou uma tabela de classificação no Google Play
    Console e App Store Connect, e anotou seu ID. Usando este
    ID, você pode enviar novas pontuações para o jogador:

    <?code-excerpt "lib/various.dart (submitScore)"?>
    ```dart
    await GamesServices.submitScore(
      score: Score(
        iOSLeaderboardID: 'some_id_from_app_store',
        androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
        value: 100,
      ),
    );
    ```

    Você não precisa verificar se a nova pontuação é a mais alta do jogador.
    Os serviços de jogos da plataforma cuidam disso para você.

2.  Para exibir a tabela de classificação como uma sobreposição sobre seu jogo, faça a
    seguinte chamada:

    <?code-excerpt "lib/various.dart (showLeaderboards)"?>
    ```dart
    await GamesServices.showLeaderboards(
      iOSLeaderboardID: 'some_id_from_app_store',
      androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
    );
    ```

3.  Se você quiser exibir as pontuações da tabela de classificação na sua própria UI, você
    pode buscá-las com [`GamesServices.loadLeaderboardScores()`][`GamesServices.loadLeaderboardScores()`].

[`GamesServices.loadLeaderboardScores()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadLeaderboardScores.html

## 5. Próximos passos

Há mais no plugin `games_services`. Com este plugin, você pode:

- Obter o ícone, nome ou ID único do jogador
- Salvar e carregar estados do jogo
- Fazer logout do serviço de jogos

Algumas conquistas podem ser incrementais. Por exemplo: "Você coletou
todas as 10 peças do McGuffin."

Cada jogo tem necessidades diferentes dos serviços de jogos.

Para começar, você pode querer criar este controller
para manter toda a lógica de conquistas e tabelas de classificação em um só lugar:

<?code-excerpt "lib/games_services_controller.dart"?>
```dart
import 'dart:async';

import 'package:games_services/games_services.dart';
import 'package:logging/logging.dart';

/// Allows awarding achievements and leaderboard scores,
/// and also showing the platforms' UI overlays for achievements
/// and leaderboards.
///
/// A facade of `package:games_services`.
class GamesServicesController {
  static final Logger _log = Logger('GamesServicesController');

  final Completer<bool> _signedInCompleter = Completer();

  Future<bool> get signedIn => _signedInCompleter.future;

  /// Unlocks an achievement on Game Center / Play Games.
  ///
  /// You must provide the achievement ids via the [iOS] and [android]
  /// parameters.
  ///
  /// Does nothing when the game isn't signed into the underlying
  /// games service.
  Future<void> awardAchievement({
    required String iOS,
    required String android,
  }) async {
    if (!await signedIn) {
      _log.warning('Trying to award achievement when not logged in.');
      return;
    }

    try {
      await GamesServices.unlock(
        achievement: Achievement(androidID: android, iOSID: iOS),
      );
    } catch (e) {
      _log.severe('Cannot award achievement: $e');
    }
  }

  /// Signs into the underlying games service.
  Future<void> initialize() async {
    try {
      await GamesServices.signIn();
      // The API is unclear so we're checking to be sure. The above call
      // returns a String, not a boolean, and there's no documentation
      // as to whether every non-error result means we're safely signed in.
      final signedIn = await GamesServices.isSignedIn;
      _signedInCompleter.complete(signedIn);
    } catch (e) {
      _log.severe('Cannot log into GamesServices: $e');
      _signedInCompleter.complete(false);
    }
  }

  /// Launches the platform's UI overlay with achievements.
  Future<void> showAchievements() async {
    if (!await signedIn) {
      _log.severe('Trying to show achievements when not logged in.');
      return;
    }

    try {
      await GamesServices.showAchievements();
    } catch (e) {
      _log.severe('Cannot show achievements: $e');
    }
  }

  /// Launches the platform's UI overlay with leaderboard(s).
  Future<void> showLeaderboard() async {
    if (!await signedIn) {
      _log.severe('Trying to show leaderboard when not logged in.');
      return;
    }

    try {
      await GamesServices.showLeaderboards(
        // TODO: When ready, change both these leaderboard IDs.
        iOSLeaderboardID: 'some_id_from_app_store',
        androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
      );
    } catch (e) {
      _log.severe('Cannot show leaderboard: $e');
    }
  }

  /// Submits [score] to the leaderboard.
  Future<void> submitLeaderboardScore(int score) async {
    if (!await signedIn) {
      _log.warning('Trying to submit leaderboard when not logged in.');
      return;
    }

    _log.info('Submitting $score to leaderboard.');

    try {
      await GamesServices.submitScore(
        score: Score(
          // TODO: When ready, change these leaderboard IDs.
          iOSLeaderboardID: 'some_id_from_app_store',
          androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
          value: score,
        ),
      );
    } catch (e) {
      _log.severe('Cannot submit leaderboard score: $e');
    }
  }
}
```

## Mais informações

O Flutter Casual Games Toolkit inclui os seguintes templates:

* [basic][basic]: jogo inicial básico
* [card][card]: jogo de cartas inicial
* [endless runner][endless runner]: jogo inicial (usando Flame)
  onde o jogador corre infinitamente, evitando armadilhas
  e ganhando recompensas

[basic]: {{site.github}}/flutter/games/tree/main/templates/basic#readme
[card]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[endless runner]: {{site.github}}/flutter/games/tree/main/templates/endless_runner#readme
