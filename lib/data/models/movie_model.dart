class Movie {
  final String id;
  final String title;
  final String year;
  final String genre;
  final String imdbRating;
  final String plot;
  final String poster;
  final bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.imdbRating,
    required this.plot,
    required this.poster,
    required this.isFavorite,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String posterUrl = json['Poster'] ?? '';
    if (posterUrl.startsWith('http://')) {
      posterUrl = posterUrl.replaceFirst('http://', 'https://');
    }

    return Movie(
      id: json['id'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      genre: json['Genre'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      plot: json['Plot'] ?? '',
      poster: posterUrl,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Movie copyWith({bool? isFavorite}) {
    return Movie(
      id: id,
      title: title,
      year: year,
      genre: genre,
      imdbRating: imdbRating,
      plot: plot,
      poster: poster,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
