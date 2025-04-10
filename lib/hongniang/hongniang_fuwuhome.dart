import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/agreement/agreement_info_page.dart';
import 'package:xinxiangqin/hongniang/hongniang_fuwulist_page.dart';
import 'package:xinxiangqin/hongniang/zixundialog.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import 'package:aliyun_face_plugin/aliyun_face_plugin.dart';

import '../mine/chat_page.dart'; // 阿里云实名认证

class HongniangFuwuhome extends StatefulWidget {
  const HongniangFuwuhome({super.key});

  @override
  State<StatefulWidget> createState() {
    return FaceVerifyState();
  }
}

class FaceVerifyState extends State<HongniangFuwuhome> {
  Map<String, dynamic> serviceDic = {};
  String morningBegin = '';
  String morningEnd = '';
  String afternoonBegin = '';
  String afternoonEnd = '';
  String qingshaonianmoshi = '';
  @override
  void initState() {
    super.initState();
    getUserInfo();

  }

  //获取用户信息
  void getUserInfo() async {
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          BotToast.closeAllLoading();
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          await sharedPreferences.setString('page', 'home');
          if (sharedPreferences.getString('qingshaonianmoshi')==null) {
            log('没有开启1');
            setState(() {
              qingshaonianmoshi='false';
            });
          }else{
            if (sharedPreferences.getString('qingshaonianmoshi')=='true'){
              log('开启了');
              setState(() {
                qingshaonianmoshi='true';
              });
            }else{
              log('没有开启2');
              setState(() {
                qingshaonianmoshi='false';
              });
            }

          }
          _getBaseInfo();

        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }

