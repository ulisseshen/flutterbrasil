---
ia-translate: true
title: Adicione conquistas e placares de líderes ao seu jogo mobile
description: >
  Como usar o plugin games_services para adicionar funcionalidades ao seu jogo.
---

<?code-excerpt path-base="cookbook/games/achievements_leaderboards"?>

Jogadores têm várias motivações para jogar.
Em linhas gerais, existem quatro motivações principais:
[imersão, conquista, cooperação e competição][].
Não importa o jogo que você construa, alguns jogadores querem *conquistar* algo nele.
Isso pode ser troféus ganhos ou segredos desbloqueados.
Alguns jogadores querem *competir* nele.
Isso pode ser atingir altas pontuações ou realizar speedruns.
Essas duas ideias mapeiam os conceitos de *conquistas* e *placar de líderes* (leaderboards).

![Um gráfico simples representando os quatro tipos de motivação explicados acima](/assets/images/docs/cookbook/types-of-gamer-motivations.png){:.site-illustration}

Ecossistemas como a App Store e o Google Play fornecem
serviços centralizados para conquistas e placares de líderes.
Jogadores podem ver as conquistas de todos os seus jogos em um só lugar e
desenvolvedores não precisam reimplementá-los para cada jogo.

Esta receita demonstra como usar o pacote [`games_services`][]
para adicionar funcionalidades de conquistas e placar de líderes ao seu jogo mobile.

[`games_services` package]: {{site.pub-pkg}}/games_services
[imersão, conquista, cooperação e competição]: https://meditations.metavert.io/p/game-player-motivations

## 1. Habilite serviços de plataforma

Para habilitar os serviços de jogos, configure o *Game Center* no iOS e
o *Google Play Games Services* no Android.

### iOS

Para habilitar o Game Center (GameKit) no iOS:

1.  Abra seu projeto Flutter no Xcode.
    Abra `ios/Runner.xcworkspace`

2.  Selecione o projeto raiz **Runner**.

3.  Vá para a aba **Signing & Capabilities**.

4.  Clique no botão `+` para adicionar **Game Center** como uma capacidade.

5.  Feche o Xcode.

6.  Se você ainda não fez isso,
    registre seu jogo no [App Store Connect][]
    e na seção **My App**, clique no ícone `+`.

    ![Captura de tela do botão + no App Store Connect](/assets/images/docs/cookbook/app-store-add-app-button.png)

7.  Ainda no App Store Connect, procure a seção *Game Center*. Você
    pode encontrá-la em **Services**, no momento em que escrevo isso. Na página do **Game
    Center**, você pode querer configurar um placar de líderes e várias
    conquistas, dependendo do seu jogo. Anote os IDs dos
    placar de líderes e conquistas que você criar.

[App Store Connect]: https://appstoreconnect.apple.com/

### Android

Para habilitar o *Play Games Services* no Android:

1.  Se você ainda não fez isso, vá para o [Google Play Console][]
    e registre seu jogo lá.

    ![Captura de tela do botão 'Criar aplicativo' no Google Play Console](/assets/images/docs/cookbook/google-play-create-app.png)

2.  Ainda no Google Play Console, selecione *Play Games Services* → *Configuração
    e gerenciamento* → *Configuração* no menu de navegação e
    siga as instruções.

      * Isso leva uma quantidade significativa de tempo e paciência.
        Entre outras coisas, você precisará configurar uma
        tela de consentimento OAuth no Google Cloud Console.
        Se em algum momento você se sentir perdido, consulte o
        [guia oficial do Play Games Services][].

        ![Captura de tela mostrando a seção de Serviços de jogos no Google Play Console](/assets/images/docs/cookbook/play-console-play-games-services.png)

3.  Quando terminar, você pode começar a adicionar placares de líderes e conquistas em
    **Play Games Services** → **Configuração e gerenciamento**. Crie o mesmo conjunto
    exato que você fez no lado iOS. Anote os IDs.

4.  Vá para **Play Games Services → Configuração e gerenciamento → Publicação**.

5.  Clique em **Publicar**. Não se preocupe, isso não publica seu
    jogo. Isso só publica as conquistas e o placar de líderes. Uma vez que um
    placar de líderes, por exemplo, é publicado dessa forma, ele não pode ser
    despublicado.

6.  Vá para **Play Games Services** **→ Configuração e gerenciamento →
    Configuração → Credenciais**.

