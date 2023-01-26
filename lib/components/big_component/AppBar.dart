import 'package:d_invite/const/designHelper.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final isFotoLoad;
  final profileUrl;
  final userName;
  final isLoading;
  final welcomeWords;
  final Function handleLogout;
  final Function handleNotification;
  final notification;
  HomeAppBar(
      {required this.handleNotification,
      this.notification,
      this.isLoading = true,
      this.isFotoLoad = true,
      this.welcomeWords,
      required this.handleLogout,
      this.profileUrl,
      this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: isFotoLoad ? AssetImage(profileUrl)
                            : NetworkImage(
                                profileUrl,
                              )),
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                    color: Colors.white30,
                  ),
                  height: 60,
                  width: 60,
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                            iconSize: 25,
                            onPressed: handleNotification,
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            )),
                        isLoading
                            ? Container()
                            : notification != null  && notification.length > 0
                                ? Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          color: Colors.red),
                                    ))
                                : Container()
                      ],
                    ),
                    IconButton(
                        iconSize: 25,
                        onPressed: handleLogout,
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              userName,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            Text(
              welcomeWords != null ? welcomeWords : 'Selamat Datang ',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
          color: Color(gradientOne),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
    );
  }
}

class InvitationAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(gradientOne), Color(gradientOne)]),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Undangan',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )),
    );
  }
}

