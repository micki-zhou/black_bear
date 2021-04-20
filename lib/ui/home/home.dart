import 'package:black_bear/config/event_bus.dart';
import 'package:black_bear/config/my_colors.dart';
import 'package:black_bear/ui/home/explore.dart';
import 'package:black_bear/ui/home/mine.dart';
import 'package:black_bear/ui/home/podcast.dart';
import 'package:black_bear/ui/home/sing.dart';
import 'package:black_bear/ui/home/group.dart';
import 'package:black_bear/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    ExplorePage(),
    PodcastPage(),
    MinePage(),
    SingPage(),
    GroupPage()
  ];
  final List<BottomNavigationBarItem> bottomNavigationBarItem = [
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/icon_explore.png',
          width: 30,
          height: 30,
        ),
        label: '发现',
        activeIcon: Image.asset(
          'images/icon_explore_active.png',
          width: 30,
          height: 30,
        )),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/icon_podcast.png',
          width: 30,
          height: 30,
        ),
        label: '播客',
        activeIcon: Image.asset(
          'images/icon_podcast_active.png',
          width: 30,
          height: 30,
        )),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/icon_mine.png',
          width: 30,
          height: 30,
        ),
        label: '我的',
        activeIcon: Image.asset(
          'images/icon_mine_active.png',
          width: 30,
          height: 30,
        )),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/icon_sing.png',
          width: 30,
          height: 28,
        ),
        label: 'k歌',
        activeIcon: Image.asset(
          'images/icon_sing_active.png',
          width: 30,
          height: 28,
        )),
    BottomNavigationBarItem(
        icon: Image.asset(
          'images/icon_group.png',
          width: 28,
          height: 30,
        ),
        label: '熊村',
        activeIcon: Image.asset(
          'images/icon_group_active.png',
          width: 28,
          height: 30,
        ))
  ];

  int bottomIndex = 0; // bottom navigation index
  var isOpenDrawer = false;
  var eventBusHome;

  @override
  void initState() {
    super.initState();
    eventBusHome = eventBus.on<EventDrawer>().listen((event) {
      if (event.isOpen) {
        setState(() {
          isOpenDrawer = !isOpenDrawer;
          Scaffold.of(context).openDrawer();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventBusHome.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      backgroundColor: MyColors.background,
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItem,
        currentIndex: bottomIndex,
        selectedItemColor: MyColors.theme,
        unselectedItemColor: MyColors.gray,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          changePage(index);
        },
      ),
      body: pages[bottomIndex],
    );
  }

  void changePage(int index) {
    if (index != bottomIndex) {
      setState(() {
        bottomIndex = index;
      });
    }
  }

  // 抽屉
  Widget _drawer() {
    return Drawer(
      child: Container(
        color: MyColors.background,
        padding:
            EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
        child: Column(
          children: [
            _mineView(),
            _drawList(),
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

  // 侧边栏列表选项
  Widget _drawList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: MyColors.white),
          margin: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _drawerListClick('消息中心', 0),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: MyColors.line,
              height: 1,
            ),
            SizedBox(
              height: 10,
            ),
            _drawerListClick('创作者中心', 2)
          ]),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: MyColors.white),
          margin: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '音乐服务',
              style: TextStyle(color: MyColors.gray),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: MyColors.line,
              height: 1,
            ),
            SizedBox(
              height: 10,
            ),
            _drawerListClick('演出', 3),
            SizedBox(
              height: 20,
            ),
            _drawerListClick('商城', 4),
            SizedBox(
              height: 20,
            ),
            _drawerListClick('口袋彩铃', 5),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: MyColors.white),
          margin: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '其他',
              style: TextStyle(color: MyColors.gray),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: MyColors.line,
              height: 1,
            ),
            SizedBox(
              height: 10,
            ),
            _drawerListClick('设置', 7),
            SizedBox(
              height: 20,
            ),
            _drawerListClick('夜间模式', 8),
            SizedBox(
              height: 20,
            ),
            _drawerListClick('分享', 9),
            SizedBox(
              height: 20,
            ),
            _drawerListClick('关于', 10),
          ]),
        ),
        Container(
          margin: EdgeInsets.all(10),
          // decoration: BoxDecoration(borderRadius:BorderRadius.circular(45)),
          child: FlatButton(
            onPressed: () {
              // 退出登录
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }), (route) => false);
            },
            minWidth: double.infinity,
            child: Text('log out'),
            textColor: MyColors.theme,
            color: MyColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

// 添加点击事件
  Widget _drawerListClick(String text, int type) {
    return InkWell(
      onTap: () {
        switch (type) {
          case 0:
            {
              print('消息中心click');
              break;
            }
          case 1:
            {
              print('云贝中心click');
              break;
            }
          case 2:
            {
              print('创作者中心click');
              break;
            }
          case 3:
            {
              print('演出click');
              break;
            }
          case 4:
            {
              print('商城click');
              break;
            }
          case 5:
            {
              print('口袋彩铃click');
              break;
            }
          case 6:
            {
              print('游戏专区click');
              break;
            }
          case 7:
            {
              print('设置click');
              break;
            }
          case 8:
            {
              print('夜间模式click');
              break;
            }
          case 9:
            {
              print('我的客服click');
              break;
            }
          case 10:
            {
              print('关于click');
              break;
            }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text), Text('>')],
      ),
    );
  }
}
