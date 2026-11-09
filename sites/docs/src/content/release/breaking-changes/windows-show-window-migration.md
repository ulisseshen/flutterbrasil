---
title: Migrar um projeto Windows para garantir que a janela seja exibida
description: Como atualizar um projeto Windows para garantir que a janela seja exibida
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

O Flutter 3.13 corrigiu um [bug][] que poderia resultar na janela não sendo exibida.
Projetos Windows criados usando Flutter 3.7 ou Flutter 3.10 precisam ser migrados
para corrigir este problema.

[bug]: {{site.repo.flutter}}/issues/119415

## Etapas de migração {:#migration-steps}

Verifique se você está no Flutter versão 3.13 ou mais recente usando `flutter --version`.
Se necessário, use `flutter upgrade` para atualizar para a versão mais recente do
Flutter SDK.

Projetos que não modificaram seu arquivo `windows/runner/flutter_window.cpp`
serão migrados automaticamente por `flutter run` ou `flutter build windows`.

Projetos que modificaram seu arquivo `windows/runner/flutter_window.cpp` podem
precisar migrar manualmente.

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

// Flutter can complete the first frame before the "show window" callback is
// registered. The following call ensures a frame is pending to ensure the
// window is shown. It is a no-op if the first frame hasn't completed yet.
flutter_controller_->ForceRedraw();
```

## Exemplo {:#example}

O [PR 995][] mostra o trabalho de migração para o
app [Flutter Gallery][].

[PR 995]: {{site.repo.gallery-archive}}/pull/995/files
[Flutter Gallery]: {{site.gallery-archive}}
