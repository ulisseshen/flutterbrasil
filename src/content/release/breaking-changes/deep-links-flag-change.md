---
ia-translate: true
title: Mudança na flag de deep links
description: >-
  Se você usa um pacote de plugin de deep linking de terceiros para apps móveis,
  defina a flag de deep linking do Flutter como false.
---

{% render "docs/breaking-changes.md" %}

## Resumo

**Esta breaking change afeta apenas apps móveis que
usam um pacote de plugin de deep linking de terceiros.**

O valor padrão para a opção de deep linking do Flutter mudou de
`false` para `true`, o que significa que o deep linking agora é opt-in por padrão.

## Guia de migração

Se você está usando a configuração padrão de deep linking do Flutter,
esta não é uma breaking change para você.

No entanto, se você está usando um plugin de terceiros para deep links,
como os seguintes, esta atualização introduz uma breaking change:

- [Firebase dynamic links](https://firebase.google.com/docs/dynamic-links)
- [`package:uni_link`]({{site.pub-pkg}}/uni_links)
- [`package:app_links`]({{site.pub-pkg}}/app_links)
- [`package:flutter_branch_sdk`]({{site.pub-pkg}}/flutter_branch_sdk)

Neste caso, você deve redefinir manualmente a
opção de deep linking do Flutter para `false`.

Dentro do arquivo `AndroidManifest.xml` do seu app para Android:

```xml title="AndroidManifest.xml" highlightLines=4
<manifest>
   <application
       <activity>
<meta-data android:name="flutter_deeplinking_enabled" android:value="false" />
       </activity>
   </application>
</manifest>
```

Dentro do arquivo `info.plist` do seu app para iOS:

```xml title="info.plist"
 <key>FlutterDeepLinkingEnabled</key>
 <false/>
```

## Cronograma

Aterrissou na versão: 3.25.0-0.1.pre<br>
Lançamento estável: 3.27

## Referências

Documento de design:

- [flutterbrasil.dev/go/deep-link-flag-migration]({{site.main-url}}/go/deep-link-flag-migration)

PR relevante:

* [Set deep linking flag to true by default]({{site.github}}/flutter/engine/pull/52350)
