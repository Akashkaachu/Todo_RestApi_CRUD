import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tudoput/presentations/tudo_page_list.dart';

Future<void> fetchTodoDataFromApi() async {
  const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (response.body != null) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      itemsValueNotifier.value = result;
    } else {
      print('Response body is null');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
