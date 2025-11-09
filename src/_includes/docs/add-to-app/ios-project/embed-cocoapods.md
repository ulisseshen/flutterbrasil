### Usar CocoaPods e o Flutter SDK {:#method-a .no_toc}

#### Abordagem {:#method-a-approach}

Este primeiro método usa CocoaPods para incorporar os módulos Flutter.
O CocoaPods gerencia dependências para projetos Swift,
incluindo código Flutter e plugins.
Cada vez que o Xcode compila o app,
o CocoaPods incorpora os módulos Flutter.

Isso permite iteração rápida com a versão mais atualizada
do seu módulo Flutter sem executar comandos adicionais
fora do Xcode.

Para saber mais sobre CocoaPods,
consulte o [guia de introdução ao CocoaPods][CocoaPods getting started guide].

#### Assista ao vídeo

Se assistir a um vídeo ajuda você a aprender,
este vídeo cobre adicionar o Flutter a um app iOS:

<YouTubeEmbed id="IIcrfrTshTs" title="Step by step on how to add Flutter to an existing iOS app"></YouTubeEmbed>

#### Requisitos {:#method-a-reqs}

Cada desenvolvedor trabalhando em seu projeto deve ter uma versão local
do Flutter SDK e CocoaPods instalados.

#### Estrutura de projeto de exemplo {:#method-a-structure}

Esta seção assume que seu app existente e
o módulo Flutter residem em diretórios irmãos.
Se você tem uma estrutura de diretório diferente,
ajuste os caminhos relativos.
A estrutura de diretório de exemplo se assemelha ao seguinte:

```plaintext
/path/to/MyApp
├── my_flutter/
│   └── .ios/
│       └── Flutter/
│         └── podhelper.rb
└── MyApp/
    └── Podfile
```

#### Atualizar seu Podfile

Adicione seus módulos Flutter ao arquivo de configuração Podfile.
Esta seção presume que você chamou seu app Swift de `MyApp`.

1. _(Opcional)_ Se seu app existente não tiver um arquivo de configuração `Podfile`,
   navegue até a raiz do diretório do seu app.
   Use o comando `pod init` para criar o arquivo `Podfile`.

   :::tip
   Se o comando `pod init` der erro,
   verifique se você está na versão mais recente do CocoaPods.
   :::

1. Atualize seu arquivo de configuração `Podfile`.

   1. Adicione as seguintes linhas após a declaração `platform`.

      ```ruby title="MyApp/Podfile"
      flutter_application_path = '../my_flutter'
      load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
      ```

   1. Para cada [alvo do Podfile][Podfile target] que precisa incorporar o Flutter,
      adicione uma chamada ao método
      `install_all_flutter_pods(flutter_application_path)`.
      Adicione essas chamadas após as configurações no passo anterior.

      ```ruby title="MyApp/Podfile"
      target 'MyApp' do
        install_all_flutter_pods(flutter_application_path)
      end
      ```

   1. No bloco `post_install` do `Podfile`,
      adicione uma chamada a `flutter_post_install(installer)`.
      Este bloco deve ser o último bloco no arquivo de configuração `Podfile`.

      ```ruby title="MyApp/Podfile"
      post_install do |installer|
        flutter_post_install(installer) if defined?(flutter_post_install)
      end
      ```

Para revisar um exemplo de `Podfile`, consulte esta [amostra de Podfile Flutter][Flutter Podfile sample].

#### Incorporar seus frameworks

No momento da compilação, o Xcode empacota seu código Dart, cada plugin Flutter,
e o Flutter engine em seus próprios bundles `*.xcframework`.
O script `podhelper.rb` do CocoaPod então incorpora esses
bundles `*.xcframework` em seu projeto.

* `Flutter.xcframework` contém o Flutter engine.
* `App.xcframework` contém o código Dart compilado para este projeto.
* `<plugin>.xcframework` contém um plugin Flutter.

Para incorporar o Flutter engine, seu código Dart e seus plugins Flutter
em seu app iOS, complete o seguinte procedimento.

1. Atualize seus plugins Flutter.

   Se você alterar as dependências do Flutter no arquivo `pubspec.yaml`,
   execute `flutter pub get` no diretório do seu módulo Flutter.
   Isso atualiza a lista de plugins que o script `podhelper.rb` lê.

   ```console
   flutter pub get
   ```

1. Incorpore os plugins e frameworks com CocoaPods.

   1. Navegue até seu projeto de app iOS em `/path/to/MyApp/MyApp`.

   1. Use o comando `pod install`.

      ```console
      pod install
      ```

   As configurações de compilação **Debug** e **Release** do seu app iOS incorporam
   os [componentes Flutter correspondentes para aquele modo de compilação][build-modes].

1. Compile o projeto.

   1. Abra `MyApp.xcworkspace` no Xcode.

      Verifique se você está abrindo `MyApp.xcworkspace` e
      não abrindo `MyApp.xcodeproj`.
      O arquivo `.xcworkspace` tem as dependências do CocoaPod,
      o `.xcodeproj` não tem.

   1. Selecione **Product** > **Build** ou pressione <kbd>Cmd</kbd> + <kbd>B</kbd>.

#### Definir LLDB Init File

:::warning
Defina seu scheme para usar o LLDB Init File do Flutter. Sem este arquivo, a depuração
em um dispositivo iOS 26 ou posterior pode travar.
:::

1. Gere os arquivos LLDB do Flutter.

   1. Dentro da sua aplicação flutter, execute o seguinte:

   ```console
   flutter build ios --config-only
   ```

   Isso irá gerar os arquivos LLDB no diretório `.ios/Flutter/ephemeral`.

1. Defina o LLDB Init File.

   1. Vá para **Product > Scheme > Edit Scheme**.

   1. Selecione a seção **Run** na barra lateral esquerda.

   1. Defina o **LLDB Init File** usando o mesmo caminho relativo para sua aplicação
      Flutter que você colocou no seu Podfile na seção **Atualizar seu Podfile**.

      ```console
      $(SRCROOT)/../my_flutter/.ios/Flutter/ephemeral/flutter_lldbinit
      ```

      Se seu scheme já tem um **LLDB Init File**, você pode adicionar o arquivo
      LLDB do Flutter a ele. O caminho para o LLDB Init File do Flutter deve ser relativo
      à localização do LLDB Init File do seu projeto.

      Por exemplo, se seu arquivo LLDB está localizado em `/path/to/MyApp/.lldbinit`,
      você adicionaria o seguinte:

      ```console
      command source --relative-to-command-file "../my_flutter/.ios/Flutter/ephemeral/flutter_lldbinit"
      ```

[build-modes]: /testing/build-modes
[CocoaPods getting started guide]: https://guides.cocoapods.org/using/using-cocoapods.html
[Podfile target]: https://guides.cocoapods.org/syntax/podfile.html#target
[Flutter Podfile sample]: https://github.com/flutter/samples/blob/main/add_to_app/plugin/ios_using_plugin/Podfile
