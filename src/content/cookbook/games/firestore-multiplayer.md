---
title: Adicionar suporte multiplayer usando Firestore
description: >
  Como usar o Firebase Cloud Firestore para implementar multiplayer
  no seu game.
ia-translate: true
---

<?code-excerpt path-base="cookbook/games/firestore_multiplayer"?>

Games multiplayer precisam de uma maneira de sincronizar estados de jogo entre jogadores.
De modo geral, existem dois tipos de games multiplayer:

1. **Alta taxa de sincronização**.
   Esses games precisam sincronizar estados de jogo muitas vezes por segundo
   com baixa latência.
   Esses incluem games de ação, games de esporte, games de luta.

2. **Baixa taxa de sincronização**.
   Esses games só precisam sincronizar estados de jogo ocasionalmente
   com a latência tendo menos impacto.
   Esses incluem games de cartas, games de estratégia, games de quebra-cabeça.

Isso se assemelha à diferenciação entre games em tempo real versus baseados em turnos,
embora a analogia seja limitada.
Por exemplo, games de estratégia em tempo real funcionam — como o nome sugere — em
tempo real, mas isso não se correlaciona com uma alta taxa de sincronização.
Esses games podem simular muito do que acontece
entre interações do jogador em máquinas locais.
Portanto, eles não precisam sincronizar estados de jogo com tanta frequência.

