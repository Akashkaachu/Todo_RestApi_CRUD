import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tudoput/core/colors/colors.dart';
import 'package:tudoput/functions/functions.dart';
import 'package:tudoput/getx/snack_bar_controller.dart';
import 'package:tudoput/presentations/add_todo_page.dart';
import 'package:http/http.dart' as http;

ValueNotifier<List> itemsValueNotifier = ValueNotifier([]);

class TodoPageList extends StatefulWidget {
  const TodoPageList({super.key});

  @override
  State<TodoPageList> createState() => _TodoPageListState();
}

class _TodoPageListState extends State<TodoPageList> {
  @override
  void initState() {
    super.initState();
    fetchTodoDataFromApi();
  }

  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: itemsValueNotifier,
      builder: (context, itemsListCout, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: klightBlue,
          title: const Text(
            'Todo List',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: itemsListCout.isEmpty
            ? Center(
                child: LottieBuilder.asset(
                    'assets/animations/Animation - 1710880865629.json'),
              )
            : ListView.builder(
                itemCount: itemsListCout.length,
                itemBuilder: (context, index) {
                  final items = itemsListCout[index] as Map;
                  final id = items['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      items['title'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(items['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(() => AddTodoPage(todo: items));
                        } else if (value == 'delete') {
                          deleteFunc(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          const PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          )
                        ];
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.to(() => AddTodoPage());
            },
            label: const Text('Add Todo')),
      ),
    );
  }
}

Future<void> deleteFunc(String id) async {
  final url = 'https://api.nstack.in/v1/todos/$id';
  final uri = Uri.parse(url);
  final response = await http.delete(uri);
  if (response.statusCode == 200 || response.statusCode == 201) {
    await fetchTodoDataFromApi();
    CustomSnackBarController()
        .showCustumSnackbar('Wow', 'Successfully deleted', ContentType.success);
  } else {
    CustomSnackBarController()
        .showCustumSnackbar('Oop', 'Somethig went wrong', ContentType.failure);
  }
}
