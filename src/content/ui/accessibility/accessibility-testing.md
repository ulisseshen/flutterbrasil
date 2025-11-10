---
ia-translate: true
title: Testes de acessibilidade
description: Informações sobre testes de acessibilidade no Flutter.
---

## Regulamentações de acessibilidade

Para garantir que seu app seja acessível, verifique-o em relação aos padrões públicos como as
[Diretrizes de Acessibilidade para Conteúdo Web (WCAG) 2][Web Content Accessibility Guidelines (WCAG) 2], a [EN 301 549][EN 301 549],
e use recursos como o [Modelo Voluntário de Acessibilidade de Produto (VPAT)][Voluntary Product Accessibility Template (VPAT)]
para autoavaliar seu produto. Para mais detalhes sobre essas
regulamentações, consulte a [página principal de acessibilidade][accessibility page].


[Web Content Accessibility Guidelines (WCAG) 2]: https://www.w3.org/WAI/standards-guidelines/wcag/
[EN 301 549]: https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf
[Voluntary Product Accessibility Template (VPAT)]: https://www.itic.org/policy/accessibility/vpat
[accessibility page]: /ui/accessibility

## Inspecionando o suporte à acessibilidade

Recomendamos usar scanners automatizados de acessibilidade para testar o seguinte:

* Para Android:
    1. Instale o [Accessibility Scanner][Accessibility Scanner] para Android
    1. Habilite o Accessibility Scanner em
       **Android Settings > Accessibility >
       Accessibility Scanner > On**.
    1. Navegue até o botão de ícone 'checkbox' do Accessibility Scanner
       para iniciar uma varredura.

* Para iOS:
    1. Abra a pasta `iOS` do seu app Flutter no Xcode.
    1. Selecione um Simulator como o destino e clique no botão **Run**.
    1. No Xcode, selecione
       **Xcode > Open Developer Tools > Accessibility Inspector**.
    1. No Accessibility Inspector,
       selecione **Inspection > Enable Point to Inspect**,
       e então selecione os vários elementos da interface do usuário no seu
       app Flutter em execução para inspecionar seus atributos de acessibilidade.
    1. No Accessibility Inspector,
       selecione **Audit** na barra de ferramentas e então
       selecione **Run Audit** para obter um relatório de possíveis problemas.

* Para web:
    1. Abra o Chrome DevTools (ou ferramentas similares em outros navegadores).
    2. Inspecione a árvore HTML sob semantics host, contendo os atributos ARIA
       gerados pelo Flutter.
    3. No Chrome, a aba "Elements" possui uma sub-aba "Accessibility"
       que pode ser usada para inspecionar os dados exportados para a árvore de semântica.


## Testando acessibilidade no mobile

Teste seu app usando a [API de Diretrizes de Acessibilidade do Flutter][Accessibility Guideline API].
Esta API verifica se a UI do seu app atende às recomendações de acessibilidade do Flutter.
Elas cobrem recomendações para contraste de texto, tamanho de destino e rótulos de destino.

O trecho a seguir mostra como usar a API de Diretrizes em
um widget de exemplo chamado `AccessibleApp`:

<?code-excerpt "accessibility/test/a11y_test.dart"?>
```dart title="test/a11y_test.dart"
import 'package:flutter_test/flutter_test.dart';
import 'package:your_accessible_app/main.dart';

void main() {
  testWidgets('Follows a11y guidelines', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(const AccessibleApp());

    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
```

Para experimentar esses testes, execute-os no app que você cria no
codelab [Escreva seu primeiro app Flutter][Write your first Flutter app].
Cada botão na tela principal desse app serve como um destino tocável
com texto renderizado em uma fonte de 18 pontos.

Você pode adicionar testes da API de Diretrizes junto com outros [testes de widget][widget tests],
ou em um arquivo separado, como `test/a11y_test.dart` neste exemplo.

[Accessibility Guideline API]: {{site.api}}/flutter/flutter_test/AccessibilityGuideline-class.html
[Write your first Flutter app]: /get-started/codelab
[widget tests]: /testing/overview#widget-tests

## Testando acessibilidade na web

Você pode debugar acessibilidade visualizando os nós semânticos criados para seu app web
usando o seguinte flag de linha de comando nos modos profile e release:

```console
flutter run -d chrome --profile --dart-define=FLUTTER_WEB_DEBUG_SHOW_SEMANTICS=true
```

Com o flag ativado, os nós semânticos aparecem sobre os widgets;
você pode verificar que os elementos semânticos estão posicionados onde deveriam estar.
Se os nós semânticos estiverem posicionados incorretamente, por favor [registre um relatório de bug][file a bug report].

[Accessibility Scanner]: https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en
[file a bug report]: https://goo.gle/flutter_web_issue
