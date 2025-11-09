---
ia-translate: true
title: Componentes diferidos para Android e web
description: Como criar componentes diferidos para melhor performance de download.
---

<?code-excerpt path-base="perf/deferred_components"?>

## Introdução

Com Flutter, apps Android e web têm a capacidade de baixar componentes
diferidos (código e assets adicionais) enquanto o app já está em execução. Isso
é útil se você tem um app grande e só quer instalar componentes se e
quando eles são necessários pelo usuário.

Embora o Flutter suporte carregamento diferido no Android e na web, as
implementações diferem. Ambas requerem [importações diferidas do Dart][dart-def-import].

*   Os [módulos de recursos dinâmicos][dynamic feature modules] do Android entregam os
    componentes diferidos empacotados como módulos Android.

    Ao construir para Android, embora você possa adiar o carregamento de módulos,
    você deve construir o app inteiro e fazer upload desse app como um único
    [Android App Bundle][android-app-bundle] (AAB).
    O Flutter não suporta despachar atualizações parciais sem reenviar
    novos Android App Bundles para a aplicação inteira.

    O Flutter realiza carregamento diferido quando você compila seu app Android
    em [modo release ou profile][release or profile mode], mas o modo debug trata todos os
    componentes diferidos como importações regulares.

*   A web cria componentes diferidos como arquivos `*.js` separados.

Para um mergulho mais profundo nos detalhes técnicos de
como este recurso funciona, veja [Deferred Components][Deferred Components]
no [Flutter wiki][Flutter wiki].

## Como configurar seu projeto Android para componentes diferidos

As seguintes instruções explicam como configurar seu
app Android para carregamento diferido.

### Passo 1: Dependências e configuração inicial do projeto

<ol>
<li>

Adicione Play Core às dependências do build.gradle
do app Android.
Em `android/app/build.gradle` adicione o seguinte:

```groovy
...
dependencies {
  ...
  implementation "com.google.android.play:core:1.8.0"
  ...
}
```
</li>

<li>

Se estiver usando a Google Play Store como o
modelo de distribuição para recursos dinâmicos,
o app deve suportar `SplitCompat` e fornecer uma instância
de um `PlayStoreDeferredComponentManager`.
Ambas essas tarefas podem ser realizadas definindo
a propriedade `android:name` na aplicação em
`android/app/src/main/AndroidManifest.xml` para
`io.flutter.embedding.android.FlutterPlayStoreSplitApplication`:

```xml
<manifest ...
  <application
     android:name="io.flutter.embedding.android.FlutterPlayStoreSplitApplication"
        ...
  </application>
</manifest>
```

`io.flutter.app.FlutterPlayStoreSplitApplication` lida com
ambas essas tarefas para você. Se você usar
`FlutterPlayStoreSplitApplication`,
você pode pular para o passo 1.3.

Se sua aplicação Android
é grande ou complexa, você pode querer suportar separadamente
`SplitCompat` e fornecer o
`PlayStoreDynamicFeatureManager` manualmente.

Para suportar `SplitCompat`, existem três métodos
(conforme detalhado na [documentação do Android][Android docs]), qualquer um dos quais é válido:

<ul>
<li>

Faça sua classe de aplicação estender `SplitCompatApplication`:

```java
public class MyApplication extends SplitCompatApplication {
    ...
}
```

</li>

<li>

Chame `SplitCompat.install(this);`
no método `attachBaseContext()`:

```java
@Override
protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    // Emulates installation of future on demand modules using SplitCompat.
    SplitCompat.install(this);
}
```

</li>

<li>

Declare `SplitCompatApplication` como a subclasse da aplicação
e adicione o código de compatibilidade do Flutter de
`FlutterApplication` à sua classe de aplicação:

```xml
<application
    ...
    android:name="com.google.android.play.core.splitcompat.SplitCompatApplication">
</application>
```

</li>
</ul>

O embedder depende de uma instância injetada de
`DeferredComponentManager` para lidar com
solicitações de instalação para componentes diferidos.
Forneça um `PlayStoreDeferredComponentManager` no
embedder do Flutter adicionando o seguinte código
à sua inicialização do app:

