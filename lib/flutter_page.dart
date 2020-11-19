library flutter_page;

import 'package:flutter/material.dart';

import 'page_util.dart';

/// class FlutterPage.
abstract class FlutterPage extends StatefulWidget implements PageAttribute {}

abstract class FlutterPageState<T extends FlutterPage> extends State<T> {
  void onHide() {}
  void onResume() {}
  @override
  void initState() {
    super.initState();
    PageUtil.pushPage(context, this);
  }

  @override
  void dispose() {
    PageUtil.popPage();
    super.dispose();
  }
}

abstract class PageAttribute {
  final String pageTag = "base_page";
}
