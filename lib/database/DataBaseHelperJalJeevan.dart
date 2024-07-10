import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/LocalSIBsavemodal.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/Localmasterdatamodal.dart';
import 'package:jaljeevanmissiondynamic/model/GetSourceCategoryModal.dart';
import 'package:jaljeevanmissiondynamic/model/Myresponse.dart';
import 'package:jaljeevanmissiondynamic/model/Saveoffinevillagemodal.dart';
import 'package:jaljeevanmissiondynamic/model/Schememodal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import '../localdatamodel/Localpwspendinglistmodal.dart';
import '../localdatamodel/Localpwssourcemodal.dart';
import '../model/LocalOtherassetsofflinesavemodal.dart';
import '../model/LocalStoragestructureofflinesavemodal.dart';
import '../model/Savesourcetypemodal.dart';

class DatabaseHelperJalJeevan {
  static Database? _database;

  DatabaseHelperJalJeevan.internal();

  static final DatabaseHelperJalJeevan instance =
  new DatabaseHelperJalJeevan.internal();
  static final String localmasterdatatable = 'localmasterdatatable';

  factory DatabaseHelperJalJeevan() => instance;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabse();
    return _database;
  }

  initDatabse() async {
    io.Directory documentryDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentryDirectory.path, 'JalJeevanMission.db');
    var db = await openDatabase(path, version: 6, onCreate: _oncreate);
    return db;
  }

  _oncreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE sourcetypecategorytable (id INTEGER PRIMARY KEY, Result TEXT)');
    await db.execute(
        'CREATE TABLE dashboarddynamictable (id INTEGER PRIMARY KEY, Result TEXT)');
    await db.execute(
        "CREATE TABLE sourcassettypetable(id INTEGER PRIMARY KEY AUTOINCREMENT , Result Text)");
    await db.execute(
        "CREATE TABLE schemelisttable(id INTEGER PRIMARY KEY AUTOINCREMENT , schemelist Text)");
    await db.execute(
        "CREATE TABLE villagedetailstable(id INTEGER PRIMARY KEY AUTOINCREMENT , Result Text)");
    await db.execute(
        "CREATE TABLE jaljeevanvillagelisttable(id INTEGER PRIMARY KEY AUTOINCREMENT , Villagelist Text)");
    await db.execute(
        "CREATE TABLE jaljeevanofflinevillages(id INTEGER PRIMARY KEY AUTOINCREMENT , Villagelist Text)");

    await db.execute(
        "CREATE TABLE localmasterdatatable(id INTEGER PRIMARY KEY AUTOINCREMENT , "
            " userId TEXT,villageId TEXT,villageName TEXT, stateId TEXT  )");

    await db.execute(
        "CREATE TABLE localmastervilagedetailstable(id INTEGER PRIMARY KEY AUTOINCREMENT , "
            " status TEXT ,  stateName TEXT ,   districtName TEXT ,    blockName TEXT , "
            " panchayatName TEXT ,StateId TEXT, UserId TEXT, villageId TEXT,  villageName TEXT , totalNoOfScheme TEXT  ,  "
            " totalNoOfWaterSource TEXT, totalWsGeoTagged TEXT, pendingWsTotal TEXT, "
            " balanceWsTotal TEXT, totalSsGeoTagged TEXT, pendingApprovalSsTotal TEXT, "
            " totalIbRequiredGeoTagged TEXT, totalIbGeoTagged TEXT, pendingIbTotal TEXT, "
            " balanceIbTotal TEXT, totalOaGeoTagged TEXT, balanceOaTotal TEXT, "
            " totalNoOfSchoolScheme TEXT, totalNoOfPwsScheme TEXT  )");


    await db.execute(
        "CREATE TABLE localmasterschemelist(id INTEGER PRIMARY KEY AUTOINCREMENT , "
            " SchemeId TEXT, VillageId TEXT, Schemename TEXT, Category TEXT  "
            " )");

    await db.execute(
        "CREATE TABLE localhabitaionlisttable(id INTEGER PRIMARY KEY AUTOINCREMENT , "
            " VillageId TEXT, HabitationId TEXT, HabitationName TEXT "
            " )");

    await db.execute(
        "CREATE TABLE localmastersourcelistdetailstable(id INTEGER PRIMARY KEY AUTOINCREMENT , "
            " SchemeId TEXT, SourceId TEXT,VillageId TEXT, Schemename TEXT,SourceTypeId TEXT, sourceTypeCategoryId TEXT, "
            " habitationId TEXT, existTagWaterSourceId TEXT, isApprovedState TEXT, landmark TEXT, latitude TEXT, "
            " longitude TEXT, habitationName TEXT, location TEXT, sourceTypeCategory TEXT, sourceType TEXT,StateName TEXT, DistrictName TEXT, BlockName TEXT,PanchayatName TEXT, districtId TEXT, "
            " VillageName TEXT, stateid TEXT "
            " )");

    await db.execute(
        "CREATE TABLE Local_PWSSavedatato_server(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "Userid TEXT, Villageid TEXT, Assettaggingid TEXT, Stateid TEXT, Schemeid TEXT,schemename TEXT , blockName TEXT ,villageName TEXT,sourceName TEXT,sourceType TEXT,panchayatName TEXT, sourceTypeCategoryId TEXT, DivisionId TEXT, "
            "habitationName TEXT,habitationId TEXT,  landmark TEXT, latitude TEXT, "
            "longitude TEXT, Accuracy TEXT, Image TEXT, SourceId TEXT,subsourceaddnew TEXT , Status TEXT,Date TEXT"
            ")");

    await db.execute(
        "CREATE TABLE Local_PWSSavedata_pendinglist(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "schemename TEXT, imageUrl TEXT, stateId TEXT, villageId TEXT, districtName TEXT, blockName TEXT, panchayatname TEXT, "
            "villageName TEXT, sourceName TEXT, sourceType TEXT,location TEXT, latitude TEXT, longitude TEXT, habitationName TEXT,  sourceCatogery TEXT, status TEXT )");

    await db.execute(
        "CREATE TABLE sibsavedatatable(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "UserId TEXT, VillageId ,CapturePointTypeId TEXT,SchemeId TEXT , SchemeName TEXT ,StateId TEXT,SourceId TEXT,SourceTypeId TEXT,sourcename TEXT, DivisionId TEXT, HabitationId TEXT, HabitationName TEXT, Landmark TEXT, "
            "Latitude TEXT, Longitude TEXT, Accuracy TEXT,Photo TEXT , VillageName TEXT, DistrictName TEXT, BlockName TEXT,PanchayatName TEXT  , Status TEXT)");

    await db.execute(
        "CREATE TABLE localmaster_sibdetailstable(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "UserId TEXT, VillageId ,StateId TEXT,schemeId TEXT , DistrictName TEXT ,BlockName TEXT,PanchayatName TEXT,VillageName TEXT,HabitationName TEXT, Latitude TEXT, Longitude TEXT, SourceName TEXT, SchemeName TEXT, "
            "Message TEXT, Status TEXT)");

    await db.execute(
        "CREATE TABLE localmaster_apidatetime(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "UserId TEXT,  API_DateTime TEXT )");

    await db.execute(
        "CREATE TABLE Otherassetssavedataofflinetable(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "UserId TEXT, VillageId ,CapturePointTypeId TEXT,SchemeId TEXT , SchemeName TEXT ,StateId TEXT,SourceId TEXT,SourceTypeId TEXT,sourcename TEXT, DivisionId TEXT, HabitationId TEXT, HabitationName TEXT, Landmark TEXT, "
            "Latitude TEXT, Longitude TEXT, Accuracy TEXT,Photo TEXT , VillageName TEXT, DistrictName TEXT, BlockName TEXT,PanchayatName TEXT  , Status TEXT , Selectassetsothercategory TEXT ,Capturepointlocationot TEXT )");

    await db.execute(
        "CREATE TABLE Storagestructuresavedataofflinetable(id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "UserId TEXT, VillageId ,SchemeId TEXT , SchemeName TEXT ,StateId TEXT,SourceId TEXT,SourceTypeId TEXT,sourcename TEXT, DivisionId TEXT, HabitationId TEXT, HabitationName TEXT, Landmark TEXT, "
            "Latitude TEXT, Longitude TEXT, Accuracy TEXT,Photo TEXT , VillageName TEXT, DistrictName TEXT, BlockName TEXT,PanchayatName TEXT  , Status TEXT , Selectstoragecategory TEXT ,Storagecapacity TEXT  )");

    //await _onUpgrade(db, 5, version);
  }

  Future<void> Tableschemelistsourcetype() async {
    var dbClient = await db;
    await dbClient?.execute("ALTER TABLE localmasterschemelist ADD COLUMN source_type TEXT",
    );
    print('Table altered successfully');
  }
  Future<void> TableschemelistSourceTypeCategoryId() async {
    var dbClient = await db;
    await dbClient?.execute("ALTER TABLE localmasterschemelist ADD COLUMN SourceTypeCategoryId TEXT",
    );
    print('Table altered successfully');
  }
  Future<void> TableschemelistsourcetypeCategory() async {
    var dbClient = await db;
    await dbClient?.execute("ALTER TABLE localmasterschemelist ADD COLUMN source_typeCategory TEXT",
    );
    print('Table altered successfully');
  }

