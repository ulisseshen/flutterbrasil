<!-- ia-translate: true -->

Plugins Flutter podem produzir [frameworks estáticos ou dinâmicos][static or dynamic frameworks].
Linke frameworks estáticos, [_nunca_ incorpore-os][static-framework].

Se você incorporar um framework estático em seu app iOS,
você não pode publicar esse app na App Store.
A publicação falha com um
erro de archive `Found an unexpected Mach-O header code`.

##### Linkar todos os frameworks

Para linkar os frameworks necessários, siga este procedimento.

1. Escolha os frameworks para linkar.

   1. No **Project Navigator**, clique em seu projeto.

   1. Clique na aba **Build Phases**.

   1. Expanda **Link Binary With Libraries**.

      <DashImage image="development/add-to-app/ios/project-setup/linked-libraries.png" caption="Expanda a fase de compilação **Link Binary With Libraries** no Xcode" />

   1. Clique em **+** (sinal de mais).

   1. Clique em **Add Other...** e depois **Add Files...**.

   1. Da caixa de diálogo **Choose frameworks and libraries to add:**,
      navegue até o diretório `/path/to/MyApp/Flutter/Release/`.

   1. Command-clique nos frameworks nesse diretório e depois clique em **Open**.

      <DashImage image="development/add-to-app/ios/project-setup/choose-libraries.png" caption="Escolha frameworks para linkar da caixa de diálogo **Choose frameworks and libraries to add:** no Xcode" />

1. Atualize os caminhos para as bibliotecas para levar em conta os modos de compilação.

   1. Inicie o Finder.

   1. Navegue até o diretório `/path/to/MyApp/`.

   1. Clique com o botão direito em `MyApp.xcodeproj` e selecione **Show Package
      Contents**.

   1. Abra `project.pbxproj` com o Xcode. O arquivo abre no editor de texto
      do Xcode. Isso também bloqueia o **Project Navigator** até você fechar o editor de texto.

      <DashImage image="development/add-to-app/ios/project-setup/project-pbxproj.png" caption="O arquivo `project-pbxproj` aberto no editor de texto do Xcode" />

   1. Encontre as linhas que se assemelham ao seguinte texto na
      `/* Begin PBXFileReference section */`.

      ```text
      312885572C1A441C009F74FF /* Flutter.xcframework */ = {
        isa = PBXFileReference;
        expectedSignature = "AppleDeveloperProgram:S8QB4VV633:FLUTTER.IO LLC";
        lastKnownFileType = wrapper.xcframework;
        name = Flutter.xcframework;
        path = Flutter/[!Release!]/Flutter.xcframework;
        sourceTree = "<group>";
      };
      312885582C1A441C009F74FF /* App.xcframework */ = {
        isa = PBXFileReference;
        lastKnownFileType = wrapper.xcframework;
        name = App.xcframework;
        path = Flutter/[!Release!]/App.xcframework;
        sourceTree = "<group>";
      };
      ```

   1. Altere o texto `Release` destacado no passo anterior
      e mude-o para `$(CONFIGURATION)`. Também envolva o caminho em
      aspas.

      ```text
      312885572C1A441C009F74FF /* Flutter.xcframework */ = {
        isa = PBXFileReference;
        expectedSignature = "AppleDeveloperProgram:S8QB4VV633:FLUTTER.IO LLC";
        lastKnownFileType = wrapper.xcframework;
        name = Flutter.xcframework;
        path = [!"!]Flutter/[!$(CONFIGURATION)!]/Flutter.xcframework[!"!];
        sourceTree = "<group>";
      };
      312885582C1A441C009F74FF /* App.xcframework */ = {
        isa = PBXFileReference;
        lastKnownFileType = wrapper.xcframework;
        name = App.xcframework;
        path = [!"!]Flutter/[!$(CONFIGURATION)!]/App.xcframework[!"!];
        sourceTree = "<group>";
      };
      ```

