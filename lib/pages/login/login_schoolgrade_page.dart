
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/pages/login/login_character_new_page.dart';
import 'package:xinxiangqin/pages/login/login_grademarriage_page.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_character_page.dart';

class LoginSchoolgradePage extends StatefulWidget {
  const LoginSchoolgradePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginGradeMarriagePagePageState();
  }
}

class LoginGradeMarriagePagePageState extends State<LoginSchoolgradePage> {
  final GlobalKey _incomeGlobalKey = GlobalKey();
  var selectRow = 0;
  var educationSelectRow = 0;
  TextEditingController controller = TextEditingController();
  //学历
  final List<String> _educationList = [
    '中专','高中及以下','大专','大学本科','硕士','博士'
  ];
  String schoolName = '';

  //婚况
  final List<String> _marrigeList = [
    '未婚','离异'
  ];

  @override
  void initState() {
    super.initState();
  }

  //监听textfield内容变化
  void _handleTextChanged(String text) {
    schoolName = text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _createView(),
    );
  }

  // 中间分割线
  Widget _selectionOverlayWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Column(
        children: [
          const Divider(
            height: 0.5,
            color: Color(0xffFE7A24),
          ),
          Expanded(child: Container()),
          const Divider(
            height: 0.5,
            color: Color(0xffFE7A24),
          ),
        ],
      ),
    );
  }

  Widget _createView() {
    return GestureDetector(
      onTap: () {
        //点击空白区域，键盘收起
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/login_info_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     padding: EdgeInsets.only(left: 15,top: MediaQuery.of(context).padding.top+33),
                     child: GestureDetector(
                       onTap: () {
                         Navigator.pop(context);
                       },
                       child: const Icon(Icons.arrow_back_ios),
                     ),
                   ),
                   //顶部内容
                   Container(
                       child: Container(
                         padding:  const EdgeInsets.only(left: 25, right: 25, top: 21.5),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(4), // 设置圆角的半径
                               child: Container(
                                 //进度条
                                   child: const SizedBox(
                                     height: 8,
                                     child: LinearProgressIndicator(
                                       backgroundColor: Colors.white,
                                       valueColor: AlwaysStoppedAnimation(Color(0xFFFE7A24)),
                                       value: 5/7,
                                     ),
                                   )
                               ),
                             ),
                             Container(
                                 padding: const EdgeInsets.only(top: 34.5),
                                 child: const Text(
                                   '您的学校是？',
                                   style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.w700,
                                       color: Color(0xFF333333)
                                   ),
                                 )
                             ),
                             Container(
                                 padding: const EdgeInsets.only(top: 18.5),
                                 child: const Text(
                                   '请真实填写学校',
                                   style: TextStyle(
                                     color: Color(0xFF666666),
                                     fontSize: 13,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 )
                             ),


                             Container(
                               alignment: Alignment.centerLeft,
                               decoration: const BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.all(Radius.circular(25))
                               ),
                               // BorderRadius.only(
                               //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                               padding: const EdgeInsets.only(left: 16,right: 16),
                               margin: const EdgeInsets.only(top: 26 ),
                               height: 50,

                               child: TextField(
                                 controller: controller,
                                 onChanged: _handleTextChanged,
                                 // scrollPadding: EdgeInsets.zero,
                                 // autofocus: true,
                                 textAlignVertical:TextAlignVertical.center,
                                 maxLength: 10,
                                 style: const TextStyle(
                                     fontSize: 15, color: Color(0xff333333)),
                                 decoration: const InputDecoration(
                                     counterText: '',
                                     contentPadding: EdgeInsets.zero,
                                     isDense: true,
                                     hintStyle: TextStyle(fontSize: 12, color: Color(0xff999999)),

                                     hintText: '请真实填写您的学校',
                                     border: InputBorder.none),
                               ),
                             ),

                             // Container(
                             //     child: Row(
                             //       children: [
                             //         //未婚
                             //         InkWell(
                             //           onTap: (){
                             //             print('点击的0');
                             //             _clickNum(0);
                             //           },
                             //           child: selectRow==0?Container(
                             //               padding: const EdgeInsets.only(left: 25),
                             //               margin: const EdgeInsets.only(right: 14.5),
                             //               width: (MediaQuery.of(context).size.width-79)/3,
                             //               height: 43,
                             //               decoration: BoxDecoration(
                             //                 borderRadius: BorderRadius.circular(21.5),
                             //                 color: Colors.white,
                             //                 border: Border.all(
                             //                   color: const Color(0xFFFE7A24), // 边框颜色
                             //                   width: 1.0, // 边框宽度
                             //                 ),
                             //               ),
                             //               child: Container(child: Row(
                             //                 // mainAxisAlignment: MainAxisAlignment.center,
                             //                 // crossAxisAlignment: CrossAxisAlignment.center,
                             //                 children: [
                             //                   Container(
                             //                     margin: const EdgeInsets.only(left: 9.5),
                             //                     child: const Text('未婚',textAlign: TextAlign.center,style: TextStyle(
                             //                         color:Color(0xFFFE7A24) ,fontSize:13,fontWeight: FontWeight.w500
                             //                     ),),
                             //                   ),
                             //                   Container(
                             //                     width: 9.5,
                             //                     height: 9.5,
                             //                     margin: const EdgeInsets.only(bottom: 10,left: 9.5),
                             //                     child: const Image(image: AssetImage('images/fourstar.png')),
                             //                   )
                             //                 ],
                             //               ),)
                             //           ):Container(
                             //             alignment: Alignment.center,
                             //
                             //             margin: const EdgeInsets.only(right: 14.5),
                             //             width: (MediaQuery.of(context).size.width-79)/3,
                             //             height: 43,
                             //
                             //             decoration: BoxDecoration(
                             //               borderRadius: BorderRadius.circular(21.5),
                             //               color: Colors.white,
                             //
                             //             ),
                             //             child: const Text('未婚',textAlign: TextAlign.center,style: TextStyle(
                             //                 color:Color(0xFF333333) ,fontSize:13,fontWeight: FontWeight.w500
                             //             ),),
                             //           ),
                             //         ),
                             //
                             //
                             //
                             //         //离异
                             //         InkWell(
                             //           onTap: (){
                             //             print('点击的1');
                             //             _clickNum(1);
                             //           },
                             //           child: selectRow==1?Container(
                             //               padding: const EdgeInsets.only(left: 25),
                             //               margin: const EdgeInsets.only(right: 14.5),
                             //               width: (MediaQuery.of(context).size.width-79)/3,
                             //               height: 43,
                             //               decoration: BoxDecoration(
                             //                 borderRadius: BorderRadius.circular(21.5),
                             //                 color: Colors.white,
                             //                 border: Border.all(
                             //                   color: const Color(0xFFFE7A24), // 边框颜色
                             //                   width: 1.0, // 边框宽度
                             //                 ),
                             //               ),
                             //               child: Container(child: Row(
                             //                 children: [
                             //                   Container(
                             //                     margin: const EdgeInsets.only(left: 9.5),
                             //                     child: const Text('离异',textAlign: TextAlign.center,style: TextStyle(
                             //                         color:Color(0xFFFE7A24) ,fontSize:13,fontWeight: FontWeight.w500
                             //                     ),),
                             //                   ),
                             //                   Container(
                             //                     width: 9.5,
                             //                     height: 9.5,
                             //                     margin: const EdgeInsets.only(bottom: 10,left: 9.5),
                             //                     child: const Image(image: AssetImage('images/fourstar.png')),
                             //                   )
                             //                 ],
                             //               ),)
                             //           ):Container(
                             //             alignment: Alignment.center,
                             //
                             //             margin: const EdgeInsets.only(right: 14.5),
                             //             width: (MediaQuery.of(context).size.width-79)/3,
                             //             height: 43,
                             //
                             //             decoration: BoxDecoration(
                             //               borderRadius: BorderRadius.circular(21.5),
                             //               color: Colors.white,
                             //
                             //             ),
                             //             child: const Text('离异',textAlign: TextAlign.center,style: TextStyle(
                             //                 color:Color(0xFF333333) ,fontSize:13,fontWeight: FontWeight.w500
                             //             ),),
                             //           ),
                             //         ),
                             //
                             //
                             //
                             //
                             //
                             //       ],
                             //     )
                             // ),

                             Container(
                                 padding: const EdgeInsets.only(top: 34.5),
                                 child: const Text(
                                   '您的学历是？',
                                   style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.w700,
                                       color: Color(0xFF333333)
                                   ),
                                 )
                             ),
                             Container(
                                 padding: const EdgeInsets.only(top: 18.5,bottom: 39.5),
                                 child: const Text(
                                   '请真实填写，以便为您推荐更合适的异性',
                                   style: TextStyle(
                                     color: Color(0xFF666666),
                                     fontSize: 13,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 )
                             ),


                             Container(
                               padding: const EdgeInsets.symmetric(
                                   horizontal: 20, vertical: 20),
                               height: 170,
                               child: Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 width: MediaQuery.of(context).size.width - 60,
                                 child: CupertinoPicker(
                                     key: _incomeGlobalKey,
                                     useMagnifier: true,
                                     magnification: 1.2,
                                     itemExtent: 32.0,
                                     squeeze: 1.2,
                                     // 每个项目的尺寸
                                     selectionOverlay: _selectionOverlayWidget(),
                                     onSelectedItemChanged: (int index) {
                                       print('第一列+$index');
                                       setState(() {
                                         educationSelectRow = index;
                                       });
                                     },
                                     // onSelectedItemChanged: (v) {
                                     //   career=
                                     // },
                                     children: _educationList.map((data) {
                                       return Center(
                                         child: Text(
                                           data,
                                           style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,
                                           color: Color(0xff333333)),
                                         ),
                                       );
                                     }).toList()),
                               ),
                             ),

                           ],
                         ),
                       )),
                 ],
               ),
             ),

              Container(
                  child: GestureDetector(
                    onTap: () {
                      _next();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      margin: const EdgeInsets.only(left: 25, right: 25,bottom: 101,top: 94),


                      child: const Image(
                        image: AssetImage('images/login_next_button.png'),
                        width: 89.5,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),)
            ],
          ),
        ),
      ),
    );
  }

  void _next() async {
    _saveUserInfo();
  }


  ///提交保存
  void _saveUserInfo() async {

    if (schoolName.isEmpty == true){
      BotToast.showText(text: '请填写您的学校');
      return;
    }else{

    }
    Map<String, dynamic> map = {};
    map['graduatFrom'] = schoolName;
    map['education'] = educationSelectRow+1;
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginCharacterNewPage();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }



  void _clickNum(e) async{

    setState(() {
      selectRow = e;
    });
  }


  @override
  void dispose() {
    BotToast.closeAllLoading();
    BotToast.cleanAll();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
