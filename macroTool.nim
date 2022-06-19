import macros
import typeinfo
import std/typetraits


proc getReclist*(node:NimNode):NimNode=
    if node[2][0].kind==nnkRefTy:
      return node[2][0][2]
      return node[2][2]

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


template badNodeKind(n, f) =
  error("Invalid node kind " & $n.kind & " for macros.`" & $f & "`", n)

proc `$$$`*(node: NimNode): string =
  ## Get the string of an identifier node.
  case node.kind
  of nnkPostfix:
    result = node.basename.strVal & "*"
  of nnkStrLit..nnkTripleStrLit, nnkCommentStmt, nnkSym, nnkIdent:
    result = node.strVal
  of nnkOpenSymChoice, nnkClosedSymChoice:
    result = $node[0]
  of nnkAccQuoted:
    result = $node[0]
  of nnkBracketExpr:
    echo node.treeRepr
    result = "__braketOpen__"
    
    for i in node:
      result=result  & $$$i & "_sp_"
    result=result & "__close__"
  else:
    badNodeKind node, "$$$"



macro ECHO*(a:static[string])=
  echo "----------------------------",a


macro StaticFor*(idx:untyped, N: static[int],body:NimNode):NimNode=
  echo "for"
  var x:NimNode=newNimNode(nnkBlockType)
  
  for i in 0.. 3:
    echo "macroo" , i
    x.add(body)
    #x.add(body)
  return x
  