import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

extension BuildContextEntension<T> on BuildContext {
  Future<T?> pushTo<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouterHelper(this).pushNamed<T>(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool?> showToast(String message) {
// It's a plugin to show toast and we can with extension
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: yColors.primary,
      textColor: yColors.primaryText,
    );
  }
}

extension PaddingX on Widget {
  Padding pr(double px) => Padding(
        key: key,
        padding: EdgeInsets.only(right: px),
        child: this,
      );

  Padding pl(double px) => Padding(
        key: key,
        padding: EdgeInsets.only(left: px),
        child: this,
      );

  Padding pt(double px) => Padding(
        key: key,
        padding: EdgeInsets.only(top: px),
        child: this,
      );

  Padding pb(double px) => Padding(
        key: key,
        padding: EdgeInsets.only(bottom: px),
        child: this,
      );
}

extension ColorUtil on Color {
  String toHex() => '#${value.toRadixString(16)}';

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension LoaderUtil on Future {
  Future<T?> showLoader<T>(BuildContext context) async {
    if (context.mounted) context.loaderOverlay.show();
    try {
      return await this;
    } finally {
      if (context.mounted) context.loaderOverlay.hide();
    }
  }
}
