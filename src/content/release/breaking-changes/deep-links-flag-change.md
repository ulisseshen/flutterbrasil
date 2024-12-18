---
ia-translate: true
title: Mudança na flag de Deep links
description: >
  Se você usa um pacote de plugin de deep linking de terceiros para aplicativos móveis,
  defina a flag de deep linking do Flutter como false.
---

## Resumo

<b>Essa mudança (potencialmente) quebra compatibilidade apenas afeta aplicativos móveis e apenas se
você usa um pacote de plugin de deep linking de terceiros.</b>

O valor padrão para a flag de deep linking do Flutter mudou de `false` para `true`,
o que significa que o deep linking agora é ativado por padrão.

## Guia de migração

Se você estiver usando a configuração padrão de deep linking do Flutter, esta não é uma mudança que quebra compatibilidade para você.

No entanto, se você estiver usando um plugin de terceiros para deep links,
como os seguintes, esta atualização introduz uma mudança que quebra a compatibilidade:

[firebase dynamic links](https://firebase.google.com/docs/dynamic-links)
[uni_link](https://pub.dev/packages/uni_links)
[app_links](https://pub.dev/packages/app_links)

Nesse caso, você deve redefinir manualmente a flag de deep linking do Flutter para `false`.

Antes: não-op

Depois:

Desative manualmente a flag de deep linking se você usar um plugin de terceiros:

* Arquivo Android Manifest

```yaml
<manifest>
   <application
       <activity>
<meta-data android:name="flutter_deeplinking_enabled" android:value="false" />
       </activity>
   </application>
</manifest>
```

* Arquivo info.plist do iOS

```yaml
   <key>FlutterDeepLinkingEnabled</key>
   <false/>
```

## Linha do tempo

Implementado na versão: 3.27.0-0.0.pre<br>
Lançamento estável: 3.27

## Referências

Documentação de design:
flutter.dev/go/deep-link-flag-migration.

PR relevante:

* [Set deep linking flag to true by defaulte]({{site.github}}/flutter/engine/pull/52350)
