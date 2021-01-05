import 'dart:html';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

import '../module/Bloc.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

AdminBloc _bloc;
SignalBloc _signalBloc;
AnalyzeBloc _analyzeBloc;
UsersBloc _usersBloc;
SubscribeBloc _subscribeBloc;
SymbolBloc _symbolBloc;
IntBloc _img;
IntBloc _menu;

class Admin extends StatelessWidget{
  const Admin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) 
      _bloc = AdminBloc()..verifyUser(context);
    if (!_bloc.isLogedIn)
      _bloc.verifyUser(context);      
    if (_symbolBloc == null)
      _symbolBloc = SymbolBloc()..loadData();
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
    if (_menu == null)
      _menu = IntBloc()..setValue(1);
    if (_img == null)
      _img = IntBloc()..setValue(1);
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Column(
                children: [
                  SizedBox(height: 25),
                  StreamWidget(
                    stream: _img.stream$,
                    itemBuilder: (i)=> FlatButton(
                      onPressed: ()=>prcUploadImg(context: context, token: _bloc.currentUser.token, id: _bloc.currentUser.id, tag: 'UserImage', ondone: (){_img.setValue(Random().nextInt(48812));}),
                      child: CircleAvatar(backgroundImage: NetworkImage('http://www.topchart.org/upload/UserImage${_bloc.currentUser.id}.jpg?id=${Random().nextInt(48812)}'), radius: 45,)
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('${_bloc.currentUser.family}', style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey)),
                  SizedBox(height: 5),
                  Text('Followers    ${_bloc.currentUser.follower}', style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey)),
                  SizedBox(height: 10),
                  FlatButton(child: Text('edit profile', style: TextStyle(fontSize: 12, color: Colors.blueGrey)), onPressed: (){}),
                  SizedBox(height: 15),
                  Text('Dashboard', style: GoogleFonts.luckiestGuy(fontSize: 40, color: Colors.blueGrey)),
                  Spacer(),
                  StreamBuilder<int>(
                    stream: _menu.stream$,
                    builder: (context, snapshot)=>Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Menu(title: 'Signal', selected: snapshot.data==1, onTap: ()=>_menu.setValue(1), selectedColor: Colors.grey[200]),
                        Menu(title: 'Analyze', selected: snapshot.data==2, onTap: ()=>_menu.setValue(2), selectedColor: Colors.grey[200]),
                        Menu(title: 'Education', selected: snapshot.data==3, onTap: ()=>_menu.setValue(3), selectedColor: Colors.grey[200]),
                        Menu(title: 'Subscribe', selected: snapshot.data==4, onTap: ()=>_menu.setValue(4), selectedColor: Colors.grey[200]),
                        Menu(title: 'User Managment', selected: snapshot.data==5, onTap: ()=>_menu.setValue(5), selectedColor: Colors.grey[200]),
                      ],
                    ),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: StreamBuilder(
                stream: _menu.stream$,
                initialData: 1,
                builder: (context, snapshot){
                  if (snapshot.hasData)
                    if (snapshot.data == 1)
                      return AdminSignal();
                    else if (snapshot.data == 2)
                      return AdminAnalyze();
                    else if (snapshot.data == 4)
                      return AdminSubscribe();
                    else if (snapshot.data == 5)
                      return UserManagment();
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
      _signalBloc = SignalBloc(context: context, api: 'Signal', token: _bloc.currentUser.token, body: {});
    return Column(
      children: [
        Row(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: StreamWidget(
                  stream: _signalBloc.sort.stream$,
                  itemBuilder: (i) {
                    return DropdownButton<int>(
                      value: i,
                      items: [
                        DropdownMenuItem<int>(child: Text('newest'), value: 1),
                        DropdownMenuItem<int>(child: Text('oldest'), value: 2),
                        DropdownMenuItem<int>(child: Text('likes'), value: 3),
                      ],
                      onChanged: (val)=>_signalBloc.sort.setValue(val),
                      underline: Container(),
                    );
                  }
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: StreamWidget(
                  stream: _signalBloc.kind.stream$,
                  itemBuilder: (i) {
                    return DropdownButton<int>(
                      value: i,
                      items: [
                        DropdownMenuItem<int>(child: Text('all'), value: 1),
                        DropdownMenuItem<int>(child: Text('1 Hour'), value: 2),
                        DropdownMenuItem<int>(child: Text('4 Hour'), value: 3),
                        DropdownMenuItem<int>(child: Text('Daily'), value: 4),
                        DropdownMenuItem<int>(child: Text('Weekly'), value: 5),
                      ],
                      onChanged: (val)=>_signalBloc.kind.setValue(val),
                      underline: Container(),
                    );
                  }
                )
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: StreamBuilder<DataModel>(
                  stream: _symbolBloc.rowsStream$,
                  builder: (context, snap){
                    if (snap.hasData)
                      if (snap.data.status == Status.Loaded)
                        return StreamWidget(
                          stream: _signalBloc.symbol.stream$,
                          itemBuilder: (i)=>DropdownButton<String>(
                            value: i ?? 'All',
                            items: [
                              DropdownMenuItem<String>(child: Text('All'), value: 'All',),
                              ...snap.data.rows.map((e)=>DropdownMenuItem<String>(child: Text('$e'), value: e)).toList()
                            ],
                            onChanged: (val)=>_signalBloc.symbol.setValue(val),
                            underline: Container(),
                          )
                        );
                      else if (snap.data.status == Status.Error)
                        return Text('${snap.data.msg}');
                    return CupertinoActivityIndicator();
                  }
                )
              ),
            ),
            Spacer(),
            IButton(type: Btn.Reload, onPressed: ()=>_signalBloc.loadData()),
            SizedBox(width: 5),
            IButton(type: Btn.Add, onPressed: ()=>showFormAsDialog(context: context, form: EditSignal(signal: TBSignal(ticket: 0),))),
          ],
        ),
        GridRow(
          [
            Field(Text('Active')),
            Field(SizedBox(width: 45)),
            Field('symbol'),
            // Field('title'),
            Field('sender'),
            Field('open date'),
            Field('likes'),
            Field('price'),
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
                Field(CircleAvatar(backgroundImage: NetworkImage('http://www.topchart.org/upload/UserImage${(rw as TBSignal).userid}.jpg?id=${Random().nextInt(48812)}'), radius: 17)),
                Field(SizedBox(width: 25)),
                Field('${(rw as TBSignal).symbol}'),
                Field('${(rw as TBSignal).sender}'),
                Field('${(rw as TBSignal).opentime}'),
                Field('${(rw as TBSignal).likes}'),
                Field('${(rw as TBSignal).price}'),
                Field(IButton(type: Btn.Edit, onPressed: ()=>showFormAsDialog(context: context, form: EditSignal(signal: rw)))),
                Field(IButton(type: Btn.Del, onPressed: ()=>_signalBloc.delSignal(context, (rw as TBSignal).ticket, (rw as TBSignal).symbol)))
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
      _analyzeBloc = AnalyzeBloc(context: context, api: 'Signal', token: _bloc.currentUser.token, body: {});
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
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: NetworkImage('http://www.topchart.org/upload/UserImage1.jpg')),SizedBox(width: 10),Text('Arman Zahmatkesh')]), value: 2),
                    DropdownMenuItem<int>(child: Row(mainAxisSize: MainAxisSize.min,children: [CircleAvatar(backgroundImage: NetworkImage('http://www.topchart.org/upload/UserImage2.jpg')),SizedBox(width: 10),Text('Hassan Moghadam')]), value: 3),
                  ],
                  onChanged: (val){},
                  underline: Container(),
                ),
              ),
            ),
            Spacer(),
            IButton(type: Btn.Reload, onPressed: ()=>_analyzeBloc.loadData()),
            IButton(type: Btn.Add, hint: 'new analyze', onPressed: ()=>showFormAsDialog(context: context, form: NewAnalyze(rec: TBAnalyze(id: 0)))),
          ],
        ),
        SizedBox(height: 35),
        Expanded(
          child: StreamBuilder<DataModel>(
            stream: _analyzeBloc.rowsStream$,
            builder: (context, snap){
              if (snap.hasData && snap.data.status == Status.Error)
                return Center(child: Text(snap.data.msg));
              if (snap.hasData && snap.data.status == Status.Loaded)
                return ListView(
                  children: [
                    ...snap.data.rows.map((e)=>Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey)
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        height: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Checkbox(value: true, onChanged: (val){}),
                                IButton(type: Btn.Edit, onPressed: ()=>showFormAsDialog(context: context, form: NewAnalyze(rec: e))),
                                IButton(type: Btn.Del, onPressed: ()=>_analyzeBloc.delAnalyze(context, (e as TBAnalyze).id, (e as TBAnalyze).symbol)),
                              ],
                            ),
                            Container(
                              width: 150,
                              child: Column(
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage('http://www.topchart.org/upload/UserImage${(e as TBAnalyze).senderid}.jpg?id=${Random().nextInt(48812)}')),
                                  SizedBox(height: 5),
                                  Icon(e.status ==1 ? Icons.trending_up : Icons.trending_down, color: e.status ==1 ? Colors.green : Colors.deepOrange),
                                  SizedBox(height: 5),
                                  Expanded(child: Text('${(e as TBAnalyze).subject}', softWrap: true, overflow: TextOverflow.ellipsis)),
                                  SizedBox(height: 5),
                                  Expanded(child: Text('${(e as TBAnalyze).symbol}', softWrap: true, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: OctoImage(
                                image: CachedNetworkImageProvider('http://topchart.org/upload/Analyze_Small${e.id}.jpg?id=${Random().nextInt(48812)}'),
                                placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                                errorBuilder: OctoError.icon(color: Colors.red),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Image(image: NetworkImage(''), width: 150),
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

class NewAnalyze extends StatelessWidget {
  const NewAnalyze({Key key, @required this.rec}) : super(key: key);

  final TBAnalyze rec;

  @override
  Widget build(BuildContext context) {
    TextEditingController _edsubject = TextEditingController(text: rec.subject);
    TextEditingController _edexpire = TextEditingController(text: rec.expiredate);
    TextEditingController _ednote = TextEditingController(text: rec.note);
    FocusNode _fsubject = FocusNode();
    FocusNode _fexpire = FocusNode();
    FocusNode _fnote = FocusNode();
    StringBloc _symbol = StringBloc()..setValue(rec.symbol  ?? 'EUR/USD');
    IntBloc _kind = IntBloc()..setValue((rec.kind == 0 ? 1 : rec.kind) ?? 1);
    IntBloc _status = IntBloc()..setValue((rec.status == 0 ? 1 : rec.status) ?? 1);
    IntBloc _premium = IntBloc()..setValue((rec.premium ?? false) ? 1 : 0);
    IntBloc _wizard = IntBloc()..setValue(0);
    _img = IntBloc()..setValue(1);
    return Container(
      width: screenWidth(context) * 0.65,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Header(
            title: 'analyze info', 
            rightBtn: StreamWidget(
              stream: _wizard.stream$,
              itemBuilder: (i) {
                return i>0 || rec.id>0 ? IButton(type: Btn.Other, icon: FaIcon(i<=1 ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft), onPressed: ()=>_wizard.setValue(i<=1 ? 2 : 1)) : Container();
              }
            ),
            leftBtn: IButton(
              type: Btn.Save, 
              onPressed: () async{
                int _id = await _analyzeBloc.saveAnalyze(context, TBAnalyze(id: rec.id, subject: _edsubject.text, kind: _kind.value, status: _status.value, premium: _premium.value==1, symbol: _symbol.value, expiredate: _edexpire.text, note: _ednote.text));
                if (_id > 0){
                  rec.id = _id;
                  _wizard.setValue(2);
                }
              }
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamWidget(
              stream: _wizard.stream$,
              itemBuilder: (i) {
                return i <= 1 ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Edit(hint: 'subject', controller: _edsubject, focus: _fsubject, autofocus: true, onSubmitted: (val)=>focusChange(context, _fexpire))),
                        SizedBox(width: 5),
                        Expanded(child: Edit(hint: 'expire date', controller: _edexpire, focus: _fexpire, onSubmitted: (val)=>focusChange(context, _fnote))),
                      ]
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Expanded(child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: StreamWidget(
                              stream: _symbol.stream$,
                              itemBuilder: (str)=>DropdownButton<String>(
                                value: '$str',
                                items: [
                                  DropdownMenuItem(value: 'EUR/USD', child: Text('EUR/USD')),
                                  DropdownMenuItem(value: 'GBP/USD', child: Text('GBP/USD')),
                                  DropdownMenuItem(value: 'USD/JPY', child: Text('USD/JPY')),
                                  DropdownMenuItem(value: 'USD/CHF', child: Text('USD/CHF')),
                                  DropdownMenuItem(value: 'USD/CAD', child: Text('USD/CAD')),
                                  DropdownMenuItem(value: 'AUD/USD', child: Text('AUD/USD')),
                                  DropdownMenuItem(value: 'NZD/USD', child: Text('NZD/USD')),
                                ],
                                onChanged: (val)=>_symbol.setValue(val),
                                underline: Container(),
                              )
                            ),
                          ),
                        )),
                        SizedBox(width: 5),
                        Expanded(child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: StreamWidget(
                              stream: _kind.stream$,
                              itemBuilder: (val)=>DropdownButton<int>(
                                value: val,
                                items: [
                                  DropdownMenuItem(value: 1, child: Text('1 HOUR')),
                                  DropdownMenuItem(value: 2, child: Text('4 HOUR')),
                                  DropdownMenuItem(value: 3, child: Text('Daily')),
                                  DropdownMenuItem(value: 4, child: Text('Weekly')),
                                ],
                                onChanged: (val)=>_kind.setValue(val),
                                underline: Container(),
                              )
                            ),
                          ),
                        )),
                        SizedBox(width: 5),
                        Expanded(child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: StreamWidget(
                              stream: _status.stream$,
                              itemBuilder: (val)=>DropdownButton<int>(
                                value: val,
                                items: [
                                  DropdownMenuItem(value: 1, child: Text('UP')),
                                  DropdownMenuItem(value: 2, child: Text('Down')),
                                ],
                                onChanged: (val)=>_status.setValue(val),
                                underline: Container(),
                              )
                            ),
                          ),
                        )),
                        SizedBox(width: 5),
                        Expanded(child: Row(
                          children: [
                            StreamWidget(
                              stream: _premium.stream$,
                              itemBuilder: (i)=>Checkbox(value: i==1, onChanged: (val)=>_premium.setValue(val ? 1 : 0))
                            ),
                            SizedBox(width: 5),
                            Text('Premium'),
                          ],
                        )),
                      ]
                    ),
                    Edit(hint: 'note', maxlines: 10, controller: _ednote, focus: _fnote),
                  ],
                ) : StreamWidget(
                  stream: _img.stream$,
                  itemBuilder: (i)=>Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.45),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5))
                                ),
                                padding: EdgeInsets.all(12),
                                child: IButton(type: Btn.Other, icon: FaIcon(FontAwesomeIcons.fileUpload), hint: 'Upload', onPressed: ()=>prcUploadImg(context: context, token: _bloc.currentUser.token, id: rec.id, tag: "AnalyzeSmall", ondone: (){int _flg = Random().nextInt(48812); _img.setValue(_flg);}))
                              ),
                              SizedBox(height: 10),
                              Image(
                                image: NetworkImage('http://topchart.org/upload/Analyze_Small${rec.id}.jpg?id=$i'),
                                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace)=>Text('😢'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.45),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5))
                                ),
                                padding: EdgeInsets.all(12),
                                child: IButton(type: Btn.Other, icon: FaIcon(FontAwesomeIcons.fileUpload), hint: 'Upload', onPressed: ()=>prcUploadImg(context: context, token: _bloc.currentUser.token, id: rec.id, tag: "AnalyzeBig", ondone: (){int _flg = Random().nextInt(48812); _img.setValue(_flg);}))
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Image(
                                  image: NetworkImage('http://topchart.org/upload/Analyze_Big${rec.id}.jpg?id=$i'),
                                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace)=>Text('😢'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                );
              }
            ),
          ),
        ]
      ),
    );
  }
}

