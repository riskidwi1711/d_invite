import 'package:flutter/material.dart';
import 'package:d_invite/const/designHelper.dart';

class BantuanPage extends StatefulWidget {
  @override
  _BantuanPageState createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(gradientOne), Color(gradientTwo)]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: SafeArea(
              child: Center(
                child: Text(
            'Bantuan',
            style: TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
              )),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid))
              ),
              child: ListTile(
                leading: Icon(Icons.app_settings_alt),
                title: Text('Cara menggunakan aplikasi'),
                subtitle: Text('cari tahu cara menggunakan aplikasi'),
              ),
            );
          }),
        )
      ],
    );
  }
}
