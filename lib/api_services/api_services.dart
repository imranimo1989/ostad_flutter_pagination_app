import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<dynamic>> fetchPosts(int start, int limit) async {
    final response = await http.get(Uri.parse('$apiUrl?_start=$start&_limit=$limit'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body) as List<dynamic>;
      return parsed;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}
