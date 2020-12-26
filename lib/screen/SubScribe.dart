import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../module/Widgets.dart';
import '../module/functions.dart';

class SubScribe extends StatelessWidget{
  const SubScribe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 15),
      width: screenWidth(context) * 0.75 > 1250 ? 1250 : screenWidth(context) * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: screenHeight(context) * 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Your Subscribtion Plan', style: GoogleFonts.fredokaOne(fontSize: 28, color: Colors.grey[600])),
          SizedBox(height: 10),
          Text('to see and follow premium signals and analysis you have to choose one', style: GoogleFonts.padauk(fontSize: 16, color: Colors.grey[400])),
          SizedBox(height: 75),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 32,
                children: [
                  SubscribeItem(title: 'Golden Account', note: 'with this account you can follow unlimited users,copy trades and Learning classes', price: 12.99, color: '#ffb700'),
                  SubscribeItem(title: 'Silver Account', note: 'with this account you can follow only 25 users and learning classes', price: 8.99, color: '#a3a3a3'),
                  SubscribeItem(title: 'Normal Account', note: 'with this account you can follow only 5 users', price: 4.99, color: '#9dccfa'),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}