---
title: Code formatting
description: >
    Flutter's code formatter formats your code
    following recommended style guidelines.
---


While your code might follow any preferred style&mdash;in our
experience&mdash;teams of developers might find it more productive to:

* Have a single, shared style, and
* Enforce this style through automatic formatting.

The alternative is often tiring formatting debates during code reviews,
where time might be better spent on code behavior rather than code style.

## Automatically formatting code in VS Code

Install the `Flutter` extension (see
[Editor setup]({{site.url}}/get-started/editor))
to get automatic formatting of code in VS Code.

To automatically format the code in the current source code window,
right-click in the code window and select `Format Document`.
You can add a keyboard shortcut to this VS Code Preferences.

To automatically format code whenever you save a file, set the
`editor.formatOnSave` setting to `true`.

## Automatically formatting code in Android Studio and IntelliJ

Install the `Dart` plugin (see
[Editor setup]({{site.url}}/get-started/editor))
to get automatic formatting of code in Android Studio and IntelliJ.
To automatically format your code in the current source code window,
use `Cmd+Option+L` (on Mac) or `Ctrl+Alt+L` (on Windows and Linux).
Android Studio and IntelliJ also provide a check box named
**Format code on save** on the Flutter page in Preferences
(on Mac) or Settings (on Windows and Linux)
which formats the current file automatically when you save it.

## Automatically formatting code with the `dart` command

You can also automatically format code in the command line interface
(CLI) using the `dart format` command:

```terminal
$ dart format path1 path2 ...
```

## Using trailing commas

Flutter code often involves building fairly deep tree-shaped data structures,
for example in a `build` method. To get good automatic formatting,
we recommend you adopt the optional *trailing commas*.
The guideline for adding a trailing comma is simple: Always
add a trailing comma at the end of a parameter list in
functions, methods, and constructors where you care about
keeping the formatting you crafted.
This helps the automatic formatter to insert an appropriate
amount of line breaks for Flutter-style code.

Here is an example of automatically formatted code *with* trailing commas:

![Automatically formatted code with trailing commas]({{site.url}}/assets/images/docs/tools/android-studio/trailing-comma-with.png){:width="100%"}

And the same code automatically formatted code *without* trailing commas:

![Automatically formatted code without trailing commas]({{site.url}}/assets/images/docs/tools/android-studio/trailing-comma-without.png){:width="100%"}
