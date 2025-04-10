/// value : 110000
/// text : "北京"
/// children : [{"value":110100,"text":"北京市","children":[{"value":110101,"text":"东城区","children":[]},{"value":110102,"text":"西城区","children":[]},{"value":110105,"text":"朝阳区","children":[]},{"value":110106,"text":"丰台区","children":[]},{"value":110107,"text":"石景山区","children":[]},{"value":110108,"text":"海淀区","children":[]},{"value":110109,"text":"门头沟区","children":[]},{"value":110111,"text":"房山区","children":[]},{"value":110112,"text":"通州区","children":[]},{"value":110113,"text":"顺义区","children":[]},{"value":110114,"text":"昌平区","children":[]},{"value":110115,"text":"大兴区","children":[]},{"value":110116,"text":"怀柔区","children":[]},{"value":110117,"text":"平谷区","children":[]},{"value":110118,"text":"密云区","children":[]},{"value":110119,"text":"延庆区","children":[]}]}]

class City {
  City({
      num? value, 
      String? text, 
      List<Children>? children,}){
    _value = value;
    _text = text;
    _children = children;
}

  City.fromJson(dynamic json) {
    _value = json['value'];
    _text = json['text'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
  }
  num? _value;
  String? _text;
  List<Children>? _children;
City copyWith({  num? value,
  String? text,
  List<Children>? children,
}) => City(  value: value ?? _value,
  text: text ?? _text,
  children: children ?? _children,
);
  num? get value => _value;
  String? get text => _text;
  List<Children>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['text'] = _text;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// value : 110100
/// text : "北京市"
/// children : [{"value":110101,"text":"东城区","children":[]},{"value":110102,"text":"西城区","children":[]},{"value":110105,"text":"朝阳区","children":[]},{"value":110106,"text":"丰台区","children":[]},{"value":110107,"text":"石景山区","children":[]},{"value":110108,"text":"海淀区","children":[]},{"value":110109,"text":"门头沟区","children":[]},{"value":110111,"text":"房山区","children":[]},{"value":110112,"text":"通州区","children":[]},{"value":110113,"text":"顺义区","children":[]},{"value":110114,"text":"昌平区","children":[]},{"value":110115,"text":"大兴区","children":[]},{"value":110116,"text":"怀柔区","children":[]},{"value":110117,"text":"平谷区","children":[]},{"value":110118,"text":"密云区","children":[]},{"value":110119,"text":"延庆区","children":[]}]

class Children {
  Children({
      num? value, 
      String? text, 
      List<Children3>? children,}){
    _value = value;
    _text = text;
    _children = children;
}

  Children.fromJson(dynamic json) {
    _value = json['value'];
    _text = json['text'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Children3.fromJson(v));
      });
    }
  }
  num? _value;
  String? _text;
  List<Children3>? _children;
Children copyWith({  num? value,
  String? text,
  List<Children3>? children,
}) => Children(  value: value ?? _value,
  text: text ?? _text,
  children: children ?? _children,
);
  num? get value => _value;
  String? get text => _text;
  List<Children3>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['text'] = _text;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// value : 110101
/// text : "东城区"
/// children : []

class Children3 {
  Children3({
      num? value, 
      String? text, 
      }){
    _value = value;
    _text = text;
}

  Children3.fromJson(dynamic json) {
    _value = json['value'];
    _text = json['text'];
  }
  num? _value;
  String? _text;
  List<dynamic>? _children;
Children copyWith({  num? value,
  String? text,
}) => Children(  value: value ?? _value,
  text: text ?? _text,
);
  num? get value => _value;
  String? get text => _text;
  List<dynamic>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['text'] = _text;
    return map;
  }

}