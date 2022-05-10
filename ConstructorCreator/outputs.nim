import inputs

proc create_TestClass*(
        value:TestStruct0=create_TestStruct0(y=10),
        value1:TestClass0=nil,
        value2:TestClass0=TestClass0(y:10)
    ):TestClass=
    return TestClass(
                value:value,
                value1:value1,
                value2:value2
                )