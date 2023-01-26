import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/confusingComp.dart';

import '../setUpAmplop.dart';

class InputWeddingFirst extends StatefulWidget {
  final dataCome;
  InputWeddingFirst({this.dataCome});

  @override
  _InputWeddingFirstState createState() =>
      _InputWeddingFirstState(this.dataCome);
}

class _InputWeddingFirstState extends State<InputWeddingFirst> {
  var dataCome;
  _InputWeddingFirstState(this.dataCome);
  final _formKey = GlobalKey<FormState>();

  //declare variable
  var date;
  var time;
  bool isLoading = false;

  //textEditingController
  TextEditingController namaAcara = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController tanggalDimulai =
      new TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController nohandphone = new TextEditingController();
  TextEditingController timeEdit = new TextEditingController(
      text: DateFormat.Hm().format(DateTime(
          2000, 09, 05, TimeOfDay.now().hour, TimeOfDay.now().minute)));
  TextEditingController bin = new TextEditingController();
  TextEditingController binti = new TextEditingController();
  TextEditingController pria = new TextEditingController();
  TextEditingController wanita = new TextEditingController();
  TextEditingController place = new TextEditingController();

  handleProccess() async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var inputData = {
      'tipe': dataCome['template']['tipe'],
      'uid': dataCome['user']['id'],
      'template': dataCome['template']['nama_file'],
      'pria': pria.text,
      'wanita': wanita.text,
      'bin': bin.text,
      'binti': binti.text,
      'place': place.text,
      'addr': alamat.text,
      'time': timeEdit.text,
      'date': date != null ? date.toString() : DateTime.now().toString(),
      'nama_acara': namaAcara.text,
      'no_handphone': nohandphone.text
    };
    await MainFunc()
        .templateProccessing(inputData)
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => SetUpAmplop(createdInvitation: value))))
        .onError((error, stackTrace) => print(error));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height - 90,
            width: MediaQuery.of(context).size.width,
            child: WaitingComp(
              title: 'Mohon tunggu..',
            ))
        : Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTxtFormWithTitle(
                    title: 'Nama Acara',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: namaAcara,
                      hintText: 'Masukan nama acara',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Alamat',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: alamat,
                      hintText: 'Masukan detail alamat',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Tempat',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: place,
                      hintText: 'Masukan nama tempat',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Tanggal Dimulai',
                    txtForm: InkWell(
                      onTap: () async {
                        await MainFunc().selectDate(context).then((value) {
                          if (this.mounted) {
                            setState(() {
                              date = value;
                              tanggalDimulai.text =
                                  DateFormat.yMMMd().format(value);
                            });
                          }
                        });
                      },
                      child: MyTextForm(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi dengan benar';
                          }
                        },
                        enable: false,
                        textEditingController: tanggalDimulai,
                        hintText: 'Masukan tanggal dimulai',
                      ),
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Waktu Dimulai',
                    txtForm: InkWell(
                      onTap: () async {
                        await MainFunc().selectTime(context).then((value) {
                          if (this.mounted) {
                            setState(() {
                              date = value;
                              timeEdit.text = DateFormat.Hm().format(DateTime(
                                  2019, 08, 1, value.hour, value.minute));
                            });
                          }
                        });
                      },
                      child: MyTextForm(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi dengan benar';
                          }
                        },
                        enable: false,
                        textEditingController: timeEdit,
                        hintText: 'Masukan waktu dimulai',
                      ),
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'No Handphone',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      type: TextInputType.phone,
                      textEditingController: nohandphone,
                      hintText: 'Masukan no handphone',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Mempelai Pria',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: pria,
                      hintText: 'Masukan nama mempelai wanita',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Ayah',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: bin,
                      hintText: 'Masukan nama ayah dari mempelai pria',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Mempelai Wanita',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: wanita,
                      hintText: 'Masukan nama mempelai wanita',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Ayah',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: binti,
                      hintText: 'Masukan nama ayah dari mempelai wanita',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyFlatButton(
                    btnHeight: 30,
                    btnFunc: () {
                      if (_formKey.currentState!.validate()) {
                        handleProccess();
                      }
                    },
                    btnName: 'Proses',
                    btnColor: Color(gradientTwo),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
  }
}

