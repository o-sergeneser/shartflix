import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shartflix/core/utils/locale_provider.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/ui/screens/profile/upload_photo_screen.dart';

import 'core/theme/app_theme.dart';
import 'core/services/api_client.dart';
import 'data/repositories_imp/auth_repository_imp.dart';
import 'data/repositories_imp/movie_repository_imp.dart';
import 'domain/repositories/auth_repository.dart';

import 'ui/bloc/auth/auth_bloc.dart';
import 'ui/bloc/auth/auth_event.dart';
import 'ui/bloc/auth/auth_state.dart';
import 'ui/bloc/movie/movie_bloc.dart';

import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authRepository = AuthRepositoryImp(apiClient);

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: MyApp(authRepository: authRepository, apiClient: apiClient),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ApiClient apiClient;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImp>(
          create: (_) => AuthRepositoryImp(apiClient),
        ),
        RepositoryProvider<MovieRepository>(
          create: (_) => MovieRepositoryImp(apiClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository)..add(AppStarted()),
          ),
          BlocProvider<MovieBloc>(
            create: (_) => MovieBloc(MovieRepositoryImp(apiClient)),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          supportedLocales: const [Locale('en', ''), Locale('tr', '')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: localeProvider.locale,
          routes: {
            '/register': (_) => const RegisterScreen(),
            '/main': (_) => const MainScreen(),
            '/upload-photo': (_) => const UploadPhotoScreen(),
          },
          home: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
                current is Authenticated || current is Unauthenticated,
            builder: (context, state) {
              if (state is Authenticated) {
                return const MainScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
