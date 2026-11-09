---
ia-translate: true
title: Crie ferramentas personalizadas no Flutter e Dart DevTools
breadcrumb: DevTools 
description: 
---

Você já quis criar ferramentas para desenvolvedores de Dart e Flutter,
mas não sabia por onde começar?
Ou talvez não quisesse passar por todo o trabalho de estabelecer
uma conexão com um app Dart ou Flutter em execução para acessar dados de depuração?
E, mesmo que você tenha criado uma ferramenta de desenvolvimento,
como a distribuiria ou daria aos usuários acesso fácil a ela?
Você pode criar ferramentas para desenvolvedores sem todos esses obstáculos.

Com o framework de extensões do Dart & Flutter DevTools,
você pode criar facilmente ferramentas para desenvolvedores que são
integradas de forma estreita ao conjunto de ferramentas existente do DevTools.
As extensões são construídas usando Flutter web e aproveitam frameworks e
utilitários existentes do DevTools para simplificar a experiência de criação
de ferramentas.

![Exemplo de extensão do DevTools para `package:foo`](/assets/images/docs/tools/devtools/custom-devtools-extension.png)

## Como as extensões do DevTools funcionam? {:#how-do-devtools-extensions-work}

As extensões são distribuídas como parte de um pacote do pub.
Você pode adicionar uma extensão do DevTools a um pacote pub existente,
ou pode criar um novo pacote que forneça apenas uma extensão do DevTools.
Em ambos os cenários,
o usuário final precisa declarar uma dependência do pacote que fornece
a extensão do DevTools para poder vê-la no DevTools.

Por exemplo, imagine que temos um `package:foo`,
e esse pacote fornece uma extensão do DevTools.
Quando um usuário depende de `package:foo` no seu app,
ele automaticamente tem acesso à extensão do DevTools
fornecida por esse pacote. Quando o DevTools detecta que a
extensão de `package:foo` está disponível, com base em informações
do app do usuário ou da sua IDE,
uma nova aba "Foo" é adicionada ao DevTools, contendo
as ferramentas de desenvolvimento fornecidas por `package:foo`.

![Diagrama mostrando como uma extensão do DevTools funciona](/assets/images/docs/tools/devtools/how-devtools-extension-works.png)

Alguns exemplos de pacotes que adicionaram uma extensão do DevTools
a um pacote existente são [`package:shared_preferences`][],
[`package:provider`][], [`package:patrol`][] e [`package:drift`][].

[`package:drift`]: {{site.pub-pkg}}/drift
[`package:patrol`]: {{site.pub-pkg}}/patrol
[`package:provider`]: {{site.pub-pkg}}/provider
[`package:shared_preferences`]: {{site.pub-pkg}}/shared_preferences

## Quais tipos de ferramentas são suportados? {:#what-types-of-tools-are-supported}

Com o framework de extensões do DevTools, você pode criar
muitos tipos de ferramentas, incluindo:

* Ferramentas complementares para pacotes existentes.
* Novas ferramentas distribuídas como pacotes próprios.
* Ferramentas que interagem com um app em execução.
* Ferramentas que interagem com arquivos de projeto abertos na IDE.
* Ferramentas que interagem com o Analysis server.

O framework de extensões do DevTools vem com recursos prontos para uso que
tornam a distribuição da sua extensão aos usuários simples.
Por exemplo, os usuários podem:

* Usar sua ferramenta a partir do DevTools no navegador.
* Usar sua ferramenta incorporada diretamente na IDE.
* Descobrir e abrir sua ferramenta a partir das IDEs compatíveis com Dart e Flutter.

Em seguida, aprenda como escrever uma extensão do DevTools.

---

## Escreva uma extensão do DevTools {:#write-a-devtools-extension}

Antes de começar, você precisa de:

* Flutter SDK >= 3.17 e Dart SDK >= 3.2.
* Um pacote [pub][] que (na sua opinião) precise
  de uma extensão personalizada do DevTools.

