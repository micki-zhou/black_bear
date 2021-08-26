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

  // TODO 临时数据
  BannerData bannerData;
  DailyRecommendData dailyRecommendData;
  RecommendSongSheetData recommendSongSheetData;
  SimilarRecommendData similarRecommendData;

  @override
  void initState() {
    super.initState();

    bannerData = getBannerData();
    dailyRecommendData = getDailyRecommendData();
    recommendSongSheetData = getRecommendSongSheetdata();
    similarRecommendData = getSimilarRecommendData();

    pageController = PageController(initialPage: 0);
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      index++;
      if (index > bannerData.url.length - 1) {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _topView(context),
            _homeBanner(),
            _dailyRecommend(),
            _recommendSongSheet(),
            _similarRecommend(),
          ],
        ),
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
      height: 180,
      child: PageView(
        controller: pageController,
        children: _getBannerImageWidget(),
      ),
    );
  }

  // 处理图片列表
  List<Widget> _getBannerImageWidget() {
    List<Widget> banners = new List();
    for (String url in bannerData.url) {
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
            itemCount: dailyRecommendData.data.length,
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
                image: AssetImage(dailyRecommendData.data[index].url),
                height: 25,
                width: 25,
                color: MyColors.theme,
              ),
            ],
          ),
          Text(
            dailyRecommendData.data[index].name,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 推荐歌单
  Widget _recommendSongSheet() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
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
              itemCount: recommendSongSheetData.data.length,
              itemBuilder: (context, index) {
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
        Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage(recommendSongSheetData.data[index].url),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          width: 100,
          child: Text(
            recommendSongSheetData.data[index].name,
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

  // 相似推荐
  Widget _similarRecommend() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "相似推荐",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: MyColors.homeTheme),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "播放",
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
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.2),
                scrollDirection: Axis.horizontal,
                itemCount: similarRecommendData.data.length,
                itemBuilder: (context, index) {
                  return simalarRecommentItem(index);
                }),
          ),
        ],
      ),
    );
  }

  // 相似推荐列表item
  Widget simalarRecommentItem(int index) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(similarRecommendData.data[index].url),
                  fit: BoxFit.cover),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                similarRecommendData.data[index].name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              Text(
                similarRecommendData.data[index].shortWord,
                style: TextStyle(fontSize: 12, color: MyColors.color_999999),
              )
            ],
          )
        ],
      ),
    );
  }

  // ---- 临时数据组装 ----

  // banner 数据
  BannerData getBannerData() {
    var result = List<String>.empty(growable: true);
    result.add('images/img_banner01.jpeg');
    result.add('images/img_banner02.jpeg');
    result.add('images/img_banner03.jpeg');
    result.add('images/img_banner04.jpeg');

    return BannerData(result);
  }

  // 每日推荐数据
  DailyRecommendData getDailyRecommendData() {
    var result = List<ImageTextData>.empty(growable: true);
    result.add(ImageTextData('每日推荐', 'images/icon_home_daily.png'));
    result.add(ImageTextData('歌单', 'images/icon_home_music_list.png'));
    result.add(ImageTextData('排行榜', 'images/icon_home_rank.png'));
    result.add(ImageTextData('私人FM', 'images/icon_home_radio.png'));
    result.add(ImageTextData('直播', 'images/icon_home_live.png'));
    result.add(ImageTextData('数字专辑', 'images/icon_home_album.png'));
    result.add(ImageTextData('唱聊', 'images/icon_home_chat.png'));
    return DailyRecommendData(result);
  }

  // 推荐歌单数据
  RecommendSongSheetData getRecommendSongSheetdata() {
    var result = List<ImageTextData>.empty(growable: true);
    result.add(
        ImageTextData('希望熬过孤独的你，能活成自己喜欢的模样', 'images/img_recommend01.jpeg'));
    result.add(
        ImageTextData('男生的温柔沁入心底 珊瑚长出海面 而你呢', 'images/img_recommend02.jpeg'));
    result
        .add(ImageTextData('痛彻心扉地哭，然后刻骨铭心的记住', 'images/img_recommend03.jpeg'));
    result.add(
        ImageTextData('后来你哭了，想安慰却忘了早已经没有了那个人', 'images/img_recommend04.jpg'));
    result.add(ImageTextData('看小说听的歌曲（古风）', 'images/img_recommend05.jpg'));
    result.add(ImageTextData('夜夜助你入眠', 'images/img_recommend06.jpeg'));
    return RecommendSongSheetData(result);
  }

  // 相似推荐数据
  SimilarRecommendData getSimilarRecommendData() {
    var result = List<SimilarData>.empty(growable: true);
    result.add(
        SimilarData('images/img_recommend02.jpeg', '夜曲', '-周杰伦', '那些年的经典歌曲'));
    result.add(SimilarData(
        'images/img_recommend04.jpg', '只为你着迷', '-李秉成', '承蒙你的出现 让我学会了坚强'));
    result.add(SimilarData(
        'images/img_recommend05.jpg', '我应该去爱你', '-李韩宇Yuzi', '情歌的魅力'));
    result.add(SimilarData(
        'images/img_recommend01.jpeg', '不要忘记我爱你', '-张碧晨', '请你不要忘记那些会议'));
    result.add(SimilarData('images/img_recommend06.jpeg', 'You Are Beautiful',
        '-刘沁', '爱到了极致 你就是我的命'));
    result.add(SimilarData(
        'images/img_recommend02.jpeg', '路过爱情', '-梁又琳', '那年遇见你 便是倾心'));
    result.add(SimilarData(
        'images/img_recommend04.jpg', '追梦赤子心', '-Gala乐队', '命运掌握在自己手里'));
    result.add(SimilarData(
        'images/img_recommend02.jpeg', '慢慢喜欢你', '-莫文蔚', '怕你不够勇气 才说岁月蹉跎'));
    result.add(
        SimilarData('images/img_recommend03.jpeg', '傻女', '-容祖儿', '傻傻的我，傻傻的你'));
    result.add(
        SimilarData('images/img_recommend05.jpg', '大哥', '-卫兰', '我要爱情不需要登对'));
    return SimilarRecommendData(result);
  }
}

// 相似推荐数据

// banner
class BannerData {
  List<String> url;
  BannerData(this.url);
}

// daily recommend
class DailyRecommendData {
  List<ImageTextData> data;

  DailyRecommendData(this.data);
}

// recommend song sheet
class RecommendSongSheetData {
  List<ImageTextData> data;

  RecommendSongSheetData(this.data);
}

// similar recommend
class SimilarRecommendData {
  List<SimilarData> data;
  SimilarRecommendData(this.data);
}

// image text
class ImageTextData {
  String name;
  String url;
  ImageTextData(this.name, this.url);
}

// similar data
class SimilarData {
  String url;
  String name;
  String author;
  String shortWord;
  SimilarData(this.url, this.name, this.author, this.shortWord);
}

// ---- 临时数据组装 ----
