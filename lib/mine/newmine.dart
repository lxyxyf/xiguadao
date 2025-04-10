import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/hongniang/hongniang_fuwuhome.dart';
import 'package:xinxiangqin/hongniang/hongniang_fuwulist_page.dart';
import 'package:xinxiangqin/hongniang/hongniang_fuwudetail.dart';
import 'package:xinxiangqin/hongniang/mine_qianxian_page.dart';
import 'package:xinxiangqin/mine/like_receive_page.dart';
import 'package:xinxiangqin/mine/comment_list_page.dart';
import 'package:xinxiangqin/mine/mine_dongtai_list.dart';
import 'package:xinxiangqin/mine/mine_meseeother_listpage.dart';
import 'package:xinxiangqin/mine/mine_order_list.dart';
import 'package:xinxiangqin/mine/mine_otherseeme_listpage.dart';
import 'package:xinxiangqin/mine/mine_wantknowme_listpage.dart';
import 'package:xinxiangqin/mine/mine_wantknowother_listpage.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/mine/share_home_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/pages/login/login_future_new_page.dart';
import 'package:xinxiangqin/pages/login/login_shimingrenzheng.dart';
import 'package:xinxiangqin/pages/login/login_smoke_dringk_page.dart';
import 'package:xinxiangqin/shequ/post_detail_page.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/utils/utils.dart';
import 'package:xinxiangqin/vipcenter/vipcenter_home.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_home_page.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_submit_noreturn.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_submit_return.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_task_list.dart';
import '../activity/my_activity_list.dart';
import '../home/noOpenVipDialog.dart';
import '../widgets/yk_easy_loading_widget.dart';
import 'face_verify.dart';
import 'userinfo_change_page.dart';

