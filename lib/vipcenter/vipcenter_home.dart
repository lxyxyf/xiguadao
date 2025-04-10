import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:bot_toast/bot_toast.dart';
// import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/tobias.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/vipcenter/pay_paytype_dialog.dart';
import 'package:xinxiangqin/vipcenter/vipcenter_xieyi.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import 'package:alipay_kit/alipay_kit.dart';
class VipcenterHome extends StatefulWidget {
  const VipcenterHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<VipcenterHome> {
  Map<String, dynamic> userDic = {};
  Map<String, dynamic> vipDic = {};
  Map<String, dynamic> myVipDic = {};
  List myvipQuanyiList = [];
  List vipQuanyiList = [];
  String vipendtime = '';
  Tobias tobias = Tobias();
  List payprice = [];
  int priceSelect = 0;
  int perfectSelect = 2;
  int isVip = 0;
  Fluwx fluwx = Fluwx();
  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    initListener();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();
    getMemberUserPrivilege();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return payprice.length!=0?Scaffold(
      backgroundColor:  Color(0xfffafafa),
        body: Stack(
          children: [
            Positioned(
              // color:  Color.fromRGBO(255, 255, 255, 0),
                height: isVip==0?screenSize.height-95-12.5-5:screenSize.height-81.5-12.5-5,
                width: screenSize.width,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child:  SingleChildScrollView(
                      child:  Stack(
                        children: [
                          Container(
                              width: screenSize.width,
                              // height: 180+MediaQuery.of(context).padding.top,
                              margin: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                  image: DecorationImage(
                                    image: AssetImage('images/vipcenter/vipcenter_top.png'),
                                    fit: BoxFit.fill,
                                  )
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                                    // color: Colors.white,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_back_ios),

                                        const Text(
                                          '会员中心',
                                          style: TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  ),

                                  //
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 96.5,
                                    margin: EdgeInsets.only(left: 13.5,right: 13.5,top: 14),
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                        image: DecorationImage(
                                          image: AssetImage('images/vipcenter/vipcenter_vepcard.png'),
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 16.5,top: 14),
                                              child: (userDic['avatar'] != null)
                                                  ? ClipOval(
                                                child: GestureDetector(
                                                  onTap: () {

                                                  },
                                                  child: NetImage(
                                                    userDic['avatar'].toString(),
                                                    width: 46,
                                                    height: 46,
                                                  ),
                                                ),
                                              )
                                                  : GestureDetector(
                                                onTap: () {

                                                },child: Container(
                                                width: 46,
                                                height: 46,
                                                decoration: const BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(46 / 2.0))),
                                              ),),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(left: 11,top: 17.5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.left,
                                                    userDic['nickname'] ?? '',
                                                    style: const TextStyle(
                                                        color: Color(0xff333333),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text(
                                                    isVip==0?'暂未开通会员，无法享受会员权益':'有效期至：'+vipendtime,
                                                    style: const TextStyle(
                                                        color: Color(0xff999999),
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 57.5,
                                          height: 25.5,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(image: AssetImage(isVip==0?'images/vipcenter/vip_close.png':'images/vipcenter/vip_open.png'),fit: BoxFit.fill)
                                          ),
                                          margin: EdgeInsets.only(right: 2,top: 2),
                                          child: Text(
                                            isVip==0?'未开通':'已开通',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 140),
                            child: Image(image: AssetImage('images/vipcenter/vipcenter_background.png')),
                          ),

                          //价格选择1
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                priceSelect=0;
                              });
                            },
                            child:  Container(
                                margin: EdgeInsets.only(top: 200,left: 17),
                                child:  Row(
                                  children: [
                                    Container(
                                        width: 108.5,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                            image: DecorationImage(
                                              image: AssetImage(priceSelect==0?'images/vipcenter/vipcenter_money_select.png':'images/vipcenter/vipcenter_money_unselect.png'),
                                              fit: BoxFit.fill,
                                            )
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 10,top: 12),
                                                  child: Text(payprice[0]['text'].toString()+'个月',style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                                ),
                                                priceSelect==0?Container(
                                                  margin: EdgeInsets.only(right: 0,top: 8),
                                                  width: 50,
                                                  height: 44,
                                                  child: Image(image: AssetImage('images/vipcenter/vipcenter_xianshiyouhui.png')),
                                                ):Container(),
                                              ],
                                            ),
                                            priceSelect==0?Container(height: 2,):Container(
                                              margin: EdgeInsets.only(top: 3,left: 10,right: 24),
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(238, 238, 238, 0.62),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(3))),
                                              child: Text('日均'+payprice[0]['num'].toString()+'元',style: TextStyle(color: Color(0xff999999),fontSize: 12,fontWeight: FontWeight.w500),),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 11,bottom: 0,top: 3),
                                                child: Row(

                                                  children: [
                                                    Text('¥',style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 15,fontWeight: FontWeight.w500)),
                                                    Text(payprice[0]['value'].toString(),style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 22.5,fontWeight: FontWeight.bold)),
                                                  ],
                                                )
                                            )

                                          ],
                                        )
                                    )
                                  ],
                                )
                            ),
                          ),

                          perfectSelect==0?Positioned(child: Container(
                            margin: EdgeInsets.only(left: 30,top: 193),
                            width: 53,height: 15.5,
                            decoration: BoxDecoration(
                                color: Color(0xffFE7A24),
                                borderRadius: BorderRadius.all(Radius.circular(1.5))
                            ),
                            child: Text('最佳选择',
                              style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          )):Container(),



                          //价格选择2
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  priceSelect=1;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 200,left: 17+108.5+(screenSize.width-108.5-108.5-108.5-30)/2),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 108.5,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            // color: Colors.red,
                                              image: DecorationImage(
                                                image: AssetImage(priceSelect==1?'images/vipcenter/vipcenter_money_select.png':'images/vipcenter/vipcenter_money_unselect.png'),
                                                fit: BoxFit.fill,
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: 10,top: 12),
                                                    child: Text(payprice[1]['text'].toString()+'个月',style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                                  ),
                                                  priceSelect==1?Container(
                                                    margin: EdgeInsets.only(right: 0,top: 8),
                                                    width: 50,
                                                    height: 44,
                                                    child: Image(image: AssetImage('images/vipcenter/vipcenter_xianshiyouhui.png')),
                                                  ):Container(),
                                                ],
                                              ),
                                              priceSelect==1?Container(height: 2,):Container(
                                                margin: EdgeInsets.only(top: 3,left: 10,right: 24),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(238, 238, 238, 0.62),
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(3))),
                                                child: Text('日均'+payprice[1]['num'].toString()+'元',style: TextStyle(color: Color(0xff999999),fontSize: 12,fontWeight: FontWeight.w500),),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 11,bottom: 0,top: 3),
                                                  child: Row(

                                                    children: [
                                                      Text('¥',style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 15,fontWeight: FontWeight.w500)),
                                                      Text(payprice[1]['value'].toString(),style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 22.5,fontWeight: FontWeight.bold)),
                                                    ],
                                                  )
                                              )

                                            ],
                                          )
                                      )
                                    ],
                                  )
                              )),

                          perfectSelect==1?Positioned(child: Container(
                            margin: EdgeInsets.only(left: 12+108.5+(screenSize.width-108.5-108.5-108.5-30),top: 193),
                            width: 53,height: 15.5,
                            decoration: BoxDecoration(
                                color: Color(0xffFE7A24),
                                borderRadius: BorderRadius.all(Radius.circular(1.5))
                            ),
                            child: Text('最佳选择',
                              style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          )):Container(),





                          //价格选择3
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                priceSelect=2;
                              });
                            },child: Container(
                              margin: EdgeInsets.only(top: 200,left: 17+108.5+108.5+(screenSize.width-108.5-108.5-108.5-30)),

                              child:  Row(
                                children: [
                                  Container(
                                      width: 108.5,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                          image: DecorationImage(
                                            image: AssetImage(priceSelect==2?'images/vipcenter/vipcenter_money_select.png':'images/vipcenter/vipcenter_money_unselect.png'),
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10,top: 12),
                                                child: Text(payprice[2]['text'].toString()+'个月',style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                              ),

                                              // 会员价格表[{num: 3.19, id: 1, text: 1, value: 99}, {num: 1.61, id: 2, text: 6, value: 299}, {num: 1.07, id: 3, text: 12, value: 398}]
                                              priceSelect==2?Container(
                                                margin: EdgeInsets.only(right: 0,top: 8),
                                                width: 50,
                                                height: 44,
                                                child: Image(image: AssetImage('images/vipcenter/vipcenter_xianshiyouhui.png')),
                                              ):Container(),
                                            ],
                                          ),
                                          priceSelect==2?Container(height: 2,):Container(
                                            margin: EdgeInsets.only(top: 3,left: 10,right: 24),
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(238, 238, 238, 0.62),
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(3))),
                                            child: Text('日均'+payprice[2]['num'].toString()+'元',style: TextStyle(color: Color(0xff999999),fontSize: 12,fontWeight: FontWeight.w500),),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 11,bottom: 0,top: 3),
                                              child: Row(

                                                children: [
                                                  Text('¥',style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 15,fontWeight: FontWeight.w500)),
                                                  Text(payprice[2]['value'].toString(),style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 22.5,fontWeight: FontWeight.bold)),
                                                ],
                                              )
                                          )

                                        ],
                                      )
                                  )
                                ],
                              )
                          ),),

                          perfectSelect==2?Positioned(child: Container(
                            margin: EdgeInsets.only(left: 17+108.5+108.5+(screenSize.width-108.5-108.5-108.5-30+13),top: 193),
                            width: 53,height: 15.5,
                            decoration: BoxDecoration(
                                color: Color(0xffFE7A24),
                                borderRadius: BorderRadius.all(Radius.circular(1.5))
                            ),
                            child: Text('最佳选择',
                              style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          )):Container(),

                          Container(
                            margin: EdgeInsets.only(top: 310,left: 15,right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //客服提示
                                Container(
                                    height: 34.5,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(254, 122, 36, 0.05),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5.5))),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 14.5),
                                          child: Image(image: AssetImage('images/vipcenter/vipcenter_kefu.png',),width: 18.5,height: 18.5,),
                                        ),
                                        SizedBox(width: 8.5,),
                                        Text('如有疑问或帮助，请随时联系客服竭诚为您服务。',style: TextStyle(color: Color(0xffFE7A24),fontSize: 13,fontWeight: FontWeight.w500),)
                                      ],
                                    )
                                ),
                                SizedBox(height: 10.5,),
                                //vip功能列表
                                Text('VIP特权',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold)),
                                SizedBox(height: 22.5,),

                                Container(
                                  width: screenSize.width,
                                  height: 200,
                                  child: GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    //设置滚动方向
                                    scrollDirection: Axis.vertical,
                                    //设置列数
                                    crossAxisCount: 4,
                                    //设置内边距
                                    padding: const EdgeInsets.all(0),
                                    //设置横向间距
                                    crossAxisSpacing: 0,
                                    //设置主轴间距
                                    mainAxisSpacing: 10,
                                    childAspectRatio:1/1,
                                    children: _getData(),
                                  ),
                                ),


                                // Container(
                                //   width: screenSize.width,
                                //     height: 200,
                                //     child: MediaQuery.removePadding(
                                //       context: context,
                                //       removeTop: true,
                                //       child: GridView.count(crossAxisCount: 4,
                                //       children: [
                                //         ListView.separated(
                                //             scrollDirection:Axis.horizontal,
                                //             itemBuilder: (BuildContext context, int index) {
                                //               return _buildItem(context, index);
                                //             },
                                //             separatorBuilder: (BuildContext context, int index) {
                                //               return Container(
                                //                 height: 15,
                                //               );
                                //             },
                                //             itemCount: vipQuanyiList.length)
                                //       ],),
                                //     )),


                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_chaojixihuan.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('超级喜欢',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('每天1次免费',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_mingpian.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('名片浏览',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('每次35个用户',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_fabuhuodong.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('发布活动',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('每月50次',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_puguang.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('多倍曝光',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('优先推荐',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                //
                                // SizedBox(height: 18,),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_chaojixihuan.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('谁想认识我',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('谁想认识我',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_mingpian.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('谁看过我',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('任意查看',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_fabuhuodong.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('专属服务',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('1v1客服',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: EdgeInsets.only(left: 24),
                                //       child: Column(
                                //         children: [
                                //           Image(image: AssetImage('images/vipcenter/vipcenter_puguang.png'),width: 35.5,height: 36,),
                                //           SizedBox(height: 4.5,),
                                //           Text('尊贵标识',style: TextStyle(color: Color(0xff6F4A49),fontSize: 14,fontWeight: FontWeight.bold)),
                                //           SizedBox(height: 6.5,),
                                //           Text('标识展示',style: TextStyle(color: Color(0xff999999),fontSize: 12,)),
                                //
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // ),


                                SizedBox(height: 12.5,),
                                Text('轻松开通  步骤简单',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold)),
                                SizedBox(height: 13.5,),
                                Text('1.选择会员套餐：根据个人需求，选择适合的会员时长。',style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500)),
                                SizedBox(height: 5,),
                                Text('2.安全支付：支持多种支付方式，支付过程安全便捷。',style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500)),
                                SizedBox(height: 5,),
                                Text('3.即刻享受：支付成功后，会员特权立即生效。',style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500)),




                              ],
                            ),
                          ),




                        ],
                      )
                  ),
                )
            ),



            //底部
            Positioned(
                left: 0,
                right: 0,
                bottom:isVip==0?95+12.5 :81.5+12.5,
                child: Container(
                  height: 1,
                  color: Color.fromRGBO(153, 153, 153, 0.17),
                )),

            Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom+12.5,
                height: isVip==0?95:81.5,
                child: Container(
                  width: MediaQuery.of(context).size.width,

                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15,right: 15,top: 12.5,bottom: 5),
                        decoration: BoxDecoration(
                            color: isVip==0?Color.fromRGBO(255, 239, 229, 1):Color.fromRGBO(255, 239, 229, 0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(11))
                        ),
                        child:
                        isVip==0?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 14.5,top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('支付',style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.w500)),
                                      Text(payprice[priceSelect]['value'].toString()+'元',style: TextStyle(color: Color(0xffFE7A24),fontSize: 15,fontWeight: FontWeight.w500)),
                                      Text('开通会员',style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.w500)),

                                    ],
                                  ),

                                  Text(payprice[priceSelect]['text'].toString()+'个月日均'+payprice[priceSelect]['num'].toString()+'元',style: TextStyle(color: Color(0xff999999),fontSize: 11,fontWeight: FontWeight.w500)),


                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showPayType();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 0,right: 0),
                                width: 101.5,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Color(0xffFE7A24),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(11))
                                ),
                                child:Text('去支付',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                              ),
                            )
                          ],
                        )
                            :Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                rightGetQuanyi();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 8,right: 0),
                                width: (screenSize.width-30),
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                                    border: Border.all(color: Color(0xffFE7A24), width: 1)
                                ),
                                child:Text('我的权益',style: TextStyle(color: Color(0xffFE7A24),fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                              ),
                            ),

                            // GestureDetector(
                            //   onTap: (){
                            //     showPayType();
                            //   },
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     margin: EdgeInsets.only(top: 0,right: 0),
                            //     width: (screenSize.width-30-10.5)/2,
                            //     height: 55,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xffFE7A24),
                            //         borderRadius:
                            //         BorderRadius.all(Radius.circular(11))
                            //     ),
                            //     child:Text('去支付',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            //
                            //   ),
                            // )
                          ],
                        ),
                      ),

                      isVip==0?SizedBox(height: 3,):Container(),
                      isVip==0?GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return VipcenterXieyi(
                                );
                              }));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('开通会员代表接受',style: TextStyle(color: Color(0xff999999),fontSize: 12,fontWeight: FontWeight.w500)),
                              Text(
                                '《会员服务协议》',
                                style:
                                TextStyle(color: Color(0xffFE7A24), fontSize: 12,fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ):Container()
                    ],
                  ),
                )),

          ],
        )

    ):Container();
  }

  List<Widget> _getData() {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> list = [];
    for (var index = 0; index < vipQuanyiList.length; index++) {
      list.add(
          Container(
            width: screenSize.width/4,
            height: screenSize.width/4,
            child: Column(
              children: [

                Image(image: AssetImage(vipQuanyiList[index]['privilegeName']=='超级喜欢'?
                'images/vipcenter/vipcenter_chaojixihuan.png'
                    :vipQuanyiList[index]['privilegeName']=='名片浏览'?
                'images/vipcenter/vipcenter_mingpian.png'
                    :vipQuanyiList[index]['privilegeName']=='发布活动'?
                'images/vipcenter/vipcenter_fabuhuodong.png'
                    :vipQuanyiList[index]['privilegeName']=='多倍曝光'?
                'images/vipcenter/vipcenter_puguang.png'
                    :vipQuanyiList[index]['privilegeName']=='谁想认识我'?
                'images/vipcenter/vipcenter_xiangrenshiwo.png'
                    :vipQuanyiList[index]['privilegeName']=='谁看过我'?
                'images/vipcenter/vipcenter_kanguowo.png'
                    :vipQuanyiList[index]['privilegeName']=='专属客服'?
                'images/vipcenter/vipcenter_zhuanshufuwu.png'
                    :'images/vipcenter/vipcenter_zunguibiaoshi.png'),width: 35.5,height: 36,),
                SizedBox(height: 2,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(vipQuanyiList[index]['privilegeName'],style: TextStyle(color: Color(0xff6F4A49),fontWeight: FontWeight.bold,fontSize: 14),),
                    vipQuanyiList[index]['privilegeName']=='超级喜欢'?Text('每'+vipQuanyiList[index]['timeUnit']+vipQuanyiList[index]['privilegeNum'].toString()+'次免费',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        : vipQuanyiList[index]['privilegeName']=='名片浏览'?Text(maxLines: 1,overflow:TextOverflow.clip ,'每'+vipQuanyiList[index]['timeUnit']+vipQuanyiList[index]['privilegeNum'].toString()+'个用户',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :vipQuanyiList[index]['privilegeName']=='发布活动'?Text('每'+vipQuanyiList[index]['timeUnit']+vipQuanyiList[index]['privilegeNum'].toString()+'次',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :vipQuanyiList[index]['privilegeName']=='多倍曝光'?Text('优先推荐',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :vipQuanyiList[index]['privilegeName']=='谁想认识我'?Text('任意查看',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :vipQuanyiList[index]['privilegeName']=='谁看过我'?Text('任意查看',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :vipQuanyiList[index]['privilegeName']=='专属客服'?Text('1v1客服',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :Text('标识展示',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                    ,

                  ],
                )
              ],
            ),
          )
      );
    }
    return list;
  }



  showPayType(){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return PayPaytypeDialog(
            price: payprice[priceSelect]['value'].toString(),
            Wepay: (){
              Navigator.pop(context);
              createWepayOrder();
            },
            Alipay: (){
              log('支付宝支付');
              Navigator.pop(context);
              createAliOrder();
            },

          );
        }
    );
  }

  initListener(){
    var listener = (response) {

      if (response is WeChatPaymentResponse) {
        if(response.errCode == 0){
          BotToast.showText(text: '支付成功');
          getUserInfo();
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }else{
          BotToast.showText(text: '支付失败，请重新支付');
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }
      }
    };
    fluwx.addSubscriber(listener); // 订阅消息
  }

  // initListener()async {
  //   var cancelable;
  //   cancelable = fluwx.addSubscriber((res) {
  //     if (res.errCode == 0) {
  //       // 这里建议去额外让后端处理支付结果回调
  //
  //       // 支付成功则关闭监听 cancel
  //       cancelable.cancel();
  //       BotToast.showText(text: '支付成功');
  //       Future.delayed(const Duration(seconds: 2), () {
  //         showSuccessDialog();
  //       });
  //     } else {
  //       BotToast.showText(text: '支付失败，请重新支付');
  //     }
  //   });
  // }




  paymentWechat(orderInfo) async {
    /// 判断手机上是否安装微信
    bool result = await fluwx.isWeChatInstalled;
    if(result==true){
      log('该手机上安装了微信');
      //请求接口返回订单信息
      payWithWeChat(orderInfo);
    } else {
      log('该手机上未安装微信,请选择其他支付方式');
    }
  }

  payWithWeChat(orderInfo)async{
    log('支付信息'+orderInfo.toString());
    fluwx.pay(
        which: Payment(
          appId: orderInfo['appid'],
          partnerId: orderInfo['partnerId'],
          prepayId: orderInfo['prepayId'],
          packageValue: orderInfo['packageValue'],
          nonceStr: orderInfo['noncestr'],
          // 此处为 int 格式，如果后端返回的int格式则不需要进行额外处理
          timestamp: int.parse(orderInfo['timestamp']),
          sign: orderInfo['sign'],
        ));
  }


  //创建微信的订单
  createWepayOrder()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMemberOrder, data: {
      'mechanismId': payprice[priceSelect]['id'],
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'userId':userId
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('获取订单信息'+data.toString());
      paymentWechat(data);
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }





  //创建支付宝的订单
  createAliOrder()async{
    log('支付宝支付1');
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMemberOrder, data: {
      'mechanismId': payprice[priceSelect]['id'],
      'terminal':1,
      'payway':'2',
      'deviceType':1
    }, successCallback: (data) async {
      EasyLoading.dismiss();

       toAliPay(data.toString());
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  //吊起支付宝支付
  void toAliPay(orderInfo) async {
    //检测是否安装支付宝
    var result = await tobias.isAliPayInstalled;
    if(result){
      log("安装了支付宝");
      // String aliOrderInfo = 'app_auth_token = 2021005100614834&${orderInfo}';
      // log('支付宝支付的订单信息'+aliOrderInfo);
      var payResult = await tobias.pay('${orderInfo}',evn: AliPayEvn.online);
      log(payResult.toString());
      if (payResult['result'] != null) {
        if (payResult['resultStatus'] == '9000') {
          log("支付宝支付成功");
          BotToast.showText(text: '支付成功');
          getUserInfo();
        } else if (payResult['resultStatus'] == '6001') {
          log("支付宝支付失败");
          log(payResult['result'].toString());
          BotToast.showText(text: '支付失败，请重新支付');
        } else {
          log("未知错误");
        }
      }else{
        log(payResult.toString());
      }
    } else {
      log("未安装支付宝");
    }
  }

  //
  void getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          log('用户信息'+data.toString());
          setState(() {
            userDic = data;
            isVip = userDic['userLevel'];
            if (isVip==0){

            }else{
              getMyvipQuanyi();
            }
          });
        }, failedCallback: (data) {});
  }


  getMyvipQuanyi()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.memberResidualInterest, queryParameters: {},
        successCallback: (data) async {
      setState(() {
        myVipDic = data;
        myvipQuanyiList = data['listPrivilege'];
        vipendtime = timestampToDateString (data['memberEnd']);
      });
      log('我的会员权益'+data['listPrivilege'].toString());

        }, failedCallback: (data) {
          log('我的权益错误'+data.toString());
          BotToast.closeAllLoading();
        });
  }

  rightGetQuanyi()async{
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.memberResidualInterest, queryParameters: {},
        successCallback: (data) async {
      BotToast.closeAllLoading();
          showModalBottomSheet(
            isScrollControlled:true,
            context: context,
            builder: (BuildContext context) {
              return MineRightsInterestsDialog(
                quanyiDic: data['listPrivilege'], OntapCommit: (){

              },
              );
            },
          );
          log('我的会员权益'+data['listPrivilege'].toString());

        }, failedCallback: (data) {
          log('我的权益错误'+data.toString());
          BotToast.closeAllLoading();
        });

  }


  void getMemberUserPrivilege() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMemberUserPrivilege, queryParameters: {},
        successCallback: (data) async {

          setState(() {
            payprice = data[0]['mechanismList'];
            vipQuanyiList = data[0]['listPrivilege'];
            log('会员价格表'+data.toString());
          });
        }, failedCallback: (data) {
          log('权益错误'+data.toString());
        });
  }


  void memberResidualInterest() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.memberResidualInterest, queryParameters: {},
        successCallback: (data) async {
          log('权益'+data.toString());
          setState(() {

          });
        }, failedCallback: (data) {
          log('权益错误'+data.toString());
        });
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

  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('yyyy-MM-dd');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }

  @override
  void dispose() {
    eventTools.off('changeUserInfo');
    super.dispose();
  }
}
