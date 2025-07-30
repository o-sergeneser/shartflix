import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Film listesi (infinite scroll)
class FetchMovies extends MovieEvent {
  final bool isRefresh;
  FetchMovies({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ToggleFavorite extends MovieEvent {
  final String movieId;
  ToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class FetchFavorites extends MovieEvent {}
