
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';

import '../widgets/network_image_widget.dart';



class ManagerActivityDaishenhePage extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  ManagerActivityDaishenhePage({super.key, required this.userInfoDic});
  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<ManagerActivityDaishenhePage> {
  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['我参与的','我创建的'];
  int typeSeletRow = 0;
  String topImage = '';

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }
  String getFormattedDate(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('MM.dd');
    return fullYearFormat.format(date);
  }

  String getFormattedDate1(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('HH:mm');
    return fullYearFormat.format(date);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("活动详情",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
        ),

      ),

      body: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          // color: const Color(0xFFFAFAFA),
            children:[
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 85,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child:
                            Stack(
                              children: [
                                Container(

                                  height: 197.5,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  widget.userInfoDic['activeSource'].toString() =='1'
                                      ? NetImage(
                                    widget.userInfoDic['activeCover'],
                                    width: MediaQuery.of(context).size.width,
                                    height: 195,
                                  )
                                      : Image(image: AssetImage('images/activity/new_activitydetail_top.png')
                                    ,width: MediaQuery.of(context).size.width,height: 195,fit: BoxFit.fill,),
                                  // Image(image:NetworkImage(widget.userInfoDic['activeCover']),width: MediaQuery.of(context).size.width,fit: BoxFit.fill,)
                                ),
                                Positioned(
                                    top: 119.5,
                                    left: 0,right: 0,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            child:
                                            Container(
                                                margin: EdgeInsets.only(left: 16),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                                    border: Border.all(width: 1,color: Colors.white)
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                                  child: Image(
                                                      image: NetworkImage(
                                                          widget.userInfoDic['promoterAvatar']),width: 45.1,height: 45.1,fit: BoxFit.cover
                                                  ),
                                                )
                                            )
                                        ),

                                        Positioned(
                                            child:
                                            Container(
                                              margin: EdgeInsets.only(left: 45.1),
                                              width: 14,height: 14.5,
                                              // decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                              //     border: Border.all(width: 0.5,color: Colors.white)
                                              // ),
                                              child: Image(image:
                                              widget.userInfoDic['headSex'].toString()=='1'?const AssetImage('images/activity_man.png')
                                                  :const AssetImage('images/activity_woman.png'),),
                                            )
                                        ),

                                        Positioned(
                                            child:
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(left: 67),
                                                    child: Text(widget.userInfoDic['headName'],
                                                      style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 50,height: 20,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white,width:1,),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    margin: EdgeInsets.only(left: 67),
                                                    child: Text('发起人',
                                                      style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),)
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),



                          Container(

                              width: MediaQuery.of(context).size.width,
                              child:
                              Container(
                                padding: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.5),topRight: Radius.circular(10.5))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 15,top: 13.5),
                                            alignment: Alignment.center,
                                            width: 62.5,height: 25.5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(image: AssetImage('images/activity/activity_detail_status.png'))
                                            ),
                                            child: Text('${widget.userInfoDic['statusName']}',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xffFE7A24)),)
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width - 8.5-15-62.5-15,
                                          margin: EdgeInsets.only(left: 8.5,top: 11.5),
                                          child: Text('${widget.userInfoDic['name']}',
                                            style: TextStyle(fontSize: 17.5,fontWeight: FontWeight.w700,color: Color(0xff333333)),),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 9.5,),
                                    Container(
                                        height: widget.userInfoDic['isInitiator']==true&&widget.userInfoDic['isEnroll'] ==true&&widget.userInfoDic['activityAvatar'].length>1?85:55,
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: RefreshIndicator(
                                            onRefresh: _onRefresh,
                                            child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                controller: _scrollController,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return _buildTypeItem(context, index);
                                                },
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return Container(

                                                  );
                                                },
                                                itemCount: widget.userInfoDic['activityAvatar'].length),
                                          ),
                                        )),



                                    Container(
                                        alignment: Alignment.topLeft,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(13.5),
                                          color:Colors.white,
                                        ),
                                        margin: const EdgeInsets.only(top: 0,left: 15,right: 15),
                                        padding: const EdgeInsets.only(bottom: 16.5),
                                        child: Container(
                                          child: Column(
                                            children: [


                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 14.5),
                                                    child: const Image(image: AssetImage('images/mymanager_time.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动时间：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text(
                                                      '${getFormattedDate(DateTime.parse(widget.userInfoDic['activeDate'].toString()))} ${getFormattedDate1(DateTime.parse(widget.userInfoDic['activeTimeBegin'].toString()))}~${getFormattedDate(DateTime.parse(widget.userInfoDic['activeTimeEnd'].toString()))} ${getFormattedDate1(DateTime.parse(widget.userInfoDic['activeTimeEnd'].toString()))}',style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 19.5),
                                                    child: const Image(image: AssetImage('images/manager_activity_address.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动地点：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    width: MediaQuery.of(context).size.width - 30 - 125,
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text(widget.userInfoDic['address'],style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 15.5),
                                                    child: const Image(image: AssetImage('images/manager_activity_personnum.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动人数：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text('${widget.userInfoDic['menNum']}男${widget.userInfoDic['womenNum']}女',style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 0,top: 15.5),
                                                        child: const Image(image: AssetImage('images/activity/pay_type.png'),width: 13.5,height: 13.5,),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                        child: const Text('付款类型：',style: TextStyle(
                                                            color:Color(0xff999999),
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      ),

                                                      Container(
                                                        margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                        child: Text(widget.userInfoDic['costShare'].toString()=='1'?'AA制':'发起人全款',style: const TextStyle(
                                                            color:Color(0xff333333),
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      ),
                                                    ],
                                                  ),


                                                  Row(
                                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [

                                                      Container(
                                                        margin: const EdgeInsets.only(top: 15.5),
                                                        child: const Text('人均¥',style: TextStyle(
                                                            color:Color(0xffF62525),
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold
                                                        ),),
                                                      ),

                                                      Container(
                                                        margin: const EdgeInsets.only(right: 15,top: 13.5),
                                                        child: Text('${widget.userInfoDic['activeCost']}',style: const TextStyle(
                                                            color:Color(0xffF62525),
                                                            fontSize: 17.5,
                                                            fontWeight: FontWeight.bold
                                                        ),),
                                                      ),
                                                    ],
                                                  )

                                                ],
                                              ),

                                            ],
                                          ),
                                        )
                                    ),

                                    const SizedBox(height: 11,),


                                    Container(
                                      transformAlignment: Alignment.centerLeft,
                                      width:MediaQuery.of(context).size.width,
                                      height: 45,
                                      color: Color(0xFFFAFAFA),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(left: 14.5,top: 15),
                                      child: const Text('活动详情',style: TextStyle(
                                          color:Color(0xff333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13.5),
                                        color:Colors.white,
                                      ),
                                      padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                                      child: Container(
                                        child: Text(widget.userInfoDic['activeDesc'],style: const TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                    ),
                                  ],

                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  )),

              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child:
                  Container(
                    margin: const EdgeInsets.all(0),
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: (){
                        closeActivity();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        margin: const EdgeInsets.only(bottom: 32,left: 25,right: 25,top: 17.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          color:const Color.fromRGBO(153, 153, 153, 0.24),
                        ),
                        child: const Text('关闭活动',textAlign: TextAlign.center,style: TextStyle(
                            color:Color(0xff999999),
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    ),
                  ))
            ]
        ),
      ),



    );
  }



  Widget _buildTypeItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          typeSeletRow = index;
          //
          // //评论详情
          // _getData();
        },
        child: Container(
          child:  Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          child: SizedBox(
                              width: 45.1,
                              height: 45.1,
                              child: ClipOval(
                                child: Image(image: NetworkImage(widget.userInfoDic['activityAvatar']![index]['avatar']),width: 45.1,height: 45.1,fit: BoxFit.cover,),
                              )
                          )),

                      Positioned(
                        width: 12.5,
                        height: 12.5,
                        right: 0,
                        top: 0,
                        child: Image(image: widget.userInfoDic['activityAvatar']![index]['sex'].toString()=='1'?const AssetImage('images/activity_man.png'):const AssetImage('images/activity_woman.png'),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4,),
                  // Container(
                  //   padding: EdgeInsets.only(top: 4.5,left: 7,right: 7,bottom: 4.5),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //     border: Border.all(
                  //       color: Color(0xffFE7A24), // 边框颜色
                  //       width: 0.5, // 边框宽度
                  //     ),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         'images/activity_chat.png',
                  //         width: 8.5,
                  //         height: 8.5,
                  //       ),
                  //       SizedBox(width: 5,),
                  //       Text(
                  //         '聊天',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(color: Color(0xffFE7A24),fontSize: 9,fontWeight: FontWeight.w500),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              )),
        )
    );
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
    }
  }

  //关闭活动
  closeActivity() async{
    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("关闭活动"),
          content: const Text("确定关闭当前活动？"),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
                cancelBaoming();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );

  }

  cancelBaoming()async{
    EasyLoading.show();
    Map<String, dynamic> map = {};
    log('传递的信息${widget.userInfoDic['id']}');
    // map['id'] = widget.userInfoDic['id'];
    NetWorkService service = await NetWorkService().init();
    service.delete(Apis.closeActivity, queryParameters: {
      'id': widget.userInfoDic['id'],
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '关闭成功');
      Navigator.pop(context);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });
  }


}
