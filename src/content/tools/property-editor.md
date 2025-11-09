---
ia-translate: true
title: Flutter Property Editor
description: Aprenda como usar o Flutter Property Editor para visualizar e modificar as propriedades de seus widgets.
---

:::note
O Flutter Property Editor requer Flutter versão 3.32 ou superior.
:::

## O que é isso?

O Flutter Property Editor é uma poderosa ferramenta de IDE que permite visualizar e modificar
propriedades de widgets diretamente de uma interface visual.

Ele permite que você descubra e modifique rapidamente os argumentos de construtor existentes e
disponíveis de seus widgets, eliminando a necessidade de ir para a definição ou
editar manualmente o código-fonte. Além disso, sua integração com o Flutter
inspector e hot reload permite que você visualize mudanças em tempo real, acelerando
o desenvolvimento e iteração de UI.

![Flutter Property Editor](/assets/images/docs/tools/devtools/property-editor-text-widget.png){:width="500px"}

## Como acessar o Flutter Property Editor

1.  Abra o Flutter Property Editor em sua IDE compatível ([VS Code][VS Code],
    [Android Studio/IntelliJ][Android Studio/IntelliJ]).

2.  Localize uma [invocação de construtor de widget][widget constructor invocation] em seu código Flutter.

3.  Mova seu cursor para qualquer lugar dentro da invocação do construtor do widget.

    Por exemplo, no seguinte método `build`, coloque seu cursor em qualquer lugar
    entre o `T` de `Text` e o parêntese de fechamento `)` após
    `TextOverflow.clip`:

    ```dart
    @override
    Widget build(BuildContext context) {
        return Text(
            'Hello World!',
            overflow: TextOverflow.clip,
        );
    }
    ```

4.  O painel Flutter Property Editor atualiza automaticamente para exibir as
    propriedades do widget na localização do seu cursor.

[VS Code]: /tools/vs-code#property-editor
[Android Studio/IntelliJ]: /tools/android-studio#property-editor
[widget constructor invocation]: /get-started/fundamentals/widgets

### Uso em tempo de execução

#### Integração com o Flutter inspector

O Flutter Property Editor pode ser usado em conjunto com o
[Flutter inspector][Flutter inspector] para inspecionar seus widgets simultaneamente em ambas as ferramentas.

1.  A partir de sua IDE preferida, execute e depure sua aplicação Flutter.
    * [Instruções do VS Code][VS Code instructions]
    * [Instruções do Android Studio/IntelliJ][Android Studio/IntelliJ instructions]

2.  Abra o [Flutter inspector][Flutter inspector] em sua IDE.

Você pode então usar o Flutter inspector para carregar um widget no Flutter Property Editor de duas formas:

