---
ia-translate: true
title: Integre um módulo Flutter em seu projeto iOS
shortTitle: Integrar Flutter
description: Aprenda como integrar um módulo Flutter em seu projeto iOS existente.
---

Os componentes de UI do Flutter podem ser adicionados incrementalmente em sua aplicação
iOS existente como frameworks incorporados.
Para incorporar o Flutter em sua aplicação existente,
considere um dos três métodos a seguir.

| Método de Incorporação | Metodologia | Benefício |
|---|---|---|
| Usar CocoaPods _(Recomendado)_ | Instale e use o Flutter SDK e CocoaPods. O Flutter compila o `flutter_module` a partir do código-fonte cada vez que o Xcode compila o app iOS. | Método menos complicado para incorporar o Flutter em seu app. |
| Usar [iOS frameworks][iOS frameworks] | Crie iOS frameworks para componentes Flutter, incorpore-os em seu iOS e atualize as configurações de compilação do seu app existente. | Não requer que cada desenvolvedor instale o Flutter SDK e CocoaPods em suas máquinas locais. |
| Usar iOS frameworks e CocoaPods | Incorpore os frameworks para seu app iOS e os plugins no Xcode, mas distribua o Flutter engine como um podspec do CocoaPods. | Fornece uma alternativa para distribuir a biblioteca grande do Flutter engine (`Flutter.xcframework`). |

{:.table .table-striped}

[iOS frameworks]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html

Quando você adiciona o Flutter ao seu app iOS existente,
ele [aumenta o tamanho do seu app iOS][app-size].

Para exemplos usando um app construído com UIKit,
veja os diretórios iOS nas [amostras de código add_to_app][add_to_app code samples].
Para um exemplo usando SwiftUI, consulte o diretório iOS no [News Feed App][News Feed app].

## Requisitos de sistema de desenvolvimento

O Flutter requer a versão mais recente do Xcode e [CocoaPods][CocoaPods].

## Criar um módulo Flutter

Para incorporar o Flutter em sua aplicação existente com qualquer método,
crie um módulo Flutter primeiro.
Use o seguinte comando para criar um módulo Flutter.

```console
$ cd /path/to/my_flutter
$ flutter create --template module my_flutter
```

O Flutter cria o projeto do módulo em `/path/to/my_flutter/`.
Se você usar o [método CocoaPods][CocoaPods method], salve o módulo
no mesmo diretório pai que seu app iOS existente.

[CocoaPods method]: /add-to-app/ios/project-setup/?tab=embed-using-cocoapods

Do diretório do módulo Flutter,
você pode executar os mesmos comandos `flutter` que você executaria em qualquer outro projeto Flutter,
como `flutter run` ou `flutter build ios`.
Você também pode executar o módulo no [VS Code][VS Code] ou
no [Android Studio/IntelliJ][Android Studio/IntelliJ] com os plugins Flutter e Dart.
Este projeto contém uma versão de exemplo de visualização única do seu módulo
antes de incorporá-lo em seu app iOS existente.
Isso ajuda ao testar as partes somente-Flutter do seu código.

## Organizar seu módulo

A estrutura de diretório do módulo `my_flutter` se assemelha a um app Flutter típico.

```plaintext
my_flutter/
├── .ios/
│   ├── Runner.xcworkspace
│   └── Flutter/podhelper.rb
├── lib/
│   └── main.dart
├── test/
└── pubspec.yaml
```

Seu código Dart deve ser adicionado ao diretório `lib/`.
Suas dependências, packages e plugins do Flutter devem ser adicionados ao
arquivo `pubspec.yaml`.

A subpasta oculta `.ios/` contém um workspace do Xcode onde
você pode executar uma versão autônoma do seu módulo.
Este projeto wrapper faz o bootstrap do seu código Flutter.
Ele contém scripts auxiliares para facilitar a construção de frameworks ou
incorporar o módulo em sua aplicação existente com CocoaPods.

:::note

* Adicione código iOS personalizado ao projeto da sua própria
  aplicação existente ou a um plugin, não ao diretório `.ios/`
  do módulo. Alterações feitas no diretório `.ios/` do seu
  módulo não aparecem em seu projeto iOS existente
  que usa o módulo, e podem ser sobrescritas pelo Flutter.

