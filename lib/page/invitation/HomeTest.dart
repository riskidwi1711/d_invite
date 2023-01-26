// import 'package:flutter/material.dart';
//
//
// class HomeTest extends StatefulWidget {
//   @override
//   _HomeTestState createState() => _HomeTestState();
// }
//
// class _HomeTestState extends State<HomeTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         HomeAppBar(
//           isFotoLoad: isFotoLoad,
//           isLoading: isLoading,
//           profileUrl: isFotoLoad
//               ? 'assets/img/avatar.jpg'
//               : '${base_url}img/${userData['user_data']['photo_profile']}',
//           handleLogout: () async {
//             await MainFunc().handleLogout().then((value) {}).whenComplete(() =>
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (builder) => LoginPage())));
//           },
//           welcomeWords: welcomeWords,
//           userName: 'Hi ${userData != null ? userData['name'] : 'user'}',
//           handleNotification: () {
//             Navigator.of(context)
//                 .push(
//                 MaterialPageRoute(builder: (builder) => NotificationPage()))
//                 .then((value) => _isNotified(0));
//           },
//           notification: notif,
//         ),
//         isLoading
//             ? SkeletonHome()
//             : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           SizedBox(
//             height: 65,
//             child: ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 padding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount:
//                 category != null ? category['content'].length : 0,
//                 itemBuilder: (BuildContext context, int index) {
//                   return CategoryCard(
//                       title: category['content'][index]['nama_kategori'],
//                       index: index,
//                       selected: select,
//                       onPressed: () async {
//                         onTapItem(index);
//                         await MainFunc()
//                             .getTemplateByCategory(
//                             category['content'][index]['id'])
//                             .then((value) {
//                           setState(() {
//                             template = value;
//                           });
//                         })
//                             .catchError((e) => print('erorr'))
//                             .whenComplete(() {
//                           setState(() {
//                             isTempLoad = false;
//                           });
//                         });
//                       });
//                 }),
//           ),
//           Expanded(
//               child: isTempLoad
//                   ? SkeletonHomeTemplate()
//                   : template['content'].length < 1
//                   ? Center(
//                   child: ConfussingComponent(
//                     title: 'Belum ada template di kategori ini',
//                   ))
//                   : GridView.builder(
//                   physics: BouncingScrollPhysics(),
//                   itemCount: template['content'].length,
//                   padding: EdgeInsets.only(
//                       left: 15, right: 15, top: 15, bottom: 10),
//                   gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount:
//                     MediaQuery.of(context).orientation ==
//                         Orientation.landscape
//                         ? 3
//                         : 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: (1 / 1.3),
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return TemplateShowCase(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (builder) => InputPage(
//                                     curUser: userData['name'],
//                                     namaFile: template['content']
//                                     [index]['nama_file'],
//                                     uid: userData['id'],
//                                     id: template['content'][index]
//                                     ['id'])));
//                       },
//                       thumbnailTemplate:
//                       '${base_url}template/${template['content'][index]['nama_file']}',
//                     );
//                   }))
//         ]),
//       ],
//     );
//   }
// }
