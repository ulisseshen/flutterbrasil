---
ia-translate: true
title: Compilar e lançar um app desktop Windows
description: Como lançar um app Flutter na Microsoft Store.
shortTitle: windows
---

Uma abordagem conveniente para distribuir apps Windows
é a [Microsoft Store][microsoftstore].
Este guia fornece um passo a passo
de empacotar e fazer deploy de um app Flutter desta forma.

:::note
Você não é obrigado a publicar apps Windows através da
Microsoft Store, particularmente se você prefere mais controle
sobre a experiência de distribuição ou não quer lidar
com o processo de certificação. A documentação da Microsoft
inclui mais informações sobre abordagens de instalação
tradicionais, incluindo [Windows Installer][msidocs].
:::

## Preliminares

Antes de iniciar o processo de lançar
um app desktop Flutter Windows na Microsoft Store,
primeiro confirme que ele satisfaz as [Políticas da Microsoft Store][storepolicies].

Além disso, você deve entrar na
[Microsoft Partner Network][microsoftpartner] para poder enviar apps.

## Configure sua aplicação no Partner Center

Gerencie o ciclo de vida de uma aplicação no
[Microsoft Partner Center][microsoftpartner].

Primeiro, reserve o nome da aplicação e
garanta que os direitos necessários ao nome existam.
Uma vez que o nome é reservado, a aplicação
será provisionada para serviços (como
notificações push), e você pode começar a adicionar complementos.

Opções como preço, disponibilidade,
classificações etárias e categoria precisam ser
configuradas junto com a primeira submissão
e são automaticamente retidas
para as submissões subsequentes.

## Empacotamento e deployment

Para publicar uma aplicação na Microsoft Store,
você deve primeiro empacotá-la.
Os formatos válidos são **.msix**, **.msixbundle**,
**.msixupload**, **.appx**, **.appxbundle**,
**.appxupload**, e **.xap**.

### Empacotamento e deployment manual para a Microsoft Store

Confira [empacotamento MSIX][msix packaging]
para aprender sobre empacotar
aplicações desktop Flutter Windows.

Note que cada produto tem uma identidade única,
que a Store atribui.

Se o pacote está sendo compilado manualmente,
você tem que incluir seus detalhes de identidade
manualmente durante o empacotamento.
As informações essenciais podem ser recuperadas
do Partner Center usando as seguintes instruções:

1. No Partner Center, navegue até a aplicação.
2. Selecione **Product management**.
3. Recupere o nome de identidade do pacote, publicador,
   e nome de exibição do publicador clicando em **Product identity**.

Depois de empacotar manualmente a aplicação,
envie-a manualmente para o
[Microsoft Partner Center][microsoftpartner].
Você pode fazer isso criando uma nova submissão,
navegando até **Packages**,
e fazendo upload do pacote de aplicação criado.

### Deployment contínuo

Além de criar e fazer deploy manualmente do pacote,
você pode automatizar o processo de build, empacotamento, versionamento,
e deployment usando ferramentas CI/CD após ter enviado
a aplicação para a Microsoft Store pela primeira vez.

#### Codemagic CI/CD

[Codemagic CI/CD][codemagic] usa o
[package pub `msix`][msix package] para empacotar
aplicações desktop Flutter Windows.

Para aplicações Flutter, use o
[Codemagic Workflow Editor][cmworkfloweditor]
ou [codemagic.yaml][cmyaml]
para empacotar a aplicação e fazer deploy dela
para o Microsoft Partner Center.
Opções adicionais (como a lista de
capacidades e recursos de idioma
contidos no pacote)
podem ser configuradas usando este package.

Para publicação, Codemagic usa a
[API de submissão do Partner Center][partnercenterapi];
então, Codemagic requer
[associar as contas Azure Active Directory
e Partner Center][azureadassociation].

#### GitHub Actions CI/CD

