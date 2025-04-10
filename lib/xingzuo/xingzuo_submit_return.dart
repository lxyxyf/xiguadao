// import 'package:bruno/bruno.dart';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_tijiao_luyin.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'
as iOSDatePicker;

class XingzuoSubmitReturn extends StatefulWidget {
  const XingzuoSubmitReturn({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<XingzuoSubmitReturn> {
  Map<String, dynamic> userDic = {};
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  String birthYear = '';
  String birthDay = '';
  String birthTime = '';
  String birthPlaceShow = '';
  String livePlaceShow = '';

  int bofangstatus = 0;//0未开始，1播放中，2暂停中

  String birthPlace = '';
  String livePlace = '';
  // 声明实例
  CityPickerUtil cityPickerUtils = CityPickers.utils();


  final _player = AudioPlayer();
  int selectRow = 0;
  List statusList = [];
  List pathList = [];
  List pathUrlList = [];
  List pathdurationList = [];

  @override
  void initState() {
    super.initState();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();
    _getData();
  }

  ///获取数据
  void _getData() async {
    Map<String,dynamic> queryParameters = {};
    // queryParameters = {
    //   'pageNo': '1',
    //   'pageSize': '20',
    // };
    SharedPreferences share = await SharedPreferences.getInstance();
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getConstellationTest, queryParameters: queryParameters, successCallback: (data) async {

      log('打印录音data'+data.toString());
      // log('打印录音列表'+data['speechRespVOList'].toString());
      if (data!= null) {
        String pathstr = data['speechRespVOList'][0]['voiceFiles'];
        pathList = pathstr.split(',');
        // Map<String ,dynamic> statusMap = {
        //   'statusType' : 0
        // };
        updateConstellationTest(data['id']);

        for (String pathstr in pathList){
          var duration = await _player.setUrl(pathstr.toString());
          log('打印录音列表'+'${duration!.inSeconds % 60} seconds');
          pathdurationList.add('${duration.inSeconds % 60}');
          statusList.add(0);
        }

        setState(() {
          birthYear = data['birthday'].toString();
          birthDay = data['lunarBirthday'].toString();
          birthTime = data['birthTime'].toString();
          birthPlaceShow = data['areaId'].toString();
          livePlaceShow = data['areaId'].toString();
          String pathstr = data['speechRespVOList'][0]['voiceFiles'];
          pathList = pathstr.split(',');
          statusList;
        });
      }
      EasyLoading.dismiss();

    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }

  updateConstellationTest(id)async{

    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateConstellationTest, data: {
      'id': int.parse(id.toString()),
      'readStatus':1
    }, successCallback: (data) async {
      log('星座回复，更新读过的状态$data');
    }, failedCallback: (data) {
    });
  }


  // String getVoiceDuration(audioUrl)  {
  //   // 创建AudioPlayer实例
  //   final player = AudioPlayer();
  //   // 加载音频文件
  //   player.setUrl(audioUrl);
  //
  //   // 等待音频加载完成
  //   player.load();
  //
  //   // 获取并打印音频时长
  //   Duration? duration = player.duration;
  //   return('Audio duration: ${duration?.inMinutes} minutes, ${duration!.inSeconds % 60} seconds');
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Color(0xFFFFFCB2),
      Color(0xFFF9F8F9),]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0,size.width,size.height));
    return Scaffold(
      // backgroundColor:  Color.fromRGBO(255, 255, 255, 0),
      body:  Container(
        // color:  Color.fromRGBO(255, 255, 255, 0),
          height: screenSize.height,
          width: screenSize.width,
          decoration: BoxDecoration(
            // color: Colors.red,
              image: DecorationImage(
                image: AssetImage('images/xingzuo/allbeijing.png'),
                fit: BoxFit.fill,
              )
          ),
          child: Stack(
              children: [
                Container(
                    width: screenSize.width,
                    // height: 180+MediaQuery.of(context).padding.top,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                            // color: Colors.white,
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_back_ios,color: Colors.white,),

                                const Text(
                                  '星座测算',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 18.5,top: 35.5),
                          height: 118.5,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                              image: DecorationImage(
                                image: AssetImage('images/xingzuo/title.png'),
                                fit: BoxFit.fill,
                              )
                          ),
                        )

                        //

                      ],
                    )
                ),

                Positioned(
                    right: 0,
                    height: 50,
                    left: 0,top: MediaQuery.of(context).padding.top+140,
                    child:Container(
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/dongxiangstar.png'),width: 199.5,fit: BoxFit.fitWidth,
                      ),
                    )
                ),

                Positioned(
                    right: 0,
                    height: 50,
                    left: 0,top: MediaQuery.of(context).padding.top+140,
                    child:Container(
                        alignment: Alignment.center,
                        child: Text('快速解析你的星座动向',style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                    )
                ),

                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+140+50,
                    child:Container(
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/centerbeijing.png'),fit: BoxFit.fill,
                      ),
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+60,
                    child:Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/xingzuo/leftstar.png'),width: 67.5,
                            ),

                            SizedBox(width: 9.5,),
                            Image(image: AssetImage('images/xingzuo/xingzuojiexi.png'),width: 78.5,fit: BoxFit.cover,
                            ),
                            SizedBox(width: 9.5,),
                            Image(image: AssetImage('images/xingzuo/rightstar.png'),width: 67.5,
                            ),
                          ],
                        )
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+40,
                    child:Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                      ),
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+50,
                    child:Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              // onTap: (){
                              //   _showDatePickerForDate(context);
                              // },
                              child:Text(birthYear,
                                style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                            ),
                            SizedBox(width: 22.5,),
                            GestureDetector(
                              // onTap: (){
                              //   _showDatePickerForDate(context);
                              // },
                              child: Text(birthDay,
                                  style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(width: 29.5,),
                            GestureDetector(
                              // onTap: (){
                              //   _showDatePickerForTime(context);
                              // },
                              child:Text(birthTime,style:
                              TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                            )
                          ],
                        )
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+80,
                    child:Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                      ),
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+100,
                    child:Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                      ),
                    )
                ),

                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+110,
                    child:Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              // onTap: (){
                              //   _showAddressPickerBirth();
                              // },
                              child:  Text(birthPlaceShow,style:
                              TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                            ),

                          ],
                        )
                    )
                ),

                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+110+22,
                    child:Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              // onTap: (){
                              //   _showAddressPickerLive();
                              // },
                              child: Text(livePlaceShow,style:
                              TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                            )
                          ],
                        )
                    )
                ),

                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+140+22,
                    child:Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                      ),
                    )
                ),


                Positioned(
                    right: 0,
                    left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+6+0,
                    bottom: 80+MediaQuery.of(context).padding.bottom,

                    child:Container(
                      height: 50*pathList.length.toDouble(),
                      child: ListView.separated(

                          itemBuilder: (BuildContext context, int index) {
                            return _buildItem(context, index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 15,
                            );
                          },
                          itemCount: pathList.length),
                    )



                  // ListView.builder(
                  //   itemCount: pathList.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text('Audio ${index + 1}'),
                  //       trailing: IconButton(
                  //         icon: Icon(Icons.play_arrow),
                  //         onPressed: () {
                  //           // playAudio(audioFiles[index]);
                  //         },
                  //       ),
                  //     );
                  //   },
                  // )
                )


                // Positioned(
                //     right: 0,
                //     left: 0,top: MediaQuery.of(context).padding.top+155+70+140+94,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image(image: AssetImage('images/xingzuo/noresulticon.png'),width: 28,height: 28,),
                //         SizedBox(width: 10,),
                //         Image(image: AssetImage('images/xingzuo/noresulttext.png'),width: 87,height: 21,),
                //
                //       ],
                //     ))
              ]
          )
      ),

    );
  }

  Widget _buildItem(BuildContext context, int index) {
    String duration = '';
    if (pathdurationList.length>0){
      duration = pathdurationList[index];
    }


    // if (getVoiceDuration(pathList[index].toString()).toString()!=null){
    //   duration = pathList.length>0?getVoiceDuration(pathList[index].toString()).toString():'0';
    // }
    log('录音状态'+statusList.toString());
    return statusList.length>0?Container(
      margin: EdgeInsets.all(0),
      child: Row(
        children: [


          // GestureDetector(
          //   child: Text('删除',style: TextStyle(
          //       color:Color(0xffEA1919 ),fontSize: 14,fontWeight: FontWeight.w500
          //   )),
          // ),
          GestureDetector(
              onTap: () {
                // selectRow = index;
                // setState(() {
                //   statusList[1]['statusType'] = 1;
                // });

              },
              child: pathList.length>0
                  ?Container(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      alignment: Alignment.topLeft,
                      duration: const Duration(milliseconds: 200),
                      // width: MediaQuery.sizeOf(context).width/2,
                      height: 50.0,
                      padding: EdgeInsets.only(left: 35),
                      child: FittedBox(
                        fit: BoxFit.none,
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(
                            //   color: const Color(0x44FFFFFF),
                            //   width: 4.0,
                            // ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF2A2E81),
                                const Color(0xFF2A2E81),
                              ],
                            ),
                          ),
                          child:  Row(
                            children: [

                              SizedBox(
                                height: 50,
                                child: Icon(
                                  Icons.multitrack_audio_rounded,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2,),
                              SizedBox(
                                height: 50,
                                child: Icon(
                                  Icons.multitrack_audio_rounded,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2,),
                              SizedBox(
                                height: 50,
                                child: Icon(
                                  Icons.multitrack_audio_rounded,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2,),
                              SizedBox(
                                height: 50,
                                child: Icon(
                                  Icons.multitrack_audio_rounded,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2,),
                              SizedBox(
                                height: 50,
                                child: Icon(
                                  Icons.multitrack_audio_rounded,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 2,),
                              Text(duration.toString()+'S',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),


                            ],
                          ),
                        ),
                      ),
                    ),
                    // Text(duration.toString()+'S',style: TextStyle(color: Colors.white),),
                    // ListTile(
                    //
                    //   title: Text('Audio'+duration.toString(),style: TextStyle(color: Colors.white),),
                    //   trailing: IconButton(
                    //     icon: Icon(Icons.play_arrow),
                    //     onPressed: () {
                    //       // playAudio(audioFiles[index]);
                    //     },
                    //   ),
                    // )
                  ],
                ),
              )
                  :Container()
          ),
          SizedBox(width: 10,),

          statusList[index] == 0?GestureDetector(
              onTap: (){
                print('点击播放了');
                setState(() {
                  statusList.replaceRange(index, index+1, [1]);
                });
                //还未开始，点击播放
                _player.stop();
                _player.setUrl(pathList[index].toString());
                _player.play();
              },
              child: Text('播放',style: TextStyle(
                  color:Colors.white,fontSize: 14,fontWeight: FontWeight.w500
              ),)
          )
              :statusList[index] == 1?GestureDetector(
              onTap: (){
                print('点击暂停了');
                //播放中，点击暂停
                setState(() {
                  statusList.replaceRange(index, index+1, [2]);
                });

                _player.pause();
                // _player.setUrl(pathList[index].toString());

              },
              child: Text('暂停',style: TextStyle(
                  color:Colors.white,fontSize: 14,fontWeight: FontWeight.w500)))
              :GestureDetector(
              onTap: (){
                print('点击继续了');
                //暂停中，点击继续
                setState(() {
                  statusList.replaceRange(index, index+1, [1]);
                });
                _player.play();
              },
              child: Text('继续播放',style: TextStyle(
                  color:Colors.white,fontSize: 14,fontWeight: FontWeight.w500
              ))
          )

        ],
      ),
    ):Container();
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
      getUserInfo();
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
