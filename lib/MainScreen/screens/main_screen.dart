import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_app.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_firestore.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_storage.dart';
import 'package:prototyp_flutter/File/Model/model_file.dart';
import 'package:prototyp_flutter/MainScreen/logics/uploadFile.dart';
import 'package:prototyp_flutter/MainScreen/widgets/setting_file_name.dart';
import 'package:prototyp_flutter/MainScreen/widgets/uploading_file.dart';
import 'package:prototyp_flutter/MainScreen/widgets/viewing_file.dart';
import 'package:prototyp_flutter/widgets/background.dart';
import 'package:prototyp_flutter/widgets/button.dart';
import 'package:prototyp_flutter/widgets/custom_dialog.dart';

List<ModelFile> _allFiles = [];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  late AppBloc appBloc;
  late FirestoreBloc firestoreBloc;
  late StorageBloc storageBloc;

  bool _settingFileName = false, _viewingFile = false;
  int _editingFile = 0;
  String _fileName = "", _userName = "", _description = "";
  int _viewingFileNum = -1;
  int sortByMode = 0;

  int _initState = 0;

  final page_controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    //init Blocs
    appBloc = BlocProvider.of(context);
    firestoreBloc = appBloc.firestoreBloc;
    storageBloc = appBloc.storageBloc;
    //get all files on database
    if (_initState == 0) {
      firestoreBloc.getAllFiles().then((allFiles) {
        setState(() {
          _initState++;
          _allFiles = allFiles;
          _allFiles.sort((a, b) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          sortByMode = 1;
        });
      });
    }
    //actual screen content
    if (_initState == 1) {
      return mainScreenContent();
    } else {
      return loadingMainScreen();
    }
  }

  Widget mainScreenContent() {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
            child: Column(
              children: [
                const Spacer(),
                const Text("Saved Files", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center),
                const SizedBox(height: 15),
                filesTable(),
                const SizedBox(height: 15),
                const Text("Sort by...", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20), textAlign: TextAlign.center),
                Row(
                  children: [
                    const Spacer(),
                    Button(
                      bgColor: sortByMode == 1 ? Colors.red : null,
                      text: "by File Name",
                      onTap: () {
                        _allFiles.sort((a, b) {
                          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                        });
                        setState(() {
                          sortByMode = 1;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Button(
                      bgColor: sortByMode == 2 ? Colors.red : null,
                      text: "by User Name",
                      onTap: () {
                        _allFiles.sort((a, b) {
                          return a.user.toLowerCase().compareTo(b.user.toLowerCase());
                        });
                        setState(() {
                          sortByMode = 2;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Button(
                      bgColor: sortByMode == 3 ? Colors.red : null,
                      text: "by Date",
                      onTap: () {
                        _allFiles.sort((a, b) {
                          return a.getUploadDate().toLowerCase().compareTo(b.getUploadDate().toLowerCase());
                        });
                        setState(() {
                          sortByMode = 3;
                        });
                      },
                    ),
                    const Spacer()
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Spacer(),
                    Button(
                      bgColor: Colors.orange,
                      text: "Upload New File",
                      onTap: () {
                        setState(() {
                          _fileName = "";
                          _settingFileName = true;
                        });
                      },
                    ),
                    const Spacer()
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          Visibility(
            visible: _settingFileName,
            child: SettingFileNames(
              onCancel: () {
                setState(() {
                  _settingFileName = false;
                  _editingFile = 0;
                });
              },
              onNameTextChanged: (fileName) {
                _fileName = fileName;
              },
              onUserTextChanged: (userName) {
                _userName = userName;
              },
              onDescriptionTextChanged: (description) {
                _description = description;
              },
              onEnd: () {
                setState(() {
                  _settingFileName = false;
                  _editingFile = 1;
                });
                //actual file upload
                pickAndUploadFile(storageBloc, _fileName, context).then((extension) {
                  firestoreBloc.addFile(_fileName, _userName, _description, extension).then((isOk) {
                    setState(() {
                      _editingFile = 0;
                      _initState = 0;
                    });
                  });
                });
              },
            ),
          ),
          Visibility(
            visible: _viewingFile,
            child: ViewingFile(
              file: _viewingFileNum < 0 ? null : _allFiles[_viewingFileNum],
              onCancel: () {
                setState(() {
                  _viewingFileNum = -1;
                  _viewingFile = false;
                });
              },
              onOpen: () async {
                await storageBloc.getFile(_allFiles[_viewingFileNum].name, _allFiles[_viewingFileNum].extension).then((downloadedFile) async {
                  if (downloadedFile != null) {
                    OpenFile.open(downloadedFile.path);
                  }
                  setState(() {
                    _viewingFileNum = -1;
                    _viewingFile = false;
                    _editingFile = 0;
                  });
                });
              },
              onDelete: () async {
                setState(() {
                  _editingFile = -1;
                });
                await storageBloc.deleteFile(_allFiles[_viewingFileNum].name, _allFiles[_viewingFileNum].extension).then((isOk) async {
                  await firestoreBloc.removeFile(_allFiles[_viewingFileNum].id).then((isOk) {
                    List<VoidCallback?> buttonActions = [null];
                    List<String> buttonTexts = [GENERAL_OK];
                    showDialog(
                      context: context,
                      builder: (_) => CustomDialog(title: "File Correctly Deleted", msg: "", buttonActions: buttonActions, buttonTexts: buttonTexts),
                      barrierDismissible: true,
                    );
                    setState(() {
                      _viewingFileNum = -1;
                      _viewingFile = false;
                      _editingFile = 0;
                      _initState = 0;
                    });
                  });
                });
              },
            ),
          ),
          Visibility(
            visible: _editingFile != 0,
            child: UploadingFile(mode: _editingFile),
          ),
        ],
      ),
    );
  }

  Widget loadingMainScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          const Center(
            child: CircularProgressIndicator(
              color: CIRCULAR_WAITING,
            ),
          ),
        ],
      ),
    );
  }

  Widget oldFilesTable() {
    List<TableRow> allTableRows = [];
    //Titles
    TableRow titlesRow = const TableRow(
      children: [
        Text("", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("File Name", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Description", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Uploaded By", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Upload Date", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
    allTableRows.add(titlesRow);
    //Files
    for (int i = 0; i < _allFiles.length; i++) {
      TableRow fileRow = TableRow(
        children: [
          //extension: xml, pdf, jpeg
          Icon(_allFiles[i].extension == "xml" ? MdiIcons.xml : (_allFiles[i].extension == "pdf" ? MdiIcons.filePdfBox : Boxicons.bxs_file_jpg)),
          InkWell(
            child: Text(_allFiles[i].name + "." + _allFiles[i].extension, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 88, 160))),
            onTap: () {
              setState(() {
                _viewingFileNum = i;
                _viewingFile = true;
              });
            },
          ),
          Text(_allFiles[i].description, textAlign: TextAlign.center),
          Text(_allFiles[i].user, textAlign: TextAlign.center),
          Text(_allFiles[i].getUploadDate(), textAlign: TextAlign.center),
        ],
      );
      allTableRows.add(fileRow);
    }
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Table(
        columnWidths: const {0: FractionColumnWidth(.1)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: allTableRows,
        border: TableBorder.all(),
      ),
    );
  }

  Widget filesTable() {
    List<List<TableRow>> allTableRows = [];
    int numTables = (_allFiles.length / 5).ceil();
    for (int j = 0; j < numTables; j++) {
      allTableRows.add([]);
    }
    //Titles
    TableRow titlesRow = TableRow(
      children: [
        Container(margin: const EdgeInsets.only(top: 5, bottom: 5), child: const Text("", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
        const Text("File Name", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("Description", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("Uploaded By", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("Upload Date", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
    for (int j = 0; j < numTables; j++) {
      allTableRows[j].add(titlesRow);
    }
    //Files
    for (int i = 0; i < _allFiles.length; i++) {
      TableRow fileRow = TableRow(
        children: [
          //extension: xml, pdf, jpeg
          Container(margin: const EdgeInsets.only(top: 5, bottom: 5), child: Icon(_allFiles[i].extension == "xml" ? MdiIcons.xml : (_allFiles[i].extension == "pdf" ? MdiIcons.filePdfBox : Boxicons.bxs_file_jpg))),
          InkWell(
            child: Text(_allFiles[i].name + "." + _allFiles[i].extension, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 67, 122))),
            onTap: () {
              setState(() {
                _viewingFileNum = i;
                _viewingFile = true;
              });
            },
          ),
          Text(_allFiles[i].description, textAlign: TextAlign.center),
          Text(_allFiles[i].user, textAlign: TextAlign.center),
          Text(_allFiles[i].getUploadDate(), textAlign: TextAlign.center),
        ],
      );
      allTableRows[(i / 5).floor()].add(fileRow);
    }
    List<Widget> tables = [];
    for (int j = 0; j < numTables; j++) {
      tables.add(
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Table(
            columnWidths: const {0: FractionColumnWidth(.1)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: allTableRows[j],
            border: TableBorder.all(),
          ),
        ),
      );
    }
    return Flexible(
      child: Container(
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: page_controller,
          children: tables,
        ),
      ),
    );
  }
}
