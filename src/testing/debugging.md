---
title: Debugging Flutter apps
description: How to debug your app using the DevTools suite.
---

<?code-excerpt path-base="testing/debugging"?>

There's a wide variety of tools and features to help debug
Flutter applications. Here are some of the available tools:

* [DevTools][], a suite of performance and profiling
  tools that run in a browser.
* [Android Studio/IntelliJ][], and [VS Code][]
  (enabled with the Flutter and Dart plugins)
  support a built-in source-level debugger with
  the ability to set breakpoints, step through code,
  and examine values.
* [Flutter inspector][], a widget inspector available
  in DevTools, and also directly from Android Studio
  and IntelliJ (enabled with the Flutter plugin).
  The inspector allows you to examine a visual
  representation of the widget tree, inspect
  individual widgets and their property values,
  enable the performance overlay, and more.
* If you are looking for a way to use GDB to remotely debug the
  Flutter engine running within an Android app process,
  check out [`flutter_gdb`][].

[`flutter_gdb`]: https://github.com/flutter/engine/blob/main/sky/tools/flutter_gdb

## DevTools

For debugging and profiling apps, DevTools might be
the first tool you reach for. DevTools runs in a
browser and supports a variety of features:

* source-level debugger
* widget inspector that displays a visual widget tree,
  and "widget select" mode where you select a widget
  in the app and it drills down to that widget in
  the tree
* memory profiler
* timeline view that supports tracing, and importing
  and exporting trace information
* logging view

If you run your application in [debug mode][] or
[profile mode][], while it's running you can open
DevTools in the browser to connect to your app.
DevTools doesn't work well with an app compiled to
[release mode][], as the debugging and profiling
information has been stripped away.

