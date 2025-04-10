
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/main_page.dart';
import 'package:xinxiangqin/pages/login/login_future_page.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'future_tags_view.dart';
import 'login_grademarriage_page.dart';
import 'login_shimingrenzheng.dart';

class LoginFutureNewPage extends StatefulWidget {
  const LoginFutureNewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginCharacterPageState();
  }
}

class LoginCharacterPageState extends State<LoginFutureNewPage> {
  final DateTime _selectedDate = DateTime.now();
  List tagList = [

  ];
  Map chooseItem = {};
  List chooseItemArray = [];
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();


  @override
  void initState() {
    super.initState();
    getMemberLabel();
  }

  //首先获取用户标签
  getMemberLabel() async {
    BotToast.showLoading();

    NetWorkService service = await NetWorkService().init();
    service.get(
      Apis.getExpectedLabelList,
      successCallback: (data) async {
        BotToast.closeAllLoading();

        if (data != null) {
          log(data.toString());
          setState(() {
            tagList = data;
          });
        }
      },
      failedCallback: (data) {
        BotToast.closeAllLoading();
      },
    );
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
        controller: _scrollController,
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
                            return const LoginFuturePage();
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top+33),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     child: const Icon(Icons.arrow_back_ios),
                    //   ),
                    // ),
                    //顶部内容
                    Container(
                        child: Container(
                          padding:  const EdgeInsets.only(left: 25, right: 25, top: 21.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(4), // 设置圆角的半径
                              //   child: Container(
                              //     //进度条
                              //       child: const SizedBox(
                              //         height: 8,
                              //         child: LinearProgressIndicator(
                              //           backgroundColor: Colors.white,
                              //           valueColor: AlwaysStoppedAnimation(Color(0xFFFE7A24)),
                              //           value: 7/7,
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
                              // Container(
                              //     padding: const EdgeInsets.only(top: 18.5),
                              //     child: const Text(
                              //       '请真实填写，以便为您推荐合适的异性',
                              //       style: TextStyle(
                              //         color: Color(0xFF666666),
                              //         fontSize: 13,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     )
                              // ),



                              Container(
                                  margin: const EdgeInsets.only(top: 30,bottom: 20),
                                  height: MediaQuery.of(context).size.height - 88.5 - 330,
                                  child: Scrollbar(
                                    controller: _scrollController1,
                                    thumbVisibility: true,
                                    // alwaysVisible: true, // 设置滚动条一直可见
                                    child: SingleChildScrollView(
                                      controller: _scrollController1,
                                      child: Container(

                                        child: FutureTagsView(
                                            tagList: tagList,
                                            isSingle: false,
                                            onSelect: (selectedIndexes){
                                              chooseItem = tagList[selectedIndexes];


                                              if (chooseItemArray.contains(chooseItem)){
                                                chooseItemArray.remove(chooseItem);
                                                print(chooseItemArray);
                                              }else{
                                                chooseItemArray.add(chooseItem);
                                                print(chooseItemArray);
                                              }

                                            }),
                                      ),
                                    ),
                                  )

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
                    margin: const EdgeInsets.only(left: 25, right: 25,bottom:50,top: 50),


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

  ///提交保存
  void _saveUserInfo() async {

    Map<String, dynamic> map = {};
    List tagsIdList = [];
    for (Map e in chooseItemArray){
      tagsIdList.add(e['id'].toString());
    }
    map['labelIds'] = tagsIdList;
    log('另一半的期望标签传值'+map.toString());
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createUserExpectedLabel, data: tagsIdList, successCallback: (data) async {
      MTEasyLoading.dismiss();




      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginFuturePage();
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
