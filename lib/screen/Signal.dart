import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../module/Bloc.dart';
import '../module/Widgets.dart';
import '../module/class.dart';
import '../module/functions.dart';

SignalBloc _bloc;

class Signal extends StatelessWidget {
  const Signal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_bloc == null)
      _bloc = SignalBloc(context: context, api: 'Signal', token: '', body: {});
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: screenWidth(context) * 0.75 > 850 ? 850 : screenWidth(context) * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: screenHeight(context) * 0.95,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: [
                      Text('Signals', style: TextStyle(fontSize: 22),),
                      Spacer(),
                      StreamWidget(
                        stream: _bloc.sort.stream$, 
                        itemBuilder: (i)=>DropdownButton<int>(
                          value: i,
                          items: [
                            DropdownMenuItem<int>(child: Text('Recently'), value: 1, onTap: ()=>_bloc.sort.setValue(1)),
                            DropdownMenuItem<int>(child: Text('Likes'), value: 2, onTap: ()=>_bloc.sort.setValue(2)),
                            DropdownMenuItem<int>(child: Text('Follower'), value: 3, onTap: ()=>_bloc.sort.setValue(3)),
                          ],
                          onChanged: (int i){},
                          underline: Container(),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        )
                      ),
                      SizedBox(width: 25)
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 35),
                    child: StreamListWidget(
                      stream: _bloc.rowsStream$, 
                      itembuilder: (rw)=>SignalItem(bloc: _bloc, rw: rw, ontap: ()=>showFormAsDialog(context: context, form: SignalInfo(sig: rw)))
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
                    color: Colors.grey[100],
                  ),
                  child: Text('Filters', style: TextStyle(fontSize: 22),),
                ),
                StreamWidget(
                  stream: _bloc.kind.stream$, 
                  itemBuilder: (i)=>Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<int>(value: 1, groupValue: i, onChanged: (val){_bloc.kind.setValue(1); _bloc.loadData();}),
                          Text('1 Hour')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(value: 2, groupValue: i, onChanged: (val){_bloc.kind.setValue(2); _bloc.loadData();}),
                          Text('4 Hour')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(value: 3, groupValue: i, onChanged: (val){_bloc.kind.setValue(3); _bloc.loadData();}),
                          Text('daily')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(value: 4, groupValue: i, onChanged: (val){_bloc.kind.setValue(4); _bloc.loadData();}),
                          Text('weekly')
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[400])),
                    color: Colors.grey[100],
                  ),

                ),
                StreamWidget(
                  stream: _bloc.premium.stream$, 
                  itemBuilder: (i)=>Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<int>(value: 5, groupValue: i, onChanged: (val){_bloc.premium.setValue(5); _bloc.loadData();}),
                          Text('free')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(value: 6, groupValue: i, onChanged: (val){_bloc.premium.setValue(6); _bloc.loadData();}),
                          Text('premuim')
                        ],
                      ),
                    ]
                  )
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[400])),
                    color: Colors.grey[100],
                  ),

                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignalInfo extends StatelessWidget {
  const SignalInfo({Key key, @required this.sig}) : super(key: key);

  final TBSignal sig;

  @override
  Widget build(BuildContext context) {
    IntBloc _comment = IntBloc()..setValue(0);
    TextEditingController _edcom = TextEditingController();
    return StreamBuilder(
      stream: _bloc.rowsStream$,
      builder: (context, snapshot) {
        return Container(
          width: screenWidth(context) * 0.85 > 650 ? 650 : screenWidth(context) * 0.85,
          // padding: EdgeInsets.all(8),
          // color: Colors.grey[200],
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: AssetImage('images/user${sig.senderid}.jpg'), radius: 25,),
                    SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.yellowAccent
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text('${sig.namad}')
                    ),
                    SizedBox(width: 15),
                    Text('${sig.title}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text('${sig.senddate}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('start at ${sig.vorod}'),
                    Text('sale: ${sig.sl}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('pointt1: ${sig.tp1}'),
                    Text('pointt2: ${sig.tp2}'),
                    Text('pointt2: ${sig.tp3}'),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IButton(icon: Icon(sig.liked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp, size: 20, color: sig.liked ? Colors.red :  null), hint: 'Like', onPressed: ()=>_bloc.likeSignal(sig.id)),
                    SizedBox(width: 5),
                    Container(child: Text('${sig.likes}', style: TextStyle(color: Colors.grey)), margin: EdgeInsets.only(top: 10),),
                    SizedBox(width: 75),
                    IButton(icon: Icon(FontAwesomeIcons.commentAlt, size: 20, color: Colors.grey), hint: 'comment', onPressed: (){_comment.setValue(_comment.value==0 ? 1 : 0); _bloc.loadComment(this.sig.id);})
                  ],
                ),
              ),
              StreamWidget(
                stream: _comment.stream$, 
                itemBuilder: (i)=> i==1 ? Container(
                  height: screenHeight(context) * 0.5,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Colors.grey[100],
                          child: Row(
                            children: [
                              SizedBox(width: 25),
                              Expanded(
                                child: StreamListWidget(
                                  stream: _bloc.comments.rowsStream$, 
                                  itembuilder: (rw)=>Comment(senderid: (rw as TBComment).senderid, sender: '${(rw as TBComment).sender}', msg: '${(rw as TBComment).msg}', date: '${(rw as TBComment).date}')
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(color: Colors.grey[200], height: 1),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Expanded(child: Edit(hint: 'comment ...', controller: _edcom, onSubmitted: (val){_bloc.addComment(val); _edcom.clear();})),
                          SizedBox(width: 5),
                          FlatButton(child: Text('POST', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue[900])), onPressed: (){_bloc.addComment(_edcom.text); _edcom.clear();})
                        ],
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ) : Container()
              ),
            ],
          ),
        );
      }
    );
  }
}