import 'package:flutter/material.dart';
import 'package:forex/module/functions.dart';

enum AppTheme {
 Light, Dark
}
enum Status{
  Loading, Loaded, Error
}
enum Msg{
  Warning, Error, Success, Info
}

class DataModel{
  Status status;
  List<dynamic> rows;
  String msg;

  DataModel({@required this.status, this.rows, this.msg});
}

class User{
  int id;
  String family;
  String mobile;
  String email;
  int accountnumber;
  int paccountnumber;
  String lastlogin;
  bool usermng;
  bool analysis;  
  bool subscription;
  String regdate;
  bool ticketmng;
  String instagram;
  String telegram;
  String whatsapp;
  bool active;
  String password;
  int follower;
  int likes;
  int analysisCount;
  int signalCount;
  String token;

  User({this.id,this.family,this.regdate,this.mobile,this.email,this.instagram,this.telegram,this.whatsapp,this.password,this.active, this.paccountnumber, this.accountnumber, this.lastlogin, this.analysis, this.subscription, this.ticketmng, this.usermng, this.token, this.follower, this.analysisCount, this.likes, this.signalCount});

  User.fromJson(Map<String, dynamic> json):
      id = json['id'],
      family = json['family'],
      mobile = json['mobile'],
      email = json['email'],
      accountnumber = json['accountnumber'],
      paccountnumber = json['paccountnumber'],
      lastlogin = json['lastlogin'],
      usermng = json['usrmng'] == 1,
      analysis = json['analysis'] == 1,
      subscription = json['subscription'] == 1,
      regdate = json['regdate'],
      ticketmng = json['ticketmng'] == 1,
      instagram = json['instagram'],
      telegram = json['telegram'],
      whatsapp = json['whatsapp'],
      password = json['password'],
      follower = json['follower'],
      likes = json['likes'],
      analysisCount = json['analysiscount'],
      signalCount = json['signalcount'],
      active = json['active'] == 1,
      token = json['token'];

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['family'] = this.family;
      data['mobile'] = this.mobile;
      data['email'] = this.email;
      data['accountnumber'] = this.accountnumber;
      data['paccountnumber'] = this.paccountnumber;
      data['usermng'] = this.usermng ? 1 : 0;
      data['analysis'] = this.analysis ? 1 : 0;
      data['subscription'] = this.subscription ? 1 : 0;
      data['regdate'] = this.regdate;
      data['ticketmng'] = this.ticketmng ? 1 : 0;
      data['instagram'] = this.instagram;
      data['telegram'] = this.telegram;
      data['whatsapp'] = this.whatsapp;
      data['password'] = this.password;
      data['follower'] = follower;
      data['active'] = this.active ? 1 : 0;
      data['token'] = this.token;
      return data;
  }

  String toString(){
    return "id=${this.id}&family=${this.family}&mobile=${this.mobile}&email=${this.email}&telegram=${this.telegram}&instagram=${this.instagram}&whatsapp${this.whatsapp}&accountnumber=${this.accountnumber}&paccountnumber=${this.paccountnumber}&usermng=${(this.usermng ?? false) ? 1 : 0}&analysis=${(this.analysis ?? false) ? 1 : 0}&subscription=${(this.subscription ?? false) ? 1 : 0}&ticketmng=${(this.ticketmng ?? false) ? 1 : 0}&usrpass=${this.password.isEmpty ? '' : generateMd5(this.password)}";
  }
}

class ExcelRow{
  bool check;
  List<dynamic> cells;
  String error;

  ExcelRow({@required this.check, @required this.cells, this.error});
}

class TBAnalyze{
  int id;
  String smallpic;
  String bigpic;
  String note;
  String subject;
  bool premium;
  int kind;
    //1=1 hour, 2=4 hour, 3=daily, 4=weekly
  int senderid;
  String sender;
  int status;
    //1=up, 2=down
  bool liked;
  int likes;
  String symbol;
  String senddate;
  String expiredate;
  String token;

  TBAnalyze({this.id,this.smallpic,this.bigpic,this.note,this.subject,this.premium,this.kind,this.senderid,this.sender,this.status,this.symbol,this.senddate,this.expiredate, this.liked=false, this.likes=0, this.token});

