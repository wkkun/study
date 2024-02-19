gradle强制更新快照版本



```
//强制更新快照 命令 ./gradlew build --refresh-dependencies
```





configurations.all {  // check for updates every build  resolutionStrategy.cacheChangingModulesFor 0, 'seconds' }