---
ia-translate: true
title: Deferred components
description: Como criar deferred components para melhor desempenho de download.
---

<?code-excerpt path-base="perf/deferred_components"?>

## Introdução

Flutter tem a capacidade de construir apps que podem
baixar código Dart adicional e assets em tempo de execução.
Isso permite que apps reduzam o tamanho do apk de instalação e baixem
recursos e assets quando necessário pelo usuário.

Nos referimos a cada pacote baixável único de bibliotecas
Dart e assets como um "deferred component".
Para carregar esses componentes, use [imports diferidos do Dart][dart-def-import].
Eles podem ser compilados em bibliotecas compartilhadas AOT split e JavaScript.

:::note
Flutter suporta carregamento diferido, ou "lazy", no Android e na web.
As implementações diferem.
Os [módulos de recurso dinâmico][dynamic feature modules] do Android entregam os
deferred components empacotados como módulos Android.
A web cria esses componentes como arquivos `*.js` separados.
Código diferido não impacta outras plataformas,
que continuam a construir normalmente com todos os deferred
components e assets incluídos no momento da instalação inicial.
:::

Embora você possa diferir o carregamento de módulos,
você deve construir o app inteiro e fazer upload desse app como um único
[Android App Bundle][android-app-bundle] (`*.aab`).
Flutter não suporta despachar atualizações parciais sem fazer novo upload de
novos Android App Bundles para a aplicação inteira.

Flutter realiza carregamento diferido quando você compila seu app
em [modo release ou profile][release or profile mode].
O modo debug trata todos os deferred components como imports regulares.
Os componentes estão presentes na inicialização e carregam imediatamente.
Isso permite que builds de debug façam hot reload.

Para um mergulho mais profundo nos detalhes técnicos de
como este recurso funciona, veja [Deferred Components][]
no [wiki do Flutter][Flutter wiki].

## Como configurar seu projeto para deferred components

As seguintes instruções explicam como configurar seu
app Android para carregamento diferido.

### Passo 1: Dependências e configuração inicial do projeto

<ol>
<li>

Adicione Play Core às dependências do build.gradle do app Android.
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

Se estiver usando a Google Play Store como
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

`io.flutter.app.FlutterPlayStoreSplitApplication` lida
com ambas essas tarefas para você. Se você usar
`FlutterPlayStoreSplitApplication`,
você pode pular para o passo 1.3.

Se sua aplicação Android
é grande ou complexa, você pode querer suportar separadamente
`SplitCompat` e fornecer o
`PlayStoreDynamicFeatureManager` manualmente.

Para suportar `SplitCompat`, há três métodos
(conforme detalhado nos [docs do Android][Android docs]), qualquer um dos quais é válido:

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

Declare `SplitCompatApplication` como a aplicação
subclasse e adicione o código de compatibilidade Flutter de
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
requisições de instalação para deferred components.
Forneça um `PlayStoreDeferredComponentManager` para
o embedder Flutter adicionando o seguinte código
à inicialização do seu app:

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

Opte por deferred components adicionando
a entrada `deferred-components` ao `pubspec.yaml` do app
sob a entrada `flutter`:

```yaml
...
flutter:
  ...
  deferred-components:
  ...
```

A ferramenta `flutter` procura pela entrada `deferred-components`
no `pubspec.yaml` para determinar se o
app deve ser construído como diferido ou não.
Isso pode ser deixado vazio por enquanto, a menos que você já
saiba os componentes desejados e as bibliotecas Dart diferidas
que vão em cada um. Você preencherá esta seção mais tarde
no [passo 3.3][step 3.3] uma vez que `gen_snapshot` produza as loading units.

</li>
</ol>

### Passo 2: Implementando bibliotecas Dart diferidas

