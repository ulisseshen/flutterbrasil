---
title: Use uma fonte personalizada
description: Como usar fontes personalizadas.
ia-translate: true
---

<?code-excerpt path-base="cookbook/design/fonts/"?>

:::secondary O que você aprenderá
* Como escolher uma fonte.
* Como importar arquivos de fonte.
* Como definir uma fonte como padrão.
* Como usar uma fonte em um determinado widget.
:::

Embora Android e iOS ofereçam fontes de sistema de alta qualidade,
os designers querem suporte para fontes personalizadas.
Você pode ter uma fonte personalizada de um designer,
ou talvez tenha baixado uma fonte do [Google Fonts][].

Um typeface é a coleção de glifos ou formas que compreendem
um determinado estilo de letras.
Uma font é uma representação desse typeface em um determinado peso ou variação.
Roboto é um typeface e Roboto Bold é uma font.

O Flutter permite que você aplique uma fonte personalizada em todo um aplicativo ou em widgets individuais.
Esta receita cria um aplicativo que usa fontes personalizadas com os seguintes passos.

1. Escolha suas fontes.
1. Importe os arquivos de fonte.
1. Declare a fonte no pubspec.
1. Defina uma fonte como padrão.
1. Use uma fonte em um widget específico.

Você não precisa seguir cada passo enquanto avança.
O guia oferece arquivos de exemplo completos no final.

:::note
Este guia faz as seguintes pressuposições:

1. Você [configurou seu ambiente Flutter][set up your Flutter environment].
1. Você [criou um novo aplicativo Flutter][new-flutter-app] chamado `custom_fonts`.
   Se você ainda não concluiu essas etapas, faça isso antes de continuar
   com este guia.
1. Você está executando os comandos fornecidos em um shell macOS ou Linux
   e usando `vi`. Você pode substituir qualquer editor de texto por `vi`.
   Usuários do Windows devem usar os comandos e caminhos apropriados ao
   executar as etapas.
1. Você está adicionando as fontes Raleway e RobotoMono ao seu aplicativo Flutter.
:::

[set up your Flutter environment]: /get-started/install
[new-flutter-app]: /get-started/test-drive

## Escolher uma fonte

Sua escolha de fonte deve ser mais do que uma preferência.
Considere quais formatos de arquivo funcionam com o Flutter e
como a fonte pode afetar as opções de design e o desempenho do aplicativo.

#### Escolha um formato de fonte suportado

O Flutter suporta os seguintes formatos de fonte:

* Coleções de fontes OpenType: `.ttc`
* Fontes TrueType: `.ttf`
* Fontes OpenType: `.otf`

O Flutter não suporta fontes no Web Open Font Format,
`.woff` e `.woff2`, em plataformas desktop.

#### Escolha fontes por seus benefícios específicos

Poucas fontes concordam sobre o que é um tipo de arquivo de fonte ou qual usa menos espaço.
A principal diferença entre tipos de arquivo de fonte envolve como o formato
codifica os glifos no arquivo.
A maioria dos arquivos de fonte TrueType e OpenType têm capacidades semelhantes, pois
pegaram emprestados uns dos outros à medida que os formatos e fontes melhoraram ao longo do tempo.

Qual fonte você deve usar depende das seguintes considerações.

* Quanta variação você precisa para fontes em seu aplicativo?
* Quanto tamanho de arquivo você pode aceitar que as fontes usem em seu aplicativo?
* Quantos idiomas você precisa suportar em seu aplicativo?

Pesquise quais opções uma determinada fonte oferece,
como mais de um peso ou estilo por arquivo de fonte,
[capacidade de fonte variável][variable-fonts],
a disponibilidade de vários arquivos de fonte para vários pesos de fonte,
ou mais de uma largura por fonte.

Escolha o typeface ou família de fontes que atende às necessidades de design do seu aplicativo.

:::secondary
Para saber como obter acesso direto a mais de 1.000 famílias de fontes de código aberto,
confira o pacote [google_fonts][].

{% ytEmbed '8Vzv2CdbEY0', 'google_fonts | Flutter package of the week' %}

Para aprender sobre outra abordagem para usar fontes personalizadas que permite
reutilizar uma fonte em vários projetos,
confira [Exportar fontes de um pacote][Export fonts from a package].
:::

## Importar os arquivos de fonte

Para trabalhar com uma fonte, importe seus arquivos de fonte para seu projeto Flutter.

Para importar arquivos de fonte, execute as seguintes etapas.

1. Se necessário, para corresponder às etapas restantes neste guia,
   altere o nome do seu aplicativo Flutter para `custom_fonts`.

   ```console
   $ mv /path/to/my_app /path/to/custom_fonts
   ```

1. Navegue até a raiz do seu projeto Flutter.

   ```console
   $ cd /path/to/custom_fonts
   ```

1. Crie um diretório `fonts` na raiz do seu projeto Flutter.

   ```console
   $ mkdir fonts
   ```

