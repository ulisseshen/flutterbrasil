---
ia-translate: true
title: Integrar um módulo Flutter ao seu projeto iOS (legado)
shortTitle: Integrar Flutter (legado)
description: Aprenda a integrar um módulo Flutter ao seu projeto iOS existente.
---

:::warning

A partir do Flutter 3.44, o Swift Package Manager (SwiftPM) substitui o CocoaPods
como gerenciador de dependências padrão para apps Flutter em iOS e macOS.
O CocoaPods está oficialmente em modo de manutenção,
e o registro dele vai [se tornar somente leitura permanentemente em 2 de dezembro de 2026][read-only].

Este guia é mantido apenas como referência e não receberá manutenção contínua.
Migre para o Swift Package Manager seguindo o [guia de integração atualizado][updated integration guide].

:::

Os componentes de UI do Flutter podem ser adicionados gradualmente ao seu app iOS
existente como frameworks incorporados. Para incorporar o Flutter ao seu app,
considere um dos três métodos a seguir.

| Método de incorporação | Metodologia | Benefício |
|---|---|---|
| Use CocoaPods _(recomendado)_ | Instale e use o SDK do Flutter e o CocoaPods. O Flutter compila o `flutter_module` a partir do código-fonte sempre que o Xcode compila o app iOS. | É o método menos complicado para incorporar o Flutter ao seu app. |
| Use [frameworks iOS][iOS frameworks] | Crie frameworks iOS para os componentes do Flutter, incorpore-os ao seu app iOS e atualize as configurações de build do seu app existente. | Não exige que cada desenvolvedor instale o SDK do Flutter e o CocoaPods em sua máquina local. |
| Use frameworks iOS e CocoaPods | Incorpore os frameworks do seu app iOS e os plugins no Xcode, mas distribua o engine do Flutter como um podspec do CocoaPods. | Oferece uma alternativa para distribuir a biblioteca grande do engine do Flutter (`Flutter.xcframework`). |

{:.table .table-striped}

[iOS frameworks]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html

Ao adicionar o Flutter ao seu app iOS existente,
isso [aumenta o tamanho do seu app iOS][app-size].

Para exemplos de apps criados com UIKit,
consulte os diretórios iOS nos [exemplos de código add_to_app][add_to_app code samples].
Para um exemplo com SwiftUI, consulte o diretório iOS do [News Feed App][News Feed App].

## Requisitos do ambiente de desenvolvimento {:#development-system-requirements}

O Flutter exige a versão mais recente do Xcode e do [CocoaPods][CocoaPods].

## Criar um módulo Flutter {:#create-a-flutter-module}

Para incorporar o Flutter ao seu app existente com qualquer método,
crie primeiro um módulo Flutter. Use o comando a seguir para criar um módulo Flutter.

```console
$ cd /path/to/my_flutter
$ flutter create --template module my_flutter
```

O Flutter cria o projeto do módulo em `/path/to/my_flutter/`.
Se você usar o [método CocoaPods][CocoaPods method], salve o módulo
no mesmo diretório pai do seu app iOS existente.

[CocoaPods method]: /add-to-app/ios/project-setup-legacy/?tab=embed-using-cocoapods

A partir do diretório do módulo Flutter, você pode executar os mesmos comandos
`flutter` que executaria em qualquer outro projeto Flutter, como `flutter run`
ou `flutter build ios`. Você também pode executar o módulo no [VS Code][VS Code]
ou no [Android Studio/IntelliJ][Android Studio/IntelliJ], com os plugins Flutter e Dart.
Este projeto contém uma versão de exemplo, com uma única visualização, do seu módulo
antes de incorporá-lo ao seu app iOS existente.
Isso ajuda a testar as partes exclusivas do Flutter do seu código.

## Organizar seu módulo {:#organize-your-module}

A estrutura de diretórios do módulo `my_flutter` se assemelha a um app Flutter típico.

<FileTree>

- my_flutter/
  - .ios/
    - Runner.xcworkspace
    - Flutter/
      - podhelper.rb
  - lib/
    - main.dart
  - test/
  - pubspec.yaml

</FileTree>

Seu código Dart deve ser adicionado ao diretório `lib/`.
As dependências, pacotes e plugins do Flutter devem ser adicionados ao
arquivo `pubspec.yaml`.

O subdiretório oculto `.ios/` contém um workspace do Xcode no qual
você pode executar uma versão independente do seu módulo.
Este projeto wrapper inicializa o seu código Flutter.
Ele contém scripts auxiliares para facilitar a criação de frameworks ou a
incorporação do módulo ao seu app existente com CocoaPods.

