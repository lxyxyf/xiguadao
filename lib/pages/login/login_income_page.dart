import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_height_picker/cupertino_height_picker.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/pages/login/career.dart';
import '../../network/apis.dart';
import '../../network/network_manager.dart';
import '../../tools/event_tools.dart';
import '../../widgets/yk_easy_loading_widget.dart';
import 'login_address_page.dart';
import 'dart:convert';

class LoginIncomePage extends StatefulWidget {
  const LoginIncomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginIncomePageState();
  }
}

class LoginIncomePageState extends State<LoginIncomePage> {
  int _counter = 0;
  final GlobalKey _incomeGlobalKey = GlobalKey();
  final GlobalKey _provinceGlobalKey = GlobalKey();
  GlobalKey erji = GlobalKey();
  TextEditingController controller = TextEditingController();

  List pickerChildren = [
    '5万以下', '5万-10万','10万-20万','20万-50万'
  ];

  String career = '';

  // List pickerChildren = ["1", "2", "3"];
  var controllr = FixedExtentScrollController(initialItem: 0);

  double heightInCm = 150;
  HeightUnit selectedHeightUnit = HeightUnit.cm;
  bool canConvertUnit = true;
  bool showSeparationText = true;

  ///是否同意用户协议和隐私政策
  bool isAgree = false;
  late List<Career> MM;
  // Career career = Career();
  String jsonArrayString =
      '[{"text":"销售","value":"销售","children":[{"text":"销售总监","value":"销售总监"},{"text":"销售经理","value":"销售经理"},{"text":"销售主管","value":"销售主管"},{"text":"销售专员","value":"销售专员"},{"text":"渠道/分销管理","value":"渠道/分销管理"},{"text":"渠道/分销专员","value":"渠道/分销专员"},{"text":"经销商","value":"经销商"},{"text":"客户经理","value":"客户经理"},{"text":"客户代表","value":"客户代表"},{"text":"销售","value":"销售"}]},{"text":"客户服务","value":"客户服务","children":[{"text":"客服经理","value":"客服经理"},{"text":"客服主管","value":"客服主管"},{"text":"客服专员","value":"客服专员"},{"text":"客服协调","value":"客服协调"},{"text":"客服技术支持","value":"客服技术支持"},{"text":"客户服务","value":"客户服务"}]},{"text":"计算机/互联网","value":"计算机/互联网","children":[{"text":"IT技术总监","value":"IT技术总监"},{"text":"IT技术经理","value":"IT技术经理"},{"text":"IT工程师","value":"IT工程师"},{"text":"系统管理员","value":"系统管理员"},{"text":"测试专员","value":"测试专员"},{"text":"运营管理","value":"运营管理"},{"text":"网页设计","value":"网页设计"},{"text":"网站编辑","value":"网站编辑"},{"text":"网站产品经理","value":"网站产品经理"},{"text":"计算机/互联网","value":"计算机/互联网"}]},{"text":"通信/电子","value":"通信/电子","children":[{"text":"通信技术","value":"通信技术"},{"text":"电子技术","value":"电子技术"},{"text":"通信/电子","value":"通信/电子"}]},{"text":"生产/制造","value":"生产/制造","children":[{"text":"工厂经理","value":"工厂经理"},{"text":"工程师","value":"工程师"},{"text":"项目主管","value":"项目主管"},{"text":"营运经理","value":"营运经理"},{"text":"营运主管","value":"营运主管"},{"text":"车间主任","value":"车间主任"},{"text":"物料管理","value":"物料管理"},{"text":"生产领班","value":"生产领班"},{"text":"操作工人","value":"操作工人"},{"text":"安全管理","value":"安全管理"},{"text":"生产/制造","value":"生产/制造"}]},{"text":"物流/仓储","value":"物流/仓储","children":[{"text":"物流经理","value":"物流经理"},{"text":"物流主管","value":"物流主管"},{"text":"物流专员","value":"物流专员"},{"text":"仓库经理","value":"仓库经理"},{"text":"仓库管理员","value":"仓库管理员"},{"text":"货运代理","value":"货运代理"},{"text":"集装箱业务","value":"集装箱业务"},{"text":"海关事务管理","value":"海关事务管理"},{"text":"报单员","value":"报单员"},{"text":"快递员","value":"快递员"},{"text":"物流/仓储","value":"物流/仓储"}]},{"text":"商贸/采购","value":"商贸/采购","children":[{"text":"商务经理","value":"商务经理"},{"text":"商务专员","value":"商务专员"},{"text":"采购经理","value":"采购经理"},{"text":"采购专员","value":"采购专员"},{"text":"外贸经理","value":"外贸经理"},{"text":"外贸专员","value":"外贸专员"},{"text":"业务跟单","value":"业务跟单"},{"text":"报关员","value":"报关员"},{"text":"商贸/采购","value":"商贸/采购"}]},{"text":"人事/行政","value":"人事/行政","children":[{"text":"人事总监","value":"人事总监"},{"text":"人事经理","value":"人事经理"},{"text":"人事主管","value":"人事主管"},{"text":"人事专员","value":"人事专员"},{"text":"招聘经理","value":"招聘经理"},{"text":"招聘专员","value":"招聘专员"},{"text":"培训经理","value":"培训经理"},{"text":"培训专员","value":"培训专员"},{"text":"秘书","value":"秘书"},{"text":"文员","value":"文员"},{"text":"后勤","value":"后勤"},{"text":"人事/行政","value":"人事/行政"}]},{"text":"高级管理","value":"高级管理","children":[{"text":"总经理","value":"总经理"},{"text":"副总经理","value":"副总经理"},{"text":"合伙人","value":"合伙人"},{"text":"总监","value":"总监"},{"text":"经理","value":"经理"},{"text":"总裁助理","value":"总裁助理"},{"text":"高级管理","value":"高级管理"}]},{"text":"广告/市场","value":"广告/市场","children":[{"text":"广告客户经理","value":"广告客户经理"},{"text":"广告客户专员","value":"广告客户专员"},{"text":"广告设计经理","value":"广告设计经理"},{"text":"广告设计专员","value":"广告设计专员"},{"text":"广告策划","value":"广告策划"},{"text":"市场营销经理","value":"市场营销经理"},{"text":"市场营销专员","value":"市场营销专员"},{"text":"市场策划","value":"市场策划"},{"text":"市场调研与分析","value":"市场调研与分析"},{"text":"市场拓展","value":"市场拓展"},{"text":"公关经理","value":"公关经理"},{"text":"公关专员","value":"公关专员"},{"text":"媒介经理","value":"媒介经理"},{"text":"媒介专员","value":"媒介专员"},{"text":"品牌经理","value":"品牌经理"},{"text":"品牌专员","value":"品牌专员"},{"text":"广告/市场","value":"广告/市场"}]},{"text":"传媒/艺术","value":"传媒/艺术","children":[{"text":"主编","value":"主编"},{"text":"编辑","value":"编辑"},{"text":"作家","value":"作家"},{"text":"撰稿人","value":"撰稿人"},{"text":"文案策划","value":"文案策划"},{"text":"出版发行","value":"出版发行"},{"text":"导演","value":"导演"},{"text":"记者","value":"记者"},{"text":"主持人","value":"主持人"},{"text":"演员","value":"演员"},{"text":"模特","value":"模特"},{"text":"经纪人","value":"经纪人"},{"text":"摄影师","value":"摄影师"},{"text":"影视后期制作","value":"影视后期制作"},{"text":"设计师","value":"设计师"},{"text":"画家","value":"画家"},{"text":"音乐家","value":"音乐家"},{"text":"舞蹈","value":"舞蹈"},{"text":"传媒/艺术","value":"传媒/艺术"}]},{"text":"生物/制药","value":"生物/制药","children":[{"text":"生物工程","value":"生物工程"},{"text":"药品生产","value":"药品生产"},{"text":"临床研究","value":"临床研究"},{"text":"医疗器械","value":"医疗器械"},{"text":"化工工程师","value":"化工工程师"},{"text":"生物/制药","value":"生物/制药"}]},{"text":"医疗/护理","value":"医疗/护理","children":[{"text":"医疗管理","value":"医疗管理"},{"text":"医生","value":"医生"},{"text":"心理医生","value":"心理医生"},{"text":"药剂师","value":"药剂师"},{"text":"护士","value":"护士"},{"text":"兽医","value":"兽医"},{"text":"医疗/护理","value":"医疗/护理"}]},{"text":"金融/银行/保险","value":"金融/银行/保险","children":[{"text":"投资","value":"投资"},{"text":"保险","value":"保险"},{"text":"金融","value":"金融"},{"text":"银行","value":"银行"},{"text":"证券","value":"证券"},{"text":"金融/银行/保险","value":"金融/银行/保"}]},{"text":"建筑/房地产","value":"建筑/房地","children":[{"text":"建筑师","value":"建筑师"},{"text":"工程师","value":"工程师"},{"text":"规划师","value":"规划师"},{"text":"景观设计","value":"景观设计"},{"text":"房地产策划","value":"房地产策划"},{"text":"房地产交易","value":"房地产交易"},{"text":"物业管理","value":"物业管理"},{"text":"建筑/房地产","value":"建筑/房地"}]},{"text":"咨询/顾问","value":"咨询/顾问","children":[{"text":"专业顾问","value":"专业顾问"},{"text":"咨询经理","value":"咨询经理"},{"text":"咨询师","value":"咨询师"},{"text":"培训师","value":"培训师"},{"text":"咨询/顾问","value":"咨询/顾问"}]},{"text":"法律","value":"法律","children":[{"text":"律师","value":"律师"},{"text":"律师助理","value":"律师助理"},{"text":"法务经理","value":"法务经理"},{"text":"法务专员","value":"法务专员"},{"text":"知识产权专员","value":"知识产权专员"},{"text":"法律","value":"法律"}]},{"text":"财会/审计","value":"财会/审计","children":[{"text":"财务总监","value":"财务总监"},{"text":"财务经理","value":"财务经理"},{"text":"财务主管","value":"财务主管"},{"text":"会计","value":"会计"},{"text":"注册会计师","value":"注册会计师"},{"text":"审计师","value":"审计师"},{"text":"税务经理","value":"税务经理"},{"text":"税务专员","value":"税务专员"},{"text":"成本经理","value":"成本经理"},{"text":"财会/审计","value":"财会/审计"}]},{"text":"教育/科研","value":"教育/科研","children":[{"text":"教授","value":"教授"},{"text":"讲师/助教","value":"讲师/助教"},{"text":"中学教师","value":"中学教师"},{"text":"小学教师","value":"小学教师"},{"text":"幼师","value":"幼师"},{"text":"教务管理人员","value":"教务管理人员"},{"text":"职业技术教师","value":"职业技术教师"},{"text":"培训师","value":"培训师"},{"text":"科研管理人员","value":"科研管理人员"},{"text":"科研人员","value":"科研人员"},{"text":"教育/科研","value":"教育/科研"}]},{"text":"服务业","value":"服务业","children":[{"text":"餐饮管理","value":"餐饮管理"},{"text":"厨师","value":"厨师"},{"text":"餐厅服务员","value":"餐厅服务员"},{"text":"酒店管理","value":"酒店管理"},{"text":"大堂经理","value":"大堂经理"},{"text":"酒店服务员","value":"酒店服务员"},{"text":"导游","value":"导游"},{"text":"美容师","value":"美容师"},{"text":"健身教练","value":"健身教练"},{"text":"商场经理","value":"商场经理"},{"text":"零售店店长","value":"零售店店长"},{"text":"店员","value":"店员"},{"text":"保安经理","value":"保安经理"},{"text":"保安人员","value":"保安人员"},{"text":"家政服务","value":"家政服务"},{"text":"服务业","value":"服务业"}]},{"text":"交通运输","value":"交通运输","children":[{"text":"飞行员","value":"飞行员"},{"text":"空乘人员","value":"空乘人员"},{"text":"地勤人员","value":"地勤人员"},{"text":"列车司机","value":"列车司机"},{"text":"乘务员","value":"乘务员"},{"text":"船长","value":"船长"},{"text":"船员","value":"船员"},{"text":"司机","value":"司机"},{"text":"交通运输","value":"交通运输"}]},{"text":"政府机构","value":"政府机构","children":[{"text":"公务员","value":"公务员"}]},{"text":"农林牧渔","value":"农林牧渔","children":[{"text":"农林牧渔","value":"农林牧渔"}]},{"text":"自由职业","value":"自由职业","children":[{"text":"自由职业","value":"自由职业"}]},{"text":"在校学生","value":"在校学生","children":[{"text":"在校学生","value":"在校学生"}]},{"text":"待业","value":"待业","children":[{"text":"待业","value":"待业"}]},{"text":"其他职业","value":"其他职业","children":[{"text":"其他职业","value":"其他职业"}]}]';

