// import 'dart:convert';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:elf_play/config/themes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
//
// class DownloadTest extends StatefulWidget {
//   const DownloadTest({Key? key}) : super(key: key);
//
//   @override
//   _DownloadTestState createState() => _DownloadTestState();
// }
//
// class _DownloadTestState extends State<DownloadTest> {
//   ReceivePort _port = ReceivePort();
//
//   @override
//   void initState() {
//     super.initState();
//
//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       setState(() {});
//     });
//
//     FlutterDownloader.registerCallback(downloadCallback);
//   }
//
//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }
//
//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send!.send([id, status, progress]);
//     print('DOWNLOAD => id$id  $status $progress');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FlatButton(
//               color: AppColors.green,
//               onPressed: () async {
//                 Directory directory = await getApplicationSupportDirectory();
//                 String ddd = directory.absolute.path;
//
//                 /////////
//
//                 /////////
//
//                 List<FileSystemEntity> entities = directory.listSync();
//
//                 entities.forEach((element) {
//                   print('DOWNLOADING  ${element}');
//                 });
//
//                 // File f = File('$ddd/testt.mov');
//                 // if (f.existsSync()) {
//                 //   print('DOWNLOADING  FOUNEDEDED');
//                 // } else {
//                 //   print('DOWNLOADING   NOT FOUNEDE XXS');
//                 // }
//               },
//               child: (Text('Check file')),
//             ),
//             FlatButton(
//               color: AppColors.errorRed,
//               onPressed: () {
//                 EasyDebounce.debounce(
//                   'DOWNLOADING_TAG',
//                   Duration(seconds: 1),
//                   () {
//                     _downloadFD();
//                   },
//                 );
//               },
//               child: (Text('Download')),
//             ),
//             FlatButton(
//               color: AppColors.green,
//               onPressed: () async {
//                 final tasks = await FlutterDownloader.loadTasks();
//                 tasks!.forEach((element) {
//                   element.print('DOWNLOADING  ${element.toString()}');
//                 });
//               },
//               child: (Text('load all')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showNoti() async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 2,
//         channelKey: 'progress_bar',
//         title: 'Downloading fake file in progress ',
//         body: 'filename.txt',
//         payload: {
//           'file': 'filename.txt',
//           'path': '-rmdir c://ruwindows/system32/huehuehue'
//         },
//         notificationLayout: NotificationLayout.Inbox,
//         // progress: min((current / total * 100).round(), 100),
//         locked: true,
//       ),
//     );
//   }
//
//   void _downloadFD() async {
//     Directory? directory = await getApplicationSupportDirectory();
//
//     String ddd = directory!.path + '';
//     print('DOWNLOAD => path => $ddd');
//     final taskId = await FlutterDownloader.enqueue(
//       url:
//           'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4?obj${jsonToStr()}',
//       savedDir: ddd,
//       fileName: 'nowwwwwwwwwww.mp4',
//       showNotification:
//           true, // show download progress in status bar (for Android)
//       openFileFromNotification:
//           false, // click on notification to open downloaded file (for Android)
//     );
//   }
//
//   String jsonToStr() {
//     var j = json.encode({
//       'glossary': {
//         'title': 'example glossary',
//         'GlossDiv': {
//           'title': 'S',
//           'GlossList': {
//             'GlossEntry': {
//               'ID': 'SGML',
//               'SortAs': 'SGML',
//               'GlossTerm': 'Standard Generalized Markup Language',
//               'Acronym': 'SGML',
//               'Abbrev': 'ISO 8879:1986',
//               'GlossDef': {
//                 'para':
//                     'A meta-markup language, used to create markup languages such as DocBook.',
//                 'GlossSeeAlso': ['GML', 'XML']
//               },
//               'GlossSee': 'markup'
//             }
//           }
//         }
//       }
//     });
//     return j;
//   }
// }
