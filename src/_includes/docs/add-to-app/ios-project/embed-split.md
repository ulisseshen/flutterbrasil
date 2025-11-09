### Use frameworks no Xcode e framework Flutter como podspec {:#method-c .no_toc}

#### Abordagem {:#method-c-approach}

Este método gera Flutter como um podspec CocoaPods em vez de
distribuir o grande `Flutter.xcframework` para outros desenvolvedores,
máquinas ou sistemas de integração contínua.
Flutter ainda gera frameworks iOS para seu código Dart compilado,
e para cada um de seus plugins Flutter.
Incorpore esses frameworks e atualize as configurações de build da sua aplicação existente.

#### Requisitos {:#method-c-reqs}

Nenhum requisito adicional de software ou hardware é necessário para este método.
Use este método nos seguintes casos de uso:

* Membros da sua equipe não podem instalar o Flutter SDK e CocoaPods
* Você não quer usar CocoaPods como gerenciador de dependências em apps iOS existentes

#### Limitações {:#method-c-limits}

{% render "docs/add-to-app/ios-project/limits-common-deps.md" %}

Este método funciona apenas com os [canais de release][release channels] `beta` ou `stable`.

[release channels]: /install/upgrade#switching-flutter-channels

#### Estrutura do projeto de exemplo {:#method-c-structure}

{% render "docs/add-to-app/ios-project/embed-framework-directory-tree.md" %}

#### Adicione o Flutter engine ao seu Podfile

Apps hospedeiros usando CocoaPods podem adicionar o Flutter engine ao seu Podfile.

```ruby title="MyApp/Podfile"
pod 'Flutter', :podspec => '/path/to/MyApp/Flutter/[![build mode]!]/Flutter.podspec'
```

:::note
Você deve codificar explicitamente o valor do `[build mode]`.
Por exemplo, use `Debug` se você precisar usar `flutter attach`
e `Release` quando estiver pronto para enviar.
:::

#### Vincule e incorpore frameworks do app e plugins

{% render "docs/add-to-app/ios-project/link-and-embed.md" %}
