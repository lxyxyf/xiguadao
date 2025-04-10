import 'dart:developer';
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
import 'activity_choose_personnum.dart';
// void main() {
//   runApp(new GridStu());
// }

class UpdateActivityPage extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  UpdateActivityPage({super.key, required this.userInfoDic});
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<UpdateActivityPage> {

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

  final FocusNode _focusNode = FocusNode();
  //var personNumList = [['1','1'],['2','2'],['3','3'],['4','4'],['5','5']];
  var personNumList = [['1','2','3','4','5','6','7','8','9','10'],['1','2','3','4','5','6','7','8','9','10']];
  int typeSelectRow = 0;
  String typeSelectName = '';
  String typeSelectId = '';

  int personNameSelectRow = 0;
  String personNameSelectName = '1';
  String womenNameSelectName = '1';

  int womenNameSelectRow = 0;
  String dateSelect = '';
  String timeSelect = '';
  String endTimeSelect = '';
  int canShowTime = 0;//0不满足展示条件

  final top = 12.0;
  final txBottom = 40.0;
  final txHeight = 140.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0xfffafafa),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("创建活动",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Color(0xff0C0C2C )),),
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
            ),

          ),
          body: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 90,left: 15,right: 15),
                  child: SingleChildScrollView(
                    child: Container(


                      child: Column(
                        children: [
                          //第一部分
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(left: 10,right: 11.5,top: 13,bottom: 13),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child:Row(
                              children: [
                                Image(image: AssetImage('images/activity/createactivity_top.png'),width: 90,height: 60.5,),
                                SizedBox(width: 13.5,),
                                Expanded(child: Text('西瓜岛，搭子交友新风尚！在这里，您不再孤单，与有趣的灵魂相遇，共同探索生活的无限可能！',
                                  style: TextStyle(overflow: TextOverflow.clip,color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),maxLines: 4,),)
                              ],
                            )
                            ,
                          ),

                          //第二部分
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(left: 10,right: 11.5,top: 18.5,bottom: 18),
                            // padding: EdgeInsets.only(left: 10,right: 11.5,top: 13,bottom: 13),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              children: [
                                //活动方式
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: const Text('选择方式',style: TextStyle(
                                          color:Color(0xff999999),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    typeSelectRow=0;
                                                    typeSelectName = 'AA制';
                                                  });
                                                },
                                                child: typeSelectRow==0?Container(
                                                  alignment: Alignment.center,
                                                  width: 13,height: 13,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Color(0xffFE7A24),width:1 ),
                                                      borderRadius: BorderRadius.all(Radius.circular(13/2))
                                                  ),
                                                  child: Container(
                                                    width: 8,height: 8,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffFE7A24),
                                                        borderRadius: BorderRadius.all(Radius.circular(8/2))
                                                    ),
                                                  ),
                                                ):Container(
                                                  width: 13,height: 13,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Color(0xff999999),width:1 ),
                                                      borderRadius: BorderRadius.all(Radius.circular(13/2))
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 7.5,),
                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    typeSelectRow=0;
                                                    typeSelectName = 'AA制';
                                                  });
                                                },
                                                child:  Text('AA制',style: TextStyle(
                                                    color:Color(0xff333333),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500)),
                                              ),

                                              SizedBox(width: 16.5,),

                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    typeSelectRow=1;
                                                    typeSelectName = '发起人全款';
                                                  });
                                                },
                                                child: typeSelectRow==1?Container(
                                                  alignment: Alignment.center,
                                                  width: 13,height: 13,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Color(0xffFE7A24),width:1 ),
                                                      borderRadius: BorderRadius.all(Radius.circular(13/2))
                                                  ),
                                                  child: Container(
                                                    width: 8,height: 8,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffFE7A24),
                                                        borderRadius: BorderRadius.all(Radius.circular(8/2))
                                                    ),
                                                  ),
                                                ):Container(
                                                  width: 13,height: 13,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Color(0xff999999),width:1 ),
                                                      borderRadius: BorderRadius.all(Radius.circular(13/2))
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 7.5,),
                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    typeSelectRow=1;
                                                    typeSelectName = '发起人全款';
                                                  });
                                                },
                                                child:  Text('发起人全款',style: TextStyle(
                                                    color:Color(0xff333333),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 37,),

                                //活动人数
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: const Text('选择人数',style: TextStyle(
                                            color:Color(0xff999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(

                                            child: Text(personNameSelectRow==0?'男：1 女：1':personNameSelectRow==1?'男：2 女：2':personNameSelectRow==2?'男：3 女：3':'男：${personNameSelectName} 女：${womenNameSelectName}',style: TextStyle(
                                                color:Color(0xff333333),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                          ),
                                          SizedBox(width: 8,),
                                          Image(image: AssetImage('images/gray_rightarrow_image.png'),width: 5.5,height: 11,)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24.5,),

                                //人数选择
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          personNameSelectRow = 0;
                                          personNameSelectName = '1';
                                          womenNameSelectName = '1';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            color: personNameSelectRow==0?Color(0xffFCF4EE):Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(Radius.circular(14))
                                        ),
                                        child: Text('一男一女',style: TextStyle(
                                            color:personNameSelectRow==0? Color(0xffFE7A24):const Color(0xff999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          personNameSelectRow = 1;
                                          personNameSelectName = '2';
                                          womenNameSelectName = '2';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            color: personNameSelectRow==1?Color(0xffFCF4EE):Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(Radius.circular(14))
                                        ),
                                        child: Text('二男二女',style: TextStyle(
                                            color:personNameSelectRow==1? Color(0xffFE7A24):const Color(0xff999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          personNameSelectRow = 2;
                                          personNameSelectName = '3';
                                          womenNameSelectName = '3';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            color: personNameSelectRow==2?Color(0xffFCF4EE):Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(Radius.circular(14))
                                        ),
                                        child: Text('三男三女',style: TextStyle(
                                            color:personNameSelectRow==2? Color(0xffFE7A24):const Color(0xff999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          personNameSelectRow = 3;
                                          // personNameSelectName = '男:未选择';
                                          // womenNameSelectName = '女：未选择';
                                          showTefieldNum();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            color: personNameSelectRow==3?Color(0xffFCF4EE):Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(Radius.circular(14))
                                        ),
                                        child: Text('其他',style: TextStyle(
                                            color:personNameSelectRow==3? Color(0xffFE7A24):const Color(0xff999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                      ),
                                    ),

                                  ],
                                ),


                                typeSelectRow==0?SizedBox(height: 24.5,):Container(),
                                typeSelectRow==0?GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    setState(() {
                                      _requestFocus();

                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: const Text('人均活动费用',style: TextStyle(
                                              color:Color(0xff999999),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          ),),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(

                                              child: Text('¥',style: TextStyle(
                                                  color:Color(0xff333333),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(width: 5,),
                                            Container(
                                              width: 50,
                                              margin: const EdgeInsets.only(right: 0 ),
                                              child: TextField(
                                                focusNode: _focusNode,
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                                                controller: priceController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textAlign: TextAlign.left,
                                                decoration: InputDecoration(
                                                    hintText: '费用',
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
                                      ],
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),


                          //第三部分
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(top: 18,bottom: 18),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              children: [

                                //活动名称
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动名称',style: TextStyle(
                                            color:Color(0xff999999),
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
                                              width: MediaQuery.of(context).size.width - 30 - 50-50,
                                              margin: const EdgeInsets.only(right: 15 ),
                                              child: TextField(
                                                maxLines: 2,
                                                maxLength: 30,
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                                                controller: nameController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                    counterText: '',
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

                                //活动地址
                                Container(

                                  margin: const EdgeInsets.only(top: 16.5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5),
                                        child: const Text('活动地址',style: TextStyle(
                                            color:Color(0xff999999),
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
                                              width: MediaQuery.of(context).size.width - 30 - 50-50,
                                              margin: const EdgeInsets.only(right: 15 ),
                                              child: TextField(
                                                maxLength: 30,
                                                maxLines: 2,
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                                                controller: addressController,
                                                textAlignVertical: TextAlignVertical.center,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                    counterText: '',
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
                                  margin: const EdgeInsets.only(top: 16.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.5,bottom: 17.5),
                                        child: const Text('活动描述',style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
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
                                                  _limitExceeded = value.length > 2000;
                                                });
                                              },
                                              textInputAction: TextInputAction.done,
                                              controller: detailController,
                                              // scrollPadding: EdgeInsets.zero,
                                              // autofocus: true,
                                              maxLength: 2000,
                                              maxLines: 10,
                                              style: const TextStyle(
                                                  fontSize: 14, color: Color(0xff333333)),
                                              decoration: InputDecoration(
                                                // errorText: _limitExceeded ? "最多只能输入100个字符" : null,
                                                  hintStyle: TextStyle(
                                                      color:
                                                      const Color(0xff999999).withOpacity(1),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500),
                                                  hintText: '请输入活动描述',
                                                  contentPadding: EdgeInsets.zero,
                                                  // isDense: true,

                                                  border: InputBorder.none),
                                            ),
                                          )),
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
                                            color:Color(0xff999999),
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

                              ],
                            ),
                          ),


                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 15),
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
                                  child: const Text('①.活动会根据平台需要进行审核；',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('2.活动发起人会占用活动的对应性别名额；',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('3.活动审核通过后才会正式发布在平台；',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3),
                                  alignment: Alignment.topLeft,
                                  child: const Text('4.活动未开始前允许发起人关闭活动；',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10,top: 3,right: 10),
                                  alignment: Alignment.topLeft,
                                  child: const Text('5.保证发布活动的真实性、合法性、并承诺不存在违反法律、行政法规的强制性、禁止性规定及公序良俗的情形。',style: TextStyle(color: Color(0xff333333),fontSize: 13,fontWeight: FontWeight.bold),),
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

  void _requestFocus() {
    setState(() {
      _focusNode.requestFocus();
    });
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


  //创建活动
  createActivitySubmit() async {

    if (priceController.text.isEmpty == true&&typeSelectRow==0){
      BotToast.showText(text: '请输入人均活动费用');
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
    map['costShare'] = typeSelectRow==0?'1':'2';
    map['activeCost'] = typeSelectRow==0?int.parse(priceController.text):0;
    map['activeSource'] = '0';
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
    var formatter1 = DateFormat('HH:mm');
    var formatter2 = DateFormat('yyyy-MM-dd HH:mm');
    String formatted1 = formatter1.format(DateTime.parse(widget.userInfoDic['activeTimeBegin'].toString()));
    String formatted2 = formatter2.format(DateTime.parse(widget.userInfoDic['activeTimeEnd'].toString()));

    setState(() {

      typeSelectRow = widget.userInfoDic['costShare'].toString()=='1'?0:1;
      personNameSelectName = widget.userInfoDic['menNum'].toString();
      womenNameSelectName = widget.userInfoDic['womenNum'].toString();
      personNameSelectRow = widget.userInfoDic['menNum']=='1'?0:widget.userInfoDic['menNum']=='2'?1:widget.userInfoDic['menNum']=='3'?2:3;
      womenNameSelectRow = widget.userInfoDic['womenNum']=='1'?0:widget.userInfoDic['womenNum']=='2'?1:widget.userInfoDic['womenNum']=='3'?2:3;
      dateSelect = widget.userInfoDic['activeDate'].toString();
      timeSelect= formatted1;//;
      endTimeSelect = formatted2;
      nameController.text = widget.userInfoDic['name'].toString();
      addressController.text = widget.userInfoDic['address'].toString();
      detailController.text = widget.userInfoDic['activeDesc'].toString();
      priceController.text = widget.userInfoDic['activeCost'].toString();
    });
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
            typeSelectId = typeList[position]['id'];
            typeSelectRow=position;
          });

        },
        onChanged: (p,position){

        },
        onCancel: (bool isCancel){}
    );
  }


  //选择参与人数
  _showPersonNumPicker(){
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
        setState(() {timeSelect= formatted1;//;
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