import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
class ActivityChoosePersonnumlog extends Dialog{

  final String title;
  final String content;
  final Function OntapCommit;
  // 构造函数赋值
  ActivityChoosePersonnumlog({super.key, this.title="",this.content="",required this.OntapCommit});

  TextEditingController manController = TextEditingController();
  TextEditingController womanController = TextEditingController();
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

                    height:160.5,

                    child:Column(
                      children: <Widget>[
                        const SizedBox(height: 14,),
                        const Text('请输入活动人数',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 20,),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 19.5,right: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //男
                              Row(
                                children: [
                                  Image.asset('images/activity_man.png',width: 12.5,height: 12.5,),
                                  const SizedBox(width: 4.5,),
                                  const Text('男',textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
                                  const SizedBox(width: 4.5,),
                                  Container(
                                   decoration: const BoxDecoration(
                                     color: Color(0xffFAFAFA),
                                       borderRadius: BorderRadius.all(Radius.circular(4.5)),
                                   ),
                                   width: 59.95,
                                   height: 23,
                                   child:
                                   TextField(
                                     controller: manController,
                                     textAlignVertical: TextAlignVertical.center,
                                     textAlign: TextAlign.left,
                                     decoration: InputDecoration(
                                         border: InputBorder.none,
                                         isCollapsed: true,
                                         hintStyle: TextStyle(
                                             color: const Color(0xff999999).withOpacity(1),
                                             fontSize: 14,

                                             fontWeight: FontWeight.w500)),
                                   ),
                                 )
                                ],
                              ),
                              //女
                              Row(
                                children: [
                                  Image.asset('images/activity_woman.png',width: 12.5,height: 12.5,),
                                  const SizedBox(width: 4.5,),
                                  const Text('女',textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
                                  const SizedBox(width: 4.5,),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.all(Radius.circular(4.5)),
                                    ),
                                    width: 59.95,
                                    height: 23,
                                    child:
                                    TextField(
                                      controller: womanController,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          hintStyle: TextStyle(
                                              color: const Color(0xff999999).withOpacity(1),
                                              fontSize: 14,

                                              fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ),
                        const SizedBox(height: 16,),
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
                                  child: const Text('取消',textAlign: TextAlign.center,style: TextStyle(color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),)
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
                                    if (manController.text.isEmpty == true){
                                      BotToast.showText(text: '请输入男生人数');
                                      return;
                                    }
                                    if (womanController.text.isEmpty == true){
                                      BotToast.showText(text: '请输入女生人数');
                                      return;
                                    }
                                    Navigator.pop(context);
                                    OntapCommit(manController.text,womanController.text);
                                  },
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                                        color:  Colors.white,
                                      ),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(0),
                                      child: const Text('确定',style: TextStyle(color: Color(0xffFE7A24),fontSize: 14,fontWeight: FontWeight.w500),)),
                                )
                            ),
                          ],
                        )
                      ],
                    )
                ),


              ],
            )
        )
    );
  }
}