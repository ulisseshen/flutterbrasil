---
title: Definir padrão de `SystemUiMode` para edge-to-edge
description: >-
    Por padrão, apps que visam Android SDK 15+ serão incluídos
    no modo edge-to-edge.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

:::note
Você pode ter encontrado esta página porque viu um aviso no Google Play
Console sobre "Edge-to-edge may not display for all users" ou "Your app
uses deprecated APIs or parameters for edge-to-edge".
Esses avisos **não** impactarão os usuários.

Este aviso referencia código obsoleto usado no engine Flutter para implementar
o modo edge-to-edge. O engine depende deste código obsoleto para evitar mudanças
que quebram a compatibilidade para os usuários, então continuará a funcionar caso você defina o modo edge-to-edge
no seu app. Veja [flutter#169810] para mais informações.
:::

## Summary

Se o seu app Flutter visa a versão 15 do Android SDK,
seu app é exibido automaticamente no modo edge-to-edge,
como documentado na página da API [`SystemUiMode`][].
Para manter o comportamento de app não-edge-to-edge
(incluindo um `SystemUiMode` não definido),
siga os passos no [migration guide](#migration-guide).

:::note
Se o seu app Flutter visa a versão 16 ou posterior do Android SDK,
seu app é exibido automaticamente no modo edge-to-edge, e você
não pode desativar. Para saber mais sobre esta mudança, confira as
[notas de lançamento do Android 16][Android 16 release notes].
:::

[`SystemUiMode`]: {{site.api}}/flutter/services/SystemUiMode.html

## Context

Por padrão, o Android impõe o [modo edge-to-edge][edge-to-edge mode] para todos os apps que
visam Android 15 ou posterior.
Para saber mais sobre esta mudança, confira as [notas de lançamento do Android 15][Android 15 release notes].
Isso impacta dispositivos rodando Android SDK 15+ ou API 35+.

Antes do Flutter 3.27, apps Flutter visam Android 14 por padrão e
não serão incluídos no modo edge-to-edge automaticamente, mas
seu app _será_ impactado quando você escolher visar Android 15.
Se o seu app visa `flutter.targetSdkVersion` (como faz por padrão),
então ele visa Android 15 a partir da versão 3.27 do Flutter,
incluindo automaticamente seu app no edge-to-edge.

Se o seu app define explicitamente `SystemUiMode.edgeToEdge` para rodar em
modo edge-to-edge chamando [`SystemChrome.setEnabledSystemUIMode`][],
então seu app já está migrado. Apps que precisam de mais tempo para migrar para
o modo edge-to-edge devem usar os passos a seguir para desativar em
dispositivos rodando Android SDK 15.

Esteja ciente do seguinte:

 1. O Android planeja que a solução alternativa detalhada aqui seja temporária.
 2. O Flutter planeja se alinhar com Android (e iOS) para
    suportar edge-to-edge por padrão dentro do ano, então
    **migre para o modo edge-to-edge antes que o sistema operacional
    remova a capacidade de desativar**.

[edge-to-edge mode]: {{site.android-dev}}/develop/ui/views/layout/edge-to-edge
[Android 15 release notes]: {{site.android-dev}}/about/versions/15/behavior-changes-15#edge-to-edge
[Android 16 release notes]: {{site.android-dev}}/about/versions/16/behavior-changes-16#edge-to-edge
[`SystemChrome.setEnabledSystemUIMode`]: {{site.api}}/flutter/services/SystemChrome/setEnabledSystemUIMode.html

## Migration guide

Para desativar edge-to-edge no SDK 15, especifique
o novo atributo de estilo em cada activity que o requer.
Se você tem um estilo pai do qual estilos filhos precisam desativar,
você pode modificar apenas o pai.
No exemplo a seguir,
atualize a configuração de estilo gerada de `flutter create`.

Por padrão, os estilos usados em um app Flutter são definidos no
arquivo de manifest Android (`your_app/android/app/src/main/AndroidManifest.xml`).
Geralmente, estilos são denotados por `@style` e ajudam a tematizar seu app.
Modifique esses estilos padrão no seu arquivo de manifest:

```xml title="AndroidManifest.xml" highlightLines=5-8
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>
        <activity ...>
            <!-- Style to modify: -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
            />
        </activity>
    </application>
</manifest>
```

Localize a definição de estilo em:
`your_app/android/app/src/main/res/values/styles.xml`.

Adicione o seguinte atributo aos estilos apropriados:

```xml title="styles.xml" highlightLines=6,12
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        ...
        <!-- Add the following line: -->
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
    </style>
    ...
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        ...
	      <!-- Add the following line: -->
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
    </style>
</resources>
```

Certifique-se de aplicar a mesma mudança no arquivo de estilos do modo noturno também:
`your_app/android/app/src/main/res/values-night/styles.xml`.

Garanta que ambos os estilos sejam atualizados consistentemente em ambos os arquivos.

Este estilo modificado desativa edge-to-edge para seu app em
apps que visam Android SDK 15.
Então agora você terminou!

## Timeline

A partir do Flutter 3.27, apps Flutter visam Android 15 por padrão, então
se você deseja usar esta versão e não definir manualmente
uma versão de SDK de destino mais baixa para seu app Flutter,
siga os [passos de migração](#migration-guide) anteriores para
manter um `SystemUiMode` não definido ou não-edge-to-edge.

Landed in version: 3.26.0-0.0.pre<br>
Stable release: 3.27

## References

* [Os `SystemUiMode`s suportados do Flutter][The supported Flutter `SystemUiMode`s]
* [O guia de mudanças de comportamento edge-to-edge do Android 15][The Android 15 edge-to-edge behavior changes guide]
* [O guia de mudanças de comportamento edge-to-edge do Android 16][The Android 16 edge-to-edge behavior changes guide]

[The supported Flutter `SystemUiMode`s]: {{site.api}}/flutter/services/SystemUiMode.html
[The Android 15 edge-to-edge behavior changes guide]: {{site.android-dev}}/about/versions/15/behavior-changes-15#edge-to-edge
[The Android 16 edge-to-edge behavior changes guide]: {{site.android-dev}}/about/versions/16/behavior-changes-16#edge-to-edge
[flutter#169810]: https://github.com/flutter/flutter/issues/169810
