import 'package:flutter/material.dart';

/// text : "销售"
/// value : "销售"
/// children : [{"text":"销售总监","value":"销售总监"},{"text":"销售经理","value":"销售经理"},{"text":"销售主管","value":"销售主管"},{"text":"销售专员","value":"销售专员"},{"text":"渠道/分销管理","value":"渠道/分销管理"},{"text":"渠道/分销专员","value":"渠道/分销专员"},{"text":"经销商","value":"经销商"},{"text":"客户经理","value":"客户经理"},{"text":"客户代表","value":"客户代表"},{"text":"销售","value":"销售"}]

class Career with ChangeNotifier{
  Career({
      String? text, 
      String? value, 
      List<Children>? children,}){
    _text = text;
    _value = value;
    _children = children;
}

  Career.fromJson(dynamic json) {
    _text = json['text'];
    _value = json['value'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
  }
  String? _text;
  String? _value;
  List<Children>? _children;

  set children(List<Children>? value) {
    _children = value;
  }

  Career copyWith({  String? text,
  String? value,
  List<Children>? children,
}) => Career(  text: text ?? _text,
  value: value ?? _value,
  children: children ?? _children,
);
  String? get text => _text;
  String? get value => _value;
  List<Children>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['value'] = _value;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// text : "销售总监"
/// value : "销售总监"

class Children {
  Children({
      String? text, 
      String? value,}){
    _text = text;
    _value = value;
}

  Children.fromJson(dynamic json) {
    _text = json['text'];
    _value = json['value'];
  }
  String? _text;
  String? _value;
Children copyWith({  String? text,
  String? value,
}) => Children(  text: text ?? _text,
  value: value ?? _value,
);
  String? get text => _text;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['value'] = _value;
    return map;
  }

}