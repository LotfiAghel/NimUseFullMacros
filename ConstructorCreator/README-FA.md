# TODO
## defult value of object field in c++
```
struct Point{
    float x=0.0,y=0.0;
};
Point p=Point(x=1.23);
cout<<p.x<<" "<<p.y<<endl;
"1.23 0.0"
```

``` 
Point* = object 
        x* {. dfv(0.0) .}:float
        y* {. dfv(0.0) .}:int

createConstructor3(Point)
``` 

instead of `createConstructor3(Point)` write  `createConstructor(create_Point,Point)` 
or `$ConstructorCreate(Point)`
``` 
create_Point(x=1.23) 
#[ or $ConstructorFind(Point)(x=1.23) 
در این حالت ما از کامپایل تایم فانکشن برای کاهش تعداد سیمبول ها استفاده میکنیم این خط از کد معادل 
constructor<Point>(x:1.23) 
هست]#
echo p.x," ",p.y
"1.23 0.0"
```
