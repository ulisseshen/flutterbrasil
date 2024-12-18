---
ia-translate: true
title: Adicione o Windows como plataforma alvo para Flutter partindo da Web
description: Configure seu sistema para desenvolver aplicativos Flutter no desktop Windows.
short-title: Começando da Web
---

Para adicionar o desktop Windows como um alvo para aplicativos Flutter, siga este procedimento.

## Instale e configure o Visual Studio

1. Aloque um mínimo de 26 GB de armazenamento para o Visual Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.
2. Instale o [Visual Studio 2022][] para depurar e compilar código C++ nativo do Windows.
   Certifique-se de instalar a carga de trabalho **Desenvolvimento para desktop com C++**.
   Isso habilita a construção de aplicativos Windows, incluindo todos os seus componentes padrão.
   **Visual Studio** é uma IDE separada do **[Visual Studio _Code_][]**.

{% include docs/install/flutter-doctor.md target='Windows' devos='Windows' config='WindowsDesktopWeb' %}

[Visual Studio 2022]: https://learn.microsoft.com/visualstudio/install/install-visual-studio?view=vs-2022
[Visual Studio _Code_]: https://code.visualstudio.com/
