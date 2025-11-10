---
title: Internacionalizando apps Flutter
shortTitle: i18n
description: Como internacionalizar seu app Flutter.
ia-translate: true
---

<?code-excerpt path-base="internationalization"?>

:::secondary O que você aprenderá
* Como rastrear o locale do dispositivo (a linguagem preferida do usuário).
* Como habilitar widgets Material ou Cupertino específicos de locale.
* Como gerenciar valores de app específicos de locale.
* Como definir os locales que um app suporta.
:::

Se seu app pode ser implantado para usuários que falam outro
idioma, então você precisará internacionalizá-lo.
Isso significa que você precisa escrever o app de forma que torne
possível localizar valores como texto e layouts
para cada idioma ou locale que o app suporta.
O Flutter fornece widgets e classes que ajudam com
internacionalização e as bibliotecas Flutter
em si são internacionalizadas.

Esta página cobre conceitos e fluxos de trabalho necessários para
localizar um aplicativo Flutter usando as
classes `MaterialApp` e `CupertinoApp`,
já que a maioria dos apps é escrita dessa forma.
No entanto, aplicativos escritos usando a classe de nível inferior
`WidgetsApp` também podem ser internacionalizados
usando as mesmas classes e lógica.

## Introdução às localizações no Flutter

Esta seção fornece um tutorial sobre como criar e
internacionalizar um novo aplicativo Flutter,
juntamente com qualquer configuração adicional
que uma plataforma alvo possa requerer.

Você pode encontrar o código-fonte deste exemplo em
[`gen_l10n_example`][].

[`gen_l10n_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/gen_l10n_example

### Configurando um app internacionalizado: o pacote Flutter<wbr>_localizations {:#setting-up}

Por padrão, o Flutter fornece apenas localizações em inglês dos EUA.
Para adicionar suporte para outros idiomas,
um aplicativo deve especificar propriedades adicionais
do `MaterialApp` (ou `CupertinoApp`),
e incluir um pacote chamado `flutter_localizations`.

Para começar, crie um novo aplicativo Flutter
em um diretório de sua escolha com o comando `flutter create`.

```console
$ flutter create <name_of_flutter_app>
```

Para usar o `flutter_localizations`,
adicione o pacote como uma dependência ao seu arquivo `pubspec.yaml`,
assim como o pacote `intl`:

```console
$ flutter pub add flutter_localizations --sdk=flutter
$ flutter pub add intl:any
```

Isso cria um arquivo `pubspec.yml` com as seguintes entradas:

<?code-excerpt "gen_l10n_example/pubspec.yaml (flutter-localizations)"?>
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
```

Em seguida, importe a biblioteca `flutter_localizations` e especifique
`localizationsDelegates` e `supportedLocales` para
seu `MaterialApp` ou `CupertinoApp`:

<?code-excerpt "gen_l10n_example/lib/main.dart (localization-delegates-import)"?>
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
```

<?code-excerpt "gen_l10n_example/lib/main.dart (material-app)" remove="AppLocalizations.delegate"?>
```dart
return const MaterialApp(
  title: 'Localizations Sample App',
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'), // English
    Locale('es'), // Spanish
  ],
  home: MyHomePage(),
);
```

Após introduzir o pacote `flutter_localizations`
e adicionar o código anterior,
os pacotes `Material` e `Cupertino`
agora devem estar corretamente localizados em
um dos locales suportados.
Os widgets devem ser adaptados às mensagens localizadas,
juntamente com o layout correto da esquerda para a direita ou da direita para a esquerda.

Tente mudar o locale da plataforma alvo para
espanhol (`es`) e as mensagens devem ser localizadas.

Apps baseados em `WidgetsApp` são similares, exceto que o
`GlobalMaterialLocalizations.delegate` não é necessário.

O construtor completo `Locale.fromSubtags` é preferível
pois suporta [`scriptCode`][], embora o construtor padrão `Locale`
ainda seja totalmente válido.

[`scriptCode`]: {{site.api}}/flutter/package-intl_locale/Locale/scriptCode.html

Os elementos da lista `localizationsDelegates` são
factories que produzem coleções de valores localizados.
`GlobalMaterialLocalizations.delegate` fornece strings
localizadas e outros valores para a biblioteca Material Components.
`GlobalWidgetsLocalizations.delegate`
define a direção padrão do texto,
da esquerda para a direita ou da direita para a esquerda, para a biblioteca de widgets.

Mais informações sobre essas propriedades do app, os tipos dos quais elas
dependem, e como os apps Flutter internacionalizados são tipicamente
estruturados, são cobertas nesta página.

[language-count]: {{site.api}}/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html

<a id="overriding-locale"></a>
### Substituindo o locale

`Localizations.override` é um construtor factory
para o widget `Localizations` que permite
a situação (tipicamente rara) onde uma seção do seu aplicativo
precisa ser localizada para um locale diferente do locale
configurado para o seu dispositivo.

Para observar este comportamento, adicione uma chamada a `Localizations.override`
e um `CalendarDatePicker` simples:

<?code-excerpt "gen_l10n_example/lib/examples.dart (date-picker)"?>
```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Add the following code
          Localizations.override(
            context: context,
            locale: const Locale('es'),
            // Using a Builder to get the correct BuildContext.
            // Alternatively, you can create a new widget and Localizations.override
            // will pass the updated BuildContext to the new widget.
            child: Builder(
              builder: (context) {
                // A toy example for an internationalized Material widget.
                return CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateChanged: (value) {},
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
```

Faça hot reload do app e o widget `CalendarDatePicker`
deve ser renderizado novamente em espanhol.

<a id="adding-localized-messages"></a>
### Adicionando suas próprias mensagens localizadas

Após adicionar o pacote `flutter_localizations`,
você pode configurar a localização.
Para adicionar texto localizado ao seu aplicativo,
complete as seguintes instruções:

1. Adicione o pacote `intl` como uma dependência, puxando
   a versão fixada pelo `flutter_localizations`:

   ```console
   $ flutter pub add intl:any
   ```

2. Abra o arquivo `pubspec.yaml` e habilite a flag `generate`.
   Esta flag é encontrada na seção `flutter` no arquivo pubspec.

   <?code-excerpt "gen_l10n_example/pubspec.yaml (generate)"?>
   ```yaml
   # The following section is specific to Flutter.
   flutter:
     generate: true # Add this line
   ```

3. Adicione um novo arquivo yaml ao diretório raiz do projeto Flutter.
   Nomeie este arquivo como `l10n.yaml` e inclua o seguinte conteúdo:

   <?code-excerpt "gen_l10n_example/l10n.yaml"?>
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   ```

   Este arquivo configura a ferramenta de localização.
   Neste exemplo, você fez o seguinte:

   * Colocou os arquivos de entrada [App Resource Bundle][] (`.arb`) em
     `${FLUTTER_PROJECT}/lib/l10n`.
     Os `.arb` fornecem recursos de localização para seu app.
   * Definiu o template em inglês como `app_en.arb`.
   * Disse ao Flutter para gerar localizações no
     arquivo `app_localizations.dart`.

4. Em `${FLUTTER_PROJECT}/lib/l10n`,
   adicione o arquivo de template `app_en.arb`. Por exemplo:

   <?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" take="5" replace="/},/}\n}/g"?>
   ```json
   {
     "helloWorld": "Hello World!",
     "@helloWorld": {
       "description": "The conventional newborn programmer greeting"
     }
   }
   ```