:::note

* Adicione código iOS personalizado ao projeto do seu próprio app existente
  ou a um plugin, não ao diretório `.ios/` do módulo. Alterações feitas no
  diretório `.ios/` do módulo não aparecem no seu projeto iOS existente que
  usa o módulo, e podem ser sobrescritas pelo Flutter.

* Exclua o diretório `.ios/` do controle de versão, pois ele é gerado
  automaticamente.

* Antes de compilar o módulo em uma nova máquina, execute `flutter pub get`
  no diretório `my_flutter`. Isso regenera o diretório `.ios/` antes de
  compilar o projeto iOS que usa o módulo Flutter.

:::

## Incorporar um módulo Flutter ao seu app iOS {:#embed-a-flutter-module-in-your-ios-app}

Depois de desenvolver o seu módulo Flutter, você pode incorporá-lo usando os
métodos descritos na tabela no topo da página.

Você pode executar no modo **Debug** em um simulador ou em um dispositivo real,
e no modo **Release** em um dispositivo real.

:::note
Saiba mais sobre os [modos de build do Flutter][build modes of Flutter].

Para usar recursos de depuração do Flutter, como o hot reload,
consulte [Depurar seu módulo add-to-app][Debugging your add-to-app module].
:::

<Tabs key="darwin-deps">
<Tab name="Usar CocoaPods">

{% render "docs/add-to-app/ios-project/embed-cocoapods.md" %}

</Tab>
<Tab name="Usar frameworks">

{% render "docs/add-to-app/ios-project/embed-frameworks.md" %}

</Tab>
<Tab name="Usar frameworks e CocoaPods">

{% render "docs/add-to-app/ios-project/embed-split.md" %}

</Tab>
</Tabs>


## Definir permissões de privacidade de rede local {:#set-local-network-privacy-permissions}

{% render "docs/add-to-app/ios-project/local-network-privacy-permissions.md" %}

## Contornar um problema conhecido em Macs com Apple Silicon {:#mitigate-known-issue-with-apple-silicon-macs}

Em [Macs com Apple Silicon][apple-silicon], o app host é compilado para um
simulador `arm64`. Embora o Flutter ofereça suporte a simuladores `arm64`,
alguns plugins podem não oferecer. Se você usar um desses plugins, pode ver um
erro de compilação como **Undefined symbols for architecture arm64**.
Se isso ocorrer, exclua `arm64` das arquiteturas do simulador no seu app host.

1. No **Project Navigator**, clique no seu projeto.

1. Clique na aba **Build Settings**.

1. Clique nas subabas **All** e **Combined**.

1. Em **Architectures**, clique em **Excluded Architectures**.

1. Expanda para ver as configurações de build disponíveis.

1. Clique em **Debug**.

1. Clique no **+** (sinal de mais).

1. Selecione **iOS Simulator**.

1. Clique duas vezes na coluna de valor de **Any iOS Simulator SDK**.

1. Clique no **+** (sinal de mais).

1. Digite `arm64` na caixa de diálogo **Debug > Any iOS Simulator SDK**.

   <DashImage image="development/add-to-app/ios/project-setup/excluded-archs.png" caption="Adicione `arm64` como arquitetura excluída do seu app" />

1. Pressione <kbd>Esc</kbd> para fechar esta caixa de diálogo.

1. Repita estes passos para o modo de build **Release**.

1. Repita para quaisquer targets de teste unitário do iOS.

## Próximos passos {:#next-steps}

Agora você pode [adicionar uma tela Flutter][add a Flutter screen] ao seu app iOS existente.

[add_to_app code samples]: {{site.repo.samples}}/tree/main/add_to_app
[add a Flutter screen]: /add-to-app/ios/add-flutter-screen
[Android Studio/IntelliJ]: /tools/android-studio
[build modes of Flutter]: /testing/build-modes
[CocoaPods]: https://cocoapods.org/
[app-size]: /resources/faq#how-big-is-the-flutter-engine
[VS Code]: /tools/vs-code
[News Feed App]: https://github.com/flutter/put-flutter-to-work/tree/022208184ec2623af2d113d13d90e8e1ce722365
[Debugging your add-to-app module]: /add-to-app/debugging/
[apple-silicon]: https://support.apple.com/en-us/116943
[read-only]: https://blog.cocoapods.org/CocoaPods-Specs-Repo/
[updated integration guide]: /add-to-app/ios/project-setup
