
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/pages/login/login_grademarriage_page.dart';
import 'package:xinxiangqin/pages/login/login_shimingrenzheng.dart';
import '../../main_page.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_character_page.dart';

class LoginFuturePage extends StatefulWidget {
  const LoginFuturePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginGradeMarriagePagePageState();
  }
}

class LoginGradeMarriagePagePageState extends State<LoginFuturePage> {
  TextEditingController controller = TextEditingController();

  String futureStr = '';


  @override
  void initState() {
    super.initState();
  }

  //监听textfield内容变化
  void _handleTextChanged(String text) {
    futureStr = text;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top+33),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            //直接跳过进入下一页实名
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const LoginGradeMarriagePage();
                                }));
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const MainPage(),
                            //   ),
                            //       (route) => false,
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15,top: MediaQuery.of(context).padding.top+33),
                            child: Text('跳过',style: TextStyle(
                                color: Color(0xff666666),fontWeight: FontWeight.w500,fontSize: 15
                            ),textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                    //顶部内容
                    Container(
                        child: Container(
                          padding:  const EdgeInsets.only(left: 25, right: 25, top: 21.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(2.25), // 设置圆角的半径
                              //   child: Container(
                              //     //进度条
                              //       child: const SizedBox(
                              //         height: 4.5,
                              //         child: LinearProgressIndicator(
                              //           backgroundColor: Colors.white,
                              //           valueColor: AlwaysStoppedAnimation(Color(0xFFFE7A24)),
                              //           value: 5/6,
                              //         ),
                              //       )
                              //   ),
                              // ),
                              Container(
                                  padding: const EdgeInsets.only(top: 34.5),
                                  child: const Text(
                                    '对另一半的期望？',
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
                                    '请真实填写，以便为您推荐合适的异性',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                              ),


                              Container(

                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                // BorderRadius.only(
                                //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(top: 26 ),
                                height: 192,

                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: controller,
                                  onChanged: _handleTextChanged,
                                  // scrollPadding: EdgeInsets.zero,
                                  // autofocus: true,
                                  textAlignVertical:TextAlignVertical.center,
                                  maxLength: 300,
                                  maxLines: 6,
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff333333)),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      hintStyle: TextStyle(fontSize: 12, color: Color(0xff999999)),

                                      hintText: '请输入对另一半的期望',
                                      border: InputBorder.none),
                                ),
                              ),


                            ],
                          ),
                        )),
                  ],
                ),
              ),

              Container(
                  child:GestureDetector(
                    onTap: () {
                      _next();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      margin: const EdgeInsets.only(left: 25, right: 25,bottom: 101,top: 94),


                      child: const Image(
                        image: AssetImage('images/login_next_button.png'),
                        width: 89.5,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),)
            ],
          ),
        ),
      )
    );
  }

  void _next() async {
    _saveUserInfo();

  }


  ///提交保存
  void _saveUserInfo() async {

    if (futureStr.isEmpty == true){
      BotToast.showText(text: '请填写对另一半的期望');
      return;
    }else{

    }
    Map<String, dynamic> map = {};
    map['partnerWish'] = futureStr;
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginGradeMarriagePage();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }



  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    BotToast.cleanAll();
    super.dispose();
  }
}