```java
import io.flutter.embedding.engine.dynamicfeatures.PlayStoreDeferredComponentManager;
import io.flutter.FlutterInjector;
...
PlayStoreDeferredComponentManager deferredComponentManager = new
  PlayStoreDeferredComponentManager(this, null);
FlutterInjector.setInstance(new FlutterInjector.Builder()
    .setDeferredComponentManager(deferredComponentManager).build());
```

</li>

<li>

Opte por componentes diferidos adicionando
a entrada `deferred-components` ao `pubspec.yaml` do app
sob a entrada `flutter`:

```yaml
...
flutter:
  ...
  deferred-components:
  ...
```

A ferramenta `flutter` procura a entrada `deferred-components`
no `pubspec.yaml` para determinar se o
app deve ser construído como diferido ou não.
Isso pode ser deixado vazio por enquanto, a menos que você já
saiba os componentes desejados e as bibliotecas Dart diferidas
que vão em cada um. Você preencherá esta seção mais tarde
no [passo 3.3][step 3.3] uma vez que `gen_snapshot` produza as unidades de carregamento.

</li>
</ol>

### Passo 2: Implementando bibliotecas Dart diferidas

Em seguida, implemente bibliotecas Dart de carregamento diferido no
código Dart do seu app. A implementação não precisa
estar completa ainda. O exemplo no
resto desta página adiciona um novo widget diferido simples
como placeholder. Você também pode converter código existente
para ser diferido modificando as importações e
protegendo usos de código diferido atrás de `Futures`
`loadLibrary()`.

<ol>
<li>

Crie uma nova biblioteca Dart.
Por exemplo, crie um novo widget `DeferredBox` que
pode ser baixado em tempo de execução.
Este widget pode ser de qualquer complexidade mas,
para os propósitos deste guia,
crie uma caixa simples como substituto.
Para criar um widget de caixa azul simples,
crie `box.dart` com o seguinte conteúdo:

<?code-excerpt "lib/box.dart"?>
```dart title="box.dart"
import 'package:flutter/material.dart';

/// A simple blue 30x30 box.
class DeferredBox extends StatelessWidget {
  const DeferredBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 30, color: Colors.blue);
  }
}
```

</li>

<li>

Importe a nova biblioteca Dart
com a palavra-chave `deferred` em seu app e
chame `loadLibrary()` (veja [carregando uma biblioteca preguiçosamente][lazily loading a library]).
O exemplo a seguir usa `FutureBuilder`
para esperar o `Future` `loadLibrary` (criado em
`initState`) completar e exibir um
`CircularProgressIndicator` como placeholder.
Quando o `Future` completa, ele retorna o widget `DeferredBox`.
`SomeWidget` pode então ser usado no app normalmente e
nunca tentará acessar o código Dart diferido até
que ele tenha carregado com sucesso.

