---
ia-translate: true
title: Pigeon
description: >-
  Saiba como usar o Pigeon para gerar vinculações com tipagem segura
  entre o seu código Dart e a plataforma hospedeira.
---

## Visão geral {:#overview}

O [Pigeon][pigeon-pub] substitui a configuração manual de canais de plataforma
brutos por APIs geradas e com tipagem segura.
Isso ajuda a evitar erros de digitação nos nomes de métodos ou tipos de argumentos
incompatíveis.

Para integrações de baixo nível que exigem acesso direto à memória nativa ou a
bibliotecas C e C++, use o [FFIgen](/interop/ffigen) ou o [JNIgen](/interop/jnigen).

## Escolha uma opção de comunicação com o Pigeon {:#choose-a-communication-option-with-pigeon}

O Pigeon oferece suporte a duas opções de comunicação, dependendo da plataforma de
destino e das necessidades de desempenho: interop nativo (FFI e JNI diretos, em prévia)
ou canais de plataforma.

### Pigeon com interop nativo (prévia) {:#pigeon-with-native-interop}

:::note
O Pigeon com interop nativo está em prévia e não é estável para uso em produção.
:::

O Pigeon com interop nativo gera vinculações nativas diretas usando o
[FFIgen](/interop/ffigen) (FFI no iOS e no macOS) e o
[JNIgen](/interop/jnigen) (JNI no Android).

Experimente essa opção de prévia se o seu caso de uso exigir qualquer um dos itens a seguir:

- Você precisa de execução síncrona na sua plataforma nativa.
- Você faz streaming de dados com alta frequência
  (por exemplo, áudio ou frames de câmera).
- Você chama código nativo a partir de isolates Dart em segundo plano.

### Pigeon com canais de plataforma {:#pigeon-with-platform-channels}

O Pigeon com canais de plataforma gera canais de plataforma padrão que oferecem suporte a
Android, iOS, macOS, Windows e Linux.

Use essa opção se o seu caso de uso exigir qualquer um dos itens a seguir:

- Você precisa de suporte a desktop no Windows ou no Linux.
- Você quer zero ferramentas externas de build.

## Fluxo de desenvolvimento {:#developer-flow}

Gere vinculações com tipagem segura usando o Pigeon com os passos a seguir:

1.  Crie o arquivo de definição do Pigeon.
1.  Gere o código.
1.  Implemente a interface nativa.
1.  Chame a API a partir do Flutter.

Para começar, crie um arquivo de definição do Pigeon em Dart
(normalmente fora do diretório `lib/`, como `pigeons/messages.dart`).
Esse arquivo define as estruturas de dados e as interfaces de API
usando anotações do Pigeon, como `@HostApi` e `@FlutterApi`.
Em seguida, execute a ferramenta geradora do Pigeon, que analisa o arquivo de definição
e produz o código necessário tanto para Dart quanto para a sua plataforma nativa de destino.

:::note
Se você estiver usando o Pigeon com a opção de comunicação de interop nativo,
defina `appDirectory`, `swiftOptions: SwiftOptions(useFfi: true, ffiModuleName: 'Runner')`
e `kotlinOptions: KotlinOptions(useJni: true)` na seção `@ConfigurePigeon`
do seu arquivo de definição do Pigeon.
Para ver os pré-requisitos completos e a configuração de build,
consulte o [guia de interop nativo][pigeon-native-guide].
:::

Depois que o código for gerado, implemente as interfaces nativas geradas nos
diretórios específicos de cada plataforma do seu projeto Flutter
(como `android/`, `ios/` ou `macos/`) e registre-as na engine do Flutter.
Por fim, chame as classes Dart geradas no seu app Flutter
(usando `<MyApi>.createWithNativeInteropApi()` ao usar interop nativo),
ou invoque as APIs nativas geradas para chamar o seu código Dart de volta.

Se precisar modificar a API, primeiro altere o arquivo de definição do Pigeon,
gere o código novamente e depois atualize a sua implementação de acordo.

## Exemplos {:#examples}

Para explorar uma implementação completa desse fluxo,
incluindo o arquivo de definição do Pigeon, o código gerado e as implementações nativas,
consulte os exemplos a seguir:

- [Exemplo do Pigeon com interop nativo][pigeon-native-example]
- [Exemplo do Pigeon com canais de plataforma][pigeon-example]
- [Plugin `shared_preferences`][shared-preferences-source]

## Restrições e limitações {:#constraints-and-limitations}

Tenha em mente as restrições e limitações a seguir ao trabalhar com o Pigeon:

### Dados de alta frequência {:#high-frequency-data}

Para casos de uso especializados que exigem manipulação direta de ponteiros nativos
brutos ou gerenciamento de memória C e C++,
use o [FFIgen](/interop/ffigen) ou o [JNIgen](/interop/jnigen).

### Herança {:#inheritance}

O Pigeon não oferece suporte a herança complexa.
Sempre que possível, achate os seus modelos de dados.

### Erros em métodos assíncronos {:#async-errors}

Se você usar o [Pigeon com canais de plataforma](#pigeon-with-platform-channels),
os métodos `@async` geram funções `suspend` no Kotlin e `async throws` no Swift,
em que o código nativo lança `FlutterError` ou `PigeonError` diretamente.
Para métodos `@asyncCallback` ou outras linguagens de destino,
o código nativo precisa retornar os erros pelo callback de conclusão fornecido.

### Múltiplas engines do Flutter {:#multiple-flutter-engines}

Se você usar o [Pigeon com interop nativo](#pigeon-with-native-interop),
`<MyApi>.createWithNativeInteropApi()` se vincula à instância de host registrada
mais recentemente para um determinado `name`, em vez de procurar a `FlutterEngine`
que fez a chamada ([issue 195877 do Flutter][issue-195877]).
Não registre várias engines com o mesmo `name` antes que cada engine anterior
inicialize o seu cliente de API Dart (por exemplo, pré-aquecer engines
em sequência ou instanciar o cliente Dart de forma preguiçosa depois que outra engine
for anexada).

## Recursos {:#resources}

Para saber mais sobre como criar e migrar plugins com o Pigeon,
consulte os recursos a seguir:

- [Migração do Pigeon com canais de plataforma para o Pigeon com interop nativo][pigeon-migration-guide]
- [Guia de interop nativo do Pigeon][pigeon-native-guide]
- [Pacote Pigeon no pub.dev][pigeon-pub]
- [Código-fonte do Pigeon][pigeon-source]
- [Demonstrações de interop nativo do Flutter][native-interop-demos]

[pigeon-pub]: {{site.pub-pkg}}/pigeon
[pigeon-source]: {{site.repo.packages}}/tree/main/packages/pigeon
[pigeon-example]: {{site.repo.packages}}/tree/main/packages/pigeon/example
[pigeon-native-example]: {{site.repo.packages}}/tree/main/packages/pigeon/example/native_interop_app
[pigeon-native-guide]: {{site.repo.packages}}/blob/main/packages/pigeon/native_interop_guide.md
[pigeon-migration-guide]: {{site.repo.packages}}/blob/main/packages/pigeon/native_interop_migration_guide.md
[shared-preferences-source]: {{site.repo.packages}}/tree/main/packages/shared_preferences
[native-interop-demos]: {{site.repo.demos}}/tree/main/native_interop_demos
[issue-195877]: {{site.repo.flutter}}/issues/195877