class AdminSubscribe extends StatelessWidget {
  const AdminSubscribe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_subscribeBloc == null)
      _subscribeBloc = SubscribeBloc(context: context, api: 'Subscribe', token: _bloc.currentUser.token, body: {});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IButton(type: Btn.Reload, onPressed: ()=>_subscribeBloc.loadData()),
            IButton(type: Btn.Add, onPressed: ()=>showFormAsDialog(context: context, form: EditSubscribtion(id: 0, title: '', note: '', price1: 0, price2: 0))),
          ],
        ),
        GridRow(
          [
            Field(Text('Active')),
            Field(SizedBox(width: 15,)),
            Field('title'),
            Field('note', flex: 3),
            Field('price'),
            Field('price3'),
          ],
          header: true,
        ),
        Expanded(
          child: StreamListWidget(
            stream: _subscribeBloc.rowsStream$,
            itembuilder: (rw)=>GridRow(
              [
                Field(Checkbox(value: rw.active, onChanged: (val)=>_subscribeBloc.setActiveSubs(context, rw.id, val ? 1 : 0))),
                Field(SizedBox(width: 25,)),
                Field('${rw.title}'),
                Field('${rw.note}', flex: 3,),
                Field('${rw.price}'),
                Field('${rw.price2}'),
                Field(IButton(icon: FaIcon(FontAwesomeIcons.edit, size: 14), onPressed: ()=>showFormAsDialog(context: context, form: EditSubscribtion(id: rw.id, title: rw.title, price1: rw.price, price2: rw.price2, note: rw.note))))
              ]
            )
          )
        )
      ],
    );
  }
}

