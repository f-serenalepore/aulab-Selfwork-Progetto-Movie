import 'package:flutter/material.dart';
import 'package:moviesqlitemvvm/models/movie.dart';
import 'package:moviesqlitemvvm/services/movie_service.dart';

class MovieViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  List<Movie> get movies => _filteredMovies;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //metodo per poter recuperare tutti i film
  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();
    _movies = await _dbService.getAllMovies();
    _filteredMovies = List.from(_movies);
    _isLoading = false;
    notifyListeners();
  }

  //metodo per aggiungere un film
  Future<void> addMovie(Movie movie) async {
    await _dbService.insertMovie(movie);
    await fetchMovies();
  }

  //metodo per cancellare un film
  Future<void> deleteMovie(int id, dynamic movie) async {
    print("1. aggiungo: ${movie.title}");

  await _dbService.insertMovie(movie);

  print("2. film inserito");

  await fetchMovies();

  print("3. film ricaricati: ${movies.length}");
  }

  //aggiornare il film
  Future<void> updateMovie(Movie movie) async {
    if (movie.id == null) return;
    await _dbService.updateMovie(movie);
    await fetchMovies();
  }

  //metodo per recuperare un film attraverso il suo id
  Movie? getMovieById(int id) {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (_) {
      return null;
    }
  }

  void filterMovies(String query) {
    if (query.isEmpty) {
      _filteredMovies = List.from(_movies);
    } else {
      _filteredMovies = _movies
          .where(
            (movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()) ||
                movie.plot.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
