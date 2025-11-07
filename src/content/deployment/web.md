---
ia-translate: true
title: Compilar e lançar um app web
description: Como preparar e lançar um app web.
short-title: Web
---

Durante um ciclo de desenvolvimento típico,
você testa um app usando `flutter run -d chrome`
(por exemplo) na linha de comando.
Isso compila uma versão _debug_ do seu app.

Esta página ajuda você a preparar uma versão _release_
do seu app e cobre os seguintes tópicos:

* [Compilando o app para release](#building-the-app-for-release)
* [Implantando na web](#deploying-to-the-web)
* [Implantando no Firebase Hosting](#deploying-to-firebase-hosting)
* [Manipulando imagens na web](#handling-images-on-the-web)
* [Escolhendo um modo de build e um renderizador](#choosing-a-build-mode-and-a-renderer)
* [Minificação](#minification)

## Compilando o app para release

Compile o app para implantação usando o comando `flutter build web`.

```console
flutter build web
```

Isso
gera o app, incluindo os assets, e coloca os arquivos no
diretório `/build/web` do projeto.

Para validar a compilação release do seu app,
inicie um servidor web (por exemplo,
`python -m http.server 8000`,
ou usando o pacote [dhttpd][]),
e abra o diretório /build/web. Navegue para
`localhost:8000` no seu navegador
(dado o exemplo do SimpleHTTPServer do python)
para ver a versão release do seu app.

## Flags de build adicionais
Você pode precisar implantar uma compilação profile ou debug para testes.
Para fazer isso, passe a flag `--profile` ou `--debug`
para o comando `flutter build web`.
Compilações profile são especializadas para criação de perfil de desempenho usando Chrome DevTools,
e compilações debug podem ser usadas para configurar o dart2js
para respeitar assertions e alterar o nível de otimização (usando a flag `-O`.)

## Escolhendo um modo de build e um renderizador

O Flutter web fornece dois modos de build (padrão e WebAssembly) e dois renderizadores
(`canvaskit` e `skwasm`).

Para mais informações, veja [Renderizadores web][Web renderers].

## Implantando na web

Quando você estiver pronto para implantar seu app,
faça upload do bundle de release
para Firebase, nuvem, ou um serviço similar.
Aqui estão algumas possibilidades, mas existem
muitas outras:

* [Firebase Hosting][]
* [GitHub Pages][]
* [Google Cloud Hosting][]

## Implantando no Firebase Hosting

Você pode usar o Firebase CLI para compilar e lançar seu app Flutter com Firebase
Hosting.

### Antes de começar

Para começar, [instale ou atualize][install-firebase-cli] o Firebase CLI:

```console
npm install -g firebase-tools
```

### Inicializar Firebase

1. Habilite a visualização de frameworks web no [CLI consciente de frameworks do Firebase][Firebase framework-aware CLI]:

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

5. Escolha seu diretório fonte de hospedagem; este pode ser um app Flutter existente.

6. Selecione uma região para hospedar seus arquivos.

7. Escolha se deseja configurar builds e deploys automáticos com GitHub.

8. Faça deploy do app para Firebase Hosting:

    ```console
    firebase deploy
    ```

    Executar este comando automaticamente executa `flutter build web --release`,
    então você não precisa compilar seu app em uma etapa separada.

Para saber mais, visite a documentação oficial do [Firebase Hosting][] para
Flutter na web.

## Manipulando imagens na web

A web suporta o widget `Image` padrão para exibir imagens.
Por design, navegadores web executam código não confiável sem prejudicar o computador host.
Isso limita o que você pode fazer com imagens em comparação com plataformas mobile e desktop.

Para mais informações, veja [Exibindo imagens na web][Displaying images on the web].

## Minificação

Para melhorar a inicialização do app, o compilador reduz o tamanho do código compilado
removendo código não utilizado (conhecido como _tree shaking_), e renomeando símbolos de código para
strings mais curtas (por exemplo, renomeando `AlignmentGeometryTween` para algo como
`ab`). Quais dessas duas otimizações são aplicadas depende do modo de build:

| Tipo de build web app | Código minificado? | Tree shaking realizado? |
|-----------------------|----------------|-------------------------|
| debug                 | No             | No                      |
| profile               | No             | Yes                     |
| release               | Yes            | Yes                     |

## Incorporando um app Flutter em uma página HTML

Veja [Incorporando Flutter web][Embedding Flutter web].

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
