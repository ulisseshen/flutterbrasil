---
ia-translate: true
title: Compilar e lançar um app web
description: Como preparar e lançar um app web.
shortTitle: Web
---

Durante um ciclo típico de desenvolvimento,
você testa um app usando `flutter run -d chrome`
(por exemplo) na linha de comando.
Isso compila uma versão _debug_ do seu app.

Esta página ajuda você a preparar uma versão _release_
do seu app e cobre os seguintes tópicos:

* [Compilando o app para release](#building-the-app-for-release)
* [Deploy para a web](#deploying-to-the-web)
* [Deploy para Firebase Hosting](#deploying-to-firebase-hosting)
* [Manipulando imagens na web](#handling-images-on-the-web)
* [Escolhendo um modo de build e um renderer](#choosing-a-build-mode-and-a-renderer)
* [Minificação](#minification)

## Compilando o app para release

Compile o app para deployment usando o comando `flutter build web`.

```console
flutter build web
```

Isso
gera o app, incluindo os assets, e coloca os arquivos no
diretório `/build/web` do projeto.

Para validar o build release do seu app,
inicie um servidor web (por exemplo,
`python -m http.server 8000`,
ou usando o package [dhttpd][]),
e abra o diretório /build/web. Navegue até
`localhost:8000` no seu navegador
(dado o exemplo python SimpleHTTPServer)
para visualizar a versão release do seu app.

## Flags de build adicionais
Você pode precisar fazer deploy de um build profile ou debug para testes.
Para fazer isso, passe a flag `--profile` ou `--debug`
para o comando `flutter build web`.
Builds profile são especializados para profiling de performance usando Chrome DevTools,
e builds debug podem ser usados para configurar dart2js
para respeitar assertions e mudar o nível de otimização (usando a flag `-O`.)

## Escolhendo um modo de build e um renderer

Flutter web fornece dois modos de build (default e WebAssembly) e dois renderers
(`canvaskit` e `skwasm`).

Para mais informações, veja [Web renderers][].

## Deploy para a web

Quando estiver pronto para fazer deploy do seu app,
faça upload do bundle release
para Firebase, nuvem, ou um serviço similar.
Aqui estão algumas possibilidades, mas há
muitas outras:

* [Firebase Hosting][]
* [GitHub Pages][]
* [Google Cloud Hosting][]

## Deploy para Firebase Hosting

Você pode usar o Firebase CLI para compilar e lançar seu app Flutter com Firebase
Hosting.

### Antes de começar

Para começar, [instale ou atualize][install-firebase-cli] o Firebase CLI:

```console
npm install -g firebase-tools
```

### Inicializar Firebase

1. Habilite o preview de web frameworks para o [CLI framework-aware do Firebase][Firebase framework-aware CLI]:

    ```console
    firebase experiments:enable webframeworks
    ```

2. Em um diretório vazio ou um projeto Flutter existente, execute o comando de
inicialização:

    ```console
    firebase init hosting
    ```

3. Responda `yes` quando perguntado se você quer usar um web framework.

4. Se você está em um diretório vazio,
    você será perguntado para escolher seu web framework. Escolha `Flutter Web`.

5. Escolha seu diretório fonte de hospedagem; isso pode ser um app flutter existente.

6. Selecione uma região para hospedar seus arquivos.

7. Escolha se deseja configurar builds e deploys automáticos com GitHub.

8. Faça deploy do app para Firebase Hosting:

    ```console
    firebase deploy
    ```

    Executar este comando automaticamente executa `flutter build web --release`,
    então você não precisa compilar seu app em um passo separado.

Para saber mais, visite a documentação oficial do [Firebase Hosting][] para
Flutter na web.

## Manipulando imagens na web

A web suporta o widget `Image` padrão para exibir imagens.
Por design, navegadores web executam código não confiável sem prejudicar o computador host.
Isso limita o que você pode fazer com imagens comparado a plataformas mobile e desktop.

Para mais informações, veja [Displaying images on the web][].

## Minificação

Para melhorar o start-up do app, o compilador reduz o tamanho do código compilado
removendo código não utilizado (conhecido como _tree shaking_), e renomeando símbolos de código para
strings mais curtas (por exemplo, renomeando `AlignmentGeometryTween` para algo como
`ab`). Quais dessas duas otimizações são aplicadas depende do modo de build:

| Tipo de build de app web | Código minificado? | Tree shaking executado? |
|-----------------------|----------------|-------------------------|
| debug                 | Não             | Não                      |
| profile               | Não             | Sim                     |
| release               | Sim            | Sim                     |

## Incorporando um app Flutter em uma página HTML

Veja [Embedding Flutter web][].

[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web

[dhttpd]: {{site.pub}}/packages/dhttpd
[Displaying images on the web]: /platform-integration/web/web-images
[Firebase Hosting]: {{site.firebase}}/docs/hosting/frameworks/flutter
[Firebase framework-aware CLI]: {{site.firebase}}/docs/hosting/frameworks/frameworks-overview
[install-firebase-cli]: {{site.firebase}}/docs/cli#install_the_firebase_cli
[GitHub Pages]: https://pages.github.com/
[give us feedback]: {{site.repo.flutter}}/issues/new?title=%5Bweb%5D:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[Google Cloud Hosting]: https://cloud.google.com/solutions/web-hosting
[Web renderers]: /platform-integration/web/renderers
