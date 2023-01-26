import 'package:flutter/material.dart';
import 'package:d_invite/components/topBar.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/page/inputOption/BirthdayInput.dart';
import 'package:d_invite/page/inputOption/WeddingInput.dart';

class InputPage extends StatefulWidget {
  final template;
  final curUser;
  InputPage({this.template, this.curUser});

  @override
  _InputPageState createState() => _InputPageState(template, curUser);
}

class _InputPageState extends State<InputPage> {
  //variable

  var template;
  var curUser;
  _InputPageState(this.template, this.curUser);


  // _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2022));
  //   if (picked != null){
  //     setState(() {
  //       date = picked;
  //       tanggalDimulai.text = DateFormat.yMMMd().format(date);
  //     });
  //   }
  // }

  // _selectTime(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if(picked != null){
  //     setState(() {
  //       time = picked;
  //       timeEdit.text = DateFormat.Hm().format(DateTime(2019, 08, 1, picked.hour, picked.minute));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                child: MyTopBarWithBack(
              title: "Buat Acara",
            )),
          ),
          Expanded(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: template['tipe'] == 1
                    ? InputWeddingFirst(
                        dataCome: {'template': template, 'user': curUser},
                      )
                    : template['tipe'] == 2
                        ? InputWeddingSecond(
                  dataCome: {'template': template, 'user': curUser},
                )
                        : template['tipe'] == 3
                            ? InputBirthdayFirst(dataCome: {'template': template, 'user': curUser},)
                            : template['tipe'] == 4
                                ? InputBirthdaySecond(dataCome: {'template': template, 'user': curUser},)
                                : InputBirthdatThird(dataCome: {'template': template, 'user': curUser})
                ),
          )
        ],
      ),
    );
  }
}
