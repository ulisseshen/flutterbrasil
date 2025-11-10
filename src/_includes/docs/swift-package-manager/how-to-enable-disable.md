---
ia-translate: true
---

## Como ativar o Swift Package Manager {:#how-to-turn-on-swift-package-manager}

O suporte ao Swift Package Manager do Flutter está desativado por padrão.
Para ativá-lo:

1. Atualize para a versão mais recente do Flutter SDK:

   ```sh
   flutter upgrade
   ```

1. Ative o recurso Swift Package Manager:

   ```sh
   flutter config --enable-swift-package-manager
   ```

Usar a CLI do Flutter para executar um app [migra o projeto][addSPM] para adicionar
integração com Swift Package Manager.
Isso faz com que seu projeto baixe os pacotes Swift dos quais
seus plugins Flutter dependem.
Um app com integração ao Swift Package Manager requer Flutter versão 3.24 ou
superior.
Para usar uma versão mais antiga do Flutter,
você precisará [remover a integração ao Swift Package Manager][removeSPM]
do app.

O Flutter volta a usar CocoaPods para dependências que ainda não suportam Swift
Package Manager.

## Como desativar o Swift Package Manager {:#how-to-turn-off-swift-package-manager}

:::secondary Autores de plugins
Autores de plugins precisam ativar e desativar o suporte ao Swift Package Manager
do Flutter para testes.
Desenvolvedores de apps não precisam desativar o suporte ao Swift Package Manager,
a menos que estejam enfrentando problemas.

Se você encontrar um bug no suporte ao Swift Package Manager do Flutter,
[abra uma issue][open an issue].
:::

Desativar o Swift Package Manager faz com que o Flutter use CocoaPods para todas
as dependências.
No entanto, o Swift Package Manager permanece integrado ao seu projeto.
Para remover completamente a integração ao Swift Package Manager do seu projeto,
siga as instruções de [Como remover a integração ao Swift Package Manager][removeSPM].

### Desativar para um único projeto

No arquivo `pubspec.yaml` do projeto, sob a seção `flutter`,
adicione `disable-swift-package-manager: true`.

```yaml title="pubspec.yaml"
# The following section is specific to Flutter packages.
flutter:
  disable-swift-package-manager: true
```

Isso desativa o Swift Package Manager para todos os contribuidores deste projeto.

### Desativar globalmente para todos os projetos

Execute o seguinte comando:

```sh
flutter config --no-enable-swift-package-manager
```

Isso desativa o Swift Package Manager para o usuário atual.

Se um projeto for incompatível com o Swift Package Manager, todos os contribuidores
precisam executar este comando.

[addSPM]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-add-swift-package-manager-integration
[removeSPM]: /packages-and-plugins/swift-package-manager/for-app-developers#how-to-remove-swift-package-manager-integration
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml
