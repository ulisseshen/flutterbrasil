---
ia-translate: true
title: Flutter fix
description: Mantenha seu código atualizado com a ajuda do recurso Flutter Fix.
---

À medida que o Flutter continua evoluindo, fornecemos uma ferramenta para ajudá-lo a limpar
APIs descontinuadas de sua base de código. A ferramenta é incluída como parte do Flutter e
sugere mudanças que você pode querer fazer em seu código. A ferramenta está disponível
a partir da linha de comando, e também está integrada nos plugins de IDE para Android
Studio e Visual Studio Code.

:::tip
Essas atualizações automatizadas são chamadas de _quick-fixes_ no IntelliJ e Android
Studio, e _code actions_ no VS Code.
:::

## Aplicando correções individuais

Você pode usar qualquer IDE compatível
para aplicar uma única correção por vez.

### IntelliJ e Android Studio

Quando o analisador detecta uma API descontinuada,
uma lâmpada aparece nessa linha de código.
Clicar na lâmpada exibe a correção sugerida
que atualiza esse código para a nova API.
Clicar na correção sugerida executa a atualização.

![Screenshot showing suggested change in IntelliJ](/assets/images/docs/development/tools/flutter-fix-suggestion-intellij.png)<br>
Um exemplo de quick-fix no IntelliJ

### VS Code

Quando o analisador detecta uma API descontinuada,
ele apresenta um erro.
Você pode fazer qualquer um dos seguintes:

* Passe o mouse sobre o erro e clique no link
  **Quick Fix**.
  Isso apresenta uma lista filtrada mostrando
  _apenas_ correções.

* Coloque o cursor no código com o erro e clique no
  ícone de lâmpada que aparece.
  Isso mostra uma lista de todas as ações, incluindo
  refatorações.

* Coloque o cursor no código com o erro e
  pressione o atalho
  (**Command+.** no macOS, **Control+.** em outros sistemas)
  Isso mostra uma lista de todas as ações, incluindo
  refatorações.

![Screenshot showing suggested change in VS Code](/assets/images/docs/development/tools/flutter-fix-suggestion-vscode.png)<br>
Um exemplo de code action no VS Code

## Aplicando correções em todo o projeto

[dart fix Decoding Flutter][dart fix Decoding Flutter]

Para ver ou aplicar mudanças em um projeto inteiro,
você pode usar a ferramenta de linha de comando, [`dart fix`][`dart fix`].

Esta ferramenta tem duas opções:

* Para ver uma lista completa de mudanças disponíveis, execute
  o seguinte comando:

  ```console
  $ dart fix --dry-run
  ```

* Para aplicar todas as mudanças em massa, execute o
  seguinte comando:

  ```console
  $ dart fix --apply
  ```

Para mais informações sobre descontinuações do Flutter, veja
[Deprecation lifetime in Flutter][Deprecation lifetime in Flutter], um artigo gratuito
na publicação Medium do Flutter.


[Deprecation lifetime in Flutter]: {{site.flutter-blog}}/deprecation-lifetime-in-flutter-e4d76ee738ad
[`dart fix`]: {{site.dart-site}}/tools/dart-fix
[dart fix Decoding Flutter]: {{site.yt.watch}}?v=OBIuSrg_Quo
