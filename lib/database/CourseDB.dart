import 'dart:io';
import 'package:mad_project/model/courseItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class CourseDB {
  String dbName;

  CourseDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  // ✅ เพิ่มข้อมูลหลักสูตรใหม่
  Future<int> insertCourse(CourseItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('courses');

    var keyID = await store.add(db, {
      'title': item.title,
      'seats': item.seats,
      'startDate': item.startDate.toIso8601String(),
      'endDate': item.endDate.toIso8601String(),
      'details': item.details,  // เพิ่มรายละเอียด
    });

    db.close();
    return keyID;
  }

  // ✅ โหลดข้อมูลหลักสูตรทั้งหมด
  Future<List<CourseItem>> loadAllCourses() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('courses');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('startDate', false)]));

    List<CourseItem> courses = [];

    for (var record in snapshot) {
      CourseItem item = CourseItem(
        id: record.key.toString(),  // เปลี่ยนเป็น String เพื่อใช้กับ id ของ CourseItem
        title: record['title'].toString(),
        seats: int.parse(record['seats'].toString()),
        startDate: DateTime.parse(record['startDate'].toString()),
        endDate: DateTime.parse(record['endDate'].toString()),
        details: record['details'].toString(),  // เพิ่มรายละเอียด
        
      );
      courses.add(item);
    }
    db.close();
    return courses;
  }

  // ✅ ลบข้อมูลหลักสูตร
  Future<void> deleteCourse(String id) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('courses');

    // แก้ไขการลบให้ตรงกับการใช้ ID แบบ String
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, int.parse(id))));

    db.close();
  }

  // ✅ อัปเดตข้อมูลหลักสูตร
  Future<void> updateCourse(CourseItem item) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('courses');

    await store.update(
        db,
        {
          'title': item.title,
          'seats': item.seats,
          'startDate': item.startDate.toIso8601String(),
          'endDate': item.endDate.toIso8601String(),
          'details': item.details,  // เพิ่มรายละเอียด
        },
        finder: Finder(filter: Filter.equals(Field.key, int.parse(item.id)))  // ใช้ int.parse กับ ID
    );

    db.close();
  }
}