If you use DevTools for profiling, make sure to
run your application in [profile mode][]. Otherwise,
the main output that appears on your profile are the
debug asserts verifying the framework's various invariants
(see [Debug mode assertions](#debug-mode-assertions)).

![GIF showing DevTools features]({{site.url}}/assets/images/docs/tools/devtools/inspector.gif){:width="100%"}

For more information, see the
[DevTools][] documentation.

## Setting breakpoints

You can set breakpoints directly in your IDE/editor
(such as [Android Studio/IntelliJ][] and [VS Code][]),
in the [DevTools debugger][],
or [programmatically][breakpoints].

## The Dart analyzer

If you're using a [Flutter enabled IDE/editor][],
the Dart analyzer is already checking your code
and looking for possible mistakes.

If you run from the command line,
test your code with `flutter analyze`.

The Dart analyzer makes heavy use of type annotations that
you put in your code to help track problems down.
You are encouraged to use them everywhere (avoiding `var`,
untyped arguments, untyped list literals, and so on)
as this is the quickest and least painful way of tracking
down problems.

For more information, see [Using the Dart analyzer][].

## Logging

Another useful debugging tool is logging.
You set logging up [programmatically][logging]
then view the output in the DevTools
[logging view][], or in the console.

## Debugging application layers

Flutter was designed with a layered architecture that includes
widget, rendering, and painting layers. For links to more
information and videos, see [The Framework architecture][] on the
[GitHub wiki][], and the community article, [The Layer Cake][].

The Flutter widget inspector provides a visual representation
of the widget tree, but if you want a greater level of detail,
or you want a verbose text-based dump of the widget,
layer, or render trees, see
[Debug flags: application layers][]
in the [Debugging Flutter apps programmatically][] page.

## Debug mode assertions

During development, you are highly encouraged to use Flutter's
[debug mode][]. This is the default if you use bug icon in
Android Studio, or `flutter run` at the command line.
Some tools support assert statements through the
command-line flag `--enable-asserts`.

In this mode, Dart assert statements are enabled,
and the Flutter framework evaluates the argument
to each assert statement encountered during execution,
throwing an exception if the result is false.
This allows developers to enable or disable invariant
checking, such that the associated performance cost
is only paid during debugging sessions.

When an invariant is violated, it's reported to the
console, with some context information to help track
down the source of the problem.

For more information, check out [Assert][] in the
[Dart language documentation][].

## Debugging animations

The easiest way to debug animations is to slow them down.
The [Flutter inspector][] provides a **Slow Animations** button,
or you can [slow the animations programmatically][].

For more information on debugging janky (non-smooth)
applications, see [Flutter performance profiling][].

## Measuring app startup time

To gather detailed information about the time it takes for your
Flutter app to start, you can run the `flutter run` command
with the `trace-startup` and `profile` options.

```
$ flutter run --trace-startup --profile
```

The trace output is saved as a JSON file called `start_up_info.json`
under the `build` directory of your Flutter project.
The output lists the elapsed time from app startup to these trace
events (captured in microseconds):

+ Time to enter the Flutter engine code.
+ Time to render the first frame of the app.
+ Time to initialize the Flutter framework.
+ Time to complete the Flutter framework initialization.

For example:

```
{
  "engineEnterTimestampMicros": 96025565262,
  "timeToFirstFrameMicros": 2171978,
  "timeToFrameworkInitMicros": 514585,
  "timeAfterFrameworkInitMicros": 1657393
}
```

## Tracing Dart code

To perform a performance trace,
you can use the DevTools [Timeline view][].
The Timeline view also supports importing
and exporting trace files. For more
information, see the [Timeline view][] docs.

You can also
[perform traces programmatically][],
though these traces can't be imported
into DevTool's Timeline view.

Be sure to use run your app in [profile mode][]
before tracing to ensure that the runtime performance
characteristics closely matches that of your final product.

## Performance overlay

To get a graphical view of the performance of your application,
turn on the performance overlay. You can do this in the
by clicking the **Performance Overlay** button in the
[Flutter inspector][].

You can also turn on the overlay [programmatically][overlay].

For information on how to interpret the graphs in the overlay,
see [The performance overlay][] in
the [Flutter performance profiling][] guide.

## Debug flags

In most cases, you won't need to use the debug flags
directly, as you'll find the most useful debugging
functionality in the [DevTools][] suite. But if you
prefer to use the debug flags directly, see
[Debug flags: performance][] in the
[Debugging Flutter apps programmatically][] page.

## Common problems

The following is a problem that some have encountered on MacOS.

### "Too many open files" exception (MacOS)

The default limit for Mac OS on how many files it can have open at a
time is rather low.  If you run into this limit,
increase the number of available
file handlers using the `ulimit` command:

```
ulimit -S -n 2048
```

If you use Travis or Cirrus for testing, increase the number of
available file handlers that they can open by adding the same line to
flutter/.travis.yml, or flutter/.cirrus.yml, respectively.

### Widgets marked const that should be equal to each other, aren't

In debug mode, you might find that two `const` widgets that should to all
appearances be equal (because of Dart's constant deduplication) are not.

For example, this code should print 1:

<?code-excerpt "lib/main.dart (Syntax)"?>
```dart
print(<Widget>{
  // this is the syntax for a Set<Widget> literal
  const SizedBox(),
  const SizedBox(),
}.length);
```

It should print 1 (rather than 2) because the two constants are the same and sets
coalesce duplicate values (and indeed the analyzer complains that
"Two elements in a set literal shouldn't be equal"). As expected, in release
builds, it does print 1. However, in debug builds it prints 2. This is because the
flutter tool injects the source location of Widget constructors into the code at compile
time, so the code is effectively:

<?code-excerpt "lib/main.dart (SyntaxExplain)"?>
```dart
print(<Widget>{
  const SizedBox(/* location: Location(file: 'foo.dart', line: 12) */),
  const SizedBox(/* location: Location(file: 'foo.dart', line: 13) */),
}.length);
```

This results in the instances being different, and so they are not deduplicated by the set.
We use this injected information to make the error messages clearer when
a widget is involved in an exception, by reporting where the relevant widget was created.
Unfortunately, it has the visible side-effect of making otherwise-identical constants be
different at compile time.

To disable this behavior, pass `--no-track-widget-creation` to the `flutter run` command.
With that flag set, the code above prints "1" in debug and release builds, and error messages
include a message saying that they cannot provide all the information that they would otherwise
be able to provide if widget creation tracking was enabled.

See also:

 * Our documentation on [how the Widget Inspector uses widget creation tracking][].
 * [WidgetInspectorService.isWidgetCreationTracked][].
 * The `_Location` class in [widget_inspector.dart][].
 * The [kernel transform that implements this feature][].

## Other resources

You might find the following docs useful:

* [Performance best practices][]
* [Flutter performance profiling][]
* [Using an OEM debugger][]
* [Flutter's modes][]
* [Debugging Flutter apps programmatically][]
* [DevTools][]
* [Android Studio/IntelliJ][]
* [VS Code][]


[Flutter enabled IDE/editor]: {{site.url}}/get-started/editor

[Debugging Flutter apps programmatically]: {{site.url}}/testing/code-debugging
[perform traces programmatically]: {{site.url}}/testing/code-debugging#tracing-dart-code-performance
[Debug flags: application layers]: {{site.url}}/testing/code-debugging#debug-flags-application-layers
[Debug flags: performance]: {{site.url}}/testing/code-debugging#debug-flags-performance
[slow the animations programmatically]: {{site.url}}/testing/code-debugging#debugging-animations
[breakpoints]: {{site.url}}/testing/code-debugging#setting-breakpoints
[logging]: {{site.url}}/testing/code-debugging#logging
[Flutter's modes]: {{site.url}}/testing/build-modes
[Flutter performance profiling]: {{site.url}}/perf/ui-performance
[Performance best practices]: {{site.url}}/perf/best-practices
[Using an OEM debugger]: {{site.url}}/testing/oem-debuggers

[The Layer Cake]: {{site.medium}}/flutter-community/the-layer-cake-widgets-elements-renderobjects-7644c3142401

[GitHub wiki]: {{site.repo.flutter}}/wiki/
[Using the Dart analyzer]: {{site.repo.flutter}}/wiki/Using-the-Dart-analyzer
[The Framework architecture]: {{site.repo.flutter}}/wiki/The-Framework-architecture

[Android Studio/IntelliJ]: {{site.url}}/tools/android-studio#run-app-with-breakpoints
[VS Code]: {{site.url}}/tools/vs-code#run-app-with-breakpoints
[DevTools]: {{site.url}}/tools/devtools
[Flutter inspector]: {{site.url}}/tools/devtools/inspector
[DevTools debugger]: {{site.url}}/tools/devtools/debugger
[logging view]: {{site.url}}/tools/devtools/logging
[Timeline view]: {{site.url}}/tools/devtools/performance
[The performance overlay]: {{site.url}}/perf/ui-performance#the-performance-overlay
[Flutter performance profiling]: {{site.url}}/perf/ui-performance
[overlay]: {{site.url}}/testing/code-debugging#performance-overlay
[debug mode]: {{site.url}}/testing/build-modes#debug
[profile mode]: {{site.url}}/testing/build-modes#profile
[release mode]: {{site.url}}/testing/build-modes#release
[how the Widget Inspector uses widget creation tracking]: {{site.url}}/tools/devtools/inspector#track-widget-creation

[Assert]: {{site.dart-site}}/language/control-flow#assert
[Dart language documentation]: {{site.dart-site}}/language

[WidgetInspectorService.isWidgetCreationTracked]: {{site.api}}/flutter/widgets/WidgetInspectorService/isWidgetCreationTracked.html
[widget_inspector.dart]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/widget_inspector.dart
[kernel transform that implements this feature]: {{site.github}}/dart-lang/sdk/blob/main/pkg/kernel/lib/transformations/track_widget_constructor_locations.dart
