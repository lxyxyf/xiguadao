class Apis {
  static const String baseUrl = 'https://admin.xiguadao.cc/api-pay';
  // static const String baseUrl = 'http://192.168.8.149';
  // static const String baseUrl = 'http://47.120.22.255:10005';

  ///基础配置
  static const String getBasicSetting =
      '/app-api/blind/basic/setting/getBasicSetting';

  ///获取更新信息
  static const String getNewVersionRecord =
      '/app-api/blind/version-record/getNewVersionRecord';

  ///获取短信验证码
  static const String getSmsCode =
      '/app-api/blind/member/login/app-send-sms-code';

  ///更换手机号
  static const String changePhone = '/app-api/blind/member/login/update-mobile';

  ///登录
  static const String login = '/app-api/blind/member/login/app-sms-login';

  ///占星师登录
  static const String zhanxingshiLogin = '/app-api/blind/member/login/astrologer';

  ///注册完成客服给用户发消息
  static const String sendNotification = '/app-api/blind/member-message/sendNotification';

  ///首页
  static const String home = '/app-api/blind/member/user/getMomentPage';

  ///更换手机号校验验证码
  static const String codeYanZheng = '/app-api/blind/member/login/valid-mobile';

  ///用户信息
  static const String userInfo =
      '/app-api/blind/member/user/getMemberUser';

  ///我的相关信息
  static const String myInformation =
      '/app-api/blind/member/match/myInformation';

  ///获取推荐用户信息
  static const String getMatchBlindMembers =
      '/app-api/blind/member/match/basicMatchBlindMembers';


  ///喜欢推荐用户
  static const String likeMatchBlindMembers =
      '/app-api/blind/member/match/createBlindMemberLike';

  ///不感兴趣
  static const String updateMemberLike = '/app-api/blind/member/match/updateMemberLike';


  ///超级喜欢推荐用户
  static const String reallyLikeUser =
      '/app-api/blind/member/match/reallyLikeUser';

  ///获取超级喜欢用户列表
  static const String mySuperFavoriteList =
      '/app-api/blind/member/match/mySuperFavoriteList';

  ///用户相册
  static const String userPhotosList =
      '/app-api/blind/member/user/getBlindMemberAlbumPage';

  ///保存用户信息
  static const String saveUserInfo =
      '/app-api/blind/member/user/updateBlindMemberUser';

  ///保存用户标签
  static const String saveUsertags =
      '/app-api/blind/member/user/updateMemberUserTag';





  ///上传文件
  static const String uploadFile = '/app-api/infra/file/upload';

  ///我的发帖
  static const String myPosts =
      '/app-api/blind/member/user/getBlindMemberMomentPage';

  ///我收到的评论
  static const String commentList =
      '/app-api/blind/member/user/getMemberCommentPage';

  ///帖子详情
  static const String postDetail = '/app-api/blind/member/user/getMemberMoment';

  ///帖子评论列表
  static const String getMomentCommentPage = '/app-api/blind/member/user/getMomentCommentPage';


  ///更新帖子看过没
  static const String updateMemberMoment =
      '/app-api/blind/member/match/updateMemberMoment';
  ///帖子评论
  static const String comment =
      '/app-api/blind/member/user/createBlindMemberComment';
  ///删除用户的帖子
  static const String deleteUsercomment =
      '/app-api/blind/member/user/deleteBlindMemberMoment';
  ///发帖
  static const String publish =
      '/app-api/blind/member/user/createBlindMemberMoment';

  ///用户检索
  static const String userSearch =
      '/app-api/blind/member/user/getAppointMemberUser';

  ///用户标签
  static const String memberLabel =
      '/app-api/blind/member/user/getMemberLabel';

  ///登录用户标签组 （新）
  static const String getMemberLabelGroupList =
      '/app-api/blind/memberLabelGroup/getMemberLabelGroupList';
  ///登录获取对另一半的期望的所有标签集合
  static const String getExpectedLabelList =
      '/app-api/blind/expectedLabel/getExpectedLabelList';

  ///获取当前用户保存的对另一半的期望的集合
  static const String getUserExpectedLabel =
      '/app-api/blind/member/userExpectedLabel/getUserExpectedLabel';

  ///保存对另一半的期望标签
  static const String createUserExpectedLabel =
      '/app-api/blind/member/userExpectedLabel/createUserExpectedLabel';

  ///修改更新对另一半的期望标签
  static const String updateUserExpectedLabel =
      '/app-api/blind/member/userExpectedLabel/updateUserExpectedLabel';




  ///获取用户的相册
  static const String getUserPhotos =
      '/app-api/blind/member/user/getBlindMemberAlbumPage';
  ///更新用户的相册
  static const String updateUserPhotos =
      '/app-api/blind/member/user/updateBlindMemberAlbum';

  //活动模块
  // static const String activityList =
  //     '/app-api/blind/member/user/getAppointMemberUser';

  //获取活动类型
  static const String activityTypeList =
      '/app-api/xgd/activity/info/getActivityKindList';

  //获取活动列表
  static const String activityList =
      '/app-api/xgd/activity/info/getActivityInfoPage';

  //发布活动
  static const String createActivity =
      '/app-api/xgd/activity/info/createActivityInfo';

  //关闭活动
  static const String closeActivity =
      '/app-api/xgd/activity/info/closeActivityInfo';

  //参与活动
  static const String entroActivity =
      '/app-api/xgd/activity/info/createEnroll';

  //取消参加活动
  static const String cancelEnrollActivity =
      '/app-api/xgd/activity/info/deleteEnroll';
  //获取某活动的信息
  static const String getActivityPageInfo =
      '/app-api/xgd/activity/info/getInfo';


  //获取我发出的喜欢我列表
  static const String getSendLikeList =
      '/app-api/blind/member/match/isSueLikeList';

  //获取我接收到的喜欢我列表
  static const String getReceiveLikeList =
      '/app-api/blind/member/match/receiveLikeList';

  //获取看过我的列表
  static const String getReceiveSeeMeList =
      '/app-api/blind/member/match/getReceiveSeeMeList';


  //获取我看过谁的列表
  static const String getIsSueSeeMeList =
      '/app-api/blind/member/match/getIsSueSeeMeList';

  ///创建想认识谁
  static const String createBlindMemberSeeMe =
      '/app-api/blind/member/match/createBlindMemberSeeMe';

  ///更新看过谁状态不喜欢
  static const String updateMemberSeeme =
      '/app-api/blind/member/match/updateMemberSeeme';




  //获取系统消息
  static const String getSystemMessageList =
      '/app-api/blind/notify-message/getNotifyMessage';

  ///实名认证
  static const String identityAuthentication =
      '/app-api/blind/member/login/identityAuthentication';


  ///实名认证不包含人脸识别
  static const String idCardAuthentication =
      '/app-api/blind/member/login/idCardAuthentication';


  //获取我的积分兑换
  static const String getPointProductPage =
      '/app-api/blind/point-detail/getPointProductPage';


  //积分兑换
  static const String createExchangeDetail =
      '/app-api/blind/point-detail/createExchangeDetail';

  //道具使用
  static const String useExchangeDetail =
      '/app-api/blind/point-detail/useExchangeDetail';

  //获取我的道具卡
  static const String getMyPoint =
      '/app-api/blind/point-detail/getMyPoint';

  //获取我的积分明细
  static const String getPointDetailPage =
      '/app-api/blind/point-detail/getPointDetailPage';




  //会员尊享特权
  static const String getMemberUserPrivilege =
      '/app-api/blind/basic/setting/getMemberUserPrivilege';


  //我的权益
  static const String memberResidualInterest =
      '/app-api/blind/member/match/memberResidualInterest';

  //提交会员支付订单
  static const String createBlindMemberOrder =
      '/app-api/order/blind/trade/createBlindMemberOrder';

  //提交红娘支付订单
  static const String createBlindMakerOrder =
      '/app-api/order/blind/trade/createBlindMakerOrder';




  ///红娘
  //获取红娘商品服务列表
  static const String getMatchmakerProductInfoPage =
      '/app-api/maker/matchmaker-product-info/getMatchmakerProductInfoPage';

  //获取红娘商品服务详情
  static const String getMatchmakerProductInfo =
      '/app-api/maker/matchmaker-product-info/getMatchmakerProductInfo';

  //获取红娘牵线记录
  static const String getMyLeadRecord =
      '/app-api/maker/matchmaker-stringing/getMyLeadRecord';

  //获取我的红娘信息
  static const String getMyMatchmaker =
      '/app-api/maker/matchmaker-stringing/getMyMatchmaker';

  //获取我的服务
  static const String getMyServiceRecord =
      '/app-api/maker/matchmaker-stringing/getMyServiceRecord';




   //获取订单详情
  static const String getBlindTradeOrder =
      '/app-api/order/blind/trade/getBlindTradeOrder';

 ///获取订单列表
  static const String getBlindTradeOrderPage =
      '/app-api/order/blind/trade/getBlindTradeOrderPage';

  //删除订单
  static const String deleteBlindTradeOrder =
      '/app-api/order/blind/trade/deleteBlindTradeOrder';

  //取消订单
  static const String cancelBlindTradeOrder =
      '/app-api/order/blind/trade/cancelBlindTradeOrder';

// static const String activityTypeList =
//     '/api-pay/app-api/activity/info/getProductTypeList';

  //创建星座测试
  static const String createConstellationTest =
      '/app-api/blind/constellation-test/createConstellationTest';
  //用户获取自己的星座测试结果
  static const String getConstellationTest =
      '/app-api/blind/constellation-test/getConstellationTest';

  //占星师根据回复的用户userId获取星座测试结果
  static const String getDivinerConstellationTest =
      '/app-api/blind/constellation-test/getDivinerConstellationTest';

  //测试师获取星座提交列表
  static const String getConstellationTestPage =
      '/app-api/blind/constellation-test/getConstellationTestPage';

  //提交录音
  static const String createConstellationSpeech =
      '/app-api/blind/constellation-test/createConstellationSpeech';

  ///修改星座回复是否已读状态
  static const String updateConstellationTest =
      '/app-api/blind/constellation-test/updateConstellationTest';


  //获取双方的距离
  static const String getDistance =
      '/app-api/blind/member/login/getDistance';

  //首页推荐切换名片次数
  static const String businessCardBrowsing =
      '/app-api/blind/member/match/businessCardBrowsing';



}
