---
ia-translate: true
title: Componentes adiados
description: Como criar componentes adiados para melhorar o desempenho de download.
---

<?code-excerpt path-base="perf/deferred_components"?>

## Introdução

O Flutter tem a capacidade de criar aplicativos que podem baixar
código Dart e ativos adicionais em tempo de execução.
Isso permite que os aplicativos reduzam o tamanho do APK de instalação e
baixem recursos e ativos quando necessário pelo usuário.

Nos referimos a cada pacote de bibliotecas e ativos Dart
exclusivamente para download como um "componente adiado".
Para carregar esses componentes, use [imports adiados do Dart][dart-def-import].
Eles podem ser compilados em bibliotecas compartilhadas AOT e JavaScript divididas.

:::note
O Flutter oferece suporte ao carregamento adiado ou "preguiçoso" no Android
e na web. As implementações diferem.
Os [módulos de recursos dinâmicos][] do Android entregam os componentes
adiados empacotados como módulos Android. A web cria esses componentes
como arquivos `*.js` separados.
O código adiado não afeta outras plataformas, que continuam a ser
construídas normalmente com todos os componentes e ativos adiados incluídos
no tempo de instalação inicial.
:::

Embora você possa adiar o carregamento de módulos, você deve
construir todo o aplicativo e fazer o upload desse aplicativo como um único
[Android App Bundle][android-app-bundle] (`*.aab`).
O Flutter não oferece suporte ao envio de atualizações parciais
sem reenviar novos Android App Bundles para todo o aplicativo.

O Flutter executa o carregamento adiado quando você compila seu aplicativo
no [modo release ou profile][].
O modo debug trata todos os componentes adiados como imports regulares.
Os componentes estão presentes na inicialização e são carregados
imediatamente. Isso permite que os builds de debug façam hot reload.

Para um mergulho mais profundo nos detalhes técnicos de como esse recurso
funciona, consulte [Componentes Adiados][] no [Flutter wiki][].

## Como configurar seu projeto para componentes adiados

As instruções a seguir explicam como configurar seu aplicativo
Android para carregamento adiado.

### Etapa 1: Dependências e configuração inicial do projeto

<ol>
<li>

Adicione o Play Core às dependências build.gradle do aplicativo Android.
Em `android/app/build.gradle`, adicione o seguinte:

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

Se estiver usando a Google Play Store como modelo de distribuição
para recursos dinâmicos, o aplicativo deve oferecer suporte a `SplitCompat`
e fornecer uma instância de um `PlayStoreDeferredComponentManager`.
Ambas as tarefas podem ser realizadas configurando a propriedade
`android:name` no aplicativo em `android/app/src/main/AndroidManifest.xml`
para `io.flutter.embedding.android.FlutterPlayStoreSplitApplication`:

```xml
<manifest ...
  <application
     android:name="io.flutter.embedding.android.FlutterPlayStoreSplitApplication"
        ...
  </application>
</manifest>
```

`io.flutter.app.FlutterPlayStoreSplitApplication` lida com ambas
as tarefas para você. Se você usar `FlutterPlayStoreSplitApplication`,
você pode pular para a etapa 1.3.

Se o seu aplicativo Android for grande ou complexo, você pode
querer oferecer suporte separadamente ao `SplitCompat` e fornecer o
`PlayStoreDynamicFeatureManager` manualmente.

Para suportar `SplitCompat`, existem três métodos (conforme detalhado
na [documentação do Android][]), qualquer um dos quais é válido:

<ul>
<li>

Faça sua classe de aplicativo estender `SplitCompatApplication`:

```java
public class MyApplication extends SplitCompatApplication {
    ...
}
```

</li>

<li>

Chame `SplitCompat.install(this);` no método
`attachBaseContext()`:

```java
@Override
protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    // Emula a instalação de futuros módulos sob demanda usando SplitCompat.
    SplitCompat.install(this);
}
```

</li>

<li>

