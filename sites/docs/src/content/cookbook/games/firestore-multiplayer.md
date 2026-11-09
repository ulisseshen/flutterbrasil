---
title: Adicione suporte multiplayer usando Firestore
description: >
  Como usar o Firebase Cloud Firestore para implementar multiplayer
  no seu jogo.
ia-translate: true
---

<?code-excerpt path-base="cookbook/games/firestore_multiplayer"?>

Jogos multiplayer precisam de uma forma de sincronizar estados de jogo entre jogadores.
De modo geral, existem dois tipos de jogos multiplayer:

1. **Alta taxa de ticks**.
   Estes jogos precisam sincronizar estados de jogo muitas vezes por segundo
   com baixa latência.
   Isso incluiria jogos de ação, jogos esportivos, jogos de luta.

2. **Baixa taxa de ticks**.
   Estes jogos só precisam sincronizar estados de jogo ocasionalmente
   com a latência tendo menos impacto.
   Isso incluiria jogos de cartas, jogos de estratégia, jogos de quebra-cabeça.

Isso se assemelha à diferenciação entre jogos em tempo real e jogos por turnos,
embora a analogia não seja perfeita.
Por exemplo, jogos de estratégia em tempo real rodam, como o nome sugere,
em tempo real, mas isso não se correlaciona com uma alta taxa de ticks.
Esses jogos podem simular grande parte do que acontece
entre as interações dos jogadores nas máquinas locais.
Por isso, eles não precisam sincronizar estados de jogo com tanta frequência.

