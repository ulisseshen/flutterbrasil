<!-- ia-translate: true -->

No iOS 14 e versões posteriores, habilite o serviço DNS multicast do Dart
na versão **Debug** do seu app iOS.
Isso adiciona [funcionalidades de depuração, como hot reload e DevTools][debugging functionalities such as hot-reload and DevTools]
usando `flutter attach`.

:::warning
Nunca habilite este serviço na versão **Release** do seu app.
A App Store da Apple pode rejeitar o seu app.
:::

Para definir as permissões de privacidade de rede local somente na versão **Debug** do seu app,
crie um `Info.plist` separado para cada configuração de build.
Projetos SwiftUI começam sem um arquivo `Info.plist`.
Se você precisar criar uma property list,
pode fazer isso pelo Xcode ou por um editor de texto.
As instruções a seguir assumem as configurações padrão **Debug** e **Release**.
Ajuste os nomes conforme necessário, de acordo com as configurações de build do seu app.

1. Crie uma nova property list.

   1. Abra seu projeto no Xcode.

   1. No **Project Navigator**, clique no nome do projeto.

   1. Na lista **Targets** do painel Editor, clique no seu app.

   1. Clique na aba **Info**.

   1. Expanda **Custom iOS Target Properties**.

   1. Clique com o botão direito na lista e selecione **Add Row**.

   1. No menu suspenso, selecione **Bonjour Services**.
      Isso cria uma nova property list no diretório do projeto,
      chamada `Info`. Ela aparece como `Info.plist` no Finder.

1. Renomeie o `Info.plist` para `Info-Debug.plist`

   1. Clique no arquivo **Info** na lista de projeto à esquerda.

   1. No painel **Identity and Type** à direita,
      altere o **Name** de `Info.plist` para `Info-Debug.plist`.

1. Crie uma property list de Release.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Selecione **File** > **Duplicate...**.
      Você também pode pressionar <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>.

   1. Na caixa de diálogo, defina o campo **Save As:** como
      `Info-Release.plist` e clique em **Save**.

1. Adicione as propriedades necessárias à property list de **Debug**.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Adicione o valor String `_dartVmService._tcp`
      ao array **Bonjour Services**.

   1. _(Opcional)_ Para definir o texto personalizado do diálogo de permissão,
      adicione a chave **Privacy - Local Network Usage Description**.

      <DashImage image="development/add-to-app/ios/project-setup/debug-plist.png" caption="A property list `Info-Debug` com as chaves **Bonjour Services** e **Privacy - Local Network Usage Description** adicionadas" />

1. Configure o target para usar property lists diferentes para cada modo de build.

   1. No **Project Navigator**, clique no seu projeto.

   1. Clique na aba **Build Settings**.

   1. Clique nas sub-abas **All** e **Combined**.

   1. Na caixa de busca, digite `plist`.
      Isso limita as configurações às que incluem property lists.

   1. Role a lista até encontrar **Packaging**.

   1. Clique na configuração **Info.plist File**.

   1. Altere o valor de **Info.plist File**
      de `path/to/Info.plist` para `path/to/Info-$(CONFIGURATION).plist`.

      <DashImage image="development/add-to-app/ios/project-setup/set-plist-build-setting.png" caption="Atualizando a configuração de build `Info.plist` para usar property lists específicas de cada modo de build" />

      Isso resolve para o caminho **Info-Debug.plist** em **Debug** e
      **Info-Release.plist** em **Release**.

      <DashImage image="development/add-to-app/ios/project-setup/plist-build-setting.png" caption="A configuração **Info.plist File** atualizada, mostrando as variações por configuração" />

1. Remova a property list de **Release** das **Build Phases**.

   1. No **Project Navigator**, clique no seu projeto.

   1. Clique na aba **Build Phases**.

   1. Expanda **Copy Bundle Resources**.

   1. Se essa lista incluir `Info-Release.plist`,
      clique nele e depois clique no **-** (sinal de menos) abaixo dela
      para remover a property list da lista de recursos.

      <DashImage image="development/add-to-app/ios/project-setup/copy-bundle.png" caption="A fase de build **Copy Bundle** exibindo a configuração **Info-Release.plist**. Remova essa configuração." />

1. A primeira tela do Flutter que o seu app de Debug carrega pede
   permissão de rede local.

   Clique em **OK**.

   _(Opcional)_ Para conceder a permissão antes de o app carregar, habilite
   **Settings > Privacy > Local Network > Your App**.

[debugging functionalities such as hot-reload and DevTools]: /add-to-app/debugging
