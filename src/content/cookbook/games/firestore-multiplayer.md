---
ia-translate: true
title: Adicionar suporte multiplayer usando Firestore
description: >
  Como usar o Firebase Cloud Firestore para implementar o modo multiplayer
  em seu jogo.
---

<?code-excerpt path-base="cookbook/games/firestore_multiplayer"?>

Jogos multiplayer precisam de uma maneira de sincronizar os estados do jogo entre os jogadores.
De modo geral, existem dois tipos de jogos multiplayer:

1.  **Alta taxa de atualização (tick rate)**.
    Esses jogos precisam sincronizar os estados do jogo várias vezes por segundo
    com baixa latência.
    Isso incluiria jogos de ação, jogos de esportes e jogos de luta.

2.  **Baixa taxa de atualização (tick rate)**.
    Esses jogos só precisam sincronizar os estados do jogo ocasionalmente
    com a latência tendo menos impacto.
    Isso incluiria jogos de cartas, jogos de estratégia e jogos de quebra-cabeça.

Isso se assemelha à diferenciação entre jogos em tempo real e jogos baseados em turnos,
embora a analogia seja incompleta.
Por exemplo, jogos de estratégia em tempo real rodam—como o nome sugere—em tempo real,
mas isso não se correlaciona com uma alta taxa de atualização (tick rate).
Esses jogos podem simular grande parte do que acontece
entre as interações dos jogadores em máquinas locais.
Portanto, eles não precisam sincronizar os estados do jogo com tanta frequência.

