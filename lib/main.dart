import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/inventory/data/datasources/inventory_local_datasource.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/usecases/inventory_usecases.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/inventory/presentation/pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Auth Data Sources & Repositories
  final authLocalDataSource = AuthLocalDataSourceImpl();
  final authRepository = AuthRepositoryImpl(localDataSource: authLocalDataSource);
  final loginUseCase = LoginUseCase(authRepository);

  // Initialize Inventory Data Sources & Repositories
  final inventoryLocalDataSource = InventoryLocalDataSourceImpl();
  final inventoryRepository = InventoryRepositoryImpl(localDataSource: inventoryLocalDataSource);
  
  final getInventoryItems = GetInventoryItems(inventoryRepository);
  final addInventoryItem = AddInventoryItem(inventoryRepository);
  final getSupplyRequests = GetSupplyRequests(inventoryRepository);
  final getNotifications = GetNotifications(inventoryRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginUseCase>.value(value: loginUseCase),
        RepositoryProvider<GetInventoryItems>.value(value: getInventoryItems),
        RepositoryProvider<AddInventoryItem>.value(value: addInventoryItem),
        RepositoryProvider<GetSupplyRequests>.value(value: getSupplyRequests),
        RepositoryProvider<GetNotifications>.value(value: getNotifications),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              loginUseCase: context.read<LoginUseCase>(),
            ),
          ),
          BlocProvider<InventoryBloc>(
            create: (context) => InventoryBloc(
              getInventoryItems: context.read<GetInventoryItems>(),
              addInventoryItem: context.read<AddInventoryItem>(),
              getSupplyRequests: context.read<GetSupplyRequests>(),
              getNotifications: context.read<GetNotifications>(),
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