[pub]: {{site.pub}}

### Configure a hierarquia dos seus pacotes {:#set-up-your-package-hierarchy}

Você vai fornecer uma extensão independente ou
uma extensão complementar.

#### Extensão independente {:#standalone-extension}

Para uma extensão independente (que não é distribuída
como parte de um pacote pub existente),
sua extensão pode incluir o código-fonte no mesmo pacote
com o qual ela é distribuída. Isso simplifica o desenvolvimento,
e, como os usuários do seu pacote vão adicioná-lo como dev_dependency,
o tamanho do seu pacote não afeta o tamanho do app do usuário.
A estrutura do seu pacote ficará assim:

```yaml
my_new_tool
  extension/
    devtools/
      build/
        ...  # pre-compiled output of the Flutter web app under lib/
      config.yaml
  lib/  # source code for your extension Flutter web app
    src/
      ...
```

Como a extensão é construída como um app Flutter web,
use `flutter create` para gerar o pacote:

```console
flutter create --template app --platforms web my_new_tool
```

Em seguida, use o pacote `my_new_tool` para configurar sua extensão
na próxima etapa.

#### Extensões complementares {:#companion-extensions}

Para uma extensão complementar (que é distribuída como parte de um pacote pub existente),
considere colocar o código-fonte da sua extensão fora do seu pacote pub.
Isso mantém o tamanho do seu pacote o menor possível, para evitar inflar
o tamanho dos apps dos usuários que dependem do seu pacote.
Esta é a estrutura de pacote recomendada:

```yaml
foo/  # formerly the repository root of your pub package
  packages/
    foo/  # your pub package
      extension/
        devtools/
          build/
            ...  # pre-compiled output of foo_devtools_extension/lib
          config.yaml
    foo_devtools_extension/
      lib/  # source code for your extension Flutter web app
```

## Configure sua extensão {:#configure-your-extension}

No pacote Dart que fornece a extensão do DevTools aos usuários,
adicione um diretório de extensão no nível superior:

```yaml
foo/
  extension/
  lib/
  ...
```

Dentro do diretório `extension`,
crie a seguinte estrutura **exatamente como mostrado**:

```yaml
extension/
  devtools/
    build/
    config.yaml
```

O arquivo `config.yaml` contém metadados que o DevTools
precisa para carregar a extensão:

```yaml
name: foo
version: 0.0.1
issueTracker: <link_to_your_issue_tracker.com>
materialIconCodePoint: '0xe0b1'
requiresConnection: true  # optional field - defaults to true
```

Copie o conteúdo do `config.yaml` como mostrado e
cole-o no arquivo `config.yaml` que você acabou de criar no seu pacote.
**É importante que você use exatamente o nome do arquivo e os nomes dos campos
como mostrados, caso contrário sua extensão pode não carregar no DevTools**.

Para cada chave, preencha o valor apropriado para o seu pacote.

* `name`: O nome do pacote desta extensão do DevTools.
  O valor deste campo é usado na barra de título da página da extensão. [**obrigatório**]
* `version`: A versão da sua extensão do DevTools.
  Este número de versão deve evoluir com o tempo conforme você lança novos recursos para sua extensão.
  O valor deste campo é usado na barra de título da página da extensão. [**obrigatório**]
* `issueTracker`: A URL do seu rastreador de issues.
  Quando um usuário clica no link **Report an issue** na interface do DevTools,
  ele é direcionado para esta URL. [**obrigatório**]

![Barra de título da tela da extensão do DevTools](/assets/images/docs/tools/devtools/devtools-extension-screen-title-bar.png){:width="80%"}

* `materialIconCodePoint`: Corresponde ao valor de codepoint de um ícone
  de [`material/icons.dart`][]. Esse ícone é usado para a aba da extensão
  na barra de abas do DevTools de nível superior. [**obrigatório**]

![Ícone da aba da extensão do DevTools](/assets/images/docs/tools/devtools/devtools-extension-tab-icon.png){:width="12%"}