Declare `SplitCompatApplication` como a subclasse do aplicativo e
adicione o código de compatibilidade do Flutter de `FlutterApplication`
à sua classe de aplicativo:

```xml
<application
    ...
    android:name="com.google.android.play.core.splitcompat.SplitCompatApplication">
</application>
```

</li>
</ul>

O embedder depende de uma instância injetada de `DeferredComponentManager`
para lidar com solicitações de instalação para componentes adiados.
Forneça um `PlayStoreDeferredComponentManager` no embedder do Flutter
adicionando o seguinte código à inicialização do seu aplicativo:

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

Opte por componentes adiados adicionando a entrada
`deferred-components` ao `pubspec.yaml` do aplicativo sob a entrada
`flutter`:

```yaml
...
flutter:
  ...
  deferred-components:
  ...
```

A ferramenta `flutter` procura a entrada `deferred-components` no
`pubspec.yaml` para determinar se o aplicativo deve ser construído
como adiado ou não. Isso pode ser deixado vazio por enquanto, a menos
que você já conheça os componentes desejados e as bibliotecas Dart
adiadas que entram em cada um. Você preencherá esta seção mais tarde na
[etapa 3.3][] depois que `gen_snapshot` produzir as unidades de carregamento.

</li>
</ol>

### Etapa 2: Implementando bibliotecas Dart adiadas

Em seguida, implemente bibliotecas Dart carregadas adiadas no código
Dart do seu aplicativo. A implementação não precisa estar completa
ainda. O exemplo no restante desta página adiciona um novo widget adiado
simples como um placeholder. Você também pode converter o código
existente para ser adiado modificando os imports e protegendo os usos
de código adiado por trás de `Futures` de `loadLibrary()`.

<ol>
<li>

Crie uma nova biblioteca Dart.
Por exemplo, crie um novo widget `DeferredBox` que pode ser baixado em tempo de
execução. Este widget pode ser de qualquer complexidade, mas, para os
propósitos deste guia, crie uma caixa simples como substituto. Para criar
um widget de caixa azul simples, crie `box.dart` com o seguinte conteúdo:

