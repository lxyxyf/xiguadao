import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';
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


class PostDetailPage extends StatefulWidget {
  String id;
  PostDetailPage({super.key, required this.id});
  @override
  State<StatefulWidget> createState() {
    return PostDetailPageState();
  }
}

class PostDetailPageState extends State<PostDetailPage> {
  double _height = 153;
  double dy = 0;
  bool isAnimated = false;
  String userId = '';
  String applyName = '输入你想说的话吧';
  String superiorCommentId = '';
  String superiorCommentUserName = '';
  String superiorCommentUserId = '';
  Map<String, dynamic>? applyDic;//回复的data
  Map<String, dynamic>? dataDic;
  Map<String, dynamic>? dataDicList;
  List dataSource = [];
  // 创建一个FocusNode对象
  final FocusNode _focusNode = FocusNode();


  int _pageNo = 1;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {

    super.initState();
    getuserId();
    _scrollController.addListener(_scrollListener);
  }

  getuserId()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    setState(() {
      userId = share.getString('UserId') ?? '';
      log('我的userid是'+userId);
      getDetailData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffafafa),
      body: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top + 24,
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext ccontext) {
                              return NewUserinfoPage(userId: dataDic!['userId'].toString(),);
                            }));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                image: dataDic != null
                                    ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(dataDic!['avatar']))
                                    : null,
                                borderRadius: const BorderRadius.all(Radius.circular(10))),
                          ),
                          const SizedBox(
                            width: 5.5,
                          ),
                          Text(
                            dataDic != null ? dataDic!['nickname'] : '',
                            style: const TextStyle(
                                color: Color(0xff333333),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        userId.toString()!=''&&dataDic!=null&&userId.toString()!=dataDic!['userId'].toString()?GestureDetector(
                          onTap: () {
                            //弹出底部弹框
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(246, 246, 246, 1.0),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 260,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
//举报
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) {
                                                        return const PostReportPage();
                                                      },
                                                      fullscreenDialog: true));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: const Text(
                                                "举报内容",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1.0),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.pop(context);
//举报此用户
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) {
                                                        return UseReportPage(
                                                          userName: dataDic![
                                                              'nickname'],
                                                        );
                                                      },
                                                      fullscreenDialog: true));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: const Text(
                                                "举报此用户",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1.0),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
//加入黑名单
                                              Navigator.pop(context);
//加入黑名单
                                              showDialog(
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomAlertPage(
                                                        (value) {
                                                      BotToast.showText(
                                                          text: '拉黑成功');
                                                      Navigator.pop(context);
                                                    },
                                                        "提示",
                                                        "${"是否将用户:" +
                                                            dataDic![
                                                                'nickname']}加入黑名单?如果点击确定,您将无法再看到此用户相关动态,请谨慎操作.");
                                                  },
                                                  context: context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: const Text(
                                                "加入黑名单",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1.0),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