* `requiresConnection`: Indica se a extensão requer um app Dart
  ou Flutter conectado para ser usada. Este é um campo opcional que assume
  o valor `true` se não for especificado. [**opcional**]

Para a documentação mais atualizada sobre a especificação do `config.yaml`,
acesse [extension_config_spec.md][].

[extension_config_spec.md]: https://github.com/flutter/devtools/blob/master/packages/devtools_extensions/extension_config_spec.md
[`material/icons.dart`]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/material/icons.dart

## Compile sua extensão {:#build-your-extension}

Use as etapas a seguir para criar uma extensão.

### Crie o app web Flutter {:#create-the-flutter-web-app}

:::note
Pule esta etapa se você estiver criando uma extensão independente,
já que você já fez isso ao configurar a hierarquia dos seus pacotes.
:::

No diretório onde você quer que o código-fonte da sua extensão fique,
execute o comando a seguir, substituindo `foo_devtools_extension` por
`<your_package_name>_devtools_extension`:

```console
flutter create --template app --platforms web foo_devtools_extension
```

### Adicione a dependência `package:devtools_extensions` {:#add-the-package-devtools-extensions-dependency}

```console
flutter pub add devtools_extensions
```

Você provavelmente também vai querer adicionar uma dependência de [`package:devtools_app_shared`][],
que contém serviços, utilitários e componentes de UI compartilhados para usar
ao construir sua extensão.
Acesse [`devtools_app_shared/example`][] para ver exemplos de uso.

```console
flutter pub add devtools_app_shared
```

[`package:devtools_app_shared`]: {{site.pub-pkg}}/devtools_app_shared
[`devtools_app_shared/example`]: https://github.com/flutter/devtools/tree/master/packages/devtools_app_shared/example

### Adicione o widget `DevToolsExtension` {:#add-the-devtoolsextension-widget}

Em `lib/main.dart`, adicione os seguintes imports:

```dart
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const FooDevToolsExtension());
}

class FooDevToolsExtension extends StatelessWidget {
  const FooDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: Placeholder(), // Build your extension here
    );
  }
}
```

O widget `DevToolsExtension` inicializa automaticamente todas as extensões
necessárias para interagir com o DevTools.
De qualquer lugar do seu app web de extensão, você pode acessar os seguintes globais:

* `extensionManager`: um gerenciador para interagir com o DevTools ou com o framework de extensões.
* `serviceManager`: um gerenciador para interagir com o serviço VM conectado, se houver.
* `dtdManager`: um gerenciador para interagir com o Dart Tooling Daemon, se houver.

## Depure sua extensão {:#debug-your-extension}

Ao desenvolver e manter sua extensão do DevTools,
você vai querer executar, depurar e testar o app Flutter web da sua extensão.
Você tem algumas opções diferentes para isso, descritas abaixo.

### Opção A: use o ambiente simulado do DevTools (recomendado para desenvolvimento) {:#option-a-use-the-simulated-devtools-environment-recommended-for-development}

Para fins de depuração,
você provavelmente vai querer usar o "ambiente simulado do DevTools".
Trata-se de um ambiente simulado que permite construir sua extensão
sem precisar desenvolvê-la como um iFrame incorporado no DevTools.
Executar sua extensão dessa forma envolve sua extensão em um ambiente
que simula a conexão entre a extensão e o DevTools.
Ele também dá acesso a hot restart e a um ciclo de desenvolvimento mais rápido.

![Depurando uma extensão com o ambiente simulado do DevTools](/assets/images/docs/tools/devtools/devtools-extension-debugger.png)

1. _Sua extensão do DevTools._
2. _A URI do serviço VM para um app de teste com o qual sua extensão do DevTools vai interagir.
   Esse app deve depender do pacote pai da sua extensão (`package:foo` neste exemplo)._
3. _Botões para executar ações que um usuário pode disparar a partir do DevTools._
4. _Logs mostrando as mensagens que serão enviadas entre sua extensão e o DevTools._

