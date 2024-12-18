---
ia-translate: true
title: Construir e liberar um aplicativo web
description: Como preparar e liberar um aplicativo web.
short-title: Web
---

Durante um ciclo de desenvolvimento típico,
você testa um aplicativo usando `flutter run -d chrome`
(por exemplo) na linha de comando.
Isso constrói uma versão _debug_ do seu aplicativo.

Esta página ajuda você a preparar uma versão de _release_
do seu aplicativo e aborda os seguintes tópicos:

* [Construindo o aplicativo para release](#construindo-o-aplicativo-para-release)
* [Fazendo deploy na web](#fazendo-deploy-na-web)
* [Fazendo deploy no Firebase Hosting](#fazendo-deploy-no-firebase-hosting)
* [Lidando com imagens na web](#lidando-com-imagens-na-web)
* [Escolhendo um modo de build e um renderizador](#escolhendo-um-modo-de-build-e-um-renderizador)
* [Minificação](#minificação)

## Construindo o aplicativo para release

Construa o aplicativo para deploy usando o comando `flutter build web`.

```console
flutter build web
```

Isso
gera o aplicativo, incluindo os assets, e coloca os arquivos no
diretório `/build/web` do projeto.

Para validar o build de release do seu aplicativo,
inicie um servidor web (por exemplo,
`python -m http.server 8000`,
ou usando o pacote [dhttpd][]),
e abra o diretório /build/web. Navegue até
`localhost:8000` no seu navegador
(dado o exemplo do SimpleHTTPServer do python)
para visualizar a versão de release do seu aplicativo.

## Flags adicionais de build
Você pode precisar fazer o deploy de um build de perfil ou debug para testes.
Para isso, passe a flag `--profile` ou `--debug`
para o comando `flutter build web`.
Builds de perfil são especializados para profiling de performance usando o Chrome DevTools,
e builds de debug podem ser usados para configurar o dart2js
para respeitar asserções e mudar o nível de otimização (usando a flag `-O`.)

## Escolhendo um modo de build e um renderizador

O Flutter web oferece dois modos de build (padrão e WebAssembly) e dois renderizadores
(`canvaskit` e `skwasm`).

Para mais informações, veja [Renderizadores Web][].

## Fazendo deploy na web

Quando você estiver pronto para fazer o deploy do seu aplicativo,
envie o pacote de release
para o Firebase, a nuvem ou um serviço similar.
Aqui estão algumas possibilidades, mas existem
muitas outras:

* [Firebase Hosting][]
* [GitHub Pages][]
* [Google Cloud Hosting][]

## Fazendo deploy no Firebase Hosting

Você pode usar o Firebase CLI para construir e liberar seu aplicativo Flutter com o Firebase
Hosting.

### Antes de começar

Para começar, [instale ou atualize][install-firebase-cli] o Firebase CLI:

```console
npm install -g firebase-tools
```

### Inicialize o Firebase

1. Habilite a preview de frameworks web no [Firebase framework-aware CLI][]:

    ```console
    firebase experiments:enable webframeworks
    ```

2. Em um diretório vazio ou em um projeto Flutter existente, execute o comando de inicialização:

    ```console
    firebase init hosting
    ```

3. Responda `yes` quando perguntado se você quer usar um framework web.

4. Se você estiver em um diretório vazio,
    será perguntado para escolher seu framework web. Escolha `Flutter Web`.

5. Escolha seu diretório de origem de hospedagem; este pode ser um aplicativo flutter existente.

6. Selecione uma região para hospedar seus arquivos.

7. Escolha se deseja configurar builds e deploys automáticos com o GitHub.

8. Faça o deploy do aplicativo para o Firebase Hosting:

    ```console
    firebase deploy
    ```

    Executar este comando automaticamente executa `flutter build web --release`,
    então você não precisa construir seu aplicativo em um passo separado.

Para aprender mais, visite a documentação oficial do [Firebase Hosting][] para
Flutter na web.

## Lidando com imagens na web

A web suporta o widget padrão `Image` para exibir imagens.
Por design, navegadores web executam código não confiável sem prejudicar o computador host.
Isso limita o que você pode fazer com imagens comparado com plataformas mobile e desktop.

Para mais informações, veja [Exibindo imagens na web][].

## Minificação

Para melhorar a inicialização do aplicativo, o compilador reduz o tamanho do código compilado,
removendo código não usado (conhecido como _tree shaking_), e renomeando símbolos de código
para strings mais curtas (por exemplo, renomeando `AlignmentGeometryTween` para algo como
`ab`). Qual dessas duas otimizações é aplicada depende do modo de build:

| Tipo de build de aplicativo web | Código minificado? | Tree shaking realizado? |
|-----------------------|----------------|-------------------------|
| debug                 | Não            | Não                     |
| profile               | Não            | Sim                     |
| release               | Sim            | Sim                     |

## Incorporando um aplicativo Flutter em uma página HTML

Veja [Incorporando Flutter web][].

[Incorporando Flutter web]: /platform-integration/web/embedding-flutter-web

[dhttpd]: {{site.pub}}/packages/dhttpd
[Exibindo imagens na web]: /platform-integration/web/web-images
[Firebase Hosting]: {{site.firebase}}/docs/hosting/frameworks/flutter
[Firebase framework-aware CLI]: {{site.firebase}}/docs/hosting/frameworks/frameworks-overview
[install-firebase-cli]: {{site.firebase}}/docs/cli#install_the_firebase_cli
[GitHub Pages]: https://pages.github.com/
[give us feedback]: {{site.repo.flutter}}/issues/new?title=%5Bweb%5D:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[Google Cloud Hosting]: https://cloud.google.com/solutions/web-hosting
[Renderizadores Web]: /platform-integration/web/renderers
