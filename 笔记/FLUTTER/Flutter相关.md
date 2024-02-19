##### Dart相关

Dart的单事件循环机制

​	1描述:Dart是运行在Isolate上的单线程,双任务队列的事件循环机制

​		Isolate是基于事件循环进行驱动的,其内部有两个事件列表 微任务队列Microtask 以及Event Quene,微任务队列Microtask优先级高于 Event Quene

​	 微任务有2个执行时机,

​		1,每当`UITaskRunner`执行完一个任务以后会触发微任务

​		2,每次界面刷新`_beginFrame`之后和回调`_drawFrame`之前 就会执行一次微任务队列

Isolate 和线程的区别

​	Isolate拥有自己的heap ,Mutator thread 多个Helper Thread,  Isolate是执行在Mutator thread 线程上,但是在程序运行过程中,Mutator thread 可能会变,即从一个线程切换到另一个线程


混入mixin

​	1,和java的实现相似,但是更加强大

​	2,解决了多重继承的混乱模式,mixin是线性的,在with后混入多个类,且拥有相同的方法时,

​			1)当前类的重写方法优先级最高

​			2)离with越远 优先级越高  A with B,C,D  这里优先级 A>D>C>B

​	3,mixin实现了 没有共同父类的各个类中共享代码  这点在flutter源码中使用及其广泛

##### flutter相关

大体框架描述:



生命周期



三种通道通信



widget,element 和renderobject的区别



