import 'package:flutter/material.dart';
import 'package:uas_twitter_mediasosial/components/widget_dot_bounce.dart';

void showLoadingCircle(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: WidgetDotBounce(
        color: Colors.white,
        size: 18.0,
        count: 3,
      ),
    ),
  );
}

void hideLoadingCircle(BuildContext context){
  Navigator.pop(context);
}