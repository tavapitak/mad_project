import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_project/model/courseItem.dart';
import 'package:mad_project/provider/courseProvider.dart';
import 'CourseFormScreen.dart';
import 'editScreen.dart';
import 'AnotherScreen.dart';  // สมมติว่า AnotherScreen เป็นหน้าที่จะไปเชื่อมด้วย

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return CourseProvider();
        }),
      ],
      child: MaterialApp(
        title: 'ระบบจัดการหลักสูตร',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'รายการหลักสูตรพัฒนาบุคลากร'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    CourseProvider provider = Provider.of<CourseProvider>(context, listen: false);
    provider.initData(); // โหลดข้อมูลหลักสูตร
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const CourseFormScreen();
                }),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // ตัวอย่างการเชื่อมไปยังหน้า AnotherScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const AnotherScreen();  // เชื่อมไปยัง AnotherScreen
                }),
              );
            },
          ),
        ],
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          int itemCount = provider.courses.length;
          if (itemCount == 0) {
            return const Center(
              child: Text(
                'ไม่มีหลักสูตร',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, int index) {
                CourseItem data = provider.courses[index];
                return Dismissible(
                  key: Key(data.id.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    provider.deleteCourse(data);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ListTile(
                      title: Text(data.title),
                      subtitle: Text(
                        'วันที่อบรม: ${data.startDate.toLocal()} - ${data.endDate.toLocal()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: FittedBox(
                          child: Text(data.seats.toString()),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('ยืนยันการลบ'),
                                content: const Text('คุณต้องการลบหลักสูตรนี้ใช่หรือไม่?'),
                                actions: [
                                  TextButton(
                                    child: const Text('ยกเลิก'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('ลบ'),
                                    onPressed: () {
                                      provider.deleteCourse(data);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return EditScreen(course: data);
                          }),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
