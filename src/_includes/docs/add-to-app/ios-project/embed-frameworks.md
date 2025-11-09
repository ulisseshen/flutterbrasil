### Vincule e incorpore frameworks no Xcode {:#method-b .no_toc}

#### Abordagem {:#method-b-approach}

Neste segundo método, edite seu projeto Xcode existente,
gere os frameworks necessários e os incorpore no seu app.
Flutter gera frameworks iOS para o próprio Flutter,
para seu código Dart compilado e para cada um de seus plugins Flutter.
Incorpore esses frameworks e atualize as configurações de build da sua aplicação existente.

#### Requisitos {:#method-b-reqs}

Nenhum requisito adicional de software ou hardware é necessário para este método.
Use este método nos seguintes casos de uso:

* Membros da sua equipe não podem instalar o Flutter SDK e CocoaPods
* Você não quer usar CocoaPods como gerenciador de dependências em apps iOS existentes

#### Limitações {:#method-b-limits}

{% render "docs/add-to-app/ios-project/limits-common-deps.md" %}

#### Estrutura do projeto de exemplo {:#method-b-structure}

{% render "docs/add-to-app/ios-project/embed-framework-directory-tree.md" %}

#### Procedimentos

Como você vincula, incorpora ou ambos os frameworks gerados
na sua app existente no Xcode depende do tipo de framework.

* Vincule e incorpore frameworks dinâmicos.
* Vincule frameworks estáticos. [Nunca os incorpore][static-framework].

{% render "docs/add-to-app/ios-project/link-and-embed.md" %}

[static-framework]: https://developer.apple.com/library/archive/technotes/tn2435/_index.html
