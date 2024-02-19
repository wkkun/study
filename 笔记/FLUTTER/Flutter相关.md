## Dart相关

### Dart的单事件循环机制

​	1描述:Dart是运行在Isolate上的单线程,双任务队列的事件循环机制

​		Isolate是基于事件循环进行驱动的,其内部有两个事件列表 微任务队列Microtask 以及Event Quene,微任务队列Microtask优先级高于 Event Quene

​	 微任务有2个执行时机,

​		1,每当`UITaskRunner`执行完一个任务以后会触发微任务

​		2,每次界面刷新`_beginFrame`之后和回调`_drawFrame`之前 就会执行一次微任务队列

### Isolate（隔离）

   在Dart VM中任何dart代码都是运行在某个isolate中的，每个isolate都是独立的，它们都有自己的存储空间、主线程和各个辅助线程，isolate之间互不影响。在Dart VM中可能同时运行着多个isolate，但它们不能直接共享数据，可以通过端口（ports：Dart VM中的一个概念，和网络中的端口不一样）相互交流信息。
   
![isolates](https://raw.githubusercontent.com/wkkun/study/main/%E7%AC%94%E8%AE%B0/img/isolates.png)

一个isolate中主要包括以下几个部分：
1. Heap：存储dart代码运行过程中创建的所有object，并由GC（垃圾回收）线程管理。
2. 单个Mutator Thread：主线程，负责执行dart代码。
3. 多个Helper Thread：辅助线程，完成Dart VM中对isolate的一些管理(GC)、优化，等任务。

同时我们可以看到VM中有一个特殊的vm-isolate，其中保存了一些全局共享的常量数据。虽然isolate之间不能相互引用，但是每个isolate都能引用vm-isolate中保存的数据。
在这里我们再深入探讨一下isolate和OS thread的关系，实际上这是十分复杂和不确定的，因为这取决于平台特性和VM被打包进应用的方式，但是有以下三点是确定的：

1. 一个OS thread一次只能进入一个isolate，若想进入其他的isolate必须先从当前isolate退出。
2. 一个isolate一次只能关联一个mutator thread，mutator thread用于执行dart代码和调用VM中public的C API。
3. 一个isolate可以同时关联多个helper thread，比如JIT编译线程、GC线程等。

实际上Dart VM在内部维护了一个全局的线程池ThreadPool来管理OS thread，所有创建线程的请求都被描述成发向线程池的ThreadPool::Task，比如GC回收内存时发送请求SweeperTask，线程池会首先检查池中是否有可用的OS thread，有的话则直接复用，没有的话则会创建一个新的线程。

**官方dart VM介绍 > https://mrale.ph/dartvm/**


#### Isolate 和线程的区别

​	Isolate拥有自己的heap ,Mutator thread 多个Helper Thread,  Isolate是执行在Mutator thread 线程上,但是在程序运行过程中,Mutator thread 可能会变,即从一个线程切换到另一个线程


#### 混入mixin

​	1,和java的实现相似,但是更加强大

​	2,解决了多重继承的混乱模式,mixin是线性的,在with后混入多个类,且拥有相同的方法时,

​			1)当前类的重写方法优先级最高

​			2)离with越远 优先级越高  A with B,C,D  这里优先级 A>D>C>B

​	3,mixin实现了 没有共同父类的各个类中共享代码  这点在flutter源码中使用及其广泛

### flutter相关

大体框架描述:
![ac7d1cec200f7ea7cb6cbab04eda252f](https://raw.githubusercontent.com/wkkun/study/main/%E7%AC%94%E8%AE%B0/img/ac7d1cec200f7ea7cb6cbab04eda252f.webp)

生命周期



三种通道通信



widget,element 和renderobject的区别



