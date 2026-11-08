---
ia-translate: true
title: Migração para AndroidX
description: Como migrar projetos Flutter existentes para AndroidX.
---

{% render "docs/breaking-changes.md" %}

:::note
Você pode ser direcionado para esta página se o Flutter detectar
que seu projeto não usa AndroidX.
:::

[AndroidX][AndroidX] é uma melhoria importante
da biblioteca original Android Support Library.

Ela fornece as bibliotecas de pacote `androidx.*`,
separadas da API da plataforma. Isso significa que ela
oferece compatibilidade retroativa e é atualizada
com mais frequência do que a plataforma Android.

[AndroidX]: {{site.android-dev}}/jetpack/androidx

## Perguntas Comuns

### Como migrar meu app, plugin ou projeto de módulo editável existente para AndroidX?

_Você precisará do Android Studio 3.2 ou superior.
Se você não o tiver instalado,
pode baixar a versão mais recente no
site do [Android Studio][Android Studio]_.

1. Abra o Android Studio.
2. Selecione **Open an existing Android Studio Project**.
3. Abra o diretório `android` dentro do seu app.
4. Aguarde até que o projeto seja sincronizado com sucesso.
   (Isso acontece automaticamente quando você abre o projeto,
   mas se não acontecer, selecione **Sync Project with Gradle Files**
   no menu **File**).
5. Selecione **Migrate to AndroidX** no menu Refactor.
6. Se for solicitado que você faça backup do projeto antes de prosseguir,
   marque **Backup project as Zip file** e clique em **Migrate**.
   Por fim, salve o arquivo zip no local de sua preferência.
   <img width="500" src="/assets/images/docs/androidx/migrate_prompt.png" alt="Select backup project as zip file" />
7. A pré-visualização de refatoração mostra a lista de alterações.
   Por fim, clique em **Do Refactor**:
   <img width="600" src="/assets/images/docs/androidx/do_androidx_refactor.png" alt="An animation of the bottom-up page transition on Android" />
8. É isso! Você migrou seu projeto para AndroidX com sucesso.

Por fim, se você migrou um plugin,
publique a nova versão AndroidX no pub e atualize
seu `CHANGELOG.md` para indicar que esta nova versão
é compatível com AndroidX.

[Android Studio]: {{site.android-dev}}/studio

### E se eu não puder usar o Android Studio?

Você pode criar um novo projeto usando a ferramenta Flutter
e então mover o código Dart e os
assets para o novo projeto.

Para criar um novo projeto, execute:

```console
flutter create -t <project-type> <new-project-path>
```

### Add to app

Se seu projeto Flutter é um tipo de módulo para adicionar
a um app Android existente e contém um
diretório `.android`, adicione a seguinte linha ao `pubspec.yaml`:

```yaml
 module:
   ...
    androidX: true # Add this line.
```

Por fim, execute `flutter clean`.

Se o seu módulo contiver um diretório `android`,
então siga as etapas da seção anterior.

### Como saber se meu projeto está usando AndroidX?

A partir do Flutter v1.12.13, novos projetos criados com
`flutter create -t <project-type>`
usam AndroidX por padrão.

Projetos criados antes desta versão do Flutter
não devem depender de nenhum [old build artifact][old build artifact] ou
[old Support Library class][old Support Library class].

[old build artifact]: {{site.android-dev}}/jetpack/androidx/migrate/artifact-mappings
[old Support Library class]: {{site.android-dev}}/jetpack/androidx/migrate/class-mappings

Em um projeto de app ou módulo,
o arquivo `android/gradle.properties`
ou `.android/gradle.properties`
deve conter:

```properties
android.useAndroidX=true
android.enableJetifier=true
```

### E se eu não migrar meu app ou módulo para AndroidX?

Seu app pode continuar a funcionar. No entanto,
combinar artefatos AndroidX e Support
geralmente não é recomendado porque pode
resultar em conflitos de dependência ou
outros tipos de falhas do Gradle.
Como resultado, à medida que mais plugins migram para AndroidX,
plugins que dependem de bibliotecas principais do Android provavelmente
causarão falhas de compilação.

### E se meu app foi migrado para AndroidX, mas nem todos os plugins que uso foram?

A ferramenta Flutter usa o Jetifier para migrar automaticamente
plugins Flutter que usam a Support Library
para AndroidX, para que você possa usar os mesmos plugins mesmo
se eles ainda não tiverem sido migrados para AndroidX.

### Estou tendo problemas ao migrar para AndroidX

[Abra uma issue no GitHub][Open an issue on GitHub] e adicione `[androidx-migration]`
ao título da issue.

[Open an issue on GitHub]: {{site.repo.flutter}}/issues/new/choose
