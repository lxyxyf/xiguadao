import 'package:flutter/material.dart';
class MyDialog extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  const MyDialog({super.key, this.title="",this.content="",required this.OntapCommit});

  @override
  Widget build(BuildContext context) {

    return Material(
        type:MaterialType.transparency,
        child:Center(
            child:Stack(
              alignment: Alignment.center,
              children: [
                Container(

                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))),
                    margin: const EdgeInsets.only(left: 46,right: 46,top: 70),
                    height:215.5,

                    child:Column(
                      children: <Widget>[
                        const SizedBox(height: 42,),
                        const Text('关系建立成功',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 19.5,right: 26),
                          child: const Text('你已接受对方的好友申请，己为你创建聊天会话，是否立即前去聊天?',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
                        ),
                        const SizedBox(height: 24.5,),
                        const Divider(thickness:0.5),
                        Row(


                          children: [
                            Expanded(child:  GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                                    color:  Colors.white,
                                  ),

                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(0),
                                  child: const Text('忽略',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),)
                              ),
                            )),
                            Container(
                                margin: const EdgeInsets.only(top: 4,bottom: 4.5),
                                color: const Color(0xffEEEEEE),
                              width: 1,
                              height: 30,

                            ),
                            Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                    OntapCommit();
                                  },
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                                        color:  Colors.white,
                                      ),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(0),
                                      child: const Text('去聊天',style: TextStyle(color: Color(0xffFE7A24),fontSize: 14,fontWeight: FontWeight.w500),)),
                                )
                            ),
                          ],
                        )
                      ],
                    )
                ),
                const Positioned(top: 0,
                    child:SizedBox(
                width: 215.5,height: 176.5,
                  child: Image(image: AssetImage('images/contact_icon.png'),width: 215.5,height: 176.5,),
                )),

              ],
            )
        )
    );
  }
}