import 'package:flutter/material.dart';
class Noopenvipdialog extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  const Noopenvipdialog({super.key, this.title="",required this.content,required this.OntapCommit});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Material(
        type:MaterialType.transparency,
        child:Container(
          width: screenSize.width,
          height: screenSize.height,
          alignment: Alignment.center,
            child:Container(
                margin:  EdgeInsets.only(left: 63,right: 62.5,top: 0 ),
              height: 310.5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin:  EdgeInsets.only(top: 0 ),
                    height: 200.5,
                    decoration:  BoxDecoration(
                      image: DecorationImage(image: AssetImage('images/vipcenter/noopenviewcard.png',),fit: BoxFit.fill),
                    ),
                    child:  Container(
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(image: AssetImage('images/vipcenter/noopenvieicon.png',),fit: BoxFit.fitWidth),
                      //
                      // ),
                      // height:319.5,
                      // padding: EdgeInsets.only(bottom: 20),
                        child:Column(
                          children: <Widget>[
                            SizedBox(height: 60,),
                            Text('您还没有开通会员',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff000000),fontSize: 19,fontWeight: FontWeight.w700),),
                            SizedBox(height: 14.5,),
                            Container(
                              alignment: Alignment.topCenter,
                              child:  Text('没有开通会员无法使用当前功能',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500),),
                            ),


                            SizedBox(height: 15,),

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                OntapCommit();


                              },
                              child: Container(
                                  height: 42.5,
                                  margin: EdgeInsets.only(left: 23.5,right: 23),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(21.25)),
                                      color: Color(0xffFE7A24)
                                  ),
                                  alignment: Alignment.center,

                                  child:Text('开通会员',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                              ),
                            )


                            // const Divider(thickness:0.5),

                          ],
                        )
                    ),
                  ),
                  Positioned(top: 0,
                      child:SizedBox(
                        width: 147,height: 147,
                        child: Image(image: AssetImage('images/vipcenter/noopenvieicon.png'),width: 147,height: 147,),
                      )),

                  Positioned(top: 270,
                      // left: 0,right: 0,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:   Image(image: AssetImage('images/vipcenter/close.png'),width: 26,height: 26,),
                      )

                  )



                ],
              )
            )
        )
    );
  }
}