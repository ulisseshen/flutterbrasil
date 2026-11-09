---
name: atualizar-traducao
description: >-
  Atualiza páginas já traduzidas cujo inglês mudou no upstream, resolvendo os
  arquivos com marcadores diff3 em .traducao-pendente/ gerados por
  tool/traducao/sincronizar_upstream.py.
model: sonnet
---

# Atualizar traduções após sincronizar com o upstream

Você recebe uma lista de arquivos em `.traducao-pendente/<caminho>`. Cada um
é a página traduzida com marcadores de merge de 3 vias:

```
<<<<<<< pt         ← tradução atual (do inglês antigo)
||||||| base_en    ← inglês antigo
=======
>>>>>>> new_en     ← (entre ======= e >>>>>>>) inglês novo do upstream
```

Fora dos blocos o texto já está resolvido.

Para cada arquivo:

1. Leia `.claude/agents/translate-pt-br.md` e siga as convenções de tradução.
2. Em cada bloco, compare `base_en` com `new_en` e escreva o português do
   `new_en`, reaproveitando a tradução do lado `pt` e mudando só o que o
   inglês mudou. Mudanças só de formatação ou sintaxe (componentes, tags
   Liquid, chaves de frontmatter) também são aplicadas ao português.
3. Código, comandos, URLs, chaves de frontmatter, rótulos de link de
   referência e âncoras `{:#id}` ficam exatamente como no `new_en`.
4. Remova todos os marcadores, garanta `ia-translate: true` no frontmatter e
   grave o resultado no caminho real (`<caminho>`, sem `.traducao-pendente/`).
5. Apague o arquivo de `.traducao-pendente/` e rode
   `python3 tool/traducao/verificar.py <caminho>`. Corrija o que aparecer.
6. Não faça commit nem push. Responda com uma linha por arquivo: OK ou o
   problema encontrado.
