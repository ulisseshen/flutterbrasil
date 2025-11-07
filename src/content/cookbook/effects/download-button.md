---
title: Criar um botão de download
description: Como implementar um botão de download.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/effects/download_button"?>

Aplicativos estão cheios de botões que executam comportamentos de longa duração.
Por exemplo, um botão pode acionar um download,
que inicia um processo de download, recebe dados ao longo do tempo,
e então fornece acesso ao recurso baixado.
É útil mostrar ao usuário o progresso de um
processo de longa duração, e o próprio botão é um bom lugar
para fornecer este feedback. Nesta receita,
você construirá um botão de download que transiciona através de
múltiplos estados visuais, baseado no status de um download de aplicativo.

A seguinte animação mostra o comportamento do aplicativo:

![O botão de download passa por seus estágios](/assets/images/docs/cookbook/effects/DownloadButton.gif){:.site-mobile-screenshot}

## Definir um novo widget stateless

Seu widget de botão precisa mudar sua aparência ao longo do tempo.
Portanto, você precisa implementar seu botão com um
widget stateless personalizado.

Defina um novo widget stateless chamado `DownloadButton`.

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

## Definir os possíveis estados visuais do botão

A apresentação visual do botão de download é baseada em um
status de download fornecido. Defina os possíveis estados do
download, e então atualize `DownloadButton` para aceitar
um `DownloadStatus` e um `Duration` para quanto tempo o botão
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
    // TODO: We'll add more to this later.
    return const SizedBox();
  }
}
```

:::note
Cada vez que você define um widget personalizado,
você deve decidir se todas as informações relevantes
são fornecidas àquele widget
de seu pai ou se aquele widget orquestra
o comportamento do aplicativo dentro de si mesmo.
Por exemplo, `DownloadButton` poderia receber o
`DownloadStatus` atual de seu pai,
ou o `DownloadButton` poderia orquestrar o
processo de download em si dentro de seu objeto `State`.
Para a maioria dos widgets, a melhor resposta é passar as informações relevantes
para o widget de seu pai,
ao invés de gerenciar o comportamento dentro do widget.
Ao passar todas as informações relevantes,
você garante maior reusabilidade para o widget,
testes mais fáceis, e mudanças mais fáceis no comportamento
do aplicativo no futuro.
:::

## Exibir a forma do botão

O botão de download muda sua forma baseado no status de
download. O botão exibe um retângulo arredondado cinza durante
os estados `notDownloaded` e `downloaded`.
O botão exibe um círculo transparente durante os
estados `fetchingDownload` e `downloading`.

Baseado no `DownloadStatus` atual,
construa um `AnimatedContainer` com uma
`ShapeDecoration` que exibe um retângulo
arredondado ou um círculo.

Considere definir a árvore de widgets da forma em um
widget `Stateless` separado para que o método `build()`
principal permaneça simples, permitindo as adições
que seguem. Ao invés de criar uma função para retornar um widget,
como `Widget _buildSomething() {}`, sempre prefira criar um
`StatelessWidget` ou um `StatefulWidget` que é mais performático. Mais
considerações sobre isso podem ser encontradas na [documentação]({{site.api}}/flutter/widgets/StatelessWidget-class.html)
ou em um vídeo dedicado no canal [YouTube]({{site.yt.watch}}?v=IOyq-eTRhvo) do Flutter.

Por enquanto, o child de `AnimatedContainer` é apenas um `SizedBox` porque voltaremos a ele em outro passo.

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

Você pode se perguntar por que você precisa de um widget `ShapeDecoration`
para um círculo transparente, dado que é invisível.
O propósito do círculo invisível é orquestrar
a animação desejada. O `AnimatedContainer` começa com um retângulo
arredondado. Quando o `DownloadStatus` muda para `fetchingDownload`,
o `AnimatedContainer` precisa animar de um retângulo arredondado
para um círculo, e então desaparecer conforme a animação ocorre.
A única maneira de implementar esta animação é definir tanto
a forma inicial de um retângulo arredondado quanto a
forma final de um círculo. Mas, você não quer que o círculo
final seja visível, então você o torna transparente,
o que causa um desaparecimento animado.

## Exibir o texto do botão

O `DownloadButton` exibe `GET` durante a
fase `notDownloaded`, `OPEN` durante a fase `downloaded`,
e nenhum texto entre elas.

Adicione widgets para exibir texto durante cada fase de download,
e anime a opacidade do texto entre elas. Adicione a árvore de widgets de texto
como um child do `AnimatedContainer` no
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
exibe um spinner radial. Este spinner aparece gradualmente da
fase `notDownloaded` e desaparece gradualmente para
a fase `fetchingDownload`.

Implemente um spinner radial que fica em cima da forma
do botão e aparece e desaparece nos momentos apropriados.

Removemos o construtor do `ButtonShapeWidget` para manter o
foco em seu método build e o widget `Stack` que adicionamos.

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

## Exibir o progresso e um botão de parar enquanto baixa

Após a fase `fetchingDownload` está a fase `downloading`.
Durante a fase `downloading`, o `DownloadButton`
substitui o spinner de progresso radial por uma
barra de progresso radial crescente. O `DownloadButton` também exibe um ícone de botão
de parar para que o usuário possa cancelar um download em progresso.

Adicione uma propriedade de progresso ao widget `DownloadButton`,
e então atualize a exibição de progresso para mudar para uma barra
de progresso radial durante a fase `downloading`.

Em seguida, adicione um ícone de botão de parar no centro da
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

## Adicionar callbacks de toque no botão

O último detalhe que seu `DownloadButton` precisa são os
comportamentos do botão. O botão deve fazer coisas quando o usuário toca nele.

Adicione propriedades de widget para callbacks para iniciar um download,
cancelar um download e abrir um download.

Finalmente, envolva a árvore de widgets existente de `DownloadButton`
com um widget `GestureDetector`, e encaminhe o
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
        // do nothing.
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
          /* ButtonShapeWidget and progress indicator */
        ],
      ),
    );
  }
}
```

Parabéns! Você tem um botão que muda sua exibição
dependendo de em qual fase o botão está: não baixado,
buscando download, baixando, e baixado.
Agora, o usuário pode tocar para iniciar um download, tocar para cancelar um
download em progresso, e tocar para abrir um download completo.

## Exemplo interativo

Execute o aplicativo:

* Clique no botão **GET** para iniciar um
  download simulado.
* O botão muda para um indicador de progresso
  para simular um download em progresso.
* Quando o download simulado estiver completo, o
  botão transiciona para **OPEN**, para indicar
  que o aplicativo está pronto para o usuário
  abrir o recurso baixado.

<!-- start dartpad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter download button hands-on example in DartPad" run="true"
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
        content: Text('Open App ${index + 1}'),
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

    // Wait a second to simulate fetch time.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    for (final stop in downloadProgressStops) {
      // Wait a second to simulate varying download speeds.
      await Future<void>.delayed(const Duration(seconds: 1));

      // If the user chose to cancel the download, stop the simulation.
      if (!_isDownloading) {
        return;
      }

      // Update the download progress.
      _progress = stop;
      notifyListeners();
    }

    // Wait a second to simulate a final delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
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
        // do nothing.
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