![Uma ilustração de dois telefones celulares e uma seta bidirecional entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Se você puder escolher baixas taxas de atualização (tick rate) como desenvolvedor, você deve.
Baixas taxas de atualização reduzem os requisitos de latência e os custos do servidor.
Às vezes, um jogo requer altas taxas de atualização (tick rate) de sincronização.
Para esses casos, soluções como o Firestore *não são uma boa opção*.
Escolha uma solução de servidor multiplayer dedicada como o [Nakama][].
O Nakama tem um [pacote Dart][].

Se você espera que seu jogo exija uma baixa taxa de atualização de sincronização,
continue lendo.

Esta receita demonstra como usar o
[`cloud_firestore` package][]
para implementar recursos multiplayer em seu jogo.
Esta receita não requer um servidor.
Ela usa dois ou mais clientes compartilhando o estado do jogo usando o Cloud Firestore.

[`cloud_firestore` package]: {{site.pub-pkg}}/cloud_firestore
[Dart package]: {{site.pub-pkg}}/nakama
[Nakama]: https://heroiclabs.com/nakama/

## 1. Prepare seu jogo para o modo multiplayer

Escreva o código do seu jogo para permitir a alteração do estado do jogo
em resposta a eventos locais e remotos.
Um evento local pode ser uma ação do jogador ou alguma lógica do jogo.
Um evento remoto pode ser uma atualização do mundo vinda do servidor.

![Captura de tela do jogo de cartas](/assets/images/docs/cookbook/multiplayer-card-game.jpg){:.site-mobile-screenshot .site-illustration}

Para simplificar esta receita do cookbook, comece com
o modelo [`card`][] que você encontrará
no repositório [`flutter/games`][].
Execute o seguinte comando para clonar esse repositório:

```console
git clone https://github.com/flutter/games.git
```

{% comment %}
  Se/quando tivermos uma ferramenta "sample_extractor", ou qualquer outra forma mais fácil
  de obter o código, mencione isso aqui.
{% endcomment %}

Abra o projeto em `templates/card`.

:::note
Você pode ignorar esta etapa e seguir a receita com seu próprio projeto de jogo.
Adapte o código nos locais apropriados.
:::

[`card`]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[`flutter/games` repository]: {{site.github}}/flutter/games

## 2. Instale o Firestore

[Cloud Firestore][] é um banco de dados de documentos NoSQL com escalabilidade horizontal na nuvem.
Ele inclui sincronização ao vivo integrada.
Isso é perfeito para nossas necessidades.
Ele mantém o estado do jogo atualizado no banco de dados na nuvem,
para que cada jogador veja o mesmo estado.

Se você quiser um guia rápido de 15 minutos sobre o Cloud Firestore,
confira o vídeo a seguir:

{% ytEmbed 'v_hR4K4auoQ', 'O que é um banco de dados NoSQL? Aprenda sobre o Cloud Firestore' %}

Para adicionar o Firestore ao seu projeto Flutter,
siga as duas primeiras etapas do guia
[Começar a usar o Cloud Firestore][]:

* [Crie um banco de dados do Cloud Firestore][]
* [Configure seu ambiente de desenvolvimento][]

Os resultados desejados incluem:

* Um banco de dados do Firestore pronto na nuvem, no **Modo de teste**
* Um arquivo `firebase_options.dart` gerado
* Os plugins apropriados adicionados ao seu `pubspec.yaml`

Você *não* precisa escrever nenhum código Dart nesta etapa.
Assim que você entender a etapa de escrever
código Dart nesse guia, volte para esta receita.

{% comment %}
  Revisite para ver se podemos colocar as etapas aqui:
  <https://firebase.google.com/docs/flutter/setup>
  ... seguido pelas 2 primeiras etapas aqui:
  <https://firebase.google.com/docs/firestore/quickstart>
{% endcomment %}

[Cloud Firestore]: https://cloud.google.com/firestore/
[Crie um banco de dados do Cloud Firestore]: {{site.firebase}}/docs/firestore/quickstart#create
[Começar a usar o Cloud Firestore]: {{site.firebase}}/docs/firestore/quickstart
[Configure seu ambiente de desenvolvimento]: {{site.firebase}}/docs/firestore/quickstart#set_up_your_development_environment

## 3. Inicialize o Firestore

1.  Abra `lib/main.dart` e importe os plugins,
    bem como o arquivo `firebase_options.dart`
    que foi gerado por `flutterfire configure` na etapa anterior.

    <?code-excerpt "lib/main.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_core/firebase_core.dart';
    
    import 'firebase_options.dart';
    ```

2.  Adicione o seguinte código logo acima da chamada para `runApp()`
    em `lib/main.dart`:

    <?code-excerpt "lib/main.dart (initializeApp)"?>
    ```dart
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

    Isso garante que o Firebase seja inicializado na inicialização do jogo.

3.  Adicione a instância do Firestore ao aplicativo.
    Dessa forma, qualquer widget pode acessar essa instância.
    Os widgets também podem reagir à falta da instância, se necessário.

    Para fazer isso com o modelo `card`, você pode usar
    o pacote `provider`
    (que já está instalado como uma dependência).

    Substitua o boilerplate `runApp(MyApp())` pelo seguinte:

    <?code-excerpt "lib/main.dart (runApp)"?>
    ```dart
    runApp(
      Provider.value(
        value: FirebaseFirestore.instance,
        child: MyApp(),
      ),
    );
    ```

    Coloque o provedor acima de `MyApp`, não dentro dele.
    Isso permite que você teste o aplicativo sem o Firebase.

    :::note
    Caso você *não* esteja trabalhando com o modelo `card`,
    você deve [instalar o pacote `provider`][]
    ou usar seu próprio método de acesso à instância `FirebaseFirestore`
    de várias partes de sua base de código.
    :::

[instalar o pacote `provider`]: {{site.pub-pkg}}/provider/install

## 4. Crie uma classe de controlador do Firestore

Embora você possa se comunicar diretamente com o Firestore,
você deve escrever uma classe de controlador dedicada
para tornar o código mais legível e sustentável.

Como você implementa o controlador depende do seu jogo
e do design exato da sua experiência multiplayer.
Para o caso do modelo `card`,
você pode sincronizar o conteúdo das duas áreas de jogo circulares.
Não é o suficiente para uma experiência multiplayer completa,
mas é um bom começo.

![Captura de tela do jogo de cartas, com setas apontando para as áreas de jogo](/assets/images/docs/cookbook/multiplayer-areas.jpg){:.site-mobile-screenshot .site-illustration}

Para criar um controlador, copie,
e cole o código a seguir em um novo arquivo chamado
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

  /// Por enquanto, há apenas uma partida. Mas para estar pronto
  /// para a formação de partidas, coloque-o em uma coleção do Firestore chamada matches.
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
    // Inscreva-se nas alterações remotas (do Firestore).
    _areaOneFirestoreSubscription = _areaOneRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaOne, snapshot);
    });
    _areaTwoFirestoreSubscription = _areaTwoRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaTwo, snapshot);
    });

    // Inscreva-se nas alterações locais no estado do jogo.
    _areaOneLocalSubscription = boardState.areaOne.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaOne();
    });
    _areaTwoLocalSubscription = boardState.areaTwo.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaTwo();
    });

    _log.fine('Inicializado');
  }

  void dispose() {
    _areaOneFirestoreSubscription?.cancel();
    _areaTwoFirestoreSubscription?.cancel();
    _areaOneLocalSubscription?.cancel();
    _areaTwoLocalSubscription?.cancel();

    _log.fine('Descartado');
  }

  /// Obtém o snapshot JSON bruto vindo do Firestore e tenta
  /// convertê-lo em uma lista de [PlayingCard]s.
  List<PlayingCard> _cardsFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?['cards'] as List?;

    if (data == null) {
      _log.info('Nenhum dado encontrado no Firestore, retornando lista vazia');
      return [];
    }

    final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => PlayingCard.fromJson(raw)).toList();
    } catch (e) {
      throw FirebaseControllerException(
          'Falha ao analisar dados do Firestore: $e');
    }
  }

  /// Obtém uma lista de [PlayingCard]s e a converte em um objeto JSON
  /// que pode ser salvo no Firestore.
  Map<String, Object?> _cardsToFirestore(
    List<PlayingCard> cards,
    SetOptions? options,
  ) {
    return {'cards': cards.map((c) => c.toJson()).toList()};
  }

  /// Atualiza o Firestore com o estado local da [area].
  Future<void> _updateFirestoreFromLocal(
      PlayingArea area, DocumentReference<List<PlayingCard>> ref) async {
    try {
      _log.fine('Atualizando o Firestore com dados locais (${area.cards}) ...');
      await ref.set(area.cards);
      _log.fine('... atualização concluída.');
    } catch (e) {
      throw FirebaseControllerException(
          'Falha ao atualizar o Firestore com dados locais (${area.cards}): $e');
    }
  }

  /// Envia o estado local de `boardState.areaOne` para o Firestore.
  void _updateFirestoreFromLocalAreaOne() {
    _updateFirestoreFromLocal(boardState.areaOne, _areaOneRef);
  }

  /// Envia o estado local de `boardState.areaTwo` para o Firestore.
  void _updateFirestoreFromLocalAreaTwo() {
    _updateFirestoreFromLocal(boardState.areaTwo, _areaTwoRef);
  }

  /// Atualiza o estado local da [area] com os dados do Firestore.
  void _updateLocalFromFirestore(
      PlayingArea area, DocumentSnapshot<List<PlayingCard>> snapshot) {
    _log.fine('Recebeu novos dados do Firestore (${snapshot.data()})');

    final cards = snapshot.data() ?? [];

    if (listEquals(cards, area.cards)) {
      _log.fine('Nenhuma alteração');
    } else {
      _log.fine('Atualizando dados locais com dados do Firestore ($cards)');
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

* O controlador se inscreve em alterações locais para atualizar o Firestore
  e em alterações remotas para atualizar o estado local e a UI.

* Os campos `_areaOneRef` e `_areaTwoRef` são
  referências de documentos do Firebase.
  Eles descrevem onde os dados de cada área residem,
  e como converter entre os objetos Dart locais (`List<PlayingCard>`)
  e objetos JSON remotos (`Map<String, dynamic>`).
  A API do Firestore nos permite assinar essas referências
  com `.snapshots()`, e escrever nelas com `.set()`.

## 5. Use o controlador do Firestore

1.  Abra o arquivo responsável por iniciar a sessão de jogo:
    `lib/play_session/play_session_screen.dart` no caso do
    modelo `card`.
    Você instancia o controlador do Firestore a partir deste arquivo.

2.  Importe o Firebase e o controlador:

    <?code-excerpt "lib/play_session/play_session_screen.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import '../multiplayer/firestore_controller.dart';
    ```

3.  Adicione um campo anulável à classe `_PlaySessionScreenState`
    para conter uma instância do controlador:

    <?code-excerpt "lib/play_session/play_session_screen.dart (controller)"?>
    ```dart
    FirestoreController? _firestoreController;
    ```

4.  No método `initState()` da mesma classe,
    adicione o código que tenta ler a instância do FirebaseFirestore
    e, se bem-sucedido, constrói o controlador.
    Você adicionou a instância `FirebaseFirestore` em `main.dart`
    na etapa *Inicializar o Firestore*.

    <?code-excerpt "lib/play_session/play_session_screen.dart (init-state)"?>
    ```dart
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning("A instância do Firestore não foi fornecida. "
          'Executando sem _firestoreController.');
    } else {
      _firestoreController = FirestoreController(
        instance: firestore,
        boardState: _boardState,
      );
    }
    ```

5.  Descarte o controlador usando o método `dispose()`
    da mesma classe.

    <?code-excerpt "lib/play_session/play_session_screen.dart (dispose)"?>
    ```dart
    _firestoreController?.dispose();
    ```

## 6. Teste o jogo

1.  Execute o jogo em dois dispositivos separados
    ou em 2 janelas diferentes no mesmo dispositivo.

2.  Observe como adicionar um cartão a uma área em um dispositivo
    faz com que ele apareça no outro.

    {% comment %}
      TBA: GIF do multiplayer funcionando
    {% endcomment %}

3.  Abra o [console da web do Firebase][]
    e navegue até o banco de dados do Firestore do seu projeto.

4.  Observe como ele atualiza os dados em tempo real.
    Você pode até editar os dados no console
    e ver todos os clientes em execução atualizarem.

    ![Captura de tela da visualização de dados do Firebase Firestore](/assets/images/docs/cookbook/multiplayer-firebase-data.png)

[console da web do Firebase]: https://console.firebase.google.com/

### Solução de problemas

Os problemas mais comuns que você pode encontrar ao testar
a integração do Firebase incluem o seguinte:

*   **O jogo trava ao tentar alcançar o Firebase.**
    *   A integração do Firebase não foi configurada corretamente.
        Revisite a *Etapa 2* e certifique-se de executar `flutterfire configure`
        como parte dessa etapa.

*   **O jogo não se comunica com o Firebase no macOS.**
    *   Por padrão, os aplicativos macOS não têm acesso à internet.
        Habilite o [direito de acesso à internet][] primeiro.

[direito de acesso à internet]: /data-and-backend/networking#macos

## 7. Próximos passos

Neste ponto, o jogo tem sincronização de estado quase instantânea e
confiável entre os clientes.
Ele carece de regras de jogo reais:
quais cartas podem ser jogadas quando e com quais resultados.
Isso depende do próprio jogo e fica para você tentar.

![Uma ilustração de dois telefones celulares e uma seta bidirecional entre eles](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

Neste ponto, o estado compartilhado da partida inclui apenas
as duas áreas de jogo e as cartas dentro delas.
Você também pode salvar outros dados em `_matchRef`,
como quem são os jogadores e de quem é a vez.
Se você não tiver certeza de por onde começar,
siga [um ou dois codelabs do Firestore][]
para se familiarizar com a API.

Inicialmente, uma única partida deve ser suficiente
para testar seu jogo multiplayer com colegas e amigos.
À medida que você se aproxima da data de lançamento,
pense na autenticação e na formação de partidas.
Felizmente, o Firebase oferece um
[método integrado para autenticar usuários][]
e a estrutura do banco de dados do Firestore pode lidar com várias partidas.
Em vez de um único `match_1`,
você pode preencher a coleção de partidas com quantos registros forem necessários.

![Captura de tela da visualização de dados do Firebase Firestore com partidas adicionais](/assets/images/docs/cookbook/multiplayer-firebase-match.png)

Uma partida online pode começar em um estado de "espera",
com apenas o primeiro jogador presente.
Outros jogadores podem ver as partidas "em espera" em algum tipo de lobby.
Assim que jogadores suficientes entrarem em uma partida, ela se torna "ativa".
Mais uma vez, a implementação exata depende do
tipo de experiência online que você deseja.
O básico permanece o mesmo:
uma grande coleção de documentos,
cada um representando uma partida ativa ou potencial.

[um ou dois codelabs do Firestore]: {{site.codelabs}}/?product=flutter&text=firestore
[método integrado para autenticar usuários]: {{site.firebase}}/docs/auth/flutter/start
