---
ia-translate: true
title: Restringe flags do engine Android em modo release
description: >-
  Passar flags de configuração do engine para binários Android de release usando
  extras de `Intent` do Android ou `--use-application-binary` não é mais suportado.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Anteriormente, o embedding Android do Flutter aceitava flags de configuração do engine
(como `--dart-flags`, `--route` ou flags de tracing)
no momento de inicialização, por meio de extras de `Intent` do Android, em todos os modos de build.
Esse mecanismo permitia que desenvolvedores e ferramentas&mdash;incluindo a CLI do Flutter
ao usar `--use-application-binary`&mdash;configurassem dinamicamente
apps em execução sem modificar o código-fonte ou o manifesto.

Para proteger apps de produção contra ataques de spoofing via `Intent`
e de injeção de parâmetros,
os builds Android de release do Flutter agora ignoram flags de configuração do engine
passadas por extras de `Intent`,
lendo a configuração do engine estritamente do `AndroidManifest.xml` compilado
ou de configuração programática antes da inicialização do engine.

Esta mudança afeta os fluxos de trabalho de duas formas:

- **Inicializações diretas via `Intent`:**
  Passar flags de configuração do engine por extras de `Intent`
  (como por meio de `adb shell am start` ou código Android nativo)
  é ignorado pelo embedding em builds de release.
- **Binários pré-compilados da CLI do Flutter:**
  Como binários pré-compilados não podem ter seus manifestos modificados
  dinamicamente após a compilação, a CLI do Flutter agora gera um erro fatal
  se você passar flags de configuração do engine para um binário de release pré-compilado
  com `flutter run --release --use-application-binary`.
  Isso evita que as flags sejam ignoradas silenciosamente.

Builds de release padrão
(em que a CLI compila o app com o Gradle e injeta as flags no manifesto)
e todos os fluxos de debug e profile continuam funcionando sem alterações.

## Contexto {:#context}

O engine do Flutter aceita flags de configuração
(como `--dart-flags`, `--route` ou `--trace-startup`)
para configurar o comportamento em tempo de execução ao rodar ou dirigir um app.
Historicamente, o embedding Android do Flutter aceitava essas flags em tempo de execução
por meio de extras de [`Intent`][].
Tanto os desenvolvedores (usando `adb shell am start` ou código nativo)
quanto a CLI do Flutter (via `adb`) dependiam de extras de `Intent`
para passar flags para apps em execução.

No entanto, extras de `Intent` em tempo de execução no Android podem sofrer spoofing
ou ser interceptados por outros apps no dispositivo do usuário.
Permitir flags arbitrárias do engine em builds de produção apresenta
vulnerabilidades de segurança, como ataques de injeção dinâmica de parâmetros
(por exemplo, o spoofing de `--aot-shared-library-name`).

Para reforçar os apps de produção, o Flutter estabelece
uma fronteira de confiança específica para cada modo de build:

- **Modo release:**
  Os limites dos apps de produção são tratados como imutáveis.
  O embedding Android ignora flags de configuração do engine passadas
  por extras de `Intent` e registra um aviso.
  Builds de release leem a configuração estritamente de um `AndroidManifest.xml`
  assinado ou de configuração programática antes da inicialização do engine.
- **Modos debug e profile:**
  O suporte dinâmico a flags via `Intent` é mantido intencionalmente
  para preservar a agilidade do desenvolvedor, benchmarks dinâmicos
  e fluxos de testes locais.

Para builds de release de projetos Gradle padrão,
a CLI do Flutter injeta automaticamente flags de linha de comando
no `AndroidManifest.xml` durante a compilação.
Quando você usa um binário de release pré-compilado com `--use-application-binary`,
a CLI não consegue modificar o manifesto compilado,
e o binário ignora as flags de `Intent` em tempo de execução.
Para evitar que testes ou scripts rodem com falhas de configuração não percebidas,
a CLI reporta um erro fatal.

Da mesma forma, quaisquer scripts automatizados, executores de testes ou apps hospedeiros
que construam diretamente `Intent`s do Android com extras de configuração
verão essas flags serem ignoradas ao iniciar um binário de release.

