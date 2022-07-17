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
        if(i[0].kind == nnkPragmaExpr): #TODO check dfv exist not every pragma
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
                            i[1]  #TODO check dfv parms not every pragma
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


macro createConstructor2*(class:typed)=
    echo class.treeRepr
    var parms = nnkFormalParams.newTree(
                    class,
            )
    var GenericArgs=nnkGenericParams.newTree(class,newIdentNode("T"))
    var ConstractorASt = nnkObjConstr.newTree(
                        class
                    )
    parms.add(nnkIdentDefs.newTree(
                        newIdentNode("T"),
                        nnkBracketExpr.newTree(
                            newIdentNode("typedesc"),
                            class
                        )
                    )
            )
    for i in getReclist(class.getImpl()):
        var tmp:NimNode
        if(i[0].kind == nnkPragmaExpr): #TODO check dfv exist not every pragma
            parms.add(nnkIdentDefs.newTree(
                        i[0][0].getBaseIndent,
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
                            i[1]  #TODO check dfv parms not every pragma
                        )
                    )
            )
            tmp=nnkExprColonExpr.newTree(
                            newIdentNode($(i[0].getBaseIndent)),
                            i[0].getBaseIndent
                        )
        #ConstractorASt.add(tmp)

    result = nnkStmtList.newTree(
        nnkMacroDef.newTree(
            newIdentNode("Create2"& $(class)),
            newEmptyNode(),
            GenericArgs,
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

macro echo_tree*(class:typed)=
    echo class.getImpl().treeRepr

type
    Person* =ref object of RootObj
        x* :int
        y* {. dfv(1011) .} :int
type
    Person2* =ref object of RootObj
        x* :int
        y* {. dfv(2022) .} :int
        y3* {. dfv(2033) .} :int
type
  PersonY=object    
    y*:int
import std/tables

proc getNode*(t:NimNode): NimNode =
    return t.findNodeType(nnkPragma)[0]
#macro Create*(T0: typedesc[type],x: varargs[untyped]): untyped =
{.experimental: "dynamicBindSym".}
proc fn_signature(fn: NimNode): NimNode =
  echo "fn_signature"  
  return   fn.bindSym()

proc addFileds(classBody:NimNode,result:NimNode,mark:Table[string,int])=
   for i in classBody.findNodeType(nnkRecList):
        echo "---==--"
        #echo dfvNode
        echo i.treeRepr
        var tmp=i.findNodeType(nnkPragmaExpr)
        var posifix=i.findNodeType(nnkPostfix)
        echo "..........."
        if posifix.isNil:
            posifix=i.findNodeType(nnkIdent)
        echo posifix.treeRepr
        if not tmp.isNil and not mark.hasKey($(posifix.getBaseIndent)): #TODO check dfv exist not every pragma
            echo i[0][1][0][1].treeRepr
            var pragma=i.findNodeType(nnkPragma).findNodeType(nnkCall)
            
            if $pragma[0] == "dfv": #TODO string always is bad moust found way to check  pragma[0] == sumFunction(dfv) 
                result.add nnkExprColonExpr.newTree(
                                posifix.getBaseIndent,
                                pragma[1]
                            )  


macro Create*(T0: untyped,x: varargs[untyped]): untyped =
    echo repr(x)
    #echo dfv.bindSym(rule=brForceOpen)
    var T=T0
    echo "echo T.treeRepr"
    echo T.treeRepr
    if T.kind==nnkBracketExpr:
        echo "thats generic2"
        
        result=nnkBracketExpr.newTree(T,T[1])
        T=fn_signature(T[0])
        echo T
    else:
        result=nnkObjConstr.newTree(
            T,
        )    
    var classBody=T.getImpl()
    echo classBody.treeRepr
    

    

    var mark=initTable[string,int]()
    for c in x.children:
        result.add(
            nnkExprColonExpr.newTree(
                c[0],                
                c[1]
            )
        )
        mark[$(c[0])]=1
    echo classBody.treeRepr
    echo "---===================--"
    
    var ofInherit=classBody.findNodeType(nnkOfInherit)
    if not ofInherit.isNil:
        echo ofInherit[0].getImpl().treeRepr
        ofInherit[0].getImpl().addFileds(result,mark)
    
    #dfvFinder.getNode()
    #var body= getAst getAst0(dfvFinder)
    #var dfvNode  = getNode( body)
    #var dfvNode=quote(dfv)
    classBody.addFileds(result,mark)
     
    #echo result.treeRepr
    #result=result
    
        
    
    #result = parseStmt("Person(x:123)")
#var z=Person
var tptp=PersonY.Create(y=12)



var z=Person.Create(x=12)
var z2=Person2.Create(x=12)

#echo_tree(Create)
#var y=Person.Create(x=12,y=123)
echo z.y
echo z2.y
echo z2.y3
dumpTree:
    Person(x:125,y:12)
    #z.x=123456

when false:
    echo_tree(Create)
    #createConstructor2(Person)

    var x=Person.Create(x=12)
    echo x.x