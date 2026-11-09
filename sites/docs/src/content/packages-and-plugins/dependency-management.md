---
ia-translate: true
title: Gerenciamento de dependências de pacotes
description: >-
  Saiba como o Flutter e o Dart resolvem as dependências de pacotes
  e como lidar com conflitos de versão.
---

Ao criar um app Flutter, você costuma usar pacotes externos para adicionar funcionalidades.
Cada pacote pode depender de outros pacotes, criando uma árvore de dependências.
Entender como o Dart e o Flutter gerenciam essas dependências ajuda você a
resolver conflitos de versão e manter o seu app estável.

## Como funciona a resolução de dependências {:#how-dependency-resolution-works}

O seu projeto Flutter especifica as dependências no arquivo `pubspec.yaml`.
Quando você executa `flutter pub get`,
o gerenciador de pacotes resolve as dependências e
registra as versões exatas no arquivo `pubspec.lock`.

### Dependências diretas e transitivas {:#direct-and-transitive-dependencies}

Uma dependência pode ser direta ou transitiva:

**Dependências diretas**
: Os pacotes que você lista explicitamente nas seções `dependencies` ou
  `dev_dependencies` do seu arquivo `pubspec.yaml`.

**Dependências transitivas**
: Os pacotes dos quais as suas dependências diretas dependem.
  Você não lista esses pacotes no seu arquivo `pubspec.yaml`,
  mas o seu projeto precisa deles para compilar.

### O arquivo pubspec.lock {:#the-pubspec-lock-file}

O arquivo `pubspec.lock` contém a versão exata de cada dependência direta e
transitiva usada no seu projeto.
Esse arquivo garante que todos os desenvolvedores da sua equipe e os seus servidores de build
usem exatamente as mesmas versões dos pacotes.
Faça commit do arquivo `pubspec.lock` no controle de versão para projetos de aplicativo,
mas não para projetos de pacote.

:::note Use intervalos de versão, não versões exatas
Como o `pubspec.lock` sempre fixa versões exatas para builds previsíveis,
você deve usar intervalos no seu arquivo `pubspec.yaml`
(podendo usar a sintaxe caret descrita abaixo).
Isso permite que o solucionador de versões encontre
versões compatíveis das dependências transitivas
e possibilita atualizar as dependências com segurança usando `flutter pub upgrade`.
:::

## O papel do solucionador de versões {:#the-role-of-the-version-solver}

Diferente de alguns gerenciadores de pacotes,
o gerenciador de pacotes do Dart (`pub`) permite apenas uma
única versão de qualquer pacote na árvore de compilação do seu app.

Essa restrição existe por vários motivos:

1.  **Segurança de tipos:**
    Se o seu app usar duas versões do mesmo pacote,
    você pode receber erros de incompatibilidade de tipos.
    Por exemplo, se `v1` e `v2` de um pacote definirem ambas uma classe `User`,
    o compilador do Dart trata as duas como tipos distintos.
    Você não pode passar um `v1.User` para um método que espera um `v2.User`.
1.  **Tamanho do binário:**
    Incluir várias versões do mesmo pacote
    aumenta o tamanho do seu aplicativo.
1.  **Estado global:**
    Muitos pacotes usam variáveis globais ou singletons.
    Ter várias cópias do pacote pode
    levar a estado inconsistente ou bugs.

O trabalho do solucionador de versões é analisar todas as restrições de versão das
suas dependências diretas e transitivas e encontrar uma
única versão concreta para cada pacote que satisfaça todas as restrições.

## Entenda as restrições de versão {:#understand-version-constraints}

Ao declarar uma dependência no `pubspec.yaml`,
você especifica uma restrição de versão.
Os pacotes Dart usam [Versionamento Semântico][Semantic Versioning] (SemVer).
Um número de versão tem três partes: `major.minor.patch` (por exemplo, `2.1.4`).

Você pode definir restrições de versão no seu arquivo `pubspec.yaml`
usando diferentes sintaxes:

[Semantic Versioning]: https://semver.org/spec/v2.0.0-rc.1.html

### Sintaxe caret {:#caret-syntax}

A sintaxe caret (`^`) é a forma mais comum de definir uma restrição de versão.
Ela instrui o solucionador a usar qualquer versão compatível com a versão especificada.

* Para versões estáveis (1.0.0 e superiores),
  o caret permite atualizações que não alteram a versão major:
  * `^1.2.3` é equivalente a `>=1.2.3 <2.0.0`
* Para versões pré-lançamento ou anteriores à 1.0.0,
  qualquer mudança na versão minor ou patch pode introduzir mudanças incompatíveis.
  Por isso, a restrição caret é mais restritiva:
  * `^0.8.0` é equivalente a `>=0.8.0 <0.9.0`
  * `^0.0.3` é equivalente a `>=0.0.3 <0.0.4`

### Intervalos tradicionais {:#traditional-ranges}

Você pode definir intervalos de versão explícitos usando operadores de comparação:

```yaml
dependencies:
  url_launcher: '>=5.4.0 <6.0.0'
```

### Qualquer versão {:#any-version}

Se você não especificar uma restrição de versão ou usar `any`,
o solucionador pode escolher qualquer versão:

```yaml
dependencies:
  url_launcher: any
```

