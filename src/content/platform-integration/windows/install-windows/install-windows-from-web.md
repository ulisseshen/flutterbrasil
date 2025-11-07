---
ia-translate: true
title: Adicionar Windows como plataforma de destino para Flutter partindo da Web
description: Configure seu sistema para desenvolver apps Flutter em Windows desktop.
short-title: Partindo da Web
---

Para adicionar Windows desktop como destino de app Flutter, siga este procedimento.

## Instalar e configurar Visual Studio

1. Aloque um mínimo de 26 GB de armazenamento para Visual Studio.
   Considere alocar 10 GB de armazenamento para uma configuração ideal.
1. Instale o [Visual Studio 2022][] para debugar e compilar código nativo C++ Windows.
   Certifique-se de instalar a workload **Desktop development with C++**.
   Isso habilita a construção de apps Windows incluindo todos os seus componentes padrão.
   **Visual Studio** é uma IDE separada do **[Visual Studio _Code_][]**.

{% include docs/install/flutter-doctor.md target='Windows' devos='Windows' config='WindowsDesktopWeb' %}

[Visual Studio 2022]: https://learn.microsoft.com/visualstudio/install/install-visual-studio?view=vs-2022
[Visual Studio _Code_]: https://code.visualstudio.com/
