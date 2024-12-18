---
ia-translate: true
title: Migrar um projeto Windows para suportar barras de título escuras
description: Como atualizar um projeto Windows para suportar barras de título escuras
---

Projetos criados antes do Flutter 3.7 têm barras de título claras, mesmo
quando o tema do Windows é o modo escuro. Projetos criados antes
do Flutter 3.7 precisam ser migrados para suportar barras de título escuras.

## Passos para a migração

Seu projeto pode ser atualizado usando estes passos:

1. Verifique se você está na versão 3.7 ou mais recente do Flutter usando `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do
SDK do Flutter
3. Faça um backup do seu projeto, possivelmente usando git ou algum outro sistema de controle de versão
4. Exclua os seguintes arquivos:
    1. `windows/runner/CMakeLists.txt`
    2. `windows/runner/win32_window.cpp`
    3. `windows/runner/win32_window.h`
5. Execute `flutter create --platforms=windows .`
6. Revise as alterações nos seguintes arquivos:
    1. `windows/runner/CMakeLists.txt`
    2. `windows/runner/win32_window.cpp`
    3. `windows/runner/win32_window.h`
7. Verifique se seu aplicativo compila usando `flutter build windows`

:::note
Siga o [guia de migração do loop de execução][] se a compilação falhar
com a seguinte mensagem de erro:

```console
flutter_window.obj : error LNK2019: unresolved external symbol "public: void __cdecl RunLoop::RegisterFlutterInstance(class flutter::FlutterEngine *)" (?RegisterFlutterInstance@RunLoop@@QEAAXPEAVFlutterEngine@flutter@@@Z) referenced in function "protected: virtual bool __cdecl FlutterWindow::OnCreate(void)" (?OnCreate@FlutterWindow@@MEAA_NXZ)
```
:::

## Exemplo

O [PR 862][] mostra o trabalho de migração para o
aplicativo [Flutter Gallery][].

[guia de migração do loop de execução]: /release/breaking-changes/windows-run-loop
[PR 862]: {{site.repo.gallery-archive}}/pull/862/files
[Flutter Gallery]: {{site.gallery-archive}}
