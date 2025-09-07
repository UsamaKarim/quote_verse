import 'package:flutter/material.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';

part 'quotes_exceptions_adapter.dart';

abstract class AppExceptionsAdapter {
  static String toTitle(BuildContext context, AppException exception) {
    return exception.toMessage(context);
  }
}
