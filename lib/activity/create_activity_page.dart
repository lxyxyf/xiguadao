import 'dart:developer';
import 'activity_choose_personnum.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart'
as iOSDatePicker;

import '../widgets/yk_easy_loading_widget.dart';
// void main() {
//   runApp(new GridStu());
// }

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({super.key});

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<CreateActivityPage> {

  List typeList = [];
  List typenameList = [];
  bool _limitExceeded = false;
  //身高
  List<String> getPersonNumList() {
    List<String> mLists = [];
    for (int i = 1; i < 21; i++) {
      mLists.add('$i');
    }
    return mLists;
  }
   //var personNumList = [['1','1'],['2','2'],['3','3'],['4','4'],['5','5']];
  List personNumList = ['1男1女','2男2女','3男3女','其他'];
  int typeSelectRow = 0;
  String typeSelectName = '';

  int personNameSelectRow = 0;
  String personNameSelectName = '';

  int womenNameSelectRow = 0;
  String womenNameSelectName = '';
  String dateSelect = '';
  String timeSelect = '';
  String endTimeSelect = '';
  int canShowTime = 0;//0不满足展示条件

  final top = 12.0;
  final txBottom = 40.0;
  final txHeight = 128.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(""),
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
            ),

          ),
          body: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 90),
                  child: SingleChildScrollView(
                    child: Container(


                      child: Column(
                        children: [

                          //顶部部分
                          Container(
                            margin: const EdgeInsets.only(left: 15, right: 15,top: 15),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              children: [
                                //活动类型
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动分类',style: TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      //右侧点击
                                      GestureDetector(
                                        onTap: (){
                                          _showTypePicker();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right:8 ),
                                              child: Text(typeSelectName!=''?typeSelectName:'请选择活动分类',style: TextStyle(
                                                  color:typeSelectName!=''?const Color(0xff333333):const Color(0xff999999),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
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

                                //活动名称
                                Container(

                                  margin: const EdgeInsets.only(top: 32.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动名称',style: TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      //右侧点击
                                      GestureDetector(
                                        onTap: (){
                                          // _showTypeListPicker();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 200,
                                              margin: const EdgeInsets.only(right: 15 ),
                                              child: TextField(
                                                controller: nameController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                    hintText: '请输入活动名称',
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    hintStyle: TextStyle(
                                                        color:
                                                        const Color(0xff999999).withOpacity(1),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                //活动时间
                                Container(
                                  margin: const EdgeInsets.only(top: 32.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动时间',style: TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      //右侧点击
                                      GestureDetector(
                                        onTap: (){
                                          _showTimePicker();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right:8 ),
                                              child: Text(endTimeSelect!=''?'$dateSelect $timeSelect-$endTimeSelect':'请选择活动时间',style: TextStyle(
                                                  color:endTimeSelect!=''?const Color(0xff333333):const Color(0xff999999),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
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


                                //活动人数
                                Container(
                                  margin: const EdgeInsets.only(top: 32.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动人数',style: TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      //右侧点击
                                      GestureDetector(
                                        onTap: (){
                                          _showPersonNumPicker();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right:8 ),
                                              child: Text(personNameSelectName!=''?'男生:$personNameSelectName 女生:$womenNameSelectName':'请选择活动人数',style: TextStyle(
                                                  color:personNameSelectName!=''?const Color(0xff333333):const Color(0xff999999),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
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


                                //活动地址
                                Container(

                                  margin: const EdgeInsets.only(top: 32.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动地址',style: TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      //右侧点击
                                      GestureDetector(
                                        onTap: (){
                                          // _showTypeListPicker();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 200,
                                              margin: const EdgeInsets.only(right: 15 ),
                                              child: TextField(
                                                controller: addressController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                    hintText: '请输入活动地址',
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    hintStyle: TextStyle(
                                                        color:
                                                        const Color(0xff999999).withOpacity(1),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500)),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),


                                //活动详情
                                Container(
                                  margin: const EdgeInsets.only(top: 32.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5,bottom: 17.5),
                                        child: const Text('活动详情',style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                                      ),
                                      Container(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xffFAFAFA),
                                                borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            // BorderRadius.only(
                                            //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(bottom:18,left: 10,right: 10 ),
                                            height: txHeight,

                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _limitExceeded = value.length > 100;
                                                });
                                              },
                                              controller: detailController,
                                              // scrollPadding: EdgeInsets.zero,
                                              // autofocus: true,
                                              maxLength: 100,
                                              maxLines: 5,
                                              style: const TextStyle(
                                                  fontSize: 11, color: Color(0xff333333)),
                                              decoration: InputDecoration(
                                                  // errorText: _limitExceeded ? "最多只能输入100个字符" : null,
                                                  hintStyle: TextStyle(
                                                      color:
                                                      const Color(0xff999999).withOpacity(1),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500),
                                                  hintText: '请输入活动详情',
                                                  contentPadding: EdgeInsets.zero,
                                                  isDense: true,
                                                  border: InputBorder.none),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 15, right: 15,top: 15),
                            padding: const EdgeInsets.only(bottom: 20.5),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 10,top: 14,bottom: 30),
                                  child: const Text('活动创建须知',style: TextStyle(color: Color(0xff999999),fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: const Text('1.活动会根据平台需要进行审核；',style: TextStyle(color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('2.活动发起人会占用活动的对应性别名额；',style: TextStyle(color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('3.活动审核通过后才会正式发布在平台；',style: TextStyle(color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('4.活动未开始前允许发起人关闭活动；',style: TextStyle(color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3,right: 10),
                                  alignment: Alignment.topLeft,
                                  child: const Text('5.保证发布活动的真实性、合法性、并承诺不存在违反法律、行政法规的强制性、禁止性规定及公序良俗的情形。',style: TextStyle(color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  )
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      createActivitySubmit();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 50,
                      margin: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 20.5),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xffFE7A24),
                          borderRadius: BorderRadius.all(Radius.circular(26))
                      ),

                      child: const Text(
                        textAlign: TextAlign.center,
                        '创建',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
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


  //创建活动
  createActivitySubmit() async {
    if (typeSelectName.isEmpty == true){
      BotToast.showText(text: '请选择活动分类');
      return;
    }
    if (nameController.text.isEmpty == true){
      BotToast.showText(text: '请输入活动名称');
      return;
    }

    if (timeSelect.isEmpty == true||endTimeSelect.isEmpty==true){
      BotToast.showText(text: '请选择活动开始时间和结束时间');
      return;
    }
    if (personNameSelectName.isEmpty == true){
      BotToast.showText(text: '请选择活动人数');
      return;
    }
    if (detailController.text.isEmpty == true){
      BotToast.showText(text: '请输入活动详情');
      return;
    }
    EasyLoading.show();
    Map<String, dynamic> map = {};

    map['name'] = nameController.text;
    map['activeDate'] = dateSelect.toString();
    map['activeTimeBegin'] = '$dateSelect $timeSelect';
    map['activeTimeEnd'] = endTimeSelect.toString();
    map['menNum'] = personNameSelectName.toString();
    map['womenNum'] = womenNameSelectName.toString();
    map['activeDesc'] = detailController.text;
    map['address'] = addressController.text;
    map['status'] = '0';
    map['auditStatus'] = '0';
    map['activityKind'] = typeList[typeSelectRow]['id'];
    map['activityKindName'] = typeSelectName.toString();
    map['activeCover'] = typeList[typeSelectRow]['imgUrl'];
    MTEasyLoading.showLoading('保存中');
    log('传值的参数$map');

    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createActivity, data: map, successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '保存成功');
      Navigator.pop(context);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });

  }

  @override
  void initState() {
    super.initState();
    getactivityTypeList();
  }

  //首先获取活动类型列表
  getactivityTypeList() async {
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(
      Apis.activityTypeList,
      queryParameters: {
        'auditStatus': '1',
        'appType': '1'
      },
      successCallback: (data) async {
        EasyLoading.dismiss();
        log('11111$data');
        List dataList = [];
        List dataList1 = [];
        if (data != null) {
          for (var map in data){
            if (map['name']=='全部'){

            }else{
              dataList.add(map['name']);
              dataList1.add(map);
            }

          }
          setState(() {

            typeList = dataList1;
            typenameList = dataList;

          });
        }
      },
      failedCallback: (data) {
        print('打印错误信息$data');
        EasyLoading.dismiss();
      },
    );
  }

  //活动类型
  _showTypePicker(){
    Pickers.showSinglePicker(context,
        data: typenameList,
        selectData: typenameList[typeSelectRow],
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
          title: const Text('选择活动类型',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print('选择的活动类型名字$p位置$position');

          setState(() {
            typeSelectName=p;
            typeSelectRow=position;
          });

        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }


  //首先弹出选择人数的pickerview
  _showPersonNumPicker(){

    Pickers.showSinglePicker(context,
        data: personNumList,
        selectData: personNumList[personNameSelectRow],
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
          title: const Text('选择活动人数',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
          textColor: Colors.black,
          backgroundColor: Colors.white,
          itemOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: Colors.grey.withOpacity(0.1)), //item覆盖样式
        ),
        onConfirm: (p,position){
          print('选择的活动类型名字$p位置$position');

          if (p=='其他'){
            Future.delayed(const Duration(seconds: 1), () {

              // 这里是一秒后需要执行的代码
              print('执行了一秒后的代码');
              showTefieldNum();
            });
          }else{
            setState(() {
              if (position==0){
                personNameSelectName='1';
                personNameSelectRow=0;
                womenNameSelectName='1';
                womenNameSelectRow=0;
              }

              if (position==1){
                personNameSelectName='2';
                personNameSelectRow=1;
                womenNameSelectName='2';
                womenNameSelectRow=1;
              }

              if (position==2){
                personNameSelectName='3';
                personNameSelectRow=2;
                womenNameSelectName='3';
                womenNameSelectRow=2;
              }

            });

          }


        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );

  }

  //自己输入人数
  showTefieldNum(){
    showDialog(
        context:context,
        builder:(context){
          return ActivityChoosePersonnumlog(
              OntapCommit: (mannum,womannum){
                setState(() {
                  personNameSelectName = mannum;
                  womenNameSelectName = womannum;
                });
              }

          );
        }
    );
  }


  // //选择参与人数
  // _showPersonNumPicker(){
  //   Pickers.showMultiPicker(
  //     context,
  //     pickerStyle: PickerStyle(
  //       cancelButton: Container(
  //         width: 25.5,
  //       ),
  //       commitButton: Container(
  //           padding: EdgeInsets.only(right: 20),
  //           child: Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
  //       ),
  //       //   headDecoration:  BoxDecoration( //头部样式
  //       //       color: Colors.grey[800],
  //       //       borderRadius: BorderRadius.only(
  //       //           topLeft: Radius.circular(8), topRight: Radius.circular(8))), //头部样式
  //       title: Text('选择参与人数',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
  //       textColor: Colors.black,
  //       backgroundColor: Colors.white,
  //       itemOverlay: CupertinoPickerDefaultSelectionOverlay(
  //           background: Colors.grey.withOpacity(0.1)), //item覆盖样式
  //     ),
  //     data: personNumList,
  //     // selectData: personNumList[0],
  //     suffix: ['男生','女生'],
  //     onConfirm: (p,position) {
  //       print(p.toString()+position.toString());
  //       setState(() {
  //         personNameSelectRow = position[0];
  //         personNameSelectName = p[0];
  //         womenNameSelectRow = position[1];
  //         womenNameSelectName = p[1];
  //       });
  //     },
  //   );
  //
  // }

  //开始时间
  _showTimePicker(){
    iOSDatePicker.DatePicker.showDatePicker(
      context,

      pickerTheme: iOSDatePicker.DateTimePickerTheme(
        confirm: Container(
            padding: const EdgeInsets.only(right: 0),
            child: const Text('下一步',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
        ),
        cancel: Container(
            padding: const EdgeInsets.only(left: 0),
            child: const Text('选择活动时间（开始时间）',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold))
        ),
        cancelTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        confirmTextStyle: const TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),
      ),
      pickerMode: iOSDatePicker.DateTimePickerMode.datetime,
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.parse("2025-12-31"),
      initialDateTime: DateTime.now(),
      locale: iOSDatePicker.DateTimePickerLocale.zh_cn,
      dateFormat: 'yy年:MM月:dd日:HH时:mm分',
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        print("选择 $dateTime");

        var formatter = DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(dateTime);

        var formatter1 = DateFormat('HH:mm');
        String formatted1 = formatter1.format(dateTime);
        print(formatted); // 输出类似 "2023-03-15 15:20"
        setState(() {
          timeSelect= formatted1;//;
          dateSelect = formatted;

        });
        // Navigator.pop(context);
        Future.delayed(const Duration(seconds: 1), () {

          // 这里是一秒后需要执行的代码
          print('执行了一秒后的代码');
          _showEndTimePicker();
        });


      },

      onCancel: () {},
      onClose: () {},
      onChange: (datetime, selectedIndex) {},
    );
  }

  //结束时间
  _showEndTimePicker(){

    iOSDatePicker.DatePicker.showDatePicker(
      context,

      pickerTheme: iOSDatePicker.DateTimePickerTheme(
        confirm: Container(
            padding: const EdgeInsets.only(right: 0),
            child: const Text('确定',style: TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500))
        ),
        cancel: Container(
            padding: const EdgeInsets.only(left: 0),
            child: const Text('选择活动时间（结束时间）',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold))
        ),
        cancelTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        confirmTextStyle: const TextStyle(color: Color(0xffEB4242),fontSize: 17,fontWeight: FontWeight.w500),
      ),
      pickerMode: iOSDatePicker.DateTimePickerMode.datetime,
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.parse("2025-12-31"),
      initialDateTime: DateTime.now(),
      locale: iOSDatePicker.DateTimePickerLocale.zh_cn,
      dateFormat: 'yy年:MM月:dd日:HH时:mm分',
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        print("选择 $dateTime");

        var formatter = DateFormat('yyyy-MM-dd HH:mm');
        String formatted = formatter.format(dateTime);
        print(formatted); // 输出类似 "2023-03-15 15:20"

        // if (DateTime.parse(formatted).isBefore(DateTime.parse(timeSelect))||DateTime.parse(formatted).isAtSameMomentAs(DateTime.parse(timeSelect))==true) {
        //   BotToast.showText(text: '结束时间要大于开始时间');
        // } else {
        //
        // }

        setState(() {
          endTimeSelect= formatted;//;
        canShowTime = 1;
        });
      },

      onCancel: () {},
      onClose: () {},
      onChange: (datetime, selectedIndex) {},
    );
  }


  @override
  void dispose() {
    detailController.dispose();
    addressController.dispose();
    nameController.dispose();
    MTEasyLoading.dismiss();
    super.dispose();
  }


}