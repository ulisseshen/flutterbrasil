---
ia-translate: true
title: Construir e lançar um aplicativo desktop para Windows
description: Como lançar um aplicativo Flutter na Microsoft Store.
short-title: windows
---

Uma abordagem conveniente para distribuir aplicativos Windows é a
[Microsoft Store][microsoftstore].
Este guia fornece um passo a passo de como empacotar e implantar
um aplicativo Flutter dessa forma.

:::note
Não é obrigatório publicar aplicativos Windows por meio da
Microsoft Store, principalmente se você preferir mais controle
sobre a experiência de distribuição ou não quiser lidar
com o processo de certificação. A documentação da Microsoft
inclui mais informações sobre abordagens de instalação
tradicionais, incluindo o [Windows Installer][msidocs].
:::

## Preliminares

Antes de começar o processo de lançamento
de um aplicativo desktop Flutter para Windows na Microsoft Store,
primeiro confirme se ele satisfaz as [Políticas da Microsoft Store][storepolicies].

Além disso, você deve se juntar à
[Microsoft Partner Network][microsoftpartner] para poder enviar aplicativos.

## Configurar seu aplicativo no Partner Center

Gerencie o ciclo de vida de um aplicativo no
[Microsoft Partner Center][microsoftpartner].

Primeiro, reserve o nome do aplicativo e
certifique-se de que os direitos necessários para o nome existam.
Depois que o nome for reservado, o aplicativo
será provisionado para serviços (como
notificações push) e você poderá começar a adicionar complementos.

Opções como preços, disponibilidade,
classificações etárias e categoria devem ser
configuradas junto com o primeiro envio
e são automaticamente mantidas
para os envios subsequentes.

## Empacotamento e implantação

Para publicar um aplicativo na Microsoft Store,
primeiro você deve empacotá-lo.
Os formatos válidos são **.msix**, **.msixbundle**,
**.msixupload**, **.appx**, **.appxbundle**,
**.appxupload** e **.xap**.

### Empacotamento e implantação manual para a Microsoft Store

Confira [empacotamento MSIX][msix packaging]
para saber mais sobre como empacotar
aplicativos desktop Flutter para Windows.

Observe que cada produto tem uma identidade única,
que a Store atribui.

Se o pacote estiver sendo construído manualmente,
você deve incluir seus detalhes de identidade
manualmente durante o empacotamento.
As informações essenciais podem ser recuperadas
no Partner Center usando as seguintes instruções:

1. No Partner Center, navegue até o aplicativo.
2. Selecione **Gerenciamento de produto**.
3. Recupere o nome da identidade do pacote, editor,
   e o nome de exibição do editor clicando em **Identidade do produto**.

Depois de empacotar o aplicativo manualmente,
envie-o manualmente para o
[Microsoft Partner Center][microsoftpartner].
Você pode fazer isso criando um novo envio,
navegando até **Pacotes**
e enviando o pacote de aplicativo criado.

### Implantação contínua

Além de criar e implantar o pacote manualmente,
você pode automatizar o processo de build, pacote,
controle de versão e implantação usando ferramentas de CI/CD depois de ter enviado
o aplicativo para a Microsoft Store pela primeira vez.

#### Codemagic CI/CD

[Codemagic CI/CD][codemagic] usa o
[`msix` pub package][msix package] para empacotar
aplicativos desktop Flutter para Windows.

Para aplicativos Flutter, use o
[Codemagic Workflow Editor][cmworkfloweditor]
ou [codemagic.yaml][cmyaml]
para empacotar o aplicativo e implantá-lo
no Microsoft Partner Center.
Opções adicionais (como a lista de
recursos e recursos de idioma
contidos no pacote)
podem ser configuradas usando este pacote.

Para publicação, o Codemagic usa a
[API de envio do Partner Center][partnercenterapi];
portanto, o Codemagic exige
[associar o Azure Active Directory
e contas do Partner Center][azureadassociation].

#### GitHub Actions CI/CD

