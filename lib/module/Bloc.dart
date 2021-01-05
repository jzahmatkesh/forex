import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'class.dart';
import 'functions.dart';

class IntBloc{
  IntBloc();

  BehaviorSubject<int> _value = BehaviorSubject<int>();
  Stream<int> get stream$ => _value.stream;
  int get value => _value.value;

  setValue(int i)=>_value.add(i);
}

class StringBloc{
  StringBloc();

  BehaviorSubject<String> _value = BehaviorSubject<String>();
  Stream<String> get stream$ => _value.stream;
  String get value => _value.value;

  setValue(String i)=>_value.add(i);
}

class ExcelBloc{
  ExcelBloc({@required this.rows}){
    this.rows.forEach((element) {
      value.add(ExcelRow(check: false, cells: element));
    });
    _rows.add(value);
  }

  final List<List<dynamic>> rows;

  BehaviorSubject<List<ExcelRow>> _rows = BehaviorSubject<List<ExcelRow>>.seeded([]);
  Stream<List<ExcelRow>> get stream$ => _rows.stream;
  List<ExcelRow> get value => _rows.value;

  checkRow(int idx, bool val, {String error}){
    if (idx==0)
      value.forEach((element)=>element.check=val);
    else
      value[idx].check = val;
    value[idx].error = error;
    _rows.add(value);
  }

  Future<bool> exportToDB({BuildContext context, String api, Map<String, dynamic> data}) async{
    try{
      var _data = await putToServer(api: '$api', body: jsonEncode(data));
      if (_data['msg'] == "Success")
        return true;
      throw Exception(_data['msg']);
    }
    catch(e){
      analyzeError(context, '$e');
      return false;
    }
  }
}

abstract class Bloc{
  final BuildContext context;
  final String api;
  final String token;
  Map<String, dynamic> body;

  Bloc({@required this.context, @required this.api, @required this.token, this.body});

  BehaviorSubject<DataModel> rows = BehaviorSubject<DataModel>.seeded(DataModel(status: Status.Loading));
  Stream<DataModel> get rowsStream$ => rows.stream;
  DataModel get rowsValue$ => rows.value;

  reload(){
    rows.add(rowsValue$);
  }

  // fetchData({bool waiting = false}) async{
  //   try{
  //     Future.delayed(Duration.zero, () => showWaiting(context));
  //     try{
  //       rows.add(DataModel(status: Status.Loading));
  //       Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=$api&token=$token');
  //       if (_data['msg'] == "Success")
  //         rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<TBSignal>((data)=>TBSignal.fromJson(data)).toList()));
  //       }
  //     catch(e){
  //       rows.add(DataModel(status: Status.Error));
  //     }
  //   }
  //   finally{
  //     hideWaiting(context);
  //   }
  // }

  // fetchOtherData({String secapi, Map<String, dynamic> body, bool waiting = false}) async{
  //   try{
  //     Future.delayed(Duration.zero, () => showWaiting(context));
  //     try{
  //       _rows.add(DataModel(status: Status.Loading));
  //       if (body == null)
  //         body = {'token': token};
  //       else
  //         body.putIfAbsent('token', () => token);
  //       Map<String, dynamic> _data = await postToServer(api: '${secapi ?? api}', body: jsonEncode(body));
  //       if (_data['msg'] == "Success"){
  //         _rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<Mainclass>((data) => Mainclass.fromJson(json.decode(data))).toList()));
  //       }
  //       else
  //         throw Exception(_data['msg']);
  //     }
  //     catch(e){
  //       _rows.add(DataModel(status: Status.Error, msg: '$e'));
  //     }
  //   }
  //   finally{
  //     hideWaiting(context);
  //   }
  // }

  // Future<Mainclass> saveData({BuildContext context, Mainclass data, bool msg = false, String secapi, bool addtorows = false}) async{
  //   Map<String, dynamic> _data;
  //   try{
  //     showWaiting(context);
  //     try{
  //       if (data.token == null || data.token.isEmpty)
  //         data.token = this.token;
  //       _data = await putToServer(api: '${secapi ?? api}', body: jsonEncode(data.toJson()));
  //       if (_data['msg'] == "Success"){
  //         if (msg)
  //           myAlert(context: context, msgType: Msg.Success, title: 'ذخیره', message: 'ذخیره اطلاعات با موفقیت انجام گردید');
  //         if (addtorows){
  //           bool nval = true;
  //           rowsValue$.rows.forEach((element) {
  //             if (element.id == data.old){
  //               element.old  = data.id;
  //               element.name = data.name;
  //               element.edit = false;
  //               nval = false;
  //             }
  //           });
  //           data.old = data.id;
  //           if (nval)
  //             rowsValue$.rows.insert(0, data);
  //           _rows.add(rowsValue$);
  //         }
  //         return Mainclass.fromJson(_data['body']);
  //       }
  //       throw Exception(_data['msg']);
  //     }
  //     catch(e){
  //       analyzeError(context, '$e');
  //     }
  //   }
  //   finally{
  //     hideWaiting(context);
  //   }
  //   if (_data.containsKey('errorid'))
  //     return Mainclass(errorid: _data['errorid']);
  //   else
  //     return null;
  // }