  TBAnalyze.fromJson(Map<String, dynamic> json):
      id = json['id'],
      smallpic = json['smallpic'],
      bigpic = json['bigpic'],
      note = json['note'],
      subject = json['subject'],
      premium = json['premium']==1,
      kind = json['kind'],
      senderid = json['senderid'],
      sender = json['sender'],
      liked = json['liked'] == 1,
      likes = json['likes'],
      status = json['status'],
      symbol = json['symbol'],
      senddate = json['senddate'],
      expiredate = json['expiredate'];

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['smallpic'] = this.smallpic;
      data['bigpic'] = this.bigpic;
      data['note'] = this.note;
      data['subject'] = this.subject;
      data['premium'] = this.premium ? 1 : 0;
      data['kind'] = this.kind;
      data['senderid'] = this.senderid;
      data['sender'] = this.sender;
      data['status'] = this.status;
      data['symbol'] = this.symbol;
      data['senddate'] = this.senddate;
      data['expiredate'] = this.expiredate;
      data['token'] = this.token;
      return data;
  }

  String toString(){
    return "id=${this.id}&title=${this.subject}&symbol=${this.symbol}&kind=${this.kind}&status=${this.status}&premium=${this.premium}&expire=${this.expiredate}&note=${this.note}";
  }
}

class TBSignal{
    String accountname;
    bool premium;
    int accountnumber;
    int userid;
    String sender;
    int operationtype;
    int ticket;
    String opentime;
    int type;
    double size;
    String symbol;
    double price;
    double stoploss;
    double takeprofit;
    double closeprice;
    String closetime;
    double profit;
    int likes;
    bool liked;
    String token;
 
    TBSignal({this.userid,this.accountname,this.premium,this.accountnumber=0,this.sender,this.operationtype,this.ticket=0,this.opentime,this.type,this.size=0,this.symbol,this.price=0,this.stoploss=0,this.takeprofit=0,this.closeprice=0,this.closetime,this.profit=0,this.likes=0,this.liked=false, this.token});
 
    TBSignal.fromJson(Map<String, dynamic> json):
        accountname = json['accountname'],
        premium = json['premium'] == 1,
        accountnumber = json['accountnumber'],
        userid = json['userid'],
        sender = json['sender'],
        operationtype = json['operationtype'],
        ticket = json['ticket'],
        opentime = json['opentime'],
        type = json['type'],
        size = json['size'] * 1.0,
        symbol = json['symbol'],
        price = json['price'] * 1.0,
        stoploss = json['stoploss'] * 1.0,
        takeprofit = json['takeprofit'] * 1.0,
        closeprice = json['closeprice'] * 1.0,
        closetime = json['closetime'],
        profit = json['profit'] * 1.0,
        likes = json['likes'],
        liked = json['liked'] == 1;
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['accountname'] = this.accountname;
        data['premium'] = this.premium ? 1 : 0;
        data['accountnumber'] = this.accountnumber;
        data['sender'] = this.sender;
        data['operationtype'] = this.operationtype;
        data['ticket'] = this.ticket;
        data['opentime'] = this.opentime; 
        data['type'] = this.type;
        data['size'] = this.size;
        data['symbol'] = this.symbol;
        data['price'] = this.price;
        data['stoploss'] = this.stoploss;
        data['takeprofit'] = this.takeprofit;
        data['closeprice'] = this.closeprice;
        data['closetime'] = this.closetime;
        data['profit'] = this.profit;
        data['likes'] = this.likes;
        data['liked'] = this.liked ? 1: 0;
        data['token'] = this.token;
        return data;
    }

    String toString(){
      return "premium=${(this.premium ?? false) ? 1: 0}&accountnumber=${this.accountnumber}&operationtype=${this.operationtype}&ticket=${this.ticket}&opentime=${this.opentime}&type=${this.type}&size=${this.size}&symbol=${this.symbol}&price=${this.price}&stoploss=${this.stoploss}&takeprofit=${this.takeprofit}&closeprice=${this.closeprice}&closetime=${this.closetime}&profit=${this.profit}";
    }
}

class TBComment{
  int senderid;
  String sender;
  String msg;
  String date;
  String token;

  TBComment({this.senderid,this.sender,this.msg,this.date, this.token});

  TBComment.fromJson(Map<String, dynamic> json):
      senderid = json['senderid'],
      sender = json['sender'],
      msg = json['msg'],
      date = json['date'];

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['senderid'] = this.senderid;
      data['sender'] = this.sender;
      data['msg'] = this.msg;
      data['date'] = this.date;
      data['token'] = this.token;
      return data;
  }
}

class TBSubscribe{
    int id;
    bool active;
    String title;
    String note;
    double price;
    double price2;
    String token;
 
    TBSubscribe({this.id,this.active,this.title,this.note,this.price,this.price2, this.token});
 
    TBSubscribe.fromJson(Map<String, dynamic> json):
        id = json['id'],
        active = json['active'] == 1,
        title = json['title'],
        note = json['note'],
        price = json['price'],
        price2 = json['price2'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['active'] = this.active ? 1 : 0;
        data['title'] = this.title;
        data['note'] = this.note;
        data['price'] = this.price;
        data['price2'] = this.price2;
        data['token'] = this.token;
        return data;
    }
}

