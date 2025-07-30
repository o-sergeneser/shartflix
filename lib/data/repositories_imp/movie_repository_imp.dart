import '../../core/services/api_client.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie_list_response_model.dart';
import '../models/movie_model.dart';

class MovieRepositoryImp implements MovieRepository {
  final ApiClient apiClient;
  MovieRepositoryImp(this.apiClient);

  @override
  Future<MovieListResponse> fetchMovies(int page) async {
    final response = await apiClient.dio.get(
      '/movie/list',
      queryParameters: {'page': page, 'limit': 4},
    );
    if (response.statusCode == 200 && response.data['data'] != null) {
      return MovieListResponse.fromJson(response.data['data']);
    } else {
      throw Exception('Film listesi alınamadı');
    }
  }

  @override
  Future<void> toggleFavorite(String movieId) async {
    final response = await apiClient.dio.post('/movie/favorite/$movieId');
    if (response.statusCode != 200) {
      throw Exception(
        response.data['response']['message'] ?? 'Favori işlemi başarısız',
      );
    }
  }

  @override
  Future<List<Movie>> fetchFavorites() async {
    try {
      final response = await apiClient.dio.get('/movie/favorites');

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];
        return data.map((m) => Movie.fromJson(m)).toList();
      } else {
        throw Exception('Favoriler alınamadı');
      }
    } catch (e) {
      throw Exception('Favoriler alınamadı: $e');
    }
  }
}
