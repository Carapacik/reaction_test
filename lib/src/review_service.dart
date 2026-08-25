import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

Future<void> requestAppReview() async {
  final bool supportsInAppReview = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  if (!supportsInAppReview) {
    return;
  }

  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    await inAppReview.requestReview();
  }
}