Em seguida, implemente bibliotecas Dart carregadas de forma diferida no
código Dart do seu app. A implementação não precisa
estar completa ainda. O exemplo no
resto desta página adiciona um novo widget diferido simples
como placeholder. Você também pode converter código existente
para ser diferido modificando os imports e
protegendo usos de código diferido atrás de `loadLibrary()`
`Futures`.

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
    return Container(
      height: 30,
      width: 30,
      color: Colors.blue,
    );
  }
}
```

</li>

<li>

Importe a nova biblioteca Dart
com a palavra-chave `deferred` no seu app e
chame `loadLibrary()` (veja [carregamento lazy de uma biblioteca][lazily loading a library]).
O seguinte exemplo usa `FutureBuilder`
para esperar o `Future` `loadLibrary` (criado em
`initState`) completar e exibir um
`CircularProgressIndicator` como placeholder.
Quando o `Future` completa, ele retorna o widget `DeferredBox`.
`SomeWidget` pode então ser usado no app normalmente e
nunca tentará acessar o código Dart diferido até que
tenha sido carregado com sucesso.

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
está disponível para uso e completa com erro caso contrário.
Todo uso de símbolos da biblioteca diferida deve ser
protegido atrás de uma chamada `loadLibrary()` completada. Todos os imports
da biblioteca devem ser marcados como `deferred` para que seja
compilada apropriadamente para ser usada em um deferred component.
Se um componente já foi carregado, chamadas adicionais
a `loadLibrary()` completam rapidamente (mas não sincronamente).
A função `loadLibrary()` também pode ser chamada cedo para
disparar um pré-carregamento para ajudar a mascarar o tempo de carregamento.

Você pode encontrar outro exemplo de carregamento de import diferido em
[`lib/deferred_widget.dart` do Flutter Gallery][Flutter Gallery's `lib/deferred_widget.dart`].

</li>
</ol>

### Passo 3: Construindo o app

Use o seguinte comando `flutter` para construir um
app de deferred components:

```console
$ flutter build appbundle
```

Este comando auxilia você validando que seu projeto
está configurado corretamente para construir apps de deferred components.
Por padrão, o build falha se o validador detecta
quaisquer problemas e guia você através de mudanças sugeridas para corrigi-los.

:::note
Você pode optar por não construir deferred components
com a flag `--no-deferred-components`.
Esta flag faz com que todos os assets definidos sob
deferred components sejam tratados como se estivessem
definidos sob a seção assets do `pubspec.yaml`.
Todo código Dart é compilado em uma única biblioteca compartilhada
e chamadas `loadLibrary()` completam no próximo limite do
loop de eventos (o mais rápido possível sendo assíncrono).
Esta flag também é equivalente a omitir a entrada `deferred-components:`
no `pubspec.yaml`.
:::

<ol>
<li><a id="step-3.1"></a>

O comando `flutter build appbundle`
executa o validador e tenta construir o app com
`gen_snapshot` instruído a produzir bibliotecas compartilhadas AOT split
como arquivos `.so` separados. Na primeira execução, o validador provavelmente
falhará ao detectar problemas; a ferramenta faz
recomendações de como configurar o projeto e corrigir esses problemas.

O validador é dividido em duas seções: validação pré-build
e pós-gen_snapshot. Isso ocorre porque qualquer
validação referenciando loading units não pode ser realizada
até que `gen_snapshot` complete e produza um conjunto final
de loading units.

:::note
Você pode optar por fazer a ferramenta tentar construir seu
app sem o validador passando a
flag `--no-validate-deferred-components`.
Isso pode resultar em instruções inesperadas e confusas
para resolver falhas.
Esta flag é destinada a ser usada em
implementações customizadas que não dependem da
implementação padrão baseada na Play-store que o validador verifica.
:::

O validador detecta quaisquer loading units novas, alteradas ou removidas
geradas por `gen_snapshot`.
As loading units atualmente geradas são rastreadas no seu
arquivo `<projectDirectory>/deferred_components_loading_units.yaml`.
Este arquivo deve ser commitado no controle de versão para garantir que
mudanças nas loading units por outros desenvolvedores possam ser detectadas.

O validador também verifica o seguinte no
diretório `android`:

<ul>
<li>

**`<projectDir>/android/app/src/main/res/values/strings.xml`**<br>
Uma entrada para cada deferred component mapeando a chave
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
cada deferred component existe e contém um `build.gradle`
e arquivo `src/main/AndroidManifest.xml`.
Isso apenas verifica existência e não valida
o conteúdo desses arquivos. Se um arquivo não existe,
ele gera um padrão recomendado.

</li>

<li>

**`<projectDir>/android/app/src/main/res/values/AndroidManifest.xml`**<br>
Contém uma entrada meta-data que codifica
o mapeamento entre loading units e o nome do componente ao qual a
loading unit está associada. Este mapeamento é usado pelo
embedder para converter o id interno de loading unit do Dart
para o nome de um deferred component a instalar. Por exemplo:

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

O validador `gen_snapshot` não executará até que o validador
pré-build passe.
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
revisadas para serem apropriadas. A ferramenta não fará quaisquer
mudanças no seu diretório `android/` automaticamente.

</li>

<li><a id="step-3.3"></a>

Uma vez que as loading units
disponíveis sejam geradas e registradas em
`<projectDirectory>/deferred_components_loading_units.yaml`,
é possível configurar totalmente a seção
`deferred-components` do pubspec para que as loading units
sejam atribuídas aos deferred components conforme desejado.
Para continuar com o exemplo da caixa, o arquivo
`deferred_components_loading_units.yaml` gerado conteria:

```yaml
loading-units:
  - id: 2
    libraries:
      - package:MyAppName/box.Dart