  void delData({BuildContext context, String msg, Map<String, dynamic> body, String secapi, Function done}){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف $msg می باشید؟', yesclick: () async{
      try{
        body.putIfAbsent('token', () => this.token);
        Map<String, dynamic> _data = await delToServer(api: '${secapi ?? this.api}', body: jsonEncode(body));
        if (_data['msg'] == "Success"){
          Navigator.of(context).pop();
          if (done != null)
            done();
          myAlert(context: context, title: 'حذف', message: '$msg با موفقیت حذف گردید', msgType: Msg.Success);
        }
        else
          throw Exception(_data['msg']);
      }
      catch(e){
        Navigator.of(context).pop();
        analyzeError(context, '$e');
      }
    });
  }

  // updateRow(Mainclass art){
  //   if (rowsValue$.rows.where((element) => element.id==art.id).length > 0)
  //     rowsValue$.rows.forEach((element){ 
  //       if (element.id==art.id){
  //         element.edit = false;
  //         element.name = art.name;
  //         element.kolid = art.kolid;
  //         element.kolname = art.kolname;
  //         element.moinid = art.moinid;
  //         element.moinname = art.moinname;
  //         element.taf1 = art.taf1;
  //         element.taf1name = art.taf1name;
  //         element.taf2 = art.taf2;
  //         element.taf2name = art.taf2name;
  //         element.taf3 = art.taf3;
  //         element.taf3name = art.taf3name;
  //         element.taf4 = art.taf4;
  //         element.taf4name = art.taf4name;
  //         element.taf5 = art.taf5;
  //         element.taf5name = art.taf5name;
  //         element.taf6 = art.taf6;
  //         element.taf6name = art.taf6name;
  //         element.bed = art.bed;
  //         element.bes = art.bes;
  //         element.note = art.note;
  //       }
  //     });
  //   else
  //     rowsValue$.rows.insert(0, art);
  //   _rows.add(DataModel(status: Status.Loaded, rows: rowsValue$.rows));
  // }

  editMode(int id){
    rowsValue$.rows.forEach((element) {element.edit = element.id == id;});
    rows.add(DataModel(status: Status.Loaded, rows: rowsValue$.rows));
  }
  setActive(int id){
    rowsValue$.rows.forEach((element) {element.active = element.id == id || id==0;});
    reload();
  }
  findByName(String val){
    rowsValue$.rows.forEach((element) {
      element.inSearch = element.name.contains(val);
      element.selected = false;
    });
    rows.add(rowsValue$);
  }

  // selectRowbyClick(Mainclass rw){
  //   if (rowsValue$.rows != null){
  //     rowsValue$.rows.forEach((value) {
  //       value.selected = value == rw;
  //     });
  //     reload();
  //   }
  // }
  selectRow(int i){
    if (rowsValue$.rows != null){
      int idx = -1;
      rowsValue$.rows.forEach((value) {
        if (value.inSearch){
          idx++;
          value.selected = idx == i;
        }
        else
          value.selected = false;
      });
      reload();
    }
  }
  selectNextRow(){
    if (rowsValue$.rows != null){
      int i=-1, idx = -1;
      rowsValue$.rows.forEach((element) {
        if (element.inSearch){
          idx++;
          if (element.selected)
            i = idx;
        }
      });
      selectRow(i+1);
    }
    reload();
  }
  selectPriorRow(){
    if (rowsValue$.rows != null){
      int i=-1, idx = -1;
      rowsValue$.rows.forEach((element) {
        if (element.inSearch){
          idx++;
          if (element.selected)
            i = idx;
        }
      });
      selectRow(i-1);
    }
    reload();
  }

  emptyList(){
    rowsValue$.rows = [];
    reload();
  }
}

class PublicBloc extends Bloc{
  PublicBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body);
}

