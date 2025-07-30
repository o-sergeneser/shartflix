import 'package:equatable/equatable.dart';
import 'package:shartflix/data/models/movie_model.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final List<Movie> favorites;
  final bool hasMore;
  final bool isLoadingMore;

  MovieLoaded({
    required this.movies,
    this.favorites = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    List<Movie>? favorites,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      favorites: favorites ?? this.favorites,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, favorites, hasMore, isLoadingMore];
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);

  @override
  List<Object?> get props => [message];
}
