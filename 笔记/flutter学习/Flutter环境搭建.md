adb预览:scrcpy

flutter 环境搭建官方地址:https://flutter.cn/docs/get-started/install/macos

Android studio下载地址:https://developer.android.google.cn/studio

flutter sdk版本下载地址:https://flutter.cn/docs/development/tools/sdk/releases?tab=macos 

jdk下载地址: https://www.oracle.com/cn/java/technologies/downloads/#jdk19-mac 

### 1、JDK

查看java版本: java -version

jdk下载地址  https://www.oracle.com/cn/java/technologies/downloads/#jdk19-mac 

配置jdk

终端:open -e ~/.zshrc

配置:

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_291.jdk/Contents/Home
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/bin:$PATH:.
export JAVA_HOME
export CLASSPATH
export PATH

保存:source ~/.zshrc

2,Android studio配置 sdk

​	gradle 环境配置(一般不需要 会自动下载)

​	GRADE_HOME="/Users/nixinsheng/.gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1/bin"

export GRADE_HOME

export PATH="${PATH}:/Users/nixinsheng/.gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1/bin"



3下载插件 这个需要

2. 安装Flutter和Dart插件
需要安装Flutter和Dart插件两个插件。

打开插件首选项：Preferences>Plugins
选择 Browse repositories…, 选择 Flutter 插件并点击 install。
这时Dart插件也会附带被安装上。

3. 重启Android Studio 使插件生效





 这个需要

open .bash_profile  

FLUTTER_HOME="/Users/wangkunkun/app/flutter"
export PATH="$FLUTTER_HOME/current/bin:$PATH"
export PUB_HOSTED_URL=https://pub.flutter-io.cn 
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

source ~/.bash_profile



运行 

​	flutter doctor

查看是否配置完成 根据错误提示进行再次配置



Flutter 官方demo

https://github.com/flutter/samples