---
ia-translate: true
title: Construindo apps Windows com Flutter
description: Considerações específicas da plataforma para construir para Windows com Flutter.
toc: true
short-title: Desenvolvimento Windows
---

Esta página discute considerações únicas para construir
apps Windows com Flutter, incluindo integração com shell
e distribuição de apps Windows através da
Microsoft Store no Windows.

## Integrando com Windows

A interface de programação do Windows combina APIs Win32 tradicionais,
interfaces COM e bibliotecas Windows Runtime mais modernas.
Como todas elas fornecem uma ABI baseada em C,
você pode chamar os serviços fornecidos pelo sistema
operacional usando a biblioteca Foreign Function Interface do Dart (`dart:ffi`).
FFI foi projetada para permitir que programas Dart chamem eficientemente
bibliotecas C. Ela fornece aos apps Flutter a capacidade de alocar
memória nativa com `malloc` ou `calloc`, suporte para ponteiros,
structs e callbacks, e tipos ABI como `long` e `size_t`.

Para mais informações sobre chamar bibliotecas C do Flutter,
veja [C interop using `dart:ffi`].

Na prática, embora seja relativamente direto chamar
APIs Win32 básicas do Dart desta forma,
é mais fácil usar uma biblioteca wrapper que abstrai as
complexidades do modelo de programação COM.
O [pacote win32][win32 package] fornece uma biblioteca
para acessar milhares de APIs Windows comuns,
usando metadados fornecidos pela Microsoft para consistência e correção.
O pacote também inclui exemplos de
uma variedade de casos de uso comuns,
como WMI, gerenciamento de disco, integração com shell
e diálogos do sistema.

Vários outros pacotes se baseiam nesta fundação,
fornecendo acesso Dart idiomático para o [registro do Windows][Windows registry],
[suporte a gamepad][gamepad support], [armazenamento biométrico][biometric storage],
[integração com taskbar][taskbar integration] e [acesso a porta serial][serial port access], para citar alguns.

Mais geralmente, muitos outros [pacotes suportam Windows][packages support Windows],
incluindo pacotes comuns como [`url_launcher`], [`shared_preferences`], [`file_selector`] e [`path_provider`].

[C interop using `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[win32 package]: {{site.pub}}/packages/win32
[Windows registry]: {{site.pub}}/packages/win32_registry
[gamepad support]: {{site.pub}}/packages/win32_gamepad
[biometric storage]: {{site.pub}}/packages/biometric_storage
[taskbar integration]: {{site.pub}}//packages/windows_taskbar
[serial port access]: {{site.pub}}/packages/serial_port_win32
[packages support Windows]: {{site.pub}}/packages?q=platform%3Awindows
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## Suportando diretrizes de UI do Windows

Embora você possa usar qualquer estilo visual ou tema que escolher,
incluindo Material, alguns autores de apps podem desejar construir
um app que corresponda às convenções do
[sistema de design Fluent][Fluent design system] da Microsoft. O pacote [fluent_ui][],
um [Flutter Favorite][], fornece suporte para visuais
e controles comuns que são comumente encontrados em
apps Windows modernos, incluindo navigation views,
content dialogs, flyouts, date
pickers e widgets tree view.

Além disso, a Microsoft oferece [fluentui_system_icons][],
um pacote que fornece acesso fácil a milhares de
ícones Fluent para uso no seu app Flutter.

Por último, o pacote [bitsdojo_window][] fornece suporte
para barras de título "owner draw", permitindo que você substitua
a barra de título padrão do Windows por uma personalizada
que corresponda ao resto do seu app.

[Fluent design system]: https://docs.microsoft.com/en-us/windows/apps/design/
[fluent_ui]: {{site.pub}}/packages/fluent_ui
[Flutter Favorite]: /packages-and-plugins/favorites
[fluentui_system_icons]: {{site.pub}}/packages/fluentui_system_icons
[bitsdojo_window]: {{site.pub}}/packages/bitsdojo_window

## Personalizando a aplicação host Windows

Quando você cria um app Windows, Flutter gera uma
pequena aplicação C++ que hospeda o Flutter.
Este "runner app" é responsável por criar e dimensionar uma
janela Win32 tradicional, inicializar o
engine Flutter e quaisquer plugins nativos,
e executar o loop de mensagens do Windows
(passando mensagens relevantes para o Flutter para processamento adicional).

Você pode, é claro, fazer mudanças neste código para atender suas necessidades,
incluindo modificar o nome e ícone do app,
e definir o tamanho e localização inicial da janela.
O código relevante está em main.cpp,
onde você encontrará código similar ao seguinte:

```cpp
Win32Window::Point origin(10, 10);
Win32Window::Size size(1280, 720);
if (!window.CreateAndShow(L"myapp", origin, size))
{
    return EXIT_FAILURE;
}
```

Substitua `myapp` pelo título que você gostaria exibido na
barra de legenda do Windows, bem como opcionalmente ajustar as
dimensões para tamanho e as coordenadas da janela.

Para mudar o ícone da aplicação Windows, substitua o
arquivo `app_icon.ico` no diretório `windows\runner\resources`
com um ícone de sua preferência.

O nome do arquivo executável Windows gerado pode ser alterado
editando a variável `BINARY_NAME` em `windows/CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.14)
project(windows_desktop_app LANGUAGES CXX)

