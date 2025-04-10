import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

class VipcenterXieyi extends StatefulWidget {
  const VipcenterXieyi({super.key});

  @override
  State<StatefulWidget> createState() {
    return PrivacyPolicyPageState();
  }
}

class PrivacyPolicyPageState extends State<VipcenterXieyi> {
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
          '西瓜岛会员服务协议',
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
                Text('亲爱的西瓜岛用户：',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('欢迎您购买西瓜岛软件（以下简称“西瓜岛”）会员充值。通过西瓜岛会员充值功能，支付费用后，您就可以拥有并使用对应的西瓜岛会员专享功能。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('山东缘分计划网络信息有限公司（以下简称“我们”）在此特别提醒您，在开始购买会员充值之前，请您首先审慎阅读本《会员服务协议》（以下简称“本协议”），确保您充分理解本协议中各项条款，再选择是否同意并接受以下协议内容。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('如您是未成年人（未满18周岁），须在法定监护人陪同下阅读并决定是否接受本协议。除非您已阅读并接受本协议的全部条款，否则您无权使用会员充值。如您不同意本协议条款，您应主动取消购买西瓜岛会员充值。您接受本协议全部内容之后，即可购买西瓜岛会员充值。您的支付并使用西瓜岛会员充值等行为视为对本协议全部内容的接受并同意受本协议的约束。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('一.协议条款的接受与修改',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('1.1本协议是我们与您之间关于购买并使用我们提供的会员充值所订立的协议。西瓜岛会员充值是有偿的，除非您同意并接受本协议所有条款内容，并完成付费程序，否则您无权使用西瓜岛会员充值专享功能及本协议中所涉及的其他各项服务。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('1.2根据相关法律、法规的变化，我们将不断地完善服务质量并依此修改服务条款。新版服务协议公布后，您可在西瓜岛相关页面内查阅最新版服务协议。除非您在新协议生效前已经享有的事项，否则您的权利及义务、购买相关程序及收费标准均以最新的服务协议中各条款和购买页面展示为准。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('1.3请您审慎阅读并选择是否接受本协议，您在享受西瓜岛会员充值时必须完全、严格遵守本协议中的各项条款。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('二.会员充值及功能说明',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('本协议中的西瓜岛会员充值以服务购买页面显示及相关页面展示的服务内容为准。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('您在购买西瓜岛各项会员充值功能时，西瓜岛将在购买页面展示会员充值的相关内容和价格，该等页面展示内容是对应会员充值的单项服务条款，是本协议的一部分，会员充值的购买和使用行为视为对各单项服务条款的同意。西瓜岛可以根据实际情况调整会员充值的收费标准并会及时通知您，您已经购买的会员充值不受价格调整的影响，若您不同意调整后的收费标准，您可以选择在用完费用后不再续费使用。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('三.风险与责任',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),


                Text('3.1请您妥善保管您的西瓜岛账户、账户密码及个人信息。由于您自身保管或使用不当等非西瓜岛方原因造成的账户密码及信息泄露问题或后果，西瓜岛在接到您通知后在合理范围内保障您的权益。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('3.2您应当通过西瓜岛软件内西瓜岛充值。通过其他充值可能存在一定的商业风险（包括但不限于不法分子利用您的账户或银行卡等进行违法活动）。这些商业风险给您造成的一切经济损失，以及向侵权方追究侵权责任和追究责任不能等后果均由您个人自行承担。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),


                Text('3.3除非西瓜岛存在过错，西瓜岛不对您因为第三方的行为或者不作为造成的损失承担任何责任和赔偿，包括但不限于支付服务、网络接入服务等任何第三方的侵权行为。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('四.会员充值购买及延续',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('4.1在西瓜岛会员充值之前，须审阅并同意接受相关的服务条款。同时，您必须保证您所填写的个人信息真实、准确且有效，否则西瓜岛有权中止您的会员充值，直至您满足了国家法律法规的要求进行了更正。您填写的个人资料发生变化，应及时修改注册的个人资料，否则由此造成的会员充值权利不能全面有效行使的责任由您自己承担。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),

                Text('4.2您可以通过各种已有的和将来可能新增的渠道，包括各类西瓜岛支持使用的在线支付工具会员充值。西瓜岛用户完成用户注册程序，并通过西瓜岛平台提供的支付方式完成相应的服务付费后，即可使用西瓜岛会员充值。购买西瓜岛会员充值之后不能租用、借用、转让或许可给第三方使用，不得以营利、经营等非个人使用的目的为自己或他人开通西瓜岛会员充值。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('4.3基于不同的手机操作系统，价格可能因系统平台方原因有所差别，具体的每项会员充值费用标准以购买界面的实际标价为准，上述费用包含所有税费。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('五.会员充值的中断与终止',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('5.1对于因无法预见或不可抗拒的事由，包括但不限于政府行为、自然灾害、黑客攻击，以及基于互联网特性可能发生的服务器死机、网络或数据库故障、软件升级、服务器维修、调整及升级等问题等造成的服务中断，西瓜岛会尽量以最快的速度通知您，并尽快采取措施进行恢复。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('5.2您如果违反或被西瓜岛视为违反本协议或用户协议的相关条款，或从事以下行为，包括但不限于：',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('（1）发布、传送、传播、储存违反国家法律、危害国家安全统一、社会稳定、公序良俗、社会公德以及侮辱、诽谤、淫秽、暴力的内容；',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),
                SizedBox(height: 20,),
                Text('（2）发布、传送、传播、储存侵害他人名誉权、肖像权、知识产权、商业秘密等合法权利的内容；',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('（3）虚构事实、隐瞒真相以误导、欺骗他人；',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),
                SizedBox(height: 20,),
                Text('（4）发表、传送、传播广告信息、诈骗信息、诱导消费信息及垃圾信息；',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),
                SizedBox(height: 20,),
                Text('（5）使用虚假账号或注册小号；',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('（6）从事其他违反法律法规、政策及公序良俗、社会公德等的行为。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('西瓜岛有权在发现该等情形后，随时停止向您提供所有功能服务，甚至限制或永久封禁您的账号。若因您出现上述问题，您已购买西瓜岛会员充值，西瓜岛不退还您任何已支付的费用，也不承担您因此造成的其他任何损失。因该等行为造成西瓜岛损失，且已支付的费用不足以弥补西瓜岛损失的，西瓜岛有权向您继续追偿。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('六.您的权利和义务',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('6.1您享有西瓜岛会员充值的各项权利，同时须遵守西瓜岛用户协议以及与会员充值相关的各项条款，包括但不限于本协议。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('6.2您有权对我们的会员充值提出宝贵的意见和建议。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('6.3如您在会员充值有效期内停止使用西瓜岛，我们将为您保留非包月类会员充值。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('6.4您自行承担在西瓜岛中传送、发布信息及使用西瓜岛免费服务或会员充值的法律责任，您使用西瓜岛服务，包括免费服务与收费服务的行为，均应遵守各项法律法规、规章、规范性文件。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('七.西瓜岛的权利与义务',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('7.1西瓜岛将根据本协议为您提供您已经购买的各项会员充值，如发生服务故障或错误，西瓜岛将尽快进行检查和维护，采取必要手段恢复会员充值的正常提供。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('7.2西瓜岛享有对您使用会员充值过程中一切活动的监督、提示和检查等权利，如您的行为违反有关法律法规或违反西瓜岛的相关条款，西瓜岛有权要求您改正并追究您的责任。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('7.3对于您在使用西瓜岛服务（包括免费和付费服务）的过程中存在的一切违反法律法规及本协议的行为，西瓜岛有权根据法律法规追究您的责任。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('7.4对于您因其个人的不良使用等原因造成的被西瓜岛官方限制或封禁账号的情况，西瓜岛不予以任何退款和赔偿，您自行承担由此导致的一切后果。务',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('八.其他',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('8.1本协议的生效、履行、解释及争议的解决均适用中华人民共和国法律，若本协议因与中华人民共和国现行法律相抵触而导致部分无效，不影响其他部分的效力。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 20,),
                Text('8.2如您和西瓜岛之间发生任何纠纷或争议，应先尽量友好协商解决；协商不成时，您同意将纠纷或争议提交本协议签订地有管辖权的人民法院进行诉讼。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),


                SizedBox(height: 20,),
                Text('8.3西瓜岛未行使或延迟行使在本协议项下的权利并不构成对这些权利的放弃，而单一或部分行使其在本协议项下的任何权利并不排斥其任何其它权利的行使。',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                Text('该协议自发布日期：2025年2月19日起开始生效',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize:14,
                      fontWeight: FontWeight.w500
                  ),),

                SizedBox(height: 40,),
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
