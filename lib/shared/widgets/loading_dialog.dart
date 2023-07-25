import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/navigator/navigator_utils.dart';

abstract class LoadingDialog {
  static final _context = NavigatorUtils.context;
  static bool _isShow = false;
  static Future<void> show() async {
    hide();
    _isShow = true;
    await showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
            content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            const Text(LocaleKeys.loading).tr()
          ],
        )),
      ),
    );
    _isShow = false;
  }

  static void hide() {
    if (_isShow) {
      Navigator.pop(_context);
      _isShow = false;
    }
  }
}
