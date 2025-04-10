import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:xinxiangqin/user/user_info_page.dart';
import 'package:xinxiangqin/utils/utils.dart';

class CommentDetailPage extends StatefulWidget {
  Map<String, dynamic> dataDic;
  CommentDetailPage({super.key, required this.dataDic});
  @override
  State<StatefulWidget> createState() {
    return CommentDetailPageState();
  }
}

class CommentDetailPageState extends State<CommentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top + 24,
                  padding: const EdgeInsets.only(left: 15, bottom: 5),
                  alignment: Alignment.bottomLeft,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      const Text(
                        '收到的评论',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                widget.dataDic['imgUrl'] != null
                    ? Container(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),
                          items: [
                            Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.dataDic['imgUrl'])),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                              },
                            ),
                            // 添加更多卡片
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //查看用户信息

                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext ccontext) {
                            return UserInfoPage(
                              userId: widget.dataDic['userId'].toString(),
                            );
                          }));
                        },
                        child: Container(
                          width: 51.5,
                          height: 51.5,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(widget.dataDic['avatar'])),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(51.5 / 2.0))),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.dataDic['nickname'],
                                style: const TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 6.5,
                              ),
                              Container(
                                width: 37,
                                decoration: BoxDecoration(
                                    color: const Color(0xff999999).withOpacity(0.22),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(2.5))),
                                alignment: Alignment.center,
                                child: const Text(
                                  '评论',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff999999), fontSize: 12),
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    Utils.formatTimeChatStamp(
                                        widget.dataDic['commentTime']),
                                    style: const TextStyle(
                                        color: Color(0xff999999), fontSize: 13),
                                  )
                                ],
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.dataDic['content'],
                            maxLines: 999,
                            style: const TextStyle(
                                color: Color(0xff333333), fontSize: 14),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
