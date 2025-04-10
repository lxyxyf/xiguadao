import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/home/forgetpassword.dart';
import 'package:xinxiangqin/home/qingshaonian_open.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/shequ/post_detail_page.dart';
import 'package:bookfx/bookfx.dart';
import 'package:dio/dio.dart';
import '../home/qingshaonian_dialog.dart';
import '../publish/publish_page.dart';
import '../tools/event_tools.dart';
import '../widgets/yk_easy_loading_widget.dart';

class ShequHomePage extends StatefulWidget {
  const ShequHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<ShequHomePage> {
  List dataSource = [];
  var dio = Dio(option);
  int _pageNo = 1;

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //   SystemUiOverlay.top
    // ]);
    _scrollController.addListener(_scrollListener);
    getData();
    getmineinfo();
    getunreadCount();




    // Future.delayed(Duration.zero, () {
    //   //执行代码写在这里
    //   showQingshaonian();
    // });
  }

  //  deepspeakTest() async {
  //   final String url = "http://192.168.12.21:8200/api/ai/start-general-conversation";
  //   final Map<String, dynamic> data = {
  //     // 在这里添加你的POST请求数据
  //     "question": "天气怎么样",
  //     "conversationId": "7485911293002563635",
  //     // "channel": "your-channel-name"
  //   };
  //
  //   try {
  //     final response = await dio.post(url,
  //         data: data,
  //         options: Options(
  //           headers: {
  //             'Accept': 'text/event-stream', // 这是SSE的Accept头，表示接受SSE事件流
  //             'Content-Type': 'application/json', // 表示发送的数据为json格式
  //           },
  //           responseType: ResponseType.stream,
  //         ));
  //
  //     // 响应的data属性现在是一个Stream<Uint8List>类型
  //     final stream = response.data;
  //     stream.listen((Uint8List chunk) {
  //       // 将接收到的字节流转换为字符串
  //       final String event = utf8.decode(chunk);
  //       print("Received event: $event");
  //
  //       // 解析事件数据（假设服务器发送的是JSON格式的字符串）
  //       final Map<String, dynamic> eventData = jsonDecode(event);
  //       // 在这里处理事件数据
  //     }, onError: (error) {
  //       print("SSE error: $error");
  //     }, onDone: () {
  //       print("SSE connection closed.");
  //     }, cancelOnError: false);
  //   } on DioError catch (e) {
  //     print("Request error: ${e.message}");
  //   }
  // }

  // deepspeakTest()async {
  //   final response = await dio.post(
  //     'http://192.168.12.21:8200/api/ai/start-general-conversation',
  //     options: Options(
  //       headers: {
  //         'Accept': 'text/event-stream', // 标识接受事件流 ‌:ml-citation{ref="2,5" data="citationList"}
  //         'Content-Type': 'application/json', // POST 请求需指定 JSON 格式 ‌:ml-citation{ref="3,5" data="citationList"}
  //       },
  //       responseType: ResponseType.stream, // 启用流式响应 ‌:ml-citation{ref="6" data="citationList"}
  //     ),
  //     data: {
  //       "question": "天气怎么样",
  //       "conversationId": "7485911293002563635",
  //     }, // 请求体数据 ‌:ml-citation{ref="3" data="citationList"}
  //   );
  //
  //   final stream = response.data?.stream;
  //   stream?.listen(
  //         (chunk) => _processChunk(utf8.decode(chunk)),
  //     onError: (e) => print('Error: $e'),
  //     onDone: () => print('Stream closed'),
  //   );
  // }
  //
  // void _processChunk(String data) {
  //   print('Received data: $data');
  //   // final events = data.split('\n\n'); // 按事件分隔符拆分
  //   // for (var event in events) {
  //   //   if (event.startsWith('data:')) {
  //   //     final payload = event.substring(5).trim();
  //   //     print('Received data: $payload');
  //   //   }
  //   // }
  // }


