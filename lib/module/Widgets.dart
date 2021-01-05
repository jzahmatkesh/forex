import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Bloc.dart';
import 'class.dart';
import 'functions.dart';

enum Btn{
  Add,Save,Exit,Reload,Del,Other,Edit,Loading
}
enum Sort{
  Asc,Desc
}

class Header extends StatelessWidget {
  const Header({Key key, @required this.title, this.rightBtn, this.leftBtn, this.color}) : super(key: key);

  final String title;
  final Widget rightBtn;
  final IButton leftBtn;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? appbarColor(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              rightBtn != null
                ? rightBtn
                : Container(width: 0),
              Expanded(child: Text('$title', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'roundor', fontSize: 20, fontWeight: FontWeight.bold),)),
              leftBtn != null
                ? leftBtn
                : Container(width: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class IButton extends StatelessWidget {
  const IButton({Key key, this.type, this.hint = "", this.icon, this.onPressed, this.size=20}) : super(key: key);

  
  final Btn type;
  final String hint;
  final Widget icon;
  final VoidCallback onPressed;
  final double size;


  @override
  Widget build(BuildContext context) {
    String _hnt = hint.isNotEmpty
      ? this.hint
      : type == Btn.Add
        ? 'New'
        : type == Btn.Del
        ? 'Delete'
        : type == Btn.Exit
          ? 'Back'
          : type == Btn.Reload
            ? 'Reload'
            : type == Btn.Save
              ? 'Save'
              : type == Btn.Edit
                ? 'Edit'
                : '';

    Widget _icon = icon != null
      ? this.icon//Icon(this.icon.icon, size: this.size, color: this.icon.color)
      : type == Btn.Add
        ? Icon(FontAwesomeIcons.solidPlusSquare, size: this.size)
        : type == Btn.Del
        ? Icon(FontAwesomeIcons.trash, size: this.size, color: Colors.grey[600])
        : type == Btn.Exit
          ? Icon(FontAwesomeIcons.signOutAlt, size: this.size)
          : type == Btn.Reload
            ? Icon(FontAwesomeIcons.syncAlt, size: this.size)
            : type == Btn.Save
              ? Icon(FontAwesomeIcons.solidSave, size: this.size, color: Colors.green)
              : type == Btn.Edit
                ? Icon(FontAwesomeIcons.solidEdit, size: this.size, color: Colors.grey[600])
                : Icon(FontAwesomeIcons.questionCircle, size: this.size);

    return _hnt.isEmpty
      ? IconButton(
          icon: _icon,
          onPressed: this.onPressed
        )
      : Tooltip(
        message: _hnt,
        child: IconButton(
          icon: _icon,
          onPressed: type==Btn.Exit && this.onPressed==null 
            ? ()=>Navigator.of(context).pop()
            : this.onPressed
        ),
      );
  }
}

class OButton extends StatelessWidget {
  const OButton({Key key, this.type, this.caption, this.icon, this.onPressed, this.color}) : super(key: key);

  
  final Btn type;
  final String caption;
  final Widget icon;
  final VoidCallback onPressed;
  final Color color;


  @override
  Widget build(BuildContext context) {
    String _hnt = (caption ?? '').isNotEmpty
      ? this.caption
      : type == Btn.Add
        ? 'new'
        : type == Btn.Del
        ? 'delete'
        : type == Btn.Exit
          ? 'return'
          : type == Btn.Reload
            ? 'reload'
            : type == Btn.Save
              ? 'save'
              : '';

    Widget _icon = icon != null
      ? this.icon
      : type == Btn.Add
        ? Icon(FontAwesomeIcons.solidPlusSquare)
        : type == Btn.Del
        ? Icon(FontAwesomeIcons.trash)
        : type == Btn.Exit
          ? Icon(FontAwesomeIcons.signOutAlt)
          : type == Btn.Reload
            ? Icon(FontAwesomeIcons.syncAlt)
            : type == Btn.Save
              ? Icon(FontAwesomeIcons.solidSave)
              : Icon(FontAwesomeIcons.questionCircle);

    return Card(
      color: this.color,
      child: CupertinoButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            type == Btn.Loading ? CupertinoActivityIndicator() : _icon,
            SizedBox(width: 10),
            Text(_hnt, style: TextStyle(fontFamily: 'roundor', fontSize: 18, fontWeight: FontWeight.bold),),
          ],
        ),
        onPressed: type==Btn.Exit && this.onPressed==null 
          ? ()=>Navigator.of(context).pop()
          : this.onPressed,
        color: this.color,
      ),
    );
  }
}

