import 'dart:developer';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/user/new_userinfo_page.dart';
import 'package:xinxiangqin/user/otherseeme.dart';
import '../vipcenter/vipcenter_home.dart';

class MineOtherseemeListpage extends StatefulWidget {
  const MineOtherseemeListpage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MineOtherseemeListpage> {

  List dataSource = [];
  List avatarList = [];
  int _pageNo = 1;
  Map<String, dynamic> userDic = {};
  String userAreaName = '';//只展示市
  Map<String, dynamic> basicDic = {};
  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的
  String qingshaonianmoshi = '';
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener);
    getUserInfo();

    _getBaseInfo();
  }

  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      if(mounted){
        setState(() {
          // log('基础配置信息111'+data.toString());
          basicDic = data;
          getList();
        });
      }
    }, failedCallback: (data) {});
  }

  //获取用户信息
  void getUserInfo() async {
    BotToast.closeAllLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          print(data);
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
        }, failedCallback: (data) {});
  }




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("谁看过我",textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
            ),

          ),
          body:Stack(
            children: [
              Column(
                children: [

                  Container(

                    margin: const EdgeInsets.only(left: 15,top: 16,right: 15),
                    height: 43.5,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        //头像集合

                        SizedBox(
                            width: avatarList.length<=4?avatarList.length.toDouble()*28:112,
                            height: 28,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: RefreshIndicator(
                                onRefresh: _onRefresh,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    controller: _scrollController1,
                                    itemBuilder: (BuildContext context, int index1) {
                                      return _buildNumListItem(context, index1);
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Container(

                                      );
                                    },
                                    itemCount: avatarList.length<=4?avatarList.length:4),
                              ),
                            )),
                        const SizedBox(width: 3,),
                        //多少人
                        Text(
                          '${dataSource.length}+',
                          style: const TextStyle(color: Color(0xffFE7A24 ), fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '人想认识你',
                          style: const TextStyle(color: Color(0xff333333), fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  userDic['userLevel'].toString()=='0'&&basicDic['virtualDisplay']==1? GestureDetector(
                    onTap: ()async{
                     if (qingshaonianmoshi=='true'){

                     }else{
                       await  Navigator.push(context, MaterialPageRoute(
                           builder: (BuildContext ccontext) {
                             return  VipcenterHome();
                           }));
                       getUserInfo();
                     }
                    },
                    child:
                    Container(
                      // height: 87,
                      margin: EdgeInsets.only(left:15,right: 15, ),
                      // height: 87,
                      child: Image(image: AssetImage('images/makefriends/openvip.png'),fit: BoxFit.fill,),
                    ),
                  ):Container(),

                  Expanded(
                    child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: GridView.count(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //设置滚动方向
                      scrollDirection: Axis.vertical,
                      //设置列数
                      crossAxisCount: 2,
                      //设置内边距
                      padding: const EdgeInsets.all(15),
                      //设置横向间距
                      crossAxisSpacing: 10,
                      //设置主轴间距
                      mainAxisSpacing: 10,
                      childAspectRatio:165.5/227,
                      children: _getData(),
                    ),
                  ),),

                  Container(
                    height: 30,

                  )

                ],
              ),

              userDic['userLevel'].toString()=='0'&&basicDic['virtualDisplay']==1?Positioned(
                  bottom: 30.5,
                  left: 15,right: 15,
                  child: GestureDetector(
                    onTap: ()async{
                      if (qingshaonianmoshi=='true'){

                      }else{
                        await  Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext ccontext) {
                              return  VipcenterHome();
                            }));
                        getUserInfo();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xffFE7A24),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text('查看谁看过我',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                    ),
                  )):Container()

            ],
          )

      ),
    );
  }


  List<Widget> _getData() {
    List<Widget> list = [];
    for (var i = 0; i < dataSource.length; i++) {
      list.add(
          GestureDetector(
            onTap: (){
              godetail(dataSource[i]);
            },
            child: Stack(
              children: [
                Container(
                    decoration:  dataSource[i]['avatar']!=null?BoxDecoration(
                      image: DecorationImage(image: NetworkImage(dataSource[i]['avatar']),fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ):BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 4,left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    child: Text(dataSource[i]['nickname']!=null?dataSource[i]['nickname'].toString():'',
                                      style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(dataSource[i]['age']!=null?dataSource[i]['age'].toString():'',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                  dataSource[i]['career']!=null?Expanded(
                                    child: Text('· '+dataSource[i]['career'].toString(),style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                                  )
                                      :Expanded(
                                    child: Text('· ',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                                  )



                                ],
                              ),
                            ))
                      ],
                    )
//
//         decoration:
//         BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
                ),
                userDic['userLevel'].toString()=='0'&&basicDic['virtualDisplay']==1?ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xff000000).withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(5)),), // 设置透明度为0，仅使用BackdropFilter的效果
                    ),
                  ),
                ):Container(),

                Positioned(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10,top: 13),
                          padding: EdgeInsets.only(left: 7.5,right: 7.3,top: 3,bottom: 3),
                          decoration: BoxDecoration(
                              color:Color.fromRGBO(0, 0, 0, 0.54),
                              borderRadius: BorderRadius.all(Radius.circular(9))
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Image(image: AssetImage('images/makefriends/kanguoNum.png'),width: 12.5,height:7.5),
                              ),
                              SizedBox(width: 5,),
                              Text('共看过${dataSource[i]['seeMeNum']}次',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        )
                      ],
                    ))

              ],
            )),
          );
    }
    return list;
  }

  //共多少人参与的列表
  Widget _buildNumListItem(BuildContext context, int index1) {
    return
      SizedBox(

        width: 28,
        height: 28,
        child:  Stack(
          children: [
            Positioned(
                left: 0,
                top: 0,
                // 将溢出部分剪裁
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Image(image: NetworkImage(avatarList[index1].toString()),width: 28,height: 28,fit: BoxFit.cover,), //宽度设为原来宽度一半
                  ),
                )
            ),
          ],
        ),
      )
    ;
  }



  godetail(infodic)async{
    if (userDic['userLevel']==0&&basicDic['virtualDisplay']==1){
      if (qingshaonianmoshi=='true'){

      }else{
        await  Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext ccontext) {
              return  VipcenterHome();
            }));
        getUserInfo();
      }
    }else{
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return Otherseeme(userId: infodic['issue'].toString(),likeFlag: infodic['likeFlag'].toString(),recordId: infodic['recordId'].toString(),);
          }));
      getList();
    }

  }



  Future<void> _onRefresh() async {
    _pageNo = 1;
    getList();
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent &&
  //       !isLoading) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     _pageNo++;
  //     getList();
  //   }
  // }

  ///获取数据
  void getList() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getReceiveSeeMeList, queryParameters: {
    }, successCallback: (data) async {
      BotToast.closeAllLoading();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          dataSource = data['appMemberExchangeReqVOList'];
          avatarList = data['avatarList'];
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      BotToast.closeAllLoading();
    });
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    super.dispose();
  }
}
