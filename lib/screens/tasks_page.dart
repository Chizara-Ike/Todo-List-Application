import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/models/Tasks.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;
  String? content;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        toolbarHeight: _deviceHeight! * 0.1,
        title: const Text('Daily Planner'),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: _tasksWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: displayTaskPop,
        child: const Icon(Icons.add,), backgroundColor: Colors.grey,
      ),
    );
  }

  // 🔹 Open Hive box
  // Future<Box> _openBox() async {
  //   return await Hive.openBox('tasks');
  // }


  Widget _todoList (){
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index){
          var task = Tasks.fromMap(tasks[index]);
        return ListTile(
          title: Text(task.todo),
          subtitle: Text(task.timeStamp.toString()),
          trailing: task.done? Icon(Icons.check_box_outlined,
                                    color: Colors.green,):
                    Icon(Icons.check_box_outline_blank),
          onTap: (){
            task.done = !task.done;
            _box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: (){
            _box!.deleteAt(index);
            setState(() {});
          },
      );
    });
}

  /// 🔹 Display tasks
  Widget _tasksWidget() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      // future: _openBox(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // if (snapshot.hasError) {
          //   return const Center(child: Text('Error loading tasks'));
          // }

          if (snapshot.hasData) {
            _box = snapshot.data;
            return _todoList();

            // if (_box!.isEmpty) {
            //   return const Center(child: Text('No tasks yet'));
            // }
            //
            // return ListView.builder(
            //   itemCount: _box!.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(_box!.getAt(index)),
            //     );
            //   },
            // );
          } else {
            return Center(
                child: const CircularProgressIndicator());
          }
        });
  }

  /// 🔹 Add task dialog
  void displayTaskPop() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            onSubmitted: (value) {
              if (content != null){
                var task = Tasks(
                    todo: content!,
                    timeStamp: DateTime.now(),
                    done: false);
                _box!.add(task.toMap());

                setState(() {
                  print(value);
                  Navigator.pop(context);
                });
              }
            },
            autofocus: true,
            onChanged: (value) {
              setState(() {
                content = value;
                print(value);
              });
            },
          ),
            // content: const Text('Add your task here'),
          //   actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () {
          //       // save task logic
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text('Add'),
          //   ),
          // ],
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
//
// class TasksPage extends StatefulWidget {
//   const TasksPage({super.key});
//
//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }
//
// class _TasksPageState extends State<TasksPage> {
//
//   double? _deviceHeight, _deviceWidth; //the underscore means it's private
//   String? content;
//   box? _box;
//   @override
//   Widget build(BuildContext context) {
//     _deviceHeight = MediaQuery.of(context).size.height;
//     _deviceWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: _deviceHeight! * 0.1 ,
//         title: const Text('Daily Planner'),
//       ),
//       body: _tasksWidget(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: displayTaskPop,
//           child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   // Widget _tasksWidget() {
//   //   return const Center(
//   //     child: Text('Tasks will appear here'),
//   //   );
//   // }
//
//   Widget _tasksWidget() {
//     return FutureBuilder(
//       future: _box(), // your async function
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text('Error loading tasks'),
//           );
//         }
//
//         if (snapshot.hasData) {
//           _box = snapshot.data;
//
//           return ListView.builder(
//             itemCount: _box.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(_box.getAt(index)),
//               );
//             },
//           );
//         }
//
//         return const Center(
//           child: Text('No tasks found'),
//         );
//       },
//     );
//   }
//
//   // Widget _tasksWidget(){
//   //   return FutureBuilder(
//   //     future: _box,
//   //       builder: BuildContext context,
//   //       AsyncSnapshot snapshot){
//   //     if (snapshot.hasData) {
//   //       _box = snapshot.data;
//   //     }
//   //     else {
//   //       return Center(
//   //           child: const CircularProgressIndicator();)
//   //     }
//   //     }
//
//     };
//   }
//   // Widget _tasksWidget(){
//   //   return Center(
//   //     child: Text(content!),
//   //   );
//   // }
//
//   void displayTaskPop() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('New Task'),
//           content: TextField(
//             onSubmitted: (value){
//
//               setState(() {
//                 print(value);
//                 Navigator.pop(context);
//               });
//
//             },
//             onChanged: (value){
//               setState(() {
//                 content = value;
//                 print(value);
//               });
//             },
//           ),
//           // content: const Text('Add your task here'),
//           // actions: [
//           //   TextButton(
//           //     onPressed: () {
//           //       Navigator.of(context).pop();
//           //     },
//           //     child: const Text('Cancel'),
//           //   ),
//           //   TextButton(
//           //     onPressed: () {
//           //       // save task logic
//           //       Navigator.of(context).pop();
//           //     },
//           //     child: const Text('Add'),
//           //   ),
//           // ],
//         );
//       },
//     );
//   }
//
//   // void displayTaskPop(){
//   //   showAboutDialog(
//   //       context: context,
//   //       build: BuildContext _context
//   //   ){
//   //     return AlertDialog();
//   //   }
//   }
