import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/inventory/data/datasources/inventory_local_datasource.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/usecases/inventory_usecases.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/inventory/presentation/pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Network Client
  final apiClient = ApiClient();

  // Initialize Auth Data Sources & Repositories
  final authLocalDataSource = AuthLocalDataSourceImpl(apiClient: apiClient);
  final authRepository = AuthRepositoryImpl(localDataSource: authLocalDataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final getSavedUser = GetSavedUser(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);

  // Initialize Inventory Data Sources & Repositories
  final inventoryLocalDataSource = InventoryLocalDataSourceImpl(apiClient: apiClient);
  final inventoryRepository = InventoryRepositoryImpl(localDataSource: inventoryLocalDataSource);
  
  final getInventoryItems = GetInventoryItems(inventoryRepository);
  final addInventoryItem = AddInventoryItem(inventoryRepository);
  final updateInventoryItem = UpdateInventoryItem(inventoryRepository);
  final deleteInventoryItem = DeleteInventoryItem(inventoryRepository);
  final getSupplyRequests = GetSupplyRequests(inventoryRepository);
  final getNotifications = GetNotifications(inventoryRepository);
  final getWarehouses = GetWarehouses(inventoryRepository);
  final getMovements = GetMovements(inventoryRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginUseCase>.value(value: loginUseCase),
        RepositoryProvider<GetSavedUser>.value(value: getSavedUser),
        RepositoryProvider<LogoutUseCase>.value(value: logoutUseCase),
        RepositoryProvider<GetInventoryItems>.value(value: getInventoryItems),
        RepositoryProvider<AddInventoryItem>.value(value: addInventoryItem),
        RepositoryProvider<UpdateInventoryItem>.value(value: updateInventoryItem),
        RepositoryProvider<DeleteInventoryItem>.value(value: deleteInventoryItem),
        RepositoryProvider<GetSupplyRequests>.value(value: getSupplyRequests),
        RepositoryProvider<GetNotifications>.value(value: getNotifications),
        RepositoryProvider<GetWarehouses>.value(value: getWarehouses),
        RepositoryProvider<GetMovements>.value(value: getMovements),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              loginUseCase: context.read<LoginUseCase>(),
              getSavedUser: context.read<GetSavedUser>(),
              logoutUseCase: context.read<LogoutUseCase>(),
            )..add(AppStarted()),
          ),
          BlocProvider<InventoryBloc>(
            create: (context) => InventoryBloc(
              getInventoryItems: context.read<GetInventoryItems>(),
              addInventoryItem: context.read<AddInventoryItem>(),
              updateInventoryItem: context.read<UpdateInventoryItem>(),
              deleteInventoryItem: context.read<DeleteInventoryItem>(),
              getSupplyRequests: context.read<GetSupplyRequests>(),
              getNotifications: context.read<GetNotifications>(),
              getWarehouses: context.read<GetWarehouses>(),
              getMovements: context.read<GetMovements>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isArabic = state.isArabic;
        
        return MaterialApp(
          title: 'MilStock',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(isArabic),
          locale: isArabic ? const Locale('ar') : const Locale('en'),
          localizationsDelegates: [
            AppLocalizationsDelegate(isArabic),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          home: _getHomePage(state),
        );
      },
    );
  }

  Widget _getHomePage(AuthState state) {
    if (state is Authenticated) {
      return DashboardPage(user: state.user);
    }
    return const LoginPage();
  }
}
