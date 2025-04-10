import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

class Qingshaonianxieyi extends StatefulWidget {
  const Qingshaonianxieyi({super.key});

  @override
  State<StatefulWidget> createState() {
    return PrivacyPolicyPageState();
  }
}

class PrivacyPolicyPageState extends State<Qingshaonianxieyi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Color(0xff333333),
          ),
        ),
        title: const Text(
          '西瓜岛青少年模式功能使用条款',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('欢迎你选择由山东缘分计划有限公司（以下简称“我们”或“平台”）开发、运营、提供的相关产品和服务！'
            '我们非常重视青少年的保护。为保护青少年个人信息的安全，并提供更加丰富、多元的优质内容，'
            '我们开发了“青少年模式”（以下简称“青少年模式”或“该模式”）。'
                    '本《青少年模式功能使用条款》旨在向法定监护人或未成年人的父母（以下简称“监护人”或“家长”）和未成年人（以下又称“被监护人”）说明该模式的运行方式，'
                    '我们将挖掘更多的适合青少年浏览的优质内容，为监护人提供更丰富的管理手段，确保儿童的信息收集、使用在监护人的监督下进行。',
                  style: TextStyle(
                  color: Color(0xff666666),
                    fontSize:14,
                    fontWeight: FontWeight.w500
                ),),

                SizedBox(height: 20,),

                Text('1.与你携手共同守护青少年',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('1.1 未满14周岁的儿童',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('如果你的被监护人是未满14周岁的儿童，他/她使用西瓜岛的普通模式，需要经过你的明确同意；'
                    '如果你不同意他/她使用西瓜岛的普通模式，请你为他/她设置青少年模式。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('在实名认证阶段，若你的被监护人需要完成实名认证，需要经过你的单独明确同意，我们会通过合理的核验措施验证你与你的被监护人的监护关系，'
                    '若你认为我们不当地处理了你或你的被监护人的信息，请通过文末的联系方式及时联系我们。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('1.2 已满14周岁不满18周岁的青少年',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('如果你的被监护人是已满14周岁不满18周岁的青少年，你和你的被监护人可以根据自主需要，选择是否设置“青少年”模式。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('2.保护青少年个人信息安全',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('2.1 严格限制收集青少年个人信息的类型',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),


                Text('该模式运行仅会收集最小必要的青少年个人信息，包括',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),


                Text('a.设备信息、年龄信息、浏览记录等，确保多元、优质内容更好地触达青少年',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),


                Text('b.平台相关日志信息，包括点赞、评论等，用于保障推荐内容的质量并向青少年推荐可能感兴趣的用户及相关信息。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),


                Text('c.其他必要情形下，西瓜岛在收集青少年信息前会征得你的同意，我们不会收集未经你授权的信息。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('2.2 严格限定青少年人信息的使用目的',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),



                Text('a.开启该模式后，收集的信息将不会被用于任何商业目的（包括但不限于：广告、营销），不会基于任何商业目的而与第三方共享。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('b.收集的部分设备信息、网络信息可能会被用于安全与反作弊目的，但是我们不会将以这些目的收集的信息用于其他不相关的领域。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('2.3 严格的措施和制度保护未成年人个人信息安全',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('a.我们在境内运营过程中收集和产生的青少年个人信息存储于中华人民共和国境内，不会传输或存储至境外。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('b.存储所收集儿童的浏览日志信息为6个月，但是法律法规另有规定的除外。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('c.我们会使用高强度的加密技术、匿名化处理及相关合理可行的手段保护未成人的信息，并使用安全保护机制防止恶意攻击。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('d.我们会建立专门的安全部门、专门针对青少年信息的安全管理制度、数据安全流程保障青少年信息安全。我们采取严格的数据使用和访问制度，确保只有授权人员才可访问，并适时对数据和技术进行安全审计。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('3.退出青少年模式',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('如果你为你的被监护人解除或退出青少年模式，你的被监护人将可以使用西瓜岛的全部功能，收集、处理、共享的信息类型与使用目的也将遵循《西瓜岛隐私政策》以及其他相关法律法规。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),
                Text('如果你要求删除我们收集的不满14周岁的儿童个人信息，或进行投诉，请通过（2657304502@qq.com）联系我们，我们在核验你的身份后，会根据你的请求和法律法规的规定进行处理。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,)

              ],
            ),
          ),
        ),
      ),
    );
  }



  // ///获取基础配置
  // void _getBaseInfo() async {
  //   MTEasyLoading.showLoading('加载中');
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.getBasicSetting, successCallback: (data) async {
  //     MTEasyLoading.dismiss();
  //     //隐私政策
  //     String privacyAgreement = data['privacyAgreement'];
  //     initWebController(privacyAgreement);
  //   }, failedCallback: (data) {
  //     MTEasyLoading.dismiss();
  //   });
  // }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
