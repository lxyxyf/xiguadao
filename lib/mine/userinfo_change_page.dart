import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
//MediaType用
import 'package:city_pickers/city_pickers.dart';
// import 'package:dd_js_util/dd_js_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/user_change_futuretags.dart';
import 'package:xinxiangqin/mine/user_changefuture_tag_view.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../pages/login/future_tags_view.dart';
import '../pages/login/tags_demo.dart';
import '../tools/event_tools.dart';
import '../user/new_userinfo_page.dart';
import '../user/user_info_yulan.dart';
import '../widgets/yk_easy_loading_widget.dart';
import 'userchange_labels_page.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'
as iOSDatePicker;
import 'caeerList.dart';
import 'userchange_photos.dart';
import 'dart:developer';



class UserinfoChangePage extends StatefulWidget {
  const UserinfoChangePage({super.key});


  @override
  State<StatefulWidget> createState() {
    return UserinfoChangePageState();
  }
}

class UserinfoChangePageState extends State<UserinfoChangePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  // 声明实例
  CityPickerUtil cityPickerUtils = CityPickers.utils();
  // PictureSelectionController _pictureSelectionController = PictureSelectionController();
  String? usernickname = '';//昵称
  String? usersex = "";//性别
  String? userbirthday = "";//生日
  String? userheight = "";//身高
  String? userweight = "";//体重
  String? usercareer = "";//职业
  String? userincome = "";//收入
  String? useradress = "";//所在地
  String? usergrade = "";//学历
  String? usermarried = "";//婚姻
  String? newAvatar = "";//新头像
  String? otherfuture = "";//对另一半的期望
  String? schoolName = "";//毕业学校
  String?  constellation= "";//星座
  bool isSureAboutMe = false;
  Map chooseItem = {};
  List chooseItemArray = [''];

  Map chooseFutureItem = {};
  List chooseFutureArray = [''];
  List chooseImageArray = [];
  int ImageCount = 0;

  Map userInfoDic = {};
  XFile? image;
