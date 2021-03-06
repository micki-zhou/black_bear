/*
 * @Author: micki 
 * @Date: 2022-03-01 17:36:30 
 * @Last Modified by: micki
 * @Last Modified time: 2022-03-01 17:38:15
 * @Desc: 登录页面
 */
import 'dart:math';

import 'package:black_bear/config/my_colors.dart';
import 'package:black_bear/model/particle_model.dart';
import 'package:black_bear/model/particle_painter.dart';
import 'package:black_bear/ui/login/register.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations/rendering.dart';

import '../home/home.dart';

class LoginPage extends StatefulWidget {
  final int numberOfParticles = 25;

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  String accountText = "";
  String passwordText = "";
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  Animation animation;

  final Random random = Random();

  final List<ParticleModel> particles = [];

  // 获取缓存账号信息
  void getInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String account = sharedPreferences.getString("account");
    String password = sharedPreferences.getString("password");
    // print("account: " + account);
    // print("password: " + password);
    if (account != null) accountText = account;
    if (password != null) passwordText = password;
    if (accountText != null && passwordText != null) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutBack);
    animationController.forward();

    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
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
      //   title: Text('Sign in'),
      //   backgroundColor: MyColors.theme,
      // ),
      backgroundColor: MyColors.theme,
      body: Center(
          child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Rendering(
              startTime: Duration(seconds: 30),
              onTick: _simulateParticles,
              builder: (context, time) {
                return CustomPaint(
                  painter: ParticlePainter(particles, time),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _accountTextField(),
                  _passwordTextField(),
                  _loginBtn(),
                  _registerBtn()
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }

  // 账号输入框
  Widget _accountTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ScaleTransition(
          alignment: Alignment.centerLeft,
          scale: curvedAnimation,
          child: TextField(
            onChanged: (value) {
              accountText = value;
            },
            controller: TextEditingController(text: accountText),
            decoration: InputDecoration(
              // labelText: 'please enter account',
              hintText: "请输入账号",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.number,
          ),
        ));
  }

  // 密码输入框
  Widget _passwordTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ScaleTransition(
          alignment: Alignment.centerRight,
          scale: curvedAnimation,
          child: TextField(
            controller: TextEditingController(text: passwordText),
            onChanged: (value) {
              passwordText = value;
            },
            decoration: InputDecoration(
                // labelText: 'please enter password',
                hintText: "请输入密码",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.lock)),
            obscureText: true,
            keyboardType: TextInputType.text,
          ),
        ));
  }

  // 注册按钮
  Widget _registerBtn() {
    return Container(
      width: 500,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: Text('注册'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(MyColors.white)),
            onPressed: () {
              // 跳转注册界面
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RegisterPage();
              }));
            },
          )
        ],
      ),
    );
  }

  // 登录按钮
  Widget _loginBtn() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Builder(builder: (BuildContext context) {
          return TextButton(
            child: Text('登录'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(MyColors.white),
                foregroundColor: MaterialStateProperty.all(MyColors.text)),
            onPressed: () {
              void showsnackBar(String msg) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: MyColors.tip,
                  duration: Duration(milliseconds: 1500),
                  content: Text(msg),
                ));
              }

              if (accountText.isEmpty) {
                showsnackBar("账号不能为空");
                return;
              }
              if (passwordText.isEmpty) {
                showsnackBar("密码不能为空");
                return;
              }
              if (accountText.isNotEmpty && passwordText.isNotEmpty) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return HomePage();
                }), (route) => false);
              } else {
                showsnackBar("账号或密码错误");
              }
            },
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          );
        }));
  }
}
