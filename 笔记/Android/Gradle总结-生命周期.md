## 生命周期

Gradle的生命周期图如下所示:

![20150905194317170](/Users/wangkunkun/Pictures/20150905194317170.png)

图来源于:[深入理解Android之Gradle](https://blog.csdn.net/innost/article/details/48228651)

**生命周期分为三个阶段:**

##### 一、初始化

1. 为settings.gadle文件创建一个[Settings](https://docs.gradle.org/current/javadoc/org/gradle/api/initialization/Settings.html)对象,并执行settings.gadle文件中的配置代码,
2. 利用Settings对象为settings.gadle文件中包含的所有Project项目根据其build.gradle文件创建具有层次关系的Project对象

**注意:**

- settings.gadle文件和Settings对象是一一对应关系,也就是一个settings.gradle文件只能创建一个Settings对象.
- settings.gradle文件中通过include:Project方式添加项目,实际上执行的就是Settings对象中的**[include](https://docs.gradle.org/current/javadoc/org/gradle/api/initialization/Settings.html#include-java.lang.String...-)**([String](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html?is-external=true)... projectPaths)方法.
- Settings对象会自动为根项目创建Porject对象,名称就是包含settings.gradle文件的目录名.
- build.gradle文件和Project对象是一一对应关系,Settings对象是根据其所包含项目中的build.gradle文件创建Project对象

##### 二、配置

执行所包含的所有build.gradle文件中的配置代码,下载三方插件,依赖项,以及构建Task的依赖关系图,

**注意:**

- 执行build.gradle中的配置代码,不仅仅包含其中的语句,方法,DSL,还包含Task中的配置代码
- 构建Task的依赖关系图是Gradle的核心

##### 三、执行

根据任务命令以及参数,确定要执行的任务子集,并执行

**注意:**

- 对于多项目而言,每次执行任务,都需要执行前面的初始化和包含的所有项目的配置

## Hook点

我们经常会需要在Project或者是Task执行到某一阶段时做一些额外处理,这时我们就需要进行一些hook, Gradle官方为我们提供了以下方法,以便我们处理

[Interface Gradle](https://docs.gradle.org/current/javadoc/org/gradle/api/invocation/Gradle.html)

------

| void   settingsEvaluated()                  |             在settings.gradle被加载和解析时调用              |
| :------------------------------------------ | :----------------------------------------------------------: |
| void    projectsLoaded(Closure closure)     | 当settings.gradle包含的项目的project实例都被创建但是还未被解析时调用 |
| void   beforeProject(Closure closure)       | 当每一个Project实例被解析之前调用,注意是解析,这时Project已经被创建了 |
| `void` `afterProject(Closure closure)`      | 当每一个Project实例被解析之后调用,注意是解析,这时Project已经被创建了 |
| `void` `projectsEvaluated(Closure closure)` |              当所有的Project实例都被解析后调用               |
| `void` `buildStarted(Closure closure)`      |                       当构建开始前调用                       |
| `void` `buildFinished(Closure closure)`     |                       当构建结束后调用                       |
| `void` `beforeSettings(Closure<?> closure)` |            在setting.gradle 被加载和解析之前调用             |



[Interface TaskExecutionGraph](https://docs.gradle.org/current/javadoc/org/gradle/api/execution/TaskExecutionGraph.html)

------

| `void` `whenReady(Closure closure)`  | 当Tasks关系依赖图创建成功时 |
| :----------------------------------- | --------------------------- |
| `void` `beforeTask(Closure closure)` | 当Task执行前调用            |
| `void`  `afterTask(Closure closure)` | 当Task执行后调用            |

在多项目的Gradle执行流程中 上述方法的执行顺序如下:



![Gradle生命周期](/Users/wangkunkun/Pictures/Gradle生命周期.jpg)



**注意:**

- 每次Gradle在执行时 都会创建一个唯一的贯穿始终的 Gradle实例, 在Settings类(settings.gradle) ,Project类(build.gradle)中都可以通过getGradle()方法获取
- 如果要hook Gradle生命周期中的某个点,一定要在该点执行之前就要监听,否者无效

