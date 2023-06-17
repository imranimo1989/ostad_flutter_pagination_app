import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_services/api_services.dart';

class PostBloc extends Cubit<List<dynamic>> {
  final ApiService apiService;
  List<dynamic> posts = [];
  int currentPage = 0;
  int limit = 10;

  PostBloc(this.apiService) : super([]);

  Future<void> fetchPosts() async {
    try {
      final newPosts = await apiService.fetchPosts(currentPage * limit, limit);
      posts.addAll(newPosts as List<dynamic>);
      emit(posts.toList());
      currentPage++;
    } catch (e) {
      // Handle error
    }
  }
}
