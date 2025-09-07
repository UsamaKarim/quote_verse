import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class Toast {
  static void error(BuildContext context, String? message) {
    toast(context, message, ToastificationType.error);
  }

  static void success(BuildContext context, String? message) {
    toast(context, message, ToastificationType.success);
  }

  static void info(BuildContext context, String? message) {
    toast(context, message, ToastificationType.info);
  }

  static void warning(BuildContext context, String? message) {
    toast(context, message, ToastificationType.warning);
  }

  static void toast(
    BuildContext context,
    String? message,
    ToastificationType type,
  ) {
    if (!context.mounted) return;
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.minimal,
      description: Text(
        message ?? 'Something went wrong. Please try again.',
      ),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: true,
      dragToClose: true,
    );
  }
}
