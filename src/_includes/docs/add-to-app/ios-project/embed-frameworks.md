### Linkar e incorporar frameworks no Xcode {:#method-b .no_toc}

#### Abordagem {:#method-b-approach}

Neste segundo método, edite seu projeto Xcode existente,
gere os frameworks necessários e incorpore-os em seu app.
O Flutter gera frameworks iOS para o próprio Flutter,
para seu código Dart compilado e para cada um dos seus plugins Flutter.
Incorpore esses frameworks e atualize as configurações de compilação da sua aplicação existente.

#### Requisitos {:#method-b-reqs}

Nenhum software ou hardware adicional é necessário para este método.
Use este método nos seguintes casos de uso:

* Membros da sua equipe não podem instalar o Flutter SDK e CocoaPods
* Você não quer usar o CocoaPods como gerenciador de dependências em apps iOS existentes

#### Limitações {:#method-b-limits}

{% render "docs/add-to-app/ios-project/limits-common-deps.md" %}

#### Estrutura de projeto de exemplo {:#method-b-structure}

{% render "docs/add-to-app/ios-project/embed-framework-directory-tree.md" %}

#### Procedimentos

Como você linka, incorpora, ou ambos, os frameworks gerados
em seu app existente no Xcode depende do tipo de framework.

* Linke e incorpore frameworks dinâmicos.
* Linke frameworks estáticos. [Nunca incorpore-os][static-framework].

{% render "docs/add-to-app/ios-project/link-and-embed.md" %}

[static-framework]: https://developer.apple.com/library/archive/technotes/tn2435/_index.html
