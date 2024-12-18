---
ia-translate: true
title: Criar um botão de download
description: Como implementar um botão de download.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/download_button"?>

Aplicativos estão cheios de botões que executam comportamentos de longa duração.
Por exemplo, um botão pode disparar um download,
que inicia um processo de download, recebe dados ao longo do tempo,
e então fornece acesso ao recurso baixado.
É útil mostrar ao usuário o progresso de um
processo de longa duração, e o próprio botão é um bom lugar
para fornecer esse feedback. Nesta receita,
você construirá um botão de download que faz a transição por
vários estados visuais, com base no status de um download de aplicativo.

A animação a seguir mostra o comportamento do aplicativo:

![O botão de download percorre seus estágios](/assets/images/docs/cookbook/effects/DownloadButton.gif){:.site-mobile-screenshot}

## Defina um novo widget sem estado

Seu widget de botão precisa mudar sua aparência ao longo do tempo.
Portanto, você precisa implementar seu botão com um
widget sem estado personalizado.

Defina um novo widget sem estado chamado `DownloadButton`.

<?code-excerpt "lib/stateful_widget.dart (DownloadButton)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO:
    return const SizedBox();
  }
}
```

## Defina os possíveis estados visuais do botão

A apresentação visual do botão de download é baseada em um
status de download fornecido. Defina os possíveis estados de
download e, em seguida, atualize `DownloadButton` para aceitar
um `DownloadStatus` e uma `Duration` por quanto tempo o botão
deve levar para animar de um status para outro.

<?code-excerpt "lib/visual_states.dart (VisualStates)"?>
```dart
enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.transitionDuration = const Duration(
      milliseconds: 500,
    ),
  });

  final DownloadStatus status;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    // TODO: Adicionaremos mais a isso mais tarde.
    return const SizedBox();
  }
}
```

:::note
Toda vez que você define um widget personalizado,
você deve decidir se todas as informações relevantes
são fornecidas a esse widget
de seu pai ou se esse widget orquestra
o comportamento do aplicativo dentro de si mesmo.
Por exemplo, `DownloadButton` poderia receber o
`DownloadStatus` atual de seu pai,
ou o `DownloadButton` poderia orquestrar o
processo de download em si dentro de seu objeto `State`.
Para a maioria dos widgets, a melhor resposta é passar as
informações relevantes para o widget de seu pai,
em vez de gerenciar o comportamento dentro do widget.
Ao passar todas as informações relevantes,
você garante maior reutilização para o widget,
testes mais fáceis e mudanças mais fáceis no comportamento do aplicativo
no futuro.
:::

## Exibir o formato do botão

O botão de download muda seu formato com base no download
status. O botão exibe um retângulo arredondado cinza durante
os estados `notDownloaded` e `downloaded`.
O botão exibe um círculo transparente durante
os estados `fetchingDownload` e `downloading`.

Com base no `DownloadStatus` atual,
construa um `AnimatedContainer` com um
`ShapeDecoration` que exibe um arredondado
retângulo ou um círculo.

Considere definir a árvore de widget do formato em um separado
widget `Stateless` para que o método `build()` principal
permaneça simples, permitindo as adições
que seguem. Em vez de criar uma função para retornar um widget,
como `Widget _buildSomething() {}`, sempre prefira criar um
`StatelessWidget` ou um `StatefulWidget` que seja mais performático. Mais
considerações sobre isso podem ser encontradas na [documentação]({{site.api}}/flutter/widgets/StatelessWidget-class.html)
ou em um vídeo dedicado no [canal do YouTube](https://www.youtube.com/watch?v=IOyq-eTRhvo){{site.yt.watch}}.

Por enquanto, o filho `AnimatedContainer` é apenas um `SizedBox` porque voltaremos a ele em outra etapa.

<?code-excerpt "lib/display.dart (Display)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.transitionDuration = const Duration(
      milliseconds: 500,
    ),
  });

  final DownloadStatus status;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  @override
  Widget build(BuildContext context) {
    return ButtonShapeWidget(
      transitionDuration: transitionDuration,
      isDownloaded: _isDownloaded,
      isDownloading: _isDownloading,
      isFetching: _isFetching,
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if (isDownloading || isFetching) {
      shape = const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: const SizedBox(),
    );
  }
}
```

Você pode se perguntar por que precisa de um widget `ShapeDecoration`
para um círculo transparente, dado que é invisível.
O propósito do círculo invisível é orquestrar
a animação desejada. O `AnimatedContainer` começa com um arredondado
retângulo. Quando o `DownloadStatus` muda para `fetchingDownload`,
o `AnimatedContainer` precisa animar de um retângulo arredondado
para um círculo e, em seguida, desaparecer à medida que a animação ocorre.
A única maneira de implementar essa animação é definir ambos
o formato inicial de um retângulo arredondado e o
formato final de um círculo. Mas, você não quer o final
círculo a ser visível, então você o torna transparente,
o que causa um fade-out animado.

## Exibir o texto do botão

O `DownloadButton` exibe `GET` durante o
fase `notDownloaded`, `OPEN` durante o `downloaded`
fase, e nenhum texto no meio.

Adicione widgets para exibir texto durante cada fase de download,
e anime a opacidade do texto no meio. Adicione o texto
árvore de widget como filho do `AnimatedContainer` no
widget wrapper do botão.

<?code-excerpt "lib/display_text.dart (DisplayText)"?>
```dart
@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if (isDownloading || isFetching) {
      shape = const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}
```

## Exibir um spinner enquanto busca o download

