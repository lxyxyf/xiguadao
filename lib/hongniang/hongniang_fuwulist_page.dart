import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/hongniang/hongniang_fuwudetail.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';

class HongniangFuwulistPage extends StatefulWidget {
  const HongniangFuwulistPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<HongniangFuwulistPage> {

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
            title: const Text("服务列表",textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
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
                      //设置滚动方向
                      scrollDirection: Axis.vertical,
                      //设置列数
                      crossAxisCount: 2,
                      //设置内边距
                      padding: const EdgeInsets.all(10),
                      //设置横向间距
                      crossAxisSpacing: 15,
                      //设置主轴间距
                      mainAxisSpacing: 10,
                      childAspectRatio:165.5/195.5,
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
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> list = [];
   if(dataSource.length>0){
     for (var i = 0; i < dataSource.length; i++) {
       list.add(
         GestureDetector(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(
                   builder: (BuildContext ccontext) {
                     return  HongniangFuwudetail(serviceId: dataSource[i]['id'].toString(),);
                   }));
             },
             child: Container(
                 margin: EdgeInsets.only(bottom: 4),
                 padding: EdgeInsets.only(left: 12.5,top: 12,right: 12,bottom: 8.5),
                 decoration: const BoxDecoration(
                   color: Colors.white,
                   // image: DecorationImage(image: AssetImage('images/makefriends/testavatar.png')),
                   borderRadius: BorderRadius.all(Radius.circular(5)),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Image(image: NetworkImage(dataSource[i]['matchmakerCover']),width: (screenSize.width-45)/2-12.5-12,height: ((screenSize.width-45)/2-12.5-12-25)*105.5/140.5,),
                     SizedBox(height: 7,),
                     Text(dataSource[i]['name'],
                       style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),
                     SizedBox(height: 5.5,),
                     Container(
                       padding: EdgeInsets.all(3.5),
                       decoration: const BoxDecoration(
                         color: Color.fromRGBO(254, 122, 36, 0.08),
                         // image: DecorationImage(image: AssetImage('images/makefriends/testavatar.png')),
                         borderRadius: BorderRadius.all(Radius.circular(2.5)),
                       ),
                       child:Text('时长:'+dataSource[i]['productDuration'].toString()+'个月',
                         style: TextStyle(color: Color(0xffFE7A24),fontSize: 12,fontWeight: FontWeight.normal),),

                     ),

                     SizedBox(height: 8,),
                     Row(
                       children: [
                         Text('￥',
                           style: TextStyle(color: Color(0xffF24C41),fontSize: 13,fontWeight: FontWeight.w500),),
                         Text(dataSource[i]['supplyPrice'].toString(),
                           style: TextStyle(color: Color(0xffF24C41),fontSize: 16,fontWeight: FontWeight.bold),),
                       ],
                     )

                   ],
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
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return NewUserHomePage(userId: typeSeletRow==0?infodic['issue'].toString():infodic['receive'].toString(),);
    //     }));
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
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMatchmakerProductInfoPage, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
          } else {
            if (data.length == 0) {
              EasyLoading.showToast('没有更多数据了');
            } else {
              dataSource.addAll(data['list']);
            }
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }
}
