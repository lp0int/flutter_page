# FlutterPage使用指南
## 关于FlutterPage的思考
在flutter里面，没有类似于传统Native开发的`Activity`，`ViewController`的概念，所有的内容都是`Widget`，这样的模式带来的弊端就是加大了我们对页面管理的能力

---
## 已有的功能支持
- 数据绑定  
    在FlutterPage里不在需要setState来更新数据，data和page已经绑定了，修改data.xxx就可以直接反映到View中。

- 生命周期
   1. `create()`页面创建时调用，等同于initState  
   2. `destroy()`页面销毁时调用，等同于dispose
   3. `onHide()`打开新的页面后，当前页面会调用
   4. `onResume()`打开的新页面关闭后会调用
   5. `didChangeAppLifecycleState(AppLifecycleState)`WidgetsBindingObserver的生命周期，[文档](https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html)

---
## onResume和onHide的实现思路
Flutter并没有[onResume](https://developer.android.com/guide/components/activities/activity-lifecycle?hl=zh-cn#onresume)这个生命周期，现在有的第三方实现很多也都是调用Navigator的回调或者是监听路由然后用Route#settings里的属性来实现。在实际使用的时候多少都会有限制或者不执行的问题。 
  
在FlutterPage中，维护一个长度最多为 **100** 的FlutterPage类型的堆栈，当新的FlutterPage被创建了，先调用栈顶的FlutterPage对象执行onHide方法，然后再把新的FlutterPage推入栈顶。当FlutterPage被销毁了，先移除栈顶的对象，在去获取新的栈顶对象，并执行其onResume()方法

---
## 使用

### Step 1
FlutterPage不对外暴露`setState()`方法，而是采用了[Provider](https://pub.dev/packages/provider)来进行状态同步，所以需要先实现一个继承自`ChangeNotifier`的类来管理需要动态改变的数据，并且在属性的set方法中调用`notifyListeners()`方法来通知页面改变。
```dart
class PageData extends ChangeNotifier {
  String _name = "initData";

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
```
之后就可以直接创建继承自FlutterPage的Page页面了


### Step 2

创建一个类，继承自FlutterPage，FlutterPage的泛型指定为第一步我们实现的类

```dart
class StatefulPageDemo extends FlutterPage<PageData> {
  @override
  PageData get data => new PageData();

  @override
  Widget build(BuildContext context, PageData data) {
    return Scaffold(
      appBar: AppBar(),
      body: RaisedButton(
          onPressed: () {
            data.name = data.name + "=";
          },
          child: Text(data.xxx),
      ),
    );
  }

  @override
  String get pageTag => "demo_page";
}
```

有三个必须要重写的内容，分别是
- data  
  页面需要绑定的数据对象，类型为指定的泛型

- build()  
  页面的生成方法，需要返回一个Widget对象，并且页面绑定的数据对象会作为参数传进来

- pageTage  
  页面的唯一标识
