import 'dart:async';

import 'package:black_bear/config/event_bus.dart';
import 'package:black_bear/config/my_colors.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Timer timer;
  PageController pageController;
  int index = 0; // banner index

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

  // 搜索框
  Widget _searchView() {
    return Container();
  }

  // 菜单按钮
  Widget _menuButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 50,
      height: double.infinity,
      child: FlatButton(
          onPressed: () {
            eventBus.fire(EventDrawer(true));
          },
          child: Icon(
            Icons.menu,
            // color: MyColors.balck,
          )),
    );
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
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return _dailyRecommendItem(index);
            }));
  }

  // 每日推荐列表item
  Widget _dailyRecommendItem(int index) {
    return GestureDetector(
      onTap: () {
        print("recommend click2: $index");
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
                image: AssetImage(recommendUrls[index]),
                height: 25,
                width: 25,
                color: MyColors.theme,
              ),
            ],
          ),
          Text(
            recommendStrs[index],
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendSongSheetUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return _recommendSongSheetItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 推荐歌单列表item
  Widget _recommendSongSheetItem(int index) {

    return GestureDetector(
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
                      image: AssetImage(recommendSongSheetUrls[index]),
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          Container(
            width: 100,
            child: Text(
              recommendSongSheetStrs[index],
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        onTap: () {
          print("recommend song sheet click: $index");
        },
      );
  }
}
