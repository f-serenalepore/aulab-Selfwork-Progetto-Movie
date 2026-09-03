import 'package:flutter/material.dart';
import 'package:moviesqlitemvvm/viewmodels/movie_view_model.dart';
import 'package:moviesqlitemvvm/views/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieViewModel()..fetchMovies(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      home: HomeView(),
    );
  }
}
