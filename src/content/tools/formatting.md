---
ia-translate: true
title: Formatação de código
description: >
    O formatador de código do Flutter formata seu código
    seguindo as diretrizes de estilo recomendadas.
---

Embora seu código possa seguir qualquer estilo preferido&mdash;em nossa
experiência&mdash;equipes de desenvolvedores podem achar mais produtivo:

*   Ter um único estilo compartilhado e
*   Impor esse estilo por meio da formatação automática.

A alternativa costuma ser debates cansativos sobre formatação durante as revisões de código,
onde o tempo poderia ser melhor gasto no comportamento do código em vez do estilo do código.

## Formatação automática de código no VS Code

Instale a extensão `Flutter` (consulte
[Configuração do editor](/get-started/editor))
para obter a formatação automática de código no VS Code.

Para formatar automaticamente o código na janela de código-fonte atual,
clique com o botão direito na janela de código e selecione `Formatar Documento`.
Você pode adicionar um atalho de teclado a essas **Preferências** do VS Code.

Para formatar automaticamente o código sempre que você salvar um arquivo, defina a
configuração `editor.formatOnSave` para `true`.

## Formatação automática de código no Android Studio e IntelliJ

Instale o plugin `Dart` (consulte
[Configuração do editor](/get-started/editor))
para obter a formatação automática de código no Android Studio e IntelliJ.
Para formatar seu código na janela de código-fonte atual:

* No macOS,
  pressione <kbd>Cmd</kbd> + <kbd>Option</kbd> + <kbd>L</kbd>.
* No Windows e Linux,
  pressione <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>.

O Android Studio e o IntelliJ também fornecem uma caixa de seleção chamada
**Formatar código ao salvar** na página do Flutter em **Preferências**
no macOS ou **Configurações** no Windows e Linux.
Essa opção corrige a formatação no arquivo atual quando você o salva.

## Formatação automática de código com o comando `dart`

Para corrigir a formatação de código na interface de linha de comando (CLI),
execute o comando `dart format`:

```console
$ dart format path1 path2 [...]
```

## Usando vírgulas finais

O código Flutter geralmente envolve a construção de estruturas de dados em formato de árvore bastante profundas,
por exemplo, em um método `build`. Para obter uma boa formatação automática,
recomendamos que você adote as *vírgulas finais* opcionais.
A diretriz para adicionar uma vírgula final é simples: sempre
adicione uma vírgula final no final de uma lista de parâmetros em
funções, métodos e construtores onde você se importa em
manter a formatação que você criou.
Isso ajuda o formatador automático a inserir uma quantidade apropriada
de quebras de linha para código no estilo Flutter.

Aqui está um exemplo de código formatado automaticamente *com* vírgulas finais:

![Código formatado automaticamente com vírgulas finais](/assets/images/docs/tools/android-studio/trailing-comma-with.png){:width="100%"}

E o mesmo código formatado automaticamente *sem* vírgulas finais:

![Código formatado automaticamente sem vírgulas finais](/assets/images/docs/tools/android-studio/trailing-comma-without.png){:width="100%"}
