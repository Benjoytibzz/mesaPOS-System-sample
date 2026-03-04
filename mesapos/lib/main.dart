import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'repositories/booking_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/menu_repository.dart';
import 'repositories/customer_repository.dart';
import 'repositories/staff_repository.dart';
import 'controllers/booking_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/customer_controller.dart';
import 'controllers/schedule_controller.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/auth/login_view.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final apiService = ApiService();
  final authService = AuthService();
  final databaseService = DatabaseService();
  
  // Initialize mock data
  await databaseService.initializeMockData();
  
  // Check for saved session
  final hasSession = await authService.checkSavedSession();
  
  runApp(MyApp(
    apiService: apiService,
    authService: authService,
    databaseService: databaseService,
    hasSession: hasSession,
  ));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final AuthService authService;
  final DatabaseService databaseService;
  final bool hasSession;

  const MyApp({
    Key? key,
    required this.apiService,
    required this.authService,
    required this.databaseService,
    required this.hasSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider.value(value: apiService),
        Provider.value(value: authService),
        Provider.value(value: databaseService),
        
        // Repositories
        ProxyProvider2<DatabaseService, ApiService, BookingRepository>(
          update: (context, db, api, _) => BookingRepository(
            databaseService: db,
            apiService: api,
          ),
        ),
        ProxyProvider2<DatabaseService, ApiService, OrderRepository>(
          update: (context, db, api, _) => OrderRepository(
            databaseService: db,
            apiService: api,
          ),
        ),
        ProxyProvider2<DatabaseService, ApiService, MenuRepository>(
          update: (context, db, api, _) => MenuRepository(
            databaseService: db,
            apiService: api,
          ),
        ),
        ProxyProvider2<DatabaseService, ApiService, CustomerRepository>(
          update: (context, db, api, _) => CustomerRepository(
            databaseService: db,
            apiService: api,
          ),
        ),
        ProxyProvider3<DatabaseService, ApiService, AuthService, StaffRepository>(
          update: (context, db, api, auth, _) => StaffRepository(
            databaseService: db,
            apiService: api,
            authService: auth,
          ),
        ),
        
        // Controllers
        ChangeNotifierProxyProvider<BookingRepository, BookingController>(
          create: (context) => BookingController(
            repository: context.read<BookingRepository>(),
            authService: context.read<AuthService>(),
          ),
          update: (context, repository, previous) => BookingController(
            repository: repository,
            authService: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProxyProvider3<OrderRepository, MenuRepository, AuthService, OrderController>(
          create: (context) => OrderController(
            orderRepository: context.read<OrderRepository>(),
            menuRepository: context.read<MenuRepository>(),
            authService: context.read<AuthService>(),
          ),
          update: (context, orderRepo, menuRepo, auth, previous) => OrderController(
            orderRepository: orderRepo,
            menuRepository: menuRepo,
            authService: auth,
          ),
        ),
        ChangeNotifierProxyProvider<CustomerRepository, CustomerController>(
          create: (context) => CustomerController(
            repository: context.read<CustomerRepository>(),
          ),
          update: (context, repository, previous) => CustomerController(
            repository: repository,
          ),
        ),
        ChangeNotifierProxyProvider<StaffRepository, ScheduleController>(
          create: (context) => ScheduleController(
            repository: context.read<StaffRepository>(),
          ),
          update: (context, repository, previous) => ScheduleController(
            repository: repository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Staff Dashboard POS',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: hasSession ? const DashboardView() : const LoginView(),
      ),
    );
  }
}