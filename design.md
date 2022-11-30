***
***shit
# Design a preprocessing language for Overwatch workshop that facilitates some programming structures
## 1 What programming structures are needed?
***
### 1.1 Memory management
Too complicated.
***
### 1.2 Subroutine call with arguments
e.g. like this construct
```
@sub subname ([id] ...)
    [stmt]
    ...
@bus
```
***
### 1.3 Constant definitions
Use special characters to signal definitions and instances of constant. e.g. '@', "@@" for escaping.
```
@macro id replacement
```
***
***
# Actual design
***
***
# Learning Flex & Bison
***
***
# Learning GNU M4
- Arguments of a macro definition which also contain macro definitions will be expanded first.
- It seems that only '$' arguments quoted once (no more times) will be converted.
- Defined macro after undefined will expand to the original arguments?
## What Define actually does:
If the argument in macro definition is a quoted text, unquote it.
## Expand a definition:
1. define(`num',``$'`#'')dnl
2. define(`def',`define(`macro',``Some text''num``Some text'')')dnl
3. def`'dnl
## Quote a string containing an unmatched begin-quote:
Use `changequote`
## Getting the last argument:
Is impossible.

```
define(`m',a)
=> 
ifelse(`a',a,T,F)
=> T
ifelse(`m',a,T,F)
=> F
define(m,1)
=> 
a
=> 1
```

```
define(`macro',`shift($1)')
=> 
macro(1,2)
=> 2
```

```
define(`macro',`define(`hey',`hey$#'))
=> 
macro
=> 
hey
=> hey0
macro()
=>
hey
=> hey1
```
