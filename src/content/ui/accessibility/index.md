---
title: Acessibilidade
description: Informações sobre o suporte de acessibilidade do Flutter.
ia-translate: true
---

## Contexto

Garantir que os aplicativos sejam acessíveis a uma ampla gama de usuários é uma
parte essencial da construção de um aplicativo de alta qualidade. Aplicativos mal
projetados criam barreiras para pessoas de todas as idades. A [Convenção da ONU sobre
os Direitos das Pessoas com Deficiência][CRPD] afirma o imperativo moral e legal
de garantir acesso universal a sistemas de informação; países ao redor do mundo
aplicam a acessibilidade como um requisito; e as empresas reconhecem as vantagens
comerciais de maximizar o acesso aos seus serviços.

Nós encorajamos fortemente que você inclua uma lista de verificação de acessibilidade
como um critério chave antes de lançar seu aplicativo. O Flutter está comprometido em
apoiar desenvolvedores na criação de aplicativos mais acessíveis e inclui suporte de
framework de primeira classe para acessibilidade, além daquele fornecido pelo sistema
operacional subjacente, incluindo:

[Design e estilização de UI][]

[Suporte a tecnologias assistivas (leitor de tela)][]

[Design e estilização de UI]: /ui/accessibility/ui-design-and-styling
[Suporte a tecnologias assistivas (leitor de tela)]:/ui/accessibility/assistive-technologies

## Regulamentações de acessibilidade

Padrões e regulamentações de acessibilidade ajudam a garantir que os produtos sejam
acessíveis a pessoas com deficiência. Muitos deles foram transformados em leis e
políticas, tornando-os requisitos para produtos e serviços.

*   **WCAG 2**: As [Diretrizes de Acessibilidade para Conteúdo Web (WCAG) 2][] são um
padrão internacionalmente reconhecido para tornar o conteúdo web mais acessível
a pessoas com deficiência. É um padrão técnico estável desenvolvido pelo
World Wide Web Consortium (W3C).

*   **EN 301 549**: A [EN 301 549][] é o padrão harmonizado europeu para
requisitos de acessibilidade para produtos e serviços de Tecnologia da Informação
e Comunicação (TIC).

*   **VPAT**: O [Modelo Voluntário de Acessibilidade de Produto (VPAT)][] é um
modelo gratuito que traduz requisitos e padrões de acessibilidade em critérios
acionáveis de teste para produtos e serviços.

Leis ao redor do mundo exigem que conteúdo e serviços digitais sejam acessíveis
a pessoas com deficiência.
Nos EUA, a [Lei dos Americanos com Deficiências (ADA)][] proíbe
discriminação em acomodações públicas.
A [Seção 508 do Ato de Reabilitação][] exige que agências federais e seus
contratados atendam aos padrões WCAG para todas as TIC.

Na UE, a [Lei Europeia de Acessibilidade (EAA)][] exige que uma ampla gama de
serviços do setor público e privado sejam acessíveis, usando principalmente
a [EN 301 549][] como sua base técnica.



[Diretrizes de Acessibilidade para Conteúdo Web (WCAG) 2]: https://www.w3.org/WAI/standards-guidelines/wcag/
[EN 301 549]: https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf
[Modelo Voluntário de Acessibilidade de Produto (VPAT)]: https://www.itic.org/policy/accessibility/vpat

[Lei dos Americanos com Deficiências (ADA)]: https://www.ada.gov/
[Seção 508 do Ato de Reabilitação]: https://www.section508.gov/
[Lei Europeia de Acessibilidade (EAA)]: https://commission.europa.eu/strategy-and-policy/policies/justice-and-fundamental-rights/disability/union-equality-strategy-rights-persons-disabilities-2021-2030/european-accessibility-act_en


## Construindo com acessibilidade em mente

Garantir que seu aplicativo possa ser usado por todos significa incorporar acessibilidade
desde o início. Para alguns aplicativos, isso é mais fácil dizer do que fazer.
No vídeo abaixo, dois dos nossos engenheiros levam um aplicativo móvel de um estado
de acessibilidade precário para um que aproveita os widgets integrados do Flutter
para oferecer uma experiência dramaticamente mais acessível.

{% ytEmbed 'bWbBgbmAdQs', 'Building Flutter apps with accessibility in mind' %}


## Lista de verificação de acessibilidade para lançamento

Aqui está uma lista não exaustiva de coisas a considerar ao preparar seu
aplicativo para lançamento.

* **Interações ativas**. Certifique-se de que todas as interações ativas façam
  algo. Qualquer botão que possa ser pressionado deve fazer algo quando pressionado.
  Por exemplo, se você tem um callback no-op para um evento `onPressed`, mude-o
  para mostrar um `SnackBar` na tela explicando qual controle você acabou de pressionar.
* **Teste com leitor de tela**. O leitor de tela deve ser capaz de
  descrever todos os controles na página quando você tocar neles, e as
  descrições devem ser inteligíveis. Teste seu aplicativo com [TalkBack][]
  (Android) e [VoiceOver][] (iOS).
* **Taxas de contraste**. Encorajamos que você tenha uma taxa de contraste de pelo
  menos 4.5:1 entre controles ou texto e o fundo, com exceção de componentes
  desabilitados. Imagens também devem ser verificadas quanto ao contraste suficiente.
* **Mudança de contexto**. Nada deve mudar o contexto do usuário
  automaticamente enquanto ele digita informações. Geralmente, os widgets
  devem evitar mudar o contexto do usuário sem algum tipo de ação de confirmação.
* **Alvos tocáveis**. Todos os alvos tocáveis devem ter pelo menos 48x48 pixels.
* **Erros**. Ações importantes devem poder ser desfeitas. Em campos
  que mostram erros, sugira uma correção, se possível.
* **Teste de deficiência de visão de cores**. Os controles devem ser usáveis e
  legíveis em modos de daltonismo e escala de cinza.
* **Fatores de escala**. A interface do usuário deve permanecer legível e usável em fatores
  de escala muito grandes para tamanho de texto e dimensionamento de exibição.

[TalkBack]: https://support.google.com/accessibility/android/answer/6283677?hl=en
[VoiceOver]: https://www.apple.com/lae/accessibility/iphone/vision/

## Saiba mais

Para saber mais sobre Flutter e acessibilidade, confira
os seguintes artigos escritos por membros da comunidade:

* [Um mergulho profundo nos widgets de acessibilidade do Flutter][]
* [Semantics no Flutter][]
* [Flutter: Criando uma ótima experiência para leitores de tela][]

[CRPD]: https://www.un.org/development/desa/disabilities/convention-on-the-rights-of-persons-with-disabilities/article-9-accessibility.html
[Um mergulho profundo nos widgets de acessibilidade do Flutter]: {{site.medium}}/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc
[Flutter: Criando uma ótima experiência para leitores de tela]: https://blog.gskinner.com/archives/2022/09/flutter-crafting-a-great-experience-for-screen-readers.html
[Semantics no Flutter]: https://www.didierboelens.com/2018/07/semantics/
