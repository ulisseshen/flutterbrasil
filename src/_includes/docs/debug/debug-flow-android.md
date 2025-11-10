#### Compile a versão Android do app Flutter no Terminal

Para gerar as dependências necessárias da plataforma Android,
execute o comando `flutter build`.

```console
flutter build appbundle --debug
```

```console
Running Gradle task 'bundleDebug'...                               27.1s
✓ Built build/app/outputs/bundle/debug/app-debug.aab.
```


<Tabs key="android-debug-flow">
<Tab name="Start from VS Code">

#### Comece depurando com VS Code primeiro {:#from-vscode-to-android-studio}

Se você usa VS Code para depurar a maior parte do seu código, comece com esta seção.

{% render "docs/debug/debug-flow-vscode-as-start.md" %}

#### Anexe ao processo Flutter no Android Studio

{% render "docs/debug/debug-android-attach-process.md" %}

</Tab>
<Tab name="Start from Android Studio">

#### Comece depurando com Android Studio primeiro {:#from-android-studio}

Se você usa Android Studio para depurar a maior parte do seu código, comece com esta seção.

{% render "docs/debug/debug-flow-androidstudio-as-start.md" %}

{% render "docs/debug/debug-android-attach-process.md" %}

</Tab>
</Tabs>
