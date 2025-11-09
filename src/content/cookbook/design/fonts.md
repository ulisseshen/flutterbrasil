---
ia-translate: true
title: Usar uma fonte customizada
description: Como usar fontes customizadas.
---

<?code-excerpt path-base="cookbook/design/fonts/"?>

:::secondary O que você vai aprender
* Como escolher uma fonte.
* Como importar arquivos de fonte.
* Como definir uma fonte como padrão.
* Como usar uma fonte em um widget específico.
:::

Embora Android e iOS ofereçam fontes de sistema de alta qualidade,
designers querem suporte para fontes customizadas.
Você pode ter uma fonte customizada de um designer,
ou talvez você tenha baixado uma fonte do [Google Fonts][].

Um typeface é a coleção de glifos ou formas que compõem
um determinado estilo de letras.
Uma fonte é uma representação desse typeface em um determinado peso ou variação.
Roboto é um typeface e Roboto Bold é uma fonte.

Flutter permite que você aplique uma fonte customizada em todo um app ou em widgets individuais.
Esta receita cria um app que usa fontes customizadas com os seguintes passos.

1. Escolher suas fontes.
1. Importar os arquivos de fonte.
1. Declarar a fonte no pubspec.
1. Definir uma fonte como padrão.
1. Usar uma fonte em um widget específico.

Você não precisa seguir cada passo conforme você avança.
O guia oferece arquivos de exemplo completos no final.

:::note
Este guia faz as seguintes suposições:

1. Você [configurou seu ambiente Flutter][set up your Flutter environment].
1. Você [criou um novo app Flutter][new-flutter-app] chamado `custom_fonts`.
   Se você ainda não completou esses passos, faça isso antes de continuar
   com este guia.
1. Você está executando os comandos fornecidos em um shell macOS ou Linux
   e usando `vi`. Você pode substituir qualquer editor de texto por `vi`.
   Usuários Windows devem usar os comandos e caminhos apropriados ao
   executar os passos.
1. Você está adicionando as fontes Raleway e RobotoMono ao seu app Flutter.
:::

[set up your Flutter environment]: /get-started
[new-flutter-app]: /reference/create-new-app

## Escolher uma fonte

Sua escolha de fonte deve ser mais do que uma preferência.
Considere quais formatos de arquivo funcionam com Flutter e
como a fonte pode afetar as opções de design e o desempenho do app.

#### Escolher um formato de fonte suportado

Flutter suporta os seguintes formatos de fonte:

* Coleções de fontes OpenType: `.ttc`
* Fontes TrueType: `.ttf`
* Fontes OpenType: `.otf`

Flutter não suporta fontes no Web Open Font Format,
`.woff` e `.woff2`, em plataformas desktop.

#### Escolher fontes por seus benefícios específicos

Poucas fontes concordam sobre o que é um tipo de arquivo de fonte ou qual usa menos espaço.
A diferença chave entre tipos de arquivo de fonte envolve como o formato
codifica os glifos no arquivo.
A maioria dos arquivos de fonte TrueType e OpenType têm capacidades similares pois
pegaram emprestado uns dos outros conforme os formatos e fontes melhoraram ao longo do tempo.

Qual fonte você deve usar depende das seguintes considerações.

* Quanta variação você precisa para fontes no seu app?
* Quanto tamanho de arquivo você pode aceitar fontes usando no seu app?
* Quantos idiomas você precisa suportar no seu app?

Pesquise quais opções uma determinada fonte oferece,
como mais de um peso ou estilo por arquivo de fonte,
[capacidade de fonte variável][variable-fonts],
a disponibilidade de múltiplos arquivos de fonte para múltiplos pesos de fonte,
ou mais de uma largura por fonte.

Escolha o typeface ou família de fontes que atenda às necessidades de design do seu app.

:::secondary
Para aprender como obter acesso direto a mais de 1.000 famílias de fontes de código aberto,
confira o pacote [google_fonts][].

<YouTubeEmbed id="8Vzv2CdbEY0" title="google_fonts | Flutter package of the week"></YouTubeEmbed>

Para aprender sobre outra abordagem para usar fontes customizadas que permite a você
reutilizar uma fonte em múltiplos projetos,
confira [Export fonts from a package][].
:::

## Importar os arquivos de fonte

Para trabalhar com uma fonte, importe seus arquivos de fonte para o seu projeto Flutter.

Para importar arquivos de fonte, execute os seguintes passos.

1. Se necessário, para corresponder aos passos restantes neste guia,
   mude o nome do seu app Flutter para `custom_fonts`.

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

A estrutura de pastas resultante deve se assemelhar ao seguinte:

```plaintext
custom_fonts/
|- fonts/
  |- Raleway-Regular.ttf
  |- Raleway-Italic.ttf
  |- RobotoMono-Regular.ttf
  |- RobotoMono-Bold.ttf
```

## Declarar a fonte no arquivo pubspec.yaml

