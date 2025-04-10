import 'dart:io';

import 'package:bot_toast/bot_toast.dart';

//MediaType用
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../widgets/yk_easy_loading_widget.dart';
// void main() {
//   runApp(new GridStu());
// }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  final PageController? pageController = PageController();
  List chooseDeleteImageArray = [];//要删除的
  List dataImageArray = [];
  int nowState = 0;//0为不编辑，1为编辑
  int _bigImageIndex = 0; //存放需要放大的图片下标
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(""),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(

                child: Text(nowState==0?'编辑':'删除',style: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold)),
                onPressed: () {
                  nowState==0?editClick():deleteClick();
                },
            ),
            )
          ],

        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,top: 10),
              alignment: Alignment.topLeft,
              child: Text('我的照片(${dataImageArray.length}/8)',style: TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: GridView.count(
                //设置滚动方向
                scrollDirection: Axis.vertical,
                //设置列数
                crossAxisCount: 4,
                //设置内边距
                padding: const EdgeInsets.all(10),
                //设置横向间距
                crossAxisSpacing: 10,
                //设置主轴间距
                mainAxisSpacing: 10,
                childAspectRatio:1,
                children: _getData(),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    requestGalleryPermission();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 50,
                    margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20.5),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Color(0xffFE7A24),
                        borderRadius: BorderRadius.all(Radius.circular(26))
                    ),

                    child: const Text(
                      textAlign: TextAlign.center,
                      '上传照片',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:14 ),
                    ),
                  ),
                ),

              ],
            )

          ],
        )

      ),
    );
  }


  List<Widget> _getData() {
    List<Widget> list = [];
    for (var i = 0; i < dataImageArray.length; i++) {
      list.add(Container(

        child: ListView(
          children: [
            nowState==0?GestureDetector(
              onTap: (){
                setState(() {
                  _bigImageIndex = i;
                });
                _showBigImage(i);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                width: 80,
                height: 80,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Image(image: NetworkImage(dataImageArray[i]['url']),fit: BoxFit.cover,)
                  // fit: BoxFit.fill,
                ),
              ),
            ):Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    changeSelect(i);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    width: 100,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Image(image: NetworkImage(dataImageArray[i]['url']),fit: BoxFit.cover,)
                        // fit: BoxFit.fill,
                      ),
                    )
                  ),

                dataImageArray[i]['isselect']==1?const Icon(Icons.check_circle):Container()
              ],

            )



          ],
        ),
