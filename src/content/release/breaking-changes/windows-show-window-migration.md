---
ia-translate: true
title: Migrar um projeto Windows para garantir que a janela seja exibida
description: Como atualizar um projeto Windows para garantir que a janela seja exibida
---

O Flutter 3.13 corrigiu um [bug][] que poderia resultar na não exibição da janela. Projetos Windows criados usando Flutter 3.7 ou Flutter 3.10 precisam ser migrados para corrigir esse problema.

[bug]: {{site.repo.flutter}}/issues/119415

## Passos para a migração

Verifique se você está na versão 3.13 ou mais recente do Flutter usando `flutter --version`. Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do SDK do Flutter.

Projetos que não modificaram seu arquivo `windows/runner/flutter_window.cpp` serão migrados automaticamente por `flutter run` ou `flutter build windows`.

Projetos que modificaram seu arquivo `windows/runner/flutter_window.cpp` podem precisar migrar manualmente.

Código antes da migração:

```cpp
flutter_controller_->engine()->SetNextFrameCallback([&]() {
  this->Show();
});
```

Código após a migração:

```cpp
flutter_controller_->engine()->SetNextFrameCallback([&]() {
  this->Show();
});

// O Flutter pode concluir o primeiro frame antes que o callback "mostrar janela" seja
// registrado. A chamada a seguir garante que um frame esteja pendente para garantir que
// a janela seja exibida. É uma no-op se o primeiro frame ainda não foi concluído.
flutter_controller_->ForceRedraw();
```

## Exemplo

O [PR 995][] mostra o trabalho de migração para o aplicativo [Flutter Gallery][].

[PR 995]: {{site.repo.gallery-archive}}/pull/995/files
[Flutter Gallery]: {{site.gallery-archive}}
