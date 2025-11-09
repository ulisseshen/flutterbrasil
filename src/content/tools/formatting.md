---
ia-translate: true
title: Formatação de código
description: >-
  O formatador de código do Flutter formata seu código
  seguindo as diretrizes de estilo recomendadas.
---


Embora seu código possa seguir qualquer estilo preferido&mdash;em nossa
experiência&mdash;equipes de desenvolvedores podem achar mais produtivo:

* Ter um único estilo compartilhado, e
* Aplicar esse estilo através de formatação automática.

A alternativa frequentemente são debates cansativos sobre formatação durante revisões de código,
onde o tempo poderia ser melhor gasto no comportamento do código ao invés do estilo do código.

## Formatando código automaticamente no VS Code

Instale a extensão `Flutter` (veja [VS Code setup][VS Code setup])
para obter formatação automática de código no VS Code.

Para formatar automaticamente o código na janela de código-fonte atual,
clique com o botão direito na janela de código e selecione `Format Document`.
Você pode adicionar um atalho de teclado para isso nas **Preferences** do VS Code.

Para formatar código automaticamente sempre que você salvar um arquivo, defina a
configuração `editor.formatOnSave` como `true`.

[VS Code setup]: /tools/vs-code#setup

## Formatando código automaticamente no Android Studio e IntelliJ

Instale o plugin `Dart` (veja [Android Studio and IntelliJ setup][Android Studio and IntelliJ setup])
para obter formatação automática de código no Android Studio e IntelliJ.
Para formatar seu código na janela de código-fonte atual:

* No macOS,
  pressione <kbd>Cmd</kbd> + <kbd>Option</kbd> + <kbd>L</kbd>.
* No Windows e Linux,
  pressione <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>.

Android Studio e IntelliJ também fornecem uma caixa de seleção chamada
**Format code on save** na página Flutter em **Preferences**
no macOS ou **Settings** no Windows e Linux.
Esta opção corrige a formatação no arquivo atual quando você o salva.

[Android Studio and IntelliJ setup]: /tools/android-studio#setup

## Formatando código automaticamente com o comando `dart`

Para corrigir a formatação do código na interface de linha de comando (CLI),
execute o comando `dart format`:

```console
$ dart format path1 path2 [...]
```

Para aprender mais sobre o formatador Dart,
confira a documentação do dart.dev sobre [`dart format`][`dart format`].

[`dart format`]: {{site.dart-site}}/tools/dart-format
