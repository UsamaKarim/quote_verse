import 'package:flutter/material.dart';
import 'package:quote_verse/app/common/exceptions_adapters/app_exceptions_adapter.dart';

part 'quotes_exceptions.dart';

sealed class AppException implements Exception {
  String toMessage(BuildContext context);
}