5. Adicione outro arquivo de bundle chamado `app_es.arb` no mesmo diretório.
   Neste arquivo, adicione a tradução em espanhol da mesma mensagem.

   <?code-excerpt "gen_l10n_example/lib/l10n/app_es.arb"?>
   ```json
   {
       "helloWorld": "¡Hola Mundo!"
   }
   ```

6. Agora, execute `flutter pub get` ou `flutter run` e a geração de código acontece automaticamente.
   Você deve encontrar arquivos gerados no diretório no caminho que você especificou
   com as opções `arb-dir` ou `output-dir`
   Alternativamente, você também pode executar `flutter gen-l10n` para
   gerar os mesmos arquivos sem executar o app.

7. Adicione a declaração de importação em `app_localizations.dart` e
   `AppLocalizations.delegate`
   na sua chamada ao construtor do `MaterialApp`:

   <?code-excerpt "gen_l10n_example/lib/main.dart (app-localizations-import)"?>
   ```dart
   import 'l10n/app_localizations.dart';
   ```

   <?code-excerpt "gen_l10n_example/lib/main.dart (material-app)"?>
   ```dart
   return const MaterialApp(
     title: 'Localizations Sample App',
     localizationsDelegates: [
       AppLocalizations.delegate, // Add this line
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: [
       Locale('en'), // English
       Locale('es'), // Spanish
     ],
     home: MyHomePage(),
   );
   ```

   A classe `AppLocalizations` também fornece listas
   `localizationsDelegates` e `supportedLocales` geradas automaticamente.
   Você pode usar essas em vez de fornecê-las manualmente.

   <?code-excerpt "gen_l10n_example/lib/examples.dart (material-app)"?>
   ```dart
   const MaterialApp(
     title: 'Localizations Sample App',
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
   );
   ```

8. Uma vez que o app Material tenha iniciado,
   você pode usar `AppLocalizations` em qualquer lugar do seu app:

   <?code-excerpt "gen_l10n_example/lib/main.dart (internationalized-title)"?>
   ```dart
   appBar: AppBar(
     // The [AppBar] title text should update its message
     // according to the system locale of the target platform.
     // Switching between English and Spanish locales should
     // cause this text to update.
     title: Text(AppLocalizations.of(context)!.helloWorld),
   ),
   ```

:::note
O app Material precisa realmente ser iniciado para inicializar
`AppLocalizations`. Se o app ainda não foi iniciado,
`AppLocalizations.of(context)!.helloWorld` causa uma
exceção nula.
:::

   Este código gera um widget `Text` que exibe "Hello World!"
   se o locale do dispositivo alvo estiver definido como inglês,
   e "¡Hola Mundo!" se o locale do dispositivo alvo estiver definido
   como espanhol. Nos arquivos `arb`,
   a chave de cada entrada é usada como o nome do método do getter,
   enquanto o valor dessa entrada contém a mensagem localizada.

O [`gen_l10n_example`][] usa esta ferramenta.

Para localizar a descrição do seu app no dispositivo,
passe a string localizada para
[`MaterialApp.onGenerateTitle`][]:

<?code-excerpt "intl_example/lib/main.dart (app-title)"?>
```dart
return MaterialApp(
  onGenerateTitle: (context) => DemoLocalizations.of(context).title,
```

