import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/comment_detail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/post/banner_point.dart';
import 'package:xinxiangqin/post/custom_alert_page.dart';
import 'package:xinxiangqin/post/post_report_page.dart';
import 'package:xinxiangqin/post/user_report_page.dart';
import 'package:xinxiangqin/utils/utils.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import '../user/new_userinfo_page.dart';


class HomeShaixuanPage extends StatefulWidget {
  HomeShaixuanPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return PostDetailPageState();
  }
}

class PostDetailPageState extends State<HomeShaixuanPage> {
  double _lowerValue = 0;
  double _upperValue = 65;

  double _lowerValueHeight = 0;
  double _upperValueHeight = 230;

  double _lowerValueWeight = 0;
  double _upperValueWeight = 150;

  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setupData();
  }

  setupData()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String? agestr = share.getString('age');
    String? heightstr = share.getString('height');
    String? weightstr = share.getString('weight');
    if(agestr==''||agestr == 'null'||agestr==null||heightstr==''||heightstr == 'null'||heightstr==null||weightstr==''||weightstr == 'null'||weightstr==null){
      await share.setString('age', '${_lowerValue},${_upperValue}');
      await share.setString('height', '${_lowerValueHeight},${_upperValueHeight}');
      await share.setString('weight', '${_lowerValueWeight},${_upperValueWeight}');
    }else{
      setState(() {
        _lowerValue = double.parse(agestr.split(',')[0].toString());
        _upperValue = double.parse(agestr.split(',')[1].toString());

        _lowerValueHeight = double.parse(heightstr.split(',')[0].toString());
        _upperValueHeight = double.parse(heightstr.split(',')[1].toString());

        _lowerValueWeight = double.parse(weightstr.split(',')[0].toString());
        _upperValueWeight = double.parse(weightstr.split(',')[1].toString());
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: MediaQuery.of(context).padding.top + 24,
              padding:  EdgeInsets.only(left: 15, bottom: 13,top: MediaQuery.of(context).padding.top ),
              alignment: Alignment.bottomLeft,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(

                      child: Text(
                        '匹配搜索',
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //年龄
            Container(
              margin: EdgeInsets.only(left: 25,top: 24),
              child: Text('年龄',
                style: TextStyle(color: Color(0xff333333),
                    fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Container(
              margin: EdgeInsets.only(top: 0, left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: RangeSliderFlutter(
                handler: RangeSliderFlutterHandler(
                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child:Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                rightHandler: RangeSliderFlutterHandler(

                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                // key: Key('3343'),
                values: [_lowerValue, _upperValue],
                rangeSlider: true,
                tooltip: RangeSliderFlutterTooltip(

                  custom: (value) {
                    print(value.toString());
                    return Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(value.toInt().toString()+'岁',
                        style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 14,fontWeight: FontWeight.w500),),
                    );
                  },
                  alwaysShowTooltip: true,
                  // rightSuffix: Text(" 岁"),
                  // leftSuffix: Text(" 岁"),
                ),
                max: 65,
                textPositionTop: -50,
                handlerHeight: 48,

                // textBackgroundColor: Colors.red,

                trackBar: RangeSliderFlutterTrackBar(
                  activeTrackBarHeight: 9,
                  inactiveTrackBarHeight: 9,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFE7A24 ),
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFAFAFA),
                  ),
                ),
                // handler: RangeSliderFlutterHandler(
                //   decoration: BoxDecoration(
                //     color: Colors.yellow,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                min: 0,
                fontSize: 15,

                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValue = lowerValue;
                  _upperValue = upperValue;
                  setState(() {});
                },
                onDragCompleted: (handlerIndex, lowerValue, upperValue)async{
                  SharedPreferences share = await SharedPreferences.getInstance();
                  await share.setString('age', '${_lowerValue.toInt()},${_upperValue.toInt()}');
                },
              ),
            ),


            //身高
            Container(
              margin: EdgeInsets.only(left: 25,top: 0),
              child: Text('身高',
                style: TextStyle(color: Color(0xff333333),
                    fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Container(
              margin: EdgeInsets.only(top: 0, left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: RangeSliderFlutter(
                handler: RangeSliderFlutterHandler(
                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child:Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                rightHandler: RangeSliderFlutterHandler(

                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                // key: Key('3343'),
                values: [_lowerValueHeight, _upperValueHeight],
                rangeSlider: true,
                tooltip: RangeSliderFlutterTooltip(

                  custom: (value) {
                    print(value.toString());
                    return Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(value.toInt().toString()+'cm',
                        style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 14,fontWeight: FontWeight.w500),),
                    );
                  },
                  alwaysShowTooltip: true,
                  // rightSuffix: Text(" 岁"),
                  // leftSuffix: Text(" 岁"),
                ),
                max: 230,
                textPositionTop: -50,
                handlerHeight: 48,

                // textBackgroundColor: Colors.red,

                trackBar: RangeSliderFlutterTrackBar(
                  activeTrackBarHeight: 9,
                  inactiveTrackBarHeight: 9,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFE7A24 ),
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFAFAFA),
                  ),
                ),
                // handler: RangeSliderFlutterHandler(
                //   decoration: BoxDecoration(
                //     color: Colors.yellow,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                min: 0,
                fontSize: 15,

                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValueHeight = lowerValue;
                  _upperValueHeight = upperValue;
                  setState(() {});
                },
                onDragCompleted: (handlerIndex, lowerValue, upperValue)async{
                  SharedPreferences share = await SharedPreferences.getInstance();
                  await share.setString('height', '${_lowerValueHeight.toInt()},${_upperValueHeight.toInt()}');
                },
              ),
            ),


            //体重
            Container(
              margin: EdgeInsets.only(left: 25,top: 0),
              child: Text('体重',
                style: TextStyle(color: Color(0xff333333),
                    fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Container(
              margin: EdgeInsets.only(top: 0, left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: RangeSliderFlutter(
                handler: RangeSliderFlutterHandler(
                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child:Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                rightHandler: RangeSliderFlutterHandler(

                  decoration: BoxDecoration(),
                  foregroundDecoration: BoxDecoration(),
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Image(image: AssetImage('images/home/shaixuanicon.png'),width: 28,height: 28,),
                  ),
                ),
                // key: Key('3343'),
                values: [_lowerValueWeight, _upperValueWeight],
                rangeSlider: true,
                tooltip: RangeSliderFlutterTooltip(

                  custom: (value) {
                    print(value.toString());
                    return Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(value.toInt().toString()+'kg',
                        style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 14,fontWeight: FontWeight.w500),),
                    );
                  },
                  alwaysShowTooltip: true,
                  // rightSuffix: Text(" 岁"),
                  // leftSuffix: Text(" 岁"),
                ),
                max: 150,
                textPositionTop: -50,
                handlerHeight: 48,

                // textBackgroundColor: Colors.red,

                trackBar: RangeSliderFlutterTrackBar(
                  activeTrackBarHeight: 9,
                  inactiveTrackBarHeight: 9,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFE7A24 ),
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffFAFAFA),
                  ),
                ),
                // handler: RangeSliderFlutterHandler(
                //   decoration: BoxDecoration(
                //     color: Colors.yellow,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                min: 0,
                fontSize: 15,

                onDragging: (handlerIndex, lowerValue, upperValue) {
                  _lowerValueWeight = lowerValue;
                  _upperValueWeight = upperValue;
                  setState(() {});
                },
                onDragCompleted: (handlerIndex, lowerValue, upperValue)async{
                  SharedPreferences share = await SharedPreferences.getInstance();
                  await share.setString('weight', '${_lowerValueWeight.toInt()},${_upperValueWeight.toInt()}');
                },
              ),
            ),

          ],
        ),
      ),
    );
  }




  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