  showQingshaonian(){
    showDialog(
        barrierDismissible:false,
        context: context,
        builder: ((ctx) {
          return QingshaonianDialog(

            OntapCommit: ()async{
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ccontext) {
                    return QingshaonianOpen(
                      havePhoneNumber: true,
                      photoNumber: '',
                    );
                  }));
            },
            CancelCommit: ()async{
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext ccontext) {
              //       return QingshaonianOpen(
              //         havePhoneNumber: true,
              //         photoNumber: '',
              //       );
              //     }));
            },
            yinsizhengceClick: (){

            },
            fuwuxieyiClick: (){

            },
          )


          ;
        }));
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

  getmineinfo()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myInformation, queryParameters: {},
        successCallback: (data) async {
          if (mounted){ setState(() {
            if (data['commentMeFlag']==1||data['likeMeFlag']==1){
              eventTools.emit('showMinePointHave');
            }
            if (data['commentMeFlag']!=1&&data['likeMeFlag']!=1){
              eventTools.emit('showMinePointNo');
            }
          });}
        }, failedCallback: (data) {});
  }

  List<Widget> widgets = [];

  BookController bookController = BookController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAFAFA),
        child: Stack(
          children: [
            Container(),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  height: MediaQuery.of(context).padding.top + 24,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(),
                      const Positioned(
                          left: 0,
                          bottom: 7.5,
                          child: Text('社区',
                              style: TextStyle(
                                  color: Color(0xff0C0C2C),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      Positioned(
                          left: 2.5,
                          bottom: 5,
                          child: Image.asset(
                            'images/home_tip.png',
                            width: 60,
                            height: 20,
                          ))
                    ],
                  ),
                )),
            dataSource.length!=0?Positioned(
                left: 15,
                right: 0,
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: StaggeredGridView.countBuilder(
                        controller: _scrollController,
                        shrinkWrap:true,
                        crossAxisCount: 4,
                        itemCount: dataSource.length,
                        itemBuilder: (BuildContext context, int index) =>  _buildItem(context, index),
                        staggeredTileBuilder: (int index) =>

                            StaggeredTile.fit(2),
                        // new StaggeredTile.count(2, index.isEven ? 2: 1),
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0,
                      ),
                    ),
                  ),
                ))
                : Center(
              child: Image(image: AssetImage('images/home_nodata.png')),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: GestureDetector(
                onTap: ()async{
                  // deepspeakTest();
                  await  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ccontext) {
                        return  PublishPage();
                      }));
                  setState(() {
                    _pageNo=1;
                    getData();
                  });
                },
                child: const Image(  width: 70,
                  height: 70,
                  fit: BoxFit.cover,image: AssetImage('images/add_icon.png'),),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Map<String, dynamic> map = dataSource[index];
    return map['empty']!='1'?GestureDetector(
      onTap: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return PostDetailPage(
                id: map['id'].toString(),
              );
            }));
        // setState(() {
        //   _pageNo=1;
        //   getData();
        // });

      },
      child: Container(
        margin: EdgeInsets.only(top: 14.5,right: 15),
        padding: EdgeInsets.only(bottom: 10),
        width: (MediaQuery.of(context).size.width - 45)/2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
                Radius.circular(10))
        ),
        // padding: EdgeInsets.only(bottom: 15),
        // margin: EdgeInsets.only(),
        child: Column(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width - 45)/2,
              height: 185,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                child: Image(image: NetworkImage(map['imgUrl'] != null
                    ? (map['imgUrl'].toString().contains(',')
                    ? _getImageArray(map['imgUrl'].toString())[0]
                    .toString()
                    : map['imgUrl'])
                    : map['avatar'].toString()),width: (MediaQuery.of(context).size.width - 45)/2,
                  height: 185,fit: BoxFit.cover,),
              ),
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            ),

            Container(
                margin: EdgeInsets.only(left: 8.5,top: 9.5),
                alignment: Alignment.topLeft,
                child: Text(
                  map['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xff333333), fontSize: 15),)),

            SizedBox(height: 6.5,),
            Container(
                margin: EdgeInsets.only(left: 8.5),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.5/2),
                            child:
                            Image(image: NetworkImage(map['avatar'].toString()),width: 22.5,height: 22.5,fit: BoxFit.cover,),
                          ),
                        ),
                        // SizedBox(width: 5.5,),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only( right: 5,left: 5.5),
                          width: (MediaQuery.of(context).size.width - 45)/2 - 50 - 50,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(47 / 2.0))),
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            map['nickname']!=null?map['nickname']:'',
                            style: const TextStyle(color: Color(0xff666666), fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Image(image: AssetImage('images/icon-pinglun.png'),width: 12,height: 11,fit: BoxFit.cover,),
                        ),
                        SizedBox(width: 5.5,),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only( right: 10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(47 / 2.0))),
                          child: Text(
                            map['memberCommentDOList'].length.toString(),
                            style: const TextStyle(color: Color(0xff666666), fontSize: 15.0,fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                  ],
                )

            ),

            // SizedBox(height: 4.5,),

          ],
        ),
      ),
    ):Container()
    ;
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
    getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      getData();
    }
  }

  void getData() async {
    MTEasyLoading.showLoading('加载中');

    NetWorkService service = await NetWorkService().init();
    service.get(
      Apis.home,
      queryParameters: {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
        'auditStatus': '1',
        'appType': '1'
      },
      successCallback: (data) async {
        isLoading = false;
        MTEasyLoading.dismiss();
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
      },
      failedCallback: (data) {
        log('社区错误'+data.toString());
        MTEasyLoading.dismiss();
      },
    );
  }


  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    EasyLoading.dismiss();
    MTEasyLoading.dismiss();
    _scrollController.dispose();
    super.dispose();
  }
}
