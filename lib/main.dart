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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Android Expert'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: const Row(
              children: [Icon(Icons.add), Text('Add Student')],
            )),
        body: FutureBuilder<List<StudentData>>(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
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
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
