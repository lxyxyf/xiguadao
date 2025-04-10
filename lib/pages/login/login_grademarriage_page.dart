
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/pages/login/login_shimingrenzheng.dart';
import 'package:xinxiangqin/pages/login/login_smoke_dringk_page.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_character_page.dart';
import 'login_future_page.dart';

class LoginGradeMarriagePage extends StatefulWidget {
  const LoginGradeMarriagePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginGradeMarriagePagePageState();
  }
}

class LoginGradeMarriagePagePageState extends State<LoginGradeMarriagePage> {
  final GlobalKey _incomeGlobalKey = GlobalKey();
  var selectRow = 0;
  var educationSelectRow = 0;
  //星座标题列表
  final List<String> xingzuoTitleList = [
    '水瓶座','双鱼座','白羊座','金牛座','双子座','巨蟹座','狮子座','处女座','天秤座','天蝎座','射手座','摩羯座'
  ];
//星座图片列表
  final List<String> xingzuoUnselectImageList = [
    'images/xingzuo/shuiping_unselect.png','images/xingzuo/shuangyu_unselect.png','images/xingzuo/baiyang_unselect.png',
    'images/xingzuo/jinniu_unselect.png','images/xingzuo/shuangzi_unselect.png','images/xingzuo/juxie_unselect.png',
    'images/xingzuo/shizi_unselect.png','images/xingzuo/chunv_unselect.png','images/xingzuo/tianping_unselect.png',
    'images/xingzuo/tianxie_unselect.png','images/xingzuo/sheshou_unselect.png','images/xingzuo/mojie_unselect.png'

  ];

  final List<String> xingzuoSelectImageList = [
    'images/xingzuo/shuiping.png','images/xingzuo/shuangyu.png','images/xingzuo/baiyang.png',
    'images/xingzuo/jinniu.png','images/xingzuo/shuangzi.png','images/xingzuo/juxie.png',
    'images/xingzuo/shizi.png','images/xingzuo/chunv.png','images/xingzuo/tianping.png',
    'images/xingzuo/tianxie.png','images/xingzuo/sheshou.png','images/xingzuo/mojie.png'

  ];
  int xingzuoSelectRow = 0;

  //婚况
  final List<String> _marrigeList = [
    '未婚','离异'
  ];



