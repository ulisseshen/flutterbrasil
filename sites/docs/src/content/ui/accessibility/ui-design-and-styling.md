---
title: Design e estilização de UI
description: Informações sobre o suporte de acessibilidade do Flutter.
ia-translate: true
---

Para criar um app acessível, projete sua UI com acessibilidade em mente.
Esta página cobre aspectos-chave do design e estilização de UI acessível.

## Fontes grandes {:#large-fonts}

Tanto Android quanto iOS contêm configurações de sistema para configurar os tamanhos de fonte
desejados usados pelos apps. Widgets de texto do Flutter respeitam essa configuração do SO ao
determinar tamanhos de fonte.

Os tamanhos de fonte são calculados automaticamente pelo Flutter com base na configuração do SO.
No entanto, como desenvolvedor você deve garantir que seu layout tenha espaço suficiente para
renderizar todo seu conteúdo quando os tamanhos de fonte forem aumentados.
Por exemplo, você pode testar todas as partes do seu app em um dispositivo de tela pequena
configurado para usar a maior configuração de fonte.

Para ajustar tamanhos de fonte: no iOS, vá em
Settings > Accessibility > Display & Text Size;
no Android, vá em Settings > Font size.

### Exemplo {:#example}

As duas capturas de tela a seguir mostram o template padrão do app Flutter
renderizado com a configuração de fonte padrão do iOS,
e com a maior configuração de fonte selecionada nas configurações de acessibilidade do iOS.

<div class="wrapping-row">
  <DashImage figure image="a11y/app-regular-fonts.png" caption="Default font setting" img-class="simple-border" img-style="max-height: 480px;" />
  <DashImage figure image="a11y/app-large-fonts.png" caption="Largest accessibility font setting" img-class="simple-border" img-style="max-height: 480px;" />
</div>


## Contraste suficiente {:#sufficient-contrast}

Contraste de cor suficiente torna texto e imagens mais fáceis de ler.
Além de beneficiar usuários com diversas deficiências visuais,
contraste de cor suficiente ajuda todos os usuários ao visualizar uma interface
em dispositivos em condições de iluminação extremas,
como quando expostos à luz solar direta ou em uma tela com baixo
brilho.

O [W3C recomenda][W3C recommends]:

* Pelo menos 4.5:1 para texto pequeno (abaixo de 18 pontos regular ou 14 pontos negrito)
* Pelo menos 3.0:1 para texto grande (18 pontos e acima regular ou 14 pontos e
  acima negrito)

Você pode testar o contraste usando a [API Accessibility Guideline][Accessibility Guideline API] do Flutter.
Para mais detalhes sobre testes, confira a [página de testes de acessibilidade][accessibility testing page].

[W3C recommends]: https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html
[accessibility testing page]: /ui/accessibility/accessibility-testing/

## Tamanho do alvo de toque {:#tap-target-size}

Controles que são muito pequenos são difíceis para muitas pessoas interagirem e selecionarem.
Garanta que elementos interativos tenham um alvo de toque grande o suficiente para ser facilmente
pressionado pelos usuários.

Tanto [Android][] quanto [iOS][] recomendam um tamanho mínimo de alvo de toque de 48x48 dp e 44x44 pts respectivamente.

O [W3C][] recomenda um tamanho mínimo de alvo de 44 por 44 pixels CSS.

Você pode testar o tamanho do alvo de toque usando a [API Accessibility Guideline][Accessibility Guideline API] do Flutter.
Para mais detalhes sobre testes, confira a [página de testes de acessibilidade][accessibility testing page].

[Android]: https://developer.android.com/guide/topics/ui/accessibility/apps#large-controls
[iOS]: https://developer.apple.com/design/human-interface-guidelines/accessibility#Mobility
[W3C]: https://www.w3.org/WAI/WCAG21/Understanding/target-size.html

[Accessibility Guideline API]: {{site.api}}/flutter/flutter_test/AccessibilityGuideline-class.html

## Outros recursos de acessibilidade {:#other-accessibility-features}

Você pode verificar a classe [AccessibilityFeatures][] para recursos de
acessibilidade adicionais que podem ser habilitados pela plataforma,
como texto em negrito, alto contraste e cores invertidas.

[AccessibilityFeatures]: https://api.flutterbrasil.dev/flutter/dart-ui/AccessibilityFeatures-class.html
