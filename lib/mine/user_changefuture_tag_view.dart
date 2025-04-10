
import 'package:flutter/material.dart';

class UserChangefutureTagView extends StatefulWidget {
  // tag组件数据eg:['label':'测试','select':false]
  final List<dynamic> tagList;

  // 返回选中 tag 的下标
  final void Function(dynamic)? onSelect;

  // 是否单选，默认多选
  final bool isSingle;

  const UserChangefutureTagView(
      {Key? key, required this.tagList, this.onSelect, this.isSingle = false})
      : super(key: key);

  @override
  State<UserChangefutureTagView> createState() => _SelectTagState();
}

class _SelectTagState extends State<UserChangefutureTagView> {

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
        item['labelName'],
        TextStyle(
          fontWeight: item['state']==0 ? FontWeight.w500 : FontWeight.normal,
          color: item['state']==0 ? const Color(0xFFFE7A24) : const Color(0xFF333333),
          fontSize: 14,
        ));
    //计算屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.isSingle) {
                          List tagList = widget.tagList;
                          for (int i = 0; i < tagList.length; i++) {
                            if (i == index) {
                              tagList[i]['state'] = 0;
                            } else {
                              tagList[i]['state'] = 1;
                            }
                          }
                        } else {
                          if (item['state'] == 0){
                            item['state'] = 1;
                          }else{
                            item['state'] = 0;
                          }

                        }
                      });
                      if (widget.onSelect != null) {
                        widget.onSelect!(index);
                      }
                    },
                    child: Container(

                        constraints: const BoxConstraints(
                          minWidth: 90,
                          minHeight: 34,
                        ),
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.5),
                          border: Border.all(
                            color: item['state']==0?const Color(0xFFFE7A24):Colors.white, // 边框颜色
                            width: item['state']==0?1.0:0.0, // 边框宽度
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            width: textWidth > screenWidth - 50
                                ? screenWidth - 50+9
                                : textWidth+11,
                            child:Stack(
                              children: [
                                Positioned(
                                  child:
                                  item['state']==0?Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 0),
                                        child: Text(item['labelName'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: item['state']==0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: item['state']==0
                                                  ? const Color(0xFFFE7A24)
                                                  : const Color(0xFF333333),
                                              fontSize: 13,
                                            ),
                                            softWrap: true),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 9.5,left: 1.5),
                                        width: 7.5,
                                        height: 7.5,
                                        child: const Image(image: AssetImage('images/fourstar.png')),
                                      )
                                    ],
                                  ):Container(
                                    alignment: Alignment.center,

                                    child: Text(item['labelName'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: item['state']==0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: item['state']==0
                                              ? const Color(0xFFFE7A24)
                                              : const Color(0xFF333333),
                                          fontSize: 13,
                                        ),
                                        softWrap: true),
                                  ),
                                ),

                              ],
                            )
                        )))
              ],
            ),

            GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.isSingle) {
                      List tagList = widget.tagList;
                      for (int i = 0; i < tagList.length; i++) {
                        if (i == index) {
                          tagList[i]['state'] = 0;
                        } else {
                          tagList[i]['state'] = 1;
                        }
                      }
                    } else {
                      if (item['state'] == 0){
                        item['state'] = 1;
                      }else{
                        item['state'] = 0;
                      }

                    }
                  });
                  if (widget.onSelect != null) {
                    widget.onSelect!(index);
                  }
                },
                child: item['status']==0?const SizedBox(
                  width: 11,
                  height: 10.5,
                  child:Image(image: AssetImage('images/close_tag_image.png')),
                ):Container()
            )
          ],
        ));
  }
}

