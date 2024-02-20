## Dart相关

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
**字节技术介绍  > https://gityuan.com/2019/10/05/dart_vm/**


#### Isolate 和线程的区别

​	Isolate拥有自己的heap ,Mutator thread 多个Helper Thread,  Isolate是执行在Mutator thread 线程上,但是在程序运行过程中,Mutator thread 可能会变,即从一个线程切换到另一个线程
​	
### ​dart异步

主流异步实现有两种：
1. 基于多线程的异步模型，线程是CPU调度的最小单位，同一时间 同一cpu只会对应一个线程
2. 基于事件循环的异步模型，一般来说是 单线程+事件队列+事件循环
 
多线程虽然好用，但是在大量并发时，仍然存在两个较大的缺陷，一个是开辟线程比较耗费资源，线程开多了机器吃不消，另一个则是线程的锁问题，多个线程操作共享内存时需要加锁，复杂情况下的锁竞争不仅会降低性能，还可能造成死锁。因此又出现了基于事件的异步模型。简单说就是在某个单线程中存在一个事件循环和一个事件队列，事件循环不断的从事件队列中取出事件来执行，这里的事件就好比是一段代码，每当遇到耗时的事件时，事件循环不会停下来等待结果，它会跳过耗时事件，继续执行其后的事件。当不耗时的事件都完成了，再来查看耗时事件的结果。因此，耗时事件不会阻塞整个事件循环，这让它后面的事件也会有机会得到执行。

我们很容易发现，这种基于事件的异步模型，只适合I/O密集型的耗时操作，因为I/O耗时操作，往往是把时间浪费在等待对方传送数据或者返回结果，因此这种异步模型往往用于网络服务器并发。如果是计算密集型的操作，则应当尽可能利用处理器的多核，实现并行计算。  

#### Dart的单事件循环机制

​	1，描述:Dart是运行在Isolate上的单线程,双任务队列的事件循环机制

​		Isolate是基于事件循环进行驱动的,其内部有两个事件列表 微任务队列Microtask 以及Event Quene,微任务队列Microtask优先级高于 Event Quene

​	 2，微任务有2个执行时机,

​		1,每当`UITaskRunner`执行完一个任务以后会触发微任务

​		2,每次界面刷新`_beginFrame`之后和回调`_drawFrame`之前 就会执行一次微任务队列
​		
​	3，每次执行微任务时，需要将微任务队列全部执行完毕才会执行下一个事件队列中的事件
​	
##### ​如下是dart单线程双任务队列模型		
​	![2be9f4ec3625423dbced4f1b47ff28bc~tplv-k3u1fbpfcp-zoom-in-crop-mark_1512_0_0_0](https://raw.githubusercontent.com/wkkun/study/main/%E7%AC%94%E8%AE%B0/img/2be9f4ec3625423dbced4f1b47ff28bc%7Etplv-k3u1fbpfcp-zoom-in-crop-mark_1512_0_0_0.webp)

#### dart异步的具体使用 Future async await
    

### 混入mixin

​	1,和java的实现相似,但是更加强大

​	2,解决了多重继承的混乱模式,mixin是线性的,在with后混入多个类,且拥有相同的方法时,

​			1)当前类的重写方法优先级最高

​			2)离with越远 优先级越高  A with B,C,D  这里优先级 A>D>C>B

​	3,mixin实现了 没有共同父类的各个类中共享代码  这点在flutter源码中使用及其广泛

### flutter相关

简介：
Flutter 是一个跨平台的 UI 工具集



