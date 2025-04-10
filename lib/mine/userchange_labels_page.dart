import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import 'package:xinxiangqin/pages/login/tags_demo.dart';

import '../tools/event_tools.dart';
import '../widgets/yk_easy_loading_widget.dart';
class UserchangeLabelsPage extends StatefulWidget {
   List<String> oldTagList;
  UserchangeLabelsPage({super.key, required this.oldTagList});
  @override
  State<StatefulWidget> createState() {
    return UserchangeLabelsPageState();
  }
}

class UserchangeLabelsPageState extends State<UserchangeLabelsPage> {
  List tagList = [

  ];
  Map chooseItem = {};
  List chooseItemArray = [];


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
      Apis.memberLabel,
      queryParameters: {
        'auditStatus': '1',
        'appType': '1'
      },
      successCallback: (data) async {
        BotToast.closeAllLoading();

        if (data != null) {
          for (Map labelMap in data){
            if (widget.oldTagList.contains(labelMap['id'].toString())){
              labelMap['status'] = 0;
              chooseItemArray.add(labelMap);
            }else{
              labelMap['status'] = 1;
            }
          }
          setState(() {

            tagList = data;
            log('所有的标签是$data');
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_info_background.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                    padding:  const EdgeInsets.only(left: 25, right: 25, top: 21.5,bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                            padding: const EdgeInsets.only(top: 15.5),
                            child: const Text(
                              '我是一个...的人',
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
                              '选择3~5个标签，可以更精准的为您推荐用户',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                        ),


                        Container(
                            margin: const EdgeInsets.only(top: 30,bottom: 10),
                            height: MediaQuery.of(context).size.height/2,
                            child: SingleChildScrollView(
                              child: Container(child:
                              SelectTag(
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

                                  })),
                            )
                        ),

                      ],
                    ),
                  )),

              Container(
                  child: GestureDetector(
                    onTap: () {
                      _saveUserInfo();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      margin: const EdgeInsets.only(left: 25, right: 25,bottom: 50,top: 50),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xffFE7A24),
                          borderRadius: BorderRadius.all(Radius.circular(26))
                      ),

                      child: const Text(
                        textAlign: TextAlign.center,
                        '确定修改',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:14 ),
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
      tagsIdList.add(e['id']);
    }
    map['integers'] = tagsIdList;
    print(map);
    MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUsertags, data: tagsIdList, successCallback: (data) async {
      MTEasyLoading.dismiss();
      BotToast.showText(text: '保存成功');
      //保存成功
      eventTools.emit('changeUserInfo');
      Navigator.pop(context,chooseItemArray);
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  @override
  void dispose() {
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
