import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../module/Bloc.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

AdminBloc _bloc;
SignalBloc _signalBloc;
AnalyzeBloc _analyzeBloc;

class Admin extends StatelessWidget{
  const Admin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) 
      _bloc = AdminBloc()..verifyUser(context);
    TextEditingController _edusr = TextEditingController();
    TextEditingController _edpss = TextEditingController();
    return Scaffold(
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _bloc.userStream$,
          initialData: DataModel(status: Status.Error),
          builder: (context, snapshot){
            if (snapshot.hasData && snapshot.data.status == Status.Loaded && _bloc.currentUser != null)
              return AdminPage();
            return Container(
              width: screenWidth(context) * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Admin Control Panel', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 25),
                  Edit(hint: 'UserName', controller: _edusr, onSubmitted: (val){}),
                  SizedBox(height: 10),
                  Edit(hint: 'Password', password: true, controller: _edpss, onSubmitted: (val){}),
                  SizedBox(height: 25),
                  snapshot.data.status==Status.Loading 
                    ? CupertinoActivityIndicator()
                    : OButton(caption: 'Login', color: Colors.green, icon: FaIcon(FontAwesomeIcons.userLock), onPressed: ()=>_bloc.authenticate(context, _edusr.text, _edpss.text))
                ]
              ),
            );
          }
        )
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IntBloc _menu = IntBloc()..setValue(1);
    return Container(
      // padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: StreamBuilder<int>(
                stream: _menu.stream$,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Column(
                      children: [
                        SizedBox(height: 25),
                        CircleAvatar(backgroundImage: AssetImage('images/user2.jpg'), radius: 45,),
                        SizedBox(height: 10),
                        FlatButton(child: Text('edit profile', style: TextStyle(fontSize: 12, color: Colors.blueGrey)), onPressed: (){}),
                        SizedBox(height: 15),
                        Text('Dashboard', style: GoogleFonts.luckiestGuy(fontSize: 40, color: Colors.blueGrey)),
                        Expanded(flex: 1, child: Container()),
                        Menu(title: 'Signal', selected: snapshot.data==1, onTap: ()=>_menu.setValue(1), selectedColor: Colors.grey[200]),
                        Menu(title: 'Analyze', selected: snapshot.data==2, onTap: ()=>_menu.setValue(2), selectedColor: Colors.grey[200]),
                        Menu(title: 'Education', selected: snapshot.data==3, onTap: ()=>_menu.setValue(3), selectedColor: Colors.grey[200]),
                        Menu(title: 'Subscribe', selected: snapshot.data==4, onTap: ()=>_menu.setValue(4), selectedColor: Colors.grey[200]),
                        Expanded(flex: 3, child: Container()),
                      ],
                    );
                  return CupertinoActivityIndicator();
                }
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: StreamBuilder(
                stream: _menu.stream$,
                builder: (context, snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data == 1)
                      return AdminSignal();
                    else if (snapshot.data == 2)
                      return AdminAnalyze();
                  return Center(child: Text('Please choose Menu from left side'));
                },
              )
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSignal extends StatelessWidget {
  const AdminSignal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_signalBloc == null)
      _signalBloc = SignalBloc(context: context, api: 'Signal', token: '', body: {});
    return Column(
      children: [
        Row(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('newest'), value: 1),
                    DropdownMenuItem<int>(child: Text('oldest'), value: 2),
                    DropdownMenuItem<int>(child: Text('likes'), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('all'), value: 1),
                    DropdownMenuItem<int>(child: Text('1 Hour'), value: 2),
                    DropdownMenuItem<int>(child: Text('4 Hour'), value: 3),
                    DropdownMenuItem<int>(child: Text('Daily'), value: 4),
                    DropdownMenuItem<int>(child: Text('Weekly'), value: 5),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('All Currencies'), value: 1),
                    DropdownMenuItem<int>(child: Text('USDCHF'), value: 2),
                    DropdownMenuItem<int>(child: Text('AUDJPY'), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('All Traders'), value: 1),
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: AssetImage('images/user1.jpg')),SizedBox(width: 10),Text('Arman Zahmatkesh')]), value: 2),
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: AssetImage('images/user2.jpg')),SizedBox(width: 10),Text('Hassan Moghadam')]), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            )
          ],
        ),
        GridRow(
          [
            Field(Text('Active')),
            Field(SizedBox(width: 45)),
            Field('namad'),
            Field('title'),
            Field('sender'),
            Field('send date'),
            Field('likes'),
            Field('vorod'),
          ],
          header: true,
        ),
        Expanded(
          child: StreamListWidget(
            stream: _signalBloc.rowsStream$,
            itembuilder: (rw)=>GridRow(
              [
                Field(Checkbox(value: true, onChanged: (val){})),
                Field(SizedBox(width: 10)),
                Field(CircleAvatar(backgroundImage: AssetImage('images/user${(rw as TBSignal).senderid}.jpg'),)),
                Field(SizedBox(width: 25)),
                Field('${(rw as TBSignal).namad}'),
                Field('${(rw as TBSignal).title}'),
                Field('${(rw as TBSignal).sender}'),
                Field('${(rw as TBSignal).senddate}'),
                Field('${(rw as TBSignal).likes}'),
                Field('${(rw as TBSignal).vorod}'),
              ],
              color: _signalBloc.rowsValue$.rows.indexOf(rw).isOdd ? rowColor(context) : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class AdminAnalyze extends StatelessWidget {
  const AdminAnalyze({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_analyzeBloc == null)
      _analyzeBloc = AnalyzeBloc(context: context, api: 'Signal', token: '', body: {});
    return Column(
      children: [
        Row(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('newest'), value: 1),
                    DropdownMenuItem<int>(child: Text('oldest'), value: 2),
                    DropdownMenuItem<int>(child: Text('likes'), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('all'), value: 1),
                    DropdownMenuItem<int>(child: Text('1 Hour'), value: 2),
                    DropdownMenuItem<int>(child: Text('4 Hour'), value: 3),
                    DropdownMenuItem<int>(child: Text('Daily'), value: 4),
                    DropdownMenuItem<int>(child: Text('Weekly'), value: 5),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('All Currencies'), value: 1),
                    DropdownMenuItem<int>(child: Text('USDCHF'), value: 2),
                    DropdownMenuItem<int>(child: Text('AUDJPY'), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: [
                    DropdownMenuItem<int>(child: Text('All Traders'), value: 1),
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: AssetImage('images/user1.jpg')),SizedBox(width: 10),Text('Arman Zahmatkesh')]), value: 2),
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: AssetImage('images/user2.jpg')),SizedBox(width: 10),Text('Hassan Moghadam')]), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 35),
        Expanded(
          child: StreamBuilder<DataModel>(
            stream: _analyzeBloc.rowsStream$,
            builder: (context, snap){
              if (snap.hasData && snap.data.status == Status.Loaded)
                return ListView(
                  children: [
                    ...snap.data.rows.map((e)=>Card(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        height: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(value: true, onChanged: (val){}),
                            Container(
                              width: 150,
                              child: Column(
                                children: [
                                  CircleAvatar(backgroundImage: AssetImage('images/user${(e as TBAnalyze).senderid}.jpg')),
                                  SizedBox(height: 5),
                                  Icon(e.status ==1 ? Icons.trending_up : Icons.trending_down, color: e.status ==1 ? Colors.green : Colors.deepOrange),
                                  SizedBox(height: 5),
                                  Expanded(child: Text('${(e as TBAnalyze).subject}', softWrap: true, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Image(image: NetworkImage((e as TBAnalyze).smallpic), width: 150),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text('${(e as TBAnalyze).note}', overflow: TextOverflow.ellipsis, maxLines: 10)
                            )
                          ],
                        ),
                      ),
                    )).toList()
                  ],
                );
              return Center(child: CupertinoActivityIndicator());
            }
          ),
        ),
      ],
    );
  }
}



