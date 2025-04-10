import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class BannerPoint extends SwiperPagination {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the dot when activate
  final double activeWidth;
  final double activeHeight;

  ///Size of the dot
  final double width;
  final double height;

  /// Space between dots
  final double space;

  @override
  final Key? key;

  const BannerPoint(
      {this.activeColor = const Color(0xffFF58AD),
      this.color = Colors.white,
      this.key,
      this.width = 6.0,
      this.height = 4.0,
      this.activeWidth = 12.0,
      this.activeHeight = 4.0,
      this.space = 2.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    if (config.itemCount > 20) {
      // LogUtil.v(
      //     "The itemCount is too big, we suggest use FractionPaginationBuilder instead of APPDotSwiperPaginationBuilder in this sitituation");
    }
    Color activeColor = this.activeColor;
    Color color = this.color;

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController!,
        layout: config.indicatorLayout,
        size: max(width, height),
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    List<Widget> list = [];

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(Container(
        key: Key("pagination_$i"),
        margin: EdgeInsets.all(space),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            color: active ? activeColor : color,
          ),
          width: active ? activeWidth : width,
          height: active ? activeHeight : height,
        ),
      ));
    }

    Flex child;
    if (config.scrollDirection == Axis.vertical) {
      child = Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      child = Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.black12,
      ),
      child: child,
    );
  }
}