class EditSubscribtion extends StatelessWidget {
  const EditSubscribtion({Key key, @required this.id, @required this.title, @required this.note, @required this.price1, @required this.price2}) : super(key: key);

  final int id;
  final String title;
  final double price1;
  final double price2;
  final String note;

  @override
  Widget build(BuildContext context) {
    TextEditingController _edtitle = TextEditingController(text: this.title);
    TextEditingController _edprice1 = TextEditingController(text: this.price1.toString());
    TextEditingController _edprice2 = TextEditingController(text: this.price2.toString());
    TextEditingController _ednote = TextEditingController(text: this.note);
    FocusNode _ftitle = FocusNode();
    FocusNode _fprice1 = FocusNode();
    FocusNode _fprice2 = FocusNode();
    FocusNode _fnote = FocusNode();
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Edit(hint: 'title', controller: _edtitle, focus: _ftitle, onSubmitted: (val)=>focusChange(context, _fprice1), autofocus: true), flex: 2),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'price1', controller: _edprice1, focus: _fprice1, onSubmitted: (val)=>focusChange(context, _fprice2))),
              SizedBox(width: 5),
              Expanded(child: Edit(hint: 'price2', controller: _edprice2, focus: _fprice2, onSubmitted: (val)=>focusChange(context, _fnote))),
            ],
          ),
          SizedBox(height: 15),
          Edit(hint: 'Note', controller: _ednote, focus: _fnote, maxlines: 10),
          SizedBox(height: 25),
          Row(
            children: [
              OButton(type: Btn.Exit, color: Colors.deepOrange, onPressed: ()=>Navigator.of(context).pop()),
              OButton(type: Btn.Save, color: Colors.green, onPressed: ()=>_subscribeBloc.saveData(context, this.id, _edtitle.text, double.tryParse(_edprice1.text), double.tryParse(_edprice2.text), _ednote.text)),
            ],
          )
        ],
      )
    );
  }
}