O ambiente simulado é habilitado pelo parâmetro de ambiente `use_simulated_environment`.
Para executar o app web da sua extensão com essa flag habilitada,
adicione uma configuração ao seu arquivo `launch.json` no VS Code:

```json
{
    ...
    "configurations": [
        ...
        {
            "name": "foo_devtools_extension + simulated environment",
            "cwd": "packages/foo_devtools_extension",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=use_simulated_environment=true"
            ],
        },
    ]
}
```

ou inicie seu app pela linha de comando com a flag adicionada:

```console
flutter run -d chrome -dart-define=use_simulated_environment=true
```

### Opção B: use um ambiente real do DevTools {:#option-b-use-a-real-devtools-environment}

Quando você tiver desenvolvido sua extensão até o ponto em que está pronto
para testar suas mudanças em um ambiente real do DevTools,
você precisa executar uma série de etapas de configuração:

<ol>
<li>Desenvolva sua extensão até o ponto em que você esteja pronto para testar
    suas mudanças em um ambiente real do DevTools.
    Compile seu app web Flutter e copie os assets gerados de
    `your_extension_web_app/build/web` para o diretório
    `extension/devtools/build` do seu pacote pub.

    Use o comando `build_and_copy` de `package:devtools_extensions`
    para ajudar nesta etapa.

    ```console
    cd your_extension_web_app;
    flutter pub get;
    dart run devtools_extensions build_and_copy --source=. --dest=path/to/your_pub_package/extension/devtools
    ```

:::note
    Se você estiver usando a estrutura de pacote recomendada para adicionar uma extensão
    a um pacote pub existente,
    o valor de `--dest` deve ser `../your_pub_package/extension/devtools`.
:::

    Para garantir que sua extensão esteja configurada corretamente para ser carregada
    no DevTools, execute o comando `validate` de `package:devtools_extensions`.
    O argumento `--package` deve apontar para a raiz do pacote Dart
    com o qual esta extensão será publicada.

    ```console
    cd your_extension_web_app;
    flutter pub get;
    dart run devtools_extensions validate --package=path/to/your_pub_package
    ```
</li>

<li>Prepare um ambiente de teste com uma dependência do seu pacote pub
    que fornece a extensão.

    No projeto Dart ou Flutter em que você está adicionando uma dependência do seu pacote,
    adicione uma dependência do tipo [`path`][] que aponte para o código-fonte local do seu pacote
    (o pacote que contém o diretório `extension/devtools/` com os assets
    da sua extensão). Feito isso, execute `pub get` no pacote.

    * **Se sua extensão exige um app em execução**,
      então você precisará executar o app que depende da sua extensão.
    * **Se sua extensão não exige um app em execução**,
      então você precisará abrir o projeto Dart ou Flutter de teste
      que depende do seu pacote em uma IDE compatível
      (VS Code ou IntelliJ / Android Studio).

[`path`]: {{site.dart-site}}/tools/pub/dependencies#path-packages
</li>

<li>Inicie o DevTools

    Use uma das seguintes formas para iniciar o DevTools:

    * **Se sua extensão exige um app em execução**,
      você pode abrir o DevTools pela URI que foi impressa
      na linha de comando quando você executou o app de teste,
      ou pela IDE em que você executou o app de teste.
    * **Se sua extensão não exige um app em execução**,
      você pode abrir seu projeto Dart ou Flutter que depende do seu pacote
      em uma IDE compatível. Abra o DevTools a partir da IDE para ver
      sua extensão no navegador.
    * **Se você precisar de mudanças locais ou não lançadas do DevTools**,
      será preciso compilar e executar o DevTools a partir do código-fonte.
      Consulte o [CONTRIBUTING.md][] do DevTools para um guia sobre como fazer isso.
      Você precisará compilar o DevTools com o servidor e o front end
      para testar extensões ([instruções][instructions]).
</li>

