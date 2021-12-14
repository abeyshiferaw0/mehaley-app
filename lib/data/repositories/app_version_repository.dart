import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/app_version_provider.dart';

class AppVersionRepository {
  //INIT PROVIDER FOR API CALL
  final AppVersionProvider appVersionProvider;

  const AppVersionRepository({required this.appVersionProvider});

  Future<String> getMinAppVersion() async {
    final String minAppVersion;

    // Response response = await appVersionProvider.getMinAppVersion();
    //
    // //PARSE ALBUM
    // minAppVersion = response.data['min_app_version'];

    return "0.0.0";
  }

  Future<void> saveMinAppVersion(String minVersion) async {
    await AppHiveBoxes.instance.systemUpdate
        .put(AppValues.minAppVersionKey, minVersion);
    return;
  }

  cancelDio() {
    appVersionProvider.cancel();
  }
}