// 使用ImagePicker前必须先实例化
  final ImagePicker _imagePicker = ImagePicker();


  double _emotionalValue = 0; // 0.6表示偏右60%（感性）
  double _pursuitValue = 0; // 修改为0到1的范围
  double _iqValue = 0.5;
  double _eqValue = 0.5;


  @override
  void initState() {
    super.initState();
    getuserInfo();
    getMemberPhotos();
  }

  getMemberPhotos() async {
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
            chooseImageArray = data['list'];
            ImageCount = chooseImageArray.length;

          });
        }
      },
      failedCallback: (data) {
        BotToast.closeAllLoading();
      },
    );
  }
  getuserInfo() async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          BotToast.closeAllLoading();
      log('用户信息'+data.toString());
          setState(() {
            userInfoDic = data;
            if(data['expectedLabelDOS']!=null){
              chooseFutureArray = data['expectedLabelDOS'];
            }
            smokeSelectRow = data['smoker'];
            dringkSelectRow = data['drink'];
            _emotionalValue = double.parse(userInfoDic['disposition']!=null?userInfoDic['disposition'].toString():'0'); // 0.6表示偏右60%（感性）
            _pursuitValue = double.parse(userInfoDic['personPursuit']!=null?userInfoDic['personPursuit'].toString():'0'); // 修改为0到1的范围
            _iqValue = double.parse(userInfoDic['iqValue']!=null?userInfoDic['iqValue'].toString():'0.5');
            _eqValue = double.parse(userInfoDic['eqValue']!=null?userInfoDic['eqValue'].toString():'0.5');
            chooseItemArray = data['memberUserTagRespVOS'];
            controller1.text = userInfoDic['nickname'].toString();

            if (userInfoDic['aboutMe']==null){
              controller.text = '';
            }else{
              controller.text = userInfoDic['aboutMe'].toString();
            }
            if (userInfoDic['partnerWish']==null){
              controller2.text = '';
              otherfuture = '';
            }else{
              controller2.text = userInfoDic['partnerWish'].toString();
              otherfuture = userInfoDic['partnerWish'].toString();
            }

            controller3.text = userInfoDic['career'].toString();
            controller4.text = userInfoDic['graduatFrom'].toString();

            usernickname = userInfoDic['nickname'].toString();
            if (userInfoDic['aboutMe']==null){
              aboutMe = '';
            }else{
              aboutMe = userInfoDic['aboutMe'].toString();
            }


            usercareer = userInfoDic['career'].toString();
            schoolName = userInfoDic['graduatFrom'].toString();


          });
        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }

  //性别
  final List<String> _sexList = [
    '男','女'
  ];
  //身高
  List<String> getHeightList() {
    List<String> mLists = [];
    for (int i = 150; i < 231; i++) {
      mLists.add('$i');
    }
    return mLists;
  }

  //体重
  List<String> getWeightList() {
    List<String> mLists = [];
    for (int i = 30; i < 151; i++) {
      mLists.add('$i');
    }
    return mLists;
  }

  //月收入
  List getMonthIncomeList = [
    '5万以下', '5万-10万','10万-20万','20万-50万'
  ];



  //学历
  final List<String> _educationList = [
    '中专','高中及以下','大专','大学本科','硕士','博士'
  ];

  //学历
  final List<String> _xingzuoLixt = [
    '水瓶座','双鱼座','白羊座','金牛座','双子座','巨蟹座','狮子座','处女座','天秤座','天蝎座','射手座','摩羯座'
  ];

  //婚况
  final List<String> _marriageList = [
    '未婚','离异'
  ];

  var smokeSelectRow = 0;//抽烟
  var dringkSelectRow = 0;//喝酒
  List? tags = [];//标签

  String cacheSize = '0M';
  String? dataImagePath = "";
  String? aboutMe = "";

  //生成数据源
  List<String> getDataList() {
    List<String> mLists = [];
    for (int i = 0; i < 4; i++) {
      mLists.add('images/add-icon.png');
    }
    return mLists;
  }


  void _showBigImage() {
    //点击图片放大
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.only(left: 0.0),
          child: PhotoView(
              tightMode: true,
              imageProvider:NetworkImage(userInfoDic['avatar'])
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration:  BoxDecoration(
            // borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: AssetImage('images/user_changeinfo_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top,bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //左侧返回按钮
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: const Icon(Icons.arrow_back_ios),
                            ),
                            Container(
                              child: const Text('我的资料',
                                style: TextStyle(
                                    color:Color(0xFF333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),),
                            )
                          ],
                        ),
                      ),

                      //右侧预览按钮
                      GestureDetector(
                          onTap: () async{
                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            String? userID = sharedPreferences.getString('UserId');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return UserInfoYulan(userId: userID.toString());
                                }));
                            // getImage();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Text('预览',
                              style: TextStyle(
                                  color:Color(0xFF333333),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),),
                          )
                      ),
                    ],
                  )
              ),

              Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      children: [

                        Container(
                            margin: const EdgeInsets.only(left: 15,right: 15,top: 45.5),

                            decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/user_changeinfo_whiteback.png'),
                                fit: BoxFit.cover,
                              ),
                              // color: const Color.fromRGBO(250, 250, 250, 0.5), // 边框颜色
                              // borderRadius: BorderRadius.circular(14.5),
                              // border: Border.all(
                              //   color: Colors.white, // 边框颜色
                              //   width: 0.5, // 边框宽度
                              // ),
                            ),
                            child: Stack(
                              children: [
                                //头像

                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        _showNickname();

                                      },
                                      child: Container(
                                          alignment: Alignment.topCenter,
                                          margin: const EdgeInsets.only(top: 45),
                                          child: Text(
                                            userInfoDic['nickname'] ?? '',
                                            style: const TextStyle(
                                                color: Color(0xFF333333),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                      ),
                                    ),

                                    //我的相册
                                    Container(
                                        alignment: Alignment.topLeft,
                                        // height: getDataList().length>5?215:140,

                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 10,left: 10.5),
                                                  child: const Text(
                                                    '我的相册',
                                                    style: TextStyle(
                                                        color: Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    userphotosPage(context);
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(top: 10,right: 10.5),
                                                    child: Row(
                                                      children: [
                                                        Text(chooseImageArray.length.toString(),
                                                            style: const TextStyle(
                                                                color: Color(0xff999999),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500
                                                            )),
                                                        const Text('张',
                                                            style: TextStyle(
                                                                color: Color(0xff999999),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w500
                                                            )),
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 5.5),
                                                          width: 5.5,
                                                          height: 11,
                                                          child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                            Container(
                                              // transform: Matrix4.translationValues(0,-30,0),
                                                margin: const EdgeInsets.only(left: 10,top: 15),
                                                child: Container(

                                                    child:
                                                    chooseImageArray.isEmpty?
                                                    GestureDetector(
                                                        onTap: (){
                                                          requestGalleryPermission();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                                              ),
                                                              alignment: Alignment.centerLeft,
                                                              margin: const EdgeInsets.only(left: 0,bottom: 15),
                                                              width: (MediaQuery.of(context).size.width-100)/4,
                                                              height: (MediaQuery.of(context).size.width-100)/4,
                                                              child: const Image(image: AssetImage('images/add-icon.png'),fit: BoxFit.cover,),
                                                            ),
                                                          ],
                                                        )
                                                    ):chooseImageArray.length==1?
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){
                                                              userphotosPage(context);
                                                            },
                                                            child: Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                width: (MediaQuery.of(context).size.width-100)/4,
                                                                height: (MediaQuery.of(context).size.width-100)/4,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                  child: Image.network(chooseImageArray[0]['url'],fit: BoxFit.cover,),
                                                                )
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){

                                                              requestGalleryPermission();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.only(bottom: 15),
                                                              width: (MediaQuery.of(context).size.width-90)/4,
                                                              height: (MediaQuery.of(context).size.width-90)/4,
                                                              child: const Image(image: AssetImage('images/add-icon.png')),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ):chooseImageArray.length==2?
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){
                                                              userphotosPage(context);},
                                                            child: Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                width: (MediaQuery.of(context).size.width-100)/4,
                                                                height: (MediaQuery.of(context).size.width-100)/4,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                  child: Image.network(chooseImageArray[0]['url'],fit: BoxFit.cover,),
                                                                )
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              userphotosPage(context);},
                                                            child: Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                width: (MediaQuery.of(context).size.width-100)/4,
                                                                height: (MediaQuery.of(context).size.width-100)/4,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                  child: Image.network(chooseImageArray[1]['url'],fit: BoxFit.cover,),
                                                                )
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                             requestGalleryPermission();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.only(bottom: 15),
                                                              width: (MediaQuery.of(context).size.width-90)/4,
                                                              height: (MediaQuery.of(context).size.width-90)/4,
                                                              child: const Image(image: AssetImage('images/add-icon.png')),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ):
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){
                                                              userphotosPage(context);},
                                                            child: Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                width: (MediaQuery.of(context).size.width-100)/4,
                                                                height: (MediaQuery.of(context).size.width-100)/4,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                  child: Image.network(chooseImageArray[0]['url'],fit: BoxFit.cover,),
                                                                )
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                              onTap: (){
                                                                userphotosPage(context);},
                                                              child:Container(
                                                                  decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                                  ),
                                                                  margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                  width: (MediaQuery.of(context).size.width-100)/4,
                                                                  height: (MediaQuery.of(context).size.width-100)/4,
                                                                  child: ClipRRect(
                                                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                    child: Image.network(chooseImageArray[1]['url'],fit: BoxFit.cover,),
                                                                  )
                                                              )
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              userphotosPage(context);},
                                                            child: Container(

                                                                margin: const EdgeInsets.only(right: 10,bottom: 15),
                                                                width: (MediaQuery.of(context).size.width-100)/4,
                                                                height: (MediaQuery.of(context).size.width-100)/4,
                                                                decoration: const BoxDecoration(

                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                  child: Image.network(chooseImageArray[2]['url'],fit: BoxFit.cover,),
                                                                )
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              requestGalleryPermission();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.only(bottom: 15),
                                                              width: (MediaQuery.of(context).size.width-90)/4,
                                                              height: (MediaQuery.of(context).size.width-90)/4,
                                                              child: const Image(image: AssetImage('images/add-icon.png')),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  // PictureSelection(
                                                  //
                                                  //   multipleChoice: true,
                                                  //   controller: _pictureSelectionController,
                                                  //   columnCount: 4,
                                                  //   maxCount: 20,
                                                  // ),
                                                )
                                            )

                                          ],
                                        )
                                    ),
                                    //关于我
                                    GestureDetector(
                                      onTap: (){
                                        _showDi();
                                      },
                                      child: Container(
                                          alignment: Alignment.topLeft,

                                          margin: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10,left: 10.5),
                                                    child: const Text(
                                                      '关于我',
                                                      style: TextStyle(
                                                          color: Color(0xff333333),
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10,right: 10.5),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(left: 5.5),
                                                      width: 5.5,
                                                      height: 11,
                                                      child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                              Container(
                                                alignment: Alignment.topLeft,
                                                // transform: Matrix4.translationValues(0,-30,0),
                                                margin: const EdgeInsets.only(left: 11,right: 10,top: 8.5,bottom: 15.5),
                                                padding: EdgeInsets.only(top: 10,bottom: 10),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffF9F9F9),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15.5)),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 12.5,top: 3),
                                                      width: 10.5,
                                                      height: 11,
                                                      child: const Image(image: AssetImage('images/edit_aboutme.png')),
                                                    ),
                                                    Expanded(
                                                      // padding: EdgeInsets.only(left: 5.5,right: 12.5,bottom: 10),
                                                        child:Container(
                                                            alignment: Alignment.centerLeft,
                                                          padding: const EdgeInsets.only(left: 5.5,right: 12.5),
                                                          child:  Wrap(
                                                            children: [
                                                              Text(userInfoDic['aboutMe'] ?? '点我写下属于你的内心独白',
                                                                maxLines: null,
                                                                style: const TextStyle(
                                                                  overflow: TextOverflow.clip,
                                                                  color: Color(0xff999999),
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.w500,
                                                                ),),
                                                            ],
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              )

                                            ],
                                          )
                                      ),
                                    ),


                                    //对另一半的期望
                                    GestureDetector(
                                     
                                      child: Container(
                                          alignment: Alignment.centerLeft,

                                          margin: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                             GestureDetector(
                                               behavior: HitTestBehavior.translucent,
                                               onTap: (){
                                                 _navigateAndDisplaySelectionFuture(context);

                                               },
                                                 child:  Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Container(
                                                       margin: const EdgeInsets.only(top: 10,left: 10.5),
                                                       child: const Text(
                                                         '对另一半的期望',
                                                         style: TextStyle(
                                                             color: Color(0xff333333),
                                                             fontSize: 15,
                                                             fontWeight: FontWeight.bold
                                                         ),),
                                                     ),
                                                     Container(
                                                       margin: const EdgeInsets.only(top: 10,right: 10.5),
                                                       child: Container(
                                                         margin: const EdgeInsets.only(left: 5.5),
                                                         width: 5.5,
                                                         height: 11,
                                                         child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                         ),
                                                       ),
                                                     )
                                                   ],
                                                 ),
                                             ),



                                              Container(
                                                  margin: const EdgeInsets.only(top: 12,bottom: 0,left: 15),
                                                  padding: EdgeInsets.only(bottom: 12.5),
                                                  // height:userInfoDic['memberUserTagRespVOS']!=null? (userInfoDic['memberUserTagRespVOS'].length/3+1)*45:10,
                                                  child: Column(
                                                    children: [
                                                      UserChangefutureTagView(
                                                          tagList: userInfoDic['expectedLabelDOS'] ?? [],
                                                          isSingle: false,
                                                          onSelect: (selectedIndexes){
                                                            chooseFutureItem = userInfoDic['expectedLabelDOS'][selectedIndexes];
                                                            removeitemFuture(chooseFutureItem);

                                                          })
                                                    ],
                                                  )
                                              ),

                                             GestureDetector(
                                                 onTap: (){
                                                 _showQiwang();
                                               },
                                                 child:  Container(
                                                   alignment: Alignment.centerLeft,
                                                   padding: EdgeInsets.only(top: 10,bottom: 10),
                                                   // transform: Matrix4.translationValues(0,-30,0),
                                                   margin: const EdgeInsets.only(left: 11,right: 10,top: 0,bottom: 15.5),
                                                   decoration: const BoxDecoration(
                                                     color: Color(0xffF9F9F9),
                                                     borderRadius: BorderRadius.all(
                                                         Radius.circular(15.5)),
                                                   ),
                                                   child: Row(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Container(
                                                         alignment: Alignment.centerLeft,
                                                         margin: const EdgeInsets.only(left: 12.5,top: 3),
                                                         width: 10.5,
                                                         height: 11,
                                                         child: const Image(image: AssetImage('images/edit_aboutme.png')),
                                                       ),
                                                       Expanded(
                                                         // padding: EdgeInsets.only(left: 5.5,right: 12.5,bottom: 10),
                                                           child:Container(
                                                             alignment: Alignment.centerLeft,
                                                             padding: const EdgeInsets.only(left: 5.5,right: 12.5),
                                                             child:  Wrap(
                                                               children: [
                                                                 Text(userInfoDic['partnerWish'] ?? '点我写下对另一半的期望',
                                                                   maxLines: null,
                                                                   style: const TextStyle(
                                                                     overflow: TextOverflow.clip,
                                                                     color: Color(0xff999999),
                                                                     fontSize: 11,
                                                                     fontWeight: FontWeight.w500,
                                                                   ),),
                                                               ],
                                                             ),
                                                           )
                                                       )
                                                     ],
                                                   ),
                                                 ),
                                                  )

                                            ],
                                          )
                                      ),
                                    ),

                                    //底部
                                    Container(
                                        alignment: Alignment.topLeft,

                                        margin:  EdgeInsets.only(left: 10.5,top: 11.5,right: 10,bottom: 10),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Container(
                                            margin: const EdgeInsets.only(bottom: 0),
                                            child: Column(

                                              children: [
                                                //昵称
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    _showNickname();
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10.5,top: 20.5,right: 0),
                                                          child: const Text('昵称',style: TextStyle(
                                                              color:Color(0xff666666),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                        ),
                                                        //右侧点击
                                                        GestureDetector(

                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 20.5,right:8 ),
                                                                child: Text(userInfoDic['nickname'] ?? '点击修改',style: TextStyle(
                                                                    color:userInfoDic['nickname']!= null?const Color(0xff333333):const Color(0xff999999),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500)),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 20.5,right: 10),
                                                                width: 5.5,
                                                                height: 11,
                                                                child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                //性别
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    userInfoDic['haveNameAuth']!=1?_pickerView():();
                                                  },
                                                  child:  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                          child: const Text('性别',style: TextStyle(
                                                              color:Color(0xff666666),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                        ),
                                                        //右侧点击
                                                        GestureDetector(

                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                child: Text(
                                                                    userInfoDic['sex']==1?'男':userInfoDic['sex']==2?'女':'点击修改',style: TextStyle(
                                                                    color:userInfoDic['sex']==1?const Color(0xff333333):userInfoDic['sex']==2?const Color(0xff333333):const Color(0xff999999),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500)),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right: 10),
                                                                width: 5.5,
                                                                height: 11,
                                                                child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),


                                                //生日
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    userInfoDic['haveNameAuth']!=1?_showDatePickerForDate(context):();
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                          child: const Text('生日',style: TextStyle(
                                                              color:Color(0xff666666),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                        ),
                                                        //右侧点击
                                                        GestureDetector(

                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                child: Text(userInfoDic['birthday'] ?? '点击修改',style: TextStyle(
                                                                    color:userInfoDic['birthday']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500)),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right: 10),
                                                                width: 5.5,
                                                                height: 11,
                                                                child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),


                                                //身高
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    _showHeightPickerForHeight();
                                                  },
                                                  child:Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                          child: const Text('身高',style: TextStyle(
                                                              color:Color(0xff666666),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                        ),
                                                        //右侧点击
                                                        GestureDetector(

                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                child: Text(userInfoDic['height']!=null?userInfoDic['height'].toString(): '点击修改',style: TextStyle(
                                                                    color:userInfoDic['height']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500)),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 37,right: 10),
                                                                width: 5.5,
                                                                height: 11,
                                                                child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),


                                                //体重
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showWeightPickerForWeight();
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('体重',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['weight']!=null ?userInfoDic['weight'].toString(): '点击修改',style: TextStyle(
                                                                      color:userInfoDic['weight']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),


                                                //职业
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showCareer();
                                                    },
                                                    child:  Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('职业',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['career'] ?? '点击修改',style: TextStyle(
                                                                      color:userInfoDic['career']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                //年收入
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showMonthIncomePickerForMonthIncome();
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('年收入',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['monthIncome']!=null?getMonthIncomeList[int.parse(userInfoDic['monthIncome'].toString())]: '点击修改',style: TextStyle(
                                                                      color:userInfoDic['monthIncome']!=null||userInfoDic['monthIncome']!=''?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                //所在地
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showAddressPicker();
                                                    },
                                                    child:  Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('所在地',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['areaName'] ?? '点击修改',style: TextStyle(
                                                                      color:userInfoDic['areaName']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                //学历
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showEducationPickerForEducation();
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('学历',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['educationName'] ?? '点击修改',style: TextStyle(
                                                                      color:userInfoDic['educationName']!=null?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),


                                                //学校
                                                GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: (){
                                                    _showGraduatFrom();
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10.5,top: 37,right: 0),
                                                          child: const Text('学校',style: TextStyle(
                                                              color:Color(0xff666666),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                        ),
                                                        //右侧点击
                                                        GestureDetector(

                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 20.5,right:8 ),
                                                                child: Text(userInfoDic['graduatFrom'] ?? '点击修改',style: TextStyle(
                                                                    color:userInfoDic['graduatFrom']!= null?const Color(0xff333333):const Color(0xff999999),
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500)),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(top: 20.5,right: 10),
                                                                width: 5.5,
                                                                height: 11,
                                                                child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),


                                                //婚况
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showMarriagePickerForMarriage();
                                                    },
                                                    child:  Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('婚况',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(
                                                            onTap: (){
                                                              _showMarriagePickerForMarriage();
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['marriageName']!=null&&userInfoDic['marriageName']!=''?userInfoDic['marriageName']:'点击修改',style: TextStyle(
                                                                      color:userInfoDic['marriageName']!=null&&userInfoDic['marriageName']!=''?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),



                                                //星座
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _showConstellationPicker();
                                                    },
                                                    child:  Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('星座',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(
                                                            onTap: (){
                                                              _showConstellationPicker();
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: Text(userInfoDic['constellation']!=null&&userInfoDic['constellation']!=''?_xingzuoLixt[int.parse(userInfoDic['constellation'].toString())].toString():'点击修改',style: TextStyle(
                                                                      color:userInfoDic['constellation']!=null&&userInfoDic['constellation']!=''?const Color(0xff333333):const Color(0xff999999),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                //标签
                                                GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: (){
                                                      _navigateAndDisplaySelection(context);

                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 37),
                                                            child: const Text('标签',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right:8 ),
                                                                  child: const Text('点击修改',style: TextStyle(
                                                                      color:Color(0xff333333),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 37,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                    margin: const EdgeInsets.only(top: 12.5,bottom: 10,left: 15),
                                                    padding: EdgeInsets.only(bottom: 15),
                                                    // height:userInfoDic['memberUserTagRespVOS']!=null? (userInfoDic['memberUserTagRespVOS'].length/3+1)*45:10,
                                                    child: Column(
                                                      children: [
                                                        SelectTag(
                                                            tagList: userInfoDic['memberUserTagRespVOS'] ?? [],
                                                            isSingle: false,
                                                            onSelect: (selectedIndexes){
                                                              chooseItem = userInfoDic['memberUserTagRespVOS'][selectedIndexes];
                                                              removeitem(chooseItem);

                                                            })
                                                      ],
                                                    )
                                                ),
                                                
                                                //抽烟
                                                GestureDetector(
                                                    // behavior: HitTestBehavior.translucent,
                                                    // onTap: (){
                                                    //   _navigateAndDisplaySelection(context);
                                                    //
                                                    // },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 10),
                                                            child: const Text('抽烟',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 10,right:8 ),
                                                                  child: const Text('修改',style: TextStyle(
                                                                      color:Color(0xff333333),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 10,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                    margin: const EdgeInsets.only(top: 12.5,bottom: 10,left: 15),
                                                    padding: EdgeInsets.only(bottom: 15),
                                                    // height:userInfoDic['memberUserTagRespVOS']!=null? (userInfoDic['memberUserTagRespVOS'].length/3+1)*45:10,
                                                    child: Row(
                                                      children: [

                                                        //偶尔抽
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              smokeSelectRow=1;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            width:57,
                                                            margin: EdgeInsets.only(right: 22.5),
                                                            height: 29,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(14.5),
                                                                color: smokeSelectRow==1?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                            ),
                                                            child:  Stack(
                                                              children: [
                                                                Positioned(

                                                                    child:
                                                                    Container(
                                                                      width:57,
                                                                      height: 29,
                                                                      alignment: Alignment.center,
                                                                      child:  Text('偶尔抽',textAlign: TextAlign.center,style:
                                                                      TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                                    )),
                                                                Positioned(
                                                                    right: 0,
                                                                    top: 0,
                                                                    child: GestureDetector(
                                                                        onTap: () {


                                                                        },
                                                                        child: smokeSelectRow==1?const SizedBox(
                                                                          width: 11,
                                                                          height: 10.5,
                                                                          child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                        ):Container()
                                                                    ))


                                                              ],
                                                            )
                                                          ),
                                                        ),
                                                        //不抽烟
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              smokeSelectRow=0;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                            // alignment: Alignment.center,
                                                            width:57,
                                                            margin: EdgeInsets.only(right: 22.5),
                                                            height: 29,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(14.5),
                                                                color: smokeSelectRow==0?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                            ),
                                                            child:  Stack(
                                                              children: [
                                                                Positioned(

                                                                  child:
                                                               Container(
                                                                 width:57,
                                                                 height: 29,
                                                                   alignment: Alignment.center,
                                                                   child:  Text('不抽烟',textAlign: TextAlign.center,style:
                                                                   TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                               )),
                                                                Positioned(
                                                                    right: 0,
                                                                    top: 0,
                                                                    child: GestureDetector(
                                                                        onTap: () {


                                                                        },
                                                                        child: smokeSelectRow==0?const SizedBox(
                                                                          width: 11,
                                                                          height: 10.5,
                                                                          child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                        ):Container()
                                                                    ))

                                                                
                                                              ],
                                                            )
                                                          ),
                                                        ),
                                                        //会抽烟
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              smokeSelectRow=2;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            width:57,
                                                            height: 29,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(14.5),
                                                                color: smokeSelectRow==2?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                            ),
                                                            child:  Stack(
                                                              children: [
                                                                Positioned(

                                                                    child:
                                                                    Container(
                                                                      width:57,
                                                                      height: 29,
                                                                      alignment: Alignment.center,
                                                                      child:  Text('会抽烟',textAlign: TextAlign.center,style:
                                                                      TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                                    )),
                                                                Positioned(
                                                                    right: 0,
                                                                    top: 0,
                                                                    child: GestureDetector(
                                                                        onTap: () {


                                                                        },
                                                                        child: smokeSelectRow==2?const SizedBox(
                                                                          width: 11,
                                                                          height: 10.5,
                                                                          child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                        ):Container()
                                                                    ))


                                                              ],
                                                            )
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                
                                                
                                                //喝酒
                                                GestureDetector(
                                                    // behavior: HitTestBehavior.translucent,
                                                    // onTap: (){
                                                    //   _navigateAndDisplaySelection(context);
                                                    //
                                                    // },
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 10.5,top: 10),
                                                            child: const Text('喝酒',style: TextStyle(
                                                                color:Color(0xff666666),
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500
                                                            ),),
                                                          ),
                                                          //右侧点击
                                                          GestureDetector(

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 10,right:8 ),
                                                                  child: const Text('修改',style: TextStyle(
                                                                      color:Color(0xff333333),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500)),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 10,right: 10),
                                                                  width: 5.5,
                                                                  height: 11,
                                                                  child: const Image(image: AssetImage('images/gray_rightarrow_image.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                    margin: const EdgeInsets.only(top: 12.5,bottom: 10,left: 15),
                                                    padding: EdgeInsets.only(bottom: 15),
                                                    // height:userInfoDic['memberUserTagRespVOS']!=null? (userInfoDic['memberUserTagRespVOS'].length/3+1)*45:10,
                                                    child: Row(
                                                      children: [

                                                        //偶尔喝
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              dringkSelectRow=1;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                              alignment: Alignment.center,
                                                              width:57,
                                                              margin: EdgeInsets.only(right: 22.5),
                                                              height: 29,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(14.5),
                                                                  color: dringkSelectRow==1?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                              ),
                                                              child:  Stack(
                                                                children: [
                                                                  Positioned(

                                                                      child:
                                                                      Container(
                                                                        width:57,
                                                                        height: 29,
                                                                        alignment: Alignment.center,
                                                                        child:  Text('偶尔喝',textAlign: TextAlign.center,style:
                                                                        TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                                      )),
                                                                  Positioned(
                                                                      right: 0,
                                                                      top: 0,
                                                                      child: GestureDetector(
                                                                          onTap: () {


                                                                          },
                                                                          child: dringkSelectRow==1?const SizedBox(
                                                                            width: 11,
                                                                            height: 10.5,
                                                                            child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                          ):Container()
                                                                      ))


                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                        //不喝酒
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              dringkSelectRow=0;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                            // alignment: Alignment.center,
                                                              width:57,
                                                              margin: EdgeInsets.only(right: 22.5),
                                                              height: 29,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(14.5),
                                                                  color: dringkSelectRow==0?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                              ),
                                                              child:  Stack(
                                                                children: [
                                                                  Positioned(

                                                                      child:
                                                                      Container(
                                                                        width:57,
                                                                        height: 29,
                                                                        alignment: Alignment.center,
                                                                        child:  Text('不喝酒',textAlign: TextAlign.center,style:
                                                                        TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                                      )),
                                                                  Positioned(
                                                                      right: 0,
                                                                      top: 0,
                                                                      child: GestureDetector(
                                                                          onTap: () {


                                                                          },
                                                                          child: dringkSelectRow==0?const SizedBox(
                                                                            width: 11,
                                                                            height: 10.5,
                                                                            child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                          ):Container()
                                                                      ))


                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                        //经常喝酒
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              dringkSelectRow=2;
                                                            });
                                                            saveSmokeAndDrink();
                                                          },
                                                          child: Container(
                                                              alignment: Alignment.center,
                                                              width:57,
                                                              height: 29,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(14.5),
                                                                  color: dringkSelectRow==2?Color.fromRGBO(254, 122, 36, 0.08):Color(0xffF8F8F8)
                                                              ),
                                                              child:  Stack(
                                                                children: [
                                                                  Positioned(

                                                                      child:
                                                                      Container(
                                                                        width:57,
                                                                        height: 29,
                                                                        alignment: Alignment.center,
                                                                        child:  Text('经常喝',textAlign: TextAlign.center,style:
                                                                        TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),),
                                                                      )),
                                                                  Positioned(
                                                                      right: 0,
                                                                      top: 0,
                                                                      child: GestureDetector(
                                                                          onTap: () {


                                                                          },
                                                                          child: dringkSelectRow==2?const SizedBox(
                                                                            width: 11,
                                                                            height: 10.5,
                                                                            child:Image(image: AssetImage('images/close_tag_image.png')),
                                                                          ):Container()
                                                                      ))


                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                
                                                
                                                
                                                



                                              ],
                                            )
                                        )
                                    ),


                                    Container(
                                      height: 350,
                                      alignment: Alignment.topLeft,
                                      margin:  EdgeInsets.only(left: 10.5,top: 11.5,right: 10,bottom: 30),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 20.5,top: 9.5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '情感偏向',
                                              style: TextStyle(
                                                  fontSize: 15,color: Color(0xff333333), fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildBiDirectionalSlider(
                                              leftLabel: '${_calculatePercentage(_emotionalValue, true)}%\n理性',
                                              rightLabel:
                                              '${_calculatePercentage(_emotionalValue, false)}%\n感性',
                                              value: _emotionalValue,
                                              leftColor: Color(0xff4078FE),
                                              rightColor: Color(0xffFE7A24),
                                              onEnd: (value){
                                                print('结束了上传');
                                                setState(() {
                                                  _emotionalValue = value;
                                                  _saveUserInfo();
                                                  // log('情感'+_emotionalValue.toString());
                                                });

                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _emotionalValue = value;
                                                  // log('情感'+_emotionalValue.toString());
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 19.5),
                                            const Text(
                                              '个人追求',
                                              style: TextStyle(
                                                  fontSize: 15,color: Color(0xff333333), fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildBiDirectionalSlider(
                                              leftLabel: '${_calculatePercentage(_pursuitValue, true)}%\n理想',
                                              rightLabel: '${_calculatePercentage(_pursuitValue, false)}%\n现实',
                                              value: _pursuitValue,
                                              leftColor: Color(0xff4078FE),
                                              rightColor: Color(0xffFE7A24),
                                              onEnd: (value){
                                                print('结束了上传');

                                                setState(() {
                                                  _pursuitValue = value;
                                                  _saveUserInfo();
                                                  // log('个人追求'+_pursuitValue.toString());
                                                });
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _pursuitValue = value;
                                                  // log('个人追求'+_pursuitValue.toString());
                                                });
                                              },

                                            ),
                                            const SizedBox(height: 19.5),
                                            const Text(
                                              'IQ',
                                              style: TextStyle(
                                                  fontSize: 15,color: Color(0xff333333), fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildProgressBar(
                                              leftLabel: '低级',
                                              rightLabel: '高级',
                                              value: _iqValue,
                                              color: Color(0xffFFB700),
                                              centerLabel: '中级',
                                              onEnd: (value){
                                                print('结束了上传');
                                                setState(() {
                                                  _iqValue = value;
                                                  _saveUserInfo();

                                                });

                                              },
                                              onChanged: (value) {
                                                // log('IQ'+value.toString());
                                                setState(() {
                                                  _iqValue = value;


                                                });
                                              },
                                            ),
                                            const SizedBox(height: 19.5),
                                            const Text(
                                              'EQ',
                                              style: TextStyle(
                                                  fontSize: 15,color: Color(0xff333333), fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildProgressBar(
                                              leftLabel: '低级',
                                              rightLabel: '高级',
                                              value: _eqValue,
                                              color: Color(0xffF77595),
                                              centerLabel: '高级',
                                              onEnd: (value){
                                                print('结束了上传');
                                                setState(() {
                                                  _eqValue = value;
                                                  _saveUserInfo();
                                                });

                                              },
                                              onChanged: (value) {
                                                // log('EQ'+value.toString());
                                                setState(() {
                                                  _eqValue = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  ],
                                ),

                              ],
                            )
                        ),
                        Positioned(child: GestureDetector(
                          onTap: (){
                            //选头像
                            _showBigImage();
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            // transform: Matrix4.translationValues(0,-39,0),
                            child: (userInfoDic['avatar'] != null
                                ? Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 83,
                                    height: 83,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 78,
                                  height: 78,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(39)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(userInfoDic['avatar']))),
                                ),
                                Positioned(
                                  width: 19,
                                  height: 19,
                                  top: 60,
                                  left: 60,
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  width: 15,
                                  height: 15,
                                  top: 62,
                                  left: 62,
                                  child: GestureDetector(
                                    onTap: (){
                                      //选头像
                                      requestGalleryPermission1();
                                    },
                                    child: Image(image: AssetImage('images/h_icon.png')),
                                  ),
                                ),
                              ],
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'images/add-icon.png'))),
                            )),
                          ),
                        ),),
                      ],
                    ),
                  )
              ),

            ],
          )
      )
    );
  }






  Widget _buildBiDirectionalSlider({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color leftColor,
    required Color rightColor,
    required ValueChanged<double> onChanged,

    required ValueChanged<double> onEnd,
  }) {
    return Row(
      children: [
        Text(leftLabel, style: TextStyle(color: value < 0 ? leftColor : Color(0xff999999))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final center = width / 2;
                  final position = (value + 1) / 2 * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              if (value < 0)
                                Positioned(
                                  left: center + (position - center),
                                  right: center,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: leftColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        left: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              if (value > 0)
                                Positioned(
                                  left: center,
                                  right: width - position,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: rightColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        right: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              // Center(
                              //   child: Container(
                              //     width: 2,
                              //     height: 20,
                              //     color: Colors.grey[300],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: position - 15,
                        top: -5,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                            onHorizontalDragEnd: (details){
                            final RenderBox box =
                            context.findRenderObject() as RenderBox;
                            final double newValue =
                                ((details.globalPosition.dx -
                                    box.localToGlobal(Offset.zero).dx) /
                                    width *
                                    2) -
                                    1;
                            if (newValue >= -1 && newValue <= 1) {
                              onEnd(newValue);
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            final RenderBox box =
                            context.findRenderObject() as RenderBox;
                            final double newValue =
                                ((details.globalPosition.dx -
                                    box.localToGlobal(Offset.zero).dx) /
                                    width *
                                    2) -
                                    1;
                            if (newValue >= -1 && newValue <= 1) {
                              onChanged(newValue);
                            }
                          },
                          child: Image(image: AssetImage('images/mine/dropdown.png'),width: 30,height: 30,)
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Text(rightLabel, style: TextStyle(color: value < 0 ? Colors.grey : rightColor)),
      ],
    );
  }

  Widget _buildDualProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double leftValue,
    required double rightValue,
    required Color leftColor,
    required Color rightColor,
    required ValueChanged<double> onLeftChanged,
    required ValueChanged<double> onRightChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(leftLabel, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Text(rightLabel, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: leftColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: leftColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: leftValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onLeftChanged,
                    ),
                  ),
                ),
              ),
              Container(
                width: 2,
                color: Colors.grey[300],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: rightColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: rightColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: rightValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onRightChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onEnd,
    String? centerLabel,
  }) {
    String getLevel(double value) {
      if (value < 0.33) {
        return '低级';
      } else if (value < 0.66) {
        return '中级';
      } else {
        return '高级';
      }
    }

    return Row(
      children: [
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(leftLabel, style: const TextStyle(color: Color(0xff999999))),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final position = value * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: width - position,
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.horizontal(
                                      left: const Radius.circular(100),
                                      right: Radius.circular(
                                          position < 10 ? 0 : 100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: position - 15,
                        top: -22,
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 7),
                              child: Text(
                                getLevel(value),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                                onHorizontalDragEnd: (details){
                                  final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                                  final double newValue = ((details
                                      .globalPosition.dx -
                                      box.localToGlobal(Offset.zero).dx) /
                                      width)
                                      .clamp(0.0, 1.0);
                                  onEnd(newValue);
                                },
                              onHorizontalDragUpdate: (details) {
                                final RenderBox box =
                                context.findRenderObject() as RenderBox;
                                final double newValue = ((details
                                    .globalPosition.dx -
                                    box.localToGlobal(Offset.zero).dx) /
                                    width)
                                    .clamp(0.0, 1.0);
                                onChanged(newValue);
                              },
                                child: Image(image: AssetImage('images/mine/dropdown.png'),width: 30,height: 30,)
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(rightLabel, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  int _calculatePercentage(double value, bool isLeft) {
    if (value == 0) {
      return 50;
    } else if (isLeft) {
      return value < 0 ? (50 + 50 * -value).round() : 100-(50 + 50 * value).round();
    } else {
      return value > 0 ? (50 + 50 * value).round() : 100-(50 + 50 * -value).round();
    }
  }


  //移除标签
  removeitem(chooseItem){
    setState(() {
      userInfoDic['memberUserTagRespVOS'].remove(chooseItem);
      _saveUserLabels();
    });


  }

  //移除期望标签
  removeitemFuture(chooseItem){
    setState(() {
      userInfoDic['expectedLabelDOS'].remove(chooseItem);
      saveFutureTags();
    });


  }

  additem(chooseItem){
    setState(() {
      userInfoDic['memberUserTagRespVOS'].add(chooseItem);
      _saveUserLabels();
    });

  }

  userphotosPage(BuildContext context)async{

    await  Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return const MyStatefulWidget();
        }));

    getMemberPhotos();

    // setState(() {
    //   userInfoDic['memberUserTagRespVOS'] = result!;
    // });
  }

  _navigateAndDisplaySelectionFuture(BuildContext context) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    /**
     * Navigator.push返回一个Future，它将在我们调用后完成选择屏幕上的Navigator.pop！
     */
    List<String> idList = [];
    for (Map labelmap in userInfoDic['expectedLabelDOS']){
      idList.add(labelmap['id'].toString());
    }
    final result = await  Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return UserChangeFuturetags( oldTagList: idList,);
        }));

    // After the Selection Screen returns a result, show it in a Snackbar!
    ///选择屏幕返回结果后，将其显示在小吃栏中！
    ///
    setState(() {
      getuserInfo();
    });

  }

  _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push returns a Future that will complete after we call
  // Navigator.pop on the Selection Screen!
  /**
   * Navigator.push返回一个Future，它将在我们调用后完成选择屏幕上的Navigator.pop！
   */
    List<String> idList = [];
    for (Map labelmap in userInfoDic['memberUserTagRespVOS']){
      idList.add(labelmap['labelId'].toString());
    }
  final result = await  Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext ccontext) {
        return UserchangeLabelsPage( oldTagList: idList,);
      }));

  // After the Selection Screen returns a result, show it in a Snackbar!
  ///选择屏幕返回结果后，将其显示在小吃栏中！
  ///
  setState(() {
    getuserInfo();
  });

  }

  // // 图片上传，目前是从图库里面拿
  // Future getImage() async {
  //   // 1、从图库选择一张照片
  //   var image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 1);
  //   // 2、获取选中图片的路径
  //   String imagePath = image!.path;
  //   // 3、通过dio将图片上传到服务器
  //   uploadSingleImage(imagePath);
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

    if (ImageCount == 8){
      BotToast.closeAllLoading();
      BotToast.showText(text: '相册最多8张照片');
      return;
    }

    List<XFile>? image = [];
    image = await _imagePicker.pickMultiImage(

    );

    log('选择的照片'+image.toString());
    if (image.isEmpty||image.length==0){
      print('1111111');
      BotToast.closeAllLoading();
      return;
    }
    if (ImageCount+image.length> 8){
      BotToast.closeAllLoading();
      BotToast.showText(text: '相册最多8张照片');
      return;
    }
    print('2222222');
    // if (image != null) this.image = image;
    // String imagePath = image!.path;
    uploadMutibleImage(image);
    setState(() {});
  }


  //更新相册
  updateMemberPhotos() async {
    Map<String, dynamic> map = {};
    map['integers'] = chooseImageArray;
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateUserPhotos, data: chooseImageArray, successCallback: (data) async {

      //保存成功
      // eventTools.emit('changeUserInfo');
      getMemberPhotos();
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });

  }

  void uploadMutibleImage(image) async {
    // //先清空
    imageUrlStr = [];
    List<XFile> files = image;
    for (XFile imagefile in files){
      String imagePath = imagefile.path;
      NetWorkService service = await NetWorkService().init();
      await service.uploadFileWithPath(Apis.uploadFile,
          filePath: imagePath,
          filename: 'image', successCallback: (data) async {
            Map<String, dynamic> map = {};
            map['url'] = data.toString();
            map['path'] = data.toString();
            chooseImageArray.add(map);
            print(chooseImageArray);
            if (chooseImageArray.length >= files.length) {
              //说明已经上传完毕
              // print('2222');
              // MTEasyLoading.dismiss();
              updateMemberPhotos();
            }
          }, failedCallback: (data) {
            BotToast.closeAllLoading();
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

  }

  getImage() async {


    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      File? croppedFile = await cropImage(File(image.path));//调用裁剪方法
      // this.image = croppedFile as File?;
      String imagePath = croppedFile!.path;
      uploadSingleImage(imagePath);
      setState(() {});
    }
  }



  ImageCropper cropper = ImageCropper();
  Future<File?> cropImage(File imageFile) async {
    final File? croppedFile = await cropper.cropImage(
        iosUiSettings:IOSUiSettings(doneButtonTitle: '确定',cancelButtonTitle: '取消'),
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 690, ratioY: 1187),
        compressFormat: ImageCompressFormat.png,
        maxWidth: 690,
        maxHeight: 1187);
    return croppedFile;}





  void uploadSingleImage(imagePath) async {
    // //先清空
    BotToast.showLoading();
    // List<File> files = _pictureSelectionController.getFiles;
    NetWorkService service = await NetWorkService().init();
    await service.uploadFileWithPath(Apis.uploadFile,
        filePath: imagePath,
        filename: 'image', successCallback: (data) async {
       // setState(() {
       //   userInfoDic['avatar'] = data.toString();
       // });
          setState(() {
            userInfoDic['avatar'] = data.toString();

          });
          newAvatar = data.toString();
          userInfoDic['avatar'] = data.toString();
          _saveUserInfo();

          // imageUrlStr.add(data.toString());
          // print(imageUrlStr);
          // if (imageUrlStr.length == files.length) {
          //   //说明已经上传完毕
          //   print('11111');
          // }
        }, failedCallback: (data) {
          BotToast.closeAllLoading();
        });
  }

  List<String> imageUrlStr = [];


  //有关于我
  void _showDi() {
    const top = 12.0;
    const txBottom = 40.0;
    const txHeight = 128.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return Padding(padding: EdgeInsets.only(bottom: keyboardHeight),
              child: Container(
            height: 257,
            color: const Color.fromRGBO(254, 122, 36, 0.23),
            child: Stack(
              children: <Widget>[
                Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 26,top: 15,bottom: 11.5),
                            child: const Text('关于我',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                          ),
                          Expanded(
                              child: Container(

                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                // BorderRadius.only(
                                //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom:18,left: 20,right: 20 ),
                                height: txHeight,

                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: controller,
                                  onChanged: _handleTextChanged,
                                  // scrollPadding: EdgeInsets.zero,
                                  autofocus: true,
                                  maxLines: 999,
                                  maxLength: 300,
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff333333)),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      border: InputBorder.none),
                                ),
                              )),
                          GestureDetector(
                            onTap: (){
                              sendAboutMe();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48.5,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all((Radius.circular(24.25))),
                                  color: Color(0xffFE7A24)
                              ),
                              margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20),
                              child: const Text("保存",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          );
        });
      },
    );
  }


  //修改昵称
  void _showNickname() {
    const top = 12.0;
    const txBottom = 40.0;
    const txHeight = 128.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Padding(padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Container(
            height: 190,
            color: const Color.fromRGBO(254, 122, 36, 0.23),
            child: Stack(
              children: <Widget>[
                Center(

                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 26,top: 15,bottom: 11.5),
                            child: const Text('昵称',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                          ),
                          Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                // BorderRadius.only(
                                //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom:18 ,left: 20,right: 20),
                                height: txHeight,

                                child: TextField(
                                  maxLength: 10,
                                  controller: controller1,
                                  onChanged: _handleTextChanged1,
                                  // scrollPadding: EdgeInsets.zero,
                                  autofocus: true,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff333333)),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                      border: InputBorder.none),
                                ),
                              )),
                          GestureDetector(
                            onTap: (){
                              sendNickname();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48.5,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all((Radius.circular(24.25))),
                                  color: Color(0xffFE7A24)
                              ),
                              margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20),
                              child: const Text("保存",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ));
        });
      },
    );
  }


  //修改职业
  void _showCareer() {
    const top = 12.0;
    const txBottom = 40.0;
    const txHeight = 128.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Padding(padding: EdgeInsets.only(bottom: keyboardHeight),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(254, 122, 36, 0.23),
                child: Stack(
                  children: <Widget>[
                    Center(

                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 26,top: 15,bottom: 11.5),
                                child: const Text('职业',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    // BorderRadius.only(
                                    //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom:18 ,left: 20,right: 20),
                                    height: txHeight,

                                    child: TextField(
                                      controller: controller3,
                                      onChanged: _handleTextChanged3,
                                      // scrollPadding: EdgeInsets.zero,
                                      autofocus: true,
                                      maxLines: 1,
                                      maxLength: 10,
                                      style: const TextStyle(
                                          fontSize: 15, color: Color(0xff333333)),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          border: InputBorder.none),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: (){
                                  sendCareer();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48.5,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all((Radius.circular(24.25))),
                                      color: Color(0xffFE7A24)
                                  ),
                                  margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20),
                                  child: const Text("保存",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ));
        });
      },
    );
  }


  //修改职业
  void _showGraduatFrom() {
    const top = 12.0;
    const txBottom = 40.0;
    const txHeight = 128.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Padding(padding: EdgeInsets.only(bottom: keyboardHeight),
              child: Container(
                height: 190,
                color: const Color.fromRGBO(254, 122, 36, 0.23),
                child: Stack(
                  children: <Widget>[
                    Center(

                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 26,top: 15,bottom: 11.5),
                                child: const Text('学校',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    // BorderRadius.only(
                                    //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom:18 ,left: 20,right: 20),
                                    height: txHeight,

                                    child: TextField(
                                      maxLength: 10,
                                      controller: controller4,
                                      onChanged: _handleTextChanged4,
                                      // scrollPadding: EdgeInsets.zero,
                                      autofocus: true,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 15, color: Color(0xff333333)),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                          border: InputBorder.none),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: (){
                                  sendGraduatFrom();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48.5,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all((Radius.circular(24.25))),
                                      color: Color(0xffFE7A24)
                                  ),
                                  margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20),
                                  child: const Text("保存",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ));
        });
      },
    );
  }


  _showQiwang(){
    const top = 12.0;
    const txBottom = 40.0;
    const txHeight = 128.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx2, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return Padding(padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              height: 257,
              color: const Color.fromRGBO(254, 122, 36, 0.23),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 26,top: 15,bottom: 11.5),
                              child: const Text('对另一半的期望',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                            ),
                            Expanded(
                                child: Container(

                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  // BorderRadius.only(
                                  //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom:18,left: 20,right: 20 ),
                                  height: txHeight,

                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    controller: controller2,
                                    onChanged: _handleTextChanged2,
                                    // scrollPadding: EdgeInsets.zero,
                                    autofocus: true,
                                    maxLines: 999,
                                    maxLength: 300,
                                    style: const TextStyle(
                                        fontSize: 15, color: Color(0xff333333)),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none),
                                  ),
                                )),
                            GestureDetector(
                              onTap: (){
                                sendOtherfuture();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 48.5,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all((Radius.circular(24.25))),
                                    color: Color(0xffFE7A24)
                                ),
                                margin: const EdgeInsets.only(left: 25, right: 25,bottom: 20),
                                child: const Text("保存",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        });
      },
    );
  }

  //监听textfield内容变化
  void _handleTextChanged1(String text) {
    usernickname = text;
  }

  //点击发送昵称
  sendNickname() async{
    Navigator.pop(context);
    setState(() {
      userInfoDic['nickname'] = usernickname;
    });

    userInfoDic['nickname'] = usernickname;
    _saveUserInfo();
  }


  //监听textfield内容变化
  void _handleTextChanged(String text) {
    aboutMe = text;

  }
  //点击发送有关我
  sendAboutMe() async{
    setState(() {
      userInfoDic['aboutMe'] = aboutMe;
    });
    Navigator.pop(context);
    userInfoDic['aboutMe'] = aboutMe;
    _saveUserInfo();
  }

  //对另一半的期望
  _handleTextChanged2(String text){
    otherfuture = text;
  }

  sendOtherfuture(){

    setState(() {
      userInfoDic['partnerWish'] = otherfuture;
    });
    Navigator.pop(context);
    userInfoDic['partnerWish'] = otherfuture;
    _saveUserInfo();
  }


  //职业
  _handleTextChanged3(String text){
    usercareer = text;
  }

  sendCareer(){
    setState(() {
      userInfoDic['career'] = usercareer;
    });
    Navigator.pop(context);
    userInfoDic['career'] = usercareer;
    _saveUserInfo();

  }


  //学校
  _handleTextChanged4(String text){
    schoolName = text;
  }

  sendGraduatFrom(){
    setState(() {
      userInfoDic['graduatFrom'] = schoolName;
    });
    Navigator.pop(context);
    userInfoDic['graduatFrom'] = schoolName;
    _saveUserInfo();

  }

  ///提交保存
  void _saveUserInfo() async {

    if (usernickname?.isEmpty==true){

    }else{
      print(usernickname);
      userInfoDic['nickname'] = usernickname;
    }


    Map<String, dynamic> map = {};
    map['sex'] = userInfoDic['sex'];
    map['career'] = userInfoDic['career'];
    map['monthIncome'] = userInfoDic['monthIncome'];
    map['birthday'] = userInfoDic['birthday'];
    map['height'] = double.parse(userInfoDic['height'].toString());
    map['weight'] = double.parse(userInfoDic['weight'].toString());
    map['areaId'] = userInfoDic['areaId'];
    map['partnerWish'] = userInfoDic['partnerWish'];
    map['graduatFrom'] = userInfoDic['graduatFrom'];
    map['constellation'] = userInfoDic['constellation'];
    map['marriage'] = userInfoDic['marriage'];
    map['education'] = userInfoDic['education'];
    map['nickname'] = userInfoDic['nickname'];
    map['avatar'] = userInfoDic['avatar'];
    map['aboutMe'] = userInfoDic['aboutMe'];
    map['monthIncomeName'] = userInfoDic['monthIncomeName'];

    map['eqValue'] = _eqValue.toString();
    map['iqValue'] = _iqValue.toString();
    map['disposition'] = _emotionalValue.toString();
    map['personPursuit'] = _pursuitValue.toString();
    log('传值修改资料$map');
    // BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      // BotToast.closeAllLoading();

      //保存成功
      eventTools.emit('changeUserInfo');
      getuserInfo();
     /* Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return LoginAddressPage();
          }));*/
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }

  ///提交保存
  void saveSmokeAndDrink() async {


    Map<String, dynamic> map = {};
    map['smoker'] = smokeSelectRow.toString();
    map['drink'] = dringkSelectRow.toString();
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      getuserInfo();
      // BotToast.showText(text: '保存成功');
      //保存成功
    }, failedCallback: (data) {
    });
  }

  ///提交保存期望标签
  void saveFutureTags() async {

    Map<String, dynamic> map = {};
    List tagsIdList = [];
    for (Map e in chooseFutureArray){
      tagsIdList.add(e['id'].toString());
    }
    map['labelIds'] = tagsIdList;
    log('另一半的期望标签传值'+map.toString());
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateUserExpectedLabel, data: tagsIdList, successCallback: (data) async {
      getuserInfo();

    }, failedCallback: (data) {
    });
  }


  ///提交保存
  void _saveUserLabels() async {

    List tagsIdList = [];
    for (Map e in userInfoDic['memberUserTagRespVOS']){
      tagsIdList.add(e['labelId']);
    }
    print('111111111');
    log('选择的tag是哪些$tagsIdList');

    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUsertags, data: tagsIdList, successCallback: (data) async {
      BotToast.closeAllLoading();
      BotToast.showText(text: '保存成功');
      getuserInfo();
      //保存成功
      // eventTools.emit('changeUserInfo');
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }



  //展示生日弹窗
  _showDatePickerForDate(BuildContext context) {
    iOSDatePicker.DatePicker.showDatePicker(
      context,

      pickerTheme: iOSDatePicker.DateTimePickerTheme(
        confirm: Container(
            padding: const EdgeInsets.only(right: 0),
            child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
        ),
        cancel: Container(
            padding: const EdgeInsets.only(left: 0),
            child: const Text('选择生日',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold))
        ),
        cancelTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        confirmTextStyle: const TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),
      ),
      pickerMode: iOSDatePicker.DateTimePickerMode.date,
      minDateTime: DateTime(1875, 1, 01),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime(1990, 1, 01),
      dateFormat: "yyyy/MM/dd",
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        print("选择 $dateTime");
        String dateSelect = "$dateTime";
        int length = 10;
        if (dateSelect.length >= length) {
          dateSelect = dateSelect.substring(0, length);
          userInfoDic['birthday']= dateSelect;// 结果是 "Hello"
        } else {
          dateSelect = dateSelect; // 原样返回字符串
          userInfoDic['birthday']= dateSelect;
        }


          setState(() {userInfoDic['birthday']= dateSelect;

          });
        _saveUserInfo();

      },

      onCancel: () {},
      onClose: () {},
      onChange: (datetime, selectedIndex) {},
    );
  }

  //身高
  _showHeightPickerForHeight(){
    Pickers.showSinglePicker(context,
        data: getHeightList(),
        selectData: getHeightList()[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择身高',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print(position);

          setState(() {
            userInfoDic['height']= p;
          });
          userInfoDic['height']= p;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }

  //地址
  Future<void> _showAddressPicker() async {

    Result? result = await CityPickers.showCityPicker(
      context: context,
      height: 300,
      theme: ThemeData(dialogBackgroundColor: Colors.white,scaffoldBackgroundColor: Colors.white),
      confirmWidget: Container(
        child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),),
      ),
        cancelWidget: Container(
          child: const Text('选择地址',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
        )
    );


    // print('result>>> ${cityPickerUtils.getAreaResultByCode('100100)}');

    if (result != null) {
      String? citycode = result.cityId;
      print('${cityPickerUtils.getAreaResultByCode(citycode!)}');

      setState(() {
        userInfoDic['areaId']= '${result.provinceId},${result.cityId},${result.areaId}';

      });
      userInfoDic['areaId']= '${result.provinceId},${result.cityId},${result.areaId}';

      _saveUserInfo();

      print(result);
      print(result.areaName);
      // 使用选择的result
      // city 就是 result.city
    }
  }


  //体重
  _showWeightPickerForWeight(){
    Pickers.showSinglePicker(context,
        data: getWeightList(),
        selectData: getWeightList()[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择体重',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print(position);
          setState(() {
            userInfoDic['weight']= p;
          });
          userInfoDic['weight']= p;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }


  //月收入
  _showMonthIncomePickerForMonthIncome(){
    Pickers.showSinglePicker(context,
        data: getMonthIncomeList,
        selectData: getMonthIncomeList[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择年收入',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print(position);
          setState(() {
            userInfoDic['monthIncome']= position;
            userInfoDic['monthIncomeName']= p;
          });
          userInfoDic['monthIncome']= position;
          userInfoDic['monthIncomeName']= p;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }

  //学历
  _showEducationPickerForEducation(){
    Pickers.showSinglePicker(context,
        data: _educationList,
        selectData: _educationList[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择学历',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print('position====$position');

          setState(() {
            userInfoDic['education']= position+1;
          });
          userInfoDic['education']= position+1;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }



  //学历
  _showConstellationPicker(){
    Pickers.showSinglePicker(context,
        data: _xingzuoLixt,
        selectData: _xingzuoLixt[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择星座',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print('position====$position');

          setState(() {
            userInfoDic['constellation']= position;
          });
          userInfoDic['constellation']= position;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }

  //婚况
  _showMarriagePickerForMarriage(){
    Pickers.showSinglePicker(context,
        data: _marriageList,
        selectData: _marriageList[0],
        pickerStyle: PickerStyle(
          //  menu: Container(height: 50,color: Colors.red,),
          //  menuHeight: 42.0,
          //  cancelButton: _cancelButton,
          cancelButton: Container(
            width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择婚况',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print(position);
          setState(() {
            userInfoDic['marriage']= position+1;
          });
          userInfoDic['marriage']= position+1;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }

  //性别
  _pickerView(){
    Pickers.showSinglePicker(context,
        data: _sexList,
        selectData: _sexList[0],
        pickerStyle: PickerStyle(
          cancelButton: Container(
             width: 25.5,
          ),
          commitButton: Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
          ),
          //   headDecoration:  BoxDecoration( //头部样式
          //       color: Colors.grey[800],
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
          title: const Text('选择性别',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print('选择得性别$position');
          setState(() {
            userInfoDic['sex']= position+1;
          });
          userInfoDic['sex']= position+1;
          _saveUserInfo();
        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }


  ///退出登录
  void quitLogin() async {
    //删除本地数据
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('UserId');
    sharedPreferences.remove('AccessToken');
    sharedPreferences.remove('RefreshToken');

    //返回登录
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
        // //测试，记得修改
        // builder: (context) => LoginBirthPage(),
      ),
          (route) => false,
    );
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}


