import 'dart:convert';

import 'package:comment_app/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentService {

  Future<List<Comment>> getAll() async {
    const url = 'https://jsonplaceholder.typicode.com/comments';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final comment = json.map((e) {
          return Comment(
              postId: e['postId'],
              id: e['id'],
              name: e['name'],
              email: e['email'],
              body: e['body']);
        }).toList();
        return comment;
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }
}
