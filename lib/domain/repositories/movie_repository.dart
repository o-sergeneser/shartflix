import 'package:shartflix/data/models/movie_list_response_model.dart';
import 'package:shartflix/data/models/movie_model.dart';

abstract class MovieRepository {
  Future<MovieListResponse> fetchMovies(int page);
  Future<void> toggleFavorite(String movieId);
  Future<List<Movie>> fetchFavorites();
}
