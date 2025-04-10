import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PayPaytypeDialog extends StatefulWidget {
  final String price;
  final String content;
  final Function Wepay;
  final Function Alipay;
  // 构造函数赋值
  PayPaytypeDialog({super.key,required this.price,this.content="",required this.Wepay,required this.Alipay,});

  @override
  _CustomAlertPageState createState() => _CustomAlertPageState();
}

class _CustomAlertPageState extends State<PayPaytypeDialog> {
  int selectRow = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Material(
        type:MaterialType.transparency,
        child:Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
                left: 0,right: 0,bottom: 0,
                height: 297.5,
                child: Container(
                    height: 297.5,
                    margin: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(47),topRight: Radius.circular(47))
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('选择支付方式',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                        SizedBox(height: 11,),
                        Container(
                          width: 37,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Color(0xff999999),
                              borderRadius: BorderRadius.all(Radius.circular(1.98))
                          ),
                        ),
                        SizedBox(height: 19,),

                        Container(
                            margin: EdgeInsets.only(left: 15,right: 15,),
                            height: 0.5,
                            color: Color(0xffEEEEEE )
                        ),

                        SizedBox(height: 18,),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              setState(() {
                                selectRow = 0;
                              });
                              // Navigator.pop(context);
                            },
                            child:Container(
                              width: screenSize.width,
                              margin: EdgeInsets.only(left: 0,right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 31,),
                                      Image(image: AssetImage('images/vipcenter/wechatpay.png'),width: 31.5,height: 26,),
                                      SizedBox(width: 9.5,),
                                      Text('微信支付',style: TextStyle(color: Color(0xff000000),fontSize: 16,fontWeight: FontWeight.bold),)
                                    ],
                                  ),


                                  selectRow==0?Container(
                                    width: 20,height: 20,
                                    margin: EdgeInsets.only(right: 30),
                                    child: Image(image: AssetImage('images/vipcenter/payselect.png'),width: 20,height: 20,),
                                  ):Container(
                                    width: 20,height: 20,
                                    margin: EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(width: 0.5,color: Color(0xffEEEEEE ))
                                    ),
                                  )

                                ],
                              ),
                            )
                        ),


                        SizedBox(height: 17,),

                        Container(
                          margin: EdgeInsets.only(left: 15,right: 15,),
                          height: 0.5,
                          color: Color(0xffEEEEEE )
                        ),

                        SizedBox(height: 17,),

                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(() {
                              selectRow = 1;
                            });
                            // Navigator.pop(context);
                          },
                          child: Container(
                            width: screenSize.width,
                            margin: EdgeInsets.only(left: 0,right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 31,),
                                    Image(image: AssetImage('images/vipcenter/alipay.png'),width: 31.5,height: 26,),
                                    SizedBox(width: 9.5,),
                                    Text('支付宝',style: TextStyle(color: Color(0xff000000),fontSize: 16,fontWeight: FontWeight.bold),)
                                  ],
                                ),

                                selectRow==1?Container(
                                  width: 20,height: 20,
                                  margin: EdgeInsets.only(right: 30),
                                  child: Image(image: AssetImage('images/vipcenter/payselect.png'),width: 20,height: 20,),
                                ):Container(
                                  width: 20,height: 20,
                                  margin: EdgeInsets.only(right: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(width: 0.5,color: Color(0xffEEEEEE ))
                                  ),
                                )
                              ],
                            ),
                          )
                        ),

                        SizedBox(height: 16,),
                        Container(
                            margin: EdgeInsets.only(left: 15,right: 15,),
                            height: 0.5,
                            color: Color(0xffEEEEEE )
                        ),

                        GestureDetector(
                          onTap: (){
                            selectRow==0?widget.Wepay():widget.Alipay();
                          },
                          child:Container(
                            alignment: Alignment.center,
                            width: screenSize.width-30,
                            decoration: BoxDecoration(
                              color: Color(0xffFE7A24),
                              borderRadius: BorderRadius.all(Radius.circular(27.5))
                            ),
                            child: Text('确认支付￥'+widget.price,style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16
                            ),),
                            margin: EdgeInsets.only(left: 15,right: 15,top: 30),
                            height: 55,
                          ),
                        )
                      ],
                    )
                ))
          ],
        )
    );
  }
}