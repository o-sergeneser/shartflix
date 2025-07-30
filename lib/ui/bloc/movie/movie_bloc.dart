import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/data/models/movie_model.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  int currentPage = 1;
  bool hasMore = true;
  List<Movie> movies = [];
  List<Movie> favorites = [];

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchFavorites>(_onFetchFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieState> emit,
  ) async {
    try {
      if (event.isRefresh) {
        currentPage = 1;
        hasMore = true;
        movies.clear();
      }

      if (!hasMore) return;

      if (state is! MovieLoaded || event.isRefresh) {
        emit(MovieLoading());
      } else {
        emit((state as MovieLoaded).copyWith(isLoadingMore: true));
      }

      final fetchedMovies = await repository.fetchMovies(currentPage);

      if (fetchedMovies.movies.isEmpty) {
        hasMore = false;
      } else {
        currentPage++;
        movies.addAll(fetchedMovies.movies);
      }

      emit(
        MovieLoaded(
          movies: List.from(movies),
          favorites: favorites,
          hasMore: hasMore,
        ),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> _onFetchFavorites(
    FetchFavorites event,
    Emitter<MovieState> emit,
  ) async {
    try {
      final favs = await repository.fetchFavorites();
      favorites = favs;

      if (state is MovieLoaded) {
        emit((state as MovieLoaded).copyWith(favorites: List.from(favs)));
      } else {
        emit(
          MovieLoaded(
            movies: movies,
            favorites: List.from(favs),
            hasMore: hasMore,
          ),
        );
      }
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MovieState> emit,
  ) async {
    if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;

      final updatedMovies = currentState.movies.map((movie) {
        if (movie.id == event.movieId) {
          return movie.copyWith(isFavorite: !movie.isFavorite);
        }
        return movie;
      }).toList();

      List<Movie> updatedFavorites = List.from(currentState.favorites);
      final toggledMovie = updatedMovies.firstWhere(
        (m) => m.id == event.movieId,
      );

      if (toggledMovie.isFavorite) {
        updatedFavorites.add(toggledMovie);
      } else {
        updatedFavorites.removeWhere((fav) => fav.id == event.movieId);
      }

      emit(
        currentState.copyWith(
          movies: updatedMovies,
          favorites: updatedFavorites,
        ),
      );

      try {
        await repository.toggleFavorite(event.movieId);
      } catch (_) {
        emit(currentState);
      }
    }
  }
}
