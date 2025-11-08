---
ia-translate: true
title: Formatação de código
description: >
    O formatador de código do Flutter formata seu código
    seguindo as diretrizes de estilo recomendadas.
---


Embora seu código possa seguir qualquer estilo preferido&mdash;em nossa
experiência&mdash;equipes de desenvolvedores podem achar mais produtivo:

* Ter um único estilo compartilhado, e
* Aplicar esse estilo através de formatação automática.

A alternativa é frequentemente debates cansativos sobre formatação durante revisões de código,
onde o tempo pode ser melhor gasto no comportamento do código em vez do estilo do código.

## Formatando código automaticamente no VS Code

Instale a extensão `Flutter` (consulte
[Configuração do editor](/get-started/editor))
para obter formatação automática de código no VS Code.

Para formatar automaticamente o código na janela de código-fonte atual,
clique com o botão direito na janela de código e selecione `Format Document`.
Você pode adicionar um atalho de teclado para isso nas **Preferences** do VS Code.

Para formatar automaticamente o código sempre que você salvar um arquivo, defina a
configuração `editor.formatOnSave` como `true`.

## Formatando código automaticamente no Android Studio e IntelliJ

Instale o plugin `Dart` (consulte
[Configuração do editor](/get-started/editor))
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

## Formatando código automaticamente com o comando `dart`

Para corrigir a formatação do código na interface de linha de comando (CLI),
execute o comando `dart format`:

```console
$ dart format path1 path2 [...]
```

## Usando vírgulas finais

Código Flutter frequentemente envolve a construção de estruturas de dados em forma de árvore bastante profundas,
por exemplo, em um método `build`. Para obter uma boa formatação automática,
recomendamos que você adote as *vírgulas finais* opcionais.
A diretriz para adicionar uma vírgula final é simples: Sempre
adicione uma vírgula final no final de uma lista de parâmetros em
funções, métodos e construtores onde você se importa em
manter a formatação que você criou.
Isso ajuda o formatador automático a inserir uma
quantidade apropriada de quebras de linha para código estilo Flutter.

Aqui está um exemplo de código formatado automaticamente *com* vírgulas finais:

![Automatically formatted code with trailing commas](/assets/images/docs/tools/android-studio/trailing-comma-with.png){:width="100%"}

E o mesmo código formatado automaticamente *sem* vírgulas finais:

![Automatically formatted code without trailing commas](/assets/images/docs/tools/android-studio/trailing-comma-without.png){:width="100%"}
