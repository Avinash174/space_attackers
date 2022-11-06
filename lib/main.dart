import 'dart:async';
import 'dart:math';
import 'package:space_attackers/collision_data.dart';

import 'astroid_model.dart';
import 'package:space_attackers/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double shipX = 0.0, shipY = 0.0;
  double maxHeight = 0.0;
  double intialPosition = 0.0;
  double velocity = 2.9;
  double time = 0.0;
  double gravity = -4.9;
  bool isGameRunning = false;
  List<GlobalKey> globakeys = [];
  GlobalKey shipGlobalKey = GlobalKey();
  int score=0;

  List<AstroidData> astroidData = [];
  List<AstroidData> setAstroidData() {
    List<AstroidData> data = [
      AstroidData(
        alignment: Alignment(3.9, 0.7),
        size: Size(70, 70),
      ),
      AstroidData(
        alignment: Alignment(1.8, -0.5),
        size: Size(100, 100),
      ),
      AstroidData(
        alignment: Alignment(3, -0.2),
        size: Size(40, 40),
      ),
      AstroidData(
        alignment: Alignment(2.3, 0.2),
        size: Size(60, 60),
      ),
    ];

    return data;
  }

  void startGame() {
    resetData();
    isGameRunning = true;
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      time = time + 0.02;
      setState(() {
        maxHeight = velocity * time + gravity * time * time;
        shipY = intialPosition - maxHeight;
        if (isShipCollided()) {
          timer.cancel();
          isGameRunning = false;
        }
      });
      moveAstroid();
    });
  }

  void onJump() {
    setState(() {
      time = 0;
      intialPosition = shipY;
    });
  }

  double generateRandomNumber() {
    Random rand = Random();
    double randomDouble = rand.nextDouble() * (-1.0 - 1.0) + 1.0;

    return randomDouble;
  }

  void moveAstroid() {
    Alignment astroid1 = astroidData[0].alignment;
    Alignment astroid2 = astroidData[1].alignment;
    Alignment astroid3 = astroidData[2].alignment;
    Alignment astroid4 = astroidData[3].alignment;

    if (astroid1.x > -1.4) {
      astroidData[0].alignment = Alignment(astroid1.x - 0.02, astroid1.y);
    } else {
      astroidData[0].alignment = Alignment(2, generateRandomNumber());
    }

    if (astroid2.x > -1.4) {
      astroidData[1].alignment = Alignment(astroid2.x - 0.02, astroid1.y);
    } else {
      astroidData[1].alignment = Alignment(1.5, generateRandomNumber());
    }

    if (astroid3.x > -1.4) {
      astroidData[2].alignment = Alignment(astroid3.x - 0.02, astroid1.y);
    } else {
      astroidData[2].alignment = Alignment(3, generateRandomNumber());
    }

    if (astroid4.x > -1.4) {
      astroidData[3].alignment = Alignment(astroid4.x - 0.02, astroid1.y);
    } else {
      astroidData[3].alignment = Alignment(2.2, generateRandomNumber());
    }
    if(astroid1.x <=0.021&& astroid1.x >=0.001){
      score++;
    }
    if(astroid2.x <=0.021&& astroid2.x >=0.001){
      score++;
    }
    if(astroid3.x <=0.021&& astroid3.x >=0.001){
      score++;
    }
    if(astroid4.x <=0.021&& astroid4.x >=0.001){
      score++;
    }

  }

  bool isShipCollided() {
    if (shipY > 1) {
      return true;
    } else if (shipY < -0.9) {
      return true;
    } else {
      return false;
    }
  }

  bool checkCollision() {
    bool isCollided = false;
    RenderBox shipRenderBox =
        shipGlobalKey.currentContext!.findRenderObject() as RenderBox;
    List<ColllisionData> collisionData = [];
    for (var element in globakeys) {
      RenderBox renderBox =
          element.currentContext!.findRenderObject() as RenderBox;
      collisionData.add(ColllisionData(
          sizeOfObject: renderBox.size,
          positionOfBox: renderBox.localToGlobal(Offset.zero)));
    }

    for (var element in collisionData) {
      final shipPosition = shipRenderBox.localToGlobal(Offset.zero);
      final astroidPostion = element.positionOfBox;
      final astroidSize = element.sizeOfObject;
      final shipSize = shipRenderBox.size;

      bool _isCollided =
          (shipPosition.dx < astroidPostion.dx + astroidSize.width &&
              shipPosition.dx + shipSize.width > astroidPostion.dx &&
              shipPosition.dy < astroidPostion.dy + astroidSize.height &&
              shipPosition.dy + shipSize.height > astroidPostion.dy);
      if(_isCollided){
        isCollided=true;
        break;
      }else if(checkCollision()){
        return true;
      }else{
        isCollided=false;
      }
    }
    return isCollided;
  }

  void initState() {
    super.initState();
    astroidData = setAstroidData();
    initialiseGlobalKeys();
  }

  void initialiseGlobalKeys() {
    for (int i = 0; i < 4; i++) {
      globakeys.add(GlobalKey());
    }
  }

  void resetData() {
    setState(() {
      astroidData = setAstroidData();
      shipX = 0.0;
      shipY = 0.0;
      maxHeight = 0.0;
      intialPosition = 0.0;
      time = 0.0;
      velocity = 2.9;
      gravity = -4.9;
      score=0;
      isGameRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: isGameRunning ? onJump : startGame,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/a.png",
                ),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(shipX, shipY),
                child: Container(
                  key: shipGlobalKey,
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/ss.png")),
                  ),
                ),
              ),
              Align(
                key: globakeys[0],
                alignment: astroidData[0].alignment,
                child: Container(
                  height: astroidData[0].size.height,
                  width: astroidData[0].size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(astroidData[0].path))),
                ),
              ),
              Align(
                key: globakeys[1],
                alignment: astroidData[1].alignment,
                child: Container(
                  height: astroidData[1].size.height,
                  width: astroidData[1].size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(astroidData[0].path))),
                ),
              ),
              Align(
                key: globakeys[2],
                alignment: astroidData[2].alignment,
                child: Container(
                  height: astroidData[2].size.height,
                  width: astroidData[2].size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(astroidData[0].path))),
                ),
              ),
              Align(
                key: globakeys[3],
                alignment: astroidData[3].alignment,
                child: Container(
                  height: astroidData[3].size.height,
                  width: astroidData[3].size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(astroidData[0].path))),
                ),
              ),
              Align(
                alignment: astroidData[0].alignment,
                child: Container(
                  height: astroidData[0].size.height,
                  width: astroidData[0].size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(astroidData[0].path))),
                ),
              ),
              isGameRunning
                  ? SizedBox()
                  : Align(
                      alignment: Alignment(0, -0.3),
                      child: Text(
                        "TAB TO PLAY",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              Align(
                alignment: Alignment(0, 0.95),
                child: Text(
                  "Score:$score",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
