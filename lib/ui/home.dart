import 'dart:async';

import 'package:black_bear/config/my_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer timer;
  PageController pageController;
  int index = 0;
  // TODO banner 临时图片数据
  List<String> imageUrls = [
    'images/img_banner01.png',
    'images/img_banner02.png',
    'images/img_banner03.png'
  ];
  List<String> recommendUrls = [
    'images/icon_home_daily.png',
    'images/icon_home_music_list.png',
    'images/icon_home_rank.png',
    'images/icon_home_radio.png',
    'images/icon_home_live.png',
    'images/icon_home_album.png',
    'images/icon_home_chat.png'
  ];
  List<String> recommendStrs = [
    '每日推荐',
    '歌单',
    '排行榜',
    '私人FM',
    '直播',
    '数字专辑',
    '唱聊'
  ];

  // TODO recommend 临时图片数据
  List<String> recommendSongSheetUrls = [
    'images/img_recommend01.jpeg',
    'images/img_recommend02.jpeg',
    'images/img_recommend03.jpeg',
    'images/img_recommend04.jpg',
    'images/img_recommend05.jpg',
    'images/img_recommend06.jpeg',
  ];

  List<String> recommendSongSheetStrs = [
    '希望熬过孤独的你，能活成自己喜欢的模样',
    '男生的温柔沁入心底 珊瑚长出海面 而你呢',
    '痛彻心扉地哭，然后刻骨铭心的记住',
    '后来你哭了，想安慰却忘了早已经没有了那个人',
    '看小说听的歌曲（古风）',
    '夜夜助你入眠',
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      index++;
      if (index > imageUrls.length - 1) {
        index = 0;
      }
      pageController.animateToPage(index,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      backgroundColor: MyColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topView(context),
          _homeBanner(),
          _dailyRecommend(),
          _recommendSongSheet()
        ],
      ),
    );
  }

  // 抽屉
  Widget _drawer() {
    return Drawer(
      child: Container(
        padding:
            EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
        child: Column(
          children: [
            _mineView(),
          ],
        ),
      ),
    );
  }

  // 头像、名字、个人资料入口
  Widget _mineView() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('images/lufei.jpg'), fit: BoxFit.cover),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              Text(
                'micki_zhou >',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Image.asset(
            'images/icon_scan.png',
            width: 25,
            height: 25,
          )
        ],
      ),
    );
  }

  // 顶部栏
  Widget _topView(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
      color: MyColors.homeTheme,
      height: 70,
      child: Row(
        children: [
          Builder(builder: (BuildContext context) {
            return _menuButton(context);
          }),
          _searchView(),
        ],
      ),
    );
  }

  // 菜单按钮
  Widget _menuButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 50,
      height: double.infinity,
      child: FlatButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(
            Icons.menu,
            // color: MyColors.balck,
          )),
    );
  }

  // 搜索框
  Widget _searchView() {
    return Container();
  }

  // banner
  Widget _homeBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      height: 150,
      child: PageView(
        controller: pageController,
        children: _getBannerImageWidget(),
      ),
    );
  }

  // 处理图片列表
  List<Widget> _getBannerImageWidget() {
    List<Widget> banners = new List();
    for (String url in imageUrls) {
      banners.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
        ),
        margin: EdgeInsets.all(10),
      ));
    }
    return banners;
  }

  // 每日推荐列表
  Widget _dailyRecommend() {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _getDailyRecommend(),
      ),
    );
  }

  // 处理获取每日推荐列表
  List<Widget> _getDailyRecommend() {
    List<Widget> result = List();
    for (var i = 0; i < recommendUrls.length; i++) {
      result.add(GestureDetector(
        onTap: () {
          print("recommend click: $i");
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MyColors.theme6,
                    shape: BoxShape.circle,
                  ),
                ),
                Image(
                  image: AssetImage(recommendUrls[i]),
                  height: 25,
                  width: 25,
                  color: MyColors.theme,
                ),
              ],
            ),
            Text(
              recommendStrs[i],
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ));
    }
    return result;
  }

  // 推荐歌单
  Widget _recommendSongSheet() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "推荐歌单",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: MyColors.homeTheme),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "更多 >",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _recommendSongSheetList(),
            ),
          ),
        ],
      ),
    );
  }

  // 推荐歌单列表
  List<Widget> _recommendSongSheetList() {
    List<Widget> result = List();
    for (int i = 0; i < recommendSongSheetUrls.length; i++) {
      result.add(GestureDetector(
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(recommendSongSheetUrls[i]),
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          Container(
            width: 100,
            child: Text(
              recommendSongSheetStrs[i],
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        onTap: () {
          print("recommend song sheet click: $i");
        },
      ));
    }
    return result;
  }
}
