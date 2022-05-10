import macros
import typeinfo
import std/typetraits


proc getReclist*(node:NimNode):NimNode=
    return node[2][0][2]

macro echoAst*(class:typed)=
    echo class.getImpl().treeRepr
    

macro getAst0*(class:typed):NimNode=
    return class.getImpl()


proc getBaseIndent*(node:NimNode):NimNode=

    case node.kind
        of nnkPostfix:
            result = node.basename
        of nnkSym:
            result = node
        else:
            result=newEmptyNode()


proc someProcThatMayRunInCompileTime(): bool =
  when nimvm:
    # This branch is taken at compile time.
    result = true
  else:
    # This branch is taken in the executable.
    result = false   