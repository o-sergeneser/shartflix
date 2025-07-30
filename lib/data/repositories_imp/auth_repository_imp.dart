import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/api_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepositoryImp(this.apiClient);

  static const _tokenKey = 'token';
  static const _tokenCreatedAtKey = 'token_created_at';
  static const _userNameKey = 'user_name';
  static const _userIdKey = 'user_id';
  static const _userPhotoKey = 'user_photo';

  @override
  Future<void> persistUserSession({
    required String token,
    required String name,
    required String id,
    required String photoUrl,
  }) async {
    await storage.write(key: _tokenKey, value: token);
    await saveTokenCreatedAt(DateTime.now());

    await storage.write(key: _userNameKey, value: name);
    await storage.write(key: _userIdKey, value: id);
    await storage.write(key: _userPhotoKey, value: photoUrl);
  }

  @override
  Future<String?> getToken() async => await storage.read(key: _tokenKey);

  @override
  Future<void> removeUserData() async {
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _tokenCreatedAtKey);
    await storage.delete(key: _userNameKey);
    await storage.delete(key: _userIdKey);
    await storage.delete(key: _userPhotoKey);
  }

  @override
  Future<DateTime?> getTokenCreatedAt() async {
    final timestamp = await storage.read(key: _tokenCreatedAtKey);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  @override
  Future<void> saveTokenCreatedAt(DateTime dateTime) async {
    await storage.write(
      key: _tokenCreatedAtKey,
      value: dateTime.toIso8601String(),
    );
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 &&
          response.data['data']['token'] != null) {
        final token = response.data['data']['token'];

        await persistUserSession(
          token: response.data['data']['token'],
          name: response.data['data']['name'],
          id: response.data['data']['id'],
          photoUrl: response.data['data']['photoUrl'] ?? '',
        );

        return token;
      } else {
        throw 'Giriş başarısız';
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Bir hata oluştu';

      if (errorData is Map &&
          errorData['response'] is Map &&
          errorData['response']['message'] != null) {
        message = errorData['response']['message'];
      }

      throw message;
    }
  }

  Future<Map<String, String?>> getUserInfo() async {
    return {
      'name': await storage.read(key: _userNameKey),
      'id': await storage.read(key: _userIdKey),
      'photoUrl': await storage.read(key: _userPhotoKey),
    };
  }

  @override
  Future<String> register(String name, String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/user/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['data']['id'] != null) {
        return 'Kayıt başarılı, lütfen giriş yapın.'; 
      } else {
        throw Exception(response.data['message'] ?? 'Kayıt başarısız');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      String message = 'Bir hata oluştu';
      if (errorData is Map &&
          errorData['response'] is Map &&
          errorData['response']['message'] != null) {
        message = errorData['response']['message'];
      }

      throw message;
    }
  }

  @override
  Future<void> logout() async => await removeUserData();

  @override
  Future<String> uploadPhoto(String filePath) async {
    final token = await getToken();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await apiClient.dio.post(
      '/user/upload_photo',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 &&
        response.data['data']['photoUrl'] != null) {
      final photoUrl = response.data['data']['photoUrl'];
      await storage.write(key: _userPhotoKey, value: photoUrl);
      return photoUrl;
    } else {
      throw Exception('Fotoğraf yüklenemedi');
    }
  }
}
