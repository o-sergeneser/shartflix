import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/theme/colors.dart';
import 'package:shartflix/ui/bloc/auth/auth_bloc.dart';
import 'package:shartflix/ui/bloc/auth/auth_event.dart';
import 'package:shartflix/ui/bloc/auth/auth_state.dart';
import 'package:shartflix/ui/bloc/movie/movie_bloc.dart';
import 'package:shartflix/ui/bloc/movie/movie_event.dart';
import 'package:shartflix/ui/bloc/movie/movie_state.dart';
import 'package:shartflix/ui/widgets/limited_offer_bottom_sheet.dart';
import '../../../data/repositories_imp/auth_repository_imp.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userId = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    context.read<MovieBloc>().add(FetchFavorites());
  }

  Future<void> _loadUserInfo() async {
    final authRepo = context.read<AuthRepositoryImp>();
    final info = await authRepo.getUserInfo();

    setState(() {
      userName = info['name'] ?? 'Kullanıcı';
      userId = info['id'] ?? '';
      photoUrl = info['photoUrl'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst kısım
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Çıkış butonu
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.power_settings_new,
                                  color: AppColors.primaryRed,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _showLogoutDialog(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Profil Detayı",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Colors.transparent,
                                  builder: (context) {
                                    return LimitedOfferBottomSheet(
                                      onClose: () => Navigator.pop(context),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.diamond,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Sınırlı Teklif",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'EuclidCircularA',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Text(
                                  "ID: $userId",
                                  style: Theme.of(context).textTheme.bodySmall,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: ElevatedButton(
                              onPressed: () async {
                                final newPhotoUrl = await Navigator.pushNamed(
                                  context,
                                  '/upload-photo',
                                );
                                if (newPhotoUrl != null &&
                                    newPhotoUrl is String) {
                                  setState(() {
                                    photoUrl = newPhotoUrl;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "Fotoğraf\nDeğiştir",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Beğendiğim Filmler",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Favori Filmler Grid
                  BlocBuilder<MovieBloc, MovieState>(
                    builder: (context, state) {
                      if (state is MovieLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is MovieLoaded) {
                        final favorites = state.favorites;

                        if (favorites.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Henüz favori filmin yok",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        final screenHeight = MediaQuery.of(context).size.height;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.565,
                              ),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final movie = favorites[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Poster
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    movie.poster,
                                    fit: BoxFit.cover,
                                    height: screenHeight * 0.3,
                                    width: double.infinity,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Film ismi
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Tür
                                Text(
                                  movie.genre,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        );
                      } else if (state is MovieError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Çıkış Yap",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Çıkış yapmak istediğinize emin misiniz?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
                Navigator.pop(context);
              },
              child: Text(
                "Evet",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