<?code-excerpt "lib/box.dart"?>
```dart title="box.dart"
import 'package:flutter/material.dart';

/// Uma caixa azul simples de 30x30.
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

Importe a nova biblioteca Dart com a palavra-chave `deferred` em seu
aplicativo e chame `loadLibrary()` (consulte [carregando uma biblioteca
preguiçosamente][]). O exemplo a seguir usa `FutureBuilder` para esperar
que o `Future` de `loadLibrary` (criado em `initState`) seja concluído e
exiba um `CircularProgressIndicator` como um placeholder. Quando o
`Future` é concluído, ele retorna o widget `DeferredBox`. `SomeWidget`
pode então ser usado no aplicativo normalmente e nunca tentará acessar o
código Dart adiado até que ele seja carregado com sucesso.

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
            return Text('Erro: ${snapshot.error}');
          }
          return box.DeferredBox();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

A função `loadLibrary()` retorna um `Future<void>` que é concluído com
sucesso quando o código na biblioteca está disponível para uso e é
concluído com um erro caso contrário. Todo o uso de símbolos da
biblioteca adiada deve ser protegido por trás de uma chamada
`loadLibrary()` concluída. Todos os imports da biblioteca devem ser
marcados como `deferred` para que sejam compilados adequadamente para
serem usados em um componente adiado. Se um componente já foi
carregado, chamadas adicionais para `loadLibrary()` são concluídas
rapidamente (mas não de forma síncrona). A função `loadLibrary()`
também pode ser chamada antecipadamente para disparar um pré-carregamento
para ajudar a mascarar o tempo de carregamento.

Você pode encontrar outro exemplo de carregamento de import adiado em
[`lib/deferred_widget.dart` da Flutter Gallery][].

</li>
</ol>

### Etapa 3: Construindo o aplicativo

Use o seguinte comando `flutter` para construir um aplicativo
de componentes adiados:

```console
$ flutter build appbundle
```

Este comando auxilia você, validando se seu projeto está configurado
corretamente para construir aplicativos de componentes adiados.
Por padrão, a build falha se o validador detectar quaisquer problemas e
o guia através das mudanças sugeridas para corrigi-los.

:::note
Você pode optar por não construir componentes adiados com a flag
`--no-deferred-components`. Esta flag faz com que todos os ativos
definidos em componentes adiados sejam tratados como se tivessem sido
definidos na seção de ativos de `pubspec.yaml`. Todo o código Dart é
compilado em uma única biblioteca compartilhada e as chamadas de
`loadLibrary()` são concluídas no próximo limite de loop de eventos
(o mais rápido possível, sendo assíncrono). Esta flag também é
equivalente a omitir a entrada `deferred-components:` em `pubspec.yaml`.
:::

<ol>
<li><a id="step-3.1"></a>

O comando `flutter build appbundle` executa o validador e tenta
construir o aplicativo com `gen_snapshot` instruído a produzir
bibliotecas compartilhadas AOT divididas como arquivos `.so` separados.
Na primeira execução, o validador provavelmente falhará ao detectar
problemas; a ferramenta faz recomendações sobre como configurar o
projeto e corrigir esses problemas.

O validador é dividido em duas seções: pré-build e validação pós-
`gen_snapshot`. Isso ocorre porque qualquer validação que faça
referência a unidades de carregamento não pode ser executada até que
`gen_snapshot` seja concluído e produza um conjunto final de unidades
de carregamento.

:::note
Você pode optar por fazer com que a ferramenta tente construir seu
aplicativo sem o validador passando a flag
`--no-validate-deferred-components`. Isso pode resultar em
instruções inesperadas e confusas para resolver falhas.
Esta flag deve ser usada em implementações personalizadas que não
dependem da implementação padrão baseada na Play Store que o validador verifica.
:::

O validador detecta quaisquer unidades de carregamento novas, alteradas ou
removidas geradas por `gen_snapshot`. As unidades de carregamento geradas
atuais são rastreadas em seu arquivo `<projectDirectory>/deferred_components_loading_units.yaml`.
Este arquivo deve ser verificado no controle de origem para garantir que
as mudanças nas unidades de carregamento por outros desenvolvedores possam
ser detectadas.

O validador também verifica o seguinte no diretório `android`:

<ul>
<li>

**`<projectDir>/android/app/src/main/res/values/strings.xml`**<br>
Uma entrada para cada componente adiado mapeando a chave
`${componentName}Name` para `${componentName}`.
Este recurso de string é usado pelo `AndroidManifest.xml` de cada
módulo de recurso para definir a `propriedade dist:title`.
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
Um módulo de recurso dinâmico do Android para cada componente
adiado existe e contém um arquivo `build.gradle` e
`src/main/AndroidManifest.xml`. Isso verifica apenas a existência e não
valida o conteúdo desses arquivos. Se um arquivo não existir, ele
gerará um recomendado padrão.

</li>

<li>

**`<projectDir>/android/app/src/main/res/values/AndroidManifest.xml`**<br>
Contém uma entrada de metadados que codifica o mapeamento entre as
unidades de carregamento e o nome do componente com o qual a unidade de
carregamento está associada. Este mapeamento é usado pelo embedder para
converter o id interno da unidade de carregamento do Dart para o nome
de um componente adiado a ser instalado. Por exemplo:

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
pré-build seja aprovado.
</li>

<li>

Para cada uma dessas verificações, a ferramenta produz os arquivos
modificados ou novos necessários para passar na verificação. Esses
arquivos são colocados no diretório
`<projectDir>/build/android_deferred_components_setup_files`.
É recomendável que as mudanças sejam aplicadas copiando e
sobrescrevendo os mesmos arquivos no diretório `android` do projeto.
Antes de sobrescrever, o estado atual do projeto deve ser confirmado no
controle de origem e as mudanças recomendadas devem ser revisadas
para serem apropriadas. A ferramenta não fará nenhuma alteração em seu
diretório `android/` automaticamente.

</li>

<li><a id="step-3.3"></a>

Assim que as unidades de carregamento disponíveis forem geradas e
registradas em `<projectDirectory>/deferred_components_loading_units.yaml`,
é possível configurar totalmente a seção `deferred-components` do
`pubspec` para que as unidades de carregamento sejam atribuídas aos
componentes adiados conforme desejado. Para continuar com o exemplo da
caixa, o arquivo gerado `deferred_components_loading_units.yaml`
conteria:

```yaml
loading-units:
  - id: 2
    libraries:
      - package:MyAppName/box.Dart
