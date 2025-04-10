import 'package:flutter/material.dart';
class ShareGuizeDialog extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  const ShareGuizeDialog({super.key, this.title="",required this.content,required this.OntapCommit});

  @override
  Widget build(BuildContext context) {

    return Material(
        type:MaterialType.transparency,
        child:Center(
            child:Stack(
              alignment: Alignment.center,
              children: [
               Container(
                 margin: const EdgeInsets.only(left: 0,right: 0),
                 height: 467,
                 decoration: const BoxDecoration(
                     image: DecorationImage(image: AssetImage('images/share/share_guize_starbackground.png',),fit: BoxFit.fitWidth),
                     ),
                 child:  Container(
                     decoration: const BoxDecoration(
                         image: DecorationImage(image: AssetImage('images/share/share_guize_dialog.png',),fit: BoxFit.fitWidth),

                       ),
                     margin: const EdgeInsets.only(left: 46,right: 46,top: 0),
                     height:319.5,
                     // padding: EdgeInsets.only(bottom: 20),
                     child:Column(
                       children: <Widget>[
                         const SizedBox(height: 140,),
                         const Text('规则',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                         const SizedBox(height: 14.5,),
                         Container(
                           alignment: Alignment.topLeft,
                           margin: const EdgeInsets.only(left: 18,right: 16.5),
                           child: const Text('1.点击“获取积分”按钮;',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                         ),
                         const SizedBox(height: 7,),
                         Container(
                           alignment: Alignment.topLeft,
                           margin: const EdgeInsets.only(left: 18,right: 16.5),
                           child: const Text('2.分享链接给微信好友;',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                         ),
                         const SizedBox(height: 7,),
                         Container(
                           alignment: Alignment.topLeft,
                           margin: const EdgeInsets.only(left: 18,right: 16.5),
                           child: const Text('3.好友点击链接后下载"西瓜岛"APP;',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                         ),
                         const SizedBox(height: 7,),
                         Container(
                           alignment: Alignment.topLeft,
                           margin: const EdgeInsets.only(left: 18,right: 16.5),
                           child:  Text('4.打开APP注册账号后，邀请人即可获得'+content+'积分;',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                         ),
                         const SizedBox(height: 7,),

                         Container(
                           alignment: Alignment.topLeft,
                           margin: const EdgeInsets.only(left: 18,right: 16.5),
                           child: const Text('5.积分可兑换一定数量的道具。',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                         ),

                         const SizedBox(height: 15,),

                         GestureDetector(
                           onTap: (){
                             Navigator.pop(context);
                           },
                           child: Container(
                               width: 140.5,height: 42.5,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular(18.25)),
                                   gradient: LinearGradient(
                                       begin: Alignment.centerLeft,//渐变开始于上面的中间开始
                                       end: Alignment.centerRight,//渐变结束于下面的中间
                                       colors: [Color(0xFFFE7A24), Color(0xFFFFC002)]//开始颜色和结束颜色]
                                   )),
                               alignment: Alignment.center,

                               child:Text('知道了',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                           ),
                         )


                         // const Divider(thickness:0.5),

                       ],
                     )
                 ),
               )
                // const Positioned(top: 40,
                //     child:SizedBox(
                //       width: 59,height: 58.5,
                //       child: Image(image: AssetImage('images/home/tishi.png'),width: 59,height: 58.5,),
                //     )),

              ],
            )
        )
    );
  }
}