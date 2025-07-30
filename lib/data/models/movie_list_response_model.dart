import 'movie_model.dart';

class MovieListResponse {
  final List<Movie> movies;
  final Pagination pagination;

  MovieListResponse({required this.movies, required this.pagination});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      movies: (json['movies'] as List).map((e) => Movie.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  Pagination({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['totalCount'],
      perPage: json['perPage'],
      maxPage: json['maxPage'],
      currentPage: json['currentPage'],
    );
  }
}