```

O id da unidade de carregamento ('2' neste caso) é usado internamente pelo
Dart e pode ser ignorado. A unidade de carregamento base (id '1') não
está listada e contém tudo que não está explicitamente contido em
outra unidade de carregamento.

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

Para atribuir uma unidade de carregamento a um componente adiado,
adicione qualquer lib Dart na unidade de carregamento à seção de
bibliotecas do módulo de recurso. Tenha as seguintes diretrizes em
mente:

<ul>
<li>

As unidades de carregamento não devem ser incluídas em mais de um
componente.

</li>
<li>

Incluir uma biblioteca Dart de uma unidade de carregamento indica
que a unidade de carregamento inteira é atribuída ao componente
adiado.

</li>
<li>

Todas as unidades de carregamento não atribuídas a um componente
adiado são incluídas no componente base, que sempre existe
implicitamente.

</li>
<li>

As unidades de carregamento atribuídas ao mesmo componente
adiado são baixadas, instaladas e enviadas juntas.

</li>
<li>

O componente base é implícito e não precisa ser definido no
pubspec.

</li>
</ul>
</li>

<li>

Os ativos também podem ser incluídos adicionando uma seção de ativos
na configuração do componente adiado:

```yaml
  deferred-components:
    - name: boxComponent
      libraries:
        - package:MyAppName/box.Dart
      assets:
        - assets/image.jpg
        - assets/picture.png
          # diretório curinga
        - assets/gallery/
```

Um ativo pode ser incluído em vários componentes adiados, mas a
instalação de ambos os componentes resulta em um ativo replicado.
Componentes somente de ativos também podem ser definidos omitindo a
seção de bibliotecas. Esses componentes somente de ativos devem ser
instalados com a classe de utilitário [`DeferredComponent`][] em
services, em vez de `loadLibrary()`. Como as libs Dart são
empacotadas junto com os ativos, se uma biblioteca Dart for carregada
com `loadLibrary()`, todos os ativos no componente também serão
carregados. No entanto, a instalação pelo nome do componente e pela
utilitário de serviços não carregará nenhuma biblioteca Dart no
componente.

Você pode incluir ativos em qualquer componente, contanto que eles
sejam instalados e carregados quando forem referenciados pela
primeira vez, embora normalmente os ativos e o código Dart que usa
esses ativos sejam melhor compactados no mesmo componente.

</li>

<li>

Adicione manualmente todos os componentes adiados que você definiu em
`pubspec.yaml` no arquivo `android/settings.gradle` como includes.
Por exemplo, se houver três componentes adiados definidos no pubspec
chamados `boxComponent`, `circleComponent` e `assetComponent`,
certifique-se de que `android/settings.gradle` contenha o seguinte:

```groovy
include ':app', ':boxComponent', ':circleComponent', ':assetComponent'
...
```

</li>

<li>

Repita as etapas [3.1][] a 3.6 (esta etapa) até que todas as
recomendações do validador sejam tratadas e a ferramenta seja
executada sem mais recomendações.

Quando bem-sucedido, este comando gera um arquivo `app-release.aab` em
`build/app/outputs/bundle/release`.

Uma build bem-sucedida nem sempre significa que o aplicativo foi
construído como pretendido. Cabe a você garantir que todas as unidades
de carregamento e bibliotecas Dart sejam incluídas da maneira que você
pretendia. Por exemplo, um erro comum é importar acidentalmente uma
biblioteca Dart sem a palavra-chave `deferred`, resultando em uma
biblioteca adiada sendo compilada como parte da unidade de carregamento
base. Nesse caso, a lib Dart seria carregada corretamente porque está
sempre presente na base, e a lib não seria dividida. Isso pode ser
verificado examinando o arquivo `deferred_components_loading_units.yaml`
para verificar se as unidades de carregamento geradas são descritas
como pretendido.

Ao ajustar as configurações de componentes adiados ou fazer alterações
no Dart que adicionam, modificam ou removem unidades de carregamento,
você deve esperar que o validador falhe. Siga as etapas [3.1][] a
3.6 (esta etapa) para aplicar quaisquer mudanças recomendadas para
continuar a build.
</li>
</ol>

### Executando o aplicativo localmente

Depois que seu aplicativo tiver construído com sucesso um arquivo
`.aab`, use o [`bundletool`][] do Android para realizar testes
locais com a flag `--local-testing`.

Para executar o arquivo `.aab` em um dispositivo de teste, baixe o
executável jar do bundletool de [github.com/google/bundletool/releases][]
e execute:

```console
$ java -jar bundletool.jar build-apks --bundle=<seu_diretorio_de_projeto_app>/build/app/outputs/bundle/release/app-release.aab --output=<seu_diretorio_temp>/app.apks --local-testing

