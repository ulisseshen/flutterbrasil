---
title: Use themes to share colors and font styles
short-title: Themes
description: How to share colors and font styles throughout an app using Themes.
prev:
  title: Use a custom font
  path: /cookbook/design/fonts
next:
  title: Work with tabs
  path: /cookbook/design/tabs
js:
  - defer: true
    url: https://dartpad.dev/inject_embed.dart.js
---

<?code-excerpt path-base="cookbook/design/themes"?>

To share colors and font styles throughout an app, use themes.
You can either define app-wide themes, or use `Theme` widgets
that define the colors and font styles for a particular part
of the application. In fact,
app-wide themes are just `Theme` widgets created at
the root of an app by the `MaterialApp`.

After defining a Theme, use it within your own widgets. Flutter's
Material widgets also use your Theme to set the background
colors and font styles for AppBars, Buttons, Checkboxes, and more.

## Creating an app theme

To share a Theme across an entire app, provide a
[`ThemeData`][] to the `MaterialApp` constructor.

If no `theme` is provided, Flutter creates a default theme for you.

<?code-excerpt "lib/main.dart (MaterialApp)" replace="/return //g"?>
```dart
MaterialApp(
  title: appName,
  theme: ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],

    // Define the default font family.
    fontFamily: 'Georgia',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
    ),
  ),
  home: const MyHomePage(
    title: appName,
  ),
);
```

See the [`ThemeData`][] documentation to see all of
the colors and fonts you can define.

## Themes for part of an application

To override the app-wide theme in part of an application,
wrap a section of the app in a `Theme` widget.

There are two ways to approach this: creating a unique `ThemeData`,
or extending the parent theme.

{{site.alert.note}}
  To learn more, watch this short Widget of the Week video on the Theme widget:

  <iframe class="full-width" src="{{site.youtube-site}}/embed/oTvQDJOBXmM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{{site.alert.end}}

### Creating unique `ThemeData`

If you don't want to inherit any application colors or font styles,
create a `ThemeData()` instance and pass that to the `Theme` widget.

<?code-excerpt "lib/theme.dart (Theme)"?>
```dart
Theme(
  // Create a unique theme with `ThemeData`
  data: ThemeData(
    splashColor: Colors.yellow,
  ),
  child: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
);
```

### Extending the parent theme

Rather than overriding everything, it often makes sense to extend the parent
theme. You can handle this by using the [`copyWith()`][] method.

<?code-excerpt "lib/theme.dart (ThemeCopyWith)"?>
```dart
Theme(
  // Find and extend the parent theme using `copyWith`. See the next
  // section for more info on `Theme.of`.
  data: Theme.of(context).copyWith(splashColor: Colors.yellow),
  child: const FloatingActionButton(
    onPressed: null,
    child: Icon(Icons.add),
  ),
);
```

## Using a Theme

Now that you've defined a theme, use it within the widgets' `build()`
methods by using the `Theme.of(context)` method.

The `Theme.of(context)` method looks up the widget tree and returns
the nearest `Theme` in the tree. If you have a standalone
`Theme` defined above your widget, that's returned.
If not, the app's theme is returned.

In fact, the `FloatingActionButton` uses this technique to find the
`accentColor`.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g"?>
```dart
Container(
  color: Theme.of(context).colorScheme.secondary,
  child: Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.titleLarge,
  ),
),
```

## Interactive example

<?code-excerpt "lib/main.dart"?>
```run-dartpad:theme-light:mode-flutter:run-true:width-100%:height-600px:split-60:ga_id-interactive_example
import 'package:flutter/material.dart';

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
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
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
        title: Text(title),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Text(
            'Text with a background color',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.yellow),
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
