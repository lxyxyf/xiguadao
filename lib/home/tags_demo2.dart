
import 'package:flutter/material.dart';

class SelectTag2 extends StatefulWidget {
  // tag组件数据eg:['label':'测试','select':false]
  final List<dynamic> tagList;

  // 返回选中 tag 的下标
  final void Function(dynamic)? onSelect;

  // 是否单选，默认多选
  final bool isSingle;

  const SelectTag2(
      {Key? key, required this.tagList, this.onSelect, this.isSingle = false})
      : super(key: key);

  @override
  State<SelectTag2> createState() => _SelectTagState();
}

class _SelectTagState extends State<SelectTag2> {

  //计算Text的内容宽度
  double calculateTextWidth(String text, TextStyle style) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.topLeft, child: buildPackItem());
  }

  buildPackItem() {
    Widget itemContent;
    List<Widget> children = []; // 创建一个列表来存储子元素
    // 使用for循环遍历widget.tagList
    for (var i = 0; i < widget.tagList.length; i++) {
      var item = widget.tagList[i]; // 获取当前元素
      Widget childWidget = Container(
        padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            right:10
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // 使用当前元素的索引i作为pickPoint的第二个参数
            children: [pickPoint(item, i)], // 假设pickPoint的第二个参数从1开始
          ),
        ),
      );
      children.add(childWidget); // 将构建的子元素添加到列表中
    }
    // 使用Wrap来包裹所有子元素
    itemContent = Wrap(
      children: children,
    );
    return itemContent;
  }

  pickPoint(item, index) {
    //计算Text内容宽度
    double textWidth = calculateTextWidth(
        item['label'],
        const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 16,
        ));
    //计算屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        child: Column(
          children: [
            InkWell(

                child: Container(

                    constraints: const BoxConstraints(
                      minWidth: 90,
                      minHeight: 34,
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(226, 225, 223, 0.28),
        borderRadius: BorderRadius.all(Radius.circular(11.25)),
      ),

                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: textWidth > screenWidth - 45
                          ? screenWidth - 45+7.5
                          : textWidth+7.5,
                      child: Container(
                        child:
                        Container(
                          alignment: Alignment.center,


                          child: Text(item['label'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff333333),
                                fontSize: 14,
                              ),
                              softWrap: true),
                        ),
                      )
                    )))
          ],
        ));
  }
}

