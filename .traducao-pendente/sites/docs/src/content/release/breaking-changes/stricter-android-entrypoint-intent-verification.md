---
ia-translate: true
title: Verificação mais rigorosa de `Intent` do Android para entrypoints de apps
description: >-
  Os extras de `Intent` do Android para roteamento, entrypoints e engines em cache
  agora são verificados de forma estrita.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Para evitar a exploração de vulnerabilidades baseadas em [`Intent`][],
o embedder Android do Flutter
(`FlutterActivity` e `FlutterFragmentActivity`)
agora verifica o remetente dos objetos `Intent`
antes de processar `EXTRA_INITIAL_ROUTE`, `EXTRA_DART_ENTRYPOINT`,
`EXTRA_DART_ENTRYPOINT_ARGS`, `EXTRA_CACHED_ENGINE_ID`,
e `EXTRA_CACHED_ENGINE_GROUP_ID`.

Em modo release, objetos `Intent` externos não podem definir esses extras
a menos que sejam verificados como originados do próprio app.
Se a verificação falhar, o embedder ignora os extras
e recorre aos metadados do manifesto ou aos valores padrão para as rotas iniciais
e os entrypoints do Dart.

## Contexto {:#context}

Anteriormente, o embedder Android do Flutter aceitava roteamento, entrypoint
e configuração do engine diretamente dos extras de `Intent`.
Isso permitia que apps externos ou agentes maliciosos:

1. Sequestrassem a navegação do app para rotas internas sensíveis
   (`EXTRA_INITIAL_ROUTE`).
1. Executassem entrypoints arbitrários do Dart ou passassem argumentos inseguros
   (`EXTRA_DART_ENTRYPOINT` e `EXTRA_DART_ENTRYPOINT_ARGS`).
1. Reutilizassem instâncias de engine ativas e já autenticadas em memória
   (`EXTRA_CACHED_ENGINE_ID` e `EXTRA_CACHED_ENGINE_GROUP_ID`).

Para corrigir essas vulnerabilidades, o Flutter agora valida o remetente do `Intent`.
Deep links continuam suportados,
mas devem corresponder às declarações de `<intent-filter>`
no seu `AndroidManifest.xml`.

## Descrição da mudança {:#description-of-change}

Em builds de release, o embedder Android valida estritamente os extras de `Intent`:
`"route"`, `"dart_entrypoint"`, `"dart_entrypoint_args"`,
`"cached_engine_id"` e `"cached_engine_group_id"`.

### Regras de verificação de Intent {:#intent-verification-rules}

Um `Intent` é verificado como seguro se:

* **A activity não é exportada:**
  Activities com `android:exported="false"` são confiáveis automaticamente.
* **No Android 14 e superior (API 34+):**
  O UID de inicialização corresponde ao UID do aplicativo (`getLaunchedFromUid()`).
* **No Android 13 e inferior (API 33 e inferiores):**
  O pacote que chama corresponde ao pacote do app (`getCallingPackage()`).
  Isso exige iniciar com `startActivityForResult()`
  ou `startActivityIfNeeded()`.

Para deep links (`Intent.ACTION_VIEW`),
a URI do link deve corresponder a um `<intent-filter>`
declarado no manifesto do aplicativo,
a menos que o `Intent` seja verificado como enviado pelo próprio app.

### Comportamento de fallback {:#fallback-behavior}

Se a verificação falhar em builds de release, os extras são ignorados:

* **Rota inicial (`EXTRA_INITIAL_ROUTE`):**
  Recorre aos argumentos de linha de comando ou aos metadados `io.flutter.InitialRoute`
  no `AndroidManifest.xml`.
  Se nenhum for especificado, o padrão é `"/"`.
* **Entrypoint do Dart (`EXTRA_DART_ENTRYPOINT`):**
  Recorre aos metadados `io.flutter.Entrypoint` no `AndroidManifest.xml`.
  Se não for especificado, o padrão é `"main"`.
* **Argumentos do entrypoint (`EXTRA_DART_ENTRYPOINT_ARGS`):**
  Ignorados; retorna `null`.
* **IDs de engine em cache (`EXTRA_CACHED_ENGINE_ID` e
  `EXTRA_CACHED_ENGINE_GROUP_ID`):**
  Ignorados; retorna `null`.

### Comportamento nos modos debug e profile {:#behavior-in-debug-and-profile-modes}

Em builds de debug e profile,
o embedder ignora a verificação para preservar as ferramentas de desenvolvimento
(como `adb shell am start`) e os testes automatizados.
No entanto, se um `Intent` falhar na verificação,
o embedder registra um aviso com o componente de destino,
os extras do intent e as instruções de migração.

