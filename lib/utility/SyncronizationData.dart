import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:jaljeevanmissiondynamic/database/DataBaseHelperJalJeevan.dart';

import '../localdatamodel/Villagelistdatalocaldata.dart';

class SyncronizationData {
  static Future<bool> isInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  final conn = DatabaseHelperJalJeevan.instance;

  Future<List<Villagelistlocaldata>> fatchvillagelist() async {
    var dbClient = await conn.db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('jaljeevanvillagelisttable');
    return queryResult.map((e) => Villagelistlocaldata.fromMap(e)).toList();
  }
}