7.  Encontre o botão **Obter recursos**.
    Ele retorna um arquivo XML com os IDs do Play Games Services.

    ```xml
    <!-- ESTE É APENAS UM EXEMPLO -->
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
    contendo o XML que você recebeu na etapa anterior.

[Google Play Console]: https://play.google.com/console/
[guia oficial do Play Games Services]: {{site.developers}}/games/services/console/enabling

## 2. Faça login no serviço de jogos

Agora que você configurou o *Game Center* e o *Play Games Services*, e
tem seus IDs de conquista e placar de líderes prontos, finalmente é hora do Dart.

1.  Adicione uma dependência no pacote [`games_services`]({{site.pub-pkg}}/games_services).

    ```console
    $ flutter pub add games_services
    ```

2.  Antes de fazer qualquer outra coisa, você precisa fazer o jogador fazer login no
    serviço de jogos.

    <?code-excerpt "lib/various.dart (signIn)"?>
    ```dart
    try {
      await GamesServices.signIn();
    } on PlatformException catch (e) {
      // ... lide com as falhas ...
    }
    ```

O login acontece em segundo plano. Leva vários segundos, então
não chame `signIn()` antes de `runApp()` ou os jogadores serão forçados a
olhar para uma tela em branco toda vez que iniciarem seu jogo.

As chamadas de API para a API `games_services` podem falhar por uma variedade de
razões. Portanto, cada chamada deve ser envolvida em um bloco try-catch como
no exemplo anterior. O resto desta receita omite o tratamento de exceções
para clareza.

:::tip
É uma boa prática criar um controller. Este seria um
`ChangeNotifier`, um bloc ou alguma outra parte da lógica que envolve
a funcionalidade bruta do plugin `games_services`.
:::

## 3. Desbloquear conquistas

1.  Registre as conquistas no Google Play Console e no App Store Connect,
    e anote seus IDs. Agora você pode conceder qualquer uma dessas
    conquistas do seu código Dart:

    <?code-excerpt "lib/various.dart (unlock)"?>
    ```dart
    await GamesServices.unlock(
      achievement: Achievement(
        androidID: 'seu id android',
        iOSID: 'seu id ios',
      ),
    );
    ```

    A conta do jogador no Google Play Games ou Apple Game Center agora
    lista a conquista.

2.  Para exibir a interface do usuário de conquistas do seu jogo, chame a
    API `games_services`:

    <?code-excerpt "lib/various.dart (showAchievements)"?>
    ```dart
    await GamesServices.showAchievements();
    ```

    Isso exibe a interface do usuário de conquistas da plataforma como uma sobreposição em seu jogo.

3.  Para exibir as conquistas em sua própria interface do usuário, use
    [`GamesServices.loadAchievements()`][].

[`GamesServices.loadAchievements()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadAchievements.html

## 4. Enviar pontuações

Quando o jogador termina uma partida, seu jogo pode enviar o resultado
dessa sessão de jogo para um ou mais placares de líderes.

Por exemplo, um jogo de plataforma como Super Mario pode enviar tanto o
pontuação final quanto o tempo gasto para completar a fase, para dois
placar de líderes separados.

1.  Na primeira etapa, você registrou um placar de líderes no Google Play
    Console e App Store Connect, e anotou seu ID. Usando este
    ID, você pode enviar novas pontuações para o jogador:

    <?code-excerpt "lib/various.dart (submitScore)"?>
    ```dart
    await GamesServices.submitScore(
      score: Score(
        iOSLeaderboardID: 'algum_id_da_app_store',
        androidLeaderboardID: 'aLgUm_Id_dO_gPlAy',
        value: 100,
      ),
    );
    ```

    Você não precisa verificar se a nova pontuação é a mais alta do jogador.
    Os serviços de jogos da plataforma cuidam disso para você.

2.  Para exibir o placar de líderes como uma sobreposição sobre seu jogo, faça a
    seguinte chamada:

    <?code-excerpt "lib/various.dart (showLeaderboards)"?>
    ```dart
    await GamesServices.showLeaderboards(
      iOSLeaderboardID: 'algum_id_da_app_store',
      androidLeaderboardID: 'aLgUm_Id_dO_gPlAy',
    );
    ```

3.  Se você quiser exibir as pontuações do placar de líderes em sua própria interface do usuário, você
    pode buscá-las com [`GamesServices.loadLeaderboardScores()`][].