class EditSignal extends StatelessWidget {
  const EditSignal({Key key, @required this.signal}) : super(key: key);

  final TBSignal signal;

  @override
  Widget build(BuildContext context) {
    StringBloc _symbol = StringBloc()..setValue(signal.symbol ?? 'choose symbol ...');
    TextEditingController _edticket = TextEditingController(text: signal.ticket.toString());
    TextEditingController _edoperationtype = TextEditingController(text: signal.operationtype);
    TextEditingController _edopentime = TextEditingController(text: signal.opentime);
    TextEditingController _edtype = TextEditingController(text: signal.type);
    TextEditingController _edsize = TextEditingController(text: signal.size.toString());
    TextEditingController _edprice = TextEditingController(text: signal.price.toString());
    TextEditingController _edstoploss = TextEditingController(text: signal.stoploss.toString());
    TextEditingController _edtakeprofit = TextEditingController(text: signal.takeprofit.toString());
    TextEditingController _edcloseprice = TextEditingController(text: signal.closeprice.toString());
    TextEditingController _edclosetime = TextEditingController(text: signal.closetime);
    TextEditingController _edprofit = TextEditingController(text: signal.profit.toString());
    FocusNode _fticket = FocusNode();
    FocusNode _foperationtype = FocusNode();
    FocusNode _fopentime = FocusNode();
    FocusNode _ftype = FocusNode();
    FocusNode _fsize = FocusNode();
    FocusNode _fprice = FocusNode();
    FocusNode _fstoploss = FocusNode();
    FocusNode _ftakeprofit = FocusNode();
    FocusNode _fcloseprice = FocusNode();
    FocusNode _fclosetime = FocusNode();
    FocusNode _fprofit = FocusNode();
    return Container(
      width: screenWidth(context) * 0.75,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: StreamBuilder<DataModel>(
                      stream: _symbolBloc.rowsStream$,
                      builder: (context, snap){
                        if (snap.hasData)
                          if (snap.data.status == Status.Loaded)
                            return StreamWidget(
                              stream: _symbol.stream$,
                              itemBuilder: (i)=>DropdownButton<String>(
                                value: i ?? 'choose symbol ...',
                                items: [
                                  DropdownMenuItem<String>(child: Text('choose symbol ...'), value: 'choose symbol ...',),
                                  ...snap.data.rows.map((e)=>DropdownMenuItem<String>(child: Text('$e'), value: e)).toList()
                                ],
                                onChanged: (val)=>_symbol.setValue(val),
                                underline: Container(),
                              )
                            );
                          else if (snap.data.status == Status.Error)
                            return Text('${snap.data.msg}');
                        return CupertinoActivityIndicator();
                      }
                  ),
                )
              ),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'ticket', controller: _edticket, focus: _fticket, onSubmitted: (val)=>focusChange(context, _foperationtype), autofocus: true)),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'operationtype', controller: _edoperationtype, focus: _foperationtype, onSubmitted: (val)=>focusChange(context, _fopentime))),
            ]
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Edit(hint: 'opentime', controller: _edopentime, focus: _fopentime, onSubmitted: (val)=>focusChange(context, _ftype))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'type', controller: _edtype, focus: _ftype, onSubmitted: (val)=>focusChange(context, _fsize))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'size', controller: _edsize, focus: _fsize, onSubmitted: (val)=>focusChange(context, _fprice))),
            ]
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Edit(hint: 'price', controller: _edprice, focus: _fprice, onSubmitted: (val)=>focusChange(context, _fstoploss))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'stoploss', controller: _edstoploss, focus: _fstoploss, onSubmitted: (val)=>focusChange(context, _ftakeprofit))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'takeprofit', controller: _edtakeprofit, focus: _ftakeprofit, onSubmitted: (val)=>focusChange(context, _fcloseprice))),
            ]
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Edit(hint: 'closeprice', controller: _edcloseprice, focus: _fcloseprice, onSubmitted: (val)=>focusChange(context, _fclosetime))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'closetime', controller: _edclosetime, focus: _fclosetime, onSubmitted: (val)=>focusChange(context, _fprofit))),
              SizedBox(width: 10),
              Expanded(child: Edit(hint: 'profit', controller: _edprofit, focus: _fprofit, onSubmitted: (val){})),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              OButton(type: Btn.Exit, onPressed: ()=>Navigator.of(context).pop(), color: Colors.deepOrange),
              OButton(type: Btn.Save, onPressed: ()=>_signalBloc.saveData(
                context, 
                TBSignal(
                  accountnumber: signal.accountnumber,
                  ticket: int.tryParse(_edticket.text),
                  symbol: _symbol.value,
                  operationtype: _edoperationtype.text,
                  opentime: _edopentime.text,
                  type: _edtype.text,
                  size: double.tryParse(_edsize.text),
                  price: double.tryParse(_edprice.text),
                  stoploss: double.tryParse(_edstoploss.text),
                  takeprofit: double.tryParse(_edtakeprofit.text),
                  closeprice: double.tryParse(_edcloseprice.text),
                  closetime: _edclosetime.text,
                  profit: double.tryParse(_edprofit.text),
                )), 
                color: Colors.green)
            ]
          )
        ],
      )
    );
  }
}

