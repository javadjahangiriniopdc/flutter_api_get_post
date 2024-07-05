import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_get_post/data.dart';

void main() {
  getStudents();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: const Color(0xff16E5A7),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Android Expert'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
             final result=await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => _AddStudentForm()));
                  setState(() {
                    
                  });
                  
            },
            label: const Row(
              children: [Icon(Icons.add), Text('Add Student')],
            )),
        body: FutureBuilder<List<StudentData>>(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _Student(
                      data: snapshot.data![index],
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class _AddStudentForm extends StatelessWidget {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Student '),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              final newStudentData = await saveStudent(
                  _firstnameController.text,
                  _lastnameController.text,
                  _courseController.text,
                  int.parse(_scoreController.text));
              Navigator.pop(context, newStudentData);
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          label: const Row(
            children: [Icon(Icons.check), Text('save')],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(label: Text('First Name')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(label: Text('last Name')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(label: Text('course')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Score')),
            )
          ],
        ),
      ),
    );
  }
}

class _Student extends StatelessWidget {
  final StudentData data;

  const _Student({required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
          ]),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
            child: Text(
              data.firstName != null && data.firstName!.isNotEmpty
                  ? data.firstName!.characters.first
                  : '',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 34),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data.firstName!} ${data.lastName!}'),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.shade200),
                    child: Text(
                      data.course!,
                      style: const TextStyle(fontSize: 10),
                    ))
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: Colors.grey.shade200,
              ),
              Text(
                data.score.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

Future<StudentData> saveStudent(
    String firstName, String lastName, String course, int score) async {
  final response = await MyHttpClient.dio.post('experts/student', data: {
    'first_name': firstName,
    'last_name': lastName,
    'course': course,
    'score': score
  });
  if (response.statusCode == 200) {
    return StudentData.formJson(response.data);
  } else {
    throw Exception();
  }
}
