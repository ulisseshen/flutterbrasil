---
ia-translate: true
title: Use temas para compartilhar cores e estilos de fonte
short-title: Temas
description: Como compartilhar cores e estilos de fonte em todo um aplicativo usando Temas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/themes"?>

:::note
Esta receita usa o suporte do Flutter para [Material 3][] e
o pacote [google_fonts][]. A partir do lançamento do Flutter 3.16,
Material 3 é o tema padrão do Flutter.
:::

[Material 3]: /ui/design/material
[google_fonts]: {{site.pub-pkg}}/google_fonts

Para compartilhar cores e estilos de fonte em todo um aplicativo, use temas.

Você pode definir temas para todo o aplicativo.
Você pode estender um tema para alterar um estilo de tema para um componente.
Cada tema define as cores, o estilo do texto e outros parâmetros
aplicáveis para o tipo de componente Material.

O Flutter aplica o estilo na seguinte ordem:

1. Estilos aplicados ao widget específico.
2. Temas que substituem o tema pai imediato.
3. Tema principal para todo o aplicativo.

Depois de definir um `Theme`, use-o dentro de seus próprios widgets.
Os widgets Material do Flutter usam seu tema para definir as cores de fundo
e os estilos de fonte para barras de aplicativos, botões, caixas de seleção e muito mais.

## Criar um tema de aplicativo

Para compartilhar um `Theme` em todo o seu aplicativo, defina a propriedade `theme`
para o construtor do seu `MaterialApp`.
Essa propriedade usa uma instância de [`ThemeData`][].

A partir do lançamento do Flutter 3.16, Material 3 é o
tema padrão do Flutter.

Se você não especificar um tema no construtor,
o Flutter criará um tema padrão para você.

<?code-excerpt "lib/main.dart (MaterialApp)" replace="/return //g"?>
```dart
MaterialApp(
  title: appName,
  theme: ThemeData(
    useMaterial3: true,

    // Define o brilho e as cores padrão.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      // ···
      brightness: Brightness.dark,
    ),

    // Define o `TextTheme` padrão. Use isso para especificar o estilo de texto
    // padrão para manchetes, títulos, corpos de texto e muito mais.
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

A maioria das instâncias de `ThemeData` define valores para as duas propriedades a seguir. Essas propriedades afetam todo o aplicativo.

1. [`colorScheme`][] define as cores.
2. [`textTheme`][] define o estilo do texto.

[`colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html

Para aprender quais cores, fontes e outras propriedades você pode definir,
confira a documentação de [`ThemeData`][].

## Aplicar um tema

Para aplicar seu novo tema, use o método `Theme.of(context)`
ao especificar as propriedades de estilo de um widget.
Isso pode incluir, mas não está limitado a, `style` e `color`.

O método `Theme.of(context)` procura na árvore de widgets e recupera
o `Theme` mais próximo na árvore.
Se você tiver um `Theme` independente, ele será aplicado.
Caso contrário, o Flutter aplica o tema do aplicativo.

No exemplo a seguir, o construtor do `Container` usa essa técnica para definir sua `color`.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g"?>
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  ),
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Texto com uma cor de fundo',
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
  // Cria um tema único com `ThemeData`.
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
  // Encontra e estende o tema pai usando `copyWith`.
  // Para saber mais, consulte a seção sobre `Theme.of`.
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

Para saber mais, assista a este vídeo curto do Widget da Semana sobre o widget `Theme`:

{% ytEmbed 'oTvQDJOBXmM', 'Theme | Widget da semana Flutter' %}

## Experimente um exemplo interativo

<?code-excerpt "lib/main.dart (FullApp)"?>
```dartpad title="Exemplo prático de temas Flutter no DartPad" run="true"
import 'package:flutter/material.dart';
// Inclua o pacote Google Fonts para fornecer mais opções de formato de texto
// https://pub.dev/packages/google_fonts
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'Temas Personalizados';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,

        // Define o brilho e as cores padrão.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // TENTE ISTO: Altere para "Brightness.light"
          //           e veja que todas as cores mudam
          //           para melhor contrastar um fundo claro.
          brightness: Brightness.dark,
        ),

        // Define o `TextTheme` padrão. Use isso para especificar o estilo de texto
        // padrão para manchetes, títulos, corpos de texto e muito mais.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // TENTE ISTO: Altere uma das GoogleFonts
          //           para "lato", "poppins" ou "lora".
          //           O título usa "titleLarge"
          //           e o texto do meio usa "bodyMedium".
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
            'Texto com uma cor de fundo',
            // TENTE ISTO: Altere o valor do texto
            //           ou altere o Theme.of(context).textTheme
            //           para "displayLarge" ou "displaySmall".
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          // TENTE ISTO: Altere o seedColor para "Colors.red" ou
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
  <img src="/assets/images/docs/cookbook/themes.png" alt="Demonstração de temas" class="site-mobile-screenshot" />
</noscript>

[`copyWith()`]: {{site.api}}/flutter/material/ThemeData/copyWith.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