class SymbolBloc extends Bloc{
  loadData() async{
    try{
      rows.add(DataModel(status: Status.Loading));
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=symbol');
      if (_data['msg'] == "Success")
        rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<String>((data)=>'${data['symbol']}').toList()));
      else
        rows.add(DataModel(status: Status.Loaded, rows: []));
      }
    catch(e){
      rows.add(DataModel(status: Status.Error, msg: '$e'));
    }
  }  
}

class SignalBloc extends Bloc{
  SignalBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
    this.loadData();
  }

  PublicBloc comments;
  IntBloc sort = IntBloc()..setValue(1);
  IntBloc kind = IntBloc()..setValue(1);
  StringBloc symbol = StringBloc()..setValue('All');
  IntBloc premium = IntBloc()..setValue(5);

  
  loadData() async{
    try{
      rows.add(DataModel(status: Status.Loading));
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Signal&token=$token&sort=${sort.value}&');
      if (_data['msg'] == "Success")
        rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<TBSignal>((data)=>TBSignal.fromJson(data)).toList()));
      }
    catch(e){
      rows.add(DataModel(status: Status.Error));
    }
  }

  likeSignal(int id){
    rowsValue$.rows.forEach((element) {
      if ((element as TBSignal).accountnumber == id){
        print('${(element as TBSignal).liked}');
        (element as TBSignal).liked = !(element as TBSignal).liked;
      }
    });
    reload();
  }

  loadComment(int id) async{
    if (comments == null)
      comments = PublicBloc(context: this.context, api: null, token: null, body: null);
    comments.rows.add(DataModel(status: Status.Loading));
    Future.delayed(Duration(seconds: 1)).then((value){
      comments.rowsValue$.rows = [
        TBComment(senderid: 1, sender: 'hassan', date: '2020/12/11', msg: 'thats great bro'),
        TBComment(senderid: 2, sender: 'mojtaba', date: '2020/12/12', msg: 'can i copy your trade?'),
        TBComment(senderid: 3, sender: 'mamad', date: '2020/12/12', msg: 'i dont think what you said happen!'),
      ];
      comments.rows.add(DataModel(status: Status.Loaded, rows: comments.rowsValue$.rows));
    });
  }

  addComment(String msg){
    comments.rowsValue$.rows.add(TBComment(senderid: 1, sender: 'me', msg: msg, date: 'now'));
    comments.reload();
  }

  saveData(BuildContext context, TBSignal signal) async{
    if (signal.symbol ==  "choose symbol ...")
      myAlert(context: context, title: 'error', message: 'symbol not selected');
    else
    try{
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=SaveSignal&token=$token&${signal.toString()}');
      if (_data['msg'] == "Success"){
        loadData();
        Navigator.of(context).pop();
      }
      else
        myAlert(context: context, title: 'Error', message: '${_data['msg']}');
    }
    catch(e){
      myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page $e');
    }
  }

  delSignal(BuildContext context, int ticket, String symbol){
    confirmMessage(context, 'delete', 'are you sure to delete $symbol ?', yesclick: () async{
      try{
        Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=DelSignal&token=$token&ticket=$ticket');
        if (_data['msg'] == "Success"){
          loadData();
          Navigator.of(context).pop();
        }
        else
          myAlert(context: context, title: 'Error', message: '${_data['msg']}');
      }
      catch(e){
        myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page $e');
      }
    });
  }
}