1. Selecionando um widget na árvore:
    * Clique em um widget na [árvore de widgets do inspector][inspector's widget tree].

2. Selecionando um widget em seu app:
    * Habilite o ["Select Widget Mode"][Select Widget Mode] no inspector.
    * Clique em um widget em sua aplicação em execução.

Ambas as ações irão automaticamente:
- Ir para a declaração do widget em seu código-fonte.
- Carregar o widget selecionado no Flutter Property Editor.

[VS Code instructions]: /tools/devtools/vscode/#run-and-debug
[Android Studio/IntelliJ instructions]: /tools/devtools/android-studio/#run-and-debug
[Flutter inspector]: /tools/devtools/inspector
[inspector's widget tree]: /tools/devtools/inspector#flutter-widget-tree
[Select Widget Mode]: /tools/devtools/inspector#inspecting-a-widget

#### Integração com hot reload

O Flutter Property Editor pode ser usado em conjunto
com hot reload para visualizar mudanças em tempo real.

1. A partir de sua IDE preferida, habilite autosave e hot reloads ao salvar.

    **VS Code**

    Adicione o seguinte ao seu arquivo `.vscode/settings.json`:

    ```json
    "files.autoSave": "afterDelay",
    "dart.flutterHotReloadOnSave": "all",
    ```

    **Android Studio e IntelliJ**

    * Abra `Settings > Tools > Actions on Save` e selecione
     `Configure autosave options`.
        - Marque a opção para `Save files if the IDE is idle for X seconds`.
        - **Recomendado:** Defina uma duração de delay pequena. Por exemplo, 2 segundos.

    * Abra `Settings > Languages & Frameworks > Flutter`.
        - Marque a opção para `Perform hot reload on save`.

2.  Execute e depure sua aplicação Flutter.
    * [Instruções do VS Code][VS Code instructions]
    * [Instruções do Android Studio/IntelliJ][Android Studio/IntelliJ instructions]

3.  Quaisquer mudanças que você fizer no Flutter Property Editor são automaticamente
    refletidas em seu app em execução.

## Conjunto de recursos

O Flutter Property Editor vem equipado com vários recursos projetados para
acelerar o processo de desenvolvimento.

### Visualizando documentação de widget

Quando um widget é selecionado no Flutter Property Editor, sua documentação é
exibida no topo. Isso permite que você leia rapidamente a documentação do widget,
sem precisar ir para a definição ou pesquisar online.

Por padrão, a documentação do widget é truncada. Clique em "Show more" para
expandir a documentação do widget.

:::tip
Para ver a documentação para widgets customizados de seu app no Flutter Property
Editor, certifique-se de seguir o [guia de estilo Dart][Dart style guide].
:::

![Flutter Property Editor gif displaying the documentation for a Text widget](/assets/images/docs/tools/devtools/property-editor-documentation.gif)

[Dart style guide]: {{site.dart-site}}/effective-dart/documentation

### Editando propriedades de widget

O Flutter Property Editor contém campos de entrada adaptados ao tipo de cada
argumento de construtor.

- **propriedades string, double e int:**
    * Estas são representadas por campos de entrada de texto.
    * Simplesmente digite o novo valor no campo.
    * Pressione ••Tab•• ou ••Enter•• para aplicar a edição diretamente ao seu código-fonte.

- **propriedades boolean e enum:**
    * Estas são representadas por menus dropdown.
    * Clique no dropdown para ver as opções disponíveis (`true`/`false` para
      booleanos, ou os vários valores enum).
    * Selecione o valor desejado da lista para aplicá-lo ao seu código.

- **propriedades de objeto (por exemplo, `TextStyle`, `EdgeInsets`, `Color`):**
    * Atualmente não suportado. O Flutter Property Editor ainda não permite
      edição direta de propriedades de objeto complexo. Você precisará editar estas
      diretamente em seu código-fonte.

### Compreendendo as entradas de propriedade

Cada entrada de propriedade no Flutter Property Editor é acompanhada de informações
para ajudá-lo a entender seu uso.

- **Tipo e nome:** O **tipo** (por exemplo, `StackFit`) e o **nome**
  (por exemplo, `fit`) do parâmetro de construtor são exibidos como um rótulo
  para cada campo de entrada.

    ![Type and name label for a property input](/assets/images/docs/tools/devtools/property-editor-name-type.png){:width="500px"}

- **Tooltip de informação (ⓘ):**
    * Passar o mouse sobre o ícone de informação ao lado de uma entrada de propriedade exibe um tooltip.
    * A informação no tooltip inclui:
        * O valor padrão da propriedade, se um for definido no construtor do widget.
        * Qualquer documentação para essa propriedade.

    ![Info tooltip for a property input](/assets/images/docs/tools/devtools/property-editor-tooltip.png){:width="600px"}

* **Rótulos "Set" e "default":**
    * O rótulo **"set"** aparece ao lado de uma entrada se a propriedade foi
      explicitamente definida em seu código-fonte. Isso significa que há um
      argumento correspondente fornecido na chamada do construtor do widget.
    * O rótulo **"default"** aparece ao lado de uma entrada se o valor atual da propriedade
      corresponde ao valor de parâmetro padrão conforme definido no widget.

    :::tip
    Se uma entrada de propriedade tem tanto um rótulo "set" quanto "default", significa que você
    forneceu explicitamente um valor em seu código, mas este valor é o mesmo que
    o valor padrão do widget para essa propriedade. Nesses casos, você pode remover com segurança
    este argumento de seu código para torná-lo mais conciso, já que o widget
    usará o valor padrão de qualquer forma.
    :::

    !["Set" and "default" labels for a property input](/assets/images/docs/tools/devtools/property-editor-labels.png){:width="500px"}

### Filtrando propriedades

Para widgets com muitas propriedades, a barra de filtro pode ajudar a localizar rapidamente
propriedades de interesse.

* **Filtrar por texto:**
    * Simplesmente digite na barra de filtro. A lista de propriedades será atualizada dinamicamente
      para mostrar apenas aquelas que correspondem à sua entrada.
    * Você pode filtrar pelo nome de uma propriedade, seu valor atual ou seu tipo. Por
      exemplo:
        * Digitar "main" filtraria para `mainAxisAlignment`, `mainAxisSize`, ou
          outras propriedades com "main" em seu nome.
        * Digitar "true" filtraria para todas as propriedades booleanas atualmente definidas como
          `true`.
        * Digitar "double" filtraria para todas as propriedades do tipo `double`.

    ![Filter input with filtering by text highlighted](/assets/images/docs/tools/devtools/property-editor-filter-text.png){:width="500px"}

* **Filtrar por propriedades "set":**
    * Use o botão de menu de filtro para abrir as opções de filtro. Marque "Only
      include properties that are set in the code."
    * Isso oculta todas as propriedades que não foram explicitamente definidas em seu
      código, permitindo que você se concentre apenas nas propriedades que você definiu explicitamente.

    ![Filter input with filter menu button highlighted](/assets/images/docs/tools/devtools/property-editor-filter-menu-button.png){:width="500px"}

* **Filtrar com uma regex:**
    * O toggle de regex (um botão com ícone `*`) permite alternar o modo regex
      para a entrada de filtro.
    * Quando habilitado, seu texto de filtro será interpretado como uma expressão
      regular.

    ![Filter input with regex toggle highlighted](/assets/images/docs/tools/devtools/property-editor-filter-regex-toggle.png){:width="500px"}

* **Limpar o filtro atual:**
    * O botão limpar (um botão com ícone `X`) limpa quaisquer filtros ativos,
      exibindo todas as propriedades do widget novamente.

    ![Filter input with clear button highlighted](/assets/images/docs/tools/devtools/property-editor-filter-clear-button.png){:width="500px"}
