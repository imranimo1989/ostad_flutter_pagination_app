import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_services/api_services.dart';
import 'business_logic_code/post_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiService = ApiService();
  final postBloc = PostBloc(ApiService());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pagination App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider.value(
        value: postBloc,
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    BlocProvider.of<PostBloc>(context).fetchPosts();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      BlocProvider.of<PostBloc>(context).fetchPosts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Pagination App'),
      ),
      body: BlocBuilder<PostBloc, List<dynamic>>(
        builder: (context, state) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.length + 1,
            itemBuilder: (context, index) {
              if (index < state.length) {
                final post = state[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text("${index+1}"),
                  ),
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                );
              } else if (index == state.length && state.isNotEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}

