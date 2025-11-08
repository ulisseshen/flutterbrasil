---
ia-translate: true
title: Migrar um projeto Windows para definir informações de versão
description: Como atualizar um projeto Windows para definir informações de versão
---

O Flutter 3.3 adicionou suporte para definir a versão do app Windows a partir do
arquivo `pubspec.yaml` ou através dos argumentos de build `--build-name` e `--build-number`.
Para mais informações, consulte a documentação
[Build and release a Windows app][].

Projetos criados antes do Flutter versão 3.3 precisam ser migrados
para suportar versionamento.

## Passos de migração

Seu projeto pode ser atualizado usando estes passos:

1. Verifique que você está no Flutter versão 3.3 ou mais recente usando `flutter --version`
2. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do
Flutter SDK
3. Faça backup do seu projeto, possivelmente usando git ou algum outro sistema de controle de versão
4. Delete os arquivos `windows/runner/CMakeLists.txt` e `windows/runner/Runner.rc`
5. Execute `flutter create --platforms=windows .`
6. Revise as alterações nos seus arquivos `windows/runner/CMakeLists.txt` e
`windows/runner/Runner.rc`
7. Verifique que seu app compila usando `flutter build windows`

:::note
Siga o [guia de migração do run loop][run loop migration guide] se a compilação falhar
com a seguinte mensagem de erro:

```console
flutter_window.obj : error LNK2019: unresolved external symbol "public: void __cdecl RunLoop::RegisterFlutterInstance(class flutter::FlutterEngine *)" (?RegisterFlutterInstance@RunLoop@@QEAAXPEAVFlutterEngine@flutter@@@Z) referenced in function "protected: virtual bool __cdecl FlutterWindow::OnCreate(void)" (?OnCreate@FlutterWindow@@MEAA_NXZ)
```
:::

## Exemplo

[PR 721][] mostra o trabalho de migração para o
app [Flutter Gallery][].

[Build and release a Windows app]: /deployment/windows#updating-the-apps-version-number
[run loop migration guide]: /release/breaking-changes/windows-run-loop
[PR 721]: {{site.repo.gallery-archive}}/pull/721/files
[Flutter Gallery]: {{site.gallery-archive}}