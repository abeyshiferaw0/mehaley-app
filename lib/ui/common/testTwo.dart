import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:path_provider/path_provider.dart';

class TestTwoWidget extends StatefulWidget {
  const TestTwoWidget({Key? key}) : super(key: key);

  @override
  State<TestTwoWidget> createState() => _TestTwoWidgetState();
}

class _TestTwoWidgetState extends State<TestTwoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(FlutterRemix.user_fill),
          onPressed: () {
            dowbload();
          },
        ),
      ),
    );
  }

  Future<String> getSaveDir() async {
    Directory directory = await getApplicationSupportDirectory();
    Directory saveDir = Directory(
      '${directory.absolute.path}${Platform.pathSeparator}${AppValues.folderMedia}${Platform.pathSeparator}${AppValues.folderSongs}${Platform.pathSeparator}',
    );
    bool exists = await saveDir.exists();
    if (!exists) {
      await saveDir.create(recursive: true);
    }
    return saveDir.path;
  }

  dowbload() async {
    var dio = Dio();
    //dio.interceptors.add(LogInterceptor());
    // This is big file(about 200M)
    //   var url = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";
    var url =
        'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_2MG.mp3';

    String saveDir = await getSaveDir();

    try {
      var response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
          }
        },
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      print(response.headers);
      var file = File("$saveDir/file.jpg");
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      print("file.existsSync()=> ${file.existsSync()}");
    } catch (e) {
      print(e);
    }
  }
}