<li>Conecte seu app de teste ao DevTools, caso ainda não esteja conectado,
    e você deverá ver uma aba na barra de aplicativos do DevTools para sua extensão.
    O estado habilitado ou desabilitado da sua extensão é gerenciado pelo DevTools,
    que o expõe em um menu **Extensions** no DevTools,
    disponível nos botões de ação no canto superior direito da tela.
</li>
</ol>

Depois de abrir o DevTools,
uma aba na barra de aplicativos do DevTools deve aparecer para sua extensão.
O estado habilitado ou desabilitado da sua extensão é gerenciado pelo DevTools,
que o expõe em um menu "Extensions",
disponível nos botões de ação no canto superior direito da tela.

![Botão do menu de extensões do DevTools](/assets/images/docs/tools/devtools/devtools-extensions-menu-button.png){:width="80%"}

![Menu de extensões do DevTools](/assets/images/docs/tools/devtools/devtools-extensions-menu.png)

[CONTRIBUTING.md]: https://github.com/flutter/devtools/tree/master/packages/devtools_extensions
[instructions]: https://github.com/flutter/devtools/blob/master/CONTRIBUTING.md#development-devtools-server--devtools-flutter-web-app

## Publique seu pacote com uma extensão do DevTools {:#publish-your-package-with-a-devtools-extension}

Para que um pacote forneça uma extensão do DevTools aos seus usuários,
ele precisa ser publicado com o conteúdo esperado no diretório
`your_pub_package/extension/devtools/`
(conforme descrito nas instruções de configuração anteriores).

<ol>
<li>Garanta que o arquivo `extension/devtools/config.yaml` existe
    e está configurado de acordo com as especificações acima.
    Você pode executar o comando `validate` de
    `package:devtools_extensions` para verificar.

 ```console
 cd your_extension_web_app;
 flutter pub get;
 dart run devtools_extensions validate --package=path/to/pkg_providing_your_extension_assets
 ```
</li>

<li>Use o comando `build_and_copy` fornecido por
    `package:devtools_extensions` para compilar sua extensão
    e copiar a saída para o diretório `extension/devtools`:

    ```console
    cd your_extension_web_app;
    flutter pub get;
    dart run devtools_extensions build_and_copy --source=. --dest=path/to/your_pub_package/extension/devtools
    ```
</li>
</ol>

Em seguida, publique seu pacote em [`pub.dev`][]:

```console
flutter pub publish
```

Ao executar `pub publish`,
você verá um aviso se não tiver o arquivo `config.yaml`
e um diretório `build` não vazio, conforme exigido.

Para orientações adicionais sobre a publicação do seu pacote,
acesse o [guia de publicação][publishing guide] do `package:devtools_extensions`.

[`pub.dev`]: {{site.pub}}
[publishing guide]: {{site.pub-pkg}}/devtools_extensions#publish-your-package-with-a-devtools-extension

---

Pronto! Agora,
quando um usuário depender da versão mais recente do seu pacote,
ele terá automaticamente acesso às ferramentas que você fornece
na sua extensão do DevTools.

Você pode achar os links a seguir úteis:

* Para as informações mais recentes sobre este recurso,
  acesse o [README das extensões do DevTools][DevTools Extensions README] no GitHub.
* Para problemas e solicitações de recursos,
  [abra uma issue][file an issue] no rastreador de issues do DevTools.
* Para suporte geral e acesso à comunidade de autores de extensões do DevTools,
  confira o canal do Discord [#devtools-extension-authors][extensions-discord]
  (você precisará primeiro entrar no [servidor do Discord do Flutter][Flutter Discord server]).

[DevTools Extensions README]: https://github.com/flutter/devtools/blob/master/packages/devtools_extensions/README.md
[extensions-discord]: https://discord.com/channels/608014603317936148/1159561514072690739
[file an issue]: https://github.com/flutter/devtools/issues
[Flutter Discord server]: {{site.repo.flutter}}/wiki/Chat
