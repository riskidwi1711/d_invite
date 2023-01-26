import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:d_invite/components/button.dart';
import 'package:d_invite/components/confusingComp.dart';
import 'package:d_invite/components/textFormField.dart';
import 'package:d_invite/const/designHelper.dart';
import 'package:d_invite/const/function/mainFunc.dart';
import 'package:d_invite/page/setUpAmplop.dart';

class InputBirthdayFirst extends StatefulWidget {
  final dataCome;
  InputBirthdayFirst({this.dataCome});
  @override
  _InputBirthdayFirstState createState() =>
      _InputBirthdayFirstState(this.dataCome);
}

class _InputBirthdayFirstState extends State<InputBirthdayFirst> {
  var dataCome;
  var date;
  var time;
  bool isLoading = false;
  _InputBirthdayFirstState(this.dataCome);

  //declare form key as global key
  final _formKey = GlobalKey<FormState>();

  //declare text editing controller
  TextEditingController umur = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController tanggalDimulai =
      new TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

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
      'name': nama.text,
      'age': umur.text,
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
                    title: 'Ulang Tahun ke',
                    txtForm: MyTextForm(
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: umur,
                      hintText: 'Masukan umur sekarang',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: nama,
                      hintText: 'Masukan nama',
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

class InputBirthdaySecond extends StatefulWidget {
  final dataCome;
  InputBirthdaySecond({this.dataCome});
  @override
  _InputBirthdaySecondState createState() =>
      _InputBirthdaySecondState(this.dataCome);
}

class _InputBirthdaySecondState extends State<InputBirthdaySecond> {
  var dataCome;
  var date;
  var time;
  bool isLoading = false;
  _InputBirthdaySecondState(this.dataCome);

  //declare form key as global key
  final _formKey = GlobalKey<FormState>();

  //declare text editing controller
  TextEditingController umur = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController timeEdit = new TextEditingController(
      text: DateFormat.Hm().format(DateTime(
          2000, 09, 05, TimeOfDay.now().hour, TimeOfDay.now().minute)));
  TextEditingController tanggalDimulai =
      new TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

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
      'name': nama.text,
      'age': umur.text,
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
                    title: 'Ulang Tahun ke',
                    txtForm: MyTextForm(
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: umur,
                      hintText: 'Masukan umur sekarang',
                    ),
                  ),
                  MyTxtFormWithTitle(
                    title: 'Nama',
                    txtForm: MyTextForm(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Isi dengan benar';
                        }
                      },
                      textEditingController: nama,
                      hintText: 'Masukan nama',
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
                      hintText: 'Masukan alamat',
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

class InputBirthdatThird extends StatefulWidget {
  final dataCome;
  InputBirthdatThird({this.dataCome});

  @override
  _InputBirthdatThirdState createState() => _InputBirthdatThirdState(this.dataCome);
}

class _InputBirthdatThirdState extends State<InputBirthdatThird> {

  var dataCome;
  var date;
  var time;
  bool isLoading = false;
  _InputBirthdatThirdState(this.dataCome);

  //declare form key as global key
  final _formKey = GlobalKey<FormState>();

  //declare text editing controller
  TextEditingController umur = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController alamat = new TextEditingController();
  TextEditingController timeEdit = new TextEditingController(
      text: DateFormat.Hm().format(DateTime(
          2000, 09, 05, TimeOfDay.now().hour, TimeOfDay.now().minute)));
  TextEditingController tanggalDimulai =
  new TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

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
      'name': nama.text,
      'age': umur.text,
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
              title: 'Ulang Tahun ke',
              txtForm: MyTextForm(
                type: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi dengan benar';
                  }
                },
                textEditingController: umur,
                hintText: 'Masukan umur sekarang',
              ),
            ),
            MyTxtFormWithTitle(
              title: 'Nama',
              txtForm: MyTextForm(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi dengan benar';
                  }
                },
                textEditingController: nama,
                hintText: 'Masukan nama',
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
                hintText: 'Masukan alamat',
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