Depois que você baixou uma fonte,
inclua uma definição de fonte no arquivo `pubspec.yaml`.
Esta definição de fonte também especifica qual arquivo de fonte deve ser usado para
renderizar um determinado peso ou estilo no seu app.

### Definir fontes no arquivo `pubspec.yaml`

Para adicionar arquivos de fonte ao seu app Flutter, complete os seguintes passos.

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
Flutter troca `Raleway-Regular` por `Raleway-Italic`.

O valor `family` define o nome do typeface.
Você usa este nome na propriedade [`fontFamily`][] de um objeto [`TextStyle`][].

O valor de um `asset` é um caminho relativo do arquivo `pubspec.yaml`
para o arquivo de fonte.
Esses arquivos contêm os contornos para os glifos na fonte.
Ao construir o app,
Flutter inclui esses arquivos no bundle de assets do app.

### Incluir arquivos de fonte para cada fonte

Diferentes typefaces implementam arquivos de fonte de maneiras diferentes.
Se você precisa de um typeface com uma variedade de pesos e estilos de fonte,
escolha e importe arquivos de fonte que representem essa variedade.

Quando você importa um arquivo de fonte que não inclui múltiplas fontes
dentro dele ou capacidades de fonte variável,
não use a propriedade `style` ou `weight` para ajustar como eles exibem.
Se você usar essas propriedades em um arquivo de fonte regular,
Flutter tenta _simular_ a aparência.
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
Para usar a fonte `RobotoMono-Bold` que você adicionou ao seu app,
defina `fontWeight` para `FontWeight.w700` no seu widget `TextStyle`.

Se você não tivesse adicionado `RobotoMono-Bold` ao seu app,
Flutter tenta fazer a fonte parecer negrito.
O texto então pode aparecer um pouco mais escuro.

Você não pode usar a propriedade `weight` para sobrescrever o peso da fonte.
Você não pode definir `RobotoMono-Bold` para nenhum outro peso além de `700`.
Se você definir `TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.w900)`,
a fonte exibida ainda renderizaria tão negrito quanto `RobotoMono-Bold` parece.

#### Definir estilo da fonte

A propriedade `style` especifica se os glifos no arquivo de fonte exibem como
`italic` ou `normal`.
Esses valores correspondem ao [`FontStyle`][].
Você pode usar esses estilos na propriedade [`fontStyle`][fontStyle property]
de um objeto [`TextStyle`][].

No `pubspec.yaml` mostrado neste guia,
você definiu `Raleway-Italic` como estando no estilo `italic`.
Para usar a fonte `Raleway-Italic` que você adicionou ao seu app,
defina `style: TextStyle(fontStyle: FontStyle.italic)`.
Flutter troca `Raleway-Regular` por `Raleway-Italic` ao renderizar.

Se não tivesse adicionado `Raleway-Italic` ao seu app,
Flutter tenta fazer a fonte _parecer_ itálico.
O texto então pode aparecer inclinado para a direita.

Você não pode usar a propriedade `style` para sobrescrever os glifos de uma fonte.
Se você definir `TextStyle(fontFamily: 'Raleway', fontStyle: FontStyle.normal)`,
a fonte exibida ainda renderizaria como itálico.
O estilo `regular` de uma fonte itálica _é_ itálico.

## Definir uma fonte como padrão

Para aplicar uma fonte a texto, você pode definir a fonte como a fonte padrão do app
no seu `theme`.

Para definir uma fonte padrão, defina a propriedade `fontFamily` no `theme` do app.
Corresponda o valor `fontFamily` ao nome `family` declarado no
arquivo `pubspec.yaml`.

O resultado se assemelharia ao seguinte código.

<?code-excerpt "lib/main.dart (MaterialApp)"?>
```dart
return MaterialApp(
  title: 'Custom Fonts',
  // Set Raleway as the default app font.
  theme: ThemeData(fontFamily: 'Raleway'),
  home: const MyHomePage(),
);
```

Para aprender mais sobre themes,
confira a receita [Using Themes to share colors and font styles][].

## Definir a fonte em um widget específico

Para aplicar a fonte a um widget específico como um widget `Text`,
forneça um [`TextStyle`][] para o widget.

Para este guia,
tente aplicar a fonte `RobotoMono` a um único widget `Text`.
Corresponda o valor `fontFamily` ao nome `family` declarado no
arquivo `pubspec.yaml`.

O resultado se assemelharia ao seguinte código.

<?code-excerpt "lib/main.dart (Text)"?>
```dart
child: Text(
  'Roboto Mono sample',
  style: TextStyle(fontFamily: 'RobotoMono'),
),
```

:::important
Se um objeto [`TextStyle`][] especifica um peso ou estilo sem um
arquivo de fonte correspondente, o motor usa um arquivo genérico para a fonte
e tenta extrapolar contornos para o peso e estilo solicitados.

Evite confiar nessa capacidade. Importe o arquivo de fonte adequado.
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

### Usar este arquivo `main.dart`

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

O app Flutter resultante deve exibir a seguinte tela.

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
