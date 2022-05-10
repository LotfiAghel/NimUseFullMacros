import lenientops, math, times, strformat, atomics, system/ansi_c
import nimraylib_now
from nimraylib_now/rlgl as rl import nil
import macros
import typeinfo
import std/typetraits

import macros

type 
    MyClass* = ref object of RootObj
        p*:int

template dfv(name: untyped) {.pragma.}

type
    RenderComp* = ref object of RootObj
        position* : Vector2
        position2* : Vector2
        visible*{. dfv(true) .} : bool 
        mmm*{. dfv(MyClass(p:10)) .}:MyClass




var z{. compileTime.}:NimNode        

proc getReclist(node:NimNode):NimNode=
    return node[2][0][2]

proc getBaseIndent(node:NimNode):NimNode=

    case node.kind
        of nnkPostfix:
            result = node.basename
        of nnkSym:
            result = node
        else:
            result=newEmptyNode()


macro createConstructor3(class:typed)=
    echo class.getImpl().treeRepr
    z = class.getImpl()
    echo "----"
    var parms = nnkFormalParams.newTree(
                    class,
            )
    var ConstractorASt = nnkObjConstr.newTree(
                        class,
                        

                    )
    for i in getReclist(class.getImpl()):
        echo "......."
        echo i.treeRepr
        var tmp:NimNode
        if(i[0].kind == nnkPragmaExpr):
            echo "======="
            echo i[0][1][0][1].treeRepr
            echo "]]]]]]]]]]]]]",$(i[0][0])
            parms.add(nnkIdentDefs.newTree(
                        newIdentNode($(i[0][0].getBaseIndent)),
                        i[1],
                        i[0][1][0][1],
                    )
            )
            tmp=nnkExprColonExpr.newTree(
                            newIdentNode($(i[0][0].getBaseIndent)),
                            i[0][0].getBaseIndent
                        )
        else:
            parms.add(nnkIdentDefs.newTree(
                        newIdentNode($(i[0].getBaseIndent)),
                        i[1],
                        newEmptyNode(),
                    )
            )
            tmp=nnkExprColonExpr.newTree(
                            newIdentNode($(i[0].getBaseIndent)),
                            i[0].getBaseIndent
                        )
        ConstractorASt.add(tmp)

    result = nnkStmtList.newTree(
        nnkProcDef.newTree(
            newIdentNode("create_"& $(class)),
            newEmptyNode(),
            newEmptyNode(),
            parms,
            newEmptyNode(),
            newEmptyNode(),
            nnkStmtList.newTree(
                nnkCommand.newTree(
                    newIdentNode("echo"),
                    newLit("hi2")
                ),
                
                nnkAsgn.newTree(
                    newIdentNode("result"), 
                    ConstractorASt
                )
            )
        )
    )    
    echo "outtttttttttttttttttttttttttttttttttt"
    echo result.treeRepr

proc someProcThatMayRunInCompileTime(): bool =
  when nimvm:
    # This branch is taken at compile time.
    result = true
  else:
    # This branch is taken in the executable.
    result = false    

createConstructor3(RenderComp)

var tt=create_RenderComp((0.1,0.1),(0.0,0.0))
echo tt.visible