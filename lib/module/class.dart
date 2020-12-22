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
    String name;
    String family;
    String regdate;
    int type;
    String mobile;
    String email;
    String instagram;
    String telegram;
    String facebook;
    String whatsapp;
    String password;
    String pic;
    int active;
    String token;
 
    User({this.id,this.name,this.family,this.regdate,this.type,this.mobile,this.email,this.instagram,this.telegram,this.facebook,this.whatsapp,this.password,this.pic,this.active, this.token});
 
    User.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        family = json['family'],
        regdate = json['regdate'],
        type = json['type'],
        mobile = json['mobile'],
        email = json['email'],
        instagram = json['instagram'],
        telegram = json['telegram'],
        facebook = json['facebook'],
        whatsapp = json['whatsapp'],
        password = json['password'],
        pic = json['pic'],
        active = json['active'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['family'] = this.family;
        data['regdate'] = this.regdate;
        data['type'] = this.type;
        data['mobile'] = this.mobile;
        data['email'] = this.email;
        data['instagram'] = this.instagram;
        data['telegram'] = this.telegram;
        data['facebook'] = this.facebook;
        data['whatsapp'] = this.whatsapp;
        data['password'] = this.password;
        data['pic'] = this.pic;
        data['active'] = this.active;
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
    int bigpic;
    String note;
    String subject;
    bool premium;
    int kind;
      //1=1 hour, 2=4 hour, 3=daily, 4=weekly
    String sender;
    int status;
      //1=up, 2=down
    int namadid;
    String namad;
    String senddate;
    String expiredate;
    String token;
 
    TBAnalyze({this.id,this.smallpic,this.bigpic,this.note,this.subject,this.premium,this.kind,this.sender,this.status,this.namadid,this.namad,this.senddate,this.expiredate, this.token});
 
    TBAnalyze.fromJson(Map<String, dynamic> json):
        id = json['id'],
        smallpic = json['smallpic'],
        bigpic = json['bigpic'],
        note = json['note'],
        subject = json['subject'],
        premium = json['premium']==1,
        kind = json['kind'],
        sender = json['sender'],
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
    int id;
    int namadid;
    String namad;
    double vorod;
    double tp1;
    double tp2;
    double tp3;
    double sl;
    int senderid;
    String sender;
    String senddate;
    String expdate;
    String title;
    int kind;
      //1=1 hour, 2=4 hour, 3=daily, 4=weekly
    String note;
    bool premium;
    bool liked;
    int likes;
    double signalnumber;
    String udate;
    String unote;
    String closedate;
    String closenote;
    String token;
 
    TBSignal({this.id,this.namadid,this.namad,this.vorod,this.tp1,this.tp2,this.tp3,this.sl,this.senderid,this.sender,this.senddate,this.expdate,this.title,this.kind,this.note,this.premium = false,this.signalnumber,this.udate,this.unote,this.closedate,this.closenote, this.token, this.liked = false, this.likes = 0});
 
    TBSignal.fromJson(Map<String, dynamic> json):
        id = json['id'],
        namadid = json['namadid'],
        namad = json['namad'],
        vorod = json['vorod'],
        tp1 = json['tp1'],
        tp2 = json['tp2'],
        tp3 = json['tp3'],
        sl = json['sl'],
        senderid = json['senderid'],
        sender = json['sender'],
        senddate = json['senddate'],
        expdate = json['expdate'],
        title = json['title'],
        kind = json['kind'],
        note = json['note'],
        premium = json['premium'] == 1,
        signalnumber = json['signalnumber'],
        udate = json['udate'],
        unote = json['unote'],
        closedate = json['closedate'],
        likes = json['likes'],
        liked = json['liked'] == 1,
        closenote = json['closenote'];
 
    Map<String, dynamic> toJson(){
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['namadid'] = this.namadid;
        data['namad'] = this.namad;
        data['vorod'] = this.vorod;
        data['tp1'] = this.tp1;
        data['tp2'] = this.tp2;
        data['tp3'] = this.tp3;
        data['sl'] = this.sl;
        data['sender'] = this.sender;
        data['senddate'] = this.senddate;
        data['expdate'] = this.expdate;
        data['title'] = this.title;
        data['kind'] = this.kind;
        data['note'] = this.note;
        data['premium'] = this.premium ? 1 : 0;
        data['signalnumber'] = this.signalnumber;
        data['udate'] = this.udate;
        data['unote'] = this.unote;
        data['closedate'] = this.closedate;
        data['closenote'] = this.closenote;
        data['token'] = this.token;
        return data;
    }
}