  @override
  void initState() {
    super.initState();
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
                                        value: 7/7,
                                      ),
                                    )
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 34.5),
                                  child: const Text(
                                    '您的婚况是？',
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
                                  child: Row(
                                    children: [
                                      //未婚
                                      InkWell(
                                        onTap: (){
                                          print('点击的0');
                                          _clickNum(0);
                                        },
                                        child: selectRow==0?Container(
                                            padding: const EdgeInsets.only(left: 25),
                                            margin: const EdgeInsets.only(right: 14.5),
                                            width: (MediaQuery.of(context).size.width-79)/3,
                                            height: 43,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(21.5),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xFFFE7A24), // 边框颜色
                                                width: 1.0, // 边框宽度
                                              ),
                                            ),
                                            child: Container(child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(left: 9.5),
                                                  child: const Text('未婚',textAlign: TextAlign.center,style: TextStyle(
                                                      color:Color(0xFFFE7A24) ,fontSize:13,fontWeight: FontWeight.w500
                                                  ),),
                                                ),
                                                Container(
                                                  width: 9.5,
                                                  height: 9.5,
                                                  margin: const EdgeInsets.only(bottom: 10,left: 9.5),
                                                  child: const Image(image: AssetImage('images/fourstar.png')),
                                                )
                                              ],
                                            ),)
                                        ):Container(
                                          alignment: Alignment.center,

                                          margin: const EdgeInsets.only(right: 14.5),
                                          width: (MediaQuery.of(context).size.width-79)/3,
                                          height: 43,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(21.5),
                                            color: Colors.white,

                                          ),
                                          child: const Text('未婚',textAlign: TextAlign.center,style: TextStyle(
                                              color:Color(0xFF333333) ,fontSize:13,fontWeight: FontWeight.w500
                                          ),),
                                        ),
                                      ),



                                      //离异
                                      InkWell(
                                        onTap: (){
                                          print('点击的1');
                                          _clickNum(1);
                                        },
                                        child: selectRow==1?Container(
                                            padding: const EdgeInsets.only(left: 25),
                                            margin: const EdgeInsets.only(right: 14.5),
                                            width: (MediaQuery.of(context).size.width-79)/3,
                                            height: 43,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(21.5),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xFFFE7A24), // 边框颜色
                                                width: 1.0, // 边框宽度
                                              ),
                                            ),
                                            child: Container(child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(left: 9.5),
                                                  child: const Text('离异',textAlign: TextAlign.center,style: TextStyle(
                                                      color:Color(0xFFFE7A24) ,fontSize:13,fontWeight: FontWeight.w500
                                                  ),),
                                                ),
                                                Container(
                                                  width: 9.5,
                                                  height: 9.5,
                                                  margin: const EdgeInsets.only(bottom: 10,left: 9.5),
                                                  child: const Image(image: AssetImage('images/fourstar.png')),
                                                )
                                              ],
                                            ),)
                                        ):Container(
                                          alignment: Alignment.center,

                                          margin: const EdgeInsets.only(right: 14.5),
                                          width: (MediaQuery.of(context).size.width-79)/3,
                                          height: 43,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(21.5),
                                            color: Colors.white,

                                          ),
                                          child: const Text('离异',textAlign: TextAlign.center,style: TextStyle(
                                              color:Color(0xFF333333) ,fontSize:13,fontWeight: FontWeight.w500
                                          ),),
                                        ),
                                      ),





                                    ],
                                  )
                              ),

                              Container(
                                  padding: const EdgeInsets.only(top: 34.5),
                                  child: const Text(
                                    '您的星座是？',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF333333)
                                    ),
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 18.5,bottom: 24),
                                  child: const Text(
                                    '请真实选择您的星座',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                              ),

                              Container(
                                height: 150,
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  //设置滚动方向
                                  scrollDirection: Axis.vertical,
                                  //设置列数
                                  crossAxisCount: 4,
                                  //设置内边距
                                  padding: const EdgeInsets.all(0),
                                  //设置横向间距
                                  crossAxisSpacing: 10,
                                  //设置主轴间距
                                  mainAxisSpacing: 10,
                                  childAspectRatio:69/29,
                                  children: _getData(),
                                ),
                              ),



                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 20, vertical: 20),
                              //   height: 170,
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(horizontal: 10),
                              //     width: MediaQuery.of(context).size.width - 60,
                              //     child: CupertinoPicker(
                              //         key: _incomeGlobalKey,
                              //         useMagnifier: true,
                              //         magnification: 1.2,
                              //         itemExtent: 32.0,
                              //         squeeze: 1.2,
                              //         // 每个项目的尺寸
                              //         selectionOverlay: _selectionOverlayWidget(),
                              //         onSelectedItemChanged: (int index) {
                              //           print('第一列+$index');
                              //           setState(() {
                              //             educationSelectRow = index;
                              //           });
                              //         },
                              //         // onSelectedItemChanged: (v) {
                              //         //   career=
                              //         // },
                              //         children: _educationList.map((data) {
                              //           return Center(
                              //             child: Text(
                              //               data,
                              //               style: const TextStyle(fontSize: 14),
                              //             ),
                              //           );
                              //         }).toList()),
                              //   ),
                              // ),

                            ],
                          ),
                        )),
                  ],
                ),
              ),

              Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _next();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 50,
                          margin: const EdgeInsets.only(left: 25, right: 25,bottom:44,top: 88),


                          child: const Image(
                            image: AssetImage('images/login_next_button.png'),
                            width: 89.5,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }


  List<Widget> _getData() {
    List<Widget> list = [];
    for (var i = 0; i < xingzuoTitleList.length; i++) {
      list.add(Container(

        child: GestureDetector(
          onTap: (){
            //单选事件
            setState(() {
              xingzuoSelectRow = i;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(14.5)),
                  border: Border.all(color: xingzuoSelectRow==i?Color(0xffFE7A24):Colors.white, width: 1)
              ),
              width: 69,
              height: 29,
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Image(image: xingzuoSelectRow!=i?AssetImage(xingzuoUnselectImageList[i]):AssetImage(xingzuoSelectImageList[i]),fit: BoxFit.cover,width: 16,height: 17.5,),
                  SizedBox(width: 4.5,),
                  Text(xingzuoTitleList[i],style: TextStyle(color: xingzuoSelectRow==i?Color(0xffFE7A24):Color(0xff333333),fontSize: 13,fontWeight: FontWeight.w500),)
                ],
              )
          ),
        )
//
//         decoration:
//         BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
      ));
    }
    return list;
  }

  void _next() async {
    _saveUserInfo();
  }


  ///提交保存
  void _saveUserInfo() async {

    Map<String, dynamic> map = {};
    map['marriage'] = selectRow+1;
    map['constellation'] = xingzuoSelectRow;
    print(map);
    // return;
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginSmokeDringkPage();
          }));
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext ccontext) {
      //       return const LoginShimingrenzheng();
      //     }));
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
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
