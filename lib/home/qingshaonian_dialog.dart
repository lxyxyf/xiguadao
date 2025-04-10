import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
class QingshaonianDialog extends Dialog{

  final String title;
  final String content;
  final Function CancelCommit;
  final Function OntapCommit;
  final Function yinsizhengceClick;
  final Function fuwuxieyiClick;
  // 构造函数赋值
  const QingshaonianDialog({super.key, this.title="",this.content="",required this.OntapCommit,required this.CancelCommit,required this.yinsizhengceClick,required this.fuwuxieyiClick});

  @override
  Widget build(BuildContext context) {

    return Material(
      type:MaterialType.transparency,
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width-41.5-41,

            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(23))),
            margin: const EdgeInsets.only(left: 25,right: 26.5,),
            padding: EdgeInsets.only(bottom: 30),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 2,),
                Container(
                  width: MediaQuery.of(context).size.width-41.5-41-61.5-61.5,
                  height: 104.5*(MediaQuery.of(context).size.width-41.5-41-61.5-61.5)/169.5,
                  child: Image(image: AssetImage('images/home/qingshaoniantop.png')),
                ),
                const SizedBox(height: 11,),
                const Text('青少年模式',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
                const SizedBox(height: 13.5,),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 25,right: 26.5),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "为呵护未成年人健康成长,西瓜岛特别推出青少年模式，该模式下部分功能无法正常使用。请监护人主动选择，并设置监护密码。",
                            style: TextStyle(color: Color(0xff999999),fontWeight: FontWeight.normal,fontSize: 14)),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
               GestureDetector(
                 onTap: ()async{
                   OntapCommit();
                 },
                 child:  Container(
                   alignment: Alignment.center,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                       alignment: Alignment.center,
                       margin: const EdgeInsets.all(0),
                       child: const Text('开启青少年模式',textAlign: TextAlign.center,style: TextStyle(color: Color(0xffFE7A24),fontSize: 13,fontWeight: FontWeight.normal),)
                   ),
                       SizedBox(width: 7.5,),
                       Container(

                           height: 9.5,
                           width: 5,
                           child: Image(image: AssetImage('images/home/rightjiantou.png'))
                       ),
                     ],
                   ),
                 ),
               ),

                GestureDetector(
                  onTap: ()async{
                    CancelCommit();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40.5,
                    margin: EdgeInsets.only(top: 18,left: 37.5,right: 37),
                    decoration: BoxDecoration(
                        color: Color(0xffFE7A24),
                        borderRadius: BorderRadius.circular(20.25)
                    ),
                    child: Text('我知道了',style: TextStyle(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }


  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行 ；locale：当前手机语言；textScaleFactor：手机系统可以设置字体大小（默认1.0）
  double calculateTextHeight(
      String value,double fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
    value = filterText(value);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Locale('zh'),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        // textScaleFactor: textScaleFactor //字体缩放大小
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.height;
  }

  static String filterText(String text) {
    String tag = '<br>';
    while (text.contains('<br>')) {
      // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }
}