![Uma ilustração de dois celulares e uma seta de duas vias entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Se você, como desenvolvedor, puder escolher taxas de ticks baixas, deve fazê-lo.
Uma taxa de ticks baixa reduz os requisitos de latência e os custos de servidor.
Às vezes, um jogo exige altas taxas de ticks de sincronização.
Para esses casos, soluções como o Firestore *não são uma boa escolha*.
Escolha uma solução de servidor multiplayer dedicada, como o [Nakama][].
O Nakama tem um [pacote Dart][Dart package].

Se você espera que o seu jogo precise de uma taxa de ticks baixa de sincronização,
continue lendo.

Esta receita demonstra como usar o [pacote `cloud_firestore`][`cloud_firestore` package]
para implementar recursos multiplayer no seu jogo.
Esta receita não requer um servidor.
Ela usa dois ou mais clientes compartilhando o estado do jogo por meio do Cloud Firestore.

[`cloud_firestore` package]: {{site.pub-pkg}}/cloud_firestore
[Dart package]: {{site.pub-pkg}}/nakama
[Nakama]: https://heroiclabs.com/nakama/

## 1. Prepare seu jogo para multiplayer {:#1-prepare-your-game-for-multiplayer}

Escreva o código do seu jogo para permitir a alteração do estado do jogo
em resposta tanto a eventos locais quanto a eventos remotos.
Um evento local pode ser uma ação do jogador ou alguma lógica do jogo.
Um evento remoto pode ser uma atualização do mundo vinda do servidor.

![Captura de tela do jogo de cartas](/assets/images/docs/cookbook/multiplayer-card-game.jpg){:.site-mobile-screenshot .site-illustration}

Para simplificar esta receita do cookbook, comece com
o template [`card`][] que você encontrará no
[repositório `flutter/games`][`flutter/games` repository].
Execute o comando a seguir para clonar esse repositório:

```console
git clone https://github.com/flutter/games.git
```

{% comment %}
  Se/quando tivermos uma ferramenta "sample_extractor", ou qualquer outra forma
  mais fácil de obter o código, mencione isso aqui.
{% endcomment %}

Abra o projeto em `templates/card`.

:::note
Você pode ignorar esta etapa e seguir a receita com o seu próprio projeto de jogo.
Adapte o código nos lugares apropriados.
:::

[`card`]: {{site.repo.games}}/tree/main/templates/card#readme
[`flutter/games` repository]: {{site.repo.games}}

## 2. Instale o Firestore {:#2-install-firestore}

[Cloud Firestore][] é um banco de dados de documentos NoSQL, na nuvem,
com escalabilidade horizontal.
Ele inclui sincronização ao vivo integrada.
Isso é perfeito para as nossas necessidades.
Ele mantém o estado do jogo atualizado no banco de dados na nuvem,
para que todos os jogadores vejam o mesmo estado.

Se você quiser uma introdução rápida de 15 minutos ao Cloud Firestore,
confira o vídeo a seguir:

<YouTubeEmbed id="v_hR4K4auoQ" title="O que é um banco de dados NoSQL? Saiba mais sobre o Cloud Firestore"></YouTubeEmbed>

Para adicionar o Firestore ao seu projeto Flutter,
siga os dois primeiros passos do guia
[Comece com o Cloud Firestore][Get started with Cloud Firestore]:

* [Crie um banco de dados do Cloud Firestore][Create a Cloud Firestore database]
* [Configure o seu ambiente de desenvolvimento][Set up your development environment]

Os resultados desejados incluem:

* Um banco de dados Firestore pronto na nuvem, em **modo de teste**
* Um arquivo `firebase_options.dart` gerado
* Os plugins apropriados adicionados ao seu `pubspec.yaml`

Você *não* precisa escrever nenhum código Dart nesta etapa.
Assim que entender a etapa de escrita de
código Dart nesse guia, volte para esta receita.

{% comment %}
  Revisite para ver se conseguimos incluir as etapas aqui:
  <https://firebase.google.com/docs/flutter/setup>
  ... seguidas pelos dois primeiros passos aqui:
  <https://firebase.google.com/docs/firestore/quickstart>
{% endcomment %}

[Cloud Firestore]: https://cloud.google.com/firestore/
[Create a Cloud Firestore database]: {{site.firebase}}/docs/firestore/quickstart#create
[Get started with Cloud Firestore]: {{site.firebase}}/docs/firestore/quickstart
[Set up your development environment]: {{site.firebase}}/docs/firestore/quickstart#set_up_your_development_environment

## 3. Inicialize o Firestore {:#3-initialize-firestore}

1. Abra `lib/main.dart` e importe os plugins,
    bem como o arquivo `firebase_options.dart`
    que foi gerado por `flutterfire configure` na etapa anterior.

    <?code-excerpt "lib/main.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_core/firebase_core.dart';
    
    import 'firebase_options.dart';
    ```

2. Adicione o código a seguir logo acima da chamada a `runApp()`
    em `lib/main.dart`:

    <?code-excerpt "lib/main.dart (initializeApp)"?>
    ```dart
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ```

    Isso garante que o Firebase seja inicializado na inicialização do jogo.

3. Adicione a instância do Firestore ao app.
    Dessa forma, qualquer widget pode acessar essa instância.
    Os widgets também podem reagir à ausência da instância, se necessário.

    Para fazer isso com o template `card`, você pode usar
    o pacote `provider`
    (que já está instalado como dependência).

    Substitua o `runApp(MyApp())` padrão pelo código a seguir:

    <?code-excerpt "lib/main.dart (runApp)"?>
    ```dart
    runApp(Provider.value(value: FirebaseFirestore.instance, child: MyApp()));
    ```

    Coloque o provider acima de `MyApp`, e não dentro dele.
    Isso permite que você teste o app sem o Firebase.

    :::note
    Caso você *não* esteja trabalhando com o template `card`, você deve
    [instalar o pacote `provider`][install the `provider` package]
    ou usar o seu próprio método para acessar a instância de `FirebaseFirestore`
    a partir de várias partes da sua base de código.
    :::

[install the `provider` package]: {{site.pub-pkg}}/provider/install

## 4. Crie uma classe controladora do Firestore {:#4-create-a-firestore-controller-class}

Embora você possa se comunicar diretamente com o Firestore,
deve escrever uma classe controladora dedicada
para tornar o código mais legível e fácil de manter.

A forma como você implementa o controlador depende do seu jogo
e do design exato da sua experiência multiplayer.
No caso do template `card`,
você poderia sincronizar o conteúdo das duas áreas circulares de jogo.
Não é o suficiente para uma experiência multiplayer completa,
mas é um bom começo.

![Captura de tela do jogo de cartas, com setas apontando para as áreas de jogo](/assets/images/docs/cookbook/multiplayer-areas.jpg){:.site-mobile-screenshot .site-illustration}

Para criar um controlador, copie e cole
o código a seguir em um novo arquivo chamado
`lib/multiplayer/firestore_controller.dart`.

<?code-excerpt "lib/multiplayer/firestore_controller.dart"?>
```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';

class FirestoreController {
  static final _log = Logger('FirestoreController');

  final FirebaseFirestore instance;

  final BoardState boardState;

  /// For now, there is only one match. But in order to be ready
  /// for match-making, put it in a Firestore collection called matches.
  late final DocumentReference<Map<String, Object?>> _matchRef = instance
      .collection('matches')
      .doc('match_1');

  late final DocumentReference<List<PlayingCard>> _areaOneRef = _matchRef
      .collection('areas')
      .doc('area_one')
      .withConverter<List<PlayingCard>>(
        fromFirestore: _cardsFromFirestore,
        toFirestore: _cardsToFirestore,
      );

  late final DocumentReference<List<PlayingCard>> _areaTwoRef = _matchRef
      .collection('areas')
      .doc('area_two')
      .withConverter<List<PlayingCard>>(
        fromFirestore: _cardsFromFirestore,
        toFirestore: _cardsToFirestore,
      );

  late final StreamSubscription<void> _areaOneFirestoreSubscription;
  late final StreamSubscription<void> _areaTwoFirestoreSubscription;

  late final StreamSubscription<void> _areaOneLocalSubscription;
  late final StreamSubscription<void> _areaTwoLocalSubscription;

  FirestoreController({required this.instance, required this.boardState}) {
    // Subscribe to the remote changes (from Firestore).
    _areaOneFirestoreSubscription = _areaOneRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaOne, snapshot);
    });
    _areaTwoFirestoreSubscription = _areaTwoRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaTwo, snapshot);
    });

    // Subscribe to the local changes in game state.
    _areaOneLocalSubscription = boardState.areaOne.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaOne();
    });
    _areaTwoLocalSubscription = boardState.areaTwo.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaTwo();
    });

    _log.fine('Initialized');
  }

  void dispose() {
    _areaOneFirestoreSubscription.cancel();
    _areaTwoFirestoreSubscription.cancel();
    _areaOneLocalSubscription.cancel();
    _areaTwoLocalSubscription.cancel();

    _log.fine('Disposed');
  }

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a list of [PlayingCard]s.
  List<PlayingCard> _cardsFromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?['cards'] as List<Object?>?;

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      return [];
    }

    try {
      return data
          .cast<Map<String, Object?>>()
          .map(PlayingCard.fromJson)
          .toList();
    } catch (e) {
      throw FirebaseControllerException(
        'Failed to parse data from Firestore: $e',
      );
    }
  }

  /// Takes a list of [PlayingCard]s and converts it into a JSON object
  /// that can be saved into Firestore.
  Map<String, Object?> _cardsToFirestore(
    List<PlayingCard> cards,
    SetOptions? options,
  ) {
    return {'cards': cards.map((c) => c.toJson()).toList()};
  }

  /// Updates Firestore with the local state of [area].
  Future<void> _updateFirestoreFromLocal(
    PlayingArea area,
    DocumentReference<List<PlayingCard>> ref,
  ) async {
    try {
      _log.fine('Updating Firestore with local data (${area.cards}) ...');
      await ref.set(area.cards);
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
        'Failed to update Firestore with local data (${area.cards}): $e',
      );
    }
  }

  /// Sends the local state of `boardState.areaOne` to Firestore.
  void _updateFirestoreFromLocalAreaOne() {
    _updateFirestoreFromLocal(boardState.areaOne, _areaOneRef);
  }

  /// Sends the local state of `boardState.areaTwo` to Firestore.
  void _updateFirestoreFromLocalAreaTwo() {
    _updateFirestoreFromLocal(boardState.areaTwo, _areaTwoRef);
  }

  /// Updates the local state of [area] with the data from Firestore.
  void _updateLocalFromFirestore(
    PlayingArea area,
    DocumentSnapshot<List<PlayingCard>> snapshot,
  ) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final cards = snapshot.data() ?? [];

    if (listEquals(cards, area.cards)) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($cards)');
      area.replaceWith(cards);
    }
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
```

Observe os seguintes recursos deste código:

* O construtor do controlador recebe um `BoardState`.
  Isso permite que o controlador manipule o estado local do jogo.

* O controlador se inscreve tanto nas mudanças locais, para atualizar o Firestore,
  quanto nas mudanças remotas, para atualizar o estado local e a UI.

* Os campos `_areaOneRef` e `_areaTwoRef` são
  referências de documentos do Firebase.
  Eles descrevem onde os dados de cada área residem
  e como converter entre os objetos Dart locais (`List<PlayingCard>`)
  e os objetos JSON remotos (`Map<String, dynamic>`).
  A API do Firestore nos permite se inscrever nessas referências
  com `.snapshots()` e escrever nelas com `.set()`.

## 5. Use o controlador Firestore {:#5-use-the-firestore-controller}

1. Abra o arquivo responsável por iniciar a sessão de jogo:
    `lib/play_session/play_session_screen.dart`, no caso do
    template `card`.
    Você instancia o controlador do Firestore a partir desse arquivo.

2. Importe o Firebase e o controlador:

    <?code-excerpt "lib/play_session/play_session_screen.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    
    import '../multiplayer/firestore_controller.dart';
    ```

