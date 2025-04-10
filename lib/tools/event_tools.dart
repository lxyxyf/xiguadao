//全局事件单例(用法类似于通知)

//订阅者回调签名
typedef void EventCallback(arg);

class EventTools {
  //私有构造函数
  EventTools._internal();
  //用来缓存全局唯一的首页
  static var homePage;

  //保存单例
  static final EventTools _singleton = EventTools._internal();

  //工厂构造函数
  factory EventTools() => _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = <Object, List<EventCallback>>{};

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null) return;
    // ignore: deprecated_member_use
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName] ??= [];
    _emap[eventName]?.add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap.remove(eventName);
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  //注意:arg是可选的位置参数
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

//定义一个top-level变量，页面引入该文件后可以直接使用bus
var eventTools = EventTools();
