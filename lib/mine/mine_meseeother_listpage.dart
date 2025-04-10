import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/user/new_userinfo_page.dart';
class MineMeseeotherListpage extends StatefulWidget {
  const MineMeseeotherListpage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MineMeseeotherListpage> {

  List dataSource = [];
  int _pageNo = 1;

  String userAreaName = '';//只展示市

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getList();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(  backgroundColor: Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("我看过谁",textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
            ),

          ),
          body:Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //设置滚动方向
                      scrollDirection: Axis.vertical,
                      //设置列数
                      crossAxisCount: 2,
                      //设置内边距
                      padding: const EdgeInsets.all(10),
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

              // Positioned(
              //   bottom: MediaQuery.of(context).viewInsets.bottom,
              //     child: Container(
              //   height: 30,
              //       color: Colors.red,
              // ))
            ],
          )

      ),
    );
  }


  List<Widget> _getData() {
    List<Widget> list = [];
    if (dataSource.length>0){
      for (var i = 0; i < dataSource.length; i++) {
        list.add(
            GestureDetector(
              onTap: (){
                godetail(dataSource[i]);
              },
              child: Container(
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
                    ),
                  )
//
//         decoration:
//         BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
              )),
            );
      }
    }
    return list;
  }



  godetail(infodic){
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return UserInfoPage(userId: typeSeletRow==0?infodic['issue'].toString():infodic['receive'].toString(),);
    //     }));

    //NewUserHomePage
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return NewUserinfoPage(userId: infodic['id'].toString(),);
        }));
  }





  Future<void> _onRefresh() async {
    _pageNo = 1;
    getList();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      getList();
    }
  }

  ///获取数据
  void getList() async {
    BotToast.closeAllLoading();
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getIsSueSeeMeList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
    }, successCallback: (data) async {
      BotToast.closeAllLoading();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          dataSource = data;
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
