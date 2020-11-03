library flutter_page;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'page_util.dart';

/// class FlutterPage.
abstract class FlutterPage<D extends ChangeNotifier> extends StatefulWidget
    implements PageAttribute {
  Widget build(BuildContext context, D d);
  void create() {}
  void destroy() {}
  void onHide() {}
  void onResume() {}
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  final FlutterPageState state = FlutterPageState<D>();

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class FlutterPageState<D extends ChangeNotifier> extends State<FlutterPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    PageUtil.pushPage(context, widget);
    widget.create();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PageUtil.popPage();
    widget.destroy();
    widget.data?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<D>.value(value: widget.data),
      ],
      child: Consumer<D>(
        builder: (context, value, child) {
          return widget.build(context, value);
        },
      ), //
    );
  }
}

abstract class PageAttribute {
  final String pageTag = "base_page";
  final ChangeNotifier data = null;
}
