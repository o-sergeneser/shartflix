abstract class AuthRepository {
  Future<void> persistUserSession({
    required String token,
    required String name,
    required String id,
    required String photoUrl,
  });
  Future<String?> getToken();
  Future<void> removeUserData();

  Future<DateTime?> getTokenCreatedAt();
  Future<void> saveTokenCreatedAt(DateTime dateTime);

  Future<String> login(String email, String password);
  Future<String> register(String name, String email, String password);
  Future<void> logout();
  Future<String> uploadPhoto(String filePath);
}
