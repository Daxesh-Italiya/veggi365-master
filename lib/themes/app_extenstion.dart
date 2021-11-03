import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension stringConversion on String {



  DateTime get getDateTimeFromAPIString {
    if (this.trim().isNotEmpty) {
      return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(
        this,
        true,
      );
    } else {
      return DateTime.now();
    }
  }

}