* Exclua o diretório `.ios/` do controle de código-fonte pois
  ele é gerado automaticamente.

* Antes de compilar o módulo em uma nova máquina,
  execute `flutter pub get` no diretório `my_flutter`.
  Isso regenera o diretório `.ios/` antes de compilar
  o projeto iOS que usa o módulo Flutter.

:::

## Incorporar um módulo Flutter em seu app iOS

Após você ter desenvolvido seu módulo Flutter,
você pode incorporá-lo usando os métodos descritos
na tabela no topo da página.

Você pode executar no modo **Debug** em um simulador ou em um dispositivo real,
e no modo **Release** em um dispositivo real.

:::note
Saiba mais sobre os [modos de compilação do Flutter][build modes of Flutter].

Para usar recursos de depuração do Flutter como hot reload,
consulte [Depurando seu módulo add-to-app][Debugging your add-to-app module].
:::

<Tabs key="darwin-deps">
<Tab name="Use CocoaPods">

{% render "docs/add-to-app/ios-project/embed-cocoapods.md" %}

</Tab>
<Tab name="Use frameworks">

{% render "docs/add-to-app/ios-project/embed-frameworks.md" %}

</Tab>
<Tab name="Use frameworks and CocoaPods">

{% render "docs/add-to-app/ios-project/embed-split.md" %}

</Tab>
</Tabs>


## Definir permissões de privacidade de rede local {:#set-local-network-privacy-permissions}

No iOS 14 e posterior, habilite o serviço Dart multicast DNS na
versão **Debug** do seu app iOS.
Isso adiciona [funcionalidades de depuração como hot-reload e DevTools][debugging functionalities such as hot-reload and DevTools]
usando `flutter attach`.

:::warning
Nunca habilite este serviço na versão **Release** do seu app.
A Apple App Store pode rejeitar seu app.
:::

Para definir permissões de privacidade de rede local apenas na versão Debug do seu app,
crie um `Info.plist` separado por configuração de compilação.
Projetos SwiftUI começam sem um arquivo `Info.plist`.
Se você precisar criar uma lista de propriedades,
você pode fazer isso através do Xcode ou editor de texto.
As instruções a seguir assumem os padrões **Debug** e **Release**.
Ajuste os nomes conforme necessário dependendo das configurações de compilação do seu app.

1. Crie uma nova lista de propriedades.

   1. Abra seu projeto no Xcode.

   1. No **Project Navigator**, clique no nome do projeto.

   1. Da lista **Targets** no painel Editor, clique em seu app.

   1. Clique na aba **Info**.

   1. Expanda **Custom iOS Target Properties**.

   1. Clique com o botão direito na lista e selecione **Add Row**.

   1. Do menu dropdown, selecione **Bonjour Services**.
      Isso cria uma nova lista de propriedades no diretório do projeto
      chamada `Info`. Isso é exibido como `Info.plist` no Finder.

1. Renomeie o `Info.plist` para `Info-Debug.plist`

   1. Clique no arquivo **Info** na lista do projeto à esquerda.

   1. No painel **Identity and Type** à direita,
      altere o **Name** de `Info.plist` para `Info-Debug.plist`.

1. Crie uma lista de propriedades Release.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Selecione **File** > **Duplicate...**.
      Você também pode pressionar <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>.

   1. Na caixa de diálogo, defina o campo **Save As:** como
      `Info-Release.plist` e clique em **Save**.

1. Adicione as propriedades necessárias à lista de propriedades **Debug**.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Adicione o valor String `_dartVmService._tcp`
      ao array **Bonjour Services**.

   1. _(Opcional)_ Para definir o texto de diálogo de permissão personalizado desejado,
      adicione a chave **Privacy - Local Network Usage Description**.

      <DashImage image="development/add-to-app/ios/project-setup/debug-plist.png" caption="A lista de propriedades `Info-Debug` com as chaves **Bonjour Services** e **Privacy - Local Network Usage Description** adicionadas" />

