
## 使用

为了方便开发，在这一版本中移除了目前存在问题的**Data**这个概念，还原了`StatefulWidget+State`的写法。开发者的`Widget`需要继承`FlutterPage`，`State`需要继承`FlutterPageState`。  

保留了onResume和onHide，转移到了`FlutterPageState`中。`FlutterPage`内只需要实现`pageTage`

