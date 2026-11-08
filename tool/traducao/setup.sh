#!/usr/bin/env bash
# Prepara um ambiente do zero (por exemplo, uma sessão nova na nuvem):
# instala o Dart SDK na versão usada pelo CI do upstream, configura o remote
# `upstream` e baixa as dependências.
#
#   bash tool/traducao/setup.sh
#   export PATH="$HOME/.dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
set -euo pipefail
cd "$(dirname "$0")/../.."

# Versão do Dart: a mesma de .github/workflows/docs.yml.
versao=$(grep -m1 -oE 'sdk: [0-9][^ ]*' .github/workflows/docs.yml | cut -d' ' -f2)
canal=stable
case "$versao" in *beta*) canal=beta ;; *dev*) canal=dev ;; esac
destino="$HOME/.dart-sdk"

if [ -x "$destino/bin/dart" ] && "$destino/bin/dart" --version 2>&1 | grep -q "$versao"; then
  echo "Dart $versao já instalado em $destino"
else
  echo "Baixando Dart $versao ($canal)..."
  tmp=$(mktemp -d)
  curl -sSfLo "$tmp/sdk.zip" \
    "https://storage.googleapis.com/dart-archive/channels/$canal/release/$versao/sdk/dartsdk-linux-x64-release.zip"
  unzip -q "$tmp/sdk.zip" -d "$tmp"
  rm -rf "$destino"
  mv "$tmp/dart-sdk" "$destino"
  rm -rf "$tmp"
fi
export PATH="$destino/bin:$HOME/.pub-cache/bin:$PATH"

if ! git remote get-url upstream >/dev/null 2>&1; then
  git remote add upstream https://github.com/flutter/website.git
fi
# Histórico suficiente para encontrar o último commit sincronizado.
git fetch --depth=3000 upstream main
if git rev-parse --is-shallow-repository | grep -q true; then
  git fetch --depth=3000 origin "$(git rev-parse --abbrev-ref HEAD)" || true
fi

dart pub get
echo
echo "Pronto. Adicione ao PATH: export PATH=\"$destino/bin:\$HOME/.pub-cache/bin:\$PATH\""
