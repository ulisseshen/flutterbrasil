---
ia-translate: true
title: "Restaurar estado no iOS"
description: "Como restaurar o estado do seu app iOS após ele ser encerrado pelo sistema operacional."
---

Quando um usuário executa um app mobile e depois seleciona outro
app para executar, o primeiro app é movido para o background,
ou _colocado em background_. O sistema operacional (tanto iOS quanto Android)
frequentemente encerra o app em background para liberar memória ou
melhorar a performance do app em execução no foreground.

Você pode usar as classes [`RestorationManager`][] (e relacionadas)
para lidar com restauração de estado.
Um app iOS requer [um pouco de configuração extra][] no Xcode,
mas as classes de restauração funcionam da mesma forma em
ambos iOS e Android.

Para mais informações, confira [State restoration on Android][]
e o exemplo de código [VeggieSeasons][].

[um pouco de configuração extra]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[State restoration on Android]: /platform-integration/android/restore-state-android
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons
