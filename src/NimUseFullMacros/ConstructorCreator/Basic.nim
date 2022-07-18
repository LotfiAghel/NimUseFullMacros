
template dfv*(name: untyped) {.pragma.}


type
 dfvFinder* = object
    a*{.dfv(true).}:int