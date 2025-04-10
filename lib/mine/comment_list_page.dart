
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xinxiangqin/mine/comment_detail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/utils/utils.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import '../shequ/post_detail_page.dart';

class CommentListPage extends StatefulWidget {
  const CommentListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return CommentListPageState();
  }
}

class CommentListPageState extends State<CommentListPage> {
  List dataSource = [];
  int _pageNo = 1;

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("收到的评论"),
        titleTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.w500),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
        ),

      ),
      body: Container(
        padding: const EdgeInsets.all(15.5),
        child: Column(
          children: [

            const SizedBox(
              height: 15,
            ),
            dataSource.length!=0?Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildItem(context, index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 15,
                          );
                        },
                        itemCount: dataSource.length),
                  ),
                )):Center(
              child: Image(image: AssetImage('images/home_nodata.png')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //评论详情
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext ccontext) {
        //   return CommentDetailPage(
        //     dataDic: dataSource[index],
        //   );
        // }));
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return PostDetailPage(
                id:dataSource[index]['momentId'].toString(),
              );
            }));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataSource[index]['avatar'] != null
                ? ClipOval(
                    child: NetImage(
                      dataSource[index]['avatar'],
                      width: 35,
                      height: 35,
                    ),
                  )
                : Container(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataSource[index]['nickname'] ?? '',
                  style: const TextStyle(
                      color: Color(0xff333333),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '评论了你的动态  ${Utils.formatTimeChatStamp(
                          dataSource[index]['commentTime'])}',
                  style: const TextStyle(color: Color(0xff999999), fontSize: 13),
                ),
                Text(
                  dataSource[index]['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xff333333), fontSize: 14),
                )
              ],
            )),
            const SizedBox(
              width: 10,
            ),
            // Container(
            //   width: 52.5,
            //   height: 52.5,
            //   decoration: BoxDecoration(
            //       color: Colors.yellow,
            //       borderRadius: BorderRadius.all(Radius.circular(5))),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
    _getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      _getData();
    }
  }

  ///获取数据
  void _getData() async {
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.commentList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log(data.toString());
      isLoading = false;
      if (data['list'] != null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
          } else {
            if (data['list'].length == 0) {
              EasyLoading.showToast('没有更多数据了');
            } else {
              dataSource.addAll(data['list']);
            }
          }
        });
      }
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });
  }
}