class FButton extends StatelessWidget {
  const FButton({Key key, @required this.hint, @required this.child, @required this.onPressed}) : super(key: key);

  final String hint;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: this.hint,
      child: FlatButton(
        child: this.child,
        onPressed: this.onPressed,
      )
    );
  }
}
class Menu extends StatelessWidget {
  const Menu({Key key, @required this.title, this.icon, this.selected, this.selectedColor, this.onTap, this.inCard, this.hoverColor}) : super(key: key);

  final String title;
  final Icon icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;
  final bool inCard;
  final Color hoverColor;
  

  @override
  Widget build(BuildContext context) {
    return this.inCard ?? false
        ? Card(child: widget())
        : widget(); 
  }
  Widget widget(){
    return ListTile(
      title: Text(title),
      leading: this.icon,
      selected: this.selected ?? false,
      selectedTileColor: this.selectedColor ?? Colors.transparent,
      onTap: this.onTap,
      hoverColor: this.hoverColor,
    );
  }
}

class Field extends StatelessWidget {
  const Field(this.data,{Key key, this.bold = false, this.flex = 1, this.sort, this.center = false}) : super(key: key);

  final dynamic data;
  final bool bold;
  final int flex;
  final Sort sort;
  final bool center;
  // final bool editable;
  // final String json;

  @override
  Widget build(BuildContext context) {
    return data is String
      ? this.sort == null
        ? widget()
        : this.sort == Sort.Asc
          ? Row(children: [Icon(FontAwesomeIcons.sortNumericDown, size: 20), SizedBox(width: 3,), widget()],)
          : Row(children: [Icon(FontAwesomeIcons.sortNumericDownAlt, size: 20), SizedBox(width: 3,), widget()],)
      : data as Widget;
  }

  Widget widget(){
    return Text('$data', textAlign: this.center ? TextAlign.center : TextAlign.start, style: this.bold ? TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lalezar', fontSize: 14) : null);
  }
}

InputDecoration textDecoration(String label) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7.0),
      gapPadding: 4,
    ),
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14.0),
    labelText: label,
    counterText: ''
    // prefixIcon: icon==null ? null : Icon(icon, color: Colors.grey[500], size: 15.0,),
  );
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    // if (oldValue.text.length >= newValue.text.length) {
    //   return newValue;
    // }
    if (_addSeperators(oldValue.text, '/').length >= _addSeperators(newValue.text, '/').length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    if (dateText.length > 10)
      dateText = dateText.substring(0, 10);
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 3) {
        newString += seperator;
      }
      if (i == 5) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class TimeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    // if (oldValue.text.length >= newValue.text.length) {
    //   return newValue;
    // }
    if (_addSeperators(oldValue.text, ':').length >= _addSeperators(newValue.text, ':').length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, ':');
    if (dateText.length > 5)
      dateText = dateText.substring(0, 5);
    if (dateText.length > 2 && int.parse(dateText.split(":")[0]) > 24)
      dateText = "24:${dateText.split(':')[1]}";
    if (dateText.length >= 5 && int.parse(dateText.split(":")[1]) > 24)
      dateText = "${dateText.split(':')[0]}:24";
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll(':', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class MoneyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      // List<String> chars = newValue.text.replaceAll(',', '').split('');
      // String newString = '';
      // int j = 0;
      // for (int i = chars.length-1; i >= 0; i--) {
      //   if (j % 3 == 0 && j > 0){ 
      //     newString = ','+newString;
      //   }
      //   newString = chars[i]+newString;
      //   j++;
      // }
      String newString = moneySeprator(double.parse(newValue.text));
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class Edit extends StatelessWidget {
  const Edit({Key key, this.value, this.onChange, this.controller, this.onSubmitted, this.autofocus = false, this.hint, this.password = false, this.focus, this.date=false, this.money=false, this.numbersonly=false, this.timeonly=false, this.readonly = false, this.onEditingComplete, this.maxlength, this.f2key, this.f2value, this.notempty=false, this.validator, this.maxlines = 1}) : super(key: key);

  final bool autofocus;
  final String value;
  final Function onChange;
  final Function onSubmitted;
  final String hint;
  final bool password;
  final TextEditingController controller;
  final FocusNode focus;
  final bool date;
  final bool numbersonly;
  final bool timeonly;
  final bool money;
  final bool readonly;
  final VoidCallback onEditingComplete;
  final int maxlength;
  final String f2key;
  final dynamic f2value;
  final bool notempty;
  final int maxlines;
  final Function(String) validator;

  @override
  Widget build(BuildContext context) {
    if (controller != null && controller.text.isEmpty)
      controller.text = this.value ?? '';
    return TextFormField(
      maxLines: this.maxlines,
      readOnly: this.readonly,
      autofocus: this.autofocus,
      controller: this.controller ?? TextEditingController(text: this.value ?? ''),
      onChanged: this.onChange,
      decoration: textDecoration(this.hint),
      obscureText: this.password,
      style: GoogleFonts.abel(),
      validator: validator != null ? validator : (val){
        if ((val.isEmpty || val.trim() == "0") && notempty) 
          return 'مقدار فیلد اجباری است';
        return null;
      },
      onFieldSubmitted: this.f2key == null ? this.onSubmitted : (val){
        // if (val.isEmpty && (f2value == null || !(f2value is TextEditingController) || (f2value as TextEditingController).text.isNotEmpty))
        //   showFormAsDialog(context: context, form: ForeignKey(controller: controller, onSubmitted: this.onSubmitted, f2key: this.f2key, relationvalue: f2value is TextEditingController ? (f2value as TextEditingController).text : f2value));
        // else
          this.onSubmitted('');
      },
      onEditingComplete: this.onEditingComplete,
      focusNode: this.focus,
      maxLength: this.maxlength,
      inputFormatters: date 
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,DateTextFormatter()] 
        : this.numbersonly 
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] 
          : this.timeonly
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,TimeTextFormatter()]
            : this.money 
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, MoneyTextFormatter()]
              : <TextInputFormatter>[],
    );
  }
}

