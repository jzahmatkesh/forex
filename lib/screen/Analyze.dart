import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forex/module/Bloc.dart';
import 'package:forex/module/Widgets.dart';
import 'package:forex/module/class.dart';
import 'package:forex/module/functions.dart';
import 'package:google_fonts/google_fonts.dart';

AnalyzeBloc _bloc;
class Analyze extends StatelessWidget {
  const Analyze({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_bloc == null)
      _bloc = AnalyzeBloc(context: context, api: 'Signal', token: '', body: {});
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: screenWidth(context) * 0.75 > 1250 ? 1250 : screenWidth(context) * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: screenHeight(context) * 0.95,
      child: Row(
        children: [
          Expanded(
            flex: 5,
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
                      Text('Analyze', style: TextStyle(fontSize: 22),),
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
                  child: SingleChildScrollView(
                    child: StreamBuilder<DataModel>(
                      stream: _bloc.rowsStream$, 
                      builder: (BuildContext context, AsyncSnapshot<DataModel> snap){
                        if (snap.connectionState != ConnectionState.active || snap.data.status == Status.Loading)
                          return Center(child: CupertinoActivityIndicator());
                        return Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ...snap.data.rows.map((e) => AnalyzeItem(bloc: _bloc, rw: e, ontap: ()=>showFormAsDialog(context: context, form: AnalyzeInfo(rw: e))))
                          ],
                        );
                      }
                    ),
                  )
                )
              ]
            )
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

class AnalyzeInfo extends StatelessWidget {
  const AnalyzeInfo({Key key, @required this.rw}) : super(key: key);

  final TBAnalyze rw;

  @override
  Widget build(BuildContext context) {
    IntBloc _comment = IntBloc()..setValue(0);
    TextEditingController _edcom = TextEditingController();
    return StreamBuilder(
      stream: _bloc.rowsStream$,
      builder: (context, snapshot) {
        return Container(
          width: screenWidth(context) * 0.75,
          padding: EdgeInsets.all(24),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text('${rw.subject}', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('${rw.namad}', style: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(rw.status ==1 ? Icons.trending_up : Icons.trending_down, color: rw.status ==1 ? Colors.green : Colors.deepOrange),
                ],
              ),
              SizedBox(height: 15),
              Image(image: NetworkImage('${rw.bigpic}'), height: 400, fit: BoxFit.fill),
              SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage('images/user${rw.senderid}.jpg')),
                  SizedBox(width: 10),
                  Text('${rw.sender}'),
                  Spacer(),
                  Text('${rw.senddate}', style: GoogleFonts.rubik(fontSize: 10)),
                ],
              ),
              SizedBox(height: 15),
              Text('${rw.note}', style: GoogleFonts.rubik(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis, softWrap: true,),
              SizedBox(height: 25),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 12, left: 8, bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey[400])
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IButton(icon: Icon(rw.liked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp, color: rw.liked ? Colors.red : Colors.grey[600]), hint: 'Like', onPressed: ()=>_bloc.like(rw.id)),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: Text('${rw.likes}'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 25),
                  IButton(icon: Icon(FontAwesomeIcons.commentAlt), hint: 'Comment', onPressed: (){_comment.setValue(_comment.value==0 ? 1 : 0); _bloc.loadComment(this.rw.id);})
                ],
              ),
              SizedBox(height: 15),
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