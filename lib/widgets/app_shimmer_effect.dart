import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Constants.dart';

/// common shimmer effect widget for display while loading data
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kShimmerBaseColor,
      highlightColor: kShimmerHighlightColor,
      period: Duration(seconds: 2),
      enabled: true,
      child: child,
    );
  }
}
