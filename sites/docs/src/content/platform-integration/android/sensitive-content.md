---
ia-translate: true
title: Proteja o conteúdo sensível do seu app
shortTitle: Conteúdo sensível
description: >-
  Aprenda como proteger conteúdo sensível em seu app Flutter.
---

O widget [`SensitiveContent`][SensitiveContent] permite que você impeça
que telas que contêm conteúdo sensível (como senhas)
sejam projetadas. Para saber mais,
confira o seguinte vídeo de dois minutos do Widget of the Week:

<YouTubeEmbed id="WnzHARTIZww"
  title="SensitiveContent | Flutter widget of the week"></YouTubeEmbed>

## Sobre o widget `SensitiveContent` {:#about-the-sensitivecontent-widget}

Você pode usar o widget `SensitiveContent` em seu app para definir a sensibilidade
de conteúdo de um `Widget` filho para um dos seguintes valores [`ContentSensitivity`][ContentSensitivity]:
`notSensitive`, `sensitive`, ou `autoSensitive`.
O modo escolhido determina se a tela do dispositivo deve ser obscurecida
(apagada) durante projeção de mídia para proteger dados sensíveis.

Você pode ter quantos widgets `SensitiveContent` em seu app desejar,
mas se _qualquer_ um desses widgets tiver um valor de conteúdo `sensitive`, então a
tela inteira é obscurecida durante projeção de mídia. Assim, para a maioria dos casos de uso,
usar múltiplos widgets `SensitiveContent` não fornece vantagem sobre ter
um widget `SensitiveContent` na árvore de widgets do seu app.

Este recurso está disponível no Android API 35+
e não tem efeito em versões de API inferiores ou outras plataformas.

:::note
O valor `autoSensitive` não é suportado a partir do Flutter 3.35 e se comporta
da mesma forma que `notSensitive`. Veja a [Issue #160879][Issue #160879] para mais informações.
:::

[Issue #160879]: {{site.repo.flutter}}/issues/160879

## Usando o widget `SensitiveContent` {:#using-the-sensitivecontent-widget}

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

Quando executado no Android API 34 e abaixo, a tela não será obscurecida
durante projeção de mídia. O widget existirá na árvore mas não tem outro
efeito, e você não precisa evitar usos de `SensitiveContent` em plataformas
que não suportam este recurso.

## Para mais informações {:#for-more-information}

Para mais informações, visite a documentação da API [`SensitiveContent`][SensitiveContent]
e [`ContentSensitivity`][ContentSensitivity].

[SensitiveContent]: {{site.api}}/flutter/widgets/SensitiveContent-class.html
[ContentSensitivity]: {{site.api}}/flutter/services/ContentSensitivity.html
