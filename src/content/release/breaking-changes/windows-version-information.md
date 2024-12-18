---
ia-translate: true
title: Migrar um projeto Windows para definir informações de versão
description: Como atualizar um projeto Windows para definir informações de versão
---

O Flutter 3.3 adicionou suporte para definir a versão do aplicativo Windows a
partir do arquivo `pubspec.yaml` ou por meio dos argumentos de build
`--build-name` e `--build-number`. Para mais informações, consulte a
documentação [Construir e lançar um aplicativo Windows][].

Projetos criados antes da versão 3.3 do Flutter precisam ser migrados
para oferecer suporte ao versionamento.

## Passos para a migração

Seu projeto pode ser atualizado usando estas etapas:

1. Verifique se você está na versão 3.3 ou mais recente do Flutter usando
   `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais
   recente do SDK do Flutter
3. Faça backup do seu projeto, possivelmente usando git ou algum outro sistema de
   controle de versão
4. Exclua os arquivos `windows/runner/CMakeLists.txt` e `windows/runner/Runner.rc`
5. Execute `flutter create --platforms=windows .`
6. Revise as alterações nos seus arquivos `windows/runner/CMakeLists.txt` e
   `windows/runner/Runner.rc`
7. Verifique se seu aplicativo compila usando `flutter build windows`

:::note
Siga o [guia de migração do loop de execução][] se a compilação falhar
com a seguinte mensagem de erro:

```console
flutter_window.obj : error LNK2019: unresolved external symbol "public: void __cdecl RunLoop::RegisterFlutterInstance(class flutter::FlutterEngine *)" (?RegisterFlutterInstance@RunLoop@@QEAAXPEAVFlutterEngine@flutter@@@Z) referenced in function "protected: virtual bool __cdecl FlutterWindow::OnCreate(void)" (?OnCreate@FlutterWindow@@MEAA_NXZ)
```
:::

## Exemplo

[PR 721][] mostra o trabalho de migração para o aplicativo
[Flutter Gallery][].

[Construir e lançar um aplicativo Windows]: /deployment/windows#updating-the-apps-version-number
[guia de migração do loop de execução]: /release/breaking-changes/windows-run-loop
[PR 721]: {{site.repo.gallery-archive}}/pull/721/files
[Flutter Gallery]: {{site.gallery-archive}}
