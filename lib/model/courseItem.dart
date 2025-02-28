class CourseItem {
  final String id;
  final String title;
  final int seats;
  final DateTime startDate;
  final DateTime endDate;
  final String details;  // เพิ่มรายละเอียดหลักสูตร

  // คอนสตรัคเตอร์สำหรับการสร้าง CourseItem ใหม่
  CourseItem({
    required this.id,
    required this.title,
    required this.seats,
    required this.startDate,
    required this.endDate,
    required this.details,  // ค่ารายละเอียด
  });

  // ฟังก์ชันจาก Map -> CourseItem
  factory CourseItem.fromMap(Map<String, dynamic> map) {
    return CourseItem(
      id: map['id'] ?? '',  // ตรวจสอบกรณี id เป็น null
      title: map['title'] ?? '',  // ตรวจสอบกรณี title เป็น null
      seats: map['seats'] ?? 0,  // ตรวจสอบกรณี seats เป็น null
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : DateTime.now(),  // กรณี startDate เป็น null
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'])
          : DateTime.now(),  // กรณี endDate เป็น null
      details: map['details'] ?? '',  // ตรวจสอบกรณี details เป็น null
    );
  }

  // ฟังก์ชันจาก CourseItem -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'seats': seats,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'details': details,  // แปลงรายละเอียด
    };
  }
}
