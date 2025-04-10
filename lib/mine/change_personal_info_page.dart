import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
// import 'package:bruno/bruno.dart';
// import 'package:dd_js_util/dd_js_util.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../pages/login/login_birth_page.dart';

// ignore: must_be_immutable
class ChangePersonalInfoPage extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  ChangePersonalInfoPage({super.key, required this.userInfoDic});

  @override
  State<StatefulWidget> createState() {
    return ChangePersonalInfoPageState();
  }
}

class ChangePersonalInfoPageState extends State<ChangePersonalInfoPage> {
  TextEditingController textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String avatarUrlStr = '';
// 使用ImagePicker前必须先实例化
  final ImagePicker _imagePicker = ImagePicker();

  ///性别 1男生,2女生

  int sex = 1;
  @override
  void initState() {
    super.initState();
    if (widget.userInfoDic['nickname'] != null) {
      setState(() {
        textEditingController.text = widget.userInfoDic['nickname'];
      });
    }

    if (widget.userInfoDic['avatar'] != null&&widget.userInfoDic['avatar'].toString()!='') {
      setState(() {
        avatarUrlStr = widget.userInfoDic['avatar'];
      });
    }

    if (widget.userInfoDic['sex'] != null) {
      setState(() {
        sex = widget.userInfoDic['sex'];
      });
    }
  }

