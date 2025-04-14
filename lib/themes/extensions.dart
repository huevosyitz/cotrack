import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

enum MessageType {
  success,
  warning,
  error,
  info,
}

Map<MessageType, ContentType> get messageTypeToContentType => {
      MessageType.success: ContentType.success,
      MessageType.warning: ContentType.warning,
      MessageType.error: ContentType.failure,
      MessageType.info: ContentType.help,
    };

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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showMessage(
      String message,
      {MessageType type = MessageType.error,
      Duration duration = const Duration(seconds: 3)}) {
    if (mounted) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: duration,
        content: AwesomeSnackbarContent(
          title: type.name.capitalizeFirst,
          message: message,
          contentType: messageTypeToContentType[type]!,
        ),
      );
      return ScaffoldMessenger.of(this).showSnackBar(snackBar);
    }

    return null;
  }

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
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

extension DateUtils on DateTime {
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