1. Atualize os caminhos de busca.

   1. Clique na aba **Build Settings**.

   1. Navegue até **Search Paths**

   1. Clique duas vezes à direita de **Framework Search Paths**.

   1. Na caixa de combinação, clique em **+** (sinal de mais).

   1. Digite `$(inherited)`.
      e pressione <kbd>Enter</kbd>.

   1. Clique em **+** (sinal de mais).

   1. Digite `$(PROJECT_DIR)/Flutter/$(CONFIGURATION)/`
      e pressione <kbd>Enter</kbd>.

      <DashImage image="development/add-to-app/ios/project-setup/framework-search-paths.png" caption="Atualize **Framework Search Paths** no Xcode" />

Após linkar os frameworks, eles devem ser exibidos na
seção **Frameworks, Libraries, and Embedded Content**
das configurações **General** do seu target.

##### Incorporar os frameworks dinâmicos

Para incorporar seus frameworks dinâmicos, complete o seguinte procedimento.

1. Navegue até **General** <span aria-label="and then">></span>
   **Frameworks, Libraries, and Embedded Content**.

1. Clique em cada um dos seus frameworks dinâmicos e selecione **Embed & Sign**.

   <DashImage image="development/add-to-app/ios/project-setup/choose-to-embed.png" caption="Selecione **Embed & Sign** para cada um dos seus frameworks no Xcode" />

   Não inclua nenhum framework estático,
   incluindo `FlutterPluginRegistrant.xcframework`.

1. Clique na aba **Build Phases**.

1. Expanda **Embed Frameworks**.
   Seus frameworks dinâmicos devem ser exibidos nessa seção.

   <DashImage image="development/add-to-app/ios/project-setup/embed-xcode.png" caption="A fase de compilação **Embed Frameworks** expandida no Xcode" />

1. Compile o projeto.

   1. Abra `MyApp.xcworkspace` no Xcode.

      Verifique se você está abrindo `MyApp.xcworkspace` e
      não abrindo `MyApp.xcodeproj`.
      O arquivo `.xcworkspace` tem as dependências do CocoaPod,
      o `.xcodeproj` não tem.

   1. Selecione **Product** <span aria-label="and then">></span>
      **Build** ou pressione <kbd>Cmd</kbd> + <kbd>B</kbd>.

#### Definir LLDB Init File

:::warning
Defina seu scheme para usar o LLDB Init File do Flutter. Sem este arquivo, a depuração
em um dispositivo iOS 26 ou posterior pode travar.
:::

1. Gere os arquivos LLDB do Flutter.

   1. Dentro da sua aplicação flutter, execute novamente `flutter build ios-framework` se
      você ainda não tiver feito:

   ```console
   $ flutter build ios-framework --output=/path/to/MyApp/Flutter/
   ```

   Isso irá gerar os arquivos LLDB no diretório `/path/to/MyApp/Flutter/`.

1. Defina o LLDB Init File.

   1. Vá para **Product > Scheme > Edit Scheme**.

   1. Selecione a seção **Run** na barra lateral esquerda.

   1. Defina o **LLDB Init File** para o seguinte:

      ```console
      $(PROJECT_DIR)/Flutter/flutter_lldbinit
      ```

      Se seu scheme já tem um **LLDB Init File**, você pode adicionar o arquivo
      LLDB do Flutter a ele. O caminho para o LLDB Init File do Flutter deve ser relativo
      à localização do LLDB Init File do seu projeto.

      Por exemplo, se seu arquivo LLDB está localizado em `/path/to/MyApp/.lldbinit`,
      você adicionaria o seguinte:

      ```console
      command source --relative-to-command-file "Flutter/flutter_lldbinit"
      ```

[static or dynamic frameworks]: https://stackoverflow.com/questions/32591878/ios-is-it-a-static-or-a-dynamic-framework
[static-framework]: https://developer.apple.com/library/archive/technotes/tn2435/_index.html
