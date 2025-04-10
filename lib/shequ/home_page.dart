import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/shequ/post_detail_page.dart';
import 'package:bookfx/bookfx.dart';

import '../publish/publish_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List dataSource = [];

  int _pageNo = 1;

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getData();
  }

  List<Widget> widgets = [];

  BookController bookController = BookController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  height: MediaQuery.of(context).padding.top + 24,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(),
                      const Positioned(
                          left: 0,
                          bottom: 7.5,
                          child: Text('社区',
                              style: TextStyle(
                                  color: Color(0xff0C0C2C),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      Positioned(
                          left: 2.5,
                          bottom: 5,
                          child: Image.asset(
                            'images/home_tip.png',
                            width: 60,
                            height: 20,
                          ))
                    ],
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).padding.top + 24 + 22,
                bottom: 40,
                child: Container(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildItem(context, index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 20,
                            );
                          },
                          itemCount: dataSource.length),
                    ),
                  ),
                )),
            Positioned(
                bottom: 40,
                right: 20,
                child: GestureDetector(
                  onTap: ()async{
                   await  Navigator.push(context,
                       MaterialPageRoute(builder: (BuildContext ccontext) {
                         return  PublishPage();
                       }));
                   setState(() {
                     _pageNo=1;
                     getData();
                   });
                  },
                  child: const Image(  width: 70,
                    height: 70,
                    fit: BoxFit.cover,image: AssetImage('images/add_icon.png'),),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Map<String, dynamic> map = dataSource[index];
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
          return PostDetailPage(
            id: map['id'].toString(),
          );
        }));
        setState(() {
          _pageNo=1;
          getData();
        });

      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        color: Colors.white,
        width: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top + 24) -
            40 -
            49 -
            20 -
            22 -
            56 -
            40 -
            20,
        child: Stack(
          children: [
            Container(),
            Positioned(
                bottom: 86 + 20,
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(map['imgUrl'] != null
                            ? (map['imgUrl'].toString().contains(',')
                                ? _getImageArray(map['imgUrl'].toString())[0]
                                    .toString()
                                : map['imgUrl'])
                            : map['avatar'].toString())),
                  ),
                  padding: const EdgeInsets.only(top: 45, left: 10, right: 10),
                )),
            Positioned(
                bottom: 86,
                left: 36,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 55, right: 12.5),
                  height: 47,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(47 / 2.0))),
                  child: Text(
                    map['nickname']!=null?map['nickname']:'',
                    style: const TextStyle(color: Color(0xff666666), fontSize: 15.0),
                  ),
                )),
            Positioned(
                left: 22,
                bottom: 76,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(65 / 2.0))),
                )),
            Positioned(
              left: 27,
              bottom: 81,
              child: Container(
                child: Row(
                  children: [
                    map['avatar'] != null
                        ? ClipOval(
                            child: Image.network(
                              map['avatar'].toString(),
                              width: 54.65,
                              height: 54.65,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'images/default_avatar.png',
                            width: 54.65,
                            height: 54.65,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(
                      width: 7,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 45,
                left: 15,
                right: 15,
                child: Text(
                  map['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xff333333), fontSize: 15),
                )),
            Positioned(
                left: 15,
                bottom: 15,
                child: Row(
                  children: [
                    Image.asset(
                      'images/icon-pinglun.png',
                      width: 10,
                      height: 9,
                      color: const Color(0xff666666),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      (map['memberCommentDOList']).length.toString(),
                      style: const TextStyle(color: Color(0xff666666), fontSize: 12),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
    getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      getData();
    }
  }

  void getData() async {
    BotToast.showLoading();

    NetWorkService service = await NetWorkService().init();
    service.get(
      Apis.home,
      queryParameters: {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
        'auditStatus': '1',
        'appType': '1'
      },
      successCallback: (data) async {
        BotToast.closeAllLoading();

        if (data['list'] != null) {
          setState(() {
            dataSource = data['list'];
          });
        }
      },
      failedCallback: (data) {
        BotToast.closeAllLoading();
      },
    );
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