class NewMinePage extends StatefulWidget {
  const NewMinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<NewMinePage> {
  Map<String, dynamic> userDic = {};
  Map<String, dynamic> mineinfodic = {};
  int _pageNo = 1;
  Map<String, dynamic> basicDic = {};
  String qingshaonianmoshi = '';

  List dataSource = [];
  @override
  void initState() {
    super.initState();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();
    getmineinfo();
    // testsss();
    getunreadCount();
  }

  getunreadCount()async{
    //获取会话未读总数
    V2TimValueCallback<int> getTotalUnreadMessageCountRes =
    await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (getTotalUnreadMessageCountRes.code == 0) {
      //拉取成功
      int? count = getTotalUnreadMessageCountRes.data;//会话未读总数
      if (count!>0){
        eventTools.emit('showMessageHave');
      }else{
        eventTools.emit('showMessageNo');
      }
      print('未读消息数量是'+count.toString());
    }
  }

  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      BotToast.closeAllLoading();
      setState(() {
        basicDic = data;
      });
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:  Color.fromRGBO(255, 255, 255, 0),
      body: qingshaonianmoshi=='true'?Container(
          color:  Color.fromRGBO(255, 255, 255, 0),
          height: 500,
          width: screenSize.width,
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height:500,
                      child: Stack(

                        children: [
                          Image.asset(
                            'images/mine/mine_top.png',
                            height: 250.5,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),

                          //编辑
                          Positioned(
                              right: 61.5,
                              top: 50 + 10,
                              child: GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Image.asset(
                                  'images/mine/mine_edit.png',
                                  width: 22,
                                  height: 21.5,
                                ),
                              )),

                          //设置
                          Positioned(
                              right: 24.5,
                              top: 50 + 10,
                              child: GestureDetector(
                                onTap: () async{
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const SetPage();
                                      }));
                                  getUserInfo();
                                },
                                child: Image.asset(
                                  'images/mine/mine_set.png',
                                  width: 24.5,
                                  height: 22.5,
                                ),
                              )),
                          Positioned(
                              top: 55,
                              left: ((MediaQuery.of(context).size.width - 97) / 2.0),
                              child: (userDic['avatar'] != null)
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(91.5/2),
                                child: GestureDetector(
                                    onTap: () async{
                                      //修改个人信息
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (BuildContext ccontext) {
                                            return const UserinfoChangePage(

                                            );
                                          }));
                                      getUserInfo();
                                    },
                                    child: Container(
                                      width: 91.5,
                                      height: 91.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:BorderRadius.circular(91.5/2),
                                        border: Border.all(width: 2,color: Colors.white)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(89.5/2),
                                        child: NetImage(

                                          userDic['avatar'].toString(),
                                          width: 89.5,
                                          height: 89.5,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                ),
                              )
                                  : GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Container(
                                  width: 97,
                                  height: 97,
                                  decoration: const BoxDecoration(
                                    // color: Colors.yellow,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(97 / 2.0))),
                                ),)),
                          Positioned(
                              top: 50 + 89.5 + 8.5,
                              child: GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      userDic['nickname'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: 15,
                              right: 15,
                              top: 50 + 89.5 + 8.5+30.5,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineWantknowMelistPage();
                                          }));
                                      getmineinfo();
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(mineinfodic['wantKnowMe']==null?'0':mineinfodic['wantKnowMe'].toString(),
                                              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child:  mineinfodic['likeMeFlag']==1?Container(
                                                  width: 8,
                                                  height: 8,
                                                  color: Color(0xffED0D0D)
                                              ):Container(),
                                            ),


                                          ],
                                        ),

                                        Text('想认识我',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineWantknowotherListpage();
                                          }));
                                      getmineinfo();
                                    },
                                    child: Column(
                                      children: [
                                        Text(mineinfodic['meWantKnow']==null?'0':mineinfodic['meWantKnow'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                        Text('我想认识',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineOtherseemeListpage();
                                          }));
                                      getmineinfo();
                                    },
                                    child:  Column(
                                      children: [
                                        Text(mineinfodic['seeMeNum']==null?'0':mineinfodic['seeMeNum'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                        Text('谁看过我',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: ()async{
                                        await Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext ccontext) {
                                              return  MineMeseeotherListpage();
                                            }));
                                        getmineinfo();
                                      },
                                      child: Column(
                                        children: [
                                          Text(mineinfodic['meSeeNum']==null?'0':mineinfodic['meSeeNum'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                          Text('我看过谁',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                        ],
                                      )),

                                ],
                              )
                          ),

                          Positioned(
                            top: 50 + 89.5 + 8.5+30.5+70,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                // image: DecorationImage(image: AssetImage('images/mine/mine_botom.png'),fit: BoxFit.fill),
                                color: Color.fromRGBO(255, 255, 255, 0),
                              ),


                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: EdgeInsets.only(top: 15.5,left: 15,right: 15),
                                    padding: EdgeInsets.only(top: 10,left: 0,right: 0,bottom: 15.5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17.5)
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () async {
                                            // 跳转实名认证
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(builder: (BuildContext context) {
                                            //       return const LoginShimingrenzheng();
                                            //     }));
                                            userDic['haveNameAuth']!=1?rightNameAuth():();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_shiming.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '实名认证',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    userDic['haveNameAuth']!=1?Text('未认证',style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),)
                                                        : Text('已认证',style: TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                                    )
                                                  ],
                                                )

                                              ],
                                            ),
                                          ),
                                        ),



                                        GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const MineDongtaiList();
                                                }));
                                            getmineinfo();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_dongtai.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的动态',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),

                                                //commentMeFlag
                                                Row(
                                                  children: [
                                                    mineinfodic['commentMeFlag']==1?Container(
                                                      width: 13.5,
                                                      height: 13.5,
                                                      decoration: const BoxDecoration(
                                                          color: Color(0xffED0D0D),
                                                          borderRadius:
                                                          BorderRadius.all(Radius.circular(13.5/2))),
                                                    ):Container(),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )


                        ],
                      ),
                    ),
                  ],
                ),
              )
          )


      )
      :Container(
          color:  Color.fromRGBO(255, 255, 255, 0),
          height: 780,
          width: screenSize.width,
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height:780,
                      child: Stack(

                        children: [
                          Image.asset(
                            'images/mine/mine_top.png',
                            height: 340.5,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),

                          //编辑
                          Positioned(
                              right: 61.5,
                              top: 50 + 10,
                              child: GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Image.asset(
                                  'images/mine/mine_edit.png',
                                  width: 22,
                                  height: 21.5,
                                ),
                              )),

                          //设置
                          Positioned(
                              right: 24.5,
                              top: 50 + 10,
                              child: GestureDetector(
                                onTap: () async{
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const SetPage();
                                      }));
                                  getUserInfo();
                                },
                                child: Image.asset(
                                  'images/mine/mine_set.png',
                                  width: 24.5,
                                  height: 22.5,
                                ),
                              )),
                          Positioned(
                              top: 55,
                              left: ((MediaQuery.of(context).size.width - 97) / 2.0),
                              child: (userDic['avatar'] != null)
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(91.5/2),
                                child: GestureDetector(
                                    onTap: () async{
                                      //修改个人信息
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (BuildContext ccontext) {
                                            return const UserinfoChangePage(

                                            );
                                          }));
                                      getUserInfo();
                                    },
                                    child: Container(
                                      width: 91.5,
                                      height: 91.5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:BorderRadius.circular(91.5/2),
                                        border: Border.all(width: 2,color: Colors.white)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(89.5/2),
                                        child: NetImage(

                                          userDic['avatar'].toString(),
                                          width: 89.5,
                                          height: 89.5,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                ),
                              )
                                  : GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Container(
                                  width: 97,
                                  height: 97,
                                  decoration: const BoxDecoration(
                                    // color: Colors.yellow,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(97 / 2.0))),
                                ),)),
                          Positioned(
                              top: 50 + 89.5 + 8.5,
                              child: GestureDetector(
                                onTap: () async{
                                  //修改个人信息
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext ccontext) {
                                        return const UserinfoChangePage(

                                        );
                                      }));
                                  getUserInfo();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      userDic['nickname'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              left: 15,
                              right: 15,
                              top: 50 + 89.5 + 8.5+30.5,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineWantknowMelistPage();
                                          }));
                                      getmineinfo();
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(mineinfodic['wantKnowMe']==null?'0':mineinfodic['wantKnowMe'].toString(),
                                              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child:  mineinfodic['likeMeFlag']==1?Container(
                                                  width: 8,
                                                  height: 8,
                                                  color: Color(0xffED0D0D)
                                              ):Container(),
                                            ),


                                          ],
                                        ),

                                        Text('想认识我',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineWantknowotherListpage();
                                          }));
                                      getmineinfo();
                                    },
                                    child: Column(
                                      children: [
                                        Text(mineinfodic['meWantKnow']==null?'0':mineinfodic['meWantKnow'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                        Text('我想认识',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: ()async{
                                      await Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext ccontext) {
                                            return  MineOtherseemeListpage();
                                          }));
                                      getmineinfo();
                                    },
                                    child:  Column(
                                      children: [
                                        Text(mineinfodic['seeMeNum']==null?'0':mineinfodic['seeMeNum'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                        Text('谁看过我',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: ()async{
                                        await Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext ccontext) {
                                              return  MineMeseeotherListpage();
                                            }));
                                        getmineinfo();
                                      },
                                      child: Column(
                                        children: [
                                          Text(mineinfodic['meSeeNum']==null?'0':mineinfodic['meSeeNum'].toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                                          Text('我看过谁',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7),fontSize: 14),)
                                        ],
                                      )),

                                ],
                              )
                          ),
                          basicDic['virtualDisplay']==1?Positioned(
                            top: 50 + 89.5 + 8.5+30.5+50,
                            child:
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: ()async{
                                await  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext ccontext) {
                                      return  VipcenterHome();
                                    }));
                                getUserInfo();
                              },
                              child: Container(
                                height: 97,
                                margin: EdgeInsets.only(left: 14.5,top: 10,right: 14.5),
                                width: (MediaQuery.of(context).size.width - 30 ) ,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage('images/mine/mine_vipcenter.png'),fit: BoxFit.fill),
                                  // color: Color.fromRGBO(255, 255, 255, 0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 12,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 16.5,),
                                              Image(image: AssetImage('images/mine/mine_vip.png'),width: 17.5,height: 16.5,),
                                              SizedBox(width:4,),
                                              Text('会员中心',style: TextStyle(color: Color(0xffFE7A24),fontSize: 17,fontFamily:'Alimama ShuHeiTi',fontWeight:FontWeight.w600  ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16.5,top:3.5),
                                            child: Text('加入会员，畅想更多会员权益',style: TextStyle(color: Color(0xffFE7A24),fontSize: 12,fontWeight:FontWeight.w500  ),),
                                          )

                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: ()async{
                                          await  Navigator.push(context, MaterialPageRoute(
                                              builder: (BuildContext ccontext) {
                                                return  VipcenterHome();
                                              }));
                                          getUserInfo();
                                        },
                                        child:  Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 15.5,top: 20),
                                          width: 63,
                                          height: 24.5,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFE7A24),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.25)
                                            ),
                                          ),
                                          child: Text('点击开通',style: TextStyle(color: Colors.white,fontSize: 11,fontWeight:FontWeight.w500  ),textAlign: TextAlign.center,),
                                        )
                                    )
                                  ],
                                ),
                              ),),
                          ):Container(),



                          Positioned(
                            top: 50 + 89.5 + 8.5+30.5+50+50,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('images/mine/mine_botom.png'),fit: BoxFit.fill),
                                color: Color.fromRGBO(255, 255, 255, 0),
                              ),


                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (BuildContext ccontext) {
                                                return  HongniangFuwuhome();
                                              }));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 60,left: 15,right: 13),
                                          height: 65.5,
                                          width: (screenSize.width-30-13)/2,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(image: AssetImage('images/mine/mine_hongniang.png'),fit: BoxFit.fill),
                                            color: Color.fromRGBO(255, 255, 255, 0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child:Text('红娘服务',style: TextStyle(color: Color(0xff333333),fontSize: 18,fontWeight:FontWeight.w700  ),),
                                                margin: EdgeInsets.only(left: 13,top: 10),
                                              ),
                                              Container(
                                                child:Text('牵线美好姻缘',style: TextStyle(color: Color(0xffFFC002),fontSize: 13,fontWeight:FontWeight.w500  ),),
                                                margin: EdgeInsets.only(left: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // GestureDetector(
                                      //   onTap: ()async{
                                      //
                                      //     // await Navigator.push(context, MaterialPageRoute(
                                      //     //     builder: (BuildContext ccontext) {
                                      //     //       return  XingzuoSubmitNoreturn();
                                      //     //     }));
                                      //     // getmineinfo();
                                      //     // return;
                                      //
                                      //     if (basicDic['virtualDisplay']==1){
                                      //       if (userDic['userLevel']==0){
                                      //         showDialog(
                                      //             context:context,
                                      //             builder:(context){
                                      //               return Noopenvipdialog(
                                      //                   content: '',
                                      //                   OntapCommit: ()async{
                                      //                     await  Navigator.push(context, MaterialPageRoute(
                                      //                         builder: (BuildContext ccontext) {
                                      //                           return  VipcenterHome();
                                      //                         }));
                                      //                     getUserInfo();
                                      //                   }
                                      //
                                      //               );
                                      //             }
                                      //         );
                                      //         return;
                                      //       }else{
                                      //
                                      //       }
                                      //     }
                                      //
                                      //
                                      //     //去提交测试
                                      //     if (mineinfodic['isConstellationCommit']==null||mineinfodic['isConstellationCommit'].toString()=='0'){
                                      //       await Navigator.push(context, MaterialPageRoute(
                                      //           builder: (BuildContext ccontext) {
                                      //             return  XingzuoHomePage();
                                      //           }));
                                      //       getmineinfo();
                                      //     }
                                      //
                                      //     //已提交测试没有回复
                                      //     if (mineinfodic['isConstellationCommit']!=null&&mineinfodic['isConstellationCommit'].toString()=='1'&&mineinfodic['isConstellationTest'].toString()=='0'){
                                      //       await Navigator.push(context, MaterialPageRoute(
                                      //           builder: (BuildContext ccontext) {
                                      //             return  XingzuoSubmitNoreturn();
                                      //           }));
                                      //       getmineinfo();
                                      //     }
                                      //
                                      //     //已提交测试已有回复
                                      //     if (mineinfodic['isConstellationCommit']!=null&&mineinfodic['isConstellationCommit'].toString()=='1'&&mineinfodic['isConstellationTest'].toString()=='1'){
                                      //       await Navigator.push(context, MaterialPageRoute(
                                      //           builder: (BuildContext ccontext) {
                                      //             return  XingzuoSubmitReturn();
                                      //           }));
                                      //       getmineinfo();
                                      //     }
                                      //
                                      //   },
                                      //   child:  Container(
                                      //     margin: EdgeInsets.only(top: 60,right: 15),
                                      //     height: 65.5,
                                      //     width: (screenSize.width-30-13)/2,
                                      //     decoration: const BoxDecoration(
                                      //       image: DecorationImage(image: AssetImage('images/mine/mine_xingzuo.png'),fit: BoxFit.fill),
                                      //       // color: Color.fromRGBO(255, 255, 255, 0),
                                      //     ),
                                      //     child: Column(
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Row(
                                      //           children: [
                                      //             Container(
                                      //               child:Text('星座测算',style: TextStyle(color: Color(0xff333333),fontSize: 18,fontWeight:FontWeight.w700  ),),
                                      //               margin: EdgeInsets.only(left: 13,top: 10),
                                      //             ),
                                      //             SizedBox(width: 5,),
                                      //             ClipRRect(
                                      //               borderRadius: BorderRadius.circular(4),
                                      //               child:  mineinfodic['constellationTestFlag']==1?Container(
                                      //                   width: 8,
                                      //                   height: 8,
                                      //                   color: Color(0xffED0D0D)
                                      //               ):Container(),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         GestureDetector(
                                      //           // //测试
                                      //           // onTap: (){
                                      //           //   Navigator.push(context, MaterialPageRoute(
                                      //           //       builder: (BuildContext ccontext) {
                                      //           //         return  XingzuoTaskList();
                                      //           //       }));
                                      //           // },
                                      //           child: Container(
                                      //             child:Text('测算星座运势',style: TextStyle(color: Color(0xffFE7A24),fontSize: 13,fontWeight:FontWeight.w500  ),),
                                      //             margin: EdgeInsets.only(left: 13),
                                      //           ),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),




                                  Container(
                                    margin: EdgeInsets.only(top: 15.5,left: 15,right: 15),
                                    padding: EdgeInsets.only(top: 10,left: 0,right: 0,bottom: 15.5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17.5)
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () async {
                                            // 跳转实名认证
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(builder: (BuildContext context) {
                                            //       return const LoginShimingrenzheng();
                                            //     }));
                                            userDic['haveNameAuth']!=1?rightNameAuth():();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_shiming.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '实名认证',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    userDic['haveNameAuth']!=1?Text('未认证',style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),)
                                                        : Text('已认证',style: TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                                    )
                                                  ],
                                                )

                                              ],
                                            ),
                                          ),
                                        ),




                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const MyActivityListPage();
                                                }));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_activity.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的活动',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const MineDongtaiList();
                                                }));
                                            getmineinfo();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_dongtai.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的动态',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),

                                                //commentMeFlag
                                                Row(
                                                  children: [
                                                    mineinfodic['commentMeFlag']==1?Container(
                                                      width: 13.5,
                                                      height: 13.5,
                                                      decoration: const BoxDecoration(
                                                          color: Color(0xffED0D0D),
                                                          borderRadius:
                                                          BorderRadius.all(Radius.circular(13.5/2))),
                                                    ):Container(),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Color.fromRGBO(171, 171, 171, 1.0),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),


                                        basicDic['virtualDisplay']==1?GestureDetector(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const MineQianxianPage();
                                                }));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_qianxian.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的服务',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ):Container(),

                                        //我的订单
                                        basicDic['virtualDisplay']==1?GestureDetector(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const MineOrderListPage();
                                                }));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_order.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的订单',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ):Container(),


                                        //我的分享
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (BuildContext ccontext) {
                                                  return const ShareHomePage();
                                                }));

                                            // Navigator.push(context, MaterialPageRoute(
                                            //     builder: (BuildContext ccontext) {
                                            //       return const LoginFutureNewPage();
                                            //     }));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10, right: 9.5),
                                            alignment: Alignment.centerLeft,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(7.5))),
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image(image: AssetImage('images/mine/mine_share.png'),width: 21,height: 21,),
                                                    SizedBox(width: 11.5,),
                                                    Text(
                                                      '我的分享',
                                                      style: TextStyle(
                                                          color: Color(0xff333333), fontSize: 15,fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )


                        ],
                      ),
                    ),
                  ],
                ),
              )
          )


      ),
    );
  }


  //立即实名认证
  rightNameAuth()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const FaceVerify();
        }));
    getUserInfo();
  }

  //获取用户信息
  void getUserInfo() async {
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
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
          setState(() {
            userDic = data;
          });
          _getBaseInfo();

        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }

  getmineinfo()async{
    // BotToast.closeAllLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myInformation, queryParameters: {},
        successCallback: (data) async {
          setState(() {
            mineinfodic = data;
            if (mineinfodic['commentMeFlag']==1||mineinfodic['likeMeFlag']==1){
              eventTools.emit('showMinePointHave');
            }
            if (mineinfodic['commentMeFlag']!=1&&mineinfodic['likeMeFlag']!=1){
              eventTools.emit('showMinePointNo');
            }
          });
        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }

  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      _pageNo = 1;
      getUserInfo();
    });
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  // ///获取我的帖子数据
  // void _getData() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.myPosts, queryParameters: {
  //     'userId': sharedPreferences.get('UserId').toString(),
  //     'pageNo': _pageNo.toString(),
  //     'pageSize': '20',
  //   }, successCallback: (data) async {
  //     print('1111');
  //     print(data);
  //     if (data['list'] != null) {
  //       setState(() {
  //         dataSource = data['list'];
  //       });
  //     }
  //   }, failedCallback: (data) {});
  // }

  ImageProvider getImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(
      imageUrl,
    );
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    EasyLoading.dismiss();
    super.dispose();
  }
}