class UserManagment extends StatelessWidget {
  const UserManagment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_usersBloc == null)
      _usersBloc = UsersBloc(context: context, api: 'Users', token: _bloc.currentUser.token, body: {})..loadData();
    return Column(
      children: [
        GridRow(
          [
            Field('Active'),
            Field('Family', flex: 2),
            Field('Last Login'),
            Field('Admin'),
            Field('Signal'),
            Field('Analyze'),
            Field('Subscription'),
            Field('Ticket'),
            Field(SizedBox(width: 15)),
            Field(IButton(type: Btn.Add, onPressed: ()=>showFormAsDialog(context: context, form: EditUser(user: User(id: 0)))))
          ],
          header: true,
        ),
        Expanded(
          child: StreamListWidget(
            stream: _usersBloc.rowsStream$,
            itembuilder: (data)=>GridRow(
              [
                Field(ICheckbox(value: (data as User).active, hint: 'avctive/deactive user', onChanged: (val){})),
                Field(
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image(
                      image: NetworkImage('http://www.topchart.org/upload/UserImage${(data as User).id}.jpg?id=${Random().nextInt(48812)}'),
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace)=>Container(width: 45, height: 45, child: Center(child: Text('😢'))),
                      fit: BoxFit.cover,
                      width: 45,
                      height: 45,
                    )
                  )
                ),
                Field(SizedBox(width: 15)),
                Field('${(data as User).family}', flex: 2),
                Field('${(data as User).lastlogin}'),
                Field(Expanded(child: ICheckbox(hint: 'user managment', value: (data as User).usermng, onChanged: (val){}))),
                Field(Expanded(child: ICheckbox(hint: 'signal accountnumber', value: (data as User).accountnumber>0, onChanged: null))),
                Field(Expanded(child: ICheckbox(hint: 'analysis managment', value: (data as User).analysis, onChanged: (val){}))),
                Field(Expanded(child: ICheckbox(hint: 'subscription managment', value: (data as User).subscription, onChanged: (val){}))),
                Field(Expanded(child: ICheckbox(hint: 'ticket managment', value: (data as User).ticketmng, onChanged: (val){}))),
                Field(IButton(type: Btn.Edit, onPressed: ()=>showFormAsDialog(context: context, form: EditUser(user: (data as User))))),
                Field(IButton(type: Btn.Del, onPressed: (){})),
              ]
            ),
          ),
        )
      ],
    );
  }
}

