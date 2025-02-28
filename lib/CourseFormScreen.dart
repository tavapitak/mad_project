import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_project/model/courseItem.dart';
import 'package:mad_project/provider/courseProvider.dart';

class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final seatsController = TextEditingController();
  final detailsController = TextEditingController(); // สำหรับรายละเอียดหลักสูตร
  DateTime? startDate;
  DateTime? endDate;

  // ฟังก์ชันเลือกวันที่
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('เพิ่มหลักสูตร'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อหลักสูตร'),
                controller: titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณาป้อนชื่อหลักสูตร";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(startDate == null
                        ? "วันที่เริ่มต้น: ยังไม่เลือก"
                        : "วันที่เริ่มต้น: ${startDate!.toLocal()}".split(' ')[0]),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(endDate == null
                        ? "วันที่สิ้นสุด: ยังไม่เลือก"
                        : "วันที่สิ้นสุด: ${endDate!.toLocal()}".split(' ')[0]),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'จำนวนที่นั่ง'),
                keyboardType: TextInputType.number,
                controller: seatsController,
                validator: (value) {
                  try {
                    int seats = int.parse(value!);
                    if (seats <= 0) {
                      return "กรุณาป้อนจำนวนที่นั่งที่มากกว่า 0";
                    }
                  } catch (e) {
                    return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'รายละเอียดหลักสูตร'),
                controller: detailsController,
                maxLines: 4,  // ให้กรอกหลายบรรทัด
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณาป้อนรายละเอียดหลักสูตร";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() && startDate != null && endDate != null) {
                    // ตรวจสอบวันที่สิ้นสุดว่าไม่น้อยกว่าหรือเท่ากับวันที่เริ่มต้น
                    if (endDate!.isBefore(startDate!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('วันที่สิ้นสุดต้องไม่ก่อนวันที่เริ่มต้น'))
                      );
                      return;
                    }

                    var provider = Provider.of<CourseProvider>(context, listen: false);

                    CourseItem newCourse = CourseItem(
                      id: '', // จะถูกกำหนดใหม่โดย DB
                      title: titleController.text,
                      seats: int.parse(seatsController.text),
                      startDate: startDate!,
                      endDate: endDate!,
                      details: detailsController.text,  // เพิ่มรายละเอียด
                    );

                    provider.addCourse(newCourse);
                    Navigator.pop(context);
                  }
                },
                child: const Text('เพิ่มหลักสูตร'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
