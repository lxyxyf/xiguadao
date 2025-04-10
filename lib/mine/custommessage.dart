import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class CustomMessage {
  // 此处的内容请根据需要自行定义
  String? link;
  String? text;
  String? businessID;

  CustomMessage.fromJSON(Map json) {
    link = json["link"];
    text = json["text"];
    businessID = json["businessID"];
  }


  CustomMessage? getCustomMessageData(V2TimCustomElem? customElem) {
    try {
      if (customElem?.data != null) {
        final customMessage = jsonDecode(customElem!.data!);
        return CustomMessage.fromJSON(customMessage);
      }
      return null;
    } catch (err) {
      return null;
    }
  }
}