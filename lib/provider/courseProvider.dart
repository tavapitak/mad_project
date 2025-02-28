import 'package:flutter/material.dart';
import 'package:mad_project/model/courseItem.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseItem> _courses = []; // รายการหลักสูตร

  List<CourseItem> get courses => _courses; // Getter ดึงข้อมูลหลักสูตร

  // ✅ ฟังก์ชันเพิ่มหลักสูตร
  void addCourse(CourseItem course) {
    _courses.add(course);
    notifyListeners(); // แจ้งให้ UI รีเฟรช
  }

  // ✅ ฟังก์ชันลบหลักสูตร
  void deleteCourse(CourseItem course) {
    _courses.removeWhere((item) => item.id == course.id);
    notifyListeners();
  }

  // ✅ ฟังก์ชันแก้ไขหลักสูตร
  void updateCourse(CourseItem course) {
    int index = _courses.indexWhere((item) => item.id == course.id);
    if (index != -1) {
      _courses[index] = course;
      notifyListeners();
    }
  }

  // ✅ โหลดข้อมูลเริ่มต้น (ถ้าต้องการ)
  void initData() {
    _courses = []; // สมมติเริ่มต้นไม่มีข้อมูล
    notifyListeners();
  }
}
