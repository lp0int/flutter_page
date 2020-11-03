import 'package:flutter/material.dart';

import 'flutter_page.dart';

class PageModel {
  final BuildContext context;
  final FlutterPage page;

  PageModel(this.context, this.page);
}

class PageUtil {
  static PageStack<PageModel> pageList = new PageStack(100);

  static FlutterPage getPage<T extends FlutterPage>(BuildContext context) {
    if (context.widget is T) return context.widget;
    T page = context.findAncestorWidgetOfExactType<T>();
    return page;
  }

  static void pushPage(BuildContext context, FlutterPage page) {
    PageModel topPage = pageList.top;
    if (topPage != null) {
      topPage.page.onHide();
    }
    pageList.push(new PageModel(context, page));
  }

  static void popPage() {
    pageList.pop();
    PageModel topPage = pageList.top;
    if (topPage != null) {
      topPage.page.onResume();
    }
  }
}

class PageStack<E> {
  final List<E> _stack;
  final int capacity;
  int _top;

  PageStack(this.capacity)
      : _top = -1,
        _stack = List<E>(capacity);

  bool get isEmpty => _top == -1;
  bool get isFull => _top == capacity - 1;
  int get size => _top + 1;

  void push(E e) {
    if (isFull) throw StackOverFlowException;
    _stack[++_top] = e;
  }

  E pop() {
    if (isEmpty) return null;
    return _stack[_top--];
  }

  E get top {
    if (isEmpty) return null;
    return _stack[_top];
  }
}

class StackOverFlowException implements Exception {
  const StackOverFlowException();
  String toString() => 'StackOverFlowException';
}

class StackEmptyException implements Exception {
  const StackEmptyException();
  String toString() => 'StackEmptyException';
}