3. Adicione um campo anulável à classe `_PlaySessionScreenState`
    para conter uma instância do controlador:

    <?code-excerpt "lib/play_session/play_session_screen.dart (controller)"?>
    ```dart
    FirestoreController? _firestoreController;
    ```

4. No método `initState()` da mesma classe,
    adicione código que tenta ler a instância de FirebaseFirestore
    e, se tiver sucesso, constrói o controlador.
    Você adicionou a instância de `FirebaseFirestore` ao `main.dart`
    na etapa *Inicialize o Firestore*.

    <?code-excerpt "lib/play_session/play_session_screen.dart (init-state)"?>
    ```dart
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning(
        "Firestore instance wasn't provided. "
        'Running without _firestoreController.',
      );
    } else {
      _firestoreController = FirestoreController(
        instance: firestore,
        boardState: _boardState,
      );
    }
    ```

5. Descarte o controlador usando o método `dispose()`
    da mesma classe.

    <?code-excerpt "lib/play_session/play_session_screen.dart (dispose)"?>
    ```dart
    _firestoreController?.dispose();
    ```

## 6. Teste o jogo {:#6-test-the-game}

1. Execute o jogo em dois dispositivos separados
    ou em 2 janelas diferentes do mesmo dispositivo.

2. Observe como adicionar uma carta a uma área em um dispositivo
    faz com que ela apareça no outro.

    {% comment %}
      TBA: GIF do multiplayer funcionando
    {% endcomment %}

