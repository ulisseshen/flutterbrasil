---
ia-translate: true
title: Migração para AndroidX
description: Como migrar projetos Flutter existentes para AndroidX.
---

:::note
Você pode ser direcionado a esta página se o Flutter detectar
que seu projeto não usa AndroidX.
:::

[AndroidX][] é uma grande melhoria
para a Biblioteca de Suporte Android original.

Ela fornece as bibliotecas de pacotes `androidx.*`,
desvinculadas da API da plataforma. Isso significa que ela
oferece compatibilidade com versões anteriores e é atualizada
com mais frequência do que a plataforma Android.

[AndroidX]: {{site.android-dev}}/jetpack/androidx

## Perguntas Comuns

### Como migro meu aplicativo, plugin ou projeto de módulo editável pelo host existente para AndroidX?

_Você precisará do Android Studio 3.2 ou superior.
Se você não o tiver instalado,
pode baixar a versão mais recente do site do
[Android Studio][]_.

1. Abra o Android Studio.
2. Selecione **Open an existing Android Studio Project** (Abrir um Projeto Android Studio Existente).
3. Abra o diretório `android` dentro do seu aplicativo.
4. Espere até que o projeto seja sincronizado com sucesso.
   (Isso acontece automaticamente quando você abre o projeto,
   mas se não acontecer, selecione **Sync Project with Gradle Files** (Sincronizar Projeto com Arquivos Gradle)
   no menu **File** (Arquivo)).
5. Selecione **Migrate to AndroidX** (Migrar para AndroidX) no menu Refactor.
6. Se você for solicitado a fazer backup do projeto antes de prosseguir,
   marque **Backup project as Zip file** (Fazer backup do projeto como arquivo Zip) e clique em **Migrate** (Migrar).
   Por fim, salve o arquivo zip no local de sua preferência.
  <img
      width="500"
      style="border-radius: 12px;"
      src="/assets/images/docs/androidx/migrate_prompt.png"
      class="figure-img img-fluid"
      alt="Selecionar backup do projeto como arquivo zip" />
7. A visualização da refatoração mostra a lista de alterações.
   Finalmente, clique em **Do Refactor** (Refatorar):
  <img
      width="600"
      style="border-radius: 12px;"
      src="/assets/images/docs/androidx/do_androidx_refactor.png"
      class="figure-img img-fluid"
      alt="Uma animação da transição de página de baixo para cima no Android" />
8. É isso! Você migrou seu projeto para AndroidX com sucesso.

Finalmente, se você migrou um plugin,
publique a nova versão AndroidX no pub e atualize
seu `CHANGELOG.md` para indicar que esta nova versão
é compatível com AndroidX.

[Android Studio]: {{site.android-dev}}/studio

### E se eu não puder usar o Android Studio?

Você pode criar um novo projeto usando a ferramenta Flutter
e, em seguida, mover o código Dart e os
assets para o novo projeto.

Para criar um novo projeto, execute:

```console
flutter create -t <tipo-de-projeto> <novo-caminho-do-projeto>
```

### Adicionar ao aplicativo

Se o seu projeto Flutter for um tipo de módulo para adicionar
a um aplicativo Android existente e contiver um
diretório `.android`, adicione a seguinte linha em `pubspec.yaml`:

```yaml
 module:
   ...
    androidX: true # Adicione esta linha.
```

Finalmente, execute `flutter clean`.

Se o seu módulo contiver um diretório `android`,
siga os passos da seção anterior.

### Como sei se meu projeto está usando AndroidX?

A partir do Flutter v1.12.13, novos projetos criados com
`flutter create -t <tipo-de-projeto>`
usam AndroidX por padrão.

Projetos criados antes desta versão do Flutter
não devem depender de nenhum [artefato de build antigo][] ou
[classe antiga da Biblioteca de Suporte][].

[artefato de build antigo]: {{site.android-dev}}/jetpack/androidx/migrate/artifact-mappings
[classe antiga da Biblioteca de Suporte]: {{site.android-dev}}/jetpack/androidx/migrate/class-mappings

Em um aplicativo ou projeto de módulo,
o arquivo `android/gradle.properties`
ou `.android/gradle.properties`
deve conter:

```properties
android.useAndroidX=true
android.enableJetifier=true
```

### E se eu não migrar meu aplicativo ou módulo para AndroidX?

Seu aplicativo pode continuar funcionando. No entanto,
combinar artefatos AndroidX e Support
geralmente não é recomendado porque pode
resultar em conflitos de dependência ou
outros tipos de falhas do Gradle.
Como resultado, à medida que mais plugins migram para AndroidX,
plugins que dependem das bibliotecas principais do Android provavelmente
causarão falhas de build.

### E se meu aplicativo for migrado para AndroidX, mas nem todos os plugins que uso?

A ferramenta Flutter usa o Jetifier para migrar automaticamente
os plugins Flutter que usam a Biblioteca de Suporte
para AndroidX, para que você possa usar os mesmos plugins mesmo
que eles ainda não tenham sido migrados para AndroidX.

### Estou tendo problemas para migrar para AndroidX

[Abra um issue no GitHub][] e adicione `[androidx-migration]`
ao título do issue.

[Abra um issue no GitHub]: {{site.repo.flutter}}/issues/new/choose
