import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class MyDialogContact extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  final Function OntapCommit;
  final Function OntapUserDetail;
  String areaName = '';
  MyDialogContact({super.key,required this.areaName, required this.userInfoDic,required this.OntapCommit,required this.OntapUserDetail});
  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MyDialogContact> {
  String myUserid = '';
  String toUserid = '10167';
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  final TIMUIKitConversation selectedConversation = TIMUIKitConversation();
  @override
  void initState() {
    // _coreInstance.login(userID: 'user1li',
    //     userSig: 'eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwqXFqUWGOZlQqeKU7MSCgswUJStDMwMDA1MLMwtTiExqRUFmUSpQ3NTU1AgoBREtycwFiZkbG5iYGFuaWkBNyUwHmpzrkuda6eGeV5iXF*YYFJKTl*NiHllSHqNfWOFRWG5W5J0SVWmemx1gkZyWb6tUCwD30TPX');
    initChatInfo();
    super.initState();
  }


  initChatInfo()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    setState(() {
      myUserid = share.getString('UserId') ?? '';
    });

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xfffafafa),
          body: Stack(
            children: [
              Positioned(
                  child: Image(
                    image: AssetImage('images/user_card_allpage.png'),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  )
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+33),
                      child: Image(
                        image: AssetImage('images/user_card_hey.png'),
                        width: 116.5,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width-20.5-20.5,
                      alignment: Alignment.topCenter,

                      margin: EdgeInsets.only(top:10,left: 20.5,right: 20.5),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(child: Image(image: AssetImage('images/user_card_whitebackground.png'),height: 424.5,)),
                          Container(
                            width: 113.5,
                            height: 113.5,
                            margin: EdgeInsets.only(top: 23.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(56.75),
                                border: Border.all(
                                  color: Colors.white, // 边框颜色
                                  width: 2.5, // 边框宽度
                                ),
                              ),
                              child: ClipOval(
                                child: Image(image: NetworkImage(widget.userInfoDic['avatar']),fit: BoxFit.fitWidth)),
                          ),

                         Positioned(
                           right: 33,
                             top:24,
                             child:GestureDetector(
                               onTap: (){
                                 widget.OntapUserDetail();
                               },
                               child: Container(
                                 padding: EdgeInsets.all(7),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(15.5),
                                     color: Color.fromRGBO(51, 51, 51, 0.41)
                                 ),
                                 child:Text('进入主页',
                                   style: TextStyle(color:Colors.white ,fontSize: 13,fontWeight: FontWeight.w500),
                                   textAlign: TextAlign.center,),
                               ),
                             )
                         ),

                          Container(

                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 153),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.userInfoDic['nickname'].toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                                ),

                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                    decoration: const BoxDecoration(
                                      color: Color(0xff35C234),
                                      borderRadius: BorderRadius.all(Radius.circular(2.5)),
                                    ),
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 5,),
                                        const Image(image: AssetImage('images/shiming_icon.png'),width: 10,height: 11,),
                                        const SizedBox(width: 3,),
                                        Text(widget.userInfoDic['haveNameAuth']==1?'已实名'
                                            :'未实名',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: widget.userInfoDic['haveNameAuth']==1?Colors.white:const Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),)
                                      ],
                                    )
                                ),

                              ],
                            ),
                          ),

                          //地址/年龄//婚姻
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 190),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 52.5,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF97CA2),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text(widget.areaName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.white),),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  width: 52.5,
                                  height: 22,
                                  margin: EdgeInsets.only(left: 19.5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffFE7A24),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text(widget.userInfoDic['age'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.white),),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  width: 52.5,
                                  height: 22,
                                  margin: EdgeInsets.only(left: 19.5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff4CD4DE),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text(widget.userInfoDic['marriageName'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.white),),
                                ),
                              ],
                            ),
                          ),


                          //身高体重/婚姻/学历
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 230,left: 30),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text('${widget.userInfoDic['height']}cm/${widget.userInfoDic['weight']}kg',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  margin: EdgeInsets.only(left: 19.5),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text(widget.userInfoDic['marriageName'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  margin: EdgeInsets.only(left: 19.5),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text('${widget.userInfoDic['educationName']}学历',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),
                              ],
                            ),
                          ),


                          //收入/地址
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 290,left: 30),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text('${widget.userInfoDic['monthIncomeName']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),


                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  margin: EdgeInsets.only(left: 19.5),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text(widget.userInfoDic['areaName'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),
                              ],
                            ),
                          ),


                          //身高体重/婚姻/学历
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 350,left: 30),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(11),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 0.34),
                                    borderRadius: BorderRadius.all(Radius.circular(11)),
                                  ),
                                  child: Text('从事${widget.userInfoDic['career']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Color(0xff333333)),),
                                ),


                              ],
                            ),
                          ),


                        ],
                      ),
                      // decoration: BoxDecoration(
                      //     image: DecorationImage(image: AssetImage('images/user_card_whitebackground.png'),fit: BoxFit.fitWidth)
                      // ),
                    )
                  ],
                ),
              ),
              Positioned(
                  left: 55,
                  top: 580,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child:  Container(
                        width: 85.5,height: 85.5,
                        child: Image(image: AssetImage('images/user_card_fail.png'),width: 85.5,height: 85.5,)
                    ),
                  )
              ),

              Positioned(
                  right: 55,
                  top: 580,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      widget.OntapCommit();
                    },
                    child:  Container(
                        width: 85.5,height: 85.5,
                        child: Image(image: AssetImage('images/user_card_love.png'),width: 85.5,height: 85.5,)
                    ),
                  )
              ),
            ],
          )
        ));
  }


}