  int firstSelectRow = 0;
  int secondSelectRow = 0;
  int incomeSelectRow = 0;
  @override
  void initState() {
    super.initState();
    var listDynamic = jsonDecode(jsonArrayString);
    MM = (listDynamic as List<dynamic>)
        .map((e) => Career.fromJson((e as Map<String, dynamic>)))
        .toList();
  }

  void changeIndex(int index) {
    setState(() {
      erji = GlobalKey();
      _counter=index;
      print( _counter);
      print(jsonEncode(MM.elementAt(_counter).children));
      // print("222 "+jsonEncode(career.children));
    });
  }


  //监听textfield内容变化
  void _handleTextChanged(String text) {
    career = text;
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
                     padding: EdgeInsets.only(
                         left: 15, top: MediaQuery.of(context).padding.top + 33),
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
                         padding: const EdgeInsets.only(left: 25, right: 25, top: 21.5),
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
                                       value: 3 / 7,
                                     ),
                                   )),
                             ),
                             Container(
                                 padding: const EdgeInsets.only(top: 34.5),
                                 child: const Text(
                                   '您的职业是？',
                                   style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.w700,
                                       color: Color(0xFF333333)),
                                 )),
                             Container(
                                 padding: const EdgeInsets.only(top: 18.5),
                                 child: const Text(
                                   '请真实填写职业',
                                   style: TextStyle(
                                     color: Color(0xFF666666),
                                     fontSize: 13,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 )),

                             Container(

                               decoration: const BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.all(Radius.circular(25))
                               ),
                               // BorderRadius.only(
                               //   //           topLeft: Radius.circular(8), topRight: Radius.circular(8))
                               padding: const EdgeInsets.only(left: 16,right: 16),
                               margin: const EdgeInsets.only(top: 26 ),
                               height: 50,
                               alignment: Alignment.centerLeft,

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
                                     hintText: '请真实填写您的职业',
                                     border: InputBorder.none),
                               ),
                             ),


                             // Container(
                             //   padding: const EdgeInsets.symmetric(
                             //       horizontal: 20, vertical: 0),
                             //   height: 180,
                             //   child: Row(
                             //     children: [
                             //       Container(
                             //         padding: const EdgeInsets.symmetric(horizontal: 10),
                             //         width: 130,
                             //         child: CupertinoPicker(
                             //             key: _provinceGlobalKey,
                             //             useMagnifier: true,
                             //             magnification: 1.2,
                             //             itemExtent: 32.0,
                             //             squeeze: 1.2,
                             //             // 每个项目的尺寸
                             //             selectionOverlay: _selectionOverlayWidget(),
                             //             onSelectedItemChanged: (int index) {
                             //               changeIndex(index);
                             //               print('第一列+$index');
                             //               firstSelectRow = index;
                             //             },
                             //             // onSelectedItemChanged: (v) {
                             //             //   career=
                             //             // },
                             //             children: MM.map((data) {
                             //               return Center(
                             //                 child: Text(
                             //                   data.text!,
                             //                   style: const TextStyle(fontSize: 14),
                             //                 ),
                             //               );
                             //             }).toList()),
                             //       ),
                             //       StatefulBuilder(builder: (BuildContext context,
                             //           void Function(void Function()) setState) {
                             //         return Container(
                             //           padding: const EdgeInsets.symmetric(horizontal: 10),
                             //           width: 150,
                             //           child: CupertinoPicker(
                             //               key: erji,
                             //               useMagnifier: true,
                             //               magnification: 1.2,
                             //               itemExtent: 32.0,
                             //               squeeze: 1.2,
                             //               // 每个项目的尺寸
                             //               selectionOverlay: _selectionOverlayWidget(),
                             //               onSelectedItemChanged: (int index) {
                             //                 print('第二列+$index');
                             //                 secondSelectRow = index;
                             //               },
                             //               children: MM.elementAt(_counter).children!.map((data) {
                             //                 return Center(
                             //                   child: Text(
                             //                     data.text!,
                             //                     style: const TextStyle(fontSize: 14),
                             //                   ),
                             //                 );
                             //               }).toList()),
                             //         );
                             //       }),
                             //     ],
                             //   ),
                             // ),



                             Container(
                                 padding: const EdgeInsets.only(top: 34.5),
                                 child: const Text(
                                   '您的年收入是？',
                                   style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.w700,
                                       color: Color(0xFF333333)),
                                 )),
                             Container(
                                 padding: const EdgeInsets.only(top: 18.5,bottom: 20),
                                 child: const Text(
                                   '请真实填写年收入',
                                   style: TextStyle(
                                     color: Color(0xFF666666),
                                     fontSize: 13,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 )),

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
                                       incomeSelectRow = index;
                                     },
                                     // onSelectedItemChanged: (v) {
                                     //   career=
                                     // },
                                     children: pickerChildren.map((data) {
                                       return Center(
                                         child: Text(
                                           data!,
                                           style: const TextStyle(fontSize: 14),
                                         ),
                                       );
                                     }).toList()),
                               ),
                             ),


                             const SizedBox(
                               child: Column(
                                 // mainAxisSize: MainAxisSize.min,
                                 children: [],
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

  ///提交保存
  void _saveUserInfo() async {
     List caeerSecond = MM.elementAt(_counter).children as List;
     print(caeerSecond[secondSelectRow].value);

    // String nowdateStr = _selectedDate.toString();
    // int length = 10;
    // if (nowdateStr.length >= length) {
    //   nowdateStr = nowdateStr.substring(0, length); // 结果是 "Hello"
    // } else {
    //   nowdateStr = nowdateStr; // 原样返回字符串
    // }
     if (career.isEmpty == true){
       BotToast.showText(text: '请填写您的职业');
       return;
     }else{

     }
    Map<String, dynamic> map = {};
    map['career'] = career;
    map['monthIncome'] = incomeSelectRow;
     map['monthIncomeName'] = pickerChildren[incomeSelectRow];
    print(map);
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      // BotToast.showText(text: '保存成功');
      //保存成功

      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return const LoginAddressPage();
          }));
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }

  void _next() async {
    _saveUserInfo();
    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext ccontext) {
    //   return LoginAddressPage();
    // }));
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    BotToast.cleanAll();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
