
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/pages/login/login_character_new_page.dart';
import 'package:xinxiangqin/pages/login/login_grademarriage_page.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_character_page.dart';
import 'login_shimingrenzheng.dart';

class LoginSmokeDringkPage extends StatefulWidget {
  const LoginSmokeDringkPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginGradeMarriagePagePageState();
  }
}

class LoginGradeMarriagePagePageState extends State<LoginSmokeDringkPage> {
  final GlobalKey _incomeGlobalKey = GlobalKey();
  var smokeSelectRow = 0;
  var dringkSelectRow = 0;
  TextEditingController controller = TextEditingController();

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

  // // 中间分割线
  // Widget _selectionOverlayWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 0, right: 0),
  //     child: Column(
  //       children: [
  //         const Divider(
  //           height: 0.5,
  //           color: Color(0xffFE7A24),
  //         ),
  //         Expanded(child: Container()),
  //         const Divider(
  //           height: 0.5,
  //           color: Color(0xffFE7A24),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                      padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top+33),
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
                          height: 264.5,
                          width:MediaQuery.of(context).size.width-30 ,
                          margin:  const EdgeInsets.only(left: 15, right: 15, top: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5),
                            color: Colors.white
                          ),
                          child: 
                          Column(
                            children: [
                              SizedBox(height: 18,),
                              Text('是否抽烟',style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),

                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    smokeSelectRow=1;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 35),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: smokeSelectRow==1?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('偶尔抽',style: TextStyle(color: smokeSelectRow==1?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    smokeSelectRow=0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 21.5),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: smokeSelectRow==0?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('不抽烟',style: TextStyle(color: smokeSelectRow==0?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    smokeSelectRow=2;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 21.5),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: smokeSelectRow==2?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('会抽烟',style: TextStyle(color: smokeSelectRow==2?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                            ],
                          ),
                        
                        )),

                    Container(
                        child: Container(
                          height: 264.5,
                          margin:  const EdgeInsets.only(left: 15, right: 15, top: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Colors.white
                          ),
                          child:
                          Column(
                            children: [
                              SizedBox(height: 18,),
                              Text('是否喝酒',style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),

                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    dringkSelectRow=1;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 35),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: dringkSelectRow==1?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('偶尔喝',style: TextStyle(color: dringkSelectRow==1?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    dringkSelectRow=0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 21.5),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: dringkSelectRow==0?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('不喝酒',style: TextStyle(color: dringkSelectRow==0?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    dringkSelectRow=2;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width-50,
                                  margin: EdgeInsets.only(left: 10,right: 10,top: 21.5),
                                  height: 39.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.56),
                                      color: dringkSelectRow==2?Color(0xffFE7A24):Color(0xffF3F5F9)
                                  ),
                                  child:  Text('经常喝酒',style: TextStyle(color: dringkSelectRow==2?Colors.white:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.normal),),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              Container(
                child: GestureDetector(
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
      ),
    );
  }

  void _next() async {
    _saveUserInfo();
  }


  ///提交保存
  void _saveUserInfo() async {


    Map<String, dynamic> map = {};
    map['smoker'] = smokeSelectRow.toString();
    map['drink'] = dringkSelectRow.toString();
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginShimingrenzheng();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }



  @override
  void dispose() {
    BotToast.closeAllLoading();
    BotToast.cleanAll();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
