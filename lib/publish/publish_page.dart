import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:bot_toast/bot_toast.dart';
import 'package:dd_js_util/dd_js_util.dart';
import 'package:dd_js_util/widget/picture_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';

class PublishPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PublishPageState();
  }
}

class PublishPageState extends State<PublishPage> {
  /// 组件的控制器
  late final PictureSelectionController? _controller;

  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = PictureSelectionController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //点击空白区域，键盘收起

          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/publish_bg.png'),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + 24,
                  padding: EdgeInsets.only(left: 15, bottom: 5),
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //点击空白区域，键盘收起

                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        '发布',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.5,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 9.5, right: 9.5, top: 16.5, bottom: 16.5),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      height: 180,
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '每一个日常都值得被记录',
                            style: TextStyle(
                                color: Color(0xff999999), fontSize: 13),
                          ),
                          SizedBox(
                            height: 11.5,
                          ),
                          Expanded(
                              child: TextField(
                                controller: textEditingController,
                                maxLines: 999,
                                maxLength: 100,
                                decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: '请输入内容......',
                                    hintStyle: const TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: 13,
                                    )),
                              ))
                        ],
                      ),
                    ),
                    Positioned(
                      right: 35 / 2.0 - 5,
                      top: -41 / 2.0 + 5,
                      child: Image.asset(
                        'images/icon-edit.png',
                        width: 35,
                        height: 41,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    '点击已选择的图片即可删除',
                    style: TextStyle(
                        color: Color(0xff808080),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: PictureSelection(
                        padding: EdgeInsets.all(0),
                        multipleChoice: true,
                        controller: _controller,
                        itemBuilder: (context, file, size, onRemove) {
                          return GestureDetector(
                              child: Image.file(
                                file,
                                width: size.width,
                                height: size.height,
                                fit: BoxFit.fill,
                              ),
                              onTap: () {
                                //点击图片删除
                                onRemove(file);
                              });
                        },
                        placeholderBuilder: (size) {
                          return Image.asset(
                            'images/publish-button.png',
                          );
                        },
                        menusBuilder: (imagePicker, cameraPicker) {
                          return Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        // await imagePicker();
                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        String? storageShouquan = sharedPreferences.getString('storageShouquan');
                                        if (storageShouquan == 'true'){
                                          await imagePicker();
                                        }else{
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('权限申请'),
                                                content: Text(
                                                    '西瓜岛需要您的同意,才能访问相册,用于读取手机储存卡中的视频或图片，以便进行编辑'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('取消'),
                                                  ),
                                                  TextButton(
                                                      child: Text('确定'),
                                                      onPressed: ()async {
                                                        Navigator.of(context).pop();
                                                        // 申请结果处理
                                                        if(await Permission.storage.request().isGranted){
                                                          await sharedPreferences.setString('storageShouquan', 'true');
                                                          // 权限已授予，进行下一步操作
                                                          await imagePicker();
                                                        }else {
                                                          await imagePicker();
                                                        }
                                                      }),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        height: 50,
                                        child: Text(
                                          '相册',
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {

                                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                        String? storageShouquan = sharedPreferences.getString('cameraShouquan');
                                        if (storageShouquan == 'true'){
                                          await cameraPicker();
                                        }else{
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('权限申请'),
                                                content: Text(
                                                    '西瓜岛需要您的同意,才能访问相机,以便于您实名认证或是拍照更换头像及发帖时使用'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('取消'),
                                                  ),
                                                  TextButton(
                                                      child: Text('确定'),
                                                      onPressed: ()async {
                                                        Navigator.of(context).pop();
                                                        // 申请结果处理
                                                        if(await Permission.camera.request().isGranted){
                                                          await sharedPreferences.setString('cameraShouquan', 'true');
                                                          // 权限已授予，进行下一步操作
                                                          await cameraPicker();
                                                        }else {

                                                        }
                                                      }),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: Text('相机',
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 16)),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: Text('取消',
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 16)),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    )),
                SizedBox(
                  height: 182.5,
                ),
                GestureDetector(
                  onTap: () {
                    //点击空白区域，键盘收起

                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_controller!.getFiles.isNotEmpty) {
                      uploadImage();
                    } else {
                      publish();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    width: MediaQuery.of(context).size.width - 50,
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xffFE7A24),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Text(
                      '发布',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future requestGalleryPermission1() async {


    // 如果用户选择了暂不在这里显示，或者出现了其他错误
  }

  List<String> imageUrlStr = [];

  ///上传图片
  void uploadImage() async {
    BotToast.showLoading();
    // //先清空
    imageUrlStr = [];
    List<File> imageModels = _controller!.getFiles;
    for (File model in imageModels) {
      var dir = await path_provider.getTemporaryDirectory();
      var targetPath = dir.absolute.path +"/"+DateTime.now().millisecondsSinceEpoch.toString()+ ".jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        model.absolute.path,
        targetPath,
        quality: 85, // 图片质量
        // minWidth: 1280, // 最小宽度
        // minHeight: 720, // 最小高度
        // 如果你想要固定的尺寸，可以设置targetWidth和targetHeight
        // 如果想要固定的质量，可以设置quality
      );
      String? imagePath = compressedFile?.path.toString();
      NetWorkService service = await NetWorkService().init();
      await service.uploadFileWithPath(Apis.uploadFile,
          filePath: imagePath.toString(),
          filename: 'image', successCallback: (data) async {
            imageUrlStr.add(data.toString());
            if (imageUrlStr.length == _controller!.getFiles.length) {
              //说明已经上传完毕
              publish();
            }
          }, failedCallback: (data) {});
    }
  }

  bool isPublishing = false;

  ///发帖
  void publish() async {
    if (isPublishing) {
      return;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> map = {};
    map['userId'] = sharedPreferences.get('UserId').toString();
    if (textEditingController.text.isEmpty) {
      BotToast.showText(text: '请输入动态内容');
      return;
    }
    map['content'] = textEditingController.text;
    String imageTotalStr = '';
    if (imageUrlStr.isNotEmpty) {
      for (int i = 0; i < imageUrlStr.length; i++) {
        if (i == imageUrlStr.length - 1) {
          imageTotalStr = imageTotalStr + imageUrlStr[i];
        } else {
          imageTotalStr = imageTotalStr + imageUrlStr[i] + ',';
        }
      }
    }
    if (imageTotalStr.isNotEmpty) {
      map['imgUrl'] = imageTotalStr;
    }
    map['type'] = '2';
    isPublishing = true;
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.publish, data: map, successCallback: (data) async {
      BotToast.showText(text: '发布成功');
      isPublishing = false;
      BotToast.closeAllLoading();
      Navigator.pop(context);
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
      isPublishing = false;
      BotToast.showText(text: '发布失败，请稍后再试');
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
