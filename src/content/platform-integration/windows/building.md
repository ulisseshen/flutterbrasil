---
ia-translate: true
title: Criando aplicativos Windows com Flutter
description: Considerações específicas da plataforma para criar para Windows com Flutter.
toc: true
short-title: Desenvolvimento para Windows
---

Esta página discute considerações exclusivas para a criação de
aplicativos Windows com Flutter, incluindo a integração com o shell e a
distribuição de aplicativos Windows por meio da Microsoft Store no
Windows.

## Integrando com o Windows

A interface de programação do Windows combina APIs Win32 tradicionais,
interfaces COM e bibliotecas Windows Runtime mais modernas. Como todas
elas fornecem um ABI baseado em C, você pode acessar os serviços
fornecidos pelo sistema operacional usando a biblioteca Foreign Function
Interface do Dart (`dart:ffi`). A FFI foi projetada para permitir que
programas Dart chamem eficientemente bibliotecas C. Ela fornece aos
aplicativos Flutter a capacidade de alocar memória nativa com `malloc` ou
`calloc`, suporte para ponteiros, structs e callbacks, e tipos ABI como
`long` e `size_t`.

Para mais informações sobre como chamar bibliotecas C a partir do Flutter,
consulte [Interoperação C usando `dart:ffi`].

Na prática, embora seja relativamente simples chamar APIs Win32 básicas do
Dart dessa forma, é mais fácil usar uma biblioteca wrapper que abstraia as
complexidades do modelo de programação COM. O [pacote win32] fornece uma
biblioteca para acessar milhares de APIs comuns do Windows, usando
metadados fornecidos pela Microsoft para consistência e correção. O pacote
também inclui exemplos de uma variedade de casos de uso comuns, como WMI,
gerenciamento de disco, integração com o shell e caixas de diálogo do
sistema.

Vários outros pacotes se baseiam nessa fundação, fornecendo acesso Dart
idiomático para o [registro do Windows], [suporte a gamepad], [armazenamento
biométrico], [integração com a barra de tarefas] e [acesso à porta serial],
para citar alguns.

De forma mais geral, muitos outros [pacotes oferecem suporte ao Windows],
incluindo pacotes comuns como [`url_launcher`], [`shared_preferences`],
[`file_selector`] e [`path_provider`].

[Interoperação C usando `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[pacote win32]: {{site.pub}}/packages/win32
[registro do Windows]: {{site.pub}}/packages/win32_registry
[suporte a gamepad]: {{site.pub}}/packages/win32_gamepad
[armazenamento biométrico]: {{site.pub}}/packages/biometric_storage
[integração com a barra de tarefas]: {{site.pub}}//packages/windows_taskbar
[acesso à porta serial]: {{site.pub}}/packages/serial_port_win32
[pacotes oferecem suporte ao Windows]: {{site.pub}}/packages?q=platform%3Awindows
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## Suportando as diretrizes de UI do Windows

Embora você possa usar qualquer estilo visual ou tema que escolher,
incluindo o Material, alguns autores de aplicativos podem querer criar um
aplicativo que corresponda às convenções do [sistema de design Fluent][] da
Microsoft. O pacote [fluent_ui][], um [Flutter Favorite][], fornece
suporte para visuais e controles comuns que são comumente encontrados em
aplicativos Windows modernos, incluindo visualizações de navegação, caixas
de diálogo de conteúdo, flyouts, seletores de data e widgets de visualização
em árvore.

Além disso, a Microsoft oferece [fluentui_system_icons][], um pacote que
fornece fácil acesso a milhares de ícones Fluent para uso em seu aplicativo
Flutter.

Por fim, o pacote [bitsdojo_window][] oferece suporte para barras de
título "owner draw", permitindo que você substitua a barra de título padrão
do Windows por uma personalizada que corresponda ao restante do seu
aplicativo.

[sistema de design Fluent]: https://docs.microsoft.com/en-us/windows/apps/design/
[fluent_ui]: {{site.pub}}/packages/fluent_ui
[Flutter Favorite]: /packages-and-plugins/favorites
[fluentui_system_icons]: {{site.pub}}/packages/fluentui_system_icons
[bitsdojo_window]: {{site.pub}}/packages/bitsdojo_window

## Personalizando o aplicativo host do Windows

Quando você cria um aplicativo Windows, o Flutter gera um pequeno
aplicativo C++ que hospeda o Flutter. Este "aplicativo runner" é
responsável por criar e dimensionar uma janela Win32 tradicional,
inicializar o mecanismo Flutter e quaisquer plugins nativos e executar o
loop de mensagens do Windows (passando mensagens relevantes para o Flutter
para processamento posterior).

Você pode, é claro, fazer alterações neste código para atender às suas
necessidades, incluindo a modificação do nome e ícone do aplicativo e a
definição do tamanho e localização iniciais da janela. O código relevante
está em main.cpp, onde você encontrará um código semelhante ao seguinte:

```cpp
Win32Window::Point origin(10, 10);
Win32Window::Size size(1280, 720);
if (!window.CreateAndShow(L"meuapp", origin, size))
{
    return EXIT_FAILURE;
}
```

Substitua `meuapp` pelo título que você gostaria de exibir na barra de
legenda do Windows, bem como, opcionalmente, ajuste as dimensões para
tamanho e as coordenadas da janela.

Para alterar o ícone do aplicativo Windows, substitua o arquivo
`app_icon.ico` no diretório `windows\runner\resources` por um ícone de sua
preferência.

O nome do arquivo executável do Windows gerado pode ser alterado editando
a variável `BINARY_NAME` em `windows/CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.14)
project(windows_desktop_app LANGUAGES CXX)