[`GamesServices.loadLeaderboardScores()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadLeaderboardScores.html

## 5. Próximos passos

Há mais no plugin `games_services`. Com este plugin, você pode:

- Obter o ícone, nome ou ID exclusivo do jogador
- Salvar e carregar estados de jogo
- Sair do serviço de jogos

Algumas conquistas podem ser incrementais. Por exemplo: "Você coletou
todas as 10 peças do McGuffin."

Cada jogo tem necessidades diferentes de serviços de jogos.

Para começar, você pode querer criar este controller
para manter toda a lógica de conquistas e placar de líderes em um só lugar:

<?code-excerpt "lib/games_services_controller.dart"?>
```dart
import 'dart:async';

import 'package:games_services/games_services.dart';
import 'package:logging/logging.dart';

/// Permite conceder conquistas e pontuações do placar de líderes,
/// e também mostrar as sobreposições da UI das plataformas para conquistas
/// e placares de líderes.
///
/// Uma fachada do `package:games_services`.
class GamesServicesController {
  static final Logger _log = Logger('GamesServicesController');

  final Completer<bool> _signedInCompleter = Completer();

  Future<bool> get signedIn => _signedInCompleter.future;

  /// Desbloqueia uma conquista no Game Center / Play Games.
  ///
  /// Você deve fornecer os ids de conquista por meio dos parâmetros [iOS] e [android].
  ///
  /// Não faz nada quando o jogo não está conectado ao serviço de jogos subjacente.
  Future<void> awardAchievement(
      {required String iOS, required String android}) async {
    if (!await signedIn) {
      _log.warning('Tentando conceder conquista quando não está logado.');
      return;
    }

    try {
      await GamesServices.unlock(
        achievement: Achievement(
          androidID: android,
          iOSID: iOS,
        ),
      );
    } catch (e) {
      _log.severe('Não é possível conceder conquista: $e');
    }
  }

  /// Faz login no serviço de jogos subjacente.
  Future<void> initialize() async {
    try {
      await GamesServices.signIn();
      // A API não é clara, então estamos verificando para ter certeza. A chamada acima
      // retorna uma String, não um booleano, e não há documentação
      // sobre se todo resultado sem erro significa que estamos conectados com segurança.
      final signedIn = await GamesServices.isSignedIn;
      _signedInCompleter.complete(signedIn);
    } catch (e) {
      _log.severe('Não é possível fazer login no GamesServices: $e');
      _signedInCompleter.complete(false);
    }
  }

  /// Lança a sobreposição de UI da plataforma com conquistas.
  Future<void> showAchievements() async {
    if (!await signedIn) {
      _log.severe('Tentando mostrar conquistas quando não está logado.');
      return;
    }

    try {
      await GamesServices.showAchievements();
    } catch (e) {
      _log.severe('Não é possível mostrar conquistas: $e');
    }
  }

  /// Lança a sobreposição de UI da plataforma com o(s) placar(es) de líderes.
  Future<void> showLeaderboard() async {
    if (!await signedIn) {
      _log.severe('Tentando mostrar o placar de líderes quando não está logado.');
      return;
    }

    try {
      await GamesServices.showLeaderboards(
        // TODO: Quando estiver pronto, altere ambos esses IDs de placar de líderes.
        iOSLeaderboardID: 'algum_id_da_app_store',
        androidLeaderboardID: 'aLgUm_Id_dO_gPlAy',
      );
    } catch (e) {
      _log.severe('Não é possível mostrar o placar de líderes: $e');
    }
  }

  /// Envia [score] para o placar de líderes.
  Future<void> submitLeaderboardScore(int score) async {
    if (!await signedIn) {
      _log.warning('Tentando enviar o placar de líderes quando não está logado.');
      return;
    }

    _log.info('Enviando $score para o placar de líderes.');

    try {
      await GamesServices.submitScore(
        score: Score(
          // TODO: Quando estiver pronto, altere esses IDs de placar de líderes.
          iOSLeaderboardID: 'algum_id_da_app_store',
          androidLeaderboardID: 'aLgUm_Id_dO_gPlAy',
          value: score,
        ),
      );
    } catch (e) {
      _log.severe('Não é possível enviar pontuação para o placar de líderes: $e');
    }
  }
}
```

## Mais informações

O Flutter Casual Games Toolkit inclui os seguintes templates:

* [basic][]: jogo inicial básico
* [card][]: jogo de cartas inicial
* [endless runner][]: jogo inicial (usando Flame)
  onde o jogador corre infinitamente, evitando armadilhas
  e ganhando recompensas

[basic]: {{site.github}}/flutter/games/tree/main/templates/basic#readme
[card]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[endless runner]: {{site.github}}/flutter/games/tree/main/templates/endless_runner#readme
