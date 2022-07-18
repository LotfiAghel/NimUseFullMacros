import Basic


type
    TestStruct0* = object
        x* {. dfv(10) .}:int
        y*:int

proc create_TestStruct0*(y:int):TestStruct0=
    return TestStruct0(x:0,y:y)
type
    TestClass0* = ref object
        x* {. dfv(10) .}:int
        y*:int
type        
    TestClass* = ref object of RootObj
        value* {. dfv(create_TestStruct0(y=10)) .}: TestStruct0
        value1* : TestClass0
        value2* {. dfv(TestClass0(y:10)) .}:TestClass0


