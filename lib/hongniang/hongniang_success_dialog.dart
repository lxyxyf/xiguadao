import 'package:flutter/material.dart';
class HongniangSuccessDialog extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  const HongniangSuccessDialog({super.key, this.title="",this.content="",required this.OntapCommit});

  @override
  Widget build(BuildContext context) {

    return Material(
        type:MaterialType.transparency,
        child:Center(
            child:Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 38,right: 37.5),
                  height: 380.5,
                  // padding: EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/hongniang/goumaichenggong.png',),fit: BoxFit.fill),
                  ),
                  child:  Container(
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(image: AssetImage('images/share/share_guize_dialog.png',),fit: BoxFit.fitWidth),
                      //
                      // ),

                      alignment: Alignment.center,
                      // padding: EdgeInsets.only(bottom: 20),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          const SizedBox(height: 235,),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 18,right: 16.5),
                            child: const Text('购买成功',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 22.5,fontWeight: FontWeight.bold),),
                          ),
                          const SizedBox(height: 13.5,),

                          Container(
                            alignment: Alignment.center,

                            child: const Text('请等待平台为您分配专属红娘',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff999999),fontSize: 15,fontWeight: FontWeight.normal),),
                          ),

                          const SizedBox(height: 15,),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 218,height: 40.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.25)),
                                  color: Color(0xffFE7A24)
                                    ),
                                alignment: Alignment.center,

                                child:Text('知道了',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                            ),
                          ),






                          // const Divider(thickness:0.5),

                        ],
                      )
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 26,height: 26,
                      margin: EdgeInsets.only(top: 420),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          border: Border.all(color: Colors.white, width: 2)
                      ),
                      alignment: Alignment.center,

                      child:Text('X',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
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