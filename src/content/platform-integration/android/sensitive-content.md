---
ia-translate: true
title: Proteja o conteúdo sensível do seu app
shortTitle: Conteúdo sensível
description: >-
  Aprenda como proteger conteúdo sensível em seu app Flutter.
---

Este recurso está disponível no Android API 35+, e você pode experimentá-lo usando
o widget [`SensitiveContent`][SensitiveContent]. Veja o guia abaixo para detalhes.

## Sobre o widget `SensitiveContent`

Você pode usar o widget `SensitiveContent` em seu app para definir a sensibilidade
de conteúdo de um `Widget` filho para um dos seguintes valores [`ContentSensitivity`][ContentSensitivity]:
`notSensitive`, `sensitive`, ou `autoSensitive`. O modo que você
escolher ajuda a determinar se a tela do dispositivo deve ser obscurecida
(apagada) durante projeção de mídia para proteger os dados sensíveis dos usuários.

Você pode ter quantos widgets `SensitiveContent` em seu app desejar,
mas se _qualquer_ um desses widgets tiver um valor de conteúdo `sensitive`, então a
tela será obscurecida durante projeção de mídia. Assim, para a maioria dos casos de uso,
usar múltiplos widgets `SensitiveContent` não fornece vantagem sobre ter
um widget `SensitiveContent` na árvore de widgets do seu app. Este recurso está
disponível no Android API 35+ e não tem efeito em versões de API inferiores e
outras plataformas.

:::note
O valor `autoSensitive` não é suportado a partir do Flutter 3.35 e se comporta
da mesma forma que `notSensitive`. Veja a [Issue #160879][Issue #160879] para mais informações.
:::

## Usando o widget `SensitiveContent`

Dado algum conteúdo que você deseja proteger do compartilhamento de tela de mídia
(por exemplo, um widget `MySensitiveContent()`), você pode envolvê-lo com o
widget `SensitiveContent` como mostrado no seguinte exemplo:

```dart
class MyWidget extends StatelessWidget {
  ...
  Widget build(BuildContext context) {
    return SensitiveContent(
      sensitivity: ContentSensitivity.sensitive,
      child: MySensitiveContent(),
    );
  }
}
```

Quando rodando no Android API 34 e abaixo, a tela não será obscurecida
durante projeção de mídia. O widget existirá na árvore mas não tem outro
efeito, e você não precisa evitar usos de `SensitiveContent` em plataformas
que não suportam este recurso.

## Para mais informações

Para mais informações, visite a documentação da API [`SensitiveContent`][SensitiveContent]
e [`ContentSensitivity`][ContentSensitivity].

[SensitiveContent]: {{site.api}}/flutter/widgets/SensitiveContent-class.html
[ContentSensitivity]: {{site.api}}/flutter/services/ContentSensitivity.html
[Issue #160879]: {{site.github}}/flutter/flutter/issues/160879