[App Resource Bundle]: {{site.github}}/google/app-resource-bundle
[`gen_l10n_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/gen_l10n_example
[`MaterialApp.onGenerateTitle`]: {{site.api}}/flutter/material/MaterialApp/onGenerateTitle.html

### Placeholders, plurais e seleções

:::tip
Ao usar o VS Code, adicione a [extensão arb-editor][arb-editor extension].
Esta extensão adiciona realce de sintaxe, snippets,
diagnósticos e correções rápidas para ajudar a editar arquivos de template `.arb`.
:::

[arb-editor extension]: https://marketplace.visualstudio.com/items?itemName=Google.arb-editor

Você também pode incluir valores de aplicativo em uma mensagem com
sintaxe especial que usa um _placeholder_ para gerar um método
em vez de um getter.
Um placeholder, que deve ser um nome de identificador Dart válido,
torna-se um parâmetro posicional no método gerado no
código `AppLocalizations`. Defina um nome de placeholder envolvendo-o
em chaves da seguinte forma:

```json
"{placeholderName}"
```

Defina cada placeholder no objeto `placeholders`
no arquivo `.arb` do app. Por exemplo,
para definir uma mensagem de saudação com um parâmetro `userName`,
adicione o seguinte a `lib/l10n/app_en.arb`:

<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="5" take="10" replace="/},$/}/g"?>
```json
"hello": "Hello {userName}",
"@hello": {
  "description": "A message with a single parameter",
  "placeholders": {
    "userName": {
      "type": "String",
      "example": "Bob"
    }
  }
}
```

Este trecho de código adiciona uma chamada de método `hello` ao
objeto `AppLocalizations.of(context)`,
e o método aceita um parâmetro do tipo `String`;
o método `hello` retorna uma string.
Regenere o arquivo `AppLocalizations`.

Substitua o código passado para `Builder` pelo seguinte:

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/wombat|Wombats|he'|they|pronoun/"?>
```dart
// Examples of internationalized strings.
return Column(
  children: <Widget>[
    // Returns 'Hello John'
    Text(AppLocalizations.of(context)!.hello('John')),
  ],
);
```

Você também pode usar placeholders numéricos para especificar múltiplos valores.
Idiomas diferentes têm maneiras diferentes de pluralizar palavras.
A sintaxe também suporta especificar _como_ uma palavra deve ser pluralizada.
Uma mensagem _pluralizada_ deve incluir um parâmetro `num` indicando
como pluralizar a palavra em diferentes situações.
O inglês, por exemplo, pluraliza "person" para "people",
mas isso não vai longe o suficiente.
O plural `message0` pode ser "no people" ou "zero people".
O plural `messageFew` pode ser
"several people", "some people", ou "a few people".
O plural `messageMany` pode
ser "most people" ou "many people", ou "a crowd".
Apenas o campo mais geral `messageOther` é obrigatório.
O exemplo a seguir mostra quais opções estão disponíveis:

```json
"{countPlaceholder, plural, =0{message0} =1{message1} =2{message2} few{messageFew} many{messageMany} other{messageOther}}"
```

A expressão anterior é substituída pela variação da mensagem
(`message0`, `message1`, ...) correspondente ao valor
do `countPlaceholder`.
Apenas o campo `messageOther` é obrigatório.

O exemplo a seguir define uma mensagem que pluraliza
a palavra "wombat":

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="15" take="10" replace="/},$/}/g"?>
```json
"nWombats": "{count, plural, =0{no wombats} =1{1 wombat} other{{count} wombats}}",
"@nWombats": {
  "description": "A plural message",
  "placeholders": {
    "count": {
      "type": "num",
      "format": "compact"
    }
  }
}
```
{% endraw %}

Use um método plural passando o parâmetro `count`:

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/John|he|she|they|pronoun/" replace="/\[/[\n    .../g"?>
```dart
// Examples of internationalized strings.
return Column(
  children: <Widget>[
    ...
    // Returns 'no wombats'
    Text(AppLocalizations.of(context)!.nWombats(0)),
    // Returns '1 wombat'
    Text(AppLocalizations.of(context)!.nWombats(1)),
    // Returns '5 wombats'
    Text(AppLocalizations.of(context)!.nWombats(5)),
  ],
);
```

Semelhante aos plurais,
você também pode escolher um valor com base em um placeholder `String`.
Isso é mais frequentemente usado para suportar idiomas com gênero.
A sintaxe é a seguinte:

```json
"{selectPlaceholder, select, case{message} ... other{messageOther}}"
```

O próximo exemplo define uma mensagem que
seleciona um pronome com base no gênero:

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="25" take="9" replace="/},$/}/g"?>
```json
"pronoun": "{gender, select, male{he} female{she} other{they}}",
"@pronoun": {
  "description": "A gendered message",
  "placeholders": {
    "gender": {
      "type": "String"
    }
  }
}
```
{% endraw %}

Use este recurso
passando a string de gênero como parâmetro:

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/'He|hello|ombat/" replace="/\[/[\n    .../g"?>
```dart
// Examples of internationalized strings.
return Column(
  children: <Widget>[
    ...
    // Returns 'he'
    Text(AppLocalizations.of(context)!.pronoun('male')),
    // Returns 'she'
    Text(AppLocalizations.of(context)!.pronoun('female')),
    // Returns 'they'
    Text(AppLocalizations.of(context)!.pronoun('other')),
  ],
);
```

Tenha em mente que ao usar declarações `select`,
a comparação entre o parâmetro e o valor
real é sensível a maiúsculas e minúsculas.
Ou seja, `AppLocalizations.of(context)!.pronoun("Male")`
usa o caso "other" por padrão, e retorna "they".

### Sintaxe de escape

Às vezes, você precisa usar tokens,
como `{` e `}`, como caracteres normais.
Para ignorar tais tokens de serem analisados,
habilite a flag `use-escaping` adicionando o
seguinte a `l10n.yaml`:

```yaml
use-escaping: true
```

O parser ignora qualquer string de caracteres
envolvida com um par de aspas simples.
Para usar um caractere de aspas simples normal,
use um par de aspas simples consecutivas.
Por exemplo, o seguinte texto é convertido
para uma `String` Dart:

```json
{
  "helloWorld": "Hello! '{Isn''t}' this a wonderful day?"
}
```

A string resultante é a seguinte:

```dart
"Hello! {Isn't} this a wonderful day?"
```

### Mensagens com números e moedas

Números, incluindo aqueles que representam valores monetários,
são exibidos de maneira muito diferente em diferentes locales.
A ferramenta de geração de localizações em
`flutter_localizations` usa a
classe [`NumberFormat`]({{site.api}}/flutter/intl/NumberFormat-class.html)
no pacote `intl` para formatar
números com base no locale e no formato desejado.

Os tipos `int`, `double` e `num` podem usar qualquer um dos
seguintes construtores `NumberFormat`:

| Message "format" value   | Output for 1200000 |
|--------------------------|--------------------|
| `compact`                | "1.2M"             |
| `compactCurrency`*       | "$1.2M"            |
| `compactSimpleCurrency`* | "$1.2M"            |
| `compactLong`            | "1.2 million"      |
| `currency`*              | "USD1,200,000.00"  |
| `decimalPattern`         | "1,200,000"        |
| `decimalPatternDigits`*  | "1,200,000"        |
| `decimalPercentPattern`* | "120,000,000%"     |
| `percentPattern`         | "120,000,000%"     |
| `scientificPattern`      | "1E6"              |
| `simpleCurrency`*        | "$1,200,000"       |

{:.table .table-striped}

Os construtores `NumberFormat` com asterisco na tabela
oferecem parâmetros nomeados opcionais.
Esses parâmetros podem ser especificados como o valor
do objeto `optionalParameters` do placeholder.
Por exemplo, para especificar o parâmetro opcional `decimalDigits`
para `compactCurrency`,
faça as seguintes alterações no arquivo `lib/l10n/app_en.arb`:

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="34" take="13" replace="/},$/}/g"?>
```json
"numberOfDataPoints": "Number of data points: {value}",
"@numberOfDataPoints": {
  "description": "A message with a formatted int parameter",
  "placeholders": {
    "value": {
      "type": "int",
      "format": "compactCurrency",
      "optionalParameters": {
        "decimalDigits": 2
      }
    }
  }
}
```
{% endraw %}

### Mensagens com datas

Strings de datas são formatadas de muitas maneiras diferentes
dependendo tanto do locale quanto das necessidades do app.

Valores de placeholder com tipo `DateTime` são formatados com
[`DateFormat`][] no pacote `intl`.

Existem 41 variações de formato,
identificadas pelos nomes de seus construtores factory `DateFormat`.
No exemplo a seguir, o valor `DateTime`
que aparece na mensagem `helloWorldOn` é
formatado com `DateFormat.yMd`:

```json
"helloWorldOn": "Hello World on {date}",
"@helloWorldOn": {
  "description": "A message with a date parameter",
  "placeholders": {
    "date": {
      "type": "DateTime",
      "format": "yMd"
    }
  }
}
```

Em um app onde o locale é inglês dos EUA,
a seguinte expressão produziria "7/9/1959".
Em um locale russo, produziria "9.07.1959".

```dart
AppLocalizations.of(context).helloWorldOn(DateTime.utc(1959, 7, 9))
```

[`DateFormat`]: {{site.api}}/flutter/intl/DateFormat-class.html

<a id="ios-specifics"></a>
### Localizando para iOS: Atualizando o bundle do app iOS

Embora as localizações sejam tratadas pelo Flutter,
você precisa adicionar os idiomas suportados no projeto Xcode.
Isso garante que sua entrada na App Store exiba corretamente
os idiomas suportados.

Para configurar os locales suportados pelo seu app,
use as seguintes instruções:

1. Abra o arquivo Xcode `ios/Runner.xcodeproj` do seu projeto.

2. No **Project Navigator**, selecione o arquivo de projeto `Runner`
   em **Projects**.

4. Selecione a aba `Info` no editor do projeto.

5. Na seção **Localizations**, clique no botão `Add`
   (`+`) para adicionar os idiomas e regiões suportados ao seu
   projeto. Quando perguntado para escolher arquivos e idioma de referência,
   simplesmente selecione `Finish`.

7. O Xcode cria automaticamente arquivos `.strings` vazios e
   atualiza o arquivo `ios/Runner.xcodeproj/project.pbxproj`.
   Esses arquivos são usados pela App Store para determinar quais
   idiomas e regiões seu app suporta.

<a id="advanced-customization"></a>
## Tópicos avançados para personalização adicional

Esta seção cobre maneiras adicionais de personalizar um
aplicativo Flutter localizado.

<a id="advanced-locale"></a>
### Definição avançada de locale

Alguns idiomas com múltiplas variantes requerem mais do que apenas um
código de idioma para diferenciar adequadamente.

Por exemplo, diferenciar completamente todas as variantes do
chinês requer especificar o código do idioma, código de script
e código do país. Isso se deve à existência
de script simplificado e tradicional, bem como diferenças regionais
na forma como os caracteres são escritos dentro do mesmo tipo de script.

Para expressar completamente cada variante do chinês para os
códigos de país `CN`, `TW` e `HK`, a lista de locales
suportados deve incluir:

<?code-excerpt "gen_l10n_example/lib/examples.dart (supported-locales)"?>
```dart
supportedLocales: [
  Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
  Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hans',
  ), // generic simplified Chinese 'zh_Hans'
  Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
  ), // generic traditional Chinese 'zh_Hant'
  Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hans',
    countryCode: 'CN',
  ), // 'zh_Hans_CN'
  Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
    countryCode: 'TW',
  ), // 'zh_Hant_TW'
  Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
    countryCode: 'HK',
  ), // 'zh_Hant_HK'
],
```

Esta definição completa e explícita garante que seu app possa
distinguir entre e fornecer conteúdo localizado
totalmente nuançado para todas as combinações desses códigos de país.
Se o locale preferido de um usuário não estiver especificado,
o Flutter seleciona a correspondência mais próxima,
que provavelmente contém diferenças do que o usuário espera.
O Flutter só resolve para locales definidos em `supportedLocales`
e fornece conteúdo localizado diferenciado por scriptCode
para idiomas comumente usados.
Veja [`Localizations`][] para informações sobre como os locales
suportados e os locales preferidos são resolvidos.

Embora o chinês seja um exemplo primário,
outros idiomas como francês (`fr_FR`, `fr_CA`)
também devem ser totalmente diferenciados para uma localização mais nuançada.

[`Localizations`]: {{site.api}}/flutter/widgets/WidgetsApp/supportedLocales.html

<a id="tracking-locale"></a>
### Rastreando o locale: A classe Locale e o widget Localizations

A classe [`Locale`][] identifica o idioma do usuário.
Dispositivos móveis suportam configurar o locale para todos os aplicativos,
geralmente usando um menu de configurações do sistema.
Apps internacionalizados respondem exibindo valores que são
específicos do locale. Por exemplo, se o usuário mudar o locale do dispositivo
de inglês para francês, então um widget `Text` que originalmente
exibia "Hello World" seria reconstruído com "Bonjour le monde".

O widget [`Localizations`][widgets-global] define o locale
para seu filho e os recursos localizados dos quais o filho depende.
O widget [`WidgetsApp`][] cria um widget `Localizations`
e o reconstrói se o locale do sistema mudar.

Você sempre pode consultar o locale atual de um app com
`Localizations.localeOf()`:

<?code-excerpt "gen_l10n_example/lib/examples.dart (my-locale)"?>
```dart
Locale myLocale = Localizations.localeOf(context);
```

[`Locale`]: {{site.api}}/flutter/dart-ui/Locale-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[widgets-global]: {{site.api}}/flutter/flutter_localizations/GlobalWidgetsLocalizations-class.html

<a id="specifying-supportedlocales" aria-hidden="true"></a>

### Especificando o parâmetro supported&shy;Locales do app

Embora a biblioteca `flutter_localizations`
suporte muitos idiomas e variantes de idioma,
apenas traduções em inglês estão disponíveis por padrão.
Cabe ao desenvolvedor decidir exatamente quais idiomas suportar.

O parâmetro [`supportedLocales`][] do `MaterialApp`
limita mudanças de locale. Quando o usuário muda a configuração de locale
no dispositivo, o widget `Localizations` do app só
acompanha se o novo locale for membro desta lista.
Se uma correspondência exata para o locale do dispositivo não for encontrada,
então o primeiro locale suportado com um [`languageCode`][] correspondente
é usado. Se isso falhar, então o primeiro elemento da
lista `supportedLocales` é usado.

Um app que deseja usar um método diferente de "resolução de locale"
pode fornecer um [`localeResolutionCallback`][].
Por exemplo, para fazer seu app aceitar incondicionalmente
qualquer locale que o usuário selecione:

<?code-excerpt "gen_l10n_example/lib/examples.dart (locale-resolution)"?>
```dart
MaterialApp(
  localeResolutionCallback: (locale, supportedLocales) {
    return locale;
  },
);
```

[`languageCode`]: {{site.api}}/flutter/dart-ui/Locale/languageCode.html
[`localeResolutionCallback`]: {{site.api}}/flutter/widgets/LocaleResolutionCallback.html
[`supportedLocales`]: {{site.api}}/flutter/material/MaterialApp/supportedLocales.html

### Configurando o arquivo l10n.yaml

O arquivo `l10n.yaml` permite que você configure a ferramenta `gen-l10n`
para especificar o seguinte:

* onde todos os arquivos de entrada estão localizados
* onde todos os arquivos de saída devem ser criados
* qual nome de classe Dart dar ao seu delegate de localizações

Para uma lista completa de opções, execute `flutter gen-l10n --help`
na linha de comando ou consulte a tabela a seguir:

| Opção                               | Descrição |
| ------------------------------------| ------------------ |
| `arb-dir`                           | O diretório onde os arquivos arb de template e traduzidos estão localizados. O padrão é `lib/l10n`. |
| `output-dir`                        | O diretório onde as classes de localização geradas são escritas. Esta opção é relevante apenas se você quiser gerar o código de localizações em outro lugar no projeto Flutter. Você também precisa definir a flag `synthetic-package` como false.<br /><br />O app deve importar o arquivo especificado na opção `output-localization-file` deste diretório. Se não especificado, o padrão é o mesmo diretório do diretório de entrada especificado em `arb-dir`. |
| `template-arb-file`                 | O arquivo arb de template que é usado como base para gerar os arquivos Dart de localização e mensagens. O padrão é `app_en.arb`. |
| `output-localization-file`          | O nome do arquivo para as classes de localização de saída e delegate de localizações. O padrão é `app_localizations.dart`. |
| `untranslated-messages-file`        | A localização de um arquivo que descreve as mensagens de localização que ainda não foram traduzidas. Usar esta opção cria um arquivo JSON na localização alvo, no seguinte formato: <br /> <br />`"locale": ["message_1", "message_2" ... "message_n"]`<br /><br /> Se esta opção não for especificada, um resumo das mensagens que não foram traduzidas é impresso na linha de comando. |
| `output-class`                      | O nome da classe Dart a ser usado para as classes de localização de saída e delegate de localizações. O padrão é `AppLocalizations`. |
| `preferred-supported-locales`       | A lista de locales suportados preferidos para o aplicativo. Por padrão, a ferramenta gera a lista de locales suportados em ordem alfabética. Use esta flag para usar um locale diferente como padrão.<br /><br />Por exemplo, passe `[ en_US ]` para usar inglês americano como padrão se um dispositivo o suportar. |
| `header`                            | O cabeçalho a ser anexado aos arquivos Dart de localizações gerados. Esta opção recebe uma string.<br /><br />Por exemplo, passe `"/// All localized files."` para anexar esta string ao arquivo Dart gerado.<br /><br />Alternativamente, confira a opção `header-file` para passar um arquivo de texto para cabeçalhos mais longos. |
| `header-file`                       | O cabeçalho a ser anexado aos arquivos Dart de localizações gerados. O valor desta opção é o nome do arquivo que contém o texto do cabeçalho que é inserido no topo de cada arquivo Dart gerado. <br /><br /> Alternativamente, confira a opção `header` para passar uma string para um cabeçalho mais simples.<br /><br />Este arquivo deve ser colocado no diretório especificado em `arb-dir`. |
| `[no-]use-deferred-loading`         | Especifica se deve gerar o arquivo Dart de localização com locales importados como deferred, permitindo carregamento preguiçoso de cada locale no Flutter web.<br /><br />Isso pode reduzir o tempo de inicialização inicial de um app web diminuindo o tamanho do bundle JavaScript. Quando esta flag está definida como true, as mensagens para um locale específico são apenas baixadas e carregadas pelo app Flutter conforme necessário. Para projetos com muitos locales diferentes e muitas strings de localização, pode melhorar o desempenho adiar o carregamento. Para projetos com um pequeno número de locales, a diferença é negligenciável e pode retardar a inicialização comparado a agrupar as localizações com o resto do aplicativo.<br /><br />Note que esta flag não afeta outras plataformas como mobile ou desktop. |
| `gen-inputs-and-outputs-list`      | Quando especificado, a ferramenta gera um arquivo JSON contendo as entradas e saídas da ferramenta, chamado `gen_l10n_inputs_and_outputs.json`.<br /><br />Isso pode ser útil para rastrear quais arquivos do projeto Flutter foram usados ao gerar o último conjunto de localizações. Por exemplo, o sistema de build da ferramenta Flutter usa este arquivo para rastrear quando chamar gen_l10n durante hot reload.<br /><br />O valor desta opção é o diretório onde o arquivo JSON é gerado. Quando null, o arquivo JSON não será gerado. |
| `synthetic-package`                 | Determina se os arquivos de saída gerados são gerados como um pacote sintético ou em um diretório especificado no projeto Flutter. Esta flag é `true` por padrão. Quando `synthetic-package` está definido como `false`, gera os arquivos de localizações no diretório especificado por `arb-dir` por padrão. Se `output-dir` for especificado, os arquivos são gerados lá. |
| `project-dir`                       | Quando especificado, a ferramenta usa o caminho passado para esta opção como o diretório do projeto Flutter raiz.<br /><br />Quando null, o caminho relativo ao diretório de trabalho atual é usado. |
| `[no-]required-resource-attributes` | Requer que todos os IDs de recurso contenham um atributo de recurso correspondente.<br /><br />Por padrão, mensagens simples não requerem metadados, mas é altamente recomendado pois isso fornece contexto para o significado de uma mensagem aos leitores.<br /><br />Atributos de recurso ainda são obrigatórios para mensagens plurais. |
| `[no-]nullable-getter`              | Especifica se o getter da classe de localizações é nullable.<br /><br />Por padrão, este valor é true para que `Localizations.of(context)` retorne um valor nullable para compatibilidade retroativa. Se este valor for false, então uma verificação de null é realizada no valor retornado de `Localizations.of(context)`, removendo a necessidade de verificação de null no código do usuário. |
| `[no-]format`                       | Quando especificado, o comando `dart format` é executado após gerar os arquivos de localização. |
| `use-escaping`                      | Especifica se deve habilitar o uso de aspas simples como sintaxe de escape. |
| `[no-]suppress-warnings`            | Quando especificado, todos os avisos são suprimidos. |
| `[no-]relax-syntax`                 | Quando especificado, a sintaxe é relaxada de modo que o caractere especial "{" é tratado como uma string se não for seguido por um placeholder válido e "}" é tratado como uma string se não fechar nenhum "{" anterior que seja tratado como um caractere especial. |
| `[no-]use-named-parameters`         | Se deve usar parâmetros nomeados para os métodos de localização gerados. |

{:.table .table-striped}


## Como funciona a internacionalização no Flutter

Esta seção cobre os detalhes técnicos de como as localizações funcionam
no Flutter. Se você está planejando suportar seu próprio conjunto de mensagens
localizadas, o conteúdo a seguir seria útil.
Caso contrário, você pode pular esta seção.

<a id="loading-and-retrieving"></a>
### Carregando e recuperando valores localizados

O widget `Localizations` é usado para carregar e
procurar objetos que contêm coleções de valores localizados.
Apps referem-se a esses objetos com [`Localizations.of(context,type)`][].
Se o locale do dispositivo mudar,
o widget `Localizations` carrega automaticamente valores para
o novo locale e então reconstrói os widgets que o usaram.
Isso acontece porque `Localizations` funciona como um
[`InheritedWidget`][].
Quando uma função de build refere-se a um inherited widget,
uma dependência implícita no inherited widget é criada.
Quando um inherited widget muda
(quando o locale do widget `Localizations` muda),
seus contextos dependentes são reconstruídos.

Valores localizados são carregados pela lista de
[`LocalizationsDelegate`][]s do widget `Localizations`.
Cada delegate deve definir um método [`load()`][] assíncrono
que produz um objeto que encapsula uma
coleção de valores localizados.
Tipicamente, esses objetos definem um método por valor localizado.

Em um app grande, diferentes módulos ou pacotes podem ser agrupados com
suas próprias localizações. É por isso que o widget `Localizations`
gerencia uma tabela de objetos, um por `LocalizationsDelegate`.
Para recuperar o objeto produzido por um dos métodos `load` do
`LocalizationsDelegate`, especifique um `BuildContext` e o tipo do objeto.

Por exemplo,
as strings localizadas para os widgets Material Components
são definidas pela classe [`MaterialLocalizations`][].
Instâncias desta classe são criadas por um `LocalizationDelegate`
fornecido pela classe [`MaterialApp`][].
Elas podem ser recuperadas com `Localizations.of()`:

```dart
Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
```

Esta expressão `Localizations.of()` em particular é usada frequentemente,
então a classe `MaterialLocalizations` fornece um atalho conveniente:

```dart
static MaterialLocalizations of(BuildContext context) {
  return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

/// Referências aos valores localizados definidos por MaterialLocalizations
/// são tipicamente escritas assim:

tooltip: MaterialLocalizations.of(context).backButtonTooltip,
```

[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`load()`]: {{site.api}}/flutter/widgets/LocalizationsDelegate/load.html
[`LocalizationsDelegate`]: {{site.api}}/flutter/widgets/LocalizationsDelegate-class.html
[`Localizations.of(context,type)`]: {{site.api}}/flutter/widgets/Localizations/of.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialLocalizations`]: {{site.api}}/flutter/material/MaterialLocalizations-class.html

