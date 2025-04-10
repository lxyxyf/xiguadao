import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Zixundialog extends Dialog{

  final String title;
  final String content;
  final String morningBegin;
  final String morningEnd;
  final String afternoonBegin;
  final String afternoonEnd;
  // 构造函数赋值
  const Zixundialog({super.key, this.title="",this.content="", required this.morningBegin,required this.morningEnd,required this.afternoonBegin,required this.afternoonEnd});


  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('HH:mm');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }
  @override
  Widget build(BuildContext context) {

    return Material(
        type:MaterialType.transparency,
        child:Center(
          child:
          Container(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16,right: 63),
                  width: 296,
                  height: 256.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('images/hongniang/kefubeijing.png'),fit: BoxFit.fill)
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 48,),
                      Image(image: AssetImage('images/hongniang/kefuwenzi.png'),width: 160,height: 50,),
                      SizedBox(height: 7.5,),
                      Container(
                        width: 218,
                        height: 84,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 3,),
                            Text('人工服务时间',style: TextStyle(color: Color(0xff666666),fontSize: 15),),
                            SizedBox(height: 5,),
                            Text('上午 '+timestampToDateString(int.parse(morningBegin))+'-'+timestampToDateString(int.parse(morningEnd)),style: TextStyle(color: Color(0xff666666),fontSize: 15),),
                            SizedBox(height: 5,),
                            Text('下午 '+timestampToDateString(int.parse(afternoonBegin))+'-'+timestampToDateString(int.parse(afternoonEnd)),style: TextStyle(color: Color(0xff666666),fontSize: 15),)
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 218,
                          height: 40.5,
                          decoration: BoxDecoration(
                            color: Color(0xffFE7A24),
                            borderRadius: BorderRadius.all(Radius.circular(20.25))
                          ),
                          child: Text('我知道了',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 17.5,),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image(image: AssetImage('images/hongniang/kefuclose.png'),width: 26,height: 26,),
                )
              ],
            ),
          )
        )
    );
  }
}