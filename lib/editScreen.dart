import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_project/model/courseItem.dart';
import 'package:mad_project/provider/courseProvider.dart';

class EditScreen extends StatefulWidget {
  final CourseItem course;

  const EditScreen({super.key, required this.course});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _seatsController;
  late TextEditingController _detailsController;  // สำหรับรายละเอียดหลักสูตร
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
    _seatsController = TextEditingController(text: widget.course.seats.toString());
    _detailsController = TextEditingController(text: widget.course.details);  // กรอกรายละเอียด
    _startDate = widget.course.startDate;
    _endDate = widget.course.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('แก้ไขหลักสูตร'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ฟอร์มชื่อหลักสูตร
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อหลักสูตร'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาป้อนชื่อหลักสูตร';
                  }
                  return null;
                },
              ),
              // ฟอร์มจำนวนที่นั่ง
              TextFormField(
                decoration: const InputDecoration(labelText: 'จำนวนที่นั่ง'),
                keyboardType: TextInputType.number,
                controller: _seatsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาป้อนจำนวนที่นั่ง';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'กรุณาป้อนตัวเลขที่มากกว่า 0';
                  }
                  return null;
                },
              ),
              // ฟอร์มรายละเอียดหลักสูตร
              TextFormField(
                decoration: const InputDecoration(labelText: 'รายละเอียดหลักสูตร'),
                controller: _detailsController,
                maxLines: 4,  // กรอกหลายบรรทัด
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาป้อนรายละเอียดหลักสูตร';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // ฟอร์มเลือกวันที่เริ่มต้น
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'วันที่เริ่ม: ${_startDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _startDate) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              // ฟอร์มเลือกวันที่สิ้นสุด
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'วันที่สิ้นสุด: ${_endDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _endDate) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var provider = Provider.of<CourseProvider>(context, listen: false);

                    CourseItem updatedCourse = CourseItem(
                      id: widget.course.id,
                      title: _titleController.text,
                      seats: int.parse(_seatsController.text),
                      startDate: _startDate,
                      endDate: _endDate,
                      details: _detailsController.text,  // คำอธิบายหลักสูตร
                    );

                    provider.updateCourse(updatedCourse);

                    Navigator.pop(context);
                  }
                },
                child: const Text('บันทึกการแก้ไข'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