# O nome do executável criado para o aplicativo.
# Altere isso para alterar o nome no disco do seu aplicativo.
set(BINARY_NAME "SeuNovoApp")

cmake_policy(SET CMP0063 NEW)
```

Quando você executa `flutter build windows`, o arquivo executável gerado
no diretório `build\windows\runner\Release` corresponderá ao nome
recém-fornecido.

Finalmente, outras propriedades do executável do aplicativo em si podem ser
encontradas no arquivo `Runner.rc` no diretório `windows\runner`. Aqui,
você pode alterar as informações de direitos autorais e a versão do
aplicativo que estão incorporadas no aplicativo Windows, que são exibidas
na caixa de diálogo de propriedades do Windows Explorer. Para alterar o
número da versão, edite as propriedades `VERSION_AS_NUMBER` e
`VERSION_AS_STRING`; outras informações podem ser editadas no bloco
`StringFileInfo`.

## Compilando com o Visual Studio

Para a maioria dos aplicativos, é suficiente permitir que o Flutter
cuide do processo de compilação usando os comandos `flutter run` e
`flutter build`. Se você estiver fazendo alterações significativas no
aplicativo runner ou integrando o Flutter a um aplicativo existente, pode
querer carregar ou compilar o aplicativo Flutter no próprio Visual Studio.

Siga estes passos:

1. Execute `flutter build windows` para criar o diretório `build\`.

2. Abra o arquivo de solução do Visual Studio para o runner do Windows,
   que agora pode ser encontrado no diretório `build\windows`, nomeado de
   acordo com o aplicativo Flutter pai.

3. No Solution Explorer, você verá vários projetos. Clique com o botão
   direito naquele que tem o mesmo nome do aplicativo Flutter e escolha
   **Definir como Projeto de Inicialização**.

4. Para gerar as dependências necessárias, execute **Build** > **Build
   Solution**

   Você também pode pressionar /
   <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>.

   Para executar o aplicativo Windows no Visual Studio, vá para **Debug** >
   **Iniciar Depuração**.

   Você também pode pressionar <kbd>F5</kbd>.

5. Use a barra de ferramentas para alternar entre as configurações Debug e
   Release, conforme apropriado.

## Distribuindo aplicativos Windows

Existem várias abordagens que você pode usar para distribuir seu
aplicativo Windows. Aqui estão algumas opções:

* Use ferramentas para construir um instalador MSIX (descrito na próxima
  seção) para seu aplicativo e distribua-o por meio da Microsoft Windows
  App Store. Você não precisa criar manualmente um certificado de
  assinatura para esta opção, pois ela é tratada para você.
* Construa um instalador MSIX e distribua-o por meio do seu próprio site.
  Para esta opção, você precisa dar ao seu aplicativo uma assinatura
  digital na forma de um certificado `.pfx`.
* Colete todas as peças necessárias e construa seu próprio arquivo zip.

### Empacotamento MSIX

[MSIX][], o novo formato de pacote de aplicativos Windows, fornece um
formato de empacotamento e instalador modernos. Este formato pode ser
usado para enviar aplicativos para a Microsoft Store no Windows ou você
pode distribuir instaladores de aplicativos diretamente.

A maneira mais fácil de criar uma distribuição MSIX para um projeto
Flutter é usar o [pacote pub `msix`][pacote msix]. Para um exemplo de uso
do pacote `msix` de um aplicativo de desktop Flutter, consulte o exemplo
[Pesquisa de Fotos na Área de Trabalho][].

[MSIX]: https://docs.microsoft.com/en-us/windows/msix/overview
[pacote msix]: {{site.pub}}/packages/msix
[Pesquisa de Fotos na Área de Trabalho]: {{site.repo.samples}}/tree/main/desktop_photo_search

#### Crie um certificado .pfx autoassinado para testes locais

Para implantação privada e testes com a ajuda do instalador MSIX, você
precisa fornecer ao seu aplicativo uma assinatura digital na forma de um
certificado `.pfx`.

Para implantação por meio da Windows Store, não é necessário gerar um
certificado `.pfx`. A Windows Store lida com a criação e gerenciamento de
certificados para aplicativos distribuídos por meio de sua loja.

Distribuir seu aplicativo hospedando-o em um site requer um certificado
assinado por uma Autoridade Certificadora conhecida pelo Windows.

Use as seguintes instruções para gerar um certificado `.pfx`
autoassinado.

1. Se você ainda não o fez, baixe o [OpenSSL][] toolkit para gerar seus
   certificados.
2. Vá para onde você instalou o OpenSSL, por exemplo,
   `C:\Program Files\OpenSSL-Win64\bin`.
3. Defina uma variável de ambiente para que você possa acessar o `OpenSSL`
   de qualquer lugar:<br>
   `"C:\Program Files\OpenSSL-Win64\bin"`
4. Gere uma chave privada da seguinte forma:<br>
   `openssl genrsa -out minha_chave.key 2048`
5. Gere um arquivo de solicitação de assinatura de certificado (CSR)
   usando a chave privada:<br>
   `openssl req -new -key minha_chave.key -out meu_csr.csr`
6. Gere o arquivo de certificado assinado (CRT) usando a chave privada e
   o arquivo CSR:<br>
   `openssl x509 -in meu_csr.csr -out meu_certificado.crt -req -signkey minha_chave.key -days 10000`
7. Gere o arquivo `.pfx` usando a chave privada e o arquivo CRT:<br>
   `openssl pkcs12 -export -out CERTIFICATE.pfx -inkey minha_chave.key -in meu_certificado.crt`
8. Instale o certificado `.pfx` primeiro na máquina local na `loja de
   certificados` como
   `Autoridades de certificação raiz confiáveis` antes de instalar o
   aplicativo.

[OpenSSL]: https://slproweb.com/products/Win32OpenSSL.html

### Criando seu próprio arquivo zip para Windows

O executável do Flutter, `.exe`, pode ser encontrado em seu projeto em
`build\windows\runner\<modo de build>\`. Além desse executável, você
precisa do seguinte:

* Do mesmo diretório:
  * todos os arquivos `.dll`
  * o diretório `data`
* Os redistribuíveis do Visual C++. Você pode usar qualquer um dos métodos
  mostrados nos [passo a passo de exemplos de implantação][] no site da
  Microsoft para garantir que os usuários finais tenham os redistribuíveis
  C++. Se você usar a opção `application-local`, você precisa copiar:
  * `msvcp140.dll`
  * `vcruntime140.dll`
  * `vcruntime140_1.dll`

  Coloque os arquivos DLL no diretório ao lado do executável e das outras
  DLLs e junte-os em um arquivo zip. A estrutura resultante se parece
  com algo assim:

  ```plaintext
  Release
  │   flutter_windows.dll
  │   msvcp140.dll
  │   meu_app.exe
  │   vcruntime140.dll
  │   vcruntime140_1.dll
  │
  └───data
  │   │   app.so
  │   │   icudtl.dat

  ...
  ```

Neste ponto, se desejado, seria relativamente simples adicionar esta pasta
a um instalador do Windows, como Inno Setup, WiX, etc.

## Recursos adicionais

Para aprender como criar um `.exe` usando o Inno Setup para distribuir seu
aplicativo de desktop Flutter para Windows, confira o [guia de
empacotamento do Windows][windows_packaging_guide] passo a passo.

[passo a passo de exemplos de implantação]: https://docs.microsoft.com/en-us/cpp/windows/deployment-examples
[windows_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-2-windows-0b468d5e9e70

