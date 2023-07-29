

import 'package:comment_app/models/comment.dart';
import 'package:comment_app/services/comment_services.dart';
import 'package:flutter/material.dart';


class CommentProvider extends ChangeNotifier {
  final _service = CommentService();
  bool isLoading = false;
  List<Comment> _comment = [];
  List<Comment> get comment => _comment;
  String error = '';

  Future<void> getAllComments() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getAll();
      _comment = response;
    } catch (e) {
      error = e.toString();
      _comment = []; 
    }
    isLoading = false;
    notifyListeners();
  }

}