class AnalyzeBloc extends Bloc{
  AnalyzeBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
    this.loadData();
  }

  PublicBloc comments;
  IntBloc kind = IntBloc()..setValue(1);
  IntBloc premium = IntBloc()..setValue(5);
  IntBloc sort = IntBloc()..setValue(1);

  loadData() async{
    try{
      rows.add(DataModel(status: Status.Loading));
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Analyze&etoken=$token');
      if (_data['msg'] == "Success")
        rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<TBAnalyze>((data)=>TBAnalyze.fromJson(data)).toList()));
      }
    catch(e){
      rows.add(DataModel(status: Status.Error, msg: '$e'));
    }
    // rows.add(DataModel(status: Status.Loading));
    // Future.delayed(Duration(seconds: 1)).then((value){
    //   rowsValue$.rows = [];
    //   if (premium.value == 5){
    //     if (kind.value == 1){
    //       rowsValue$.rows.add(TBAnalyze(id: 2, namadid: 2, namad: 'AUDJPY', kind: 1, premium: false, subject: 'BTC shorts to retest previous ATH', senderid: 2,sender: 'ForexThief', senddate: 'Dec 19', smallpic: 'https://s3.tradingview.com/u/U75x1Cne_mid.png', bigpic: 'https://a.c-dn.net/b/0ZRBLH/types-of-forex-analysis_body_GBPUSD-chart-in-forex-analysis-techniques.png', expiredate: '2020/12/25', note: 'Always against the crowd.. You called me crazy on previous analysis to long from 5k Now we here. Consolidation box... Need to retest 20k soon', status: 1));
    //       rowsValue$.rows.add(TBAnalyze(id: 4, namadid: 1, namad: 'USDCHF', kind: 1, premium: false, subject: 'wait to sell', senderid: 1, sender: 'Arman Zahmatkesh', senddate: '2020/12/21 - 16:45 PM', smallpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', bigpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', expiredate: '2020/12/25', note: 'BTC Update Since last few days we saw 7 continuous daily green candles on bitcoin & For strong growth ahead bitcoin needs some correction. Currently Market is entering in blow-off phase and As Bitcoin is forming similar pattern & fractals like last blow off phase so we are expecting a correction. No one knows exactly where it is going to top but based on our analysis there is possibility of \$23k - \$25k and then correction midterm to following targets \$18k - \$15k - \$12k. Expecting bearish move to start next week starting 21st of December.', status: 2));
    //     }
    //     if (kind.value == 2)
    //     rowsValue$.rows.add(TBAnalyze(id: 1, namadid: 1, namad: 'USDCHF', kind: 2, premium: false, subject: 'wait to sell', senderid: 1, sender: 'Arman Zahmatkesh', senddate: '2020/12/21 - 16:45 PM', smallpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', bigpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', expiredate: '2020/12/25', note: '', status: 1));
    //   }
    //   if (premium.value == 6)
    //     if (kind.value == 3)
    //       rowsValue$.rows.add(TBAnalyze(id: 3, namadid: 3, namad: 'EURGBP', kind: 3, premium: true, subject: 'wait to sell', senderid: 1,sender: 'Arman Zahmatkesh', senddate: '2020/12/21 - 12:45 AM', smallpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', bigpic: 'https://s3.tradingview.com/u/u0B9fKPV_mid.png', expiredate: '2020/12/25', note: '', status: 2));
    //   rows.add(DataModel(status: Status.Loaded, rows: rowsValue$.rows));
    // });
  }

  like(int id){
    rowsValue$.rows.forEach((element) {
      if ((element as TBAnalyze).id == id)
        (element as TBAnalyze).liked = !(element as TBAnalyze).liked;
    });
    reload();
  }

  loadComment(int id) async{
    if (comments == null)
      comments = PublicBloc(context: this.context, api: null, token: null, body: null);
    comments.rows.add(DataModel(status: Status.Loading));
    Future.delayed(Duration(seconds: 1)).then((value){
      comments.rowsValue$.rows = [
        TBComment(senderid: 1, sender: 'hassan', date: '2020/12/11', msg: 'thats great bro'),
        TBComment(senderid: 2, sender: 'mojtaba', date: '2020/12/12', msg: 'can i copy your trade?'),
        TBComment(senderid: 3, sender: 'mamad', date: '2020/12/12', msg: 'i dont think what you said happen!'),
      ];
      comments.rows.add(DataModel(status: Status.Loaded, rows: comments.rowsValue$.rows));
    });
  }

  addComment(String msg){
    comments.rowsValue$.rows.add(TBComment(senderid: 1, sender: 'me', msg: msg, date: 'now'));
    comments.reload();
  }

  Future<int> saveAnalyze(BuildContext context, TBAnalyze analyze) async{
    if (analyze.subject.isEmpty)
      myAlert(context: context, title: 'error', message: 'title cannot be empty');
    else if (analyze.note.isEmpty)
      myAlert(context: context, title: 'error', message: 'note cannot be empty');
    else
      try{
        Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=SaveAnalyze&token=$token&${analyze.toString()}');
        if (_data['msg'] == "Success"){
          int _id = _data["body"][0]['id'];
          bool ntf = true;
          rowsValue$.rows.forEach((e){
            if ((e as TBAnalyze).id == _id){
              e = analyze;
              ntf = false;
            }
          });
          if (ntf){
            analyze.id = _id;
            rowsValue$.rows.insert(0, analyze);
          }
          rows.add(rowsValue$);
          return _id;
        }
        else{
          myAlert(context: context, title: 'Error', message: '${_data['msg']}');
          return 0;
        }
      }
      catch(e){
        myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page $e');
        return 0;
      }
      return 0;
  }

  delAnalyze(BuildContext context, int id, String symbol){
    confirmMessage(context, 'delete', 'are you sure to delete $symbol analyze ?', yesclick: () async{
      try{
        Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=DelAnalyze&token=$token&id=$id');
        if (_data['msg'] == "Success"){
          loadData();
          Navigator.of(context).pop();
        }
        else
          myAlert(context: context, title: 'Error', message: '${_data['msg']}');
      }
      catch(e){
        myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page $e');
      }
    });
  }
}