$ java -jar bundletool.jar install-apks --apks=<seu_diretorio_temp>/app.apks
```

Onde `<seu_diretorio_de_projeto_app>` é o caminho para o diretório do
projeto do seu aplicativo e `<seu_diretorio_temp>` é qualquer diretório
temporário usado para armazenar as saídas do bundletool. Isso descompacta
seu arquivo `.aab` em um arquivo `.apks` e o instala no dispositivo.
Todos os recursos dinâmicos do Android disponíveis são carregados no
dispositivo localmente e a instalação de componentes adiados é emulada.

Antes de executar o `build-apks` novamente, remova o arquivo .apks
do aplicativo existente:

```console
$ rm <seu_diretorio_temp>/app.apks
```

As alterações na base de código Dart exigem o incremento do ID de build
do Android ou a desinstalação e reinstalação do aplicativo, pois o
Android não atualizará os módulos de recursos, a menos que detecte um
novo número de versão.

### Publicando na Google Play Store

O arquivo `.aab` construído pode ser carregado diretamente na Play
Store normalmente. Quando `loadLibrary()` é chamado, o módulo Android
necessário contendo a biblioteca Dart AOT e os ativos é baixado pelo
mecanismo Flutter usando o recurso de entrega da Play Store.

[3.1]: #step-3.1
[Documentação do Android]: {{site.android-dev}}/guide/playcore/feature-delivery#declare_splitcompatapplication_in_the_manifest
[`bundletool`]: {{site.android-dev}}/studio/command-line/bundletool
[Componentes Adiados]: {{site.repo.flutter}}/wiki/Deferred-Components
[`DeferredComponent`]: {{site.api}}/flutter/services/DeferredComponent-class.html
[módulos de recursos dinâmicos]: {{site.android-dev}}/guide/playcore/feature-delivery
[`lib/deferred_widget.dart` da Flutter Gallery]: {{site.repo.gallery-archive}}/blob/main/lib/deferred_widget.dart
[Flutter wiki]: {{site.repo.flutter}}/tree/master/docs
[github.com/google/bundletool/releases]: {{site.github}}/google/bundletool/releases
[carregando uma biblioteca preguiçosamente]: {{site.dart-site}}/language/libraries#lazily-loading-a-library
[modo release ou profile]: /testing/build-modes
[etapa 3.3]: #step-3.3
[android-app-bundle]: {{site.android-dev}}/guide/app-bundle
[dart-def-import]: https://dart.dev/language/libraries#lazily-loading-a-library