```

O id da loading unit ('2' neste caso) é usado
internamente pelo Dart, e pode ser ignorado.
A loading unit base (id '1') não é listada
e contém tudo que não está explicitamente contido
em outra loading unit.

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

Para atribuir uma loading unit a um deferred component,
adicione qualquer lib Dart na loading unit à
seção libraries do módulo de recurso.
Mantenha as seguintes diretrizes em mente:

<ul>
<li>

Loading units não devem ser incluídas
em mais de um componente.

</li>
<li>

Incluir uma biblioteca Dart de uma
loading unit indica que a loading
unit inteira é atribuída ao deferred component.

</li>
<li>

Todas as loading units não atribuídas a
um deferred component são incluídas no componente base,
que sempre existe implicitamente.

</li>
<li>

Loading units atribuídas ao mesmo
deferred component são baixadas, instaladas
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
uma seção assets na configuração do deferred component:

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

Um asset pode ser incluído em múltiplos deferred components,
mas instalar ambos os componentes resulta em um asset replicado.
Componentes apenas de assets também podem ser definidos omitindo a
seção libraries. Esses componentes apenas de assets devem ser
instalados com a classe utilitária [`DeferredComponent`][] em
services em vez de `loadLibrary()`.
Como bibliotecas Dart são empacotadas junto com assets,
se uma biblioteca Dart é carregada com `loadLibrary()`,
quaisquer assets no componente são carregados também.
No entanto, instalar por nome de componente e o utilitário services
não carregará nenhuma biblioteca dart no componente.

Você é livre para incluir assets em qualquer componente,
desde que sejam instalados e carregados quando
forem referenciados pela primeira vez, embora tipicamente,
assets e o código Dart que usa esses assets
sejam melhor empacotados no mesmo componente.

</li>

<li>

Adicione manualmente todos os deferred components
que você definiu no `pubspec.yaml` no
arquivo `android/settings.gradle` como includes.
Por exemplo, se há três deferred components
definidos no pubspec chamados `boxComponent`, `circleComponent`,
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

Um build bem-sucedido nem sempre significa que o app foi
construído conforme pretendido. Cabe a você garantir que todas as loading
units e bibliotecas Dart estejam incluídas da maneira que você pretendeu.
Por exemplo, um erro comum é importar acidentalmente uma
biblioteca Dart sem a palavra-chave `deferred`,
resultando em uma biblioteca diferida sendo compilada como parte da
loading unit base. Neste caso, a biblioteca Dart carregaria
corretamente porque sempre está presente na base,
e a biblioteca não seria separada. Isso pode ser verificado
examinando o arquivo `deferred_components_loading_units.yaml`
para verificar que as loading units geradas são descritas
conforme pretendido.

Ao ajustar as configurações de deferred components,
ou fazer mudanças no Dart que adicionam, modificam ou removem loading units,
você deve esperar que o validador falhe.
Siga os passos [3.1][3.1] até 3.6 (este passo) para aplicar quaisquer
mudanças recomendadas para continuar o build.
</li>
</ol>

### Executando o app localmente

Uma vez que seu app tenha construído com sucesso um arquivo `.aab`,
use o [`bundletool`][] do Android para realizar
testes locais com a flag `--local-testing`.

Para executar o arquivo `.aab` em um dispositivo de teste,
baixe o executável jar bundletool de
[github.com/google/bundletool/releases][] e execute:

```console
$ java -jar bundletool.jar build-apks --bundle=<your_app_project_dir>/build/app/outputs/bundle/release/app-release.aab --output=<your_temp_dir>/app.apks --local-testing

$ java -jar bundletool.jar install-apks --apks=<your_temp_dir>/app.apks
```

Onde `<your_app_project_dir>` é o caminho para o diretório do
projeto do seu app e `<your_temp_dir>` é qualquer diretório temporário
usado para armazenar as saídas do bundletool.
Isso desempacota seu arquivo `.aab` em um arquivo `.apks` e
instala-o no dispositivo. Todos os recursos dinâmicos Android
disponíveis são carregados no dispositivo localmente e
a instalação de deferred components é emulada.

Antes de executar `build-apks` novamente,
remova o arquivo .apks do app existente:

```console
$ rm <your_temp_dir>/app.apks
```

Mudanças na base de código Dart requerem ou incrementar
o ID de build do Android ou desinstalar e reinstalar
o app, pois o Android não atualizará os módulos de recurso
a menos que detecte um novo número de versão.

### Lançando na Google Play Store

O arquivo `.aab` construído pode ser enviado diretamente para
a Play store normalmente. Quando `loadLibrary()` é chamado,
o módulo Android necessário contendo a biblioteca Dart AOT e
assets é baixado pelo motor Flutter usando o
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
