import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FirstAgreeDialog extends Dialog{

  final String title;
  final String content;
  final Function CancelCommit;
  final Function OntapCommit;
  final Function yinsizhengceClick;
  final Function fuwuxieyiClick;
  // 构造函数赋值
  const FirstAgreeDialog({super.key, this.title="",this.content="",required this.OntapCommit,required this.CancelCommit,required this.yinsizhengceClick,required this.fuwuxieyiClick});

  @override
  Widget build(BuildContext context) {

    return Material(
      type:MaterialType.transparency,
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width-30-30,
            // height: calculateTextHeight('请您务必仔细阅读，充分理解服务协议和隐私政策各条款，包括但不限于为了向您提供即时通讯，'
            //     '内容分享等服务，我们需要收集您设备信息和个人信息，您可以在设置中查看，管理您的授权。您可阅读《隐私政策》和《服务协议》了解详细信息，如您同意，请点击同意接受我们的服务。',
            //     14, FontWeight.w500, MediaQuery.of(context).size.width-30-30-19.5-19.5, 100)+50+50+41,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(17.5))),
            margin: const EdgeInsets.only(left: 30,right: 30,),
            padding: EdgeInsets.only(bottom: 15),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 12,),
                const Text('服务协议和隐私政策',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                const SizedBox(height: 12,),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 19.5,right: 19.5),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "请您务必仔细阅读，充分理解服务协议和隐私政策各条款，包括但不限于为了向您提供即时通讯，内容分享等服务，"
                                "我们需要收集您设备信息和个人信息，您可以在设置中查看，管理您的授权。您可阅读",
                            style: TextStyle(color: Color(0xff666666),fontWeight: FontWeight.w500,fontSize: 14)),
                        TextSpan(
                            text: "《隐私政策》",
                            style: TextStyle(color: Color(0xffFE7A24)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                yinsizhengceClick();
                              }),
                        TextSpan(
                            text: "和",
                            style: TextStyle(color: Color(0xff666666))),
                        TextSpan(
                            text: "《服务协议》",
                            style: TextStyle(color: Color(0xffFE7A24)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                fuwuxieyiClick();
                              }),
                        TextSpan(
                            text: "了解详细信息，如您同意，请点击同意接受我们的服务。",
                            style: TextStyle(color: Color(0xff666666))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.5,),
                const Divider(thickness:0.5),
                Container(

                  height: 50,
                  child: Row(
                    children: [
                      Container(

                          height: 50,
                          width: (MediaQuery.of(context).size.width-30-30)/2-0.5,
                          child:  GestureDetector(
                            onTap: ()async{
                              CancelCommit();
                            },
                            child: Container(
                                // decoration: const BoxDecoration(
                                //   borderRadius:
                                //   BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                                //   color:  Colors.white,
                                // ),

                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(0),
                                child: const Text('暂不使用',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),)
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 4,bottom: 4.5),
                        color: const Color(0xffEEEEEE),
                        width: 1,
                        height: 30,

                      ),
                      Container(

                          height: 50,
                          width: (MediaQuery.of(context).size.width-30-30)/2-0.5,
                          child: GestureDetector(
                            onTap: ()async{
                              OntapCommit();
                            },
                            child: Container(

                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(0),
                                child: const Text('同意',style: TextStyle(color: Color(0xffFE7A24),fontSize: 14,fontWeight: FontWeight.w500),)),
                          )
                      ),
                    ],
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
        // textScaleFactor: textScaleFactor ,//字体缩放大小
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