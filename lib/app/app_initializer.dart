import 'package:flutter/material.dart';
import 'package:restaurant_management/app/cubits_provider.dart';
import 'package:restaurant_management/app/my_app.dart';
import 'package:restaurant_management/app/repositories_provider.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';

class MyAppInitializer extends StatelessWidget {
  final String? accessToken;

  const MyAppInitializer({super.key, this.accessToken});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initDependencies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: Text('Initialization Error'))),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _initDependencies() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();

    final dioClient = DioClient(tokenStorage);

    final repositories = await createRepositories(dioClient, tokenStorage);

    final initialRoute =
        (accessToken != null) ? AppRoutes.mainRoute : AppRoutes.loginRoute;

    return RepositoriesProvider(
      repositories: repositories,
      child: CubitsProvider(
        repositories: repositories,
        tokenStorage: tokenStorage,
        child: MyApp(initialRoute: initialRoute),
      ),
    );
  }
}