  Future requestGalleryPermission1() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storageShouquan = sharedPreferences.getString('storageShouquan');
    if (storageShouquan == 'true'){
      getImage();
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
                      getImage();
                    }else {
                      getImage();
                    }
                  }),
            ],
          );
        },
      );
    }

    // 如果用户选择了暂不在这里显示，或者出现了其他错误
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Color(0xFFFAFAFA),
      child: Stack(
        children: [
          Container(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200.5 / 375.0 * MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/info-edit-icon.png'))),
          ),
          Positioned(
            left: 25,
            right: 25,
            top: 157,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 152,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'step1',
                          style: TextStyle(
                              color: Color(0xffFE7A24),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '上传头像',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '请上传真实头像，否则封号处理',
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 12),
                                )
                              ],
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                requestGalleryPermission1();
                              },
                              child: avatarUrlStr != ''
                                  ? ClipRRect(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(12)),
                                      child: Image.network(avatarUrlStr,width: 80,height: 80,fit: BoxFit.cover,)
                                    )
                                  : (widget.userInfoDic['avatar'] == null||widget.userInfoDic['avatar'].toString() == ''
                                      ?Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'images/add-icon.png'))),
                              ): Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(widget
                                            .userInfoDic['avatar']))),
                              ))
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 152,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'step2',
                          style: TextStyle(
                              color: Color(0xffFE7A24),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 47.5,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            const Color.fromRGBO(231, 231, 231, 1.0),
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(47.5 / 2.0))),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: textEditingController,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    counterText: '',
                                      hintText: '请输入昵称',
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff333333)
                                              .withOpacity(0.4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '输入昵称',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '输入一个自己喜欢的名字',
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 152,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'step3',
                          style: TextStyle(
                              color: Color(0xffFE7A24),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '选择性别',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7.5,
                                ),
                                Text(
                                  '你是男生还是女生？',
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sex = 1;
                                    });
                                  },
                                  child: Container(
                                    width: 131,
                                    height: 47.4,
                                    alignment: Alignment.bottomLeft,
                                    decoration: BoxDecoration(
                                        color: sex == 1
                                            ? const Color(0xffFE7A24)
                                            : Colors.white,
                                        border: sex == 1
                                            ? null
                                            : Border.all(
                                                width: 0.5,
                                                color: const Color(0xffEEEEEE)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(47.4 / 2.0))),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 21.5,
                                        ),
                                        Image.asset(
                                          'images/nan.png',
                                          width: 22.5,
                                          height: 39.5,
                                        ),
                                        Expanded(
                                            child: Center(
                                          child: Text(
                                            '我是男生',
                                            style: TextStyle(
                                                color: sex == 1
                                                    ? Colors.white
                                                    : const Color(0xff333333),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sex = 2;
                                    });
                                  },
                                  child: Container(
                                    width: 131,
                                    height: 47.4,
                                    decoration: BoxDecoration(
                                        color: sex == 2
                                            ? const Color(0xffFE7A24)
                                            : Colors.white,
                                        border: sex == 2
                                            ? null
                                            : Border.all(
                                                width: 0.5,
                                                color: const Color(0xffEEEEEE)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(47.4 / 2.0))),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 21.5,
                                        ),
                                        Image.asset(
                                          'images/nv.png',
                                          width: 22.5,
                                          height: 39.5,
                                        ),
                                        Expanded(
                                            child: Center(
                                          child: Text(
                                            '我是女生',
                                            style: TextStyle(
                                                color: sex == 2
                                                    ? Colors.white
                                                    : const Color(0xff333333),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                  GestureDetector(
                    onTap: () {
                      _saveUserInfo();
                    },
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xffFE7A24),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      alignment: Alignment.center,
                      child: const Text(
                        '提交',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }



  ///上传图片
  void uploadImage(imagePath) async {
    // MTEasyLoading.showLoading('上传中');
    NetWorkService service = await NetWorkService().init();
    service.uploadFileWithPath(Apis.uploadFile,
        filePath: imagePath,
        filename: 'image', successCallback: (data) async {
      // MTEasyLoading.dismiss();
      setState(() {
        avatarUrlStr = data.toString();
      });
    }, failedCallback: (data) {
      // MTEasyLoading.dismiss();
    });
  }

  getImage() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.camera,
  //     Permission.photos
  //   ].request();
  //
  //   // 检查相机权限的状态
  //   if (statuses[Permission.camera] == PermissionStatus.granted&&statuses[Permission.photos] == PermissionStatus.granted) {
  //     // 权限已授予
  //     print('Camera permission granted.');
  //   } else if (statuses[Permission.camera] == PermissionStatus.denied) {
  //     BotToast.showText(text: '请前往设置开启相机权限');
  //     return;
  //     // 权限被拒绝
  //     print('Camera permission denied.');
  //     // 这里可以显示一个对话框，提示用户权限被拒绝，并询问是否要打开应用设置
  //   } else if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
  //     // 权限被永久拒绝
  //     print('Camera permission permanently denied.');
  //     // 打开应用设置页面，让用户可以手动更改权限
  //     openAppSettings();
  //   }
  //
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null){
      File? croppedFile = await cropImage(File(image.path));//调用裁剪方法
      if (croppedFile!=null){
        String imagePath = croppedFile.path;

        uploadImage(imagePath);
        setState(() {});
      }

    }

  }

  ImageCropper cropper = ImageCropper();
  Future<File?> cropImage(File imageFile) async {
    final File? croppedFile = await cropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 690, ratioY: 1187),
        compressFormat: ImageCompressFormat.png,
        maxWidth: 690,
        maxHeight: 1187,
    iosUiSettings:IOSUiSettings(doneButtonTitle: '确定',cancelButtonTitle: '取消'));

    return croppedFile;}

  // void uploadSingleImage(imagePath) async {
  //   // //先清空
  //   MTEasyLoading.showLoading('');
  //   // List<File> files = _pictureSelectionController.getFiles;
  //   NetWorkService service = await NetWorkService().init();
  //   await service.uploadFileWithPath(Apis.uploadFile,
  //       filePath: imagePath,
  //       filename: 'image', successCallback: (data) async {
  //         // setState(() {
  //         //   userInfoDic['avatar'] = data.toString();
  //         // });
  //         setState(() {
  //           userInfoDic['avatar'] = data.toString();
  //
  //         });
  //         newAvatar = data.toString();
  //         userInfoDic['avatar'] = data.toString();
  //         _saveUserInfo();
  //
  //         // imageUrlStr.add(data.toString());
  //         // print(imageUrlStr);
  //         // if (imageUrlStr.length == files.length) {
  //         //   //说明已经上传完毕
  //         //   print('11111');
  //         // }
  //       }, failedCallback: (data) {
  //         MTEasyLoading.dismiss();
  //       });
  // }


  ///提交保存
  void _saveUserInfo() async {
    Map<String, dynamic> map = {};
    print('头像'+avatarUrlStr);
    if (avatarUrlStr.isEmpty||avatarUrlStr=='') {
      BotToast.showText(text: '请先选择头像');
      return;
    }else{
      map['avatar'] = avatarUrlStr;
    }
    if (textEditingController.text.isEmpty) {
      BotToast.showText(text: '昵称不能为空');
      return;
    }



    // if (avatarUrlStr.isNotEmpty) {
    //
    // }

    map['sex'] = sex == 1 ? '1' : '2';
    map['nickname'] = textEditingController.text;
    print(map);
    MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      BotToast.showText(text: '保存成功');
      //保存成功
      eventTools.emit('changeUserInfo');
      BotToast.closeAllLoading();
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginBirthPage();
          }));

    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
      BotToast.closeAllLoading();
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }

}
