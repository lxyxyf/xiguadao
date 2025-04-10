
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_heightweight_page.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class LoginBirthPage extends StatefulWidget {
  const LoginBirthPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginBirthPageState();
  }
}

class LoginBirthPageState extends State<LoginBirthPage> {
  DateTime _selectedDate = DateTime.now();

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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          value: 1/7,
                                        ),
                                      )
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 34.5),
                                    child: const Text(
                                      '您是哪一年出生的？',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF333333)
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 15.5),
                                    child: const Text(
                                      '请真实填写，以便为您推荐合适的异性',
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 40),
                                  alignment: Alignment.center,
                                  padding:  EdgeInsets.symmetric(horizontal: 38.5),
                                  child: DatePickerWidget(
                                    looping: false, // default is not looping
                                    firstDate: DateTime(1960, 1, 1),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime(2000,1,1),// DateTime(1994),
                                    dateFormat:
                                    // "MM-dd(E)",
                                    "yyyy/MM/dd",
                                    locale: DatePicker.localeFromString('en'),
                                    onChange: (DateTime newDate, _) {
                                      setState(() {
                                        _selectedDate = newDate;
                                      });
                                      print(_selectedDate);
                                    },
                                    pickerTheme:  DateTimePickerTheme(
                                        pickerHeight: 220,
                                        // pickerHeight:160,
                                        backgroundColor: Colors.transparent,
                                        itemTextStyle:
                                        TextStyle(color: Color(0xFF333333), fontSize: 14,fontWeight: FontWeight.bold),
                                        dividerColor: Color(0xFFFE7A24),
                                        // dividerHeight: 0.5,
                                        dividerThickness: 0.5
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )),
                    ],
                  )),


              Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _next();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 50,
                          margin: const EdgeInsets.only(left: 25, right: 25,bottom: 101,top: 124.5),

                          child: const Image(
                            image: AssetImage('images/login_next_button.png'),
                            width: 89.5,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // SizedBox(height: 100,)

                    ],
                  )),


            ],
          ),
        ),
      ),
    );
  }

  void _next() async {
    _saveUserInfo();
  }

  ///提交保存
  void _saveUserInfo() async {
    String nowdateStr = _selectedDate.toString();
    int length = 10;
    if (nowdateStr.length >= length) {
      nowdateStr = nowdateStr.substring(0, length); // 结果是 "Hello"
    } else {
      nowdateStr = nowdateStr; // 原样返回字符串
    }
    Map<String, dynamic> map = {};
    map['birthday'] = nowdateStr;
    print(map);
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功
      // eventTools.emit('changeUserInfo');
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginHeightWeightPage();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  @override
  void dispose() {
    BotToast.cleanAll();
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