//
//         decoration:
//         BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
      ));
    }
    return list;
  }

  void _showBigImage(int index){
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        useSafeArea:false,
        // useRootNavigator: true,
        context: context, builder: (context){
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(dataImageArray[index]['url']),
                          initialScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(tag: dataImageArray[index]['id']),
                        );
                      },
                      itemCount: dataImageArray.length,
                      // loadingBuilder: (context, event) => Container(
                      //   margin: EdgeInsets.only(top: 10,left: 10),
                      //   width: 200.0,
                      //   height: 90.0,
                      //   color: Colors.white,
                      //   child: CircularProgressIndicator(
                      //     backgroundColor:Colors.black,
                      //     value: 1/11,
                      //   ),
                      // ),
                      backgroundDecoration: BoxDecoration(
                        // color: Colors.black
                      ),
                      pageController: PageController(initialPage:index),
                      onPageChanged: (int pageIndex){
                        print('当前是第'+pageIndex.toString()+'张');
                        setState(() {
                          _bigImageIndex = pageIndex;
                        });
                      },
                    )
                ),
                Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 15,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(Icons.close,color: Colors.white,size: 25,),
                      ),
                    )),

                // Positioned(
                //     top: MediaQuery.of(context).padding.top,
                //     right: 15,
                //     child: GestureDetector(
                //       onTap: (){
                //         Navigator.pop(context);
                //       },
                //       child: Container(
                //         child: Icon(Icons.delete,color: Colors.white,size: 25,),
                //       ),
                //     )),

                Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 15+50,right: 65,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text((_bigImageIndex+1).toString()+'/'+dataImageArray.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                      ),
                    ))
              ],
            ),
          );
        },
      );
    });
  }

  // void _showBigImage(int index) {
  //   setState(() {
  //     _bigImageIndex = index;
  //   });
  //   //点击图片放大
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         insetPadding: const EdgeInsets.only(left: 0.0),
  //         child: PhotoView(
  //           tightMode: true,
  //           imageProvider:NetworkImage(dataImageArray[_bigImageIndex]['url'])
  //         ),
  //       );
  //     },
  //   );
  // }

  editClick(){

    List dataarray = dataImageArray;
    for (int i = 0;i<dataarray.length;i++){
      Map dataMap = dataarray[i];
      dataMap['isselect'] = 0;
    }
    setState(() {
      dataImageArray = dataarray;
      nowState = 1;
    });
  }

  changeSelect(i){
    setState(() {
      if (dataImageArray[i]['isselect'] == 0){
        dataImageArray[i]['isselect'] = 1;
      }else{
        dataImageArray[i]['isselect'] = 0;
      }
    });
  }

  deleteClick(){

    List dataarray = dataImageArray;
    List dataarray1 = [];
    print(dataarray.toString());
    // for (int i = 0;i<dataImageArray.length;i++){
    //   Map dataMap = dataImageArray[i];
    //   if (dataMap['isselect']! == 1){
    //     print(dataMap.toString());
    //     dataarray.add(dataMap);
    //   }
    // }
    if (dataarray.isEmpty){
      BotToast.showText(text: '没有可删除的照片');
      return;
    }else{
      for (Map dataMap in dataarray){
        if (dataMap['isselect']! == 1) {
          print(dataMap.toString());
          dataarray1.add(dataMap);
        }
      }

      if (dataarray1.isEmpty){
        BotToast.showText(text: '请先选择要删除的照片');
        return;
      }else {
        showDialog(
            context: context,
            barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
            builder: (context) {
              return AlertDialog(
                title: const Text("温馨提示！"),
                content: const Text("您确定要删除吗？"),
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
                      sureDelete();
                    },
                    child: const Text("确定"),
                  ),
                ],
              );
            }
        );
      }
    }






  }


  sureDelete() async {
    List dataarray = dataImageArray;
    List dataarray1 = dataImageArray;
    for (int i = dataarray.length-1;i>=0;i--){
      Map dataMap = dataarray[i];
      if (dataMap['isselect'] == 1){
        dataarray1.remove(dataMap);
      }
    }
    print('当前图片数组$dataarray1');
    updateMemberPhotosBydelete(dataarray1);
  }

  refreshimagedata(){

  }




  //更新相册
  updateMemberPhotosBydelete(dataarray) async {
    BotToast.showLoading();
    Map<String, dynamic> map = {};
    // List tagsIdList = [];
    // for (Map e in chooseItemArray){
    //   tagsIdList.add(e['id']);
    // }
    map['integers'] = dataarray;
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateUserPhotos, data: dataarray, successCallback: (data) async {
      BotToast.closeAllLoading();

      //保存成功
      // eventTools.emit('changeUserInfo');
      getMemberPhotos();
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });

  }

  // @override
  // Widget build(BuildContext context) {
  //   return
  // }
  @override
  void initState() {
    super.initState();
    getMemberPhotos();
  }

  //首先获取用户相册列表
  getMemberPhotos() async {

    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.get(
      Apis.getUserPhotos,
      queryParameters: {
        'auditStatus': '1',
        'appType': '1',
        'pageSize':'20'
      },
      successCallback: (data) async {
        BotToast.closeAllLoading();

        if (data != null) {
          setState(() {
            nowState = 0;
            dataImageArray = data['list'];
            print(dataImageArray);
            print('4444444');
            return;
          });
        }
      },
      failedCallback: (data) {
        BotToast.closeAllLoading();
      },
    );
  }

  //更新相册
  updateMemberPhotos() async {
    BotToast.showLoading();
    Map<String, dynamic> map = {};
    // List tagsIdList = [];
    // for (Map e in chooseItemArray){
    //   tagsIdList.add(e['id']);
    // }
    map['integers'] = dataImageArray;
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateUserPhotos, data: dataImageArray, successCallback: (data) async {
      BotToast.closeAllLoading();
      //保存成功
      // eventTools.emit('changeUserInfo');
      getMemberPhotos();
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });

  }
  //
  // showQuanxianShuomingLog()async{
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return AlertDialog(
  //         title: Text('权限申请'),
  //         content: Text('使用相机需要您的授权'),
  //         actions: <Widget>[
  //           FlatButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('取消'),
  //           ),
  //           FlatButton(
  //             onPressed: () => Permission.camera.request().then((result){
  //               // 申请结果处理
  //             }),
  //             child: Text('确定'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future requestGalleryPermission() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? storageShouquan = sharedPreferences.getString('storageShouquan');
    if (storageShouquan == 'true'){
      getMutibleImage();
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
                      getMutibleImage();
                      }else {
                        getMutibleImage();
                      }
                    }),
            ],
          );
        },
      );
    }

  }


  //多选图片
  getMutibleImage() async {

    List<XFile>? image = await _imagePicker.pickMultiImage(

    );
    // if (image != null) this.image = image;
    // String imagePath = image!.path;
    // if (image.isEmpty){
    //   MTEasyLoading.dismiss();
    //   return;
    // }
    uploadMutibleImage(image);

  }
  List imageUrlStr = [];
  void uploadMutibleImage(image) async {
    // MTEasyLoading.dismiss();
    BotToast.showLoading();
    //   NetWorkService service = await NetWorkService().init();
    //   service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
    //     MTEasyLoading.dismiss();
    //     BotToast.showText(text: '保存成功');
    print('11111');
    // //先清空
    imageUrlStr = [];
    List<XFile> files = image;
    if (files.length+dataImageArray.length>8){
      BotToast.closeAllLoading();
      BotToast.showText(text: '相册最多8张照片');
      return;
    }

    for (XFile imagefile in files){
      String imagePath = imagefile.path;
      NetWorkService service = await NetWorkService().init();
      await service.uploadFileWithPath(Apis.uploadFile,
          filePath: imagePath,
          filename: 'image', successCallback: (data) async {
            Map<String, dynamic> map = {};
            map['url'] = data.toString();
            map['path'] = data.toString();
            dataImageArray.add(map);
            print(dataImageArray);
            if (dataImageArray.length >= files.length) {
              //说明已经上传完毕
              print('2222');

              updateMemberPhotos();
            }
          }, failedCallback: (data) {});
    }
    BotToast.closeAllLoading();

  }
}