  ///获取基础配置
  void _getBaseInfo() async {
    MTEasyLoading.showLoading('加载中');
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      MTEasyLoading.dismiss();
      //
      if (data!=null){
        setState(() {
          serviceDic = data;
          morningBegin=timestampToDateString(serviceDic['morningBegin']);
          morningEnd= timestampToDateString(serviceDic['morningEnd']);
          afternoonBegin= timestampToDateString(serviceDic['afternoonBegin']);
          afternoonEnd= timestampToDateString(serviceDic['afternoonEnd']);
        });
      }

    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
      resizeToAvoidBottomInset: true,
    );
  }

  /// 自定义 主内容
  Widget _bodyView() {
    return GestureDetector(
      onTap: () {
        //点击空白区域，键盘收起
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // 主内容区
      // 主内容区
      child: Stack(
        children: [
          // 背景颜色
          Container(
            color: const Color.fromARGB(255, 243, 245, 249),
          ),

          // 顶部背景图片
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
             margin: EdgeInsets.all(0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/hongniang/homebeijing.png'), // 本地图片
                  fit: BoxFit.cover, // 设置图片填充模式
                ),
              ),
            ),
          ),

          // 主内容视图
          Positioned(
            child: Container(
              child: Column(
                children: [
                  Container(
                    // margin: EdgeInsets.only(left: 15,top: 10),
                    height: MediaQuery.of(context).padding.top + 24,
                    padding: EdgeInsets.only(left: 15, top: MediaQuery.of(context).padding.top),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0,right: 0,top: 0),
                    height: 441,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('images/hongniang/homecard.png'),fit: BoxFit.fill)
                    ),
                    child: Column(
                      children: [
                        //第一行文字
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 62.5,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 238, 238, 0.47),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              margin: EdgeInsets.only(left: 39.5,top: 145.5),
                              child: Text('#专业',style: TextStyle(color: Color(0xff999999),fontSize: 14),),
                            ),

                            SizedBox(width: 29,),

                            Container(
                              alignment: Alignment.center,
                              width: 62.5,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 238, 238, 0.47),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              margin: EdgeInsets.only(top: 145.5),
                              child: Text('#高效',style: TextStyle(color: Color(0xff999999),fontSize: 14),),
                            )
                          ],
                        ),

                        SizedBox(height: 16,),

                        //图片横线
                        Container(
                          margin: EdgeInsets.only(left: 42,right: 32.5),
                          height: 11.5,
                          // width: 300.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('images/hongniang/jiantouhengxian.png'),fit: BoxFit.fill)
                          ),
                        ),

                        SizedBox(height: 19,),

                        //
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 39.5,),
                            Image(image: AssetImage('images/hongniang/leftyinhao.png'),width: 14,height: 12,),
                            SizedBox(width: 11,),
                            Text('红娘1v1',style: TextStyle(color: Color(0xff333333),fontSize: 20,fontWeight: FontWeight.bold),)
                            
                          ],
                        ),
                        
                        SizedBox(height: 19,),
                        Container(
                          margin: EdgeInsets.only(left: 68,right: 52.5),
                          child: Text('红娘一对一我们会根据您的感情经历，择偶方向为您分配专属红娘，在您的寻爱旅程中为您指引方向。',
                            style: TextStyle(color: Color(0xff666666),fontWeight: FontWeight.normal,fontSize: 15),),
                        ),


                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top: 9,right: 52.5),
                         child: Image(image: AssetImage('images/hongniang/rightyinhao.png'),width: 14,height: 12,),
                        ),

                        SizedBox(height: 10,),

                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 39.5),
                          child: Text('找对象就现在，不拖延',
                            style: TextStyle(color: Color(0xff999999),fontWeight: FontWeight.w300,fontSize: 13),),
                        ),
                        SizedBox(height: 5,),

                        //图片横线
                        Container(
                          margin: EdgeInsets.only(left: 42,right: 32.5),
                          height: 11.5,
                          // width: 300.5,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/hongniang/jiantouhengxian.png'),fit: BoxFit.fill)
                          ),
                        ),


                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.all(0),

                    child: Row(
                      children: [
                        serviceDic['virtualDisplay']==1? GestureDetector(
                          onTap: (){
                            if(qingshaonianmoshi == 'true'){

                            }else{
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext ccontext) {
                                    return  HongniangFuwulistPage();
                                  }));
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width-30-35)/2,
                            margin: EdgeInsets.only(left: 15,right: 15),
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(26))
                            ),
                            child: Text('购买服务',style: TextStyle(color: Color(0xffFE7A24),fontWeight: FontWeight.bold,fontSize: 15),),
                          ),
                        ):Container(),

                       // SizedBox(width: 35,),
                       GestureDetector(
                         onTap: (){
                           log(morningBegin+morningEnd+afternoonBegin+afternoonEnd);
                           bool ischaoshi = isTimeBetween(morningBegin,morningEnd);
                           bool ischaoshi1 = isTimeBetween(afternoonBegin,afternoonEnd);
                           ischaoshi||ischaoshi1?gochat():showKefu();
                         },
                         child:  Container(
                           alignment: Alignment.center,
                           width: (MediaQuery.of(context).size.width-30-35)/2,
                           margin: EdgeInsets.only(right: 15,left: serviceDic['virtualDisplay']!=1?15:0),
                           height: 56,
                           decoration: BoxDecoration(
                               color: Color(0xffFE7A24),
                               borderRadius: BorderRadius.all(Radius.circular(26))
                           ),
                           child: Text('立即咨询',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                         ),
                       )
                      ],
                    ),
                  )
                ],
              ), // 你的内容
            ),
          ),
        ],
      ),
    );
  }

  gochat(){
    Map<String, dynamic> userInfoDic = {
      'id':'1',
      'nickname':'官方客服',
    };
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext ccontext) {
          return  ChatPage(userInfoDic: userInfoDic);
        }));
  }


  showKefu(){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return Zixundialog(
              morningBegin:serviceDic['morningBegin'].toString(),
            morningEnd: serviceDic['morningEnd'].toString(),
            afternoonBegin: serviceDic['afternoonBegin'].toString(),
            afternoonEnd: serviceDic['afternoonEnd'].toString(),
          );
        }
    );
  }
  //morningBegin+'-'+morningEnd
//afternoonBegin+'-'+afternoonEnd

  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('HH:mm');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }

  bool isTimeBetween(String start, String end) {
    final now = DateTime.now();
    TimeOfDay startTime = TimeOfDay(hour: int.parse(start.split(':').first), minute: int.parse(start.split(':').last));
    TimeOfDay endTime = TimeOfDay(hour: int.parse(end.split(':').first), minute: int.parse(end.split(':').last));

    // 将当前时间与开始和结束时间转换为TimeOfDay
    TimeOfDay nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    startTime.hour;
    if (nowTime.hour>startTime.hour&&nowTime.hour<endTime.hour){
      return true;
    }

    if (nowTime.hour<startTime.hour||nowTime.hour>endTime.hour){
      return false;
    }

    if (nowTime.hour==startTime.hour&&nowTime.minute<startTime.minute){
      return false;
    }

    if (nowTime.hour==startTime.hour&&nowTime.minute>=startTime.minute){
      return true;
    }

    if (nowTime.hour==endTime.hour&&nowTime.minute<endTime.minute){
      return true;
    }

    // 将TimeOfDay转换为毫秒比较
    // final nowMillis = nowTime.;
    // final startMillis = startTime.inMilliseconds;
    // final endMillis = endTime.inMilliseconds;

    // 如果当前时间在开始和结束时间之后，则返回false
    // if (nowMillis > endMillis || nowMillis < startMillis) {
    //   return false;
    // }
    return false;
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }

}