<a id="defining-class"></a>
### Definindo uma classe para os recursos localizados do app

Montar um app Flutter internacionalizado geralmente
começa com a classe que encapsula os valores localizados do app.
O exemplo a seguir é típico de tais classes.

Código-fonte completo para o [`intl_example`][] deste app.

Este exemplo é baseado nas APIs e ferramentas fornecidas pelo
pacote [`intl`][]. A seção [Uma classe alternativa para os recursos
localizados do app](#alternative-class)
descreve [um exemplo][an example] que não depende do pacote `intl`.

A classe `DemoLocalizations`
(definida no trecho de código a seguir)
contém as strings do app (apenas uma para o exemplo)
traduzidas para os locales que o app suporta.
Ela usa a função `initializeMessages()`
gerada pelo pacote [`intl`][] do Dart,
[`Intl.message()`][], para procurá-las.

<?code-excerpt "intl_example/lib/main.dart (demo-localizations)"?>
```dart
class DemoLocalizations {
  DemoLocalizations(this.localeName);

  static Future<DemoLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return DemoLocalizations(localeName);
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  final String localeName;

  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }
}
```

Uma classe baseada no pacote `intl` importa um catálogo de mensagens
gerado que fornece a função `initializeMessages()`
e o armazenamento de apoio por locale para `Intl.message()`.
O catálogo de mensagens é produzido por uma [ferramenta `intl`](#dart-tools)
que analisa o código-fonte de classes que contêm
chamadas `Intl.message()`.
Neste caso, seria apenas a classe `DemoLocalizations`.

[an example]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/minimal
[`intl`]: {{site.pub-pkg}}/intl
[`Intl.message()`]: {{site.pub-api}}/intl/latest/intl/Intl/message.html

<a id="adding-language"></a>
### Adicionando suporte para um novo idioma

Um app que precisa suportar um idioma que não está incluído em
[`GlobalMaterialLocalizations`][] tem que fazer algum trabalho extra:
ele deve fornecer cerca de 70 traduções ("localizações")
para palavras ou frases e os padrões e símbolos de data para o
locale.

Veja a seguir um exemplo de como adicionar
suporte para o idioma norueguês Nynorsk.

Uma nova subclasse `GlobalMaterialLocalizations` define as
localizações das quais a biblioteca Material depende.
Uma nova subclasse `LocalizationsDelegate`, que serve
como factory para a subclasse `GlobalMaterialLocalizations`,
também deve ser definida.

Aqui está o código-fonte para o exemplo completo [`add_language`][],
menos as traduções reais de Nynorsk.

A subclasse `GlobalMaterialLocalizations` específica do locale
é chamada `NnMaterialLocalizations`,
e a subclasse `LocalizationsDelegate` é
`_NnMaterialLocalizationsDelegate`.
O valor de `NnMaterialLocalizations.delegate`
é uma instância do delegate, e é tudo
que é necessário por um app que usa essas localizações.

A classe delegate inclui localizações básicas de formato de data e número.
Todas as outras localizações são definidas por getters de propriedade
com valor `String` em `NnMaterialLocalizations`, assim:

<?code-excerpt "add_language/lib/nn_intl.dart (getters)"?>
```dart
@override
String get moreButtonTooltip => r'More';

@override
String get aboutListTileTitleRaw => r'About $applicationName';

@override
String get alertDialogLabel => r'Alert';
```

Essas são as traduções em inglês, é claro.
Para completar o trabalho, você precisa mudar o valor de retorno
de cada getter para uma string Nynorsk apropriada.

Os getters retornam strings Dart "brutas" que têm um prefixo `r`,
como `r'About $applicationName'`,
porque às vezes as strings contêm variáveis com um prefixo `$`.
As variáveis são expandidas por métodos de localização parametrizados:

<?code-excerpt "add_language/lib/nn_intl.dart (raw)"?>
```dart
@override
String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow of $rowCount';

@override
String get pageRowsInfoTitleApproximateRaw =>
    r'$firstRow–$lastRow of about $rowCount';
```

Os padrões e símbolos de data do locale também precisam ser
especificados, que são definidos no código-fonte da seguinte forma:

{% comment %}
RegEx adds last two lines with commented out code and closing bracket.
{% endcomment %}

<?code-excerpt "add_language/lib/nn_intl.dart (date-patterns)" replace="/  'LLL': 'LLL',/  'LLL': 'LLL',\n  \/\/ ...\n}/g"?>
```dart
const nnLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  // ...
}
```

{% comment %}
RegEx adds last two lines with commented out code and closing bracket.
{% endcomment %}

<?code-excerpt "add_language/lib/nn_intl.dart (date-symbols)" replace="/  ],/  ],\n  \/\/ ...\n}/g"?>
```dart
const nnDateSymbols = {
  'NAME': 'nn',
  'ERAS': <dynamic>['f.Kr.', 'e.Kr.'],
```

Esses valores precisam ser modificados para o locale usar a
formatação de data correta. Infelizmente, como a biblioteca `intl` não
compartilha a mesma flexibilidade para formatação de números,
a formatação para um locale existente deve ser usada
como substituto em `_NnMaterialLocalizationsDelegate`:

<?code-excerpt "add_language/lib/nn_intl.dart (delegate)"?>
```dart
class _NnMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _NnMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'nn';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    // The locale (in this case `nn`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: nnLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(nnDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      NnMaterialLocalizations(
        localeName: localeName,
        // The `intl` library's NumberFormat class is generated from CLDR data
        // (see https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/number_symbols_data.dart).
        // Unfortunately, there is no way to use a locale that isn't defined in
        // this map and the only way to work around this is to use a listed
        // locale's NumberFormat symbols. So, here we use the number formats
        // for 'en_US' instead.
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        // DateFormat here will use the symbols and patterns provided in the
        // `date_symbol_data_custom.initializeDateFormattingCustom` call above.
        // However, an alternative is to simply use a supported locale's
        // DateFormat symbols, similar to NumberFormat above.
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(_NnMaterialLocalizationsDelegate old) => false;
}
```

Para mais informações sobre strings de localização,
confira o [README do flutter_localizations][flutter_localizations README].

Uma vez que você implementou suas subclasses específicas de idioma de
`GlobalMaterialLocalizations` e `LocalizationsDelegate`,
você precisa adicionar o idioma e uma instância de delegate ao seu app.
O código a seguir define o idioma do app como Nynorsk e
adiciona a instância de delegate `NnMaterialLocalizations` à lista
`localizationsDelegates` do app:

<?code-excerpt "add_language/lib/main.dart (material-app)"?>
```dart
const MaterialApp(
  localizationsDelegates: [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    NnMaterialLocalizations.delegate, // Add the newly created delegate
  ],
  supportedLocales: [Locale('en', 'US'), Locale('nn')],
  home: Home(),
),
```

[`add_language`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/add_language/lib/main.dart

[flutter_localizations README]: {{site.repo.flutter}}/blob/main/packages/flutter_localizations/lib/src/l10n/README.md
[`GlobalMaterialLocalizations`]: {{site.api}}/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html

<a id="alternative-internationalization-workflows"></a>
## Fluxos de trabalho alternativos de internacionalização

Esta seção descreve diferentes abordagens para internacionalizar
seu aplicativo Flutter.

<a id="alternative-class"></a>
### Uma classe alternativa para os recursos localizados do app

O exemplo anterior foi definido em termos do pacote `intl`
do Dart. Você pode escolher sua própria abordagem para gerenciar
valores localizados por questão de simplicidade ou talvez para integrar
com um framework i18n diferente.

Código-fonte completo para o app [`minimal`][].

No exemplo a seguir, a classe `DemoLocalizations`
inclui todas as suas traduções diretamente em Maps por idioma:


<?code-excerpt "minimal/lib/main.dart (demo)"?>
```dart
class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {'title': 'Hello World'},
    'es': {'title': 'Hola Mundo'},
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }
}
```

No app minimal, o `DemoLocalizationsDelegate` é ligeiramente
diferente. Seu método `load` retorna um [`SynchronousFuture`][]
porque nenhum carregamento assíncrono precisa ocorrer.

<?code-excerpt "minimal/lib/main.dart (delegate)"?>
```dart
class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      DemoLocalizations.languages().contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
```

[`SynchronousFuture`]: {{site.api}}/flutter/foundation/SynchronousFuture-class.html

<a id="dart-tools"></a>
### Usando as ferramentas Dart intl

Antes de construir uma API usando o pacote [`intl`][] do Dart,
revise a documentação do pacote `intl`.
A lista a seguir resume o processo para
localizar um app que depende do pacote `intl`:

O app de demonstração depende de um arquivo-fonte gerado chamado
`l10n/messages_all.dart`, que define todas as
strings localizáveis usadas pelo app.

Reconstruir `l10n/messages_all.dart` requer dois passos.

 1. Com o diretório raiz do app como diretório atual,
    gere `l10n/intl_messages.arb` a partir de `lib/main.dart`:

    ```console
    $ dart run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
    ```

    O arquivo `intl_messages.arb` é um mapa em formato JSON com uma entrada para
    cada função `Intl.message()` definida em `main.dart`.
    Este arquivo serve como template para as traduções em inglês e espanhol,
    `intl_en.arb` e `intl_es.arb`.
    Essas traduções são criadas por você, o desenvolvedor.

 2. Com o diretório raiz do app como diretório atual,
    gere `intl_messages_<locale>.dart` para cada
    arquivo `intl_<locale>.arb` e `intl_messages_all.dart`,
    que importa todos os arquivos de mensagens:

    ```console
    $ dart run intl_translation:generate_from_arb \
        --output-dir=lib/l10n --no-use-deferred-loading \
        lib/main.dart lib/l10n/intl_*.arb
    ```

    ***O Windows não suporta wildcard de nome de arquivo.***
    Em vez disso, liste os arquivos .arb que foram gerados pelo
    comando `intl_translation:extract_to_arb`.

    ```console
    $ dart run intl_translation:generate_from_arb \
        --output-dir=lib/l10n --no-use-deferred-loading \
        lib/main.dart \
        lib/l10n/intl_en.arb lib/l10n/intl_fr.arb lib/l10n/intl_messages.arb
    ```

    A classe `DemoLocalizations` usa a função
    `initializeMessages()` gerada
    (definida em `intl_messages_all.dart`)
    para carregar as mensagens localizadas e `Intl.message()`
    para procurá-las.

## Mais informações

Se você aprende melhor lendo código,
confira os seguintes exemplos.

* [`minimal`][]<br>
  O exemplo `minimal` foi projetado para ser o mais
  simples possível.
* [`intl_example`][]<br>
  usa APIs e ferramentas fornecidas pelo pacote [`intl`][].

Se o pacote `intl` do Dart é novo para você,
confira [Usando as ferramentas Dart intl](#dart-tools).

[`intl_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/intl_example
[`minimal`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/minimal