class EditUser extends StatelessWidget {
  const EditUser({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.85,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(18),
            color: Colors.grey[200],
            width: 275,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FlatButton(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image(
                        image: NetworkImage('http://www.topchart.org/upload/UserImage${user.id}.jpg?id=${Random().nextInt(48812)}'),
                        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace)=>Container(width: 125, height: 125, child: Center(child: FaIcon(FontAwesomeIcons.smile, size: 105, color: Colors.grey))),
                        fit: BoxFit.cover,
                        width: 125,
                        height: 125,
                      )
                    ),
                    onPressed: (){}
                  )
                ),
                SizedBox(height: 50),
                Text('permissions:'),
                SizedBox(height: 5),
                FilterItem(selected: user.usermng ?? false, title: 'User Managment', onSelected: (val){}),
                FilterItem(selected: user.analysis ?? false, title: 'Analyze Managment', onSelected: (val){}),
                FilterItem(selected: user.subscription ?? false, title: 'Subscription Managment', onSelected: (val){}),
                FilterItem(selected: user.ticketmng ?? false, title: 'Ticket Managment', onSelected: (val){}),
                SizedBox(height: 15),
              ]
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Edit(hint: 'family', onSubmitted: (val){})),
                      SizedBox(width: 5),
                      Expanded(child: Edit(hint: 'Signal AccountNumber', onSubmitted: (val){})),
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Edit(hint: 'mobile', onSubmitted: (val){})),
                      SizedBox(width: 5),
                      Expanded(child: Edit(hint: 'email', onSubmitted: (val){})),
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Edit(hint: 'instagram', onSubmitted: (val){})),
                      SizedBox(width: 5),
                      Expanded(child: Edit(hint: 'whatsApp', onSubmitted: (val){})),
                      SizedBox(width: 5),
                      Expanded(child: Edit(hint: 'telegram', onSubmitted: (val){})),
                    ]
                  ),
                  Spacer(),
                  Row(
                    children: [
                      OButton(caption: 'return', type: Btn.Exit, onPressed: ()=>Navigator.of(context).pop(), color: Colors.deepOrange.withOpacity(0.75),),
                      OButton(caption: 'save', type: Btn.Save, onPressed: (){}, color: Colors.green.withOpacity(0.75)),
                    ]
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}