//屏蔽citie
                                              Navigator.pop(context);

                                              showDialog(
                                                  builder:
                                                      (BuildContext context) {
                                                    return CustomAlertPage(
                                                        (value) {
                                                      BotToast.showText(
                                                          text: '屏蔽成功');
                                                      Navigator.pop(context);
                                                    }, "提示",
                                                        "是否屏蔽此条帖子,如果点击确定,则下次无法再次看到此贴,且无法撤销,请谨慎操作.");
                                                  },
                                                  context: context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: const Text(
                                                "屏蔽此贴",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1.0),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "取消",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        51, 51, 51, 1.0),
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                            //进入举报页面
                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (BuildContext ccontext) {
                            //   return PostReportPage();
                            // }));
                          },
                          child: const Text(
                            '举报',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ):GestureDetector(
                          onTap: (){
                            //删除
                            deleteMoment();
                          },
                          child: const Text(
                            '删除',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                child: Stack(
                  children: [
                    Container(),

                    // || !dataDic!['imgUrl'].toString().contains(',')
                    dataDic == null
                        ? Container()
                        : (dataDic!['imgUrl'] == null)
                            ? Positioned(
                                top: 0,
                                bottom: 153 - 15,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: dataDic != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  dataDic!['avatar']))
                                          : null),
                                  height: 472 /
                                      705.0 *
                                      (MediaQuery.of(context).size.height),
                                  width: MediaQuery.of(context).size.width,
                                ))
                            : (dataDic!['imgUrl'].toString().contains(',')
                                ? Positioned(
                                    top: 0,
                                    bottom: 153 - 15,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 472 /
                                          705.0 *
                                          (MediaQuery.of(context).size.height),
                                      width: MediaQuery.of(context).size.width,
                                      child: Swiper(
                                        scale: 472 /
                                            705.0,
                                        viewportFraction: 1,
                                        // itemHeight: 472 /
                                        //     705.0 *
                                        //     (MediaQuery.of(context).size.height),
                                        // itemWidth: MediaQuery.of(context).size.width,
                                        // containerHeight: 472 /
                                        //     705.0 *
                                        //     (MediaQuery.of(context).size.height),
                                        // containerWidth: MediaQuery.of(context).size.width,
                                        autoplay: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String imageUrl = _getImageArray(
                                              dataDic!['imgUrl'])[index];
                                          return ClipRRect(
                                            child: Image(image: NetworkImage(imageUrl),fit: BoxFit.cover,),
                                          );
                                        },
                                        pagination: SwiperPagination(
                                          margin: EdgeInsets.only(bottom: 20),
                                          alignment: Alignment.bottomCenter,
                                          builder: BannerPoint(),
                                        ),
                                        itemCount:
                                            _getImageArray(dataDic!['imgUrl'])
                                                .length,
                                      ),
                                    ))
                                : Positioned(
                                    top: 0,
                                    bottom: 153 - 15,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: dataDic != null
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      dataDic!['imgUrl']
                                                          .toString()))
                                              : null),
                                      height: 472 /
                                          705.0 *
                                          (MediaQuery.of(context).size.height),
                                      width: MediaQuery.of(context).size.width,
                                    ))),

                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 60,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (isAnimated == true) {
                              return;
                            }

                            //向上滑动
                            if (details.delta.dy < 0) {
                              setState(() {
                                dy = details.delta.dy;
                                isAnimated = true;
                              });

                              _changeSize();
                            }

                            if (details.delta.dy > 0) {
                              setState(() {
                                dy = details.delta.dy;
                                isAnimated = true;
                              });
                              _changeSize();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            onEnd: () {
                              setState(() {
                                isAnimated = false;
                              });
                            },
                            height: _height,
                            curve: Curves.easeIn,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 5.5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color:
                                          const Color(0xff999999).withOpacity(0.33),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(1.25))),
                                  height: 2.5,
                                  width: 37,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '上滑查看更多',
                                  style: TextStyle(
                                      color:
                                          const Color(0xff999999).withOpacity(0.64),
                                      fontSize: 11),
                                ),
                                const SizedBox(
                                  height: 13,
                                ),
                                Expanded(
                                    child: !(dataDicList == null)
                                        ? MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child: ListView.separated(
                                                controller: _scrollController,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return _buildItem(
                                                      context, index);
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index == 0) {
                                                    return Container();
                                                  }
                                                  return Container(
                                                    height: 0.5,
                                                    color: const Color(0xffEEEEEE),
                                                  );
                                                },
                                                itemCount: dataSource
                                                        .length +
                                                    1),
                                          )
                                        : Container()),
                              ],
                            ),
                          ),
                        )),

                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding:
                              const EdgeInsets.only(bottom: 9, left: 15, right: 15),
                          height: 60,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                height: 0.5,
                                color: const Color.fromRGBO(247, 247, 247, 1.0),
                              ),
                              const SizedBox(
                                height: 10.5,
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding:
                                          const EdgeInsets.only(left: 12, right: 12),
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(
                                              245, 245, 245, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'images/input-icon.png',
                                            width: 13.5,
                                            height: 13.5,
                                          ),
                                          const SizedBox(
                                            width: 5.5,
                                          ),
                                          Expanded(
                                              child: TextField(
                                                focusNode: _focusNode, // 将FocusNode分配给TextField
                                                maxLength: 100,
                                            onSubmitted: (e) {
                                              hideKeyboard(context);
                                              if (applyName=='输入你想说的话吧'){
                                                comment();
                                              }else{
                                                commentWithApply();
                                              }

                                            },
                                            controller: textEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                              counterText: '',
                                                hintText: applyName,
                                                border: InputBorder.none,
                                                isCollapsed: true,
                                                hintStyle: TextStyle(
                                                  color: const Color(0xff999999)
                                                      .withOpacity(0.7),
                                                  fontSize: 13,fontWeight: FontWeight.bold
                                                )),
                                          ))
                                        ],
                                      ),
                                    )),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        hideKeyboard(context);
                                        if (applyName=='输入你想说的话吧'){
                                          comment();
                                        }else{
                                          commentWithApply();
                                        }
                                      },
                                      child: Container(
                                        width: 85.5,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffFE7A24),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          '发布',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Text(
                dataDic != null ? dataDic!['content'] : '',
                maxLines: 999,
                style: const TextStyle(
                  color: Color(0xff333333),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Image.asset(
                  'images/riqi.png',
                  width: 10,
                  height: 9.5,
                ),
                const SizedBox(
                  width: 5.5,
                ),
                Text(
                  dataDic != null
                      ? Utils.formatTimeChatStamp(dataDic!['createTime'])
                      : '',
                  style: const TextStyle(color: Color(0xff999999), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 0.5,
              color: const Color(0xffEEEEEE),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              dataDic != null
                  ? '共${dataDic!['memberCommentDOList'].length}条评论'
                  : '',
              style: const TextStyle(color: Color(0xff333333), fontSize: 15),
            )
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          applyName = dataSource[index - 1]['nickname'];
          applyDic = dataSource[index - 1];
        });
        _focusNode.requestFocus();
        // //查看评论详情
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext ccontext) {
        //   return CommentDetailPage(
        //     dataDic: dataDic!['memberCommentDOList'][index - 1],
        //   );
        // }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [


                GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext ccontext) {
                          return NewUserinfoPage(userId: dataSource[index - 1]['userId'].toString(),);
                        }));
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(dataSource
                            [index - 1]['avatar'])),
                        borderRadius: const BorderRadius.all(Radius.circular(35 / 2.0))),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              dataSource[index - 1]['nickname'],
                              style: const TextStyle(color: Color(0xff666666), fontSize: 14),
                            ),
                            Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      Utils.formatTimeChatStamp(
                                          dataSource[index - 1]
                                          ['commentTime']),
                                      style:
                                      const TextStyle(color: Color(0xff999999), fontSize: 13),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Text(
                          dataSource[index - 1]['content'],
                          maxLines: 2,
                          style: const TextStyle(color: Color(0xff333333), fontSize: 14),
                        )
                      ],
                    )),
              ],
            ),

            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:
                    (BuildContext context,
                    int index1) {
                  return _buildItemApply(
                      context, index1,index);
                },
                separatorBuilder:
                    (BuildContext context,
                    int index) {
                      return Container();
                  if (index == 0) {
                    return Container();
                  }
                  return Container(
                    height: 0.5,
                    color: const Color(0xffEEEEEE),
                  );
                },
                itemCount: dataSource[index - 1]['arr']==null?0:dataSource[index - 1]['arr']
                    .length ),


            // Container(
            //   color: Color(0xffEEEEEE ),
            //   height: 0.5,
            //  margin: EdgeInsets.only(left: 15,right: 15,top: 15),
            // )
            // Expanded(
            //     child: !(dataDic == null)
            //         ? MediaQuery.removePadding(
            //       context: context,
            //       removeTop: true,
            //       child: ListView.separated(
            //           shrinkWrap: true,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemBuilder:
            //               (BuildContext context,
            //               int index) {
            //             return _buildItemApply(
            //                 context, index);
            //           },
            //           separatorBuilder:
            //               (BuildContext context,
            //               int index) {
            //             if (index == 0) {
            //               return Container();
            //             }
            //             return Container(
            //               height: 0.5,
            //               color: const Color(0xffEEEEEE),
            //             );
            //           },
            //           itemCount: dataDic![
            //           'memberCommentDOList']
            //               .length +
            //               1),
            //     )
            //         : Container()),


          ],
        )
      ),
    );
  }


  Widget _buildItemApply(BuildContext context, int index1,int index) {

    return GestureDetector(
      onTap: () {
        setState(() {
          applyName = dataSource[index-1]['arr'][index1]['nickname'];
          applyDic = dataSource[index-1]['arr'][index1];
        });
        _focusNode.requestFocus();
        // //查看评论详情
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext ccontext) {
        //   return CommentDetailPage(
        //     dataDic: dataDic!['memberCommentDOList'][index - 1],
        //   );
        // }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 35, right: 0, top: 20, bottom: 0),
        color: Colors.white,
        child: Row(
          children: [


            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ccontext) {
                      return NewUserinfoPage(userId: dataSource[index-1]['arr'][index1]['userId'].toString(),);
                    }));
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(dataSource
                        [index - 1]['arr'][index1]['avatar'])),
                    borderRadius: const BorderRadius.all(Radius.circular(35 / 2.0))),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          dataSource[index - 1]['arr'][index1]['nickname'],
                          style: const TextStyle(color: Color(0xff666666), fontSize: 14),
                        ),
                        SizedBox(width: 8.5,),
                        Image(image: AssetImage('images/apply_right_arrow.png',),width: 6,height: 11,),
                        SizedBox(width: 8.5,),
                        Text(
                          dataSource[index - 1]['arr'][index1]['superiorCommentUserName'],
                          style: const TextStyle(color: Color(0xff666666), fontSize: 14),
                        ),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  Utils.formatTimeChatStamp(
                                      dataSource[index - 1]['arr'][index1]
                                      ['commentTime']),
                                  style:
                                  const TextStyle(color: Color(0xff999999), fontSize: 13),
                                )
                              ],
                            ))
                      ],
                    ),
                    Text(
                      dataSource[index - 1]['arr'][index1]['content'],
                      maxLines: 2,
                      style: const TextStyle(color: Color(0xff333333), fontSize: 14),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _changeSize() {
    setState(() {
      if (dy > 0) {
        _height = 153;
      } else {
        _height = 600 / 780.0 * (MediaQuery.of(context).size.height);
      }
      isAnimated = false;
    });
  }

  //删除帖子
  deleteMoment() async {
    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("删除动态"),
          content: const Text("确定删除当前动态吗？"),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
                sureDelete();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  sureDelete() async {
    EasyLoading.show();
    Map<String, dynamic> map = {};
    log('传递的信息${dataDic!['id']}');
    // map['id'] = widget.userInfoDic['id'];
    NetWorkService service = await NetWorkService().init();
    service.delete(Apis.deleteUsercomment, queryParameters: {
      'id': dataDic!['id'],
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '删除成功');
      Navigator.pop(context);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });
  }

  ///获取帖子数据
  void getDetailData() async {
    EasyLoading.show();
    log('帖子的id'+widget.id.toString());
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.postDetail, queryParameters: {
      'id': widget.id,
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('帖子详情$data');
      if (userId.toString()==data['userId'].toString()){
        updateMemberMoment(data['id'].toString());
      }

      setState(() {
        dataDic = data;
        //createBlindMemberSeeMe(data);
      });
      getDetailApplyData();
    }, failedCallback: (data) {
      log('帖子错误$data');
      EasyLoading.dismiss();
    });
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
    getDetailApplyData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      getDetailApplyData();
    }
  }


  //获取该帖子下的评论列表
  void getDetailApplyData() async {
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMomentCommentPage, queryParameters: {
      'momentId': widget.id,
      'pageNo':_pageNo,
      'pageSize':20
    }, successCallback: (data) async {
      // EasyLoading.dismiss();
      // log('帖子评论详情$data');
      // setState(() {
      //   dataDicList = data;
      //   //createBlindMemberSeeMe(data);
      // });




      log('帖子评论详情$data');
      isLoading = false;
      EasyLoading.dismiss();
      if (data != null) {
        setState(() {
          if (_pageNo == 1) {
            dataDicList = data;
            dataSource = data!['list'];
          } else {
            if (data!['list'].length == 0) {
              BotToast.showText( text: '没有更多数据了');
            } else {
              dataSource.addAll(data!['list']);
            }
          }
        });

      }

    }, failedCallback: (data) {
      log('帖子错误$data');
      EasyLoading.dismiss();
    });
  }

  //更新状态
  updateMemberMoment(id)async{

    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateMemberMoment, data: {
      'id': int.parse(id),
      'readStatus':1
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('帖子看过了没$data');
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });
  }


  //收起键盘
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  ///评论帖子
  void comment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (textEditingController.text.isEmpty) {
      BotToast.showText(text: '请输入评论内容');
      return;
    }
    EasyLoading.show();

    NetWorkService service = await NetWorkService().init();

    service.post(Apis.comment, data: {
      // 'no': dataDic!['no'],
      'content': textEditingController.text,
      'userId': sharedPreferences.get('UserId').toString(),
      'type': '0',
      'status': '1',
      'momentId': dataDic!['id'].toString(),
      'momentUser': dataDic!['userId'].toString()
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      BotToast.showText(text: '评论成功');
      textEditingController.clear();
      setState(() {
        _pageNo = 1;
        getDetailData();
      });
    }, failedCallback: (data) {
      print(data);
      EasyLoading.dismiss();
    });
  }


  //二级评论
  commentWithApply()async{
    log('要回复的人'+applyDic.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (textEditingController.text.isEmpty) {
      BotToast.showText(text: '请输入评论内容');
      return;
    }
    EasyLoading.show();

    NetWorkService service = await NetWorkService().init();
    // Map<String, dynamic>? data111 = {
    //   'no': applyDic!['no'],
    //   'content': textEditingController.text,
    //   'userId': sharedPreferences.get('UserId').toString(),
    //   // 'type': '0',
    //   // 'status': '1',
    //   'momentId': dataDic!['id'].toString(),
    //   'momentNo': dataDic!['no'].toString(),
    //   'momentUser': dataDic!['userId'].toString(),
    //   'superiorCommentId':applyDic!['id'],
    //   'superiorCommentUserId':applyDic!['userId'],
    //   'superiorCommentUserName':applyDic!['nickname'],
    // };
    // log('回复内容'+data111.toString());
    // return;

    service.post(Apis.comment, data: {
      // 'no': applyDic!['no'],
      'content': textEditingController.text,
      'userId': sharedPreferences.get('UserId').toString(),
      // 'type': '0',
      // 'status': '1',
      'momentId': dataDic!['id'].toString(),
      'momentNo':'',
      'momentUser': dataDic!['userId'].toString(),
      'superiorCommentId':applyDic!['id'],
      'superiorCommentUserId':applyDic!['userId'],
      'superiorCommentUserName':applyDic!['nickname'],

    }, successCallback: (data) async {
      EasyLoading.dismiss();
      BotToast.showText(text: '评论成功');
      textEditingController.clear();
      setState(() {
        _pageNo = 1;
        getDetailData();
      });
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textEditingController.dispose();
    BotToast.closeAllLoading();
    EasyLoading.dismiss();
    _focusNode.dispose();
    super.dispose();
  }


}
