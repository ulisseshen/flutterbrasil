---
ia-translate: true
title: Classe IconData marcada como final
description: >-
  A classe IconData agora é marcada como final,
  impedindo que seja estendida ou implementada.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A classe `IconData` agora é marcada como [`final`][],
o que impede que seja implementada ou estendida.
Essa mudança faz parte de um esforço para generalizar o
mecanismo de tree-shaking de assets e código nativo.

[`final`]: {{site.dart-site}}/language/class-modifiers#final

## Contexto {:#background}

A equipe do Flutter está trabalhando em um mecanismo generalizado para
trazer o tree-shaking de assets e código nativo para pacotes.
O Icon Tree Shaker específico existente
está sendo incorporado a esse mecanismo geral.

Por questões de desempenho, localidade e compreensibilidade, o mecanismo geral não
oferece suporte ao registro de instâncias `const` em hierarquias de tipos complexas.
Por isso, a classe `IconData` agora é marcada como `final`.

Código que implementa ou estende `IconData` agora
falha na compilação com o seguinte erro:

```text
The class 'IconData' is 'final' and can't be extended or implemented outside of its library.
```

## Guia de migração {:#migration-guide}

Em vez de implementar `IconData`,
como com um `enum` que oferece suporte a dot shorthand,
segurança de tipos e uma lista `.values` automatizada,
use uma classe wrapper com instâncias `static const`.

### Migrando tipos de ícone personalizados {:#migrating-custom-icon-types}

Se você usava um `enum` que implementa `IconData`,
migre para uma classe com instâncias `static const` e um widget personalizado.

Código antes da migração:

```dart
enum AppIcons implements IconData {
  arrowUpward(0xe062),
  arrowDownward(0xe061);

  const AppIcons(this.codePoint)
    : fontFamily = 'MaterialIcons',
      fontPackage = null,
      matchTextDirection = false;

  @override
  final int codePoint;
  @override
  final String? fontFamily;
  @override
  final String? fontPackage;
  @override
  final bool matchTextDirection;
}

Widget build(BuildContext context) {
  // Example usage of AppIcons:
  return Icon(AppIcons.arrowUpward);
}
```

Para manter o suporte a dot shorthand e a segurança de tipos,
use uma classe wrapper e um widget personalizado.

Código após a migração:

```dart
final class AppIconData {
  final IconData iconData;

  const AppIconData._(this.iconData);

  static const arrowUpward = AppIconData._(
    IconData(0xe062, fontFamily: 'MaterialIcons'),
  );
  static const arrowDownward = AppIconData._(
    IconData(0xe061, fontFamily: 'MaterialIcons'),
  );

  static const values = [arrowUpward, arrowDownward];
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key});
  final AppIconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon.iconData);
  }
}

Widget build(BuildContext context) {
  // Usage preserves dot shorthand if the type can be inferred:
  return const AppIcon(AppIconData.arrowUpward);
  // Or if inferred: const AppIcon(.arrowUpward)
}
```

Se você depende de `.values` para ferramentas como o Widgetbook,
pode manter a lista `values` manualmente, como no
exemplo anterior, ou usar geração de código.

### Ignore o lint `mustBeConst` {:#ignore-the-mustbeconst-lint}

Para habilitar o tree-shaking, alguns parâmetros de `IconData` são
marcados com a anotação `mustBeConst`.
Se você precisar usar um `IconData` não const e
estiver disposto a abrir mão do tree-shaking para esse ícone,
adicione um comentário de ignorar para o lint.

```dart
// ignore: non_const_argument_for_const_parameter
Icon(myDynamicIconData);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.44.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

PR relevante:

* [Mark `IconData` `final` and `@mustBeConst`][pr-181345]

Issues relevantes:

* [Breaking Change: Marking `class IconData` as `final`][issue-181342]
* [Marking `IconData`'s constructor parameters as `@mustBeConst`][issue-181344]

[pr-181345]: {{site.repo.flutter}}/pull/181345
[issue-181342]: {{site.repo.flutter}}/issues/181342
[issue-181344]: {{site.repo.flutter}}/issues/181344
