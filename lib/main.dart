import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/products_remote_datasource.dart';
import 'data/datasources/posts_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/products_repository_impl.dart';
import 'data/repositories/posts_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/get_cached_user_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_event.dart';
import 'presentation/auth/bloc/auth_state.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/home/screens/home_screen.dart';
import 'presentation/settings/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(client: http.Client());

    final authLocalDs = AuthLocalDataSourceImpl(prefs);
    final authRemoteDs = AuthRemoteDataSourceImpl(apiClient);
    final productsRemoteDs = ProductsRemoteDataSourceImpl(apiClient);
    final postsRemoteDs = PostsRemoteDataSourceImpl(apiClient);

    final authRepo = AuthRepositoryImpl(
      remoteDataSource: authRemoteDs,
      localDataSource: authLocalDs,
    );
    final productsRepo = ProductsRepositoryImpl(productsRemoteDs);
    final postsRepo = PostsRepositoryImpl(postsRemoteDs);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs)),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            getCachedUserUseCase: GetCachedUserUseCase(authRepo),
          )..add(CheckAuthEvent()),
        ),
        RepositoryProvider<GetProductsUseCase>(
          create: (_) => GetProductsUseCase(productsRepo),
        ),
        RepositoryProvider<GetPostsUseCase>(
          create: (_) => GetPostsUseCase(postsRepo),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Taghyeer App',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading || state is AuthInitial) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.workspace_premium_rounded, size: 42),
                          SizedBox(height: 14),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
                }
                if (state is AuthAuthenticated) {
                  return const HomeScreen();
                }
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
