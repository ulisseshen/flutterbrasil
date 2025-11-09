---
ia-translate: true
title: Usar themes para compartilhar cores e estilos de fonte
shortTitle: Themes
description: Como compartilhar cores e estilos de fonte em todo um app usando Themes.
---

<?code-excerpt path-base="cookbook/design/themes"?>

:::note
Esta receita usa o suporte do Flutter para [Material 3][] e
o pacote [google_fonts][]. A partir do release Flutter 3.16,
Material 3 é o theme padrão do Flutter.
:::

[Material 3]: /ui/design/material
[google_fonts]: {{site.pub-pkg}}/google_fonts

Para compartilhar cores e estilos de fonte em todo um app, use themes.

Você pode definir themes em todo o app.
Você pode estender um theme para mudar um estilo de theme para um componente.
Cada theme define as cores, estilo de tipo, e outros parâmetros
aplicáveis para o tipo de componente Material.

Flutter aplica estilização na seguinte ordem:

1. Estilos aplicados ao widget específico.
1. Themes que sobrescrevem o theme pai imediato.
1. Theme principal para todo o app.

Depois que você define um `Theme`, use-o dentro dos seus próprios widgets.
Os widgets Material do Flutter usam seu theme para definir as cores de fundo
e estilos de fonte para barras de app, botões, checkboxes, e mais.

## Criar um theme de app

Para compartilhar um `Theme` em todo o seu app, defina a propriedade `theme`
no seu construtor `MaterialApp`.
Esta propriedade recebe uma instância [`ThemeData`][].

A partir do release Flutter 3.16, Material 3 é o
theme padrão do Flutter.

Se você não especificar um theme no construtor,
Flutter cria um theme padrão para você.

<?code-excerpt "lib/main.dart (MaterialApp)" replace="/return //g"?>
```dart
MaterialApp(
  title: appName,
  theme: ThemeData(
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
  home: const MyHomePage(title: appName),
);
```

A maioria das instâncias de `ThemeData` define valores para as seguintes duas propriedades. Essas propriedades afetam todo o app.

1. [`colorScheme`][] define as cores.
1. [`textTheme`][] define a estilização de texto.

[`colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html

Para aprender quais cores, fontes, e outras propriedades, você pode definir,
confira a documentação de [`ThemeData`][].

## Aplicar um theme

Para aplicar seu novo theme, use o método `Theme.of(context)`
ao especificar as propriedades de estilização de um widget.
Essas podem incluir, mas não estão limitadas a, `style` e `color`.

O método `Theme.of(context)` procura na árvore de widgets e recupera
o `Theme` mais próximo na árvore.
Se você tem um `Theme` independente, ele é aplicado.
Se não, Flutter aplica o theme do app.

No exemplo a seguir, o construtor `Container` usa essa técnica para definir sua `color`.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g"?>
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

## Sobrescrever um theme

Para sobrescrever o theme geral em parte de um app,
envolva essa seção do app em um widget `Theme`.

Você pode sobrescrever um theme de duas maneiras:

1. Criar uma instância `ThemeData` única.
2. Estender o theme pai.

### Definir uma instância `ThemeData` única

Se você quer que um componente do seu app ignore o theme geral,
crie uma instância `ThemeData`.
Passe essa instância para o widget `Theme`.

<?code-excerpt "lib/main.dart (Theme)"?>
```dart
Theme(
  // Create a unique theme with `ThemeData`.
  data: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
  child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
);
```

### Estender o theme pai

Em vez de sobrescrever tudo, considere estender o theme pai.
Para estender um theme, use o método [`copyWith()`][].

<?code-excerpt "lib/main.dart (ThemeCopyWith)"?>
```dart
Theme(
  // Find and extend the parent theme using `copyWith`.
  // To learn more, check out the section on `Theme.of`.
  data: Theme.of(
    context,
  ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
  child: const FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
);
```

## Assistir um vídeo sobre `Theme`

Para aprender mais, assista este curto vídeo Widget of the Week sobre o widget `Theme`:

<YouTubeEmbed id="oTvQDJOBXmM" title="Theme | Flutter widget of the week"></YouTubeEmbed>

## Experimentar um exemplo interativo

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
      home: const MyHomePage(title: appName),
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
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
