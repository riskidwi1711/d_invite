import 'dart:async';
import 'dart:convert';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/notificationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_invite/api/sharedPrefs/localStore.dart';
import 'package:d_invite/components/big_component/AppBar.dart';
import 'package:d_invite/components/big_component/templateShowCase.dart';
import 'package:d_invite/components/card.dart';
import 'package:d_invite/components/confusingComp.dart';
import 'package:d_invite/components/skeleton.dart';
import 'package:d_invite/const/config.dart';
import 'package:d_invite/const/function/initData.dart';
import 'package:d_invite/page/inputPage.dart';
import 'package:d_invite/page/loginReg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userData;
  var template;
  var newTemplate;
  var notif;
  var category;
  var imgName;
  var welcomeWords;
  int select = 0;
  bool isLoading = true;
  bool isTempLoad = false;
  bool isFotoLoad = true;

  @override
  void initState() {
    InitData()
        .getAllData()
        .whenComplete(() => newData().whenComplete(() {
              if (this.mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            }))
        .whenComplete(() => _isNotified(0));
    super.initState();
    if (this.mounted) {
      setState(() {
        welcomeWords = MainFunc().getWelcomeWords();
      });

      Timer(Duration(seconds: 10), () {
        if (this.mounted) {
          setState(() {
            welcomeWords = "Yuk mulai buat digital invitation";
          });
        }
      });
    }
  }

  void onTapItem(int index) {
    setState(() {
      select = index;
      isTempLoad = true;
    });
  }

  Future<void> newData() async {
    var userDataJSON = await CallLocal().getLocalString('userData');
    var templateJSON = await CallLocal().getLocalString('template');
    var newTemplateJSON = await CallLocal().getLocalString('newTemplate');
    var categoryJSON = await CallLocal().getLocalString('category');

    if (userDataJSON != null &&
        templateJSON != null &&
        newTemplateJSON != null &&
        categoryJSON != null) {
      if (this.mounted) {
        setState(() {
          userData = jsonDecode(userDataJSON);
          template = jsonDecode(templateJSON);
          newTemplate = jsonDecode(newTemplateJSON);
          category = jsonDecode(categoryJSON);
        });
      }
    }
  }

  void _giveTemplate(id) async {
    await InitData().getTemplateByCategory(id).whenComplete(() async {
      await CallLocal().getLocalString('template').then((value) {
        if (this.mounted) {
          setState(() {
            template = jsonDecode(value);
            isTempLoad = !isTempLoad;
          });
        }
      });
    });
  }

  void _isNotified(e) async {
    await MainFunc().getUserData(userData['id']).then((value) {
      dynamic data = value;
      List notify = data['notif'];
      if (this.mounted) {
        setState(() {
          notif = notify.where((element) => element['unread'] == e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 180),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: isLoading
                  ? SkeletonHome()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            height: 130,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: 3,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 450,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(child: Text('Iklan')),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Template terbaru',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text('Lihat template terbaru')
                              ],
                            )),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: newTemplate != null
                                  ? newTemplate['content'].length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: TemplateShowCase(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => InputPage(
                                                  curUser: userData,
                                                  template:
                                                      newTemplate['content']
                                                          [index])));
                                    },
                                    thumbnailTemplate:
                                        '${base_url}template/preview/${newTemplate['content'][index]['preview']}',
                                  ),
                                );
                              }),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Semua template',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text(
                                    'Kamu bisa memilih template berdasarkan kategori')
                              ],
                            )),
                        SizedBox(
                          height: 65,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: category != null
                                    ? category['content'].length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return CategoryCard(
                                      title: category['content'][index]
                                          ['nama_kategori'],
                                      index: index,
                                      selected: select,
                                      onPressed: () async {
                                        onTapItem(index);
                                        _giveTemplate(
                                            category['content'][index]['id']);
                                      });
                                }),
                          ),
                        ),
                        isTempLoad
                            ? SkeletonHomeTemplate()
                            : template['content'].length < 1
                                ? Center(
                                    child: ConfussingComponent(
                                    title: 'Belum ada template di kategori ini',
                                  ))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: template['content'].length,
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 5,
                                        bottom: 10),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.landscape
                                              ? 3
                                              : 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: (2 / 3),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return TemplateShowCase(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      InputPage(
                                                        curUser: userData,
                                                        template:
                                                            template['content']
                                                                [index],
                                                      )));
                                        },
                                        thumbnailTemplate:
                                            '${base_url}template/preview/${template['content'][index]['preview']}',
                                      );
                                    })
                      ],
                    )),
        ),
        HomeAppBar(
          isFotoLoad: isFotoLoad,
          isLoading: isLoading,
          profileUrl: isFotoLoad
              ? 'assets/img/avatar.jpg'
              : '${base_url}img/${userData['user_data']['photo_profile']}',
          handleLogout: () async {
            await MainFunc().handleLogout().then((value) {}).whenComplete(() =>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (builder) => LoginPage())));
          },
          welcomeWords: welcomeWords,
          userName: 'Hi ${userData != null ? userData['name'] : 'user'}',
          handleNotification: () {
            Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (builder) => NotificationPage()))
                .then((value) {
              _isNotified(0);
            });
          },
          notification: notif,
        ),
      ],
    );
  }
}
