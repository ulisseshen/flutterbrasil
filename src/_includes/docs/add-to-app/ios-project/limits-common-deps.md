
Flutter não pode lidar com [dependências comuns com xcframeworks][common].
Se tanto o app hospedeiro quanto o plugin do módulo Flutter definem a
mesma dependência pod e você integra o módulo Flutter usando esta opção,
ocorrem erros.
Esses erros incluem problemas como `Multiple commands produce
'CommonDependency.framework'`.

Para contornar este problema, vincule cada fonte de plugin em seu arquivo `podspec`
do módulo Flutter ao `Podfile` do app hospedeiro.
Vincule a fonte em vez do framework `xcframework` dos plugins.
A próxima seção explica como [produzir esse framework][ios-framework].

Para prevenir o erro que ocorre quando existem dependências comuns,
use `flutter build ios-framework` com a flag `--no-plugins`.

[common]: https://github.com/flutter/flutter/issues/130220
[ios-framework]: https://github.com/flutter/flutter/issues/114692