[`Intent`]: https://developer.android.com/reference/android/content/Intent

## Descrição da mudança {:#description-of-change}

### Comportamento do embedding Android {:#android-embedding-behavior}

O embedding Android do Flutter aplica o seguinte comportamento
ao receber flags de configuração do engine por extras de `Intent` do Android
(como de `adb shell am start` ou de chamadas nativas a `Intent.putExtra()`):

| Modo de build | Comportamento dos extras de `Intent` | Observações |
| :--- | :--- | :--- |
| **Debug / Profile** | Aceitos e interpretados | As flags são aplicadas dinamicamente na inicialização. |
| **Release** | **Ignorados** | O embedding registra um aviso e descarta todas as flags de configuração do engine recebidas por extras de `Intent`. |

Além disso, o método de interface interno
`FlutterActivityAndFragmentDelegate.Host.getFlutterShellArgs` foi descontinuado
em favor de `getFlutterEngineFlags()`.

### Comportamento da CLI do Flutter {:#flutter-cli-behavior}

A CLI do Flutter aplica o seguinte comportamento
ao executar apps Flutter no Android:

| Modo de build | Usando `--use-application-binary` | Comportamento da CLI | Observações |
| :--- | :--- | :--- | :--- |
| **Debug / Profile** | Sim | Passa as flags para o binário via `adb` | Não é necessário recompilar; as flags são aplicadas em tempo de execução. |
| **Debug / Profile** | Não | Compila e passa as flags via `adb` | Fluxo de desenvolvimento padrão. |
| **Release** | Sim | **Erro fatal** se flags de configuração forem fornecidas | Binários de release pré-compilados não podem ser configurados dinamicamente. |
| **Release** | Não | Injeta as flags no `AndroidManifest.xml` durante a compilação | Fluxo padrão de build de release. |

## Guia de migração {:#migration-guide}

:::note
Você **não é afetado** e não precisa tomar nenhuma ação se:
- Você compila e executa apps de release padrão com a CLI do Flutter
  (`flutter run --release`, `flutter build apk --release`
  ou `flutter build appbundle`).
- Você executa testes e benchmarks no modo **debug** ou **profile**.
- Você usa `--use-application-binary` sem passar flags de configuração do engine.
:::

Você **é afetado** se:
- Você inicia builds de release diretamente por extras de `Intent` do Android
  (como com `adb shell am start` ou intents de inicialização personalizadas em código nativo)
  para passar flags de configuração do engine ou argumentos de rota.
- Seus pipelines de CI/CD, scripts automatizados ou executores de testes passam flags
  para binários de release pré-compilados usando `--use-application-binary`.
- Você compila apps Android com Flutter usando sistemas de build não baseados em Gradle
  ou herméticos (como o Bazel) e configura binários de release com flags de inicialização.

Se seus fluxos de trabalho forem afetados, use um dos seguintes caminhos de migração:

### Mude os testes e benchmarks para o modo profile {:#switch-testing-and-benchmarking-to-profile-mode}

Se seus pipelines de teste automatizados, scripts ou benchmarks passam flags
para binários de release dinamicamente na inicialização:

1.  Mude o alvo de teste para o **modo profile** (`--profile`).
    O modo profile espelha as características de desempenho do release
    e, ao mesmo tempo, mantém o suporte à configuração dinâmica de flags em tempo de execução
    por meio de extras de `Intent` e da CLI do Flutter, sem recompilação.

### Configure inicializações diretas via Intent e sistemas de build herméticos {:#configure-direct-intent-launches-and-hermetic-build-systems}

Se você inicia builds de release diretamente por `Intent`s do Android
(por exemplo, via `adb shell am start` ou executores de testes personalizados),
ou se você compila apps Android com Flutter usando sistemas de build não baseados em Gradle
ou herméticos (como o Bazel) que separam a compilação da execução:

1.  **Não dependa de extras de `Intent` para builds de release.**
    Quaisquer flags do engine passadas em extras de `Intent` para um binário de release
    são silenciosamente ignoradas pelo embedding em tempo de execução.
