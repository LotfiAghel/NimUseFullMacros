import macros
type
    MyClass=object
        y*:int
        y1*:int

proc hello(x:int=22,x1:int):MyClass =
    echo "hi ",x
    echo "h2 "
    result = MyClass(y:x,y1:x1)

macro echoAst(a:typed)=
    echo a.getImpl().treeRepr
    

macro gen_hello(): typed =
    result = nnkStmtList.newTree(
        nnkProcDef.newTree(
            newIdentNode("hello2"),
            newEmptyNode(),
            newEmptyNode(),
            nnkFormalParams.newTree(
                    newIdentNode("int"),
                    nnkIdentDefs.newTree(
                        newIdentNode("x"),
                        newIdentNode("int"),
                         newEmptyNode(),
                    )
            ),
            newEmptyNode(),
            newEmptyNode(),
            nnkStmtList.newTree(
                nnkCommand.newTree(
                    newIdentNode("echo"),
                    newLit("hi2")
                ),
                nnkAsgn.newTree(
                    newIdentNode("result"), 
                     newIdentNode("x"),
                )
            )
        )
    )
echoAst(hello)
gen_hello()
echo hello(10,12)
echo hello2(12)
