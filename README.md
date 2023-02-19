# HCPF: Validador e Gerador de CPF escrito em Haskell

Ferramenta simples para mostrar um pouco da capacidade do Haskell como ferramenta(e pra eu poder treinar um poquinho de programação funcional também).

Sua utilização é bem simples:

``` sh
hcpf #Gera um CPF aleatório

hcpf 123.456.789-00 #Verifica se o CPF é válido
```

### Requisitos
Para utilizar está ferramenta você vai precisar ter o compilador de Haskell GHCI, e o pacote random instalado.

``` sh
dnf install gchi #Fedora
apt-get update && apt-get install ghc6 ghc6-prof #Debian
```

Para instalação do Random em alguns casos será necessário instalar está biblioteca. Para isso recomendo a utilização do GHCUP e o stack. Depois basta instalar com o stack a biblioteca:

`stack ghci --package random`

Aqui vai mais alguns links caso tenha alguma dúvida ou algum dos processos não tenha funcionado:

Para instalação do GHCI:
https://www.haskell.org/ghc/distribution_packages.html

Instalaçao do GHCUP:
https://www.haskell.org/ghcup/

Instalação de Módulos:
https://discourse.haskell.org/t/how-to-install-modules/1363/2

E para você que assim como eu achou interessante a ideia de aprender uma linguagem que trabalha de maneira diferente, aqui vai o livro que me introduziu Haskell e a sua wiki:

https://wiki.haskell.org/Haskell

https://wiki.haskell.org/Haskell