3. Abra o [console web do Firebase][Firebase web console]
    e navegue até o Firestore Database do seu projeto.

4. Observe como ele atualiza os dados em tempo real.
    Você pode até editar os dados no console
    e ver todos os clientes em execução serem atualizados.

    ![Captura de tela da visualização de dados do Firebase Firestore](/assets/images/docs/cookbook/multiplayer-firebase-data.png)

[Firebase web console]: https://console.firebase.google.com/

### Solução de problemas {:#troubleshooting}

Os problemas mais comuns que você pode encontrar ao testar
a integração com o Firebase incluem os seguintes:

* **O jogo trava ao tentar acessar o Firebase.**
  * A integração com o Firebase não foi configurada corretamente.
    Revisite o *Passo 2* e certifique-se de executar `flutterfire configure`
    como parte dessa etapa.

* **O jogo não se comunica com o Firebase no macOS.**
  * Por padrão, apps macOS não têm acesso à internet.
    Habilite primeiro a [permissão de rede (entitlement)][internet entitlement].

[internet entitlement]: /data-and-backend/networking#macos

## 7. Próximos passos {:#7-next-steps}

Neste ponto, o jogo tem uma sincronização de estado quase instantânea e
confiável entre os clientes.
Falta ele ter regras de jogo reais:
quais cartas podem ser jogadas e quando, e com quais resultados.
Isso depende do próprio jogo e fica a seu cargo experimentar.

![Uma ilustração de dois celulares e uma seta de duas vias entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Neste ponto, o estado compartilhado da partida inclui apenas
as duas áreas de jogo e as cartas dentro delas.
Você também pode salvar outros dados em `_matchRef`,
como quem são os jogadores e de quem é a vez.
Se você não sabe por onde começar,
siga [um ou dois codelabs do Firestore][a Firestore codelab or two]
para se familiarizar com a API.

No início, uma única partida deve bastar
para testar o seu jogo multiplayer com colegas e amigos.
À medida que se aproxima da data de lançamento,
pense em autenticação e em matchmaking.
Felizmente, o Firebase oferece uma
[forma integrada de autenticar usuários][built-in way to authenticate users],
e a estrutura do banco de dados do Firestore pode lidar com várias partidas.
Em vez de um único `match_1`,
você pode preencher a coleção de partidas com quantos registros forem necessários.

![Captura de tela da visualização de dados do Firebase Firestore com partidas adicionais](/assets/images/docs/cookbook/multiplayer-firebase-match.png)

Uma partida online pode começar em um estado de "espera",
com apenas o primeiro jogador presente.
Outros jogadores podem ver as partidas em "espera" em algum tipo de lobby.
Quando jogadores suficientes entram em uma partida, ela passa a ficar "ativa".
Mais uma vez, a implementação exata depende
do tipo de experiência online que você quer.
Os fundamentos continuam os mesmos:
uma grande coleção de documentos,
cada um representando uma partida ativa ou potencial.

[a Firestore codelab or two]: {{site.codelabs}}/?product=flutter&text=firestore
[built-in way to authenticate users]: {{site.firebase}}/docs/auth/flutter/start
