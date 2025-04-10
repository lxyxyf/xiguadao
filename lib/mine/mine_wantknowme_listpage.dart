import 'dart:developer';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/user/new_userinfo_page.dart';
import 'package:xinxiangqin/user/wantknowme.dart';
import '../vipcenter/vipcenter_home.dart';

class MineWantknowMelistPage extends StatefulWidget {
  const MineWantknowMelistPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MineWantknowMelistPage> {

  List dataSource = [];
  List avatarList = [];
  int _pageNo = 1;
  Map<String, dynamic> userDic = {};
  String userAreaName = '';//只展示市

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> basicDic = {};
  Map<String, dynamic> mineinfodic = {};
  String qingshaonianmoshi = '';
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    getUserInfo();
    _getBaseInfo();
  }

  updateMemberLike()async{

    // List updateList = [];
    // for (Map<String,dynamic> data in dataSource){
    //   Map<String,dynamic> data1 = {
    //
    //   }
    // }
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateMemberLike, data: {


    }, successCallback: (data) async {
      log('想认识我，更新读过的状态$data');
    }, failedCallback: (data) {
    });
  }

  getmineinfo()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myInformation, queryParameters: {},
        successCallback: (data) async {
          setState(() {
            mineinfodic = data;
            log('判断星座会员等信息'+mineinfodic.toString());
            getList();
          });
        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }



  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      if(mounted){
        setState(() {
          basicDic = data;
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
          getmineinfo();
        }, failedCallback: (data) {});
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("想认识我",textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
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
                          mineinfodic['wantKnowMe']!=null?'${mineinfodic['wantKnowMe']}+':'0+',
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
                      margin: EdgeInsets.only(left:15,right: 15, ),
                      // height: 87,
                      child: Image(image: AssetImage('images/makefriends/openvip.png'),fit: BoxFit.fill,),
                    ),
                  ):Container(),

                  Expanded(
                    child: GridView.count(
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
                  ),
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
                      child: Text('查看谁想认识我',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
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
                Row(
                  children: [
                    Expanded(child:
                    Container(
                        decoration:  dataSource[i]['avatar']!=null?BoxDecoration(
                          image: DecorationImage(image: NetworkImage(dataSource[i]['avatar']),fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ):BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
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
                            )
                        )
//
//         decoration:
//         BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
                    ),)
                  ],
                ),
                userDic['userLevel'].toString()=='0'&&basicDic['virtualDisplay']==1?ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                        decoration: BoxDecoration(color: Color(0xff000000).withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(5)),),
                    ),
                  ),
                ):Container(),


                // dataSource[i]['readStatus']==0?Container(
                //   margin: EdgeInsets.only(left: 5,top: 5),
                //   width: 13.5,
                //   height: 13.5,
                //   decoration: const BoxDecoration(
                //       color: Color(0xffED0D0D),
                //       borderRadius:
                //       BorderRadius.all(Radius.circular(13.5/2))),
                // ):Container(),


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
            return Wantknowme(userId: infodic['id'].toString(),islikeeachother:infodic['likeEachother'].toString(),recordId:infodic['recordId'].toString(),seeMeFlag:infodic['seeMeFlag'].toString());
          }));
      setState(() {
        getmineinfo();
        _pageNo = 1;
        getList();
      });
    }

  }





  Future<void> _onRefresh() async {
    _pageNo = 1;
    getList();
  }

  void _scrollListener() {
    // if (_scrollController.position.pixels ==
    //     _scrollController.position.maxScrollExtent &&
    //     !isLoading) {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   _pageNo++;
    //   getList();
    // }
  }

  ///获取数据
  void getList() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getReceiveLikeList, queryParameters: {
      // 'pageNo': _pageNo.toString(),
      // 'pageSize': '10',
    }, successCallback: (data) async {
      BotToast.closeAllLoading();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          dataSource = data['appMemberExchangeReqVOList'];
          updateMemberLike();
          avatarList = data['avatarList'];
          log('打印错误$dataSource');
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