<?code-excerpt "lib/use_deferred_box.dart"?>
```dart
import 'package:flutter/material.dart';
import 'box.dart' deferred as box;

class SomeWidget extends StatefulWidget {
  const SomeWidget({super.key});

  @override
  State<SomeWidget> createState() => _SomeWidgetState();
}

class _SomeWidgetState extends State<SomeWidget> {
  late Future<void> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = box.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _libraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return box.DeferredBox();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

A função `loadLibrary()` retorna um `Future<void>`
que completa com sucesso quando o código na biblioteca
está disponível para uso e completa com um erro caso contrário.
Todo uso de símbolos da biblioteca diferida deve ser
protegido atrás de uma chamada `loadLibrary()` completada. Todas as importações
da biblioteca devem ser marcadas como `deferred` para ela ser
compilada apropriadamente para ser usada em um componente diferido.
Se um componente já foi carregado, chamadas adicionais
a `loadLibrary()` completam rapidamente (mas não sincronamente).
A função `loadLibrary()` também pode ser chamada cedo para
disparar um pré-carregamento para ajudar a mascarar o tempo de carregamento.

Você pode encontrar outro exemplo de carregamento de importação diferida em
[`lib/deferred_widget.dart` da Flutter Gallery][Flutter Gallery's `lib/deferred_widget.dart`].

</li>
</ol>

### Passo 3: Construindo o app

Use o seguinte comando `flutter` para construir um
app de componentes diferidos:

```console
$ flutter build appbundle
```

Este comando auxilia você validando que seu projeto
está configurado corretamente para construir apps de componentes diferidos.
Por padrão, a construção falha se o validador detectar
quaisquer problemas e guia você através de mudanças sugeridas para corrigi-los.

:::note
Você pode optar por não construir componentes diferidos
com a flag `--no-deferred-components`.
Esta flag faz com que todos os assets definidos sob
componentes diferidos sejam tratados como se fossem
definidos na seção de assets do `pubspec.yaml`.
Todo código Dart é compilado em uma única biblioteca compartilhada
e chamadas `loadLibrary()` completam no próximo limite do
loop de eventos (o mais rápido possível enquanto sendo assíncrono).
Esta flag também é equivalente a omitir a entrada `deferred-components:`
no `pubspec.yaml`.
:::

<ol>
<li><a id="step-3.1"></a>

O comando `flutter build appbundle`
executa o validador e tenta construir o app com
`gen_snapshot` instruído a produzir bibliotecas compartilhadas AOT divididas
como arquivos SO separados. Na primeira execução, o validador provavelmente
falhará ao detectar problemas; a ferramenta faz
recomendações de como configurar o projeto e corrigir esses problemas.

O validador é dividido em duas seções: validação
pré-build e pós-gen_snapshot. Isso ocorre porque qualquer
validação referenciando unidades de carregamento não pode ser realizada
até que `gen_snapshot` complete e produza um conjunto final
de unidades de carregamento.

:::note
Você pode optar por fazer a ferramenta tentar construir seu
app sem o validador passando a
flag `--no-validate-deferred-components`.
Isso pode resultar em instruções inesperadas e confusas
para resolver falhas.
Esta flag é destinada a ser usada em
implementações customizadas que não dependem da
implementação padrão baseada em Play-store que o validador verifica.
:::

O validador detecta quaisquer unidades de carregamento novas,
alteradas ou removidas geradas por `gen_snapshot`.
As unidades de carregamento geradas atualmente são rastreadas em seu
arquivo `<projectDirectory>/deferred_components_loading_units.yaml`.
Este arquivo deve ser commitado no controle de versão para garantir que
mudanças nas unidades de carregamento por outros desenvolvedores possam ser capturadas.

O validador também verifica o seguinte no
diretório `android`:

<ul>
<li>

**`<projectDir>/android/app/src/main/res/values/strings.xml`**<br>
Uma entrada para cada componente diferido mapeando a chave
`${componentName}Name` para `${componentName}`.
Este recurso de string é usado pelo `AndroidManifest.xml`
de cada módulo de recurso para definir a propriedade `dist:title`.
Por exemplo:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
  ...
  <string name="boxComponentName">boxComponent</string>
</resources>
```

</li>

<li>

**`<projectDir>/android/<componentName>`**<br>
Um módulo de recurso dinâmico Android para
cada componente diferido existe e contém um arquivo `build.gradle`
e `src/main/AndroidManifest.xml`.
Isso verifica apenas a existência e não valida
o conteúdo desses arquivos. Se um arquivo não existir,
ele gera um padrão recomendado.

</li>

<li>

**`<projectDir>/android/app/src/main/res/values/AndroidManifest.xml`**<br>
Contém uma entrada meta-data que codifica
o mapeamento entre unidades de carregamento e o nome do componente com o qual a
unidade de carregamento está associada. Este mapeamento é usado pelo
embedder para converter o id de unidade de carregamento interno do Dart
para o nome de um componente diferido a instalar. Por exemplo:

```xml
...
<application
    android:label="MyApp"
    android:name="io.flutter.app.FlutterPlayStoreSplitApplication"
    android:icon="@mipmap/ic_launcher">
    ...
    <meta-data android:name="io.flutter.embedding.engine.deferredcomponents.DeferredComponentManager.loadingUnitMapping" android:value="2:boxComponent"/>
</application>
...
```

</li>
</ul>

O validador `gen_snapshot` não será executado até que o validador
de pré-build passe.
</li>

<li>

