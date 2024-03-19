import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudoput/core/const/const.dart';
import 'package:http/http.dart' as http;
import 'package:tudoput/functions/functions.dart';
import 'package:tudoput/getx/snack_bar_controller.dart';
import 'package:tudoput/presentations/tudo_page_list.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key, this.todo});
  final Map? todo;
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String id = '';
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      id = todo['_id'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          kheight20,
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              label: Text('Title'),
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          kheight20,
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              label: Text('Description'),
              hintText: 'Description',
              hintStyle: TextStyle(color: Colors.white),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          kheight20,
          ElevatedButton(
              onPressed: () {
                isEdit ? editFun(id) : addData();
                fetchTodoDataFromApi();
                Get.to(() => const TodoPageList());
              },
              child: Text(isEdit ? 'Update' : 'Submit'))
        ]),
      ),
    );
  }

  void addData() async {
    //Get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
//Submit data to the Server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      fetchTodoDataFromApi();
      CustomSnackBarController()
          .showCustumSnackbar('Wow', 'Creation Success', ContentType.success);
    } else {
      CustomSnackBarController()
          .showCustumSnackbar('Oops', 'Creation failed', ContentType.failure);
    }
  }

  Future<void> editFun(String id) async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchTodoDataFromApi();
      CustomSnackBarController().showCustumSnackbar(
          'Wow', 'Successfully updated', ContentType.success);
    } else {
      CustomSnackBarController().showCustumSnackbar(
          'Oops', 'Something went wrong', ContentType.failure);
    }
  }
}