1. Defina o target para usar listas de propriedades diferentes para diferentes modos de compilação.

   1. No **Project Navigator**, clique em seu projeto.

   1. Clique na aba **Build Settings**.

   1. Clique nas sub-abas **All** e **Combined**.

   1. Na caixa Search, digite `plist`.
      Isso limita as configurações àquelas que incluem listas de propriedades.

   1. Role pela lista até ver **Packaging**.

   1. Clique na configuração **Info.plist File**.

   1. Altere o valor de **Info.plist File**
      de `path/to/Info.plist` para `path/to/Info-$(CONFIGURATION).plist`.

      <DashImage image="development/add-to-app/ios/project-setup/set-plist-build-setting.png" caption="Atualizando a configuração de compilação `Info.plist` para usar listas de propriedades específicas do modo de compilação" />

      Isso resolve para o caminho **Info-Debug.plist** em **Debug** e
      **Info-Release.plist** em **Release**.

      <DashImage image="development/add-to-app/ios/project-setup/plist-build-setting.png" caption="A configuração de compilação **Info.plist File** atualizada exibindo as variações de configuração" />

1. Remova a lista de propriedades **Release** das **Build Phases**.

   1. No **Project Navigator**, clique em seu projeto.

   1. Clique na aba **Build Phases**.

   1. Expanda **Copy Bundle Resources**.

   1. Se esta lista incluir `Info-Release.plist`,
      clique nele e depois clique no **-** (sinal de menos) abaixo dele
      para remover a lista de propriedades da lista de recursos.

      <DashImage image="development/add-to-app/ios/project-setup/copy-bundle.png" caption="A fase de compilação **Copy Bundle** exibindo a configuração **Info-Release.plist**. Remova esta configuração." />

1. A primeira tela Flutter que seu app Debug carrega solicita
   permissão de rede local.

   Clique em **OK**.

   _(Opcional)_ Para conceder permissão antes do app carregar, habilite
   **Settings > Privacy > Local Network > Your App**.

## Mitigar problema conhecido com Macs Apple Silicon

Em [Macs executando Apple Silicon][apple-silicon],
o app host compila para um simulador `arm64`.
Embora o Flutter suporte simuladores `arm64`, alguns plugins podem não suportar.
Se você usar um desses plugins, você pode ver um erro de compilação como
**Undefined symbols for architecture arm64**.
Se isso ocorrer,
exclua `arm64` das arquiteturas de simulador em seu app host.

1. No **Project Navigator**, clique em seu projeto.

1. Clique na aba **Build Settings**.

1. Clique nas sub-abas **All** e **Combined**.

1. Em **Architectures**, clique em **Excluded Architectures**.

1. Expanda para ver as configurações de compilação disponíveis.

1. Clique em **Debug**.

1. Clique no **+** (sinal de mais).

1. Selecione **iOS Simulator**.

1. Clique duas vezes na coluna de valor para **Any iOS Simulator SDK**.

1. Clique no **+** (sinal de mais).

1. Digite `arm64` na caixa de diálogo **Debug > Any iOS Simulator SDK**.

   <DashImage image="development/add-to-app/ios/project-setup/excluded-archs.png" caption="Adicione `arm64` como uma arquitetura excluída para seu app" />

1. Pressione <kbd>Esc</kbd> para fechar esta caixa de diálogo.

1. Repita estes passos para o modo de compilação **Release**.

1. Repita para quaisquer targets de teste unitário iOS.

## Próximos passos

Você agora pode [adicionar uma tela Flutter][add a Flutter screen] ao seu app iOS existente.

[add_to_app code samples]: {{site.repo.samples}}/tree/main/add_to_app
[add a Flutter screen]: /add-to-app/ios/add-flutter-screen
[Android Studio/IntelliJ]: /tools/android-studio
[build modes of Flutter]: /testing/build-modes
[CocoaPods]: https://cocoapods.org/
[debugging functionalities such as hot-reload and DevTools]: /add-to-app/debugging
[app-size]: /resources/faq#how-big-is-the-flutter-engine
[VS Code]: /tools/vs-code
[News Feed app]: https://github.com/flutter/put-flutter-to-work/tree/022208184ec2623af2d113d13d90e8e1ce722365
[Debugging your add-to-app module]: /add-to-app/debugging/
[apple-silicon]: https://support.apple.com/en-us/116943
