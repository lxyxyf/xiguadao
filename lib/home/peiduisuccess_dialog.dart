import 'package:flutter/material.dart';

class PeiduisuccessDialog extends StatefulWidget {
  final String title;
  final String content;
  final Map peiduiDic;
  final Function OntapCommit;
  final Function OntapCancel;

  // 构造函数赋值
  const PeiduisuccessDialog({this.title="",this.content="",required this.OntapCommit,required this.OntapCancel,required this.peiduiDic});

  @override
  _ShowAlertDialogState createState() => _ShowAlertDialogState();
}

class _ShowAlertDialogState extends State<PeiduisuccessDialog> with TickerProviderStateMixin {

   late AnimationController controller;
   late AnimationController _controller;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync:this, // 让程序和手机的刷新频率统一
    );

    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync:this, // 让程序和手机的刷新频率统一
    );

    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        widget.OntapCancel();
      },
      child: Material(
          type:MaterialType.transparency,
          child:Container(
            alignment: Alignment.center,
            width: screenSize.width,
            height: screenSize.height,
            child: Container(
              // margin: EdgeInsets.only(left: 30,right: 30),
              width: 300,
              height: 300,
              // padding: EdgeInsets.only(bottom: 10,top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Stack(
                children: <Widget>[
                  // ElevatedButton(onPressed: (){
                  //   _controller.forward();
                  // }, child: const Text('移动')),
                  Positioned(
                    left: 50.0,
                    top: 20.0,
                    child: SlideTransition(
                      // 方块的宽度100，设置x轴y轴位移 0.5：也就是x轴向右移动50，同时向下移动50
                      position:
                      Tween(begin: Offset(-0.25, 0), end: Offset(0.25, 0))
                          .chain(CurveTween(curve: Curves.slowMiddle)) // 配置动画效果
                          .chain(CurveTween(curve: Interval(0, 1))) // 当前时间点30%开始（也就是第三秒开始移动）运动到60%结束（第6秒结束）
                          .animate(_controller),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        // color: Colors.red,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(image: NetworkImage(widget.peiduiDic['matchAvatar']),fit: BoxFit.cover)
                        ),
                      ),
                    ),

                  ),

                  Positioned(
                    right: 100.0,
                    top: 20.0,
                    child: SlideTransition(
                      // 方块的宽度100，设置x轴y轴位移 0.5：也就是x轴向右移动50，同时向下移动50
                      position:
                      Tween(begin: Offset(1, 0), end: Offset(0.25, 0))
                          .chain(CurveTween(curve: Curves.slowMiddle)) // 配置动画效果
                          .chain(CurveTween(curve: Interval(0, 1))) // 当前时间点30%开始（也就是第三秒开始移动）运动到60%结束（第6秒结束）
                          .animate(_controller),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        // color: Colors.red,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(image: NetworkImage(widget.peiduiDic['ownAvatar']),fit: BoxFit.cover)
                        ),
                      ),
                    ),

                  ),

                  Positioned(
                      top: 150,
                      width: 300,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('匹配成功',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                      )),

                  Positioned(
                      top: 180,
                      width: 300,
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.peiduiDic['matchNickName'].toString(),
                                  style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500)),
                              SizedBox(width: 10,),
                              Text(widget.peiduiDic['matchAge'].toString()+'岁',
                                  style: TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500)),
                            ],
                          )
                      )),


                  Container(
                      alignment: Alignment.center,
                      child:
                      GestureDetector(
                        onTap: (){

                          widget.OntapCommit();

                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 200),
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.only(left: 7,right: 7,top: 3,bottom: 3),
                            decoration: BoxDecoration(
                                color: Color(0xffFE7A24),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Text('开始聊天',
                              style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                        ),
                      )
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}