import 'dart:io';

import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/dashboard/provider/feed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../synthese/widgets/filters.dart';
import '../provider/init_provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;
  bool failedToFetch = false;
  Map dataToSend = {};
  int? site;
  String? siteName;
  Map? themeValue;
  String? observStatus;
  DateTime date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime time = DateTime(
    0,
    0,
    0,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
    DateTime.now().millisecond,
    DateTime.now().microsecond,
  );
  final TextEditingController postController = TextEditingController();
  File? _selectedImage;

// SITES GETTER
  void siteGetter(siteId, siteNm) {
    setState(() {
      site = siteId;
      siteName = siteNm;
    });
  }

// Theme observation
  final List observThemes = [
    {
      "val": 'sanitaire',
      "index": 1,
      'children': [
        'Passage viral',
        'Rappel vaccination',
      ]
    },
    {
      "val": 'services généraux',
      "index": 2,
      'children': [
        'Électricité',
        'Eau',
        'Équipements/Matériels',
      ],
    },
    {
      "val": 'météo',
      "index": 3,
      'children': [
        'Coup de chaleur',
        'Chute de neige',
      ],
    },
    {
      "val": "usine d'aliment",
      "index": 4,
      'children': [
        'Supplémentation additifs',
        'Stockage fond de silo',
        'Changement marteaux',
        'Changement grille',
      ],
    },
    {
      "val": "MP & FP",
      "index": 5,
      'children': [
        'Nouveau fournisseur',
        'Nouvelle MP',
        'Analyse MP',
        'Analyse PF',
        'Granulométrie',
      ],
    },
    {
      "val": "Formulation",
      "index": 6,
      'children': [
        'Nouveau canvas',
        'Nouveau primixeur',
        'Nouvelle liste prix MP',
      ],
    },
  ];
  void themeGetter(val) {
    setState(() {
      themeValue = val;
    });
  }

  void statusGetter(val) {
    setState(() {
      observStatus = val;
    });
  }

  // IMG PICKER
  Future _pickImage() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImg == null) {
      return;
    }
    setState(() {
      _selectedImage = File(returnedImg.path);
    });
  }

// TAKE IMG WITH
  Future _takeImage() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImg == null) {
      return;
    }
    setState(() {
      _selectedImage = File(returnedImg.path);
    });
  }

// TAKE IMG WITH
  void clearImg() {
    setState(() {
      _selectedImage!.delete();
      _selectedImage = null;
    });
  }

// DATE + TIME
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

// SUBMIT DATA
  void addNewPost(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<FeedProvider>(context, listen: false).addNewPost(_selectedImage, dataToSend).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            addNewPost(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec d'envoyer les données",
          "Réessayer",
          true,
          addNewPost,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List sites = Provider.of<InitProvider>(context, listen: false).slidesData.map((e) {
      return {
        "siteId": e.siteId,
        "siteName": e.siteName
      };
    }).toList();
    sites.insert(0, {
      "siteId": false,
      "siteName": "GLOBAL"
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Quoi de neuf ?",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const Divider(),
              // SITES SELECT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Site"),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      Filters.showActionSheet(context, sites, siteGetter);
                    },
                    child: Text(siteName ?? "GLOBAL"),
                  )
                ],
              ),
              const Divider(),
              // THEME SELECT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Thème"),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      Filters.showObservThemeActionSheet(context, observThemes, themeGetter);
                    },
                    child: Text(themeValue != null ? themeValue!["val"] : "----"),
                  )
                ],
              ),
              const Divider(),
              // THEME SELECT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Observation"),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      Filters.showSameValuesActionSheet(context, themeValue == null ? [] : themeValue!["children"], statusGetter);
                    },
                    child: Text(observStatus ?? "----"),
                  )
                ],
              ),
              const Divider(),
              // Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Date"),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      _showDialog(
                        CupertinoDatePicker(
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() => date = newDate);
                          },
                        ),
                      );
                    },
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(date),
                    ),
                  )
                ],
              ),
              const Divider(),
              // DATE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Heure"),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      _showDialog(
                        CupertinoDatePicker(
                          initialDateTime: time,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => time = newTime);
                          },
                        ),
                      );
                    },
                    child: Text(
                      DateFormat('HH:mm').format(time),
                    ),
                  )
                ],
              ),
              const Divider(),
              // CONTENT
              SizedBox(
                height: 200,
                child: TextFormField(
                  controller: postController,
                  maxLines: 10,
                  minLines: null,
                  maxLength: 300,
                  // expands: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(6),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.amber,
                  textInputAction: TextInputAction.newline,
                  validator: (val) {
                    if (val != null && val.isEmpty) {
                      return "field can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              // IMAGE  PICKER
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Importer des images"),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            child: const Icon(
                              Icons.publish,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _takeImage();
                            },
                            child: const Icon(
                              Icons.photo_camera,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(4)),
                      height: 100,
                      width: double.infinity,
                      child: Center(
                        child: _selectedImage != null
                            ? GestureDetector(
                                onTap: () {
                                  AlertsDialog.imageViewModal(_selectedImage, context, clearImg);
                                },
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Icon(
                                MdiIcons.imageOffOutline,
                                color: Colors.grey.shade300,
                                size: 28,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              // DATA SENDER
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text(
                    "Publier",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      dataToSend["date"] = DateFormat('yyyy-MM-dd').format(date);
                      dataToSend["time"] = DateFormat('HH:mm').format(time);
                      dataToSend["observ_text"] = observStatus ?? "";
                      dataToSend["observ_theme"] = themeValue != null ? themeValue!["index"] : "";
                      dataToSend["other"] = postController.text;
                      if (site != null) {
                        dataToSend["site"] = site;
                      }
                    });
                    addNewPost(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
