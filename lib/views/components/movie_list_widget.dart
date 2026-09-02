import 'package:flutter/material.dart';
import 'package:moviesqlitemvvm/viewmodels/movie_view_model.dart';
import 'package:moviesqlitemvvm/views/components/movie_form_dialog.dart';
import 'package:provider/provider.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieViewModel>();
    final movies = viewModel.movies;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(movie.title),
                  subtitle: Text(
                    "Anno: ${movie.year} - durata: ${movie.duration}\nTrama: ${movie.plot}",
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => MovieFormDialog(movie: movie),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<MovieViewModel>().deleteMovie(movie.id!);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
