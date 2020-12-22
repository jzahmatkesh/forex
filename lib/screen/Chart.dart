import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = 'https://www.zahmatkesh.dev/forex/chart.html';
      iframe.style.border = "none";
      return iframe;
    });
    return Container(
      child: HtmlElementView(viewType: 'iframe')
    );
  }
}