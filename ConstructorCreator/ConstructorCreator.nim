import macros
import typeinfo
import std/typetraits
import macros

import Basic

import ../macroTool

macro createConstructor*(class:typed)=
    echo class.treeRepr
    var parms = nnkFormalParams.newTree(
                    class,
            )
    var ConstractorASt = nnkObjConstr.newTree(
                        class
                    )
    for i in getReclist(class.getImpl()):
        var tmp:NimNode
        if(i[0].kind == nnkPragmaExpr):
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
                        nnkObjConstr.newTree(
                            i[1]
                        )
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
                nnkAsgn.newTree(
                    newIdentNode("result"), 
                    ConstractorASt
                )
            )
        )
    )    
    echo "outtttttttttttttttttttttttttttttttttt"
    echo result.treeRepr