class InputWeddingSecond extends StatefulWidget {
  final dataCome;
  InputWeddingSecond({this.dataCome});
  @override
  _InputWeddingSecondState createState() =>
      _InputWeddingSecondState(this.dataCome);
}

class _InputWeddingSecondState extends State<InputWeddingSecond> {
  var dataCome;
  var date;
  var time;
  bool isLoading = false;
  _InputWeddingSecondState(this.dataCome);

  //declare form key as global key
  final _formKey = GlobalKey<FormState>();

  //declare text editing controller
  TextEditingController namaAcara = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController tanggalDimulai =
      new TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  TextEditingController nohandphone = new TextEditingController();
  TextEditingController timeEdit = new TextEditingController(
      text: DateFormat.Hm().format(DateTime(
          2000, 09, 05, TimeOfDay.now().hour, TimeOfDay.now().minute)));
  TextEditingController bin = new TextEditingController();
  TextEditingController binti = new TextEditingController();
  TextEditingController pria = new TextEditingController();
  TextEditingController wanita = new TextEditingController();
  TextEditingController place = new TextEditingController();

  handleProccess() async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var inputData = {
      'tipe': dataCome['template']['tipe'],
      'uid': dataCome['user']['id'],
      'template': dataCome['template']['nama_file'],
      'pria': pria.text,
      'wanita': wanita.text,
      'place': place.text,
      'addr': alamat.text,
      'time': timeEdit.text,
      'date': date != null ? date.toString() : DateTime.now().toString(),
    };
    await MainFunc().templateProccessing(inputData).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => SetUpAmplop(createdInvitation: value)));
    }).onError((error, stackTrace) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height - 90,
            width: MediaQuery.of(context).size.width,
            child: WaitingComp(
              title: 'Mohon tunggu..',
            ))
        : Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTxtFormWithTitle(
                    title: 'Alamat',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: alamat,
                      hintText: 'Masukan detail alamat',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Tempat',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: place,
                      hintText: 'Masukan nama tempat',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Tanggal Dimulai',
                    txtForm: InkWell(
                      onTap: () async {
                        await MainFunc().selectDate(context).then((value) {
                          if (this.mounted) {
                            setState(() {
                              date = value;
                              tanggalDimulai.text =
                                  DateFormat.yMMMd().format(value);
                            });
                          }
                        });
                      },
                      child: MyTextForm(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi dengan benar';
                          }
                        },
                        enable: false,
                        textEditingController: tanggalDimulai,
                        hintText: 'Masukan tanggal dimulai',
                      ),
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Waktu Dimulai',
                    txtForm: InkWell(
                      onTap: () async {
                        await MainFunc().selectTime(context).then((value) {
                          if (this.mounted) {
                            setState(() {
                              date = value;
                              timeEdit.text = DateFormat.Hm().format(DateTime(
                                  2019, 08, 1, value.hour, value.minute));
                            });
                          }
                        });
                      },
                      child: MyTextForm(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi dengan benar';
                          }
                        },
                        enable: false,
                        textEditingController: timeEdit,
                        hintText: 'Masukan waktu dimulai',
                      ),
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Mempelai Pria',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: pria,
                      hintText: 'Masukan nama mempelai wanita',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama Mempelai Wanita',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: wanita,
                      hintText: 'Masukan nama mempelai wanita',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyFlatButton(
                    btnHeight: 30,
                    btnFunc: () {
                      if (_formKey.currentState!.validate()) {
                        handleProccess();
                      }
                    },
                    btnName: 'Proses',
                    btnColor: Color(gradientTwo),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
  }
}
