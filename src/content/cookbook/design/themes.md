---
title: Use temas para compartilhar cores e estilos de fonte
short-title: Temas
description: Como compartilhar cores e estilos de fonte por todo um aplicativo usando Temas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/design/themes"?>

:::note
Esta receita usa o suporte do Flutter para [Material 3][] e
o pacote [google_fonts][]. A partir do lançamento do Flutter 3.16,
Material 3 é o tema padrão do Flutter.
:::

[Material 3]: /ui/design/material
[google_fonts]: {{site.pub-pkg}}/google_fonts

Para compartilhar cores e estilos de fonte por todo um aplicativo, use temas.

Você pode definir temas em todo o aplicativo.
Você pode estender um tema para alterar o estilo de um tema para um componente.
Cada tema define as cores, tipo de estilo e outros parâmetros
aplicáveis para o tipo de componente Material.

O Flutter aplica o estilo na seguinte ordem:

1. Estilos aplicados ao widget específico.
1. Temas que substituem o tema pai imediato.
1. Tema principal para todo o aplicativo.

Depois de definir um `Theme`, use-o dentro de seus próprios widgets.
Os widgets Material do Flutter usam seu tema para definir as cores de fundo
e estilos de fonte para barras de aplicativo, botões, caixas de seleção e muito mais.

## Criar um tema de aplicativo

Para compartilhar um `Theme` em todo o seu aplicativo, defina a propriedade `theme`
no construtor do seu `MaterialApp`.
Esta propriedade aceita uma instância de [`ThemeData`][].

A partir do lançamento do Flutter 3.16, Material 3 é o
tema padrão do Flutter.

Se você não especificar um tema no construtor,
o Flutter cria um tema padrão para você.

<?code-excerpt "lib/main.dart (MaterialApp)" replace="/return //g"?>
```dart
MaterialApp(
  title: appName,
  theme: ThemeData(
    useMaterial3: true,

    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      // ···
      brightness: Brightness.dark,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      // ···
      titleLarge: GoogleFonts.oswald(
        fontSize: 30,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
  ),
  home: const MyHomePage(
    title: appName,
  ),
);
```

A maioria das instâncias de `ThemeData` definem valores para as duas propriedades seguintes. Essas propriedades afetam todo o aplicativo.

1. [`colorScheme`][] define as cores.
1. [`textTheme`][] define o estilo de texto.

[`colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html

Para saber quais cores, fontes e outras propriedades você pode definir,
confira a documentação do [`ThemeData`][].

## Aplicar um tema

Para aplicar seu novo tema, use o método `Theme.of(context)`
ao especificar as propriedades de estilo de um widget.
Estas podem incluir, mas não estão limitadas a, `style` e `color`.

O método `Theme.of(context)` procura na árvore de widgets e recupera
o `Theme` mais próximo na árvore.
Se você tiver um `Theme` independente, ele é aplicado.
Se não, o Flutter aplica o tema do aplicativo.

No exemplo a seguir, o construtor `Container` usa essa técnica para definir sua `color`.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g"?>
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  ),
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Text with a background color',
    // ···
    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
  ),
),
```

## Substituir um tema

Para substituir o tema geral em parte de um aplicativo,
envolva essa seção do aplicativo em um widget `Theme`.

Você pode substituir um tema de duas maneiras:

1. Criar uma instância única de `ThemeData`.
2. Estender o tema pai.

### Definir uma instância única de `ThemeData`

Se você quiser que um componente do seu aplicativo ignore o tema geral,
crie uma instância de `ThemeData`.
Passe essa instância para o widget `Theme`.

<?code-excerpt "lib/main.dart (Theme)"?>
```dart
Theme(
  // Create a unique theme with `ThemeData`.
  data: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
    ),
  ),
  child: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
);
```

### Estender o tema pai

Em vez de substituir tudo, considere estender o tema pai.
Para estender um tema, use o método [`copyWith()`][].

<?code-excerpt "lib/main.dart (ThemeCopyWith)"?>
```dart
Theme(
  // Find and extend the parent theme using `copyWith`.
  // To learn more, check out the section on `Theme.of`.
  data: Theme.of(context).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
    ),
  ),
  child: const FloatingActionButton(
    onPressed: null,
    child: Icon(Icons.add),
  ),
);
```

## Assista a um vídeo sobre `Theme`

Para saber mais, assista a este breve vídeo Widget of the Week sobre o widget `Theme`:

{% ytEmbed 'oTvQDJOBXmM', 'Theme | Flutter widget of the week' %}

## Experimente um exemplo interativo

<?code-excerpt "lib/main.dart (FullApp)"?>
```dartpad title="Flutter themes hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';
// Include the Google Fonts package to provide more text format options
// https://pub.dev/packages/google_fonts
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // TRY THIS: Change one of the GoogleFonts
          //           to "lato", "poppins", or "lora".
          //           The title uses "titleLarge"
          //           and the middle text uses "bodyMedium".
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                )),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Text with a background color',
            // TRY THIS: Change the Text value
            //           or change the Theme.of(context).textTheme
            //           to "displayLarge" or "displaySmall".
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          // TRY THIS: Change the seedColor to "Colors.red" or
          //           "Colors.blue".
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/themes.png" alt="Themes Demo" class="site-mobile-screenshot" />
</noscript>

[`copyWith()`]: {{site.api}}/flutter/material/ThemeData/copyWith.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
