import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_income_page.dart';
import 'custom_box.dart';

class LoginHeightWeightPage extends StatefulWidget {
  const LoginHeightWeightPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginHeightWeightPageState();
  }
}

class LoginHeightWeightPageState extends State<LoginHeightWeightPage> {
  final DateTime _selectedDate = DateTime.now();
  final int _totalCount = 230;
  final int _initValue = 160;
  int _currentValue = 160;

  final int _totalCount1 = 150;
  final int _initValue1 = 75;
  int _currentValue1 = 75;

  ///是否同意用户协议和隐私政策
  bool isAgree = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _createView(),
    );
  }

  Widget _createView() {
    return GestureDetector(
      onTap: () {
        //点击空白区域，键盘收起
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_info_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top+15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    //顶部内容
                    Container(
                        child: Container(
                          padding:  const EdgeInsets.only(left: 25, right: 25, top: 21.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4), // 设置圆角的半径
                                child: Container(
                                  //进度条
                                    child: SizedBox(
                                      height: 8,
                                      child: LinearProgressIndicator(
                                        // borderRadius: BorderRadius.circular(4),
                                        backgroundColor: Colors.white,
                                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFE7A24)),
                                        value: 2/7,
                                      ),
                                    )
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 34.5),
                                  child: const Text(
                                    '您的身高体重是？',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333)
                                    ),
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 18.5),
                                  child: const Text(
                                    '资料越全，为您推荐的异性越精准',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                              ),

                              Container(
                                  padding: const EdgeInsets.only(top: 29.5),
                                  child: const Text(
                                    '身高（cm）',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333)
                                    ),
                                  )
                              ),


                              // RulerWidget(onChanged: (double dx){
                              //   print("当前刻度值是${dx / 5}");
                              // }, style: TextStyle()),
                              //



                              CustomBox(
                                title: '',
                                valueText: Text(
                                  _currentValue.toString(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 2.0,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                wheelSlider: WheelSlider(
                                  totalCount: _totalCount,
                                  initValue: _initValue,
                                  onValueChanged: (val) {
                                    setState(() {
                                      _currentValue = val;
                                    });
                                  },
                                  isVibrate:false,
                                  pointerColor: const Color(0xFFFE7A24),
                                  lineColor: Color(0xFF999999),
                                ),

                              ),

                              Container(
                                  padding: const EdgeInsets.only(top: 29.5),
                                  child: const Text(
                                    '体重（kg）',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333)
                                    ),
                                  )
                              ),
                              CustomBox(
                                title: '',
                                valueText: Text(
                                  _currentValue1.toString(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 2.0,
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                wheelSlider: WheelSlider(
                                  totalCount: _totalCount1,
                                  initValue: _initValue1,
                                  onValueChanged: (val) {
                                    setState(() {
                                      _currentValue1 = val;
                                    });
                                  },
                                  isVibrate:false,
                                  pointerColor: const Color(0xFFFE7A24),
                                  lineColor: Color(0xFF999999),
                                ),

                              ),



                              const SizedBox(

                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [

                                  ],
                                ),
                              ),

                            ],
                          ),
                        )),
                  ],
                ),
              ),

              Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _next();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 50,
                          margin: const EdgeInsets.only(left: 25, right: 25,bottom: 110.5,top: 94),


                          child: const Image(
                            image: AssetImage('images/login_next_button.png'),
                            width: 89.5,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),



                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }


  ///提交保存
  void _saveUserInfo() async {
    // String nowdateStr = _selectedDate.toString();
    // int length = 10;
    // if (nowdateStr.length >= length) {
    //   nowdateStr = nowdateStr.substring(0, length); // 结果是 "Hello"
    // } else {
    //   nowdateStr = nowdateStr; // 原样返回字符串
    // }
    Map<String, dynamic> map = {};
    map['height'] = double.parse(_currentValue.toString());
    map['weight'] = double.parse(_currentValue1.toString());
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      BotToast.showText(text: '保存成功');
      //保存成功
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginIncomePage();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  void _next() async {
    _saveUserInfo();
  }


  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    BotToast.cleanAll();
    super.dispose();
  }
}