O GitHub Actions pode usar o
[Microsoft Dev Store CLI](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/overview)
para empacotar aplicativos em um MSIX e publicá-los na Microsoft Store.
O [setup-msstore-cli](https://github.com/microsoft/setup-msstore-cli)
GitHub Action instala o CLI para que a Action possa usá-lo para empacotamento
e publicação.

Como o empacotamento do MSIX usa o
[`msix` pub package][msix package], o `pubspec.yaml` do projeto
deve conter um nó `msix_config` apropriado.

Você deve criar um diretório Azure AD no Dev Center com
[permissão de administrador global](https://azure.microsoft.com/documentation/articles/active-directory-assign-admin-roles/).

O GitHub Action requer segredos de ambiente do partner center.
`AZURE_AD_TENANT_ID`, `AZURE_AD_ClIENT_ID` e `AZURE_AD_CLIENT_SECRET`
são visíveis no Dev Center seguindo as instruções do
[Windows Store Publish Action](https://github.com/marketplace/actions/windows-store-publish#obtaining-your-credentials).
Você também precisa do segredo `SELLER_ID`, que pode ser encontrado no Dev Center
em **Configurações da conta** > **Perfil da organização** > **Informações legais**.

O aplicativo já deve estar presente no Microsoft Dev Center com pelo
menos um envio completo e `msstore init` deve ser executado uma vez no
repositório antes que a Action possa ser executada. Uma vez concluído, executar
[`msstore package .`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/package-command)
e
[`msstore publish`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/publish-command)
em um GitHub Action empacota o
aplicativo em um MSIX e o envia para um novo envio no dev center.

As etapas necessárias para a publicação do MSIX são semelhantes às seguintes

```yaml
- uses: microsoft/setup-msstore-cli@v1

- name: Configure the Microsoft Store CLI
  run: msstore reconfigure --tenantId ${{ secrets.AZURE_AD_TENANT_ID }} --clientId ${{ secrets.AZURE_AD_ClIENT_ID }} --clientSecret ${{ secrets.AZURE_AD_CLIENT_SECRET }} --sellerId ${{ secrets.SELLER_ID }}

- name: Install Dart dependencies
  run: flutter pub get

- name: Create MSIX package
  run: msstore package .

- name: Publish MSIX to the Microsoft Store
  run: msstore publish -v
```

## Atualizando o número da versão do aplicativo

Para aplicativos publicados na Microsoft Store,
o número da versão deve ser definido durante o
processo de empacotamento.

O número de versão padrão do aplicativo é `1.0.0.0`.

:::note
Não é permitido que aplicativos da Microsoft Store tenham uma
Versão com um número de revisão diferente de zero.
Portanto, o último número da versão deve
permanecer zero para todas as versões.
Certifique-se de seguir as
[diretrizes de versionamento][windowspackageversioning] da Microsoft.
:::

Para aplicativos não publicados na Microsoft Store, você
pode definir o arquivo executável do aplicativo e as versões do produto.
A versão de arquivo padrão do executável é `1.0.0.1`
e sua versão de produto padrão é `1.0.0+1`. Para atualizar isso,
navegue até o arquivo `pubspec.yaml` e atualize a
seguinte linha:

```yaml
version: 1.0.0+1
```

O nome do build são três números separados por pontos,
seguido por um número de build opcional separado
por um `+`. No exemplo acima, o nome do build é `1.0.0`
e o número do build é `1`.

O nome do build torna-se os três primeiros números do
arquivo e versões do produto, enquanto o número do build se torna
o quarto número do arquivo e versões do produto.

Tanto o nome quanto o número do build podem ser substituídos em
`flutter build windows` especificando `--build-name` e
`--build-number`, respectivamente.

:::note
Projetos Flutter criados antes do Flutter 3.3
precisam ser atualizados para definir a versão do executável
informações. Para obter mais informações,
consulte o [guia de migração de versão][].
:::

## Adicionar ícones de aplicativos

Para atualizar o ícone de um Flutter Windows
aplicativo desktop antes de empacotar, use o
seguinte instruções:

1. No projeto Flutter, navegue até
   **windows\runner\resources**.
2. Substitua o **app_icon.ico** pelo ícone desejado.
3. Se o nome do ícone for diferente de **app_icon.ico**,
   proceda para alterar o valor **IDI_APP_ICON** no
   arquivo **windows\runner\Runner.rc** para apontar para o novo caminho.

Ao empacotar com o [`msix` pub package][msix package],
o caminho do logotipo também pode ser configurado dentro do arquivo `pubspec.yaml`.

Para atualizar a imagem do aplicativo na listagem da Store,
navegue até a etapa de listagem da Store do envio
e selecione Logotipos da Store.
De lá, você pode fazer upload do logotipo com
o tamanho de 300 x 300 pixels.

Todas as imagens enviadas são mantidas para envios subsequentes.

## Validando o pacote do aplicativo

Antes da publicação na Microsoft Store,
primeiro valide o pacote do aplicativo localmente.

[Windows App Certification Kit][windowsappcertification]
é uma ferramenta incluída no
Windows Software Development Kit (SDK).

Para validar o aplicativo:

1. Inicie o Windows App Cert Kit.
2. Selecione o pacote de desktop Flutter Windows
   (**.msix**, **.msixbundle**, etc.).
3. Escolha um destino para o relatório de teste.

O relatório pode conter avisos e informações importantes,
mesmo que a certificação seja aprovada.

[azureadassociation]: https://docs.microsoft.com/windows/uwp/publish/associate-azure-ad-with-partner-center
[cmworkfloweditor]: https://docs.codemagic.io/flutter-publishing/publishing-to-microsoft-store/
[cmyaml]: https://docs.codemagic.io/yaml-publishing/microsoft-store/
[codemagic]: https://codemagic.io/start/
[microsoftstore]: https://www.microsoft.com/store/apps/windows
[msidocs]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[microsoftpartner]: https://partner.microsoft.com/
[msix package]: {{site.pub}}/packages/msix
[msix packaging]: /platform-integration/windows/building#msix-packaging
[partnercenterapi]: https://docs.microsoft.com/azure/marketplace/azure-app-apis
[storepolicies]: https://docs.microsoft.com/windows/uwp/publish/store-policies/
[visualstudiopackaging]: https://docs.microsoft.com/windows/msix/package/packaging-uwp-apps
[visualstudiosubmission]: https://docs.microsoft.com/windows/msix/package/packaging-uwp-apps#automate-store-submissions
[windowspackageversioning]: https://docs.microsoft.com/windows/uwp/publish/package-version-numbering
[windowsappcertification]: https://docs.microsoft.com/windows/uwp/debug-test-perf/windows-app-certification-kit
[version migration guide]: /release/breaking-changes/windows-version-information
