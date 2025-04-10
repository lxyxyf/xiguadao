import 'package:flutter/material.dart';
class MineRightsInterestsDialog extends Dialog{

  final List quanyiDic;
  final Function OntapCommit;
  // 构造函数赋值
  const MineRightsInterestsDialog({super.key,required this.quanyiDic,required this.OntapCommit});

  Widget _buildItem(BuildContext context, int index) {
    return Row(
              children: [
                SizedBox(width: 15,),
                Image(image: AssetImage(quanyiDic[index]['privilegeName']=='超级喜欢'?
                'images/vipcenter/vipcenter_chaojixihuan.png'
                  :quanyiDic[index]['privilegeName']=='名片浏览'?
                'images/vipcenter/vipcenter_mingpian.png'
                    :quanyiDic[index]['privilegeName']=='发布活动'?
                'images/vipcenter/vipcenter_fabuhuodong.png'
                    :quanyiDic[index]['privilegeName']=='多倍曝光'?
                'images/vipcenter/vipcenter_puguang.png'
                    :quanyiDic[index]['privilegeName']=='谁想认识我'?
                'images/vipcenter/vipcenter_xiangrenshiwo.png'
                    :quanyiDic[index]['privilegeName']=='谁看过我'?
                'images/vipcenter/vipcenter_kanguowo.png'
                    :quanyiDic[index]['privilegeName']=='专属客服'?
                'images/vipcenter/vipcenter_zhuanshufuwu.png'
                    :'images/vipcenter/vipcenter_zunguibiaoshi.png'),width: 42,height: 42,),
                SizedBox(width: 9,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quanyiDic[index]['privilegeName'],style: TextStyle(color: Color(0xff6F4A49),fontWeight: FontWeight.bold,fontSize: 14),),
                    quanyiDic[index]['privilegeName']=='超级喜欢'?Text('今天剩余'+quanyiDic[index]['remainingNum'].toString()+'次免费超级喜欢次数；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                    : quanyiDic[index]['privilegeName']=='名片浏览'?Text('本'+quanyiDic[index]['timeUnit']+'剩余'+quanyiDic[index]['remainingNum'].toString()+'次可刷新用户名片次数；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                    :quanyiDic[index]['privilegeName']=='发布活动'?Text('本'+quanyiDic[index]['timeUnit']+'剩余发布活动'+quanyiDic[index]['remainingNum'].toString()+'次；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :quanyiDic[index]['privilegeName']=='多倍曝光'?Text('名片优先推荐，被更多人看到；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :quanyiDic[index]['privilegeName']=='谁想认识我'?Text('任意查看想认识你的人；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :quanyiDic[index]['privilegeName']=='谁看过我'?Text('任意查看看过你的人；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :quanyiDic[index]['privilegeName']=='专属客服'?Text('1v1专属客服服务；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                        :Text('尊贵标识展示，在人群中脱颖而出；',
                      style: TextStyle(color: Color(0xff999999),fontSize: 12),)
                    ,

                  ],
                )
              ],
            )
    ;
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        type:MaterialType.transparency,
        child:Container(
          height: 65*quanyiDic.length+50,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(47),topRight: Radius.circular(47))),
                  // margin: const EdgeInsets.only(left: 46,right: 46,top: 70),
                  // padding: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  // height:613,

                  child:

                  Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text('我的权益',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                      SizedBox(height: 15,),
                      Container(
                        width: 37,
                        height: 4,

                        decoration: BoxDecoration(
                            color: Color(0xff999999),
                            borderRadius: BorderRadius.all(Radius.circular(1.98))
                        ),
                      ),

                      SizedBox(height: 7.5,),
                      //超级喜欢
                      Expanded(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildItem(context, index);
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 15,
                                  );
                                },
                                itemCount: quanyiDic.length),
                          )),
                      SizedBox(height: 12,),
                    ],
                  )
              ),


            ],
          ),
        )
    );
  }
}