Para cada uma dessas verificações,
a ferramenta produz os arquivos modificados ou novos
necessários para passar na verificação.
Esses arquivos são colocados no
diretório `<projectDir>/build/android_deferred_components_setup_files`.
É recomendado que as mudanças sejam aplicadas
copiando e sobrescrevendo os mesmos arquivos no
diretório `android` do projeto. Antes de sobrescrever,
o estado atual do projeto deve ser commitado no
controle de versão e as mudanças recomendadas devem ser
revisadas para serem apropriadas. A ferramenta não fará nenhuma
mudança em seu diretório `android/` automaticamente.

</li>

<li><a id="step-3.3"></a>

Uma vez que as unidades de
carregamento disponíveis sejam geradas e registradas em
`<projectDirectory>/deferred_components_loading_units.yaml`,
é possível configurar totalmente a seção
`deferred-components` do pubspec para que as unidades de carregamento
sejam atribuídas aos componentes diferidos como desejado.
Para continuar com o exemplo da caixa, o arquivo gerado
`deferred_components_loading_units.yaml` conteria:

```yaml
loading-units:
  - id: 2
    libraries:
      - package:MyAppName/box.Dart
```

O id da unidade de carregamento ('2' neste caso) é usado
internamente pelo Dart, e pode ser ignorado.
A unidade de carregamento base (id '1') não está listada
e contém tudo que não está explicitamente contido
em outra unidade de carregamento.

Você pode agora adicionar o seguinte ao `pubspec.yaml`:

```yaml
...
flutter:
  ...
  deferred-components:
    - name: boxComponent
      libraries:
        - package:MyAppName/box.Dart
  ...
```

Para atribuir uma unidade de carregamento a um componente diferido,
adicione qualquer biblioteca Dart na unidade de carregamento na
seção libraries do módulo de recurso.
Mantenha as seguintes diretrizes em mente:

<ul>
<li>

Unidades de carregamento não devem ser incluídas
em mais de um componente.

</li>
<li>

Incluir uma biblioteca Dart de uma
unidade de carregamento indica que a unidade de carregamento inteira
é atribuída ao componente diferido.

</li>
<li>

Todas as unidades de carregamento não atribuídas a
um componente diferido são incluídas no componente base,
que sempre existe implicitamente.

</li>
<li>

Unidades de carregamento atribuídas ao mesmo
componente diferido são baixadas, instaladas,
e enviadas juntas.

</li>
<li>

O componente base é implícito e
não precisa ser definido no pubspec.

</li>
</ul>
</li>

<li>

Assets também podem ser incluídos adicionando
uma seção assets na configuração do componente diferido:

```yaml
  deferred-components:
    - name: boxComponent
      libraries:
        - package:MyAppName/box.Dart
      assets:
        - assets/image.jpg
        - assets/picture.png
          # wildcard directory
        - assets/gallery/
```

Um asset pode ser incluído em múltiplos componentes diferidos,
mas instalar ambos os componentes resulta em um asset replicado.
Componentes apenas de assets também podem ser definidos omitindo a
seção libraries. Esses componentes apenas de assets devem ser
instalados com a classe utilitária [`DeferredComponent`][`DeferredComponent`] em
services ao invés de `loadLibrary()`.
Como bibliotecas Dart são empacotadas junto com assets,
se uma biblioteca Dart é carregada com `loadLibrary()`,
quaisquer assets no componente são carregados também.
No entanto, instalar por nome de componente e o utilitário de services
não carregará nenhuma biblioteca Dart no componente.

Você é livre para incluir assets em qualquer componente,
desde que eles sejam instalados e carregados quando
são referenciados pela primeira vez, embora tipicamente,
assets e o código Dart que usa esses assets
sejam melhor empacotados no mesmo componente.

</li>

<li>

Adicione manualmente todos os componentes diferidos
que você definiu em `pubspec.yaml` no
arquivo `android/settings.gradle` como includes.
Por exemplo, se há três componentes diferidos
definidos no pubspec chamados, `boxComponent`, `circleComponent`,
e `assetComponent`, garanta que `android/settings.gradle`
contenha o seguinte:

```groovy
include ':app', ':boxComponent', ':circleComponent', ':assetComponent'
...
```

</li>

<li>