/*
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      print("Upgrading database from version $oldVersion to $newVersion...");

      // Check if the necessary columns exist in 'localmasterschemelist'
      List<Map<String, dynamic>> columns = await db.rawQuery('PRAGMA table_info(localmasterschemelist)');

      bool hasSourceTypeColumn = columns.any((column) => column['name'] == 'source_type');
      bool hasSourceTypeCategoryId = columns.any((column) => column['name'] == 'SourceTypeCategoryId');
      bool hasSource_typeCategory = columns.any((column) => column['name'] == 'source_typeCategory');

      // Add columns if they do not exist
      if (!hasSourceTypeColumn) {
        print("Adding source_type column to localmasterschemelist...");
        await db.execute('ALTER TABLE localmasterschemelist ADD COLUMN source_type TEXT');
      }
      if (!hasSourceTypeCategoryId) {
        print("Adding source_typeID column to localmasterschemelist...");
        await db.execute('ALTER TABLE localmasterschemelist ADD COLUMN SourceTypeCategoryId TEXT');
      }
      if (!hasSource_typeCategory) {
        print("Adding source_cat column to localmasterschemelist...");
        await db.execute('ALTER TABLE localmasterschemelist ADD COLUMN source_typeCategory TEXT');
      }


      print("Database upgraded successfully.");
    }
  }
*/


  Future<Localmasterdatetime> insertMasterapidatetime(
      Localmasterdatetime localmasterdatetime) async {
    var dbClient = await db;
    await dbClient!
        .insert('localmaster_apidatetime', localmasterdatetime.toMap());
    return localmasterdatetime;
  }

  Future<List<Map<String, dynamic>>> getDatatime(String userId) async {
    var dbClient = await db;
    return await dbClient!.query('localmaster_apidatetime',
        where: 'UserId = ?', whereArgs: [userId]);
  }

  Future<void> insertselecttvillageofflineDB(
      Saveoffinevillagemodal saveoffinevillagemodal) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'jaljeevanofflinevillages',
      {'Villagelist': jsonEncode(saveoffinevillagemodal.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future fetchData_fromdb_saveofflinevilage() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('jaljeevanofflinevillages');
    return List.generate(maps.length, (i) {
      final Map<String, dynamic> map = maps[i];
      return jsonDecode(map['Villagelist']);
    });
  }

  bool isDistrictNameColumnExists(List<Map<String, dynamic>> columns) {
    for (var column in columns) {
      if (column['name'] == 'districtName') {
        return true;
      }
    }
    return false;
  }

  Future<LocalPWSSavedData> insertpwssourcelocal(
      LocalPWSSavedData localPWSSavedData) async {
    var dbClient = await db;
    await dbClient!
        .insert('Local_PWSSavedatato_server', localPWSSavedData.toJson());
    return localPWSSavedData;
  }

  Future<Localmasterdatanodal> insertMastervillagelistdata(
      Localmasterdatanodal localmasterdatanodal) async {
    var dbClient = await db;
    await dbClient!
        .insert('localmasterdatatable', localmasterdatanodal.toMap());
    return localmasterdatanodal;
  }

  Future<Localmasterdatamodal_VillageDetails> insertMastervillagedetails(
      Localmasterdatamodal_VillageDetails
          localmasterdatamodal_VillageDetails) async {
    var dbClient = await db;

    await dbClient!.insert('localmastervilagedetailstable',
        localmasterdatamodal_VillageDetails.toMap());
    return localmasterdatamodal_VillageDetails;
  }

  Future<Localmasterdatamoda_Scheme> insertMasterSchmelist(
      Localmasterdatamoda_Scheme localmasterdatamoda_Scheme) async {
    var dbClient = await db;
    await dbClient!

        .insert('localmasterschemelist', localmasterdatamoda_Scheme.toMap());
    return localmasterdatamoda_Scheme;
  }

  Future<LocalmasterInformationBoardItemModal> insertmastersibdetails(
      LocalmasterInformationBoardItemModal
          localmasterInformationBoardItemModal) async {
    var dbClient = await db;
    await dbClient!.insert('localmaster_sibdetailstable',
        localmasterInformationBoardItemModal.toMap());
    return localmasterInformationBoardItemModal;
  }

  Future<LocalSourcelistdetailsModal> insertMasterSourcedetails(
      LocalSourcelistdetailsModal localSourcelistdetailsModal) async {
    var dbClient = await db;
    await dbClient!.insert('localmastersourcelistdetailstable',
        localSourcelistdetailsModal.toMap());
    return localSourcelistdetailsModal;
  }

  Future<LocalHabitaionlistModal> insertMasterhabitaionlist(
      LocalHabitaionlistModal localHabitaionlistModal) async {
    var dbClient = await db;
    await dbClient!
        .insert('localhabitaionlisttable', localHabitaionlistModal.toMap());
    return localHabitaionlistModal;
  }

  Future<List<Localmasterdatanodal>> Fatchdatafrommastertable() async {
    var dbClient = await instance.db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('localmasterdatatable');
    return queryResult.map((e) => Localmasterdatanodal.fromMap(e)).toList();
  }

 /* Future<List<Localmasterdatamoda_Scheme>>
      Fatchdatafrommastertable_Schmelist() async {
    var dbClient = await instance.db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('localmasterschemelist');
    return queryResult
        .map((e) => Localmasterdatamoda_Scheme.fromJson(e))
        .toList();
  }*/

  Future<Map<String, dynamic>?> getVillageDetailsById(String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? result = await dbClient?.query(
        'localmastervilagedetailstable',
        where: 'villageId = ?',
        whereArgs: [villageId],
      );
      if (result != null && result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<LocalSIBsavemodal>?> getsibsavedofflineentry_villageidwise(
      String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'sibsavedatatable',
        where: 'VillageId = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalSIBsavemodal.fromMap(maps[i]);
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> truncateTableByVillageId_sibsaved(String Schemeid) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.delete(
        'sibsavedatatable',
        where: 'SchemeId = ?',
        whereArgs: [Schemeid],
      );
    } catch (e) {}
  }

  Future<void> truncateTableByVillageId_pwssavedonserver(
      String schemeId) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.delete(
        'Local_PWSSavedatato_server',
        where: 'Schemeid = ?',
        whereArgs: [schemeId],
      );
    } catch (e) {}
  }

  Future<int> updateVillageDetails(Map<String, dynamic> updatedDetails) async {
    try {
      var dbClient = await instance.db;
      int? rowsUpdated = await dbClient?.update(
        'localmastervilagedetailstable',
        updatedDetails,
        where: 'villageId = ?',
        whereArgs: [updatedDetails['villageId']],
      );
      return rowsUpdated!;
    } catch (e) {
      return 0;
    }
  }

  Future<int> updateRecord(
      int id, String pendingWsTotal, String pendingIbTotal) async {
    var dbClient = await instance.db;
    return await dbClient!.update(
      'localmastervilagedetailstable',
      {'pendingWsTotal': pendingWsTotal, 'pendingIbTotal': pendingIbTotal},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>?> getDistinctHabitaion(
      String villageId) async {
    var dbClient = await instance.db;
    return await dbClient?.rawQuery(
        "SELECT DISTINCT HabitationName, HabitationId FROM localhabitaionlisttable WHERE VillageId = ? ORDER BY HabitationName ASC",
        [villageId]);
  }

  Future<List<Map<String, dynamic>>> getAllRecordsForschemelist(
      String villageId) async {
    var dbClient = await instance.db;

    String query = '''
      SELECT *
      FROM localmasterschemelist
      WHERE villageId = $villageId
    ''';
    return await dbClient!.rawQuery(query);
  }

  Future<bool> isRecordExist(int id) async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.query(
      'localmasterschemelist',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }

  Future<bool> isDuplicateEntry(String villageId) async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT COUNT(*) AS count FROM localmasterdatatable WHERE villageId = ?",
      [villageId],
    );
    final int count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  /*Future<void> removeDuplicateEntries() async {
    var dbClient = await instance.db;
    try {
      await dbClient!.transaction((txn) async {
        final List<Map<String, dynamic>> duplicates = await txn.rawQuery(
          "SELECT id, villageId FROM localmasterdatatable GROUP BY villageId HAVING COUNT(*) > 1",
        );

        for (final duplicate in duplicates) {
          final int idToKeep = duplicate['id'] as int;
          final int villageId = duplicate['villageId'] as int;

          final List<Map<String, dynamic>> entries = await txn.query(
            'localmasterdatatable',
            where: 'villageId = ?',
            whereArgs: [villageId],
          );

          for (final entry in entries) {
            final int id = entry['id'] as int;
            if (id != idToKeep) {
              await txn.delete('localmasterdatatable',
                  where: 'id = ?', whereArgs: [id]);
            }
          }
        }
      });
    } catch (e) {
      debugPrintStack();
    }
  }*/


  Future<void> removeDuplicateEntries() async {
    var dbClient = await instance
        .db;
    String query = '''
    DELETE FROM localmasterdatatable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmasterdatatable 
        GROUP BY villageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }


  Future<void> insertData_schemelist_inDB(Schememodal schememodal) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'schemelisttable',
      {'schemelist': jsonEncode(schememodal.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isRecordExists(int id) async {
    var dbClient = await instance
        .db;
    List<Map<String, dynamic>> result = await dbClient!
        .query('jaljeevanofflinevillages', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<void> upsertRecord(
      int id, Saveoffinevillagemodal saveoffinevillagemodal) async {
    var dbClient = await instance
        .db;
    List<Map<String, dynamic>> result = await dbClient!
        .query('jaljeevanofflinevillages', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      await dbClient.update(
        'jaljeevanofflinevillages',
        {'Villagelist': jsonEncode(saveoffinevillagemodal.toJson())},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await dbClient.insert(
        'jaljeevanofflinevillages',
        {'id': id, 'Villagelist': jsonEncode(saveoffinevillagemodal.toJson())},
      );
    }
  }

  Future<void> insertData_villagedetails_inDB(String data) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'villagedetailstable',
      {'Result': jsonEncode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete('jaljeevantable', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cleardb_villagedetails() async {
    var dbClient = await db;
    await dbClient!.delete('localmastervilagedetailstable');
  }

  Future<void> truncateTable_villagedetails() async {
    var dbClient = await instance
        .db;
    String query = '''
    DELETE FROM localmastervilagedetailstable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmastervilagedetailstable `
        GROUP BY villageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> clearDuplicateEntriesForSchemeId(
      String schemeId, String villageId) async {
    var dbClient = await db;
    await _removeDuplicateEntriesForSchemeId(dbClient!, schemeId, villageId);
  }

  Future<void> _removeDuplicateEntriesForSchemeId(
      Database db, String schemeId, String villageId) async {
    List<Map<String, dynamic>> schemeItems = await db.query(
      'localmasterschemelist',
      where: 'SchemeId = ? AND VillageId = ?',
      whereArgs: [schemeId, villageId],
    );
    Set<String> seenCombinations = {};
    for (Map<String, dynamic> item in schemeItems) {
      String schemeName = item['Schemename'];
      String category = item['Category'];
      String combination = '$schemeName-$category-$villageId';

      if (seenCombinations.contains(combination)) {
        int id = item['id'];
        await db
            .delete('localmasterschemelist', where: 'id = ?', whereArgs: [id]);
      } else {
        seenCombinations.add(combination);
      }
    }
  }

  Future<void> truncateTable_offlinevillages() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM jaljeevanofflinevillages
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM jaljeevanofflinevillages 
        GROUP BY Villagelist
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> duplicate_schemeremoveindb() async {
    var dbClient = await instance
        .db;
    String query = '''
    DELETE FROM localmasterschemelist
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmasterschemelist 
        GROUP BY SchemeId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> duplicate_entryofdashboarDB() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM dashboarddynamictable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM dashboarddynamictable 
        GROUP BY Result
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> cleardb_localmasterdatatable() async {
    var dbClient = await db;
    await dbClient!.delete('localmasterdatatable');
  }

  Future<void> truncateTable_localmasterdatatable() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM localmasterdatatable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmasterdatatable 
        GROUP BY villageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> cleardb_offlineviilagetable() async {
    var dbClient = await instance.db;
    await dbClient!.delete('jaljeevanofflinevillages');
  }

  Future<void> cleartable_villagelist() async {
    var dbClient = await instance.db;
    await dbClient!.delete('localmasterdatatable');
  }

  Future<void> cleartable_villagedetails() async {
    var dbClient = await instance.db;
    await dbClient!.delete('localmastervilagedetailstable');
  }

  Future<void> cleardb_localmasterschemelist() async {
    var dbClient = await instance.db;
    await dbClient!.delete('localmasterschemelist');
  }

  Future<void> cleardb_sourcetypecategorytable() async {
    var dbClient = await instance.db;
    await dbClient!.delete('sourcetypecategorytable');
  }
  Future<void> cleardb_sourcassettypetable() async {
    var dbClient = await instance.db;
    await dbClient!.delete('sourcassettypetable');
  }

  Future<void> cleardb_sourcedetailstable() async {
    var dbClient = await instance.db;
    await dbClient!.delete('localmastersourcelistdetailstable');
  }

  Future<void> cleardb_localhabitaionlisttable() async {
    var dbClient = await instance.db;
    await dbClient!.delete('localhabitaionlisttable');
  }

  Future<void> truncateTable_localmasterschemelist() async {
    var dbClient = await instance.db;

    String query = '''
    DELETE FROM localmasterschemelist
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmasterschemelist 
        GROUP BY SchemeId, VillageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> truncateTable_localmastersourcedetails() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM localmastersourcelistdetailstable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localmastersourcelistdetailstable 
        GROUP BY villageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> truncateTable_localmasterhabitaionlist() async {
    var dbClient = await instance.db;

    String query = '''
    DELETE FROM localhabitaionlisttable
    WHERE id NOT IN (
        SELECT MIN(id) 
        FROM localhabitaionlisttable 
        GROUP BY villageId
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> insertData_dashboard_inDB(Myresponse data) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'dashboarddynamictable',
      {'Result': jsonEncode(data.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Myresponse>> fetchData_fromdb_ofdashboard() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('dashboarddynamictable');
    return List.generate(maps.length, (i) {
      final Map<String, dynamic> map = maps[i];
      return Myresponse.fromJson(jsonDecode(map['Result']));
    });
  }

  Future<void> insertData_mastersourcetype_inDB(
      Savesourcetypemodal savesourcetypemodal) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'sourcassettypetable',
      {'Result': jsonEncode(savesourcetypemodal.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future fetchData_fromdb_sourceassettype() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('sourcassettypetable');
    return List.generate(maps.length, (i) {
      final Map<String, dynamic> map = maps[i];
      return jsonDecode(map['Result']);
    });
  }

  Future<void> insertData_mastersource_categorytype_inDB(
      GetSourceCategoryModal getSourceCategoryModal) async {
    var dbClient = await instance.db;
    await dbClient!.insert(
      'sourcetypecategorytable',
      {'Result': jsonEncode(getSourceCategoryModal)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future fetchData_mastersource_categorytype_inDB() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('sourcetypecategorytable');
    return List.generate(maps.length, (i) {
      final Map<String, dynamic> map = maps[i];
      return jsonDecode(map['Result']);
    });
  }

  Future<List<LocalSourcelistdetailsModal>> getAllRecords() async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result =
        await dbClient!.query('localmastersourcelistdetailstable');
    List<LocalSourcelistdetailsModal> records =
        result.map((map) => LocalSourcelistdetailsModal.fromJson(map)).toList();
    return records;
  }

  Future<List<Map<String, dynamic>>> getallrecordsourcedetails(
      String villageId) async {
    var dbClient = await instance.db;
    return await dbClient!.query('localmastersourcelistdetailstable',
        where: 'VillageId = ?', whereArgs: [villageId]);
  }

  Future<List<Map<String, dynamic>>> getallrecordsourcedetails_byschemeid(
      String SchemeId, String category, String villageId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      List<Map<String, dynamic>> result = await dbClient.rawQuery('''
      SELECT lmsld.*
      FROM localmastersourcelistdetailstable AS lmsld
      JOIN localmasterschemelist AS lmsl ON lmsld.SchemeId = lmsl.SchemeId
      WHERE lmsld.SchemeId = ? 
      AND lmsl.Category = ?
      AND lmsld.VillageId = ?   -- Added village ID check
    ''', [SchemeId, category, villageId]);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getallrecordsibdetails_byschemeid(
      String SchemeId, String category, String villageId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      List<Map<String, dynamic>> result = await dbClient.rawQuery('''
      SELECT lmsld.*
      FROM localmaster_sibdetailstable AS lmsld
      JOIN localmasterschemelist AS lmsl ON lmsld.SchemeId = lmsl.SchemeId
      WHERE lmsld.SchemeId = ? 
      AND lmsl.Category = ?
      AND lmsld.VillageId = ?   -- Added village ID check
    ''', [SchemeId, category, villageId]);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<String?> findSourceIdBySchemeId(String schemeId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      var result = await dbClient.rawQuery('''
        SELECT SourceId
        FROM localmastersourcelistdetailstable
        WHERE SchemeId = ?
      ''', [schemeId]);
      if (result.isNotEmpty) {
        return result[0]['SourceId'] as String;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> truncatetable_pwssourcesaveddata() async {
    var dbClient = await db;
    await dbClient!.delete('Local_PWSSavedatato_server');
  }

  Future<void> truncatetable_dashboardtable() async {
    var dbClient = await db;
    await dbClient!.delete('dashboarddynamictable');
  }

  Future<void> truncatetable_sibmasterdeatils() async {
    var dbClient = await db;
    await dbClient!.delete('localmaster_sibdetailstable');
  }

  Future<List<LocalPWSSavedData>> getAllLocalPWSSavedData() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('Local_PWSSavedatato_server');
      return results.map((json) => LocalPWSSavedData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> countPendingEntries() async {
    try {
      var dbClient = await instance.db;
      var count = Sqflite.firstIntValue(await dbClient!.rawQuery(
          'SELECT COUNT(*) FROM Local_PWSSavedatato_server WHERE Status = ?',
          ['Pending']));
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<LocalPWSSavedData>?> getallpwssave_villagewise(
      String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'Local_PWSSavedatato_server',
        where: 'Villageid = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalPWSSavedData.fromJson(maps[i]);
      });
    } catch (e) {
      return null;
    }
  }

  Future<Localpwspendinglistmodal> insertpwssource_pendinglist(
      Localpwspendinglistmodal localpwspendinglistmodal) async {
    var dbClient = await db;
    await dbClient!.insert(
        'Local_PWSSavedata_pendinglist', localpwspendinglistmodal.toMap());
    return localpwspendinglistmodal;
  }

  Future<List<Localpwspendinglistmodal>>
      getAllLocalpendingPWSSavedData() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('Local_PWSSavedata_pendinglist');
    return List.generate(maps.length, (i) {
      return Localpwspendinglistmodal.fromjson(maps[i]);
    });
  }

  Future<List<Localmasterdatanodal>> getAllofflinevillagelistfromdb() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps =
        await dbClient!.query('localmasterdatatable');
    return List.generate(maps.length, (i) {
      return Localmasterdatanodal.fromMap(maps[i]);
    });
  }

  Future<void> updateofflinevillage(int id, String newSchemeName) async {
    var dbClient = await instance.db;
    await dbClient!.update(
      'localmasterdatatable',
      {'villageName': newSchemeName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateVillageNameByIdAndVillageId(
      String id, String villageId, String newVillageName) async {
    var dbClient = await instance.db;
    await dbClient!.update(
      'localmasterdatatable',
      {'villageName': newVillageName},
      where: 'id = ? AND villageId = ?',
      whereArgs: [id, villageId],
    );
  }

  Future<void> insertOrUpdateDataByUserId(
      int userId, Localmasterdatanodal modal) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> existingData = await dbClient!.query(
      'localmasterdatatable',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (existingData.isNotEmpty) {
      await dbClient!.update(
        'localmasterdatatable',
        modal.toMap(),
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } else {
      await dbClient!.insert(
        'localmasterdatatable',
        modal.toMap()..['userId'] = userId,
      );
    }
  }

  Future<void> truncatetable_pwspendinglist() async {
    var dbClient = await instance.db;
    await dbClient!.delete('Local_PWSSavedata_pendinglist');
  }

  Future<Map<String, String?>> findSourceDetailsBySchemeId(
      String schemeId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      var result = await dbClient.rawQuery('''
      SELECT SourceId, sourceTypeCategoryId ,SourceTypeId, sourceType
      FROM localmastersourcelistdetailstable
      WHERE SchemeId = ?
    ''', [schemeId]);

      if (result.isNotEmpty) {
        return {
          'SourceId': result[0]['SourceId'] as String?,
          'sourceTypeCategoryId': result[0]['sourceTypeCategoryId'] as String?,
          'SourceTypeId': result[0]['SourceTypeId'] as String?,
          'sourceType': result[0]['sourceType'] as String?,
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, String?>> findSourcettypeBySchemeId(
      String schemeId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      var result = await dbClient.rawQuery('''
      SELECT source_type
      FROM localmasterschemelist
      WHERE SchemeId = ?
    ''', [schemeId]);

      if (result.isNotEmpty) {
        return {
          'source_type': result[0]['source_type'] as String?,
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
  Future<Map<String, String?>> findSourcettype_categoryidBySchemeId(
      String schemeId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      var result = await dbClient.rawQuery('''
      SELECT SourceTypeCategoryId
      FROM localmasterschemelist
      WHERE SchemeId = ?
    ''', [schemeId]);

      if (result.isNotEmpty) {
        return {
          'SourceTypeCategoryId': result[0]['SourceTypeCategoryId'] as String?,
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }


  Future<Map<String, String?>> findSourcettype_categoryBySchemeId(
      String schemeId) async {
    try {
      var dbClient = await instance.db;
      if (dbClient == null) {
        throw Exception("Database instance is null");
      }
      var result = await dbClient.rawQuery('''
      SELECT source_typeCategory
      FROM localmasterschemelist
      WHERE SchemeId = ?
    ''', [schemeId]);

      if (result.isNotEmpty) {
        return {
          'source_typeCategory': result[0]['source_typeCategory'] as String?,
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<void> deleteofflinependinglistByIndex(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Local_PWSSavedatato_server',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearRowById(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Local_PWSSavedatato_server',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> SIBclearRowById(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'sibsavedatatable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<LocalPWSSavedData>> getalllistfrompwssaveaccordingtoschemeid(
      String schemeid, String villageId) async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        'Local_PWSSavedatato_server',
        where: 'Schemeid = ? AND Villageid = ?',
        whereArgs: [schemeid, villageId]);

    return List.generate(maps.length, (i) {
      return LocalPWSSavedData.fromJson(maps[i]);
    });
  }

  Future<List<LocalSIBsavemodal>> getalllistfromSIBsaveaccordingtoschemeid(
      String schemeid, String villageId) async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        'sibsavedatatable',
        where: 'SchemeId = ? AND VillageId = ?',
        whereArgs: [schemeid, villageId]);

    return List.generate(maps.length, (i) {
      return LocalSIBsavemodal.fromMap(maps[i]);
    });
  }

  Future<void> duplicate_entryforassetsourcetypeB() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM sourcassettypetable
    WHERE id NOT IN (
        SELECT MIN(id)
        FROM sourcassettypetable 
        GROUP BY Result
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<void> duplicate_entryforsourcecategory() async {
    var dbClient = await instance.db;
    String query = '''
    DELETE FROM sourcetypecategorytable
    WHERE id NOT IN (
        SELECT MIN(id)
        FROM sourcetypecategorytable 
        GROUP BY Result
    )
  ''';
    await dbClient!.rawDelete(query);
  }

  Future<bool> isRecordExistsLocallyaddnew(String latitude, String longitude,
      String schemeId, String sourceTypeCategoryId) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT * FROM Local_PWSSavedatato_server WHERE "
      "latitude = ? AND longitude = ? AND Schemeid = ? AND sourceTypeCategoryId = ?",
      [latitude, longitude, schemeId, sourceTypeCategoryId],
    );
    return result.isNotEmpty;
  }

  Future<bool> isRecordExistsProceedtotag(
      String schemeId, String habitationId, String landmark) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT * FROM Local_PWSSavedatato_server WHERE "
      "Schemeid = ? AND habitationId = ? AND landmark = ?",
      [schemeId, habitationId, landmark],
    );
    return result.isNotEmpty;
  }

  Future<int> countRows() async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(await dbClient!
        .rawQuery('SELECT COUNT(*) FROM Local_PWSSavedatato_server'));
    return count ?? 0;
  }

  Future<int> countRows_forsib() async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(
        await dbClient!.rawQuery('SELECT COUNT(*) FROM sibsavedatatable'));
    return count ?? 0;
  }

  Future<Map<int, String>> countRowsByVillageId() async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
    SELECT VillageId, COUNT(*) AS count
    FROM sibsavedatatable
    GROUP BY VillageId
  ''');

    Map<int, String> countsByVillageId = {};
    result.forEach((row) {
      countsByVillageId[row['VillageId']] = row['count'];
    });

    return countsByVillageId;
  }

  Future<int> countRowsByVillageId_siblocal(String villageId) async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM sibsavedatatable WHERE VillageId = ?',
      [villageId],
    ));
    return count ?? 0;
  }

  Future<int> countRowsByVillageId_pwslocal(String villageId) async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM Local_PWSSavedatato_server WHERE Villageid = ?',
      [villageId],
    ));
    return count ?? 0;
  }

  Future<LocalSIBsavemodal> insertsibsaveindb(
      LocalSIBsavemodal localSIBsavemodal) async {
    var dbClient = await db;
    await dbClient!.insert('sibsavedatatable', localSIBsavemodal.toMap());
    return localSIBsavemodal;
  }



  Future<List<LocalSIBsavemodal>> getallofflineentriessib() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('sibsavedatatable');
      return results.map((json) => LocalSIBsavemodal.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearRowById_sibsavetabledb(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'sibsavedatatable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  truncatetable_sibsavetableindb() async {
    var dbClient = await db;

    return await dbClient!.rawDelete('DELETE FROM sibsavedatatable');
  }

  Future<bool> isRecordExists_insibsave(
      String schemeId, String habitationId, String landmark) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT * FROM sibsavedatatable WHERE "
      "SchemeId = ? AND HabitationId = ? AND Landmark = ?",
      [schemeId, habitationId, landmark],
    );
    return result.isNotEmpty;
  }

  Future<void> cleardb_sibmasterlist() async {
    var dbClient = await db;
    await dbClient!.delete('localmaster_sibdetailstable');
  }

  Future<List<LocalmasterInformationBoardItemModal>> getallrecordsib_masterdata(
      String schemeId, String villageId) async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(
        'localmaster_sibdetailstable',
        where: 'schemeId = ? And VillageId = ?',
        whereArgs: [schemeId, villageId]);

    return List.generate(maps.length, (i) {
      return LocalmasterInformationBoardItemModal.fromMap(maps[i]);
    });
  }

  Future<void> updateStatusInPendingList(
      String villageId, String schemeId, String status) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.update(
        'Local_PWSSavedatato_server',
        {'status': status},
        where: 'villageId = ? AND schemeId = ?',
        whereArgs: [villageId, schemeId],
      );
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> updateStatusInPendingListsib(
      String villageId, String schemeId, String status) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.update(
        'sibsavedatatable',
        {'status': status},
        where: 'villageId = ? AND schemeId = ?',
        whereArgs: [villageId, schemeId],
      );
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<List<Map<String, dynamic>>>
      pwscommonfindallrecordsameVillageIds() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
      SELECT Villageid, villageName, panchayatName, blockName, COUNT(*) as count
      FROM Local_PWSSavedatato_server
      GROUP BY Villageid
      HAVING COUNT(*) > 0
    ''');
    return result;
  }

  Future<List<Map<String, dynamic>>>
      sibcommonfindallrecordsameVillageIds() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
      SELECT VillageId, VillageName, PanchayatName, BlockName,DistrictName, COUNT(*) as count
      FROM sibsavedatatable
      GROUP BY VillageId
      HAVING COUNT(*) > 0
    ''');
    return result;
  }

  Future<void> deleteRecordsByVillageIdsib(String villageId) async {
    var dbClient = await instance.db;

    await dbClient!.delete(
      'sibsavedatatable',
      where: 'VillageId = ?',
      whereArgs: [villageId],
    );
  }

  Future<void> deleteRecordsByVillageIdpws(String villageId) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Local_PWSSavedatato_server',
      where: 'Villageid = ?',
      whereArgs: [villageId],
    );
  }

  Future<List<LocalOtherassetsofflinesavemodal>?>
      getallotherassetssave_villagewise(String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'Otherassetssavedataofflinetable',
        where: 'VillageId = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalOtherassetsofflinesavemodal.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrintStack();
      return null;
    }
  }

  Future<void> clearRowByIdot(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Otherassetssavedataofflinetable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> countRowsByVillageId_otherassetlocal(String villageId) async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM Otherassetssavedataofflinetable WHERE VillageId = ?',
      [villageId],
    ));
    return count ?? 0;
  }

  Future<LocalOtherassetsofflinesavemodal> insertotherassetsofflinesaveindb(
      LocalOtherassetsofflinesavemodal localOtherassetsofflinesavemodal) async {
    var dbClient = await db;
    await dbClient!.insert('Otherassetssavedataofflinetable',
        localOtherassetsofflinesavemodal.toMap());
    return localOtherassetsofflinesavemodal;
  }

  Future<List<LocalOtherassetsofflinesavemodal>?>
      getallotherassetssavedofflineentry_villageidwise(String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'Otherassetssavedataofflinetable',
        where: 'VillageId = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalOtherassetsofflinesavemodal.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrintStack();
      return null;
    }
  }

  Future<bool> isRecordExists_indbforotsave(
      String schemeId,
      String habitationId,
      String Latitude,
      String Longitude,
      String Selectassetsothercategory) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT * FROM Otherassetssavedataofflinetable WHERE "
      "SchemeId = ? AND HabitationId = ? AND Latitude = ? AND Longitude = ? AND Selectassetsothercategory = ?",
      [schemeId, habitationId, Latitude, Longitude, Selectassetsothercategory],
    );
    return result.isNotEmpty;
  }

  Future<bool> isRecordExists_indbforsssave(
      String schemeId,
      String habitationId,
      String Latitude,
      String Longitude,
      String Selectstoragecategory) async {
    var dbClient = await instance.db;
    List<Map<String, dynamic>> result = await dbClient!.rawQuery(
      "SELECT * FROM Storagestructuresavedataofflinetable WHERE "
      "SchemeId = ? AND HabitationId = ? AND Latitude = ? AND Longitude = ? AND Selectstoragecategory = ?",
      [schemeId, habitationId, Latitude, Longitude, Selectstoragecategory],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      otherassetscommonfindallrecordsameVillageIds() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
      SELECT VillageId, VillageName, PanchayatName, BlockName, COUNT(*) as count
      FROM Otherassetssavedataofflinetable
      GROUP BY VillageId
      HAVING COUNT(*) > 0
    ''');
    return result;
  }

  Future<void> deleteRecordsByVillageIdotherassets(String villageId) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Otherassetssavedataofflinetable',
      where: 'VillageId = ?',
      whereArgs: [villageId],
    );
  }

  Future<List<LocalOtherassetsofflinesavemodal>>
      getallofflineentriesforotherassets() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('Otherassetssavedataofflinetable');
      return results
          .map((json) => LocalOtherassetsofflinesavemodal.fromMap(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> countRowsByVillageId_sslocal(String villageId) async {
    var dbClient = await instance.db;
    final count = Sqflite.firstIntValue(await dbClient!.rawQuery(
      'SELECT COUNT(*) FROM Storagestructuresavedataofflinetable WHERE VillageId = ?',
      [villageId],
    ));
    return count ?? 0;
  }

  Future<List<LocalStoragestructureofflinesavemodal>?>
      getallstoragestructure_villagewise(String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'Storagestructuresavedataofflinetable',
        where: 'VillageId = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalStoragestructureofflinesavemodal.fromMap(maps[i]);
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<LocalStoragestructureofflinesavemodal>?>
      getallstoragestructurestructureofflineentry_villageidwise(
          String villageId) async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        'Storagestructuresavedataofflinetable',
        where: 'VillageId = ?',
        whereArgs: [villageId],
      );
      return List.generate(maps!.length, (i) {
        return LocalStoragestructureofflinesavemodal.fromMap(maps[i]);
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> truncateTableByVillageId_sssaved(String Schemeid) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.delete(
        'Storagestructuresavedataofflinetable',
        where: 'SchemeId = ?',
        whereArgs: [Schemeid],
      );
    } catch (e) {}
  }

  Future<void> updateStatusInPendingListstoragestructure(
      String villageId, String schemeId, String status) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.update(
        'Storagestructuresavedataofflinetable',
        {'Status': status},
        where: 'VillageId = ? AND SchemeId = ?',
        whereArgs: [villageId, schemeId],
      );
    } catch (e) {}
  }

  Future<void> truncatetable_ssmasterdeatils() async {
    var dbClient = await db;
    await dbClient!.delete('Storagestructuresavedataofflinetable');
  }

  Future<void> clearRowByIdss(id) async {
    var dbClient = await instance.db;
    await dbClient!.delete(
      'Storagestructuresavedataofflinetable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<LocalStoragestructureofflinesavemodal>
      insertstoragestructureofflinesaveindb(
          LocalStoragestructureofflinesavemodal
              localStoragestructureofflinesavemodal) async {
    var dbClient = await db;
    await dbClient!.insert('Storagestructuresavedataofflinetable',
        localStoragestructureofflinesavemodal.toMap());
    return localStoragestructureofflinesavemodal;
  }

  Future<void> deleteRecordsByVillageIdstoragestructure(
      String villageId) async {
    var dbClient = await instance.db;

    await dbClient!.delete(
      'Storagestructuresavedataofflinetable',
      where: 'VillageId = ?',
      whereArgs: [villageId],
    );
  }

  Future<List<Map<String, dynamic>>>
      structurestructurecommonfindallrecordsameVillageIds() async {
    var dbClient = await instance.db;
    final List<Map<String, dynamic>> result = await dbClient!.rawQuery('''
      SELECT VillageId, VillageName, PanchayatName, BlockName, COUNT(*) as count
      FROM Storagestructuresavedataofflinetable
      GROUP BY VillageId
      HAVING COUNT(*) > 0
    ''');
    return result;
  }

  Future<void> truncateTableByVillageId_Ot(String Schemeid) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.delete(
        'Otherassetssavedataofflinetable',
        where: 'SchemeId = ?',
        whereArgs: [Schemeid],
      );
    } catch (e) {}
  }

  Future<void> updateStatusInpendinglistot(
      String villageId, String schemeId, String status) async {
    try {
      var dbClient = await instance.db;
      await dbClient?.update(
        'Otherassetssavedataofflinetable',
        {'Status': status},
        where: 'VillageId = ? AND SchemeId = ?',
        whereArgs: [villageId, schemeId],
      );
    } catch (e) {}
  }

  Future<List<LocalStoragestructureofflinesavemodal>>
      getallofflineentriesforstoragestructure() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('Storagestructuresavedataofflinetable');
      return results
          .map((json) => LocalStoragestructureofflinesavemodal.fromMap(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<LocalStoragestructureofflinesavemodal>>
      getallofflineentriesstoragestructure() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('Storagestructuresavedataofflinetable');
      return results
          .map((json) => LocalStoragestructureofflinesavemodal.fromMap(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<LocalOtherassetsofflinesavemodal>>
      getallofflineentriesotherassets() async {
    try {
      var dbClient = await instance.db;
      List<Map<String, dynamic>> results =
          await dbClient!.query('Otherassetssavedataofflinetable');
      return results
          .map((json) => LocalOtherassetsofflinesavemodal.fromMap(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> truncatetable_otmasterdeatils() async {
    var dbClient = await db;
    await dbClient!.delete('Otherassetssavedataofflinetable');
  }
}
