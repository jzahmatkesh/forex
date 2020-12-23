import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forex/module/functions.dart';

import '../module/Bloc.dart';
import '../module/Widgets.dart';
import 'Analyze.dart';
import 'Chart.dart';
import 'Learning.dart';
import 'Signal.dart';

IntBloc _menu = IntBloc()..setValue(3);

class Dashboard extends StatelessWidget{
  const Dashboard({Key key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      body: Container(
        // padding: EdgeInsets.all(8),
        child: StreamWidget(
          stream: _menu.stream$, 
          itemBuilder: (i) => Row(
            children: [
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Image(image: AssetImage('images/logo.png'), height: 125,),
                    SizedBox(height: 15),
                    Text('DONT TRADE !', style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 15),
                    Text('WITHOUT ADVICE', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    Text('EDUCATION', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    Text('MONEY MANAGMENT', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 35),
                    Menu(icon: Icon(CupertinoIcons.chart_pie), title: 'Chart', selected: i==1, onTap: ()=>_menu.setValue(1)),
                    Menu(icon: Icon(CupertinoIcons.waveform_path_ecg), title: 'Signal', selected: i==2, onTap: ()=>_menu.setValue(2)),
                    Menu(icon: Icon(CupertinoIcons.square_stack_3d_up), title: 'Analyze', selected: i==3, onTap: ()=>_menu.setValue(3)),
                    Menu(icon: Icon(FontAwesomeIcons.bookReader), title: 'Learning', selected: i==4, onTap: ()=>_menu.setValue(4)),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.lightBlue[900],
                      height: screenHeight(context) * 0.25,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.grey[100],
                        height: screenHeight(context) * 0.75,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        // width: screenWidth(context) * 0.75,
                        child: i == 1
                          ? Chart()
                          : i == 2
                            ? Signal()
                            : i == 3
                              ? Analyze()
                              : Learning()
                      ),
                    )
                  ],
                ) 
              )
            ],
          ),
        )
      ),
    );
  }
}