:::note Evite usar `any`
Não recomendamos usar `any`, porque uma futura atualização do pacote pode
introduzir mudanças incompatíveis que quebrem o seu build.
:::

## Entenda os conflitos de dependência {:#understand-dependency-conflicts}

Um conflito de dependência ocorre quando dois pacotes na sua árvore de dependências exigem
versões incompatíveis da mesma dependência transitiva.

Considere este cenário de exemplo:

1.  O seu app depende de duas dependências diretas: `package_a` e `package_b`.
1.  `package_a` depende de `foo: ^1.0.0`.
1.  `package_b` depende de `foo: ^2.0.0`.

![Conflito do solucionador de versões](/assets/images/docs/development/packages-and-plugins/version-solver.png)

Como `foo` não pode ser ao mesmo tempo `^1.0.0` (que é `<2.0.0`) e
`^2.0.0` (que é `>=2.0.0`), o solucionador de versões falha.

Quando você executa `flutter pub get` ou tenta compilar o app,
o solucionador exibe uma mensagem de erro:

```console
Because every version of package_a depends on foo ^1.0.0 and
every version of package_b depends on foo ^2.0.0,
package_a is incompatible with package_b.
So, because my_app depends on both package_a ^1.0.0
and package_b ^1.0.0, version solving failed.
```

Para ler essa mensagem de erro, siga o conflito de baixo para cima no grafo de dependências:

1.  Identifique o pacote em conflito (`foo`).
1.  Descubra quais pacotes exigem versões conflitantes.
    Por exemplo, `package_a` exige `foo: ^1.0.0` e
    `package_b` exige `foo: ^2.0.0`.
1.  Verifique quais dependências diretas trazem esses pacotes conflitantes.
    Por exemplo, `my_app` depende de
    `package_a: ^1.0.0` e `package_b: ^1.0.0`.

## Resolva os conflitos de dependência {:#resolve-dependency-conflicts}

Você pode usar os passos a seguir para resolver conflitos de dependência.

### Atualize as versões dos pacotes {:#upgrade-package-versions}

Antes de fazer alterações manuais, verifique se existem versões mais novas e
compatíveis das suas dependências.
Execute o comando a seguir para atualizar os seus pacotes para as
versões mais recentes permitidas pelas restrições do seu `pubspec.yaml`:

```bash
flutter pub upgrade
```

Para ver quais pacotes têm versões mais novas além das suas restrições atuais, execute:

```bash
flutter pub outdated
```

Para atualizar para versões major mais novas,
execute `flutter pub upgrade --major-versions`.
Esse comando atualiza as restrições no seu arquivo `pubspec.yaml`
para permitir as versões mais recentes resolvíveis e, em seguida,
executa `flutter pub get` para obter essas dependências atualizadas.

### Use substituições de dependência {:#use-dependency-overrides}

Se não existirem versões compatíveis porque um dos pacotes não foi atualizado,
você pode forçar o solucionador de versões a usar uma versão específica.
Adicione uma seção `dependency_overrides` ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  package_a: ^1.0.0
  package_b: ^1.0.0

dependency_overrides:
  foo: ^2.0.0
```

Isso substitui todas as restrições de `foo` e
força o solucionador de versões a usar `^2.0.0`.

:::warning
Use substituições de dependência apenas como uma correção temporária.
Se os pacotes não forem realmente compatíveis,
contornar o solucionador de versões pode causar
erros de compilação ou falhas em tempo de execução (como `NoSuchMethodError`).
Teste bem o seu app depois de aplicar uma substituição.
:::

:::note
As substituições de dependência se aplicam somente ao pacote raiz.
Se você estiver desenvolvendo um pacote para publicar no pub.dev,
não inclua `dependency_overrides` no seu arquivo `pubspec.yaml`, porque
outros projetos que dependem do seu pacote vão ignorá-las.
:::

### Apoie o ecossistema {:#support-the-ecosystem}

Se um pacote não tem mais manutenção ou é lento para ser atualizado,
você pode ajudar a resolver o problema:

1.  **Abra uma issue:**
    Pesquise no repositório do pacote por issues existentes ou
    abra uma nova issue para avisar o mantenedor.
1.  **Envie um pull request:**
    Se você puder corrigir o conflito, faça um fork do repositório do pacote,
    atualize as restrições e envie um pull request.
1.  **Use uma dependência git ou de caminho:**
    Enquanto aguarda o mantenedor aceitar o seu pull request,
    você pode apontar o seu `pubspec.yaml` para o seu fork ou para uma cópia local:

    ```yaml
    dependencies:
      package_a:
        git:
          url: https://github.com/your-username/package_a.git
          ref: update-foo-dependency
    ```

## Saiba mais {:#learn-more}

Para mais informações sobre como o Dart gerencia dependências,
consulte os recursos a seguir:

* [Versionamento de pacotes][Package versioning] no dart.dev
* [Dependências do pub][Pub dependencies] no dart.dev
* [Substituições de dependência][Dependency overrides] no dart.dev

[Dependency overrides]: {{site.dart-site}}/tools/pub/dependencies#dependency-overrides
[Package versioning]: {{site.dart-site}}/tools/pub/versioning
[Pub dependencies]: {{site.dart-site}}/tools/pub/dependencies
