import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/mine/like_receive_page.dart';
import 'package:xinxiangqin/mine/comment_list_page.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/shequ/post_detail_page.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/utils/utils.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import '../activity/my_activity_list.dart';
import 'userinfo_change_page.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MinePage> {
  Map<String, dynamic> userDic = {};
  int _pageNo = 1;

  List dataSource = [];
  @override
  void initState() {
    super.initState();
    eventTools.on('changeUserInfo', (arg) {
      getUserInfo();
    });
    getUserInfo();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffEAEAEA),
      body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child:  SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      // height: dataSource.length!=0?dataSource.length*280:0,
                        margin: EdgeInsets.all(15),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: Container(
                            // padding: const EdgeInsets.only(right: 15.5),
                              child: RefreshIndicator(
                                onRefresh: _onRefresh,
                                child: GridView.builder(
                                    shrinkWrap: true, // 根据内容自动调整高度
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: dataSource.length,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, //每一行的列数
                                      mainAxisSpacing: 10, //主轴方向上的间距
                                      crossAxisSpacing: 10, //交叉轴轴方向上的间距
                                      childAspectRatio: 167.3 / 241.0, //子元素的宽高比例
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _buildItem(context, index);
                                    }),
                              )),
                        )
                    )


                    // Positioned(
                    //   right: 5,
                    //   bottom: 23.5,
                    //   child:  GestureDetector(
                    //       onTap: (){
                    //         Navigator.push(context,
                    //             MaterialPageRoute(builder: (BuildContext ccontext) {
                    //               return PublishPage();
                    //             }));
                    //       },
                    //       child:Container(
                    //         width: 61,
                    //         height: 61,
                    //         child: Image(image:AssetImage('images/publishActivity.png'),),
                    //       )),
                    // )
                  ],
                ),
              )
          )


      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //查看详情
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return PostDetailPage(
                id: dataSource[index]['id'].toString(),
              );
            }));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 184,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(dataSource[index]['imgUrl'] != null
                          ? (dataSource[index]['imgUrl']
                          .toString()
                          .contains(',')
                          ? _getImageArray(
                          dataSource[index]['imgUrl'].toString())[0]
                          .toString()
                          : dataSource[index]['imgUrl'])
                          : userDic['avatar'].toString())),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.5, top: 9.5),
              child: Text(
                dataSource[index]['content'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xff333333), fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.5, top: 10, right: 7.5),
              child: Row(
                children: [
                  Text(
                    Utils.formatTimeChatStamp(dataSource[index]['createTime']),
                    style: const TextStyle(color: Color(0xff666666), fontSize: 12),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'images/icon-pinglun.png',
                            width: 10,
                            height: 9,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (dataSource[index]['memberCommentDOList'])
                                .length
                                .toString(),
                            style:
                            const TextStyle(color: Color(0xff666666), fontSize: 12),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          print(data);
          setState(() {
            userDic = data;
          });
        }, failedCallback: (data) {});
  }

  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      _pageNo = 1;
      _getData();
    });
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  ///获取我的帖子数据
  void _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myPosts, queryParameters: {
      'userId': sharedPreferences.get('UserId').toString(),
      'pageNo': _pageNo.toString(),
      'pageSize': '20',
    }, successCallback: (data) async {
      print('1111');
      print(data);
      if (data['list'] != null) {
        setState(() {
          dataSource = data['list'];
        });
      }
    }, failedCallback: (data) {});
  }

  ImageProvider getImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(
      imageUrl,
    );
  }

  @override
  void dispose() {
    eventTools.off('changeUserInfo');
    super.dispose();
  }
}
