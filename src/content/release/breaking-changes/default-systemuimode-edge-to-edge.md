---
ia-translate: true
title: Definir o padrão para SystemUiMode como Edge-to-Edge
description: >
    Por padrão, aplicativos com SDK Android 15+ terão o modo
    edge-to-edge ativado.
---

## Resumo
Se o seu aplicativo Flutter tem como alvo o SDK Android versão 15 ou superior,
seu aplicativo será exibido automaticamente no modo edge-to-edge,
como mostrado na página da API [`SystemUiMode`][1].
Para manter o comportamento do aplicativo não edge-to-edge
(incluindo um `SystemUiMode` não definido),
use as informações no [guia de migração](#guia-de-migração).

## Contexto
Por padrão, o Android impõe o [modo edge-to-edge][2] para todos os aplicativos
que têm como alvo o Android 15 e versões posteriores. Para mais detalhes,
confira as [notas de versão do Android][3]. Isso afeta dispositivos
executando no SDK Android 15+ ou API 35+.

Anterior à versão do quarto trimestre de 2024, os aplicativos Flutter
tinham como alvo o Android 14 por padrão e não ativavam o modo
edge-to-edge automaticamente, mas seu aplicativo _será_ afetado
quando você escolher usar o Android 15. Se seu aplicativo tem como alvo
`flutter.targetSdkVersion` (como faz por padrão), então terá como alvo
o Android 15 a partir da versão 3.26 do Flutter, ativando automaticamente
o modo edge-to-edge. Visite a [linha do tempo](#linha-do-tempo) para
detalhes. Se seu aplicativo define explicitamente `SystemUiMode.edgeToEdge`
para executar no modo edge-to-edge chamando
[`SystemChrome.setEnabledSystemUIMode`][4], então seu aplicativo
já está migrado. Aplicativos que precisam de mais tempo para migrar para
o modo edge-to-edge devem usar os seguintes passos para desativá-lo
em dispositivos executando o SDK Android 15+.

Esteja ciente do seguinte:

1.  O Android planeja que a solução alternativa detalhada aqui seja
    temporária.
2.  O Flutter planeja se alinhar com o Android (e iOS) para
    suportar edge-to-edge por padrão dentro do ano,
    portanto, **migre para o modo edge-to-edge antes que o sistema
    operacional remova a capacidade de desativá-lo**.

## Guia de migração

Para desativar o edge-to-edge no SDK 15, especifique o novo atributo
de estilo em cada atividade que o requer. Se você tiver um estilo
pai do qual os estilos filhos precisam desativar, você pode modificar
apenas o pai. No exemplo a seguir, atualize o estilo gerado a partir
de `flutter create`.

Por padrão, os estilos usados em um aplicativo Flutter são definidos
no arquivo de manifesto (`seu_app/android/app/src/main/AndroidManifest.xml`).
Geralmente, os estilos são denotados por `@style` e ajudam a definir
o tema do seu aplicativo. Modifique esses estilos padrão em seu
manifesto:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>
        <activity ...>
            <!-- Estilo que você precisará modificar: -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
            />
        </activity>
    </application>
</manifest>
```

Encontre onde esse estilo é definido em
`seu_app/android/app/src/main/res/values/styles.xml`.
Lá, adicione o seguinte atributo ao estilo:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        ...
	    <!-- Adicione a seguinte linha: -->
        <item name="android:windowOptOutEdgeToEdgeEnforcement">true</item>
    </style>
</resources>
```

Este estilo modificado desativa o edge-to-edge para
aplicativos que têm como alvo o SDK Android 15+. Então agora você
terminou!

## Linha do tempo
Os aplicativos Flutter terão como alvo o Android 15 na próxima versão
estável (3.26), portanto, se você deseja usar esta versão e não
definir manualmente uma versão de SDK alvo inferior para seu
aplicativo Flutter, estas [etapas de migração](#guia-de-migração)
serão necessárias para manter um `SystemUiMode` não definido ou
não edge-to-edge.

## Referências

*   [Os `SystemUiMode`s do Flutter suportados][1]
*   [O guia de mudanças de comportamento edge-to-edge do Android 15][3]


[1]: {{site.api}}/flutter/services/SystemUiMode.html
[2]: {{site.android-dev}}/develop/ui/views/layout/edge-to-edge
[3]: {{site.android-dev}}/about/versions/15/behavior-changes-15#edge-to-edge
[4]: {{site.api}}/flutter/services/SystemChrome/setEnabledSystemUIMode.html

