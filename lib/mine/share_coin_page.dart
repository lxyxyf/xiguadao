import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:intl/intl.dart';
class ShareCoinPage extends StatefulWidget {
  const ShareCoinPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<ShareCoinPage> {
  Map<String, dynamic> pointDic = {};
  int selectRow = 0;
  List dataSource = [];
  bool isLoading = false;
  int _pageNo = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getPointDetailPage();
  }

  ///获取积分商品
  void getPointDetailPage() async {
    Map<String, dynamic> dict = {};
    if (selectRow==0){
      dict['pageNo'] = _pageNo.toString();
      dict['pageSize'] = '10';
    }

    if (selectRow==1){
      dict['pageNo'] = _pageNo.toString();
      dict['pageSize'] = '10';
      dict['type'] = '1';
    }

    if (selectRow==2){
      dict['pageNo'] = _pageNo.toString();
      dict['pageSize'] = '10';
      dict['type'] = '2';
    }
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    log('打印传值参数$dict');
    service.get(Apis.getPointDetailPage, queryParameters: dict, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          pointDic = data;
          if (_pageNo == 1) {
            dataSource = data['pointDetailRespVOPageResult']['list'];
          } else {
            if (data.length == 0) {
              EasyLoading.showToast('没有更多数据了');
            } else {
              dataSource.addAll(data['pointDetailRespVOPageResult']['list']);
            }
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }


  chooseSeletRow(row){
    setState(() {
      _pageNo = 1;
      selectRow = row;
      getPointDetailPage();
    });
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          // color: Colors.white,
          child: Stack(
            children: [

              Container(
                  height: 165+MediaQuery.of(context).padding.top,
                  width: screenSize.width,
                  // height: 180+MediaQuery.of(context).padding.top,
                  // margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage('images/share/coin_top.png'),
                        fit: BoxFit.fill,
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                        // color: Colors.white,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child:  Row(
                            children: [
                              const Icon(Icons.arrow_back_ios,color: Colors.white,),

                              const Text(
                                '积分明细',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 26,),

                      Row(

                        children: [
                          SizedBox(width: 15,),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Image(image: AssetImage('images/share/bigcoin.png'),width: 30,height: 31,),
                          ),
                          SizedBox(width: 6.5,),
                          Text(
                              pointDic['myPointNum']!=null?pointDic['myPointNum'].toString():'0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 34.5,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 2.5,),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              '积分',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          )

                        ],
                      ),






                    ],
                  )
              ),


              Positioned(
                top: MediaQuery.of(context).padding.top+165-42,
                  left: 0,right: 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
                    height: 42,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(13.5),topRight: Radius.circular(23.5))
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            chooseSeletRow(0);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text('全部',style: TextStyle(
                                    color: selectRow==0?Color(0xffFE7A24 ):Color(0xff333333 ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                selectRow==0?Container(
                                    width: 30,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFE7A24),
                                        borderRadius: BorderRadius.all(Radius.circular(2)))
                                ):Container()
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            chooseSeletRow(1);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text('增加',style: TextStyle(
                                    color: selectRow==1?Color(0xffFE7A24 ):Color(0xff333333 ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                selectRow==1?Container(
                                    width: 30,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFE7A24),
                                        borderRadius: BorderRadius.all(Radius.circular(2)))
                                ):Container()
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            chooseSeletRow(2);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text('兑换',style: TextStyle(
                                    color: selectRow==2?Color(0xffFE7A24 ):Color(0xff333333 ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                selectRow==2?Container(
                                    width: 30,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFE7A24),
                                        borderRadius: BorderRadius.all(Radius.circular(2)))
                                ):Container()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

              ),


              dataSource.length!=0?Positioned(
                top: MediaQuery.of(context).padding.top+165+15,
                left: 0,right: 0,
                bottom: 30,
                child: MediaQuery.removePadding(
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
                        itemCount: dataSource.length),
                  ),
                ),):Center(
                child: Image(image: AssetImage('images/home_nodata.png')),
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
          margin: const EdgeInsets.only(left: 15,right: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child:Column(

            children: [
              Container(
                  padding: const EdgeInsets.only(top: 20,left: 16,right: 15.5),
                  // color: Colors.white,
                  child:   Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(dataSource[index]['sourceName'],style: TextStyle(
                                    color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.w500
                                ),),
                              ),
                              SizedBox(width: 15,),
                              Container(
                                alignment: Alignment.center,
                                width: 39,height: 18.5,
                                decoration: BoxDecoration(
                                    border: Border.all(color:Color(0xffFE7A24),width: 0.5 ),
                                    borderRadius: BorderRadius.all(Radius.circular(9.25))
                                ),
                                margin: EdgeInsets.only(right: 10),
                                child: Text(dataSource[index]['typeName'],style: TextStyle(
                                    color: Color(0xffFE7A24),fontSize: 12,fontWeight: FontWeight.w500
                                ),),
                              ),
                            ],
                          ),
                          SizedBox(height: 11,),


                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child:
                            Text(
                              timestampToDateString(dataSource[index]['createTime']),
                              style: const TextStyle(color: Color(0xff999999), fontSize: 11.5,fontWeight: FontWeight.w500),
                            ),
                          ),



                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(

                          children: [
                           Container(
                             margin: EdgeInsets.only(bottom: 3),
                             child:
                             Text(dataSource[index]['points'].toString(),style: TextStyle(
                                 color: Color(0xffFE7A24),fontSize: 17.5,fontWeight: FontWeight.bold
                             ),),
                           ),

                            Text('积分',style: TextStyle(
                                color: Color(0xffFE7A24),fontSize: 12,fontWeight: FontWeight.w500
                            ),),
                          ],
                        ),
                      )



                    ],
                  ),


              ),

            ],
          )
      ),
    );
  }

  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _pageNo=1;
    });
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      getPointDetailPage();
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
