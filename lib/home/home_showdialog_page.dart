import 'package:flutter/material.dart';
class HomeShowdialogPage extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  const HomeShowdialogPage({super.key, this.title="",this.content="",required this.OntapCommit});

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
                      image: DecorationImage(image: AssetImage('images/home/dialogbackground.png',),fit: BoxFit.fill),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))),
                    margin: const EdgeInsets.only(left: 46,right: 46,top: 70),
                    height:310.5,
                    // padding: EdgeInsets.only(bottom: 20),
                    child:Column(
                      children: <Widget>[
                        const SizedBox(height: 42,),
                        const Text('温馨提示',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 19.5,right: 26),
                          child: const Text('亲爱的用户，我们发现您的个人资料中存在下列不合适的信息内容，需修改后才会继续展示对其他用户展示您的名片信息，谢谢您的理解~',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                        ),
                        const SizedBox(height: 24.5,),

                        Container(
                          margin: EdgeInsets.only(left: 17.5,right: 17.5,bottom: 10),
                          height: 58.5,
                          padding: EdgeInsets.only(left: 13),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(254, 122, 36, 0.05),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Row(
                            children: [
                              Text(content,textAlign: TextAlign.left,style: TextStyle(color: Color(0xffFE7A24),fontSize: 15,fontWeight: FontWeight.bold),),
                              Text('需进行修改',textAlign: TextAlign.left,style: TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),

                            ],
                          ),
                        ),

                        // const Divider(thickness:0.5),
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
                                      child: const Text('去修改',style: TextStyle(color: Color(0xffFE7A24),fontSize: 14,fontWeight: FontWeight.w500),)),
                                )
                            ),
                          ],
                        )
                      ],
                    )
                ),
                const Positioned(top: 40,
                    child:SizedBox(
                      width: 59,height: 58.5,
                      child: Image(image: AssetImage('images/home/tishi.png'),width: 59,height: 58.5,),
                    )),

              ],
            )
        )
    );
  }
}