# The name of the executable created for the application.
# Change this to change the on-disk name of your application.
set(BINARY_NAME "YourNewApp")

cmake_policy(SET CMP0063 NEW)
```

Quando você executar `flutter build windows`,
o arquivo executável gerado no
diretório `build\windows\runner\Release`
corresponderá ao nome recém-dado.

Finalmente, propriedades adicionais para o executável do app
em si podem ser encontradas no arquivo `Runner.rc` no
diretório `windows\runner`. Aqui você pode mudar as
informações de copyright e versão da aplicação que
são incorporadas no app Windows, que são exibidas
na caixa de diálogo de propriedades do Windows Explorer.
Para mudar o número da versão, edite as propriedades `VERSION_AS_NUMBER`
e `VERSION_AS_STRING`;
outras informações podem ser editadas no bloco `StringFileInfo`.

## Compilando com Visual Studio

Para a maioria dos apps, é suficiente permitir que o Flutter
lide com o processo de compilação usando os comandos `flutter run`
e `flutter build`. Se você está fazendo mudanças significativas
no runner app ou integrando Flutter em um app existente,
você pode querer carregar ou compilar o app Flutter no próprio Visual Studio.

Siga estas etapas:

1. Execute `flutter build windows` para criar o diretório `build\`.

1. Abra o arquivo de solução do Visual Studio para o runner Windows,
   que agora pode ser encontrado no diretório `build\windows`,
   nomeado de acordo com o app Flutter pai.

1. No Solution Explorer, você verá vários projetos.
   Clique com o botão direito no que tem o mesmo nome do app Flutter,
   e escolha **Set as Startup Project**.

1. Para gerar as dependências necessárias,
   execute **Build** > **Build Solution**

   Você também pode pressionar
   <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>.

   Para executar o app Windows do Visual Studio, vá para **Debug** > **Start Debugging**.

   Você também pode pressionar <kbd>F5</kbd>.

1. Use a barra de ferramentas para alternar entre configurações Debug e Release
   conforme apropriado.

## Distribuindo apps Windows

Existem várias abordagens que você pode usar para
distribuir sua aplicação Windows.
Aqui estão algumas opções:

* Use ferramentas para construir um instalador MSIX
  (descrito na próxima seção)
  para sua aplicação e distribuí-lo através da
  Microsoft Windows App Store.
  Você não precisa criar manualmente um certificado
  de assinatura para esta opção, pois é
  tratado para você.
* Construa um instalador MSIX e distribua-o
  através do seu próprio website. Para esta
  opção, você precisa dar à sua aplicação uma
  assinatura digital na forma de um
  certificado `.pfx`.
* Colete todas as peças necessárias
  e construa seu próprio arquivo zip.

<a id="msix-packaging"></a>
### Empacotamento MSIX

[MSIX][], o novo formato de pacote de aplicação Windows,
fornece um formato de empacotamento e instalador modernos.
Este formato pode ser usado para enviar aplicações
à Microsoft Store no Windows, ou você pode
distribuir instaladores de app diretamente.

A maneira mais fácil de criar uma distribuição MSIX
para um projeto Flutter é usar o
[pacote pub `msix`][msix package].
Para um exemplo de uso do pacote `msix`
de um app Flutter desktop,
veja o exemplo [Desktop Photo Search][].

[MSIX]: https://docs.microsoft.com/en-us/windows/msix/overview
[msix package]: {{site.pub}}/packages/msix
[Desktop Photo Search]: {{site.repo.samples}}/tree/main/desktop_photo_search

#### Criar um certificado .pfx auto-assinado para testes locais

Para implantação privada e testes com a ajuda
do instalador MSIX, você precisa dar à sua aplicação uma
assinatura digital na forma de um certificado `.pfx`.

Para implantação através da Windows Store,
gerar um certificado `.pfx` não é necessário.
A Windows Store lida com criação e gerenciamento
de certificados para aplicações
distribuídas através de sua loja.

Distribuir sua aplicação hospedando-a em um
website requer um certificado assinado por uma
Certificate Authority conhecida pelo Windows.

Use as seguintes instruções para gerar um
certificado `.pfx` auto-assinado.

1. Se você ainda não o fez, baixe o toolkit [OpenSSL][]
   para gerar seus certificados.
1. Vá para onde você instalou o OpenSSL, por exemplo,
   `C:\Program Files\OpenSSL-Win64\bin`.
1. Defina uma variável de ambiente para que você possa acessar
   `OpenSSL` de qualquer lugar:<br>
   `"C:\Program Files\OpenSSL-Win64\bin"`
1. Gere uma chave privada da seguinte forma:<br>
   `openssl genrsa -out mykeyname.key 2048`
1. Gere um arquivo certificate signing request (CSR)
   usando a chave privada:<br>
   `openssl req -new -key mykeyname.key -out mycsrname.csr`
1. Gere o arquivo de certificado assinado (CRT) usando
   a chave privada e o arquivo CSR:<br>
   `openssl x509 -in mycsrname.csr -out mycrtname.crt -req -signkey mykeyname.key -days 10000`
1. Gere o arquivo `.pfx` usando a chave privada e
   o arquivo CRT:<br>
   `openssl pkcs12 -export -out CERTIFICATE.pfx -inkey mykeyname.key -in mycrtname.crt`
1. Instale o certificado `.pfx` primeiro na máquina local
   em `Certificate store` como
   `Trusted Root Certification Authorities`
   antes de instalar o app.

[OpenSSL]: https://slproweb.com/products/Win32OpenSSL.html

### Construindo seu próprio arquivo zip para Windows

O executável Flutter, `.exe`, pode ser encontrado no seu
projeto em `build\windows\runner\<build mode>\`.
Além desse executável, você precisa do seguinte:

* Do mesmo diretório:
  * todos os arquivos `.dll`
  * o diretório `data`
* Os redistribuíveis do Visual C++.
  Você pode usar qualquer um dos métodos mostrados nos
  [exemplos de walkthrough de implantação][deployment example walkthroughs] no site da Microsoft
  para garantir que os usuários finais tenham os redistribuíveis C++.
  Se você usar a opção `application-local`, você precisa copiar:
  * `msvcp140.dll`
  * `vcruntime140.dll`
  * `vcruntime140_1.dll`

  Coloque os arquivos DLL no diretório ao lado do executável
  e as outras DLLs, e agrupe-os juntos em um arquivo zip.
  A estrutura resultante parece algo assim:

  ```plaintext
  Release
  │   flutter_windows.dll
  │   msvcp140.dll
  │   my_app.exe
  │   vcruntime140.dll
  │   vcruntime140_1.dll
  │
  └───data
  │   │   app.so
  │   │   icudtl.dat

  ...
  ```

Neste ponto, se desejado, seria relativamente simples
adicionar esta pasta a um instalador Windows como Inno Setup, WiX, etc.

## Recursos adicionais

Para aprender como construir um `.exe` usando Inno Setup para distribuir
seu app Flutter desktop para Windows, confira o
[guia de empacotamento Windows][windows_packaging_guide] passo a passo.

[deployment example walkthroughs]: https://docs.microsoft.com/en-us/cpp/windows/deployment-examples
[windows_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-2-windows-0b468d5e9e70