Repita os passos [3.1][3.1] até 3.6 (este passo)
até que todas as recomendações do validador sejam tratadas e a ferramenta
execute sem mais recomendações.

Quando bem-sucedido, este comando produz um arquivo `app-release.aab`
em `build/app/outputs/bundle/release`.

Uma construção bem-sucedida nem sempre significa que o app foi
construído como pretendido. Cabe a você garantir que todas as unidades de
carregamento e bibliotecas Dart estejam incluídas da maneira que você pretendia.
Por exemplo, um erro comum é importar acidentalmente uma
biblioteca Dart sem a palavra-chave `deferred`,
resultando em uma biblioteca diferida sendo compilada como parte da
unidade de carregamento base. Neste caso, a biblioteca Dart
carregaria corretamente porque está sempre presente na base,
e a biblioteca não seria dividida. Isso pode ser verificado
examinando o arquivo `deferred_components_loading_units.yaml`
para verificar que as unidades de carregamento geradas são descritas
como pretendido.

Ao ajustar as configurações de componentes diferidos,
ou fazer mudanças Dart que adicionam, modificam ou removem unidades de carregamento,
você deve esperar que o validador falhe.
Siga os passos [3.1][3.1] até 3.6 (este passo) para aplicar quaisquer
mudanças recomendadas para continuar a construção.
</li>
</ol>

### Executando o app localmente

Uma vez que seu app tenha construído com sucesso um arquivo AAB,
use o [`bundletool`][`bundletool`] do Android para realizar
testes locais com a flag `--local-testing`.

Para executar o arquivo AAB em um dispositivo de teste,
baixe o executável jar bundletool de
[github.com/google/bundletool/releases][github.com/google/bundletool/releases] e execute:

```console
$ java -jar bundletool.jar build-apks --bundle=<your_app_project_dir>/build/app/outputs/bundle/release/app-release.aab --output=<your_temp_dir>/app.apks --local-testing

$ java -jar bundletool.jar install-apks --apks=<your_temp_dir>/app.apks
```

Onde `<your_app_project_dir>` é o caminho para o
diretório do projeto do seu app e `<your_temp_dir>` é qualquer diretório
temporário usado para armazenar as saídas do bundletool.
Isso desempacota seu arquivo AAB em um arquivo APK e
o instala no dispositivo. Todos os recursos dinâmicos Android
disponíveis são carregados no dispositivo localmente e
a instalação de componentes diferidos é emulada.

Antes de executar `build-apks` novamente,
remova o arquivo APK do app existente:

```console
$ rm <your_temp_dir>/app.apks
```

Mudanças na base de código Dart requerem incrementar
o ID de build do Android ou desinstalar e reinstalar
o app, já que o Android não atualizará os módulos de recurso
a menos que detecte um novo número de versão.

### Lançamento na Google Play Store

O arquivo AAB construído pode ser enviado diretamente para
a Play store normalmente. Quando `loadLibrary()` é chamado,
o módulo Android necessário contendo a biblioteca Dart AOT e
assets é baixado pelo engine Flutter usando o
recurso de entrega da Play store.


[3.1]: #step-3.1
[Android docs]: {{site.android-dev}}/guide/playcore/feature-delivery#declare_splitcompatapplication_in_the_manifest
[`bundletool`]: {{site.android-dev}}/studio/command-line/bundletool
[Deferred Components]: {{site.repo.flutter}}/wiki/Deferred-Components
[`DeferredComponent`]: {{site.api}}/flutter/services/DeferredComponent-class.html
[dynamic feature modules]: {{site.android-dev}}/guide/playcore/feature-delivery
[Flutter Gallery's `lib/deferred_widget.dart`]: {{site.repo.gallery-archive}}/blob/main/lib/deferred_widget.dart
[Flutter wiki]: {{site.repo.flutter}}/tree/main/docs
[github.com/google/bundletool/releases]: {{site.github}}/google/bundletool/releases
[lazily loading a library]: {{site.dart-site}}/language/libraries#lazily-loading-a-library
[release or profile mode]: /testing/build-modes
[step 3.3]: #step-3.3
[android-app-bundle]: {{site.android-dev}}/guide/app-bundle
[dart-def-import]: https://dart.dev/language/libraries#lazily-loading-a-library