1.  **Use o modo profile para testes dinâmicos:**
    Para testes de integração ou benchmarks de desempenho que exigem
    variar flags dinamicamente na inicialização, compile e execute
    um build **profile** em vez de um build de release.
1.  **Declare as flags estaticamente no `AndroidManifest.xml`:**
    Se você precisar executar um binário de release com flags específicas do engine,
    declare essas flags estaticamente no seu `AndroidManifest.xml`
    antes de compilar o binário de release.
    Para mais detalhes, consulte
    [Declare as flags do engine no `AndroidManifest.xml`](#declare-engine-flags-in-manifest).

### Compile binários de release com flags diretamente usando a CLI do Flutter {:#build-release-binaries-with-flags-directly-using-the-flutter-cli}

Se você precisar executar testes contra um binário de release com a CLI do Flutter:

1.  Execute `flutter build` ou `flutter run` com suas flags de configuração
    sem `--use-application-binary`.
    A CLI incorpora automaticamente as flags no manifesto compilado.
1.  Como alternativa, compile binários de release separados
    para cada configuração necessária.

### Configure as flags do engine programaticamente no código nativo do host {:#configure-engine-flags-programmatically-in-native-host-code}

Se você inicia o Flutter a partir de código Android nativo
(como em uma integração add-to-app ou em uma activity nativa personalizada)
e passava flags do engine anteriormente por extras de `Intent`:

1.  **Sobrescreva `getFlutterEngineFlags()`:**
    Se você estende `FlutterActivity` ou `FlutterFragment`, sobrescreva
    `getFlutterEngineFlags()` em vez de usar extras de `Intent`
    ou o método descontinuado `getFlutterShellArgs()`:

    ```kotlin
    class MyFlutterActivity : FlutterActivity() {
        override fun getFlutterEngineFlags(): List<String> {
            val flags = super.getFlutterEngineFlags().toMutableList()
            flags.add("--trace-startup")
            return flags
        }
    }
    ```

1.  **Use `FlutterFragment.NewEngineFragmentBuilder`:**
    Se você hospeda um `FlutterFragment`, passe as flags usando o builder:

    ```kotlin
    val fragment = FlutterFragment.withNewEngine()
        .flutterEngineFlags(listOf("--trace-startup"))
        .build<FlutterFragment>()
    ```

1.  **Pré-inicialize e armazene em cache um `FlutterEngine`:**
    Se você gerencia o ciclo de vida do engine diretamente, forneça os argumentos do engine
    ao construtor do `FlutterEngine`:

    ```kotlin
    val args = arrayOf("--trace-startup", "--enable-impeller=true")
    val flutterEngine = FlutterEngine(context, args)
    FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
    ```

### Declare as flags do engine no manifesto {:#declare-engine-flags-in-manifest}

Para configurar as flags do engine estaticamente em builds de release,
adicione elementos `<meta-data>` sob a tag `<application>` no
seu arquivo `android/app/src/main/AndroidManifest.xml`:

```xml title="AndroidManifest.xml" highlightLines=6-12
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="my_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Declare engine configuration flags statically -->
        <meta-data
            android:name="io.flutter.embedding.android.DartFlags"
            android:value="--some-dart-flag" />
        <meta-data
            android:name="io.flutter.embedding.android.EnableDartProfiling"
            android:value="false" />
        <activity
            ...
        </activity>
    </application>
</manifest>
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.50.0-0.1.pre<br>
Na versão estável: 3.50

## Referências {:#references}

Issues relevantes:

* [Issue 180686][]
* [Issue 190461][]

Pull requests relevantes:

* [PR 190870][]
* [PR 191328][]
* [PR 191924][]

[Issue 180686]: https://github.com/flutter/flutter/issues/180686
[Issue 190461]: https://github.com/flutter/flutter/issues/190461
[PR 190870]: https://github.com/flutter/flutter/pull/190870
[PR 191328]: https://github.com/flutter/flutter/pull/191328
[PR 191924]: https://github.com/flutter/flutter/pull/191924