Durante a fase `fetchingDownload`, o `DownloadButton`
exibe um spinner radial. Este spinner aparece de
a fase `notDownloaded` e desaparece para
a fase `fetchingDownload`.

Implemente um spinner radial que fica em cima do botão
formato e aparece e desaparece nos momentos apropriados.

Removemos o construtor do `ButtonShapeWidget` para manter o
foco em seu método de construção e no widget `Stack` que adicionamos.

<?code-excerpt "lib/spinner.dart (Spinner)"?>
```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: _onPressed,
    child: Stack(
      children: [
        ButtonShapeWidget(
          transitionDuration: transitionDuration,
          isDownloaded: _isDownloaded,
          isDownloading: _isDownloading,
          isFetching: _isFetching,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
            curve: Curves.ease,
            child: ProgressIndicatorWidget(
              downloadProgress: downloadProgress,
              isDownloading: _isDownloading,
              isFetching: _isFetching,
            ),
          ),
        ),
      ],
    ),
  );
}
```

## Exibir o progresso e um botão de parada durante o download

Depois da fase `fetchingDownload` está a fase `downloading`.
Durante a fase `downloading`, o `DownloadButton`
substitui o spinner de progresso radial por um crescente
barra de progresso radial. O `DownloadButton` também exibe um botão de parada
ícone para que o usuário possa cancelar um download em andamento.

Adicione uma propriedade de progresso ao widget `DownloadButton`,
e então atualize a exibição do progresso para mudar para um radial
barra de progresso durante a fase `downloading`.

Em seguida, adicione um ícone de botão de parada no centro do
barra de progresso radial.

<?code-excerpt "lib/stop.dart (StopIcon)"?>
```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: _onPressed,
    child: Stack(
      children: [
        ButtonShapeWidget(
          transitionDuration: transitionDuration,
          isDownloaded: _isDownloaded,
          isDownloading: _isDownloading,
          isFetching: _isFetching,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
            curve: Curves.ease,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ProgressIndicatorWidget(
                  downloadProgress: downloadProgress,
                  isDownloading: _isDownloading,
                  isFetching: _isFetching,
                ),
                if (_isDownloading)
                  const Icon(
                    Icons.stop,
                    size: 14.0,
                    color: CupertinoColors.activeBlue,
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
```

## Adicionar callbacks de toque de botão

O último detalhe que seu `DownloadButton` precisa é o
comportamento do botão. O botão deve fazer coisas quando o usuário o toca.

Adicione propriedades de widget para callbacks para iniciar um download,
cancelar um download e abrir um download.

Finalmente, envolva a árvore de widget existente do `DownloadButton`
com um widget `GestureDetector` e encaminhe o
evento de toque para a propriedade de callback correspondente.

<?code-excerpt "lib/button_taps.dart (TapCallbacks)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // não faça nada.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: const Stack(
        children: [
          /* ButtonShapeWidget e indicador de progresso */
        ],
      ),
    );
  }
}
```

Parabéns! Você tem um botão que muda sua exibição
dependendo de qual fase o botão está: não baixado,
buscando download, baixando e baixado.
Agora, o usuário pode tocar para iniciar um download, tocar para cancelar um
download em andamento e tocar para abrir um download concluído.

## Exemplo interativo

Execute o aplicativo:

* Clique no botão **GET** para iniciar um
  download simulado.
* O botão muda para um indicador de progresso
  para simular um download em andamento.
* Quando o download simulado é concluído, o
  botão faz a transição para **OPEN**, para indicar
  que o aplicativo está pronto para o usuário
  abrir o recurso baixado.

<!-- start dartpad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de botão de download do Flutter no DartPad" run="true"
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleCupertinoDownloadButton(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({super.key});

  @override
  State<ExampleCupertinoDownloadButton> createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState
    extends State<ExampleCupertinoDownloadButton> {
  late final List<DownloadController> _downloadControllers;

  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(onOpenDownload: () {
        _openDownload(index);
      }),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrir App ${index + 1}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apps')),
      body: ListView.separated(
        itemCount: _downloadControllers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final downloadController = _downloadControllers[index];

    return ListTile(
      leading: const DemoAppIcon(),
      title: Text(
        'App ${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge,
      ),
      subtitle: Text(
        'Lorem ipsum dolor #${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 96,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: downloadController.downloadStatus,
              downloadProgress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class DemoAppIcon extends StatelessWidget {
  const DemoAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SizedBox(
          width: 80,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Icon(
                Icons.ac_unit,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // Espere um segundo para simular o tempo de busca.
    await Future<void>.delayed(const Duration(seconds: 1));

    // Se o usuário optou por cancelar o download, pare a simulação.
    if (!_isDownloading) {
      return;
    }

    // Mude para a fase de download.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    for (final stop in downloadProgressStops) {
      // Espere um segundo para simular diferentes velocidades de download.
      await Future<void>.delayed(const Duration(seconds: 1));

      // Se o usuário optou por cancelar o download, pare a simulação.
      if (!_isDownloading) {
        return;
      }

      // Atualize o progresso do download.
      _progress = stop;
      notifyListeners();
    }

    // Espere um segundo para simular um atraso final.
    await Future<void>.delayed(const Duration(seconds: 1));

    // Se o usuário optou por cancelar o download, pare a simulação.
    if (!_isDownloading) {
      return;
    }

    // Mude para o estado baixado, concluindo a simulação.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // não faça nada.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if (isDownloading || isFetching) {
      shape = const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.transparent,
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
```
