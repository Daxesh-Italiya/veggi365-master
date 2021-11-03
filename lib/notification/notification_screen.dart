import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/themes/utility.dart';
import 'package:veggi/widgets/app_shimmer_effect.dart';

import '../Constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoaded = false;

  @override
  void initState() {
    //Utility.statusBarColorWhiteBackGround();
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Notification',
          style: AppTextStyle.pageTitleStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.navigate_before_outlined,
            color: AppColors.themeColor.primaryIconColor,
            size: 35,
          ),
        ),
      ),
      body: isLoaded ? buildNoItemWidget() : buildNotificationShimmer(),
    );
  }

  Widget buildNotificationShimmer() {
    return AppShimmer(
      child: ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    verticalSpace(4),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 8.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoItemWidget() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              color: kPrimaryColor,
              size: 80,
            ),
            verticalSpace(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'You have no notification at all!',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
