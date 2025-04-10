// import 'package:bruno/bruno.dart';
// import 'dart:ffi';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
// import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../widgets/yk_easy_loading_widget.dart';


class XingzuoTijiaoLuyin extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  // XingzuoTijiaoLuyin({required this.userInfoDic});

  XingzuoTijiaoLuyin({
    Key? key,
    required this.onRecorderEnd,required this.userInfoDic
  }) : super(key: key);
  void Function(String? path, int? duration) onRecorderEnd;
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<XingzuoTijiaoLuyin> {
  Map<String, dynamic> userDic = {};
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();


  //录音部分
  OverlayEntry? _overlayEntry;

  /// 手势
  ValueNotifier<bool>? _onLongPressSubject;
  ValueNotifier<Offset?>? _longPressMoveOffsetSubject;

  /// 录音
  RecorderController? _recorderController;
  final _player = AudioPlayer();
  bool _hasPermission = false;
  bool isCancelRecord = false;
  List pathList = [];
  List pathUrlList = [];
  List pathdurationList = [];
  List statusList = [];
  final GlobalKey _keyOfSendArea = GlobalKey();

  Timer? _timer;
  List _sounds=[];

  @override
  void initState() {
    super.initState();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();


    _onLongPressSubject = ValueNotifier<bool>(false);
    _longPressMoveOffsetSubject = ValueNotifier<Offset?>(null);

    _recorderController = RecorderController();
  }

  @override
  void dispose() {
    eventTools.off('changeUserInfo');
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;

    _onLongPressSubject?.dispose();
    _onLongPressSubject = null;

    _longPressMoveOffsetSubject?.dispose();
    _longPressMoveOffsetSubject = null;

    _recorderController?.dispose();
    _recorderController = null;
    MTEasyLoading.dismiss();
    super.dispose();
  }

  void _getPermission() async {
    var p = await _recorderController?.checkPermission();
    _hasPermission = p ?? false;
  }

  ///显示录音悬浮布局
  _buildOverLayView(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return Material(
            type: MaterialType.canvas,
            color: const Color(0x99000000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                StreamBuilder<Duration>(
                  stream: _recorderController?.onCurrentDuration,
                  builder: (_, snapshotDuration) {
                    double extended = ((snapshotDuration.data?.inSeconds ?? 0) >
                        60)
                        ? 40.0
                        : ((snapshotDuration.data?.inSeconds ?? 0).toDouble() /
                        60.0 *
                        40.0);
                    int length = 24;
                    var waveData =
                    (_recorderController?.waveData ?? []).toList();
                    waveData.insertAll(0, List.generate(length, (index) => 0));
                    List<double> amplitudes =
                    waveData.skip(waveData.length - length).toList();
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.0 + extended,
                        vertical: 25.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xDDFD5DA5),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: SizedBox(
                        height: 40.0,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var amplitude = amplitudes[index];
                            return Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                width: 2.0,
                                height: 8.0 +
                                    (amplitude *
                                        ((amplitude <= 0.08 &&
                                            amplitude >= 0.04)
                                            ? 3
                                            : 1)) *
                                        32.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 2.0,
                            );
                          },
                          itemCount: length,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 0,
                  height: 0,
                  margin: const EdgeInsets.only(top: 12.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xDDFD5DA5),
                        width: 12,
                        style: BorderStyle.solid,
                      ),
                      right: BorderSide(
                        color: Colors.transparent,
                        width: 12,
                        style: BorderStyle.solid,
                      ),
                      left: BorderSide(
                        color: Colors.transparent,
                        width: 12,
                        style: BorderStyle.solid,
                      ),
                      top: BorderSide(
                        color: Colors.transparent,
                        width: 12,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                ValueListenableBuilder<Offset?>(
                  valueListenable: _longPressMoveOffsetSubject!,
                  builder: (_, moveOffset, child) {
                    bool inCancel = false;
                    if (moveOffset != null) {
                      var move = moveOffset;
                      var box =
                      _keyOfSendArea.currentContext?.findRenderObject();
                      if (box != null && (box is RenderBox)) {
                        var local = box.globalToLocal(move);
                        if (box.hitTest(BoxHitTestResult(), position: local)) {
                          inCancel = false;
                          isCancelRecord = inCancel;
                        } else {
                          inCancel = true;
                          isCancelRecord = inCancel;
                        }
                      }
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 30.0,
                        //   child: inCancel
                        //       ? const Text(
                        //     '松开  取消',
                        //     style: TextStyle(
                        //       color: Color(0xFFFFFFFF),
                        //       fontSize: 15.0,
                        //       fontWeight: FontWeight.normal,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   )
                        //       : const SizedBox.shrink(),
                        // ),
                        // SizedBox(
                        //   width: 60.0,
                        //   height: 60.0,
                        //   child: Center(
                        //     child: Icon(
                        //       Icons.remove_circle_rounded,
                        //       color: inCancel
                        //           ? const Color(0x88FFFFFF)
                        //           : const Color(0x33000000),
                        //       size: inCancel ? 60.0 : 40.0,
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 30.0),
                        SizedBox(
                          width: double.infinity,
                          height: 30.0,
                          child: inCancel
                              ? const SizedBox.shrink()
                              : const Text(
                            '松开  发送',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        /// 语音发送区域
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: MediaQuery.sizeOf(context).width,
                          height: 148.0,
                          padding: EdgeInsets.only(top: inCancel ? 20.0 : 0),
                          child: FittedBox(
                            fit: BoxFit.none,
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              key: _keyOfSendArea,
                              width: 1080.0,
                              height: 1080.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1080.0),
                                border: Border.all(
                                  color: inCancel
                                      ? Colors.transparent
                                      : const Color(0x44FFFFFF),
                                  width: 4.0,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF999999),
                                    const Color(0xFFFFFFFF),
                                  ],
                                ),
                              ),
                              child: const Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: 148.0,
                                  child: Icon(
                                    Icons.multitrack_audio_rounded,
                                    size: 24.0,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _hideVoiceView() async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
    }
  }


  //
  // ///申请权限
  // void requestPermission(Permission permission) async {
  //   PermissionStatus status = await permission.request();
  //   if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // }


  void _startRecorder({
    required LongPressStartDetails details,
  }) async {
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    //   avAudioSessionCategoryOptions:
    //       AVAudioSessionCategoryOptions.allowBluetooth |
    //           AVAudioSessionCategoryOptions.defaultToSpeaker,
    //   avAudioSessionMode: AVAudioSessionMode.spokenAudio,
    //   avAudioSessionRouteSharingPolicy:
    //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
    //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    //   androidAudioAttributes: const AndroidAudioAttributes(
    //     contentType: AndroidAudioContentType.speech,
    //     flags: AndroidAudioFlags.none,
    //     usage: AndroidAudioUsage.voiceCommunication,
    //   ),
    //   androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    //   androidWillPauseWhenDucked: true,
    // ));
    try {
      var path = '';
      var tempDir = await getTemporaryDirectory();
      String voiceDir = '${tempDir.path}/medias/voice/';
      if (!(await Directory(voiceDir).exists())) {
        await Directory(voiceDir).create(recursive: true);
      }
      path = '$voiceDir${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorderController?.record(
        path: path,
        sampleRate: 44100,
        bitRate: 48000,
      );
      _onLongPressSubject?.value = true;

      ///显示录音悬浮布局
      // ignore: use_build_context_synchronously
      _buildOverLayView(context);
    } catch (err) {
      debugPrint('startRecorder error: ${err.toString()}');
      _stopRecorder(
        details: LongPressEndDetails(globalPosition: details.globalPosition),
      );
    }
  }

  Future<void> _stopRecorder({
    required LongPressEndDetails details,
  }) async {
    _onLongPressSubject?.value = false;
    try {
      var path = await _recorderController?.stop();
      log('录音的path'+path.toString());
      if (isCancelRecord == true){

      }else{
        if (_recorderController?.recordedDuration.inSeconds.toString()=='0'){

        }else{
          setState(() {
            pathList.add(path.toString());
            statusList.add(0);
            pathdurationList.add(_recorderController?.recordedDuration.inSeconds.toString());

          });
        }

      }
      log('录音的数组'+pathList.toString());

      var move = _longPressMoveOffsetSubject?.value ?? Offset.zero;
      var box = _keyOfSendArea.currentContext?.findRenderObject();
      if (box != null && (box is RenderBox)) {
        var local = box.globalToLocal(move);
        if (box.hitTest(BoxHitTestResult(), position: local)) {
          if ((_recorderController?.recordedDuration.inSeconds ?? 0) > 1) {

            widget.onRecorderEnd(
              path,
              _recorderController?.recordedDuration.inSeconds,
            );
          }
        }
      }
    } on Exception catch (err) {
      debugPrint('stopRecorder error: $err');
    }
    _hideVoiceView();

  }



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
          child: widget.userInfoDic['userId']!=null?Stack(

              children: [
                SingleChildScrollView(
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height,
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
                                child: Image(image: AssetImage('images/xingzuo/touxiangbeijing.png'),width: 111,
                                ),
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+15,
                              child:Container(
                                width: size.width,
                                alignment: Alignment.center,
                                child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                ),
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+20,
                              child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(widget.userInfoDic['birthday'],style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                      SizedBox(width: 22.5,),
                                      Text(widget.userInfoDic['lunarBirthday']!=null?widget.userInfoDic['lunarBirthday']:'未选择',style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                                      SizedBox(width: 29.5,),
                                      Text(widget.userInfoDic['birthTime'],style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500)),
                                    ],
                                  )
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+50,
                              child:Container(
                                width: size.width,
                                alignment: Alignment.center,
                                child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                ),
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+75,
                              child:Container(
                                width: size.width,
                                alignment: Alignment.center,
                                child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                ),
                              )
                          ),

                          // Positioned(
                          //     right: 0,
                          //     left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+80,
                          //     child:Container(
                          //         width: size.width,
                          //         alignment: Alignment.center,
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Text(widget.userInfoDic['areaId'].toString(),style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                          //             SizedBox(width: 15,),
                          //             Text(widget.userInfoDic['nativePlace'].toString(),style: TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                          //           ],
                          //         )
                          //     )
                          // ),

                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+80,
                              child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child:  Text(widget.userInfoDic['areaId'].toString(),style:
                                        TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                      ),
                                      // SizedBox(width: 15,),
                                      // GestureDetector(
                                      //   onTap: (){
                                      //     _showAddressPickerLive();
                                      //   },
                                      //   child: Text(livePlaceShow==''?'现居地':livePlaceShow,style:
                                      //   TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                                      // )
                                    ],
                                  )
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+80+25,
                              child:Container(
                                  width: size.width,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // GestureDetector(
                                      //   onTap: (){
                                      //     _showAddressPickerBirth();
                                      //   },
                                      //   child:  Text(birthPlaceShow==''?'出生地':birthPlaceShow,style:
                                      //   TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500),),
                                      // ),
                                      // SizedBox(width: 15,),
                                      GestureDetector(
                                        child: Text(widget.userInfoDic['nativePlace'].toString(),style:
                                        TextStyle(color: Color(0xff6A6AD7),fontSize: 15,fontWeight: FontWeight.w500,)),
                                      )
                                    ],
                                  )
                              )
                          ),

                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+105+25,
                              child:Container(
                                width: size.width,
                                alignment: Alignment.center,
                                child: Image(image: AssetImage('images/xingzuo/hengxian.png'),width: 256.6,
                                ),
                              )
                          ),


                          Positioned(
                              right: 0,
                              left: 0,top: MediaQuery.of(context).padding.top+155+70+40+111+105+5,
                              bottom: 70+MediaQuery.of(context).padding.bottom,

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
                        ],
                      ),
                    )
                ),


                Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).viewInsets.bottom+12.5,
                    height: 81.5,
                    child: Container(
                      margin: EdgeInsets.only(left: 25,right: 25,bottom: 12.5),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              await submitAudio();

                              submitInfo();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 0,right: 0),
                                width: 101,
                                height: 45.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(22.75))
                                ),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(image: AssetImage('images/xingzuo/tijiao.png'),width: 17.5,height: 18,),
                                    SizedBox(width: 5,),
                                    Text('提交',style:
                                    TextStyle(color: Color(0xff2A2E81),fontSize: 15,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                                  ],
                                )

                            ),
                          ),
                          SizedBox(width: 10.5,),


                          //录音

                          GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onLongPressDown: (details) {
                              if (!_hasPermission) {
                                _getPermission();
                              }
                            },
                            onLongPressStart: (details) async {
                              if (_hasPermission) {
                                _startRecorder(
                                  details: details,
                                );
                              }
                            },
                            onLongPressEnd: (details) {
                              _stopRecorder(
                                details: details,
                              );
                            },
                            onLongPressMoveUpdate: (details) {
                              var longPressOffset = details.globalPosition;
                              _longPressMoveOffsetSubject?.value = longPressOffset;
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 0,right: 0),
                              width: 209.5,
                              height: 45.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  // color: const Color(0xFFFDE6F1),
                                  width: 0.5,
                                ),
                                // color: const Color(0xFFFAFAFA),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(top: 0,right: 0),
                                width: 209.5,
                                height: 45.5,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _onLongPressSubject!,
                                  builder: (_, onLongPress, child) {
                                    return ValueListenableBuilder<Offset?>(
                                      valueListenable: _longPressMoveOffsetSubject!,
                                      builder: (_, moveOffset, child) {
                                        // bool inCancel = false;
                                        // if (moveOffset != null) {
                                        //   var move = moveOffset;
                                        //   var box = _keyOfSendArea.currentContext?.findRenderObject();
                                        //   if (box != null && (box is RenderBox) && box.hasSize) {
                                        //     var local = box.globalToLocal(move);
                                        //     if (box.hitTest(BoxHitTestResult(), position: local)) {
                                        //       inCancel = false;
                                        //     } else {
                                        //       inCancel = true;
                                        //     }
                                        //   }
                                        // }
                                        return
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 0,right: 0),
                                            width: 209.5,
                                            height: 45.5,
                                            decoration: BoxDecoration(
                                                color: Color(0xff2A2E81),
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(22.75))
                                            ),
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image(image: AssetImage('images/xingzuo/luyin.png'),width: 13,height: 16,),
                                                SizedBox(width: 5,),
                                                Text(onLongPress == true
                                                ? ( '松开  发送')
                                                    : '按住录音',style:
                                                TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),

                                              ],
                                            )
                                        );
                                        //   Text(
                                        //   onLongPress == true
                                        //       ? (inCancel ? '松开  取消' : '松开  发送')
                                        //       : '按住说话',
                                        //   style: const TextStyle(
                                        //     color: Color(0xFF333333),
                                        //     fontSize: 15.0,
                                        //     fontWeight: FontWeight.normal,
                                        //   ),
                                        // );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          )


                        ],
                      ),
                    )),
              ]
          )
              :Container()
      ),

    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var duration = pathdurationList[index].toString();
    return statusList.length>0?GestureDetector(
        onTap: () {
          // _player.stop();
          // _player.setAsset(pathList[index].toString());
          // _player.play();
        },
        child: pathList.length>0
            ?Container(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  _player.stop();
                  setState(() {
                    pathList.removeAt(index);
                    pathdurationList.removeAt(index);
                    statusList.removeAt(index);
                  });
                  print('删除了第'+index.toString()+'个');
                },
                child: Text('删除',style: TextStyle(
                    color:Color(0xffEA1919 ),fontSize: 14,fontWeight: FontWeight.w500
                )),
              ),
              SizedBox(width: 10,),

              statusList[index] == 0?GestureDetector(
                  onTap: (){
                    log('播放前录音数组为'+pathList.toString());
                    log('点击播放了'+pathList[index].toString());
                    setState(() {
                      statusList.replaceRange(index, index+1, [1]);
                    });
                    //还未开始，点击播放
                    _player.stop();
                    _player.setFilePath(pathList[index].toString());
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
              ),

              SizedBox(width: 10,),
              AnimatedContainer(
                alignment: Alignment.topRight,
                duration: const Duration(milliseconds: 200),
                // width: MediaQuery.sizeOf(context).width/2,
                height: 50.0,
                padding: EdgeInsets.only(right: 35),
                child: FittedBox(
                  fit: BoxFit.none,
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
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
                        Text(duration.toString()+'S',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
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
                        SizedBox(
                          height: 50,
                          child: Icon(
                            Icons.multitrack_audio_rounded,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),

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


  submitAudio()async{
    MTEasyLoading.showLoading('');

    // //先清空
    for (String audiofile in pathList){
      String imagePath = audiofile;
      NetWorkService service = await NetWorkService().init();
      await service.uploadAudioFileWithPath(Apis.uploadFile,
          filePath: imagePath,
          filename: 'm4a', successCallback: (data) async {
            pathUrlList.add(data.toString());
            log(data.toString());
            print('11111');
          }, failedCallback: (data) {
            MTEasyLoading.dismiss();
          });
    }
  }

  submitInfo()async{
    log('2222222222');
    Map<String ,dynamic> loadData = {
      'userId':widget.userInfoDic['userId'],
      'testId':widget.userInfoDic['id'],
      'voiceFiles':pathUrlList.join(','),
    };
    List dataList = [];
    dataList.add(loadData);
    // Map<String ,dynamic> loadData1 = {
    //   'userId':widget.userInfoDic['userId'],
    //   'testId':widget.userInfoDic['id'],
    //   'voiceFiles':pathUrlList.join(','),
    // };
    // log('请求参数:'+loadData.toString());
    // return;
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createConstellationSpeech, data: dataList,
        successCallback: (data) async {
          log('请求成功:'+data.toString());
          BotToast.showText(text: '回复成功');
          MTEasyLoading.dismiss();
          Navigator.pop(context);
        }, failedCallback: (data) {
          log('请求报错:'+data.toString());
          MTEasyLoading.dismiss();
        });
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


}
