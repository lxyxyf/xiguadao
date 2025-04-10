import 'dart:developer';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
// import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/mine/share_coin_page.dart';
import 'package:xinxiangqin/mine/share_guize_dialog.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

class ShareHomePage extends StatefulWidget {
  const ShareHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<ShareHomePage> {
  Map<String, dynamic> pointDic = {};
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  String invitePoints = '0';
  String usernickname = '';
  bool isLoading = false;
  List pointProductDatasource = [];
  List pointMypointDatasource = [];
  final ScrollController _scrollController = ScrollController();
  Fluwx fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    getUserInfo();
    getPointProductPage();
    getMyPoint();
    _getBaseInfo();
  }

  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      invitePoints = data['invitePoints'].toString();
    }, failedCallback: (data) {});
  }

  ///获取积分商品
  void getPointProductPage() async {
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getPointProductPage, queryParameters: {
      'pageNo': '1',
      'pageSize': '20',
    }, successCallback: (data) async {
      EasyLoading.dismiss();

      isLoading = false;
      if (data!= null) {
        setState(() {
          pointProductDatasource = data['list'];
          log('打印积分商品data$pointProductDatasource');
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }


  ///获取我的道具卡
  void getMyPoint() async {
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMyPoint, queryParameters: {
      'pageNo': '1',
      'pageSize': '20',
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印我的道具卡data$data');
      isLoading = false;
      pointDic = data;
      if (data['exchangeDetailVos']!= null) {
        setState(() {
          pointMypointDatasource = data['exchangeDetailVos'];
        });
      }
    }, failedCallback: (data) {
      log('打印我的道具卡错误$data');
      EasyLoading.dismiss();
    });
  }

  void getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          log('用户信息身份type='+data.toString());
          setState(() {
            usernickname = data['nickname'];
          });
        }, failedCallback: (data) {});
  }

  void _share()async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('UserId');
    String? nickName = sharedPreferences.getString('nackname');
    final ByteData bytes = await rootBundle.load('images/share/shareappicon.png');
    await fluwx.share(
        WeChatShareWebPageModel(
            thumbData:bytes.buffer.asUint8List(),
            'https://www.xiguadao.cc/share/#/?id=${userID}',
            title: '${usernickname}邀请您加入【西瓜岛】',
            description: '🍉探索无限可能，尽在西瓜岛🍉',
            scene: WeChatScene.session
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor:  Colors.white,
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.white,
          child: Stack(
            children: [

              Container(
                  height: 253,
                  width: screenSize.width,
                  padding: EdgeInsets.only(bottom: 19.5),
                  // height: 180+MediaQuery.of(context).padding.top,
                  // margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage('images/share/top.png'),
                        fit: BoxFit.fill,
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                        // color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child:  Row(
                                children: [
                                  const Icon(Icons.arrow_back_ios,color: Color(0xff333333),),

                                  const Text(
                                    '我的分享',
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),

                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext ccontext) {
                                          return const ShareCoinPage(

                                          );
                                        }));
                                  },
                                  child: Text('积分明细',
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(width: 14.5,),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context:context,
                                        builder:(context){
                                          return ShareGuizeDialog(
                                            content: invitePoints,
                                              OntapCommit: (){

                                              }
                                          );
                                        }
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image(image: AssetImage('images/share/guize.png'),width: 14,height: 14,),
                                      SizedBox(width: 5,),
                                      const Text(
                                        '规则',
                                        style: TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),

                                      SizedBox(width: 16,)
                                    ],
                                  )
                                ),


                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 13,),
                      //订单状态
                      Row(
                        children: [
                          SizedBox(width: 25,),
                          Text(pointDic['myPointNum']!=null?pointDic['myPointNum'].toString():'0',style: TextStyle(color: Color(0xff333333),fontSize: 34.5,fontWeight: FontWeight.w700),),
                          SizedBox(width: 2.5,),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('积分',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                      SizedBox(height: 1,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [



                          GestureDetector(
                            onTap: (){
                              _share();
                            },
                            child: Container(
                                width: 94,height: 36.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(18.25)),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,//渐变开始于上面的中间开始
                                        end: Alignment.centerRight,//渐变结束于下面的中间
                                        colors: [Color(0xFFFE7A24), Color(0xFFFFC002)]//开始颜色和结束颜色]
                                    )),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 25),
                                child:Text('获取积分',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                            ),
                          ),
                          Container(
                              height: 50.5,
                              padding: EdgeInsets.only(left: 3,right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Color.fromRGBO(255, 255, 255, 0.24)
                                 ),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 34),
                              child:Column(
                                children: [
                                  Text('今日已领',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),),
                                  pointDic['todayReceivePoint']==null?Text('0积分',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)
                                      :Text(pointDic['todayReceivePoint'].toString()+'积分',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)
                                ],
                              )
                          ),

                        ],
                      )

                    ],
                  )
              ),
              Positioned(
                  left: 11.5,right: 11.5,
                  top: 220,

                  child: Container(
                    // height: 200*2+50,
                    child:SingleChildScrollView(
                      child: Column(
                        children: [

                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              // color: Colors.red,
                                image: DecorationImage(
                                  image: AssetImage('images/share/backgroundcard.png'),
                                  fit: BoxFit.fill,
                                )
                            ),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 21.5,right: 16,bottom: 10,top: 0),
                            child:Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 0,right: 0,top: 0),
                                    height: 50,
                                    child: Stack(
                                      children: [


                                        Positioned(
                                            left: 83,
                                            top: 28.5,
                                            child: Image(image: AssetImage('images/share/xiexian.png'),width: 82,height: 15.5,)
                                        ),

                                        Positioned(
                                            height: 50,
                                            left:89,top: 12.5,
                                            child: Text('积分兑换',style:
                                            TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),)
                                        ),

                                      ],
                                    )
                                ),
                                pointProductDatasource.length!=0?Expanded(child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: RefreshIndicator(
                                    onRefresh: _onRefresh,
                                    child: ListView.separated(
                                        controller: _scrollController,
                                        itemBuilder: (BuildContext context, int index) {
                                          return _buildItem(context, index);
                                        },
                                        separatorBuilder: (BuildContext context, int index) {
                                          return Container(
                                            height: 15,
                                          );
                                        },
                                        itemCount: pointProductDatasource.length),
                                  ),
                                ),):Container(
                                  width: 130,height: 130,
                                  child: Center(
                                    child: Image(image: AssetImage('images/home_nodata.png')),
                                  ),
                                ),
                              ],
                            )
                            // decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                            // ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                              height: 200,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                  image: DecorationImage(
                                    image: AssetImage('images/share/backgroundcard.png'),
                                    fit: BoxFit.fill,
                                  )
                              ),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 21.5,right: 16,bottom: 10,top: 0),
                              child:Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 0,right: 0,top: 0),
                                      height: 50,
                                      child: Stack(
                                        children: [


                                          Positioned(
                                              left: 83,
                                              top: 28.5,
                                              child: Image(image: AssetImage('images/share/xiexian.png'),width: 82,height: 15.5,)
                                          ),

                                          Positioned(
                                              height: 50,
                                              left:89,top: 12.5,
                                              child: Text('我的道具卡',style:
                                              TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),)
                                          ),

                                        ],
                                      )
                                  ),
                                  pointMypointDatasource.length!=0?Expanded(child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: RefreshIndicator(
                                      onRefresh: _onRefresh,
                                      child: ListView.separated(
                                          controller: _scrollController,
                                          itemBuilder: (BuildContext context, int index) {
                                            return _buildItem1(context, index);
                                          },
                                          separatorBuilder: (BuildContext context, int index) {
                                            return Container(
                                              height: 15,
                                            );
                                          },
                                          itemCount: pointMypointDatasource.length),
                                    ),
                                  ),):Container(
                                    width: 130,height: 130,
                                    child: Center(
                                      child: Image(image: AssetImage('images/home_nodata.png')),
                                    ),
                                  ),
                                ],
                              )
                            // decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                            // ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),



            ],
          ),
        )

    );
  }


  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // // showTankuang();
        // godetail(dataSource[index]);
      },
      child: Container(

          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child:Column(
            children: [

              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image(image: AssetImage(pointProductDatasource[index]['productName']=='超级喜欢'?'images/share/chaojixihuan.png':'images/share/tiyanka.png'),width: 46,height: 46,),
                          SizedBox(width: 11,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(pointProductDatasource[index]['productName'],style:
                                  TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),
                                  pointProductDatasource[index]['productName']=='超级喜欢'?Text(' x'+pointProductDatasource[index]['timeLimit'].toString()+'次',style:
                                  TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500),)
                                      :Text(' x'+pointProductDatasource[index]['timeLimit'].toString()+'天',style:
                                  TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500))
                                ],
                              ),

                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Image(image: AssetImage('images/share/coin.png'),width: 13.5,height: 14,),
                                  SizedBox(width: 5,),
                                  Text(pointProductDatasource[index]['exchangePoint'].toString(),style:
                                  TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),),

                                ],
                              )
                            ],
                          )
                        ],
                      ),

                      GestureDetector(
                        onTap: (){
                          duihuanjifen(index);
                        },
                        child:Container(
                            width: 78,height: 29,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18.25)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,//渐变开始于上面的中间开始
                                    end: Alignment.centerRight,//渐变结束于下面的中间
                                    colors: [Color(0xFFFE7A24), Color(0xFFFFC002)]//开始颜色和结束颜色]
                                )),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 0),
                            child:Text('兑换',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  )
              ),


            ],
          ),
      ),
    );
  }


  Widget _buildItem1(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // // showTankuang();
        // godetail(dataSource[index]);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child:Column(
          children: [

            Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage(pointMypointDatasource[index]['productName']=='超级喜欢'?'images/share/chaojixihuan.png':'images/share/tiyanka.png'),width: 46,height: 46,),
                        SizedBox(width: 11,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(pointMypointDatasource[index]['productName'].toString(),style:
                                TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),
                                Text(' x'+pointMypointDatasource[index]['remainQuantity'].toString()+pointMypointDatasource[index]['unit'].toString(),style:
                                TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500),)

                              ],
                            ),

                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Image(image: AssetImage('images/share/coin.png'),width: 13.5,height: 14,),
                                SizedBox(width: 5,),
                                Text(pointMypointDatasource[index]['redeemPoint'].toString()+'积分 ',style:
                                TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),),

                              ],
                            )
                          ],
                        )
                      ],
                    ),

                   GestureDetector(
                     onTap: (){
                       useDaoju(index);
                     },
                     child:  Container(
                         width: 78,height: 29,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(18.25)),
                             gradient: LinearGradient(
                                 begin: Alignment.centerLeft,//渐变开始于上面的中间开始
                                 end: Alignment.centerRight,//渐变结束于下面的中间
                                 colors: [Color(0xFFFE7A24), Color(0xFFFFC002)]//开始颜色和结束颜色]
                             )),
                         alignment: Alignment.center,
                         margin: EdgeInsets.only(right: 0),
                         child:Text('使用',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                     ),
                   )
                  ],
                )
            ),


          ],
        ),
      ),
    );
  }

  duihuanjifen(index)async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createExchangeDetail, data: {
      'productId': pointProductDatasource[index]['id'],
      'status':'0',
      'redeemPoint':pointProductDatasource[index]['exchangePoint'].toString()
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      BotToast.showText(text: '兑换成功');
      getPointProductPage();
      getMyPoint();
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  useDaoju(index)async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.useExchangeDetail, data: {
      'id': pointMypointDatasource[index]['id']
    }, successCallback: (data) async {
      log(data.toString());
      EasyLoading.dismiss();
      BotToast.showText(text: '使用成功');
      getMyPoint();
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }


  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {

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
