import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/shequ/post_detail_page.dart';
import 'package:xinxiangqin/utils/utils.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key, required this.userId});
  final String userId;
  @override
  State<StatefulWidget> createState() {
    return UserInfoPageState();
  }
}

class UserInfoPageState extends State<UserInfoPage> {
  Map<String, dynamic> dataDic = {};
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 231.5,
              decoration: dataDic.isNotEmpty
                  ? BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(dataDic['avatar'])))
                  : null,
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    top: 35.5 + 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 17.5,
                      bottom: 28,
                      child: Container(
                        width: 58.65,
                        height: 58.65,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(57 / 2.0))),
                      )),
                  Positioned(
                      left: 19.5,
                      bottom: 30,
                      child: Container(
                        height: 54.65,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(54.65 / 2.0)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54.65,
                              height: 54.65,
                              decoration: BoxDecoration(
                                  image: dataDic.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(dataDic['avatar']))
                                      : null,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(54.65 / 2.0))),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              dataDic.isNotEmpty ? dataDic['nickname'] : '',
                              style: const TextStyle(
                                  color: Color(0xff666666), fontSize: 15.0),
                            ),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      )),
                  // Positioned(
                  //     left: 63.5,
                  //     top: 143.5 + 3.5,
                  //     child: dataDic.isNotEmpty
                  //         ? dataDic['sex'].toString() == '2'
                  //             ? Image.asset(
                  //                 'images/icon-nv.png',
                  //                 width: 17,
                  //                 height: 17,
                  //               )
                  //             : Image.asset(
                  //                 'images/icon-nan.png',
                  //                 width: 17,
                  //                 height: 17,
                  //               )
                  //         : Container())
                ],
              ),
            ),
            Expanded(
                child: (dataDic.isNotEmpty &&
                        dataDic['blindMemberMomentDOList'].isNotEmpty)
                    ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return _buildItem(context, index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 20,
                            );
                          },
                          itemCount: dataDic['blindMemberMomentDOList'].length,
                          padding: const EdgeInsets.only(top: 20),
                        ),
                      )
                    : const Center(
                        child: Text('暂无任何数据'),
                      ))
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Map<String, dynamic> dic = dataDic['blindMemberMomentDOList'][index];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        //查看贴子详情
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
          return PostDetailPage(
            id: dic['id'].toString(),
          );
        }));
      },
      child: Container(
          child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(),
          Container(
            padding:
                const EdgeInsets.only(left: 9.5,  top: 10.5, bottom: 10.5),
            margin: const EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width - 30,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.formatTimeChatStamp(dic['createTime']),
                  style: const TextStyle(color: Color(0xff0C0C2C), fontSize: 14),
                ),
                const SizedBox(
                  height: 11.5,
                ),
                (dic['imgUrl'] != null && dic['imgUrl'].length > 0)
                    ? _buildImagesWidget(dic['imgUrl'])
                    : Container(),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30 - 9.5 * 2,
                  child: Text(
                    dic['content'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xff333333), fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30 - 9.5 * 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'images/icon-pinglun.png',
                        width: 12.5,
                        height: 11.5,
                      ),
                      const SizedBox(
                        width: 5.5,
                      ),
                      Text(
                        dic['memberCommentDOList'] == null
                            ? '0'
                            : dic['memberCommentDOList'].length.toString(),
                        style:
                            const TextStyle(color: Color(0xff666666), fontSize: 13),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 35 / 2.0 - 5,
            top: -41 / 2.0 + 5,
            child: Image.asset(
              'images/icon-edit.png',
              width: 35,
              height: 41,
            ),
          )
        ],
      )),
    );
  }

  Widget _buildImagesWidget(String imageStr) {
    if (imageStr.isEmpty) {
      return Container();
    }

    List<String> imageUrls = [];
    if (!imageStr.contains(',')) {
      imageUrls = [imageStr];
    } else {
      imageUrls = _getImageArray(imageStr);
    }

    List<Widget> widgets = [];
    for (int i = 0; i < imageUrls.length; i++) {
      if (i == 3) {
        break;
      }
      widgets.add(Container(
        width: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
        height: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrls[i].toString())),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
      ));

      widgets.add(const SizedBox(
        width: 9.5,
      ));
    }

    return Row(
      children: widgets,
    );
  }

  void _getUserInfo() async {
    EasyLoading.show();

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userSearch, queryParameters: {"userId": widget.userId},
        successCallback: (data) async {
      EasyLoading.dismiss();
log('用户主页$data');
      setState(() {
        dataDic = data;
      });
    }, failedCallback: (data) {
          log('用户主页错误$data');
      EasyLoading.dismiss();
    });
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }
}
