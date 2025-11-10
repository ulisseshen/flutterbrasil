Os exemplos nesta pasta costumavam estar em `src/_includes/code`. Apesar disso,
os códigos-fonte não estavam sendo incluídos em lugar algum. É provável que os códigos-fonte
apareçam em algumas páginas mesmo assim. O que precisa ser feito é o seguinte:

- Cada app/exemplo precisa ser totalmente revisado (e potencialmente simplificado).
- Se os códigos-fonte estiverem de fato sendo usados em páginas do site, então eles precisam ser
  integrados como trechos de código adequados. Veja [Code excerpts][] para detalhes.
- Cada app/exemplo deve ser testado, pelo menos com um smoke test.

À medida que essas mudanças forem concluídas para uma determinada pasta de app/exemplo, mova a
pasta para `examples/animation`. Quando `examples/_animation` estiver vazio, pode ser
excluído.

[Code excerpts]: https://github.com/dart-lang/site-shared/blob/main/doc/code-excerpts.md
