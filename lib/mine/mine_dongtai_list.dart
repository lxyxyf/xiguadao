import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import '../publish/publish_page.dart';
import '../shequ/post_detail_page.dart';
import '../utils/utils.dart';

class MineDongtaiList extends StatefulWidget {
  const MineDongtaiList({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MineDongtaiList> {

  Map<String, dynamic> userDic = {};
  int _pageNo = 1;
  bool isLoading = false;
  List dataSource = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getUserInfo();
    _getData();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(  backgroundColor: Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("我的动态",textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.bold),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
            ),

          ),
          body:Stack(
            children: [
              dataSource.length!=0?Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child:  SingleChildScrollView(
                        child: Column(
                          children: [

                            Container(
                              // height: dataSource.length!=0?dataSource.length*280:0,
                                margin: EdgeInsets.all(15),
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: Container(
                                    // padding: const EdgeInsets.only(right: 15.5),
                                      child: RefreshIndicator(
                                        onRefresh: _onRefresh,
                                        child: GridView.builder(
                                          controller:_scrollController,
                                            shrinkWrap: true, // 根据内容自动调整高度
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: dataSource.length,
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2, //每一行的列数
                                              mainAxisSpacing: 10, //主轴方向上的间距
                                              crossAxisSpacing: 10, //交叉轴轴方向上的间距
                                              childAspectRatio: (screenSize.width-45)/ (screenSize.width-45+130), //子元素的宽高比例
                                            ),
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              return _buildItem(context, index);
                                            }),
                                      )),
                                )
                            )


                            // Positioned(
                            //   right: 5,
                            //   bottom: 23.5,
                            //   child:  GestureDetector(
                            //       onTap: (){
                            //         Navigator.push(context,
                            //             MaterialPageRoute(builder: (BuildContext ccontext) {
                            //               return PublishPage();
                            //             }));
                            //       },
                            //       child:Container(
                            //         width: 61,
                            //         height: 61,
                            //         child: Image(image:AssetImage('images/publishActivity.png'),),
                            //       )),
                            // )
                          ],
                        ),
                      )
                  )


              )
                  :Center(
                child: Image(image: AssetImage('images/home_nodata.png')),
              ),

              Positioned(
                right: 5,
                bottom: MediaQuery.of(context).padding.bottom+20,
                child:  GestureDetector(
                    onTap: () async{
                      publishNew();
                    },
                    child:const SizedBox(
                      width: 61,
                      height: 61,
                      child: Image(image:AssetImage('images/publishActivity.png'),),
                    )),
              )
            ],
          )

      ),
    );
  }


  Widget _buildItem(BuildContext context, int index) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async{
        //查看详情
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return PostDetailPage(
                id: dataSource[index]['id'].toString(),
              );
            }));
        setState(() {
          _pageNo = 1;
          _getData();
        });

      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                Container(
                  width: (screenSize.width-45)/2,
                  height: (screenSize.width-45)/2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(dataSource[index]['imgUrl'] != null
                              ? (dataSource[index]['imgUrl']
                              .toString()
                              .contains(',')
                              ? _getImageArray(
                              dataSource[index]['imgUrl'].toString())[0]
                              .toString()
                              : dataSource[index]['imgUrl'])
                              : userDic['avatar'].toString())),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                ),
                dataSource[index]['readStatus']==0?Container(
                  margin: EdgeInsets.only(left: 5,top: 5),
                  width: 13.5,
                  height: 13.5,
                  decoration: const BoxDecoration(
                      color: Color(0xffED0D0D),
                      borderRadius:
                      BorderRadius.all(Radius.circular(13.5/2))),
                ):Container(),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 7.5, top: 9.5),
              child: Text(
                dataSource[index]['content'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xff333333), fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.5, top: 10, right: 7.5),
              child: Row(
                children: [
                  Text(
                    Utils.formatTimeChatStamp(dataSource[index]['createTime']),
                    style: const TextStyle(color: Color(0xff666666), fontSize: 12),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [


                          Image.asset(
                            'images/icon-pinglun.png',
                            width: 10,
                            height: 9,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (dataSource[index]['memberCommentDOList'])
                                .length
                                .toString(),
                            style:
                            const TextStyle(color: Color(0xff666666), fontSize: 12),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  publishNew()async{
    await  Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return  PublishPage();
        }));
    setState(() {
      _pageNo=1;
      _getData();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      _getData();
    }
  }

  void getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          print(data);
          setState(() {
            userDic = data;
          });
        }, failedCallback: (data) {});
  }

  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      _pageNo = 1;
      _getData();
    });
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  ///获取我的帖子数据
  void _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.home, queryParameters: {
      'userId': sharedPreferences.get('UserId').toString(),
      'pageNo': _pageNo.toString(),
      'pageSize': '20',
    }, successCallback: (data) async {
      isLoading = false;
      BotToast.closeAllLoading();
      log('社区数据'+data.toString());
      if (data != null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
          } else {
            if (data['list'].length == 0) {
              BotToast.showText( text: '没有更多数据了');
            } else {
              dataSource.addAll(data['list']);
            }
          }
        });

      }
    }, failedCallback: (data) {});
  }

}