大体框架描述:
![ac7d1cec200f7ea7cb6cbab04eda252f](https://raw.githubusercontent.com/wkkun/study/main/%E7%AC%94%E8%AE%B0/img/ac7d1cec200f7ea7cb6cbab04eda252f.webp)

官方简介 > https://flutter.cn/docs/resources/architectural-overview


生命周期



### widget,element 和renderobject的区别

#### Widget
官方简介是
> Describes the configuration for an [Element]
> 
>  Widgets are the central class hierarchy in the Flutter framework. 
> A widget is an immutable description of part of a user interface.
>  Widgets can be inflated into elements, which manage the underlying render tree
即是 Element的配置信息，Widgets是Flutter framework的核心类，widget是用户接口中不可变的描述，通过widget可以生成管理底层渲染树的Element类

需要注意的是
1. 在flutter中一切皆是widget，它不仅仅是描述UI的配置信息，而且也表示 手势检测 主题 滚动等等功能，只是flutter是一个UI框架 我们大部分都是用widget表示UI
2. widget是不可变的，每一次UI刷新都会生成新的widget，可复用的是element和renderobject
3. widget和element是一对多的关系，

#### Element

Element就是Widget在UI树具体位置的一个实例化对象，Widget是Element的配置信息，Element通过Widget创建Renderobject并赋值给RenderObjectElement._renderObject

widget是不可变的，每次刷新都会重新生成，但是Element是可以缓存的，它会根据widget是否变化以及是否可更新决定是否复用


#### Renderobject

   RenderObject就是渲染树中的一个对象，**它主要的作用是实现事件响应以及渲染管线中除过 build 的执行过程（build 过程由 element 实现），即包括：布局、绘制、层合成以及上屏**
   
   RenderObject类本身实现了一套基础的布局和绘制协议，但是并没有定义子节点模型（如一个节点可以有几个子节点，没有子节点？一个？两个？或者更多？）。 它也没有定义坐标系统（如子节点定位是在笛卡尔坐标中还是极坐标？）和具体的布局协议（是通过宽高还是通过constraint和size?，或者是否由父节点在子节点布局之前或之后设置子节点的大小和位置等）
   为此，Flutter框架提供了一个RenderBox和一个 RenderSliver类，它们都是继承自RenderObject，布局坐标系统采用笛卡尔坐标系，屏幕的(top, left)是原点。而 Flutter 基于这两个类分别实现了基于 RenderBox 的盒模型布局和基于 Sliver 的按需加载模型

#### 如何关联的
runApp(Widget)=>WidgetsFlutterBinding.scheduleAttachRootWidget(View(Widget))
=>WidgetsFlutterBinding.attachRootWidget(..Widget..)=>RootWidget(Widget).attach=>RootElement.mount=>RootElement._rebuild()=>RootElement.updateChild()
=>inflateWidget(Widget)
```
Element inflateWidget(Widget newWidget, Object? newSlot){
...
final Element newChild = newWidget.createElement();
newChild.mount(this, newSlot);
...
}
```
即是 从runapp开始 执行attach方法 创建RootElement 然后执行mount挂载方法，在该方法中会执行重建方法进而 加载我们写的根widget 并inflate创建Element，并挂载，以此按照深度优先遍历整个widget树，生成相应的Element并挂载从而形成Element树
而在RenderObjectElement的挂载方法中
```
RenderObjectElement.dart
void mount(Element? parent, Object? newSlot) {
...
//调用widget的创建renderobject方法 并缓存
_renderObject = (widget as RenderObjectWidget).createRenderObject(this);
//将renderobject 插入到renderobject树种
 attachRenderObject(newSlot);
...
}

```

如图为三棵树的转换
![trees](assets/trees.webp)
widget到Element是一对多  Element到RenderObject是1对0或者1 只有RenderObjectElement才会生成RenderObjec


三种通道通信


通信的实现

### flutter引擎的启动流程

### flutter的启动流程

flutter 从main()方法开始启动
```
void runApp(Widget app) {
//初始化WidgetsFlutterBinding单例
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  assert(binding.debugCheckZone('runApp'));
  binding
  //将我们自定义的widget添加到rootwidget 生成整个Element树和renderobject树
    ..scheduleAttachRootWidget(binding.wrapWithDefaultView(app)）
    //尽快刷新帧，而不是等待引擎请求帧以响应系统“Vsync”信号。
    ..scheduleWarmUpFrame();
}
```
WidgetsFlutterBinding 是flutter中混合了各种绑定的绑定类

```
class WidgetsFlutterBinding extends BindingBase with GestureBinding, SchedulerBinding, ServicesBinding, PaintingBinding, SemanticsBinding, RendererBinding, WidgetsBinding{

}
```
其中RendererBinding 是和刷新相关、

```
mixin RendererBinding on BindingBase, ...{

  void initInstances() {
  ...
  //添加持久帧回调
  addPersistentFrameCallback(_handlePersistentFrameCallback);
  ...
  }
  
   void _handlePersistentFrameCallback(Duration timeStamp) {
    drawFrame();
    _scheduleMouseTrackerUpdate();
  }
  
  //绘制
    @protected
  void drawFrame() {
  //重新布局
    rootPipelineOwner.flushLayout();
    //更新“层合成”信息
    rootPipelineOwner.flushCompositingBits();
    //绘制
    rootPipelineOwner.flushPaint();
    if (sendFramesToEngine) {
      for (final RenderView renderView in renderViews) {
      //发送到GPU
        renderView.compositeFrame(); // this sends the bits to the GPU
      }
      rootPipelineOwner.flushSemantics(); // this sends the semantics to the OS.
      _firstFrameSent = true;
    }
  }

}
```
综上 flutter的启动流程是
1. 执行runapp() 初始化WidgetsFlutterBinding单例，其混入的RendererBinding添加持久帧回调，addPersistentFrameCallback
2. 生成将自定义的widget包裹在RootWidget中生成Elment树和RenderObject树，并设置BuildOwner
3. 尽快开启下一帧绘制

### flutter的刷新流程

### flutter的渲染机制 

![flutter_draw](assets/flutter_draw.png)

1. 当需要渲染则会调用到Engine的ScheduleFrame()来注册VSYNC信号回调，一旦触发回调doFrame()执行完成后，便会移除回调方法，也就是说一次注册一次回调；
2. 当需要再次绘制则需要重新调用到ScheduleFrame()方法，该方法的唯一重要参数regenerate_layer_tree决定在帧绘制过程是否需要重新生成layer tree，还是直接复用上一次的layer tree；
3. UI线程的绘制过程，最核心的是执行WidgetsBinding的drawFrame()方法，然后会创建layer tree视图树
4. 再交由GPU Task Runner将layer tree提供的信息转化为平台可执行的GPU指令。

#### 核心工作
##### Vsync单注册模式：保证在一帧的时间窗口里UI线程只会生成一个layer tree发送给GPU线程，原理如下
   Animator中的信号量pending_frame_semaphore_用于控制不能连续频繁地调用Vsync请求，一次只能存在Vsync注册。 pending_frame_semaphore_初始值为1，在Animator::RequestFrame()消费信号会减1，当而后再次调用则会失败直接返回； Animator的BeginFrame()或者DrawLastLayerTree()方法会执行信号加1操作。
##### RendererBinding的 drawFrame（）方法

```
  void drawFrame() {
  //更新布局
    rootPipelineOwner.flushLayout();
    //更新合成层
    rootPipelineOwner.flushCompositingBits();
    //重新绘制
    rootPipelineOwner.flushPaint();
    if (sendFramesToEngine) {
      for (final RenderView renderView in renderViews) {
      //发送到gpu
        renderView.compositeFrame(); // this sends the bits to the GPU
      }
      rootPipelineOwner.flushSemantics(); // this sends the semantics to the OS.
      _firstFrameSent = true;
    }
  }
```


1. Layout: 计算渲染对象的大小和位置，对应于flushLayout()，这个过程可能会嵌套再调用build操作；
2. Compositing bits: 更新具有脏合成位的任何渲染对象， 对应于flushCompositingBits()
3. Paint: 将绘制命令记录到Layer， 对应于flushPaint()；
4. Compositing:将Compositing bits发送给GPU， 对应于compositeFrame()；
5. Semantics: 编译渲染对象的语义，并将语义发送给操作系统， 对应于flushSemantics()。


SchedulerBinding是flutter引擎的调度绑定类

当平台 vsync信号发出 进行屏幕刷新时 会调用
PlatformDispatcher.instance._drawFrame()
而_drawFrame最后调用SchedulerBinding的handleDrawFrame方法

```
SchedulerBinding.dart

  void handleDrawFrame() {
  ...
    // PERSISTENT FRAME CALLBACKS 
    //此处调用所有注册固定帧刷新回调 即是：addPersistentFrameCallback
      _schedulerPhase = SchedulerPhase.persistentCallbacks;
      for (final FrameCallback callback in            List<FrameCallback>.of(_persistentCallbacks)) {
        _invokeFrameCallback(callback, _currentFrameTimeStamp!);
      }

      // POST-FRAME CALLBACKS
      _schedulerPhase = SchedulerPhase.postFrameCallbacks;
      final List<FrameCallback> localPostFrameCallbacks =
          List<FrameCallback>.of(_postFrameCallbacks);
      _postFrameCallbacks.clear();
  ...
  }
```

而RendererBinding在flutter启动时就生成渲染管线并注册了固定帧回调，所以此时执行RendererBinding._handlePersistentFrameCallback
=>RendererBinding.drawFrame()
```
  void drawFrame() {
  //更新布局
    rootPipelineOwner.flushLayout();
    //更新合成层
    rootPipelineOwner.flushCompositingBits();
    //重新绘制
    rootPipelineOwner.flushPaint();
    if (sendFramesToEngine) {
      for (final RenderView renderView in renderViews) {
      //发送到gpu
        renderView.compositeFrame(); // this sends the bits to the GPU
      }
      rootPipelineOwner.flushSemantics(); // this sends the semantics to the OS.
      _firstFrameSent = true;
    }
  }
```
1. RendererBinding初始化时生成渲染管线PipelineOwner 并为flutter renderobject树 共有
2. flushLayout 遍历_nodesNeedingLayout数组，对每一个renderObject重新布局（调用其_layoutWithoutResize方法），确定新的大小和偏移。_layoutWithoutResize方法中会调用markNeedsPaint()，该方法和 markNeedsLayout 方法功能类似，也会从当前节点向父级查找，直到找到一个isRepaintBoundary属性为true的父节点，然后将它添加到一个全局的nodesNeedingPaint列表中；由于根节点（RenderView）的 isRepaintBoundary 为 true，所以必会找到一个。查找过程结束后会调用 buildOwner.requestVisualUpdate 方法，该方法最终会调用scheduleFrame()，该方法中会先判断是否已经请求过新的frame，如果没有则请求一个新的frame。
3. flushCompositingBits
4. flushPaint 遍历nodesNeedingPaint列表，调用每一个节点的paint方法进行重绘，绘制过程会生成Layer。需要说明一下，flutter中绘制结果是保存在Layer中的，也就是说只要Layer不释放，那么绘制的结果就会被缓存，因此，Layer可以跨frame来缓存绘制结果，避免不必要的重绘开销。Flutter框架绘制过程中，遇到isRepaintBoundary 为 true 的节点时，才会生成一个新的Layer。可见Layer和 renderObject 不是一一对应关系，父子节点可以共享，这个我们会在随后的一个试验中来验证。当然，如果是自定义组件，我们可以在renderObject中手动添加任意多个 Layer，这通常用于只需一次绘制而随后不会发生变化的绘制元素的缓存场景，
5. 上屏 绘制完成后，我们得到的是一棵Layer树，最后我们需要将Layer树中的绘制信息在屏幕上显示。我们知道Flutter是自实现的渲染引擎，因此，我们需要将绘制信息提交给Flutter engine，而renderView.compositeFrame 正是完成了这个使命










