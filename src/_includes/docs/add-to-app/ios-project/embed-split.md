### Usar frameworks no Xcode e Flutter framework como podspec {:#method-c .no_toc}

#### Abordagem {:#method-c-approach}

Este método gera o Flutter como um podspec CocoaPods em vez de
distribuir o grande `Flutter.xcframework` para outros desenvolvedores,
máquinas ou sistemas de integração contínua.
O Flutter ainda gera frameworks iOS para seu código Dart compilado,
e para cada um dos seus plugins Flutter.
Incorpore esses frameworks e atualize as configurações de compilação da sua aplicação existente.

#### Requisitos {:#method-c-reqs}

Nenhum software ou hardware adicional é necessário para este método.
Use este método nos seguintes casos de uso:

* Membros da sua equipe não podem instalar o Flutter SDK e CocoaPods
* Você não quer usar o CocoaPods como gerenciador de dependências em apps iOS existentes

#### Limitações {:#method-c-limits}

{% render "docs/add-to-app/ios-project/limits-common-deps.md" %}

Este método funciona apenas com os [canais de release][release channels] `beta` ou `stable`.

[release channels]: /install/upgrade#switching-flutter-channels

#### Estrutura de projeto de exemplo {:#method-c-structure}

{% render "docs/add-to-app/ios-project/embed-framework-directory-tree.md" %}

#### Adicionar Flutter engine ao seu Podfile

Apps host usando CocoaPods podem adicionar o Flutter engine ao seu Podfile.

```ruby title="MyApp/Podfile"
pod 'Flutter', :podspec => '/path/to/MyApp/Flutter/[![build mode]!]/Flutter.podspec'
```

:::note
Você deve codificar o valor `[build mode]` de forma rígida.
Por exemplo, use `Debug` se você precisar usar `flutter attach`
e `Release` quando estiver pronto para enviar.
:::

#### Linkar e incorporar frameworks de app e plugin

{% render "docs/add-to-app/ios-project/link-and-embed.md" %}