GitHub Actions pode usar o
[Microsoft Dev Store CLI](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/overview)
para empacotar aplicações em um MSIX e publicá-las na Microsoft Store.
O [setup-msstore-cli](https://github.com/microsoft/setup-msstore-cli)
GitHub Action instala o cli para que a Action possa usá-lo para empacotamento
e publicação.

Como o empacotamento do MSIX usa o
[package pub `msix`][msix package], o `pubspec.yaml` do projeto
deve conter um nó `msix_config` apropriado.

Você deve criar um diretório Azure AD do Dev Center com
[permissão de administrador global](https://azure.microsoft.com/documentation/articles/active-directory-assign-admin-roles/).

O GitHub Action requer secrets de ambiente do partner center.
`AZURE_AD_TENANT_ID`, `AZURE_AD_ClIENT_ID`, e `AZURE_AD_CLIENT_SECRET`
são visíveis no Dev Center seguindo as instruções para a
[Windows Store Publish Action](https://github.com/marketplace/actions/windows-store-publish#obtaining-your-credentials).
Você também precisa do secret `SELLER_ID`, que pode ser encontrado no Dev Center
em **Account Settings** > **Organization Profile** > **Legal Info**.

A aplicação já deve estar presente no Microsoft Dev Center com pelo
menos uma submissão completa, e `msstore init` deve ser executado uma vez dentro
do repositório antes que a Action possa ser executada. Uma vez completo, executar
[`msstore package .`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/package-command)
e
[`msstore publish`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/publish-command)
em um GitHub Action empacota a
aplicação em um MSIX e faz upload dela para uma nova submissão no dev center.

Os passos necessários para publicação MSIX se assemelham ao seguinte

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

## Atualizar o número de versão do app {:#updating-the-apps-version-number}

Para apps publicados na Microsoft Store,
o número de versão deve ser definido durante o
processo de empacotamento.

O número de versão padrão do app é `1.0.0.0`.

:::note
Apps da Microsoft Store não têm permissão para ter uma
Versão com um número de revisão diferente de zero.
Portanto, o último número da versão deve
permanecer zero para todos os lançamentos.
Garanta que você siga as
[diretrizes de versionamento][windowspackageversioning] da Microsoft.
:::

Para apps não publicados na Microsoft Store, você
pode definir as versões de arquivo e produto do executável do app.
A versão de arquivo padrão do executável é `1.0.0.1`,
e sua versão de produto padrão é `1.0.0+1`. Para atualizar estas,
navegue até o arquivo `pubspec.yaml` e atualize a
seguinte linha:

```yaml
version: 1.0.0+1
```

O nome de build são três números separados por pontos,
seguidos por um número de build opcional que é separado
por um `+`. No exemplo acima, o nome de build é `1.0.0`
e o número de build é `1`.

O nome de build se torna os três primeiros números das
versões de arquivo e produto, enquanto o número de build se torna
o quarto número das versões de arquivo e produto.

Tanto o nome de build quanto o número podem ser sobrescritos em
`flutter build windows` especificando `--build-name` e
`--build-number`, respectivamente.

:::note
Projetos Flutter criados antes do Flutter 3.3
precisam ser atualizados para definir as informações de versão
do executável. Para mais informações,
consulte o [guia de migração de versão][version migration guide].
:::

## Adicionar ícones de app

Para atualizar o ícone de uma aplicação
desktop Flutter Windows antes de empacotar use as
seguintes instruções:

1. No projeto Flutter, navegue até
   **windows\runner\resources**.
2. Substitua o **app_icon.ico** pelo ícone desejado.
3. Se o nome do ícone é diferente de **app_icon.ico**,
   proceda para mudar o valor **IDI_APP_ICON** no
   arquivo **windows\runner\Runner.rc** para apontar para o novo caminho.

Ao empacotar com o [package pub `msix`][msix package],
o caminho do logo também pode ser configurado dentro do arquivo `pubspec.yaml`.

Para atualizar a imagem da aplicação na listagem da Store,
navegue até o passo Store listing da submissão
e selecione Store logos.
De lá, você pode fazer upload do logo com
o tamanho de 300 x 300 pixels.

Todas as imagens carregadas são retidas para submissões subsequentes.

## Validando o pacote de aplicação

Antes de publicar na Microsoft Store,
primeiro valide o pacote de aplicação localmente.

[Windows App Certification Kit][windowsappcertification]
é uma ferramenta incluída no
Windows Software Development Kit (SDK).

Para validar a aplicação:

1. Inicie Windows App Cert Kit.
2. Selecione o pacote desktop Flutter Windows
   (**.msix**, **.msixbundle**, etc.).
3. Escolha um destino para o relatório de teste.

O relatório pode conter avisos e informações importantes,
mesmo se a certificação passar.

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