![Uma ilustração de dois telefones celulares e uma seta bidirecional entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Se você pode escolher baixas taxas de sincronização como desenvolvedor, você deve.
Uma baixa taxa de sincronização reduz os requisitos de latência e os custos do servidor.
Às vezes, um game requer altas taxas de sincronização.
Para esses casos, soluções como Firestore *não são uma boa escolha*.
Escolha uma solução de servidor multiplayer dedicada como [Nakama][].
Nakama tem um [pacote Dart][].

Se você espera que seu game requer uma baixa taxa de sincronização,
continue lendo.

Esta receita demonstra como usar o
[pacote `cloud_firestore`][]
para implementar capacidades multiplayer no seu game.
Esta receita não requer um servidor.
Ela usa dois ou mais clientes compartilhando estado de jogo usando Cloud Firestore.

[pacote `cloud_firestore`]: {{site.pub-pkg}}/cloud_firestore
[pacote Dart]: {{site.pub-pkg}}/nakama
[Nakama]: https://heroiclabs.com/nakama/

## 1. Preparar seu game para multiplayer

Escreva o código do seu game para permitir alterar o estado do jogo
em resposta a eventos locais e eventos remotos.
Um evento local pode ser uma ação do jogador ou alguma lógica do game.
Um evento remoto pode ser uma atualização de mundo vinda do servidor.

![Screenshot do game de cartas](/assets/images/docs/cookbook/multiplayer-card-game.jpg){:.site-mobile-screenshot .site-illustration}

Para simplificar esta receita do cookbook, comece com
o template [`card`][] que você encontrará
no [repositório `flutter/games`][].
Execute o seguinte comando para clonar esse repositório:

```console
git clone https://github.com/flutter/games.git
```

{% comment %}
  If/when we have a "sample_extractor" tool, or any other easier way
  to get the code, mention that here.
{% endcomment %}

Abra o projeto em `templates/card`.

:::note
Você pode ignorar este passo e seguir a receita com seu próprio projeto
de game. Adapte o código nos lugares apropriados.
:::

[`card`]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[repositório `flutter/games`]: {{site.github}}/flutter/games

## 2. Instalar o Firestore

[Cloud Firestore][] é um banco de dados de documentos NoSQL
com escala horizontal na nuvem.
Ele inclui sincronização ao vivo integrada.
Isso é perfeito para nossas necessidades.
Ele mantém o estado do jogo atualizado no banco de dados na nuvem,
então todo jogador vê o mesmo estado.

Se você quiser uma introdução rápida de 15 minutos sobre Cloud Firestore,
confira o seguinte vídeo:

{% ytEmbed 'v_hR4K4auoQ', 'What is a NoSQL Database? Learn about Cloud Firestore' %}

Para adicionar Firestore ao seu projeto Flutter,
siga os dois primeiros passos do
guia [Get started with Cloud Firestore][]:

* [Create a Cloud Firestore database][]
* [Set up your development environment][]

Os resultados desejados incluem:

* Um banco de dados Firestore pronto na nuvem, em **Test mode**
* Um arquivo `firebase_options.dart` gerado
* Os plugins apropriados adicionados ao seu `pubspec.yaml`

Você *não* precisa escrever nenhum código Dart neste passo.
Assim que você entender o passo de escrever
código Dart nesse guia, retorne a esta receita.

{% comment %}
  Revisit to see if we can inline the steps here:
  <https://firebase.google.com/docs/flutter/setup>
  ... followed by the first 2 steps here:
  <https://firebase.google.com/docs/firestore/quickstart>
{% endcomment %}

[Cloud Firestore]: https://cloud.google.com/firestore/
[Create a Cloud Firestore database]: {{site.firebase}}/docs/firestore/quickstart#create
[Get started with Cloud Firestore]: {{site.firebase}}/docs/firestore/quickstart
[Set up your development environment]: {{site.firebase}}/docs/firestore/quickstart#set_up_your_development_environment

## 3. Inicializar o Firestore

1. Abra `lib/main.dart` e importe os plugins,
    bem como o arquivo `firebase_options.dart`
    que foi gerado por `flutterfire configure` no passo anterior.

    <?code-excerpt "lib/main.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_core/firebase_core.dart';
    
    import 'firebase_options.dart';
    ```

2. Adicione o seguinte código logo acima da chamada para `runApp()`
    em `lib/main.dart`:

    <?code-excerpt "lib/main.dart (initializeApp)"?>
    ```dart
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

    Isso garante que o Firebase seja inicializado no início do game.

3. Adicione a instância do Firestore ao app.
    Dessa forma, qualquer widget pode acessar essa instância.
    Widgets também podem reagir à instância ausente, se necessário.

    Para fazer isso com o template `card`, você pode usar
    o pacote `provider`
    (que já está instalado como uma dependência).

    Substitua o boilerplate `runApp(MyApp())` com o seguinte:

    <?code-excerpt "lib/main.dart (runApp)"?>
    ```dart
    runApp(
      Provider.value(
        value: FirebaseFirestore.instance,
        child: MyApp(),
      ),
    );
    ```

    Coloque o provider acima de `MyApp`, não dentro dele.
    Isso permite que você teste o app sem Firebase.

    :::note
    Caso você *não* esteja trabalhando com o template `card`,
    você deve [instalar o pacote `provider`][]
    ou usar seu próprio método de acessar a instância `FirebaseFirestore`
    de várias partes do seu código.
    :::

[instalar o pacote `provider`]: {{site.pub-pkg}}/provider/install

## 4. Criar uma classe controller do Firestore

Embora você possa falar com o Firestore diretamente,
você deve escrever uma classe controller dedicada
para tornar o código mais legível e manutenível.

Como você implementa o controller depende do seu game
e do design exato da sua experiência multiplayer.
Para o caso do template `card`,
você pode sincronizar o conteúdo das duas áreas de jogo circulares.
Não é suficiente para uma experiência multiplayer completa,
mas é um bom começo.

![Screenshot do game de cartas, com setas apontando para áreas de jogo](/assets/images/docs/cookbook/multiplayer-areas.jpg){:.site-mobile-screenshot .site-illustration}

Para criar um controller, copie,
em seguida, cole o seguinte código em um novo arquivo chamado
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
  late final _matchRef = instance.collection('matches').doc('match_1');

  late final _areaOneRef = _matchRef
      .collection('areas')
      .doc('area_one')
      .withConverter<List<PlayingCard>>(
          fromFirestore: _cardsFromFirestore, toFirestore: _cardsToFirestore);

  late final _areaTwoRef = _matchRef
      .collection('areas')
      .doc('area_two')
      .withConverter<List<PlayingCard>>(
          fromFirestore: _cardsFromFirestore, toFirestore: _cardsToFirestore);

  StreamSubscription? _areaOneFirestoreSubscription;
  StreamSubscription? _areaTwoFirestoreSubscription;

  StreamSubscription? _areaOneLocalSubscription;
  StreamSubscription? _areaTwoLocalSubscription;

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
    _areaOneFirestoreSubscription?.cancel();
    _areaTwoFirestoreSubscription?.cancel();
    _areaOneLocalSubscription?.cancel();
    _areaTwoLocalSubscription?.cancel();

    _log.fine('Disposed');
  }

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a list of [PlayingCard]s.
  List<PlayingCard> _cardsFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?['cards'] as List?;

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      return [];
    }

    final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => PlayingCard.fromJson(raw)).toList();
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
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
      PlayingArea area, DocumentReference<List<PlayingCard>> ref) async {
    try {
      _log.fine('Updating Firestore with local data (${area.cards}) ...');
      await ref.set(area.cards);
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to update Firestore with local data (${area.cards}): $e');
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
      PlayingArea area, DocumentSnapshot<List<PlayingCard>> snapshot) {
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

* O construtor do controller recebe um `BoardState`.
  Isso permite que o controller manipule o estado local do game.

* O controller se inscreve tanto em mudanças locais para atualizar o Firestore
  quanto em mudanças remotas para atualizar o estado local e a UI.

* Os campos `_areaOneRef` e `_areaTwoRef` são
  referências de documentos do Firebase.
  Eles descrevem onde os dados de cada área residem,
  e como converter entre os objetos Dart locais (`List<PlayingCard>`)
  e objetos JSON remotos (`Map<String, dynamic>`).
  A API do Firestore nos permite nos inscrever nessas referências
  com `.snapshots()`, e escrever nelas com `.set()`.

## 5. Usar o controller do Firestore

1. Abra o arquivo responsável por iniciar a sessão de jogo:
    `lib/play_session/play_session_screen.dart` no caso do
    template `card`.
    Você instancia o controller do Firestore deste arquivo.

2. Importe o Firebase e o controller:

    <?code-excerpt "lib/play_session/play_session_screen.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import '../multiplayer/firestore_controller.dart';
    ```

3. Adicione um campo anulável à classe `_PlaySessionScreenState`
    para conter uma instância do controller:

    <?code-excerpt "lib/play_session/play_session_screen.dart (controller)"?>
    ```dart
    FirestoreController? _firestoreController;
    ```

4. No método `initState()` da mesma classe,
    adicione código que tenta ler a instância do FirebaseFirestore
    e, se bem-sucedido, constrói o controller.
    Você adicionou a instância `FirebaseFirestore` ao `main.dart`
    no passo *Initialize Firestore*.

    <?code-excerpt "lib/play_session/play_session_screen.dart (init-state)"?>
    ```dart
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning("Firestore instance wasn't provided. "
          'Running without _firestoreController.');
    } else {
      _firestoreController = FirestoreController(
        instance: firestore,
        boardState: _boardState,
      );
    }
    ```

5. Descarte o controller usando o método `dispose()`
    da mesma classe.

    <?code-excerpt "lib/play_session/play_session_screen.dart (dispose)"?>
    ```dart
    _firestoreController?.dispose();
    ```

## 6. Testar o game

1. Execute o game em dois dispositivos separados
    ou em 2 janelas diferentes no mesmo dispositivo.

2. Observe como adicionar uma carta a uma área em um dispositivo
    faz ela aparecer no outro.

    {% comment %}
      TBA: GIF of multiplayer working
    {% endcomment %}

3. Abra o [console web do Firebase][]
    e navegue até o Firestore Database do seu projeto.

4. Observe como ele atualiza os dados em tempo real.
    Você pode até editar os dados no console
    e ver todos os clientes em execução se atualizarem.

    ![Screenshot da visualização de dados do Firebase Firestore](/assets/images/docs/cookbook/multiplayer-firebase-data.png)

[console web do Firebase]: https://console.firebase.google.com/

### Resolução de problemas

Os problemas mais comuns que você pode encontrar ao testar
a integração com Firebase incluem o seguinte:

* **O game trava ao tentar acessar o Firebase.**
  * A integração com Firebase não foi configurada corretamente.
    Revisite o *Passo 2* e certifique-se de executar `flutterfire configure`
    como parte desse passo.

* **O game não se comunica com o Firebase no macOS.**
  * Por padrão, apps macOS não têm acesso à internet.
    Habilite [internet entitlement][] primeiro.

[internet entitlement]: /data-and-backend/networking#macos

## 7. Próximos passos

Neste ponto, o game tem sincronização quase instantânea e
confiável de estado entre clientes.
Ele carece de regras de jogo reais:
quais cartas podem ser jogadas quando, e com quais resultados.
Isso depende do game em si e fica para você experimentar.

![Uma ilustração de dois telefones celulares e uma seta bidirecional entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Neste ponto, o estado compartilhado da partida inclui apenas
as duas áreas de jogo e as cartas dentro delas.
Você pode salvar outros dados em `_matchRef` também,
como quem são os jogadores e de quem é a vez.
Se você não tem certeza por onde começar,
siga [um codelab ou dois sobre Firestore][]
para se familiarizar com a API.

No início, uma única partida deve ser suficiente
para testar seu game multiplayer com colegas e amigos.
Conforme você se aproxima da data de lançamento,
pense em autenticação e matchmaking.
Felizmente, o Firebase fornece uma
[maneira integrada de autenticar usuários][]
e a estrutura do banco de dados Firestore pode lidar com múltiplas partidas.
Em vez de um único `match_1`,
você pode popular a coleção matches com quantos registros forem necessários.

![Screenshot da visualização de dados do Firebase Firestore com partidas adicionais](/assets/images/docs/cookbook/multiplayer-firebase-match.png)

Uma partida online pode começar em um estado de "espera",
com apenas o primeiro jogador presente.
Outros jogadores podem ver as partidas de "espera" em algum tipo de lobby.
Uma vez que jogadores suficientes entrem em uma partida, ela se torna "ativa".
Mais uma vez, a implementação exata depende do
tipo de experiência online que você deseja.
O básico permanece o mesmo:
uma grande coleção de documentos,
cada um representando uma partida ativa ou potencial.

[um codelab ou dois sobre Firestore]: {{site.codelabs}}/?product=flutter&text=firestore
[maneira integrada de autenticar usuários]: {{site.firebase}}/docs/auth/flutter/start
