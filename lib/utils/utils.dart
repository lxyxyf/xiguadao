class Utils {
  //聊天时间戳转日期格式
  static String formatTimeChatStamp(int time) {
    var timestp = DateTime.fromMillisecondsSinceEpoch(time);
    String hour = timestp.hour < 10 ? '0${timestp.hour}' : '${timestp.hour}';
    String minute =
        timestp.minute < 10 ? '0${timestp.minute}' : '${timestp.minute}';
    var now = DateTime.now().millisecondsSinceEpoch;
    var timenow = DateTime.fromMillisecondsSinceEpoch(now);
    //整点
    var strtimes = DateTime.parse(
            '${timestp.year}-${timestp.month >= 10 ? timestp.month : ('0${timestp.month}')}-${timestp.day >= 10 ? timestp.day : ('0${timestp.day}')} 00:00:00.00000')
        .millisecondsSinceEpoch;
    if (now - strtimes >= 86400000 && now - strtimes < 86400000 * 2) {
      //昨天的消息
      return '昨天 $hour:$minute';
    } else if ('${timestp.year}-${timestp.month}-${timestp.day}' ==
        '${timenow.year}-${timenow.month}-${timenow.day}') {
      //今天的消息
      return '$hour:$minute';
    } else {
      //昨天之前的消息
      return '${timestp.year}-${timestp.month}-${timestp.day}';
    }
  }
}