class Stu extends StatelessWidget {
  List listData = [
    // {
    //   "title": "标题1",
    //   "author": "内容1",
    //   "image": "https://www.itying.com/images/flutter/1.png"
    // },
    // {
    //   "title": "标题2",
    //   "author": "内容2",
    //   "image": "https://www.itying.com/images/flutter/2.png"
    // },
    // {
    //   "title": "标题3",
    //   "author": "内容3",
    //   "image": "https://www.itying.com/images/flutter/3.png"
    // },
    // {
    //   "title": "标题4",
    //   "author": "内容4",
    //   "image": "https://www.itying.com/images/flutter/4.png"
    // },
    // {
    //   "title": "标题5",
    //   "author": "内容5",
    //   "image": "https://www.itying.com/images/flutter/5.png"
    // },
    // {
    //   "title": "标题6",
    //   "author": "内容6",
    //   "image": "https://www.itying.com/images/flutter/6.png"
    // },
    // {
    //   "title": "标题7",
    //   "author": "内容7",
    //   "image": "https://www.itying.com/images/flutter/7.png"
    // },
    // {
    //   "title": "标题8",
    //   "author": "内容8",
    //   "image": "https://www.itying.com/images/flutter/1.png"
    // },
    // {
    //   "title": "标题9",
    //   "author": "内容9",
    //   "image": "https://www.itying.com/images/flutter/2.png"
    // }
  ];

  Stu({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}