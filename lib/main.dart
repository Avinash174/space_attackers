import 'dart:async';

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

  double  shipX =0.0,shipY=0.0;
  double maxHeight=0.0;
  double intialPosition=0.0;
  double velocity=2.9;
  double time =0.0;
  double gravity=-4.9;
  bool isGameRunning =false;

  void startGame(){
    isGameRunning=true;
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      time = time+ 0.02;
      setState(() {
        maxHeight = velocity * time+ gravity *time * time;
        shipY = intialPosition -maxHeight;
      });
    });
  }

  void onJump(){
   setState(() {
     time =0;
     intialPosition=shipY;
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: isGameRunning?onJump:startGame,
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
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/ss.png")
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