1. Mova ou copie os arquivos de fonte em uma pasta `fonts` ou `assets`
   na raiz do seu projeto Flutter.

   ```console
   $ cp ~/Downloads/*.ttf ./fonts
   ```

A estrutura de pastas resultante deve se parecer com o seguinte:

```plaintext
custom_fonts/
|- fonts/
  |- Raleway-Regular.ttf
  |- Raleway-Italic.ttf
  |- RobotoMono-Regular.ttf
  |- RobotoMono-Bold.ttf
```

## Declarar a fonte no arquivo pubspec.yaml

Depois de baixar uma fonte,
inclua uma definição de fonte no arquivo `pubspec.yaml`.
Esta definição de fonte também especifica qual arquivo de fonte deve ser usado para
renderizar um determinado peso ou estilo em seu aplicativo.

### Definir fontes no arquivo `pubspec.yaml`

Para adicionar arquivos de fonte ao seu aplicativo Flutter, complete as seguintes etapas.

1. Abra o arquivo `pubspec.yaml` na raiz do seu projeto Flutter.

   ```console
   $ vi pubspec.yaml
   ```

1. Cole o seguinte bloco YAML após a declaração `flutter`.

   ```yaml
     fonts:
       - family: Raleway
         fonts:
           - asset: fonts/Raleway-Regular.ttf
           - asset: fonts/Raleway-Italic.ttf
             style: italic
       - family: RobotoMono
         fonts:
           - asset: fonts/RobotoMono-Regular.ttf
           - asset: fonts/RobotoMono-Bold.ttf
             weight: 700
   ```

Este arquivo `pubspec.yaml` define o estilo itálico para a
família de fontes `Raleway` como o arquivo de fonte `Raleway-Italic.ttf`.
Quando você define `style: TextStyle(fontStyle: FontStyle.italic)`,
o Flutter troca `Raleway-Regular` por `Raleway-Italic`.

O valor `family` define o nome do typeface.
Você usa esse nome na propriedade [`fontFamily`][] de um objeto [`TextStyle`][].

O valor de um `asset` é um caminho relativo do arquivo `pubspec.yaml`
para o arquivo de fonte.
Esses arquivos contêm os contornos para os glifos na fonte.
Ao construir o aplicativo,
o Flutter inclui esses arquivos no pacote de assets do aplicativo.

### Incluir arquivos de fonte para cada fonte

Diferentes typefaces implementam arquivos de fonte de maneiras diferentes.
Se você precisar de um typeface com uma variedade de pesos e estilos de fonte,
escolha e importe arquivos de fonte que representem essa variedade.

Quando você importa um arquivo de fonte que não inclui várias fontes
dentro dele ou capacidades de fonte variável,
não use a propriedade `style` ou `weight` para ajustar como elas são exibidas.
Se você usar essas propriedades em um arquivo de fonte regular,
o Flutter tenta _simular_ a aparência.
O resultado visual parecerá bem diferente de usar o arquivo de fonte correto.

### Definir estilos e pesos com arquivos de fonte

Quando você declara quais arquivos de fonte representam estilos ou pesos de uma fonte,
você pode aplicar as propriedades `style` ou `weight`.

#### Definir peso da fonte

A propriedade `weight` especifica o peso dos contornos no
arquivo como um múltiplo inteiro de 100, entre 100 e 900.
Esses valores correspondem ao [`FontWeight`][] e podem ser usados na
propriedade [`fontWeight`][fontWeight property] de um objeto [`TextStyle`][].

No `pubspec.yaml` mostrado neste guia,
você definiu `RobotoMono-Bold` como o peso `700` da família de fontes.
Para usar a fonte `RobotoMono-Bold` que você adicionou ao seu aplicativo,
defina `fontWeight` como `FontWeight.w700` em seu widget `TextStyle`.

Se você não tivesse adicionado `RobotoMono-Bold` ao seu aplicativo,
o Flutter tenta fazer a fonte parecer negrito.
O texto então pode parecer um pouco mais escuro.

Você não pode usar a propriedade `weight` para substituir o peso da fonte.
Você não pode definir `RobotoMono-Bold` para nenhum outro peso além de `700`.
Se você definir `TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.w900)`,
a fonte exibida ainda renderizaria tão negrito quanto `RobotoMono-Bold` parece.

#### Definir estilo da fonte

A propriedade `style` especifica se os glifos no arquivo de fonte são exibidos como
`italic` ou `normal`.
Esses valores correspondem ao [`FontStyle`][].
Você pode usar esses estilos na propriedade [`fontStyle`][fontStyle property]
de um objeto [`TextStyle`][].

No `pubspec.yaml` mostrado neste guia,
você definiu `Raleway-Italic` como estando no estilo `italic`.
Para usar a fonte `Raleway-Italic` que você adicionou ao seu aplicativo,
defina `style: TextStyle(fontStyle: FontStyle.italic)`.
O Flutter troca `Raleway-Regular` por `Raleway-Italic` ao renderizar.

Se você não tivesse adicionado `Raleway-Italic` ao seu aplicativo,
o Flutter tenta fazer a fonte _parecer_ itálica.
O texto então pode parecer estar inclinado para a direita.

