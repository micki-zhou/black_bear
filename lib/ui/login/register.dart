import 'package:black_bear/config/my_colors.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  String accountText = "";
  String passwordText = "";
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  Animation<Offset> animation;
  Animation<double> slide;

  String tipStr = "Hi , \n您想叫什么名字 ?";
  String hintStr = "请输入账号";

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutBack);
    animation =
        Tween(begin: Offset(0, 0), end: Offset(0, -3)).animate(curvedAnimation);
    slide = Tween(begin: 200.0, end: 50.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign up'),
      //   backgroundColor: Color(0xff383838),
      // ),
      backgroundColor: MyColors.theme,
      body: Column(
        children: [
          _backLogin(context),
          Container(
            padding: EdgeInsets.fromLTRB(30, slide.value, 30, 0),
            child: Column(
              children: <Widget>[_textTip(), _textField(), _next()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTip() {
    return Container(
      width: 500,
      child: Text(
        tipStr,
        style: TextStyle(color: Colors.white, fontSize: 25),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: TextField(
        onChanged: (value) {
          accountText = value;
        },
        decoration: InputDecoration(
          hintText: hintStr,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _next() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Builder(builder: (BuildContext context) {
          return FlatButton(
              onPressed: () {
                if (accountText.isNotEmpty) {
                  saveAccountValue();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RegisterNext();
                  }));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: MyColors.tip,
                    duration: Duration(milliseconds: 1500),
                    content: Text('账号不能为空'),
                  ));
                }
              },
              color: MyColors.white,
              shape: CircleBorder(),
              child: Icon(
                Icons.navigate_next,
                color: MyColors.theme,
                size: 50,
              ));
        })
      ],
    );
  }

  // 保存用户名
  void saveAccountValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("account", accountText);
  }
}

class RegisterNext extends StatefulWidget {
  @override
  _RegisterNextState createState() => _RegisterNextState();
}

class _RegisterNextState extends State<RegisterNext>
    with SingleTickerProviderStateMixin {
  String passwordText = "";
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  Animation<Offset> animation;
  Animation<double> slide;
  String tipStr = "Hi , \n您想设置什么密码 ?";
  String hintStr = "Please enter password";

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutBack);
    animation =
        Tween(begin: Offset(0, 0), end: Offset(0, -3)).animate(curvedAnimation);
    slide = Tween(begin: 200.0, end: 50.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign up'),
      //   backgroundColor: Color(0xff383838),
      // ),
      backgroundColor: MyColors.theme,
      body: Column(
        children: [
          _backLogin(context),
          Container(
            padding: EdgeInsets.fromLTRB(30, slide.value, 30, 0),
            child: Column(
              children: <Widget>[_textTip(), _textField(), _next()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTip() {
    return Container(
      width: 500,
      child: Text(
        tipStr,
        style: TextStyle(color: Colors.white, fontSize: 25),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: TextField(
        onChanged: (value) {
          passwordText = value;
        },
        decoration: InputDecoration(
          hintText: hintStr,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _next() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Builder(builder: (BuildContext context) {
          return FlatButton(
              onPressed: () {
                if (passwordText.isNotEmpty) {
                  savePasswordValue();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return LoginPage();
                  // }));

                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }), (route) => false);

                  // Navigator.of(context).pushAndRemoveUntil(LoginPage(), (Route<dynamic> route) => false);

                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: MyColors.tip,
                    duration: Duration(milliseconds: 1500),
                    content: Text('密码不能为空'),
                  ));
                }
              },
              color: MyColors.white,
              shape: CircleBorder(),
              child: Icon(
                Icons.navigate_next,
                color: MyColors.theme,
                size: 50,
              ));
        })
      ],
    );
  }

  // 保存密码
  void savePasswordValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("password", passwordText);
  }
}

Widget _backLogin(context) {
  return Row(
    children: [
      ButtonTheme(
        minWidth: 50,
        child: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }), (route) => false);
            },
            child: Icon(
              Icons.navigate_before,
              size: 50,
              color: MyColors.white,
            )),
      ),
    ],
  );
}