## Guia de migração {:#migration-guide}

Você não precisa migrar se:

* Você não passa os extras `route`, `dart_entrypoint`, `dart_entrypoint_args`,
  `cached_engine_id` ou `cached_engine_group_id` em `Intent`s.
* Sua `FlutterActivity` ou `FlutterFragmentActivity` de destino
  não é exportada (`android:exported="false"`).

Se você passa esses extras para uma activity exportada,
escolha uma das seguintes estratégias de migração:

### Defina as activities hospedeiras como não exportadas {:#set-host-activities-to-non-exported}

Se apps externos não precisam abrir sua activity diretamente,
defina `android:exported="false"` no `AndroidManifest.xml`:

```xml title="AndroidManifest.xml"
<activity
    android:name=".MyFlutterActivity"
    android:exported="false">
</activity>
```

:::note
A activity principal de inicialização do seu app (com `ACTION_MAIN`
e `CATEGORY_LAUNCHER`) deve continuar exportada para que o launcher do sistema
possa iniciar o seu app.
:::

### Migre para deep links no roteamento externo {:#migrate-to-deep-links-for-external-routing}

Para navegar para telas específicas a partir de fontes externas,
atalhos ou notificações,
use [deep links][] padrão em vez de `EXTRA_INITIAL_ROUTE`:

```java
Intent intent = new Intent(context, MainActivity.class);
intent.setAction(Intent.ACTION_VIEW);
intent.setData(Uri.parse("myapp://product_details"));
```

Declare entradas `<intent-filter>` correspondentes no `AndroidManifest.xml`
para que o embedder possa validar a URL recebida.

### Declare entrypoints e rotas no AndroidManifest.xml {:#declare-entrypoints-and-routes-in-androidmanifestxml}

Para entrypoints estáticos ou rotas iniciais,
declare-os como `<meta-data>` no `AndroidManifest.xml`:

```xml title="AndroidManifest.xml"
<activity 
    android:name=".MyFlutterActivity"
    android:exported="true">
    <meta-data
        android:name="io.flutter.Entrypoint"
        android:value="myCustomEntrypoint" />
    <meta-data
        android:name="io.flutter.InitialRoute"
        android:value="/customRoute" />
</activity>
```

### Use startActivityForResult no Android 13 e inferior {:#use-startactivityforresult-on-android-13-and-earlier}

Para inicializações internas do app em uma activity exportada no Android 13 e inferior,
chame `startActivityForResult()` em vez de `startActivity()`:

```diff
- startActivity(intent);
+ startActivityForResult(intent, REQUEST_CODE);
```

Isso preenche `getCallingPackage()`, permitindo que o embedder verifique
que o `Intent` se originou do seu app.
Você não precisa tratar o resultado em `onActivityResult()`.

### Sobrescreva métodos de configuração em uma subclasse de activity {:#override-configuration-methods-in-an-activity-subclass}

Para fornecer entrypoints ou argumentos dinâmicos sem depender de extras de `Intent`,
crie uma subclasse de `FlutterActivity` ou `FlutterFragmentActivity`
e sobrescreva os métodos de configuração:

```java
public class MyFlutterActivity extends FlutterActivity {
    @NonNull
    @Override
    public String getDartEntrypointFunctionName() {
        return ConfigManager.getEntrypoint(); 
    }
    
    @Nullable
    @Override
    public List<String> getDartEntrypointArgs() {
        return ConfigManager.getArgs();
    }
}
```

## Linha do tempo {:#timeline}

<<<<<<< pt
Incluído na versão: 3.50.0-0.1.pre<br>
Na versão estável: Ainda não
||||||| base_en
Landed in version: 3.50.0-0.1.pre<br>
In stable release: Not yet
=======
Landed in version: 3.50.0-0.1.pre<br>
In stable release: 3.50
>>>>>>> new_en

## Referências {:#references}

* [Filtros de `Intent` do Android][Android `Intent` filters]
* [Configure deep links do Android no Flutter][Set up Flutter Android deep links]

Issues relevantes:

* [Issue 190450][]
* [Issue 190452][]

PR relevante:

* [PR 190249][]

[`Intent`]: https://developer.android.com/reference/android/content/Intent
[deep links]: /cookbook/navigation/set-up-app-links
[intent filters]: https://developer.android.com/guide/components/intents-filters
[Android `Intent` filters]:
https://developer.android.com/guide/components/intents-filters
[Set up Flutter Android deep links]: /cookbook/navigation/set-up-app-links
[Issue 190450]: https://github.com/flutter/flutter/issues/190450
[Issue 190452]: https://github.com/flutter/flutter/issues/190452
[PR 190249]: https://github.com/flutter/flutter/pull/190249

