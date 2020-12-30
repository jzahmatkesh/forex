import 'package:flutter/material.dart';

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
  bool usermng;
  bool analysis;  
  bool subscription;
  String regdate;
  bool ticketmng;
  String instagram;
  String telegram;
  String whatsapp;
  String password;
  bool active;
  int follower;
  String token;

  User({this.id,this.family,this.regdate,this.mobile,this.email,this.instagram,this.telegram,this.whatsapp,this.password,this.active, this.accountnumber, this.analysis, this.subscription, this.ticketmng, this.usermng, this.token, this.follower});

  User.fromJson(Map<String, dynamic> json):
      id = json['id'],
      family = json['family'],
      mobile = json['mobile'],
      email = json['email'],
      accountnumber = json['accountnumber'],
      usermng = json['usermng'] == 1,
      analysis = json['analysis'] == 1,
      subscription = json['subscription'] == 1,
      regdate = json['regdate'],
      ticketmng = json['ticketmng'] == 1,
      instagram = json['instagram'],
      telegram = json['telegram'],
      whatsapp = json['whatsapp'],
      password = json['password'],
      follower = json['follower'],
      active = json['active'] == 1,
      token = json['token'];

  Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['family'] = this.family;
      data['mobile'] = this.mobile;
      data['email'] = this.email;
      data['accountnumber'] = this.accountnumber;
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
  int namadid;
  String namad;
  String senddate;
  String expiredate;
  String token;

  TBAnalyze({this.id,this.smallpic,this.bigpic,this.note,this.subject,this.premium,this.kind,this.senderid,this.sender,this.status,this.namadid,this.namad,this.senddate,this.expiredate, this.liked=false, this.likes=0, this.token});

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
      namadid = json['namadid'],
      namad = json['namad'],
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
      data['namadid'] = this.namadid;
      data['namad'] = this.namad;
      data['senddate'] = this.senddate;
      data['expiredate'] = this.expiredate;
      data['token'] = this.token;
      return data;
  }
}

class TBSignal{
    String accountname;
    bool premium;
    int accountnumber;
    String sender;
    String operationtype;
    int ticket;
    String opentime;
    String type;
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
 
    TBSignal({this.accountname,this.premium,this.accountnumber,this.sender,this.operationtype,this.ticket,this.opentime,this.type,this.size,this.symbol,this.price,this.stoploss,this.takeprofit,this.closeprice,this.closetime,this.profit,this.likes,this.liked, this.token});
 
    TBSignal.fromJson(Map<String, dynamic> json):
        accountname = json['accountname'],
        premium = json['premium'] == 1,
        accountnumber = json['accountnumber'],
        sender = json['sender'],
        operationtype = json['operationtype'],
        ticket = json['ticket'],
        opentime = json['opentime'],
        type = json['type'],
        size = json['size'],
        symbol = json['symbol'],
        price = json['price'],
        stoploss = json['stoploss'],
        takeprofit = json['takeprofit'],
        closeprice = json['closeprice'],
        closetime = json['closetime'],
        profit = json['profit'],
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