class GridRow extends StatelessWidget {
  const GridRow(this.fields, {Key key, this.color, this.header = false, this.onTap, this.onDoubleTap}) : super(key: key);

  final List<Field> fields;
  final Color color;
  final bool header;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    bool icn = fields.where((e) => !(e.data is String)).length > 0;
    return this.onTap != null
      ? Card(
        child: ListTile(
          dense: true,
          title: widget(context, icn),
          onTap: this.onTap,
        ),
        color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
      )
      : GestureDetector(
        onDoubleTap: this.onDoubleTap,
        child: Card(
          color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
          child: widget(context, icn)
        ),
      );
  }

  Widget widget(BuildContext context, bool icn){
    return Container(
      padding: EdgeInsets.symmetric(vertical: header ? 12 : icn ? 0 : 12, horizontal: 8),
      child: Row(
        children: [
          ...fields.map((e){
            if (e.data is String)
              return Expanded(child: e, flex: e.flex);
            else if (e.data is Edit) // || e.data is F2Edit
              return Expanded(flex: e.flex, child: Container(margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3), child: e.data));
            else 
              return e.data;
          })
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   bool icn = fields.where((e) => !(e.data is String)).length > 0;
  //   return this.onTap != null
  //     ? ListTile(
  //       title: widget(context, icn),
  //       onTap: this.onTap,
  //     )
  //     : GestureDetector(
  //       onDoubleTap: this.onDoubleTap,
  //       child: widget(context, icn),
  //     );
  // }

  // Widget widget(BuildContext context, bool icn){
  //   return Card(
  //     color: this.color ?? (this.header ? appbarColor(context) : Colors.transparent),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: header ? 12 : icn ? 0 : 12, horizontal: 8),
  //       child: Row(
  //         children: [
  //           ...fields.map((e){
  //             if (e.data is String)
  //               return Expanded(flex: e.flex, child: e);
  //             else if (e.data is Edit || e.data is F2Edit)
  //               return Expanded(flex: e.flex, child: Container(margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3), child: e.data));
  //             else 
  //               return e.data;
  //           })
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class FilterItem extends StatelessWidget {
  const FilterItem({Key key, @required this.title, @required this.selected, this.onSelected, this.color}) : super(key: key);

  final Color color;
  final String title;
  final bool selected;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: FilterChip(
        backgroundColor: this.color,
        selectedColor: this.color,
        elevation: this.selected ? 5 : 2,
        shape: BeveledRectangleBorder(side: BorderSide(color: Colors.black12, width: 0.2), borderRadius: BorderRadius.circular(5.0)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        label: Text('${this.title}', style: GoogleFonts.allerta()),
        selected: this.selected,
        onSelected: this.onSelected
      )
    );
  }
}

class StreamListWidget extends StatelessWidget {
  const StreamListWidget({Key key, @required this.stream, @required this.itembuilder}) : super(key: key);

  final Function(dynamic) itembuilder;
  final Stream stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataModel>(
      stream: this.stream,
      builder: (context, snap){
        if (snap.hasData)
          if (snap.data.status == Status.Error)
            return Center(child: Text('${snap.data.msg}'));
          else if (snap.data.status == Status.Loaded)
            return ListView.builder(
              itemCount: snap.data.rows.length,
              itemBuilder: (context, idx) => itembuilder(snap.data.rows[idx])
            );
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}

class StreamWidget extends StatelessWidget {
  const StreamWidget({Key key, @required this.stream, @required this.itemBuilder}) : super(key: key);

  final Stream<dynamic> stream;
  final Function itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: this.stream,
      builder: (context, snap){
        if (snap.connectionState == ConnectionState.active)
          return this.itemBuilder(snap.data);
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}

// class ForeignKey extends StatelessWidget {
//   const ForeignKey({Key key, @required this.onSubmitted, @required this.controller, @required this.f2key, this.relationvalue}) : super(key: key);

//   final TextEditingController controller;
//   final Function onSubmitted;
//   final String f2key;
//   final dynamic relationvalue;

//   @override
//   Widget build(BuildContext context) {
//     MyProvider _prov = Provider.of<MyProvider>(context);
//     var _f2Bloc = PublicBloc(
//       context: context, 
//       api: 'Coding/$f2key',
//       body: f2key=='Moin' ? {'kolid': int.parse(relationvalue)} : f2key=="Tafsili" ? {'lev': relationvalue} : null,
//       token: _prov.currentUser.token
//     );
//     return Container(
//       width: screenWidth(context) * 0.25,  
//       height: screenHeight(context) * 0.50,  
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Column(
//           children: [
//             RawKeyboardListener(
//               child: Edit(hint: '... جستجو', onChange: (val)=>_f2Bloc.findByName(val), autofocus: true, onSubmitted: (String val){
//                 if (_f2Bloc.rowsValue$.rows.where((element) => element.selected).length == 0)
//                   this.onSubmitted('');
//                 else{
//                   this.controller.text = _f2Bloc.rowsValue$.rows.where((element) => element.selected).toList()[0].id.toString();
//                   this.onSubmitted(this.controller.text);
//                 }                  
//                 Navigator.of(context).pop();
//               }),
//               focusNode: FocusNode(),
//               onKey: (RawKeyEvent event) {
//                 List<Mainclass> _rows = _f2Bloc.rowsValue$.rows;
//                 if (_f2Bloc.rowsValue$.status == Status.Loaded && _rows != null && _rows.length > 0){
//                   if (_rows.where((element) => element.selected).length == 0)  
//                     _f2Bloc.selectRow(0);
//                   else if (event.runtimeType == RawKeyDownEvent)
//                     if (event.data.logicalKey.keyId == 4295426129)
//                       _f2Bloc.selectNextRow();
//                     else if (event.data.logicalKey.keyId == 4295426130)
//                       _f2Bloc.selectPriorRow();
//                 }
//               }
//             ),
//             SizedBox(height: 5),
//             Expanded(
//               child: StreamListWidget(stream: _f2Bloc.rowsStream$, itembuilder: (rw) =>rw.inSearch ? GridRow(
//                 [
//                   Field('${rw.id}'),
//                   Field(rw.name, flex: 3,)
//                 ], 
//                 color: rw.selected ? accentcolor(context).withOpacity(0.25) : null,
//                 onTap: (){
//                   this.controller.text = rw.id.toString();
//                   Navigator.of(context).pop();
//                   this.onSubmitted('${rw.id}');
//                 },
//               ) : Container()
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }

class GridError extends StatelessWidget {
  const GridError({Key key, @required this.msg, this.color}) : super(key: key);

  final dynamic msg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: this.color ?? Colors.red.withOpacity(0.5)
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      child: msg is String 
        ? Text('$msg', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontFamily: 'Lalezar'))
        : this.msg,
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key key, @required this.caption, @required this.icon, @required this.onTap}) : super(key: key);

  final String caption;
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          child: Row(
            children: [
              icon,
              SizedBox(width: 5),
              Text('$caption'),
            ],
          ), 
          onPressed: this.onTap
        ),
      )
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({Key key, @required this.senderid, @required this.sender, @required this.msg, @required this.date, this.leftCorner = true}) : super(key: key);

  final int senderid;
  final String sender;
  final String msg;
  final String date;
  final bool leftCorner;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(backgroundImage: AssetImage('images/user$senderid.jpg')),
              SizedBox(width: 10),
              Text('$sender', style: GoogleFonts.overpass(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 15),
              Text('$msg', style: GoogleFonts.workSans()),
            ],
          ),
          SizedBox(height: 10),
          Text('      $date', style: TextStyle(fontSize: 9)),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class SignalItem extends StatelessWidget {
  const SignalItem({Key key, @required this.bloc, @required this.rw, this.ontap}) : super(key: key);

  final TBSignal rw;
  final SignalBloc bloc;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: !rw.closetime.isEmpty ? Colors.red.withOpacity(0.05) : null,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage('images/user${rw.accountnumber}.jpg')),
        title: Row(
          children: [
            Text(rw.symbol),
            SizedBox(width: 5),
            // Text(' - ${rw.title}', style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${rw.opentime}'),
            SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IButton(icon: Icon(rw.liked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp, size: 20, color: rw.liked ? Colors.red :  null,), hint: 'Like', onPressed: ()=>bloc.likeSignal(rw.accountnumber)),
                SizedBox(width: 5),
                Container(child: Text('${rw.likes}', style: TextStyle(color: Colors.grey)), margin: EdgeInsets.only(top: 10))
              ],
            )
          ],
        ),
        onTap: this.ontap
      ),
    );
  }
}

class AnalyzeItem extends StatelessWidget {
  const AnalyzeItem({Key key, @required this.bloc, @required this.rw, this.ontap}) : super(key: key);

  final TBAnalyze rw;
  final AnalyzeBloc bloc;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      color: Colors.grey[100],
      child: Container(
        width: screenWidth(context) * 0.30 > 435 ? 435 : screenWidth(context) * 0.30 < 400 ? 400 : screenWidth(context) * 0.30,
        padding: EdgeInsets.all(8),
        child: ListTile(
          onTap: this.ontap,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${rw.subject}', style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('${rw.symbol}', style: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(rw.status ==1 ? Icons.trending_up : Icons.trending_down, color: rw.status ==1 ? Colors.green : Colors.deepOrange),
                ],
              ),
              SizedBox(height: 15),
              Image(image: NetworkImage('${rw.smallpic}'), height: 200, fit: BoxFit.fill),
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
                        IButton(icon: Icon(rw.liked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp, color: rw.liked ? Colors.red : Colors.grey[600]), hint: 'Like', onPressed: ()=>bloc.like(rw.id)),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: Text('${rw.likes}'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 25),
                  IButton(icon: Icon(FontAwesomeIcons.commentAlt), hint: 'Comment', onPressed: (){})
                ],
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      )
    );
  }
}

class SubscribeItem extends StatelessWidget {
  const SubscribeItem({Key key, @required this.title, @required this.note, @required this.price, this.color}) : super(key: key);

  final String title;
  final String note;
  final double price;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295,
      height: 503,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(50)),
              ),
              elevation: 12,
              child: Container(
                width: screenWidth(context) * 0.25 < 275 ? 275 : screenWidth(context) * 0.25,
                height: 450,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Text('$title', style: GoogleFonts.fredokaOne(fontSize: 26, color: Colors.blueGrey)),
                    SizedBox(height: 25),
                    Text('$note', style: GoogleFonts.padauk(fontSize: 16, color: Colors.grey[500]), textAlign: TextAlign.center,),
                    Spacer(),
                    Row(
                      children: [
                        FButton(hint: 'Visa Card', onPressed: (){}, child: FaIcon(FontAwesomeIcons.ccVisa, size: 36, color: Colors.blueGrey)),
                        FButton(hint: 'Paypal', onPressed: (){}, child: FaIcon(FontAwesomeIcons.ccPaypal, size: 36, color: Colors.blue)),
                        FButton(hint: 'Master Card', onPressed: (){}, child: FaIcon(FontAwesomeIcons.ccMastercard, size: 36, color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FButton(hint: 'Bitcoin', onPressed: (){}, child: FaIcon(FontAwesomeIcons.bitcoin, size: 36, color: Colors.yellow[900])),
                        FButton(hint: 'Iranian Bank', onPressed: (){}, child: FaIcon(FontAwesomeIcons.moneyCheckAlt, size: 36, color: Colors.purple)),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text('payment', style: TextStyle(color: Colors.grey[600])),
                        Spacer(),
                        Text('\$$price / month', style: TextStyle(color: Colors.grey[400]))
                      ],
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FaIcon(FontAwesomeIcons.award, size: 65, color: this.color == null ? Colors.yellow[600] : hexToColor(this.color))
          ),
        ],
      ),
    );
  }
}

class ICheckbox extends StatelessWidget {
  const ICheckbox({Key key, @required this.value, @required this.hint, this.onChanged}) : super(key: key);

  final bool value;
  final String hint;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: this.hint,
      child: Checkbox(
        value: this.value,
        onChanged: this.onChanged,
      ),
    );
  }
}