class SubscribeBloc extends Bloc{
  SubscribeBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
    this.loadData();
  }

  PublicBloc comments;

  loadData() async{
    try{
      rows.add(DataModel(status: Status.Loading));
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Subscribe&etoken=$token');
      if (_data['msg'] == "Success")
        rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<TBSubscribe>((data)=>TBSubscribe.fromJson(data)).toList()));
      else
        rows.add(DataModel(status: Status.Error, msg: '${_data['msg']}'));
    }
    catch(e){
      print('error: $e');
      rows.add(DataModel(status: Status.Error, msg: '$e'));
    }
  }

  saveData(BuildContext context, int id, String title, double price1, double price2, String note) async{
    try{
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=SaveSubscribe&token=$token&id=$id&title=$title&price1=$price1&price2=$price2&note=$note');
      if (_data['msg'] == "Success"){
        loadData();
        Navigator.of(context).pop();
      }
      else
        myAlert(context: context, title: 'Error', message: '${_data['msg']}');
    }
    catch(e){
      myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page');
    }
  }

  setActiveSubs(BuildContext context, int id, int active) async{
    try{
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=ActiveSubscribe&token=$token&id=$id&active=$active');
      if (_data['msg'] == "Success"){
        rowsValue$.rows.forEach((element){
          if (element.id == id)
            element.active = active == 1;
        });
        rows.add(rowsValue$);
      }
      else
        myAlert(context: context, title: 'Error', message: '${_data['msg']}');
    }
    catch(e){
      myAlert(context: context, title: 'Error', message: 'error saving data on server. please try again after reload page $e');
    }
  }
}

class AdminBloc{
  BehaviorSubject<DataModel> _user = BehaviorSubject<DataModel>();
  Stream<DataModel> get userStream$ => _user.stream;
  User get currentUser => _user.value.rows !=null && _user.value.rows.length > 0 ? _user.value.rows[0] : null;
  bool get isLogedIn => _user.value != null && _user.value.rows != null &&_user.value.rows.length > 0;

  void authenticate(BuildContext context, String username, String pass) async{
    _user.add(DataModel(status: Status.Loading));
    
    try{
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Authenticate&email=$username&pass=${generateMd5(pass)}');
      if (_data['msg'] == "Success"){
        _user.add(DataModel(status: Status.Loaded, rows: _data['body'].map<User>((data) => User.fromJson(data)).toList()));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', currentUser.token);
      }
      else
        throw Exception(_data['msg']);
    }
    catch(e){
      myAlert(context: context, title: 'authenticate', message: '$e', msgType: Msg.Error);
      _user.add(DataModel(status: Status.Error, msg: '$e'));
    }
  }

  void verifyUser(BuildContext context) async{
      try{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = await prefs.getString('token') ?? '';
        if (token.trim().isNotEmpty)
          try{
            _user.add(DataModel(status: Status.Loading));
            Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Verify&token=$token');
            if (_data['msg'] == "Success"){
              _user.add(DataModel(status: Status.Loaded, rows: _data['body'].map<User>((data) => User.fromJson(data)).toList()));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', currentUser.token);
            }
            else
              throw Exception(_data['msg']);
          }
          catch(e){
            _user.add(DataModel(status: Status.Error));
          }
      }
      catch(e){
      }
  }
}

class UsersBloc extends Bloc{
  UsersBloc({@required BuildContext context,@required String api, @required String token, @required Map<String, dynamic> body}): super(context: context, api: api, token: token, body: body){
    this.loadData();
  }

  loadData() async{
    try{
      rows.add(DataModel(status: Status.Loading));
      Map<String, dynamic> _data = await postToServer(api: 'http://topchart.org/core.php?command=Users&token=$token');
      if (_data['msg'] == "Success")
        rows.add(DataModel(status: Status.Loaded, rows: _data['body'].map<User>((data)=>User.fromJson(data)).toList()));
      else
        rows.add(DataModel(status: Status.Error, msg: _data['msg']));
    }
    catch(e){
      rows.add(DataModel(status: Status.Error));
    }
  }
}
