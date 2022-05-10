import inputs
import ConstructorCreator
import outputs
import macros
import ../macroTool

static:
    echo "0outputs must be"
    echoAst(outputs.create_TestClass)
    #echo getAst0(outputs.create_TestClass).treeRepr
    echo "0outputs-----------------------------------"

createConstructor(inputs.TestClass)

var t0=outputs.create_TestClass()
var t1=create_TestClass()

echo t0.value
echo t1.value


echo t0.value2.y
echo t1.value2.y