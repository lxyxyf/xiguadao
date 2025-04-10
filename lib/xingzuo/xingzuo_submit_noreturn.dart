// import 'package:bruno/bruno.dart';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_tijiao_luyin.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'
as iOSDatePicker;

class XingzuoSubmitNoreturn extends StatefulWidget {
  const XingzuoSubmitNoreturn({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<XingzuoSubmitNoreturn> {
  Map<String, dynamic> userDic = {};
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  String birthYear = '';
  String birthDay = '';
  String birthTime = '';
  String birthPlaceShow = '';
  String livePlaceShow = '';

  List audiourlList = [];

  String birthPlace = '';
  String livePlace = '';
  // 声明实例
  CityPickerUtil cityPickerUtils = CityPickers.utils();

  @override
  void initState() {
    super.initState();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();
    _getData();
  }

  ///获取数据
  void _getData() async {
    Map<String,dynamic> queryParameters = {};
    // queryParameters = {
    //   'pageNo': '1',
    //   'pageSize': '20',
    // };
    SharedPreferences share = await SharedPreferences.getInstance();
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getConstellationTest, queryParameters: queryParameters, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印录音data'+data.toString());
      // log('打印录音列表'+data['speechRespVOList'].toString());
      if (data!= null) {
        setState(() {
          birthYear = data['birthday'].toString();
          birthDay = data['lunarBirthday'].toString();
          birthTime = data['birthTime'].toString();
          birthPlaceShow = data['areaId'].toString();
          livePlaceShow = data['areaId'].toString();
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Color(0xFFFFFCB2),
      Color(0xFFF9F8F9),]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0,size.width,size.height));
    return Scaffold(
      // backgroundColor:  Color.fromRGBO(255, 255, 255, 0),
      body:  Container(
          margin: const EdgeInsets.only(bottom: 0,left: 0,right: 0),
          // color:  Color.fromRGBO(255, 255, 255, 0),
          //  padding: EdgeInsets.only(bottom: 0),
          //   height: screenSize.height,
          //   width: screenSize.width,
          // decoration: BoxDecoration(
          //   // color: Colors.red,
          //     image: DecorationImage(
          //       image: AssetImage('images/xingzuo/allbeijing.png'),
          //       fit: BoxFit.cover,
          //     )
          // ),
          child: SingleChildScrollView(
              child: Container(
                  child:  Container(
                      height: 880,
                      width: screenSize.width,
                      // decoration: BoxDecoration(
                      //   // color: Colors.red,
                      //     image: DecorationImage(
                      //       image: AssetImage('images/xingzuo/allbeijing.png'),
                      //       fit: BoxFit.cover,
                      //     )
                      // ),

                      child: Stack(
                          children: [
                            Positioned(

                                left: 0,top: 0,right: 0,bottom: 0,
                                child: Container(
                                  height: screenSize.height,
                                  width: screenSize.width,
                                  child: Image(image: AssetImage('images/xingzuo/allbeijing.png'),
                                    width: screenSize.width,height: screenSize.height,fit: BoxFit.cover,),
                                )
                            ),

                            Container(
                                width: screenSize.width,
                                // height: 180+MediaQuery.of(context).padding.top,
                                margin: EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                                        // color: Colors.white,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.arrow_back_ios,color: Colors.white,),

                                            const Text(
                                              '星座测算',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 18.5,top: 35.5),
                                      height: 118.5,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                          image: DecorationImage(
                                            image: AssetImage('images/xingzuo/title.png'),
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    )

                                    //

                                  ],
                                )
                            ),

                            Positioned(
                                right: 0,
                                height: 50,
                                left: 0,top: MediaQuery.of(context).padding.top+140,
                                child:Container(
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/dongxiangstar.png'),width: 199.5,fit: BoxFit.fitWidth,
                                  ),
                                )
                            ),

                            Positioned(
                                right: 0,
                                height: 50,
                                left: 0,top: MediaQuery.of(context).padding.top+140,
                                child:Container(
                                    alignment: Alignment.center,
                                    child: Text('快速解析你的星座动向',style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                                )
                            ),

                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+140+50,
                                child:Container(
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/centerbeijing.png'),fit: BoxFit.fill,
                                  ),
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+60,
                                child:Container(
                                    width: size.width,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image(image: AssetImage('images/xingzuo/leftstar.png'),width: 67.5,
                                        ),

                                        SizedBox(width: 9.5,),
                                        Image(image: AssetImage('images/xingzuo/wanshanxinxi.png'),width: 78.5,fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 9.5,),
                                        Image(image: AssetImage('images/xingzuo/rightstar.png'),width: 67.5,
                                        ),
                                      ],
                                    )
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+40,
                                child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                  ),
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+50,
                                child:Container(
                                    width: size.width,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          // onTap: (){
                                          //   _showDatePickerForDate(context);
                                          // },
                                          child:Text(birthYear,
                                            style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                        ),
                                        SizedBox(width: 22.5,),
                                        GestureDetector(
                                          // onTap: (){
                                          //   _showDatePickerForDate(context);
                                          // },
                                          child: Text(birthDay,
                                              style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                                        ),
                                        SizedBox(width: 29.5,),
                                        GestureDetector(
                                          // onTap: (){
                                          //   _showDatePickerForTime(context);
                                          // },
                                          child:Text(birthTime,style:
                                          TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                                        )
                                      ],
                                    )
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+80,
                                child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                  ),
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+100,
                                child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                  ),
                                )
                            ),

                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+110,
                                child:Container(
                                    width: size.width,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            _showAddressPickerBirth();
                                          },
                                          child:  Text(birthPlaceShow,style:
                                          TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                        ),
                                        // SizedBox(width: 15,),
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     _showAddressPickerLive();
                                        //   },
                                        //   child: Text(livePlaceShow==''?'现居地':livePlaceShow,style:
                                        //   TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                                        // )
                                      ],
                                    )
                                )
                            ),


                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+110+32,
                                child:Container(
                                    width: size.width,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     _showAddressPickerBirth();
                                        //   },
                                        //   child:  Text(birthPlaceShow==''?'出生地':birthPlaceShow,style:
                                        //   TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                        // ),
                                        // SizedBox(width: 15,),
                                        GestureDetector(
                                          onTap: (){
                                            _showAddressPickerLive();
                                          },
                                          child: Text(livePlaceShow,style:
                                          TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                                        )
                                      ],
                                    )
                                )
                            ),

                            Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+140+32,
                                child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                  ),
                                )
                            ),


                         Positioned(
                                right: 0,
                                left: 0,top: MediaQuery.of(context).padding.top+155+70+140+94+50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(image: AssetImage('images/xingzuo/noresulticon.png'),width: 28,height: 28,),
                                    SizedBox(width: 10,),
                                    Image(image: AssetImage('images/xingzuo/noresulttext.png'),width: 87,height: 21,),

                                  ],
                                )),



                          ]
                      ))
              )
          )
      ),

    );
  }

  //展示生日弹窗
  _showDatePickerForDate(BuildContext context) {
    iOSDatePicker.DatePicker.showDatePicker(
      context,
      pickerTheme: iOSDatePicker.DateTimePickerTheme(
        confirm: Container(
            padding: const EdgeInsets.only(right: 0),
            child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
        ),
        cancel: Container(
            padding: const EdgeInsets.only(left: 0),
            child: const Text('选择生日',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold))
        ),
        cancelTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        confirmTextStyle: const TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),
      ),
      pickerMode: iOSDatePicker.DateTimePickerMode.date,
      minDateTime: DateTime(1875, 1, 01),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime(1990, 1, 01),
      dateFormat: "yyyy/MM/dd",
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {

        String dateSelect = "$dateTime";
        print("选择阳历生日"+dateSelect.substring(5, 10));
        int length = 10;
        // if (dateSelect.length >= length) {
        //   dateSelect = dateSelect.substring(0, length);
        //   birthDay= dateSelect;// 结果是 "Hello"
        // } else {
        //   dateSelect = dateSelect; // 原样返回字符串
        //   birthDay= dateSelect;
        // }



        setState(() {
          birthDay= dateSelect.substring(5, 10);
          birthYear = dateSelect.substring(0, 4);

        });
      },

      onCancel: () {},
      onClose: () {},
      onChange: (datetime, selectedIndex) {},
    );
  }


  //展示生辰弹窗
  _showDatePickerForTime(BuildContext context) {
    iOSDatePicker.DatePicker.showDatePicker(
      context,
      pickerTheme: iOSDatePicker.DateTimePickerTheme(
        confirm: Container(
            padding: const EdgeInsets.only(right: 0),
            child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
        ),
        cancel: Container(
            padding: const EdgeInsets.only(left: 0),
            child: const Text('出生时辰',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold))
        ),
        cancelTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        confirmTextStyle: const TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),
      ),
      pickerMode: iOSDatePicker.DateTimePickerMode.time,
      minDateTime: DateTime(1875, 1, 01 ,0 , 0, 0),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime(1990, 1, 01 ,0 ,0 ,0),
      dateFormat: "HH/mm",
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {

        String dateSelect = "$dateTime";
        print('选择'+dateSelect.substring(11, 16));
        int length = 5;
        // if (dateSelect.length >= length) {
        //   dateSelect = dateSelect.substring(0, length);
        //   birthTime= dateSelect;// 结果是 "Hello"
        // } else {
        //   dateSelect = dateSelect; // 原样返回字符串
        //   birthDay= dateSelect;
        // }



        setState(() {
          birthTime = dateSelect.substring(11, 16);

        });
      },

      onCancel: () {},
      onClose: () {},
      onChange: (datetime, selectedIndex) {},
    );
  }



  //地址
  Future<void> _showAddressPickerBirth() async {
    Result? result = await CityPickers.showCityPicker(
        context: context,
        height: 300,
        theme: ThemeData(dialogBackgroundColor: Colors.white,scaffoldBackgroundColor: Colors.white),
        confirmWidget: Container(
          child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),),
        ),
        cancelWidget: Container(
          child: const Text('出生地',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
        )
    );
    if (result != null) {
      setState(() {
        birthPlaceShow = '${result.provinceName},${result.cityName},${result.areaName}';
        birthPlace = '${result.provinceName},${result.cityName},${result.areaName}';
      });
    }
  }

  //居住地址
  Future<void> _showAddressPickerLive() async {
    Result? result = await CityPickers.showCityPicker(
        context: context,
        height: 300,
        theme: ThemeData(dialogBackgroundColor: Colors.white,scaffoldBackgroundColor: Colors.white),
        confirmWidget: Container(
          child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),),
        ),
        cancelWidget: Container(
          child: const Text('居住地',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
        )
    );
    if (result != null) {
      setState(() {
        livePlaceShow = '${result.cityName}';
        livePlace = '${result.provinceName},${result.cityName},${result.areaName}';
      });
    }
  }


  //提交星座测试
  submitTest()async{
    if (birthYear==''){
      BotToast.showText(text: '请选择出生年份');
      return;
    }
    if (birthDay==''){
      BotToast.showText(text: '请选择阳历生日');
      return;
    }
    if (birthTime==''){
      BotToast.showText(text: '请选择出生时辰');
      return;
    }
    if (birthPlace==''){
      BotToast.showText(text: '请选择出生地');
      return;
    }
    if (livePlace==''){
      BotToast.showText(text: '请选择现居地');
      return;
    }
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createConstellationTest, data: {
      'birthday': birthYear,
      'lunarBirthday':birthDay,
      'birthTime':birthTime,
      'areaId':birthPlace,
      'nativePlace':livePlace
    }, successCallback: (data) async {

      EasyLoading.dismiss();
      BotToast.showText(text: '提交成功，请耐心等待');
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }


  void getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          print(data);
          setState(() {
            userDic = data;
          });
        }, failedCallback: (data) {});
  }

  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      getUserInfo();
    });
  }


  ImageProvider getImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(
      imageUrl,
    );
  }

  @override
  void dispose() {
    eventTools.off('changeUserInfo');
    super.dispose();
  }
}