Você não pode usar a propriedade `style` para substituir os glifos de uma fonte.
Se você definir `TextStyle(fontFamily: 'Raleway', fontStyle: FontStyle.normal)`,
a fonte exibida ainda renderizaria como itálica.
O estilo `regular` de uma fonte itálica _é_ itálico.

## Definir uma fonte como padrão

Para aplicar uma fonte ao texto, você pode definir a fonte como a fonte padrão do aplicativo
em seu `theme`.

Para definir uma fonte padrão, defina a propriedade `fontFamily` no `theme` do aplicativo.
Corresponda o valor de `fontFamily` ao nome `family` declarado no
arquivo `pubspec.yaml`.

O resultado se pareceria com o seguinte código.

<?code-excerpt "lib/main.dart (MaterialApp)"?>
```dart
return MaterialApp(
  title: 'Custom Fonts',
  // Set Raleway as the default app font.
  theme: ThemeData(fontFamily: 'Raleway'),
  home: const MyHomePage(),
);
```

Para saber mais sobre temas,
confira a receita [Usando Temas para compartilhar cores e estilos de fonte][Using Themes to share colors and font styles].

## Definir a fonte em um widget específico

Para aplicar a fonte a um widget específico como um widget `Text`,
forneça um [`TextStyle`][] ao widget.

Para este guia,
tente aplicar a fonte `RobotoMono` a um único widget `Text`.
Corresponda o valor de `fontFamily` ao nome `family` declarado no
arquivo `pubspec.yaml`.

O resultado se pareceria com o seguinte código.

<?code-excerpt "lib/main.dart (Text)"?>
```dart
child: Text(
  'Roboto Mono sample',
  style: TextStyle(fontFamily: 'RobotoMono'),
),
```

:::important
Se um objeto [`TextStyle`][] especifica um peso ou estilo sem um
arquivo de fonte correspondente, o mecanismo usa um arquivo genérico para a fonte
e tenta extrapolar contornos para o peso e estilo solicitados.

Evite depender dessa capacidade. Importe o arquivo de fonte adequado em vez disso.
:::

## Experimente o exemplo completo

### Baixar fontes

Baixe os arquivos de fonte Raleway e RobotoMono do [Google Fonts][].

### Atualizar o arquivo `pubspec.yaml`

1. Abra o arquivo `pubspec.yaml` na raiz do seu projeto Flutter.

   ```console
   $ vi pubspec.yaml
   ```

1. Substitua seu conteúdo pelo seguinte YAML.

   ```yaml
   name: custom_fonts
   description: An example of how to use custom fonts with Flutter

   dependencies:
     flutter:
       sdk: flutter

   dev_dependencies:
     flutter_test:
       sdk: flutter

   flutter:
     fonts:
       - family: Raleway
         fonts:
           - asset: fonts/Raleway-Regular.ttf
           - asset: fonts/Raleway-Italic.ttf
             style: italic
       - family: RobotoMono
         fonts:
           - asset: fonts/RobotoMono-Regular.ttf
           - asset: fonts/RobotoMono-Bold.ttf
             weight: 700
     uses-material-design: true
   ```

### Use este arquivo `main.dart`

1. Abra o arquivo `main.dart` no diretório `lib/` do seu projeto Flutter.

   ```console
   $ vi lib/main.dart
   ```

1. Substitua seu conteúdo pelo seguinte código Dart.

   <?code-excerpt "lib/main.dart"?>
   ```dart
   import 'package:flutter/material.dart';

   void main() => runApp(const MyApp());

   class MyApp extends StatelessWidget {
     const MyApp({super.key});

     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         title: 'Custom Fonts',
         // Set Raleway as the default app font.
         theme: ThemeData(fontFamily: 'Raleway'),
         home: const MyHomePage(),
       );
     }
   }

   class MyHomePage extends StatelessWidget {
     const MyHomePage({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         // The AppBar uses the app-default Raleway font.
         appBar: AppBar(title: const Text('Custom Fonts')),
         body: const Center(
           // This Text widget uses the RobotoMono font.
           child: Text(
             'Roboto Mono sample',
             style: TextStyle(fontFamily: 'RobotoMono'),
           ),
         ),
       );
     }
   }
   ```

O aplicativo Flutter resultante deve exibir a seguinte tela.

![Custom Fonts Demo](/assets/images/docs/cookbook/fonts.png){:.site-mobile-screenshot}

[variable-fonts]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts
[Export fonts from a package]: /cookbook/design/package-fonts
[`fontFamily`]: {{site.api}}/flutter/painting/TextStyle/fontFamily.html
[fontStyle property]: {{site.api}}/flutter/painting/TextStyle/fontStyle.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[fontWeight property]: {{site.api}}/flutter/painting/TextStyle/fontWeight.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[Google Fonts]: https://fonts.google.com
[google_fonts]: {{site.pub-pkg}}/google_fonts
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[Using Themes to share colors and font styles]: /cookbook/design/themes
