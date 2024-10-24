import 'package:curb_companion/features/location/presentation/location_screen.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/pages/auth_screen.dart';
import 'package:curb_companion/features/getting_started/presentation/getting_started.dart';
import 'package:curb_companion/pages/index_screen.dart';
import 'package:curb_companion/features/recent_search/data/recent_search_adapter.dart';
import 'package:curb_companion/features/location/domain/cc_address.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/user/data/user_adapter.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/shared/models/env.dart';
import 'package:curb_companion/utils/helpers/theme_helper.dart';
import 'package:curb_companion/utils/services/firebase_service.dart';
import 'package:curb_companion/utils/services/geolocator_service.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure that the app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.init();

  // Set the orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Hive & register the CCPosition adapter.
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(CCAddressAdapter())
    ..registerAdapter(CCLocationAdapter())
    ..registerAdapter(RecentSearchItemAdapter())
    ..registerAdapter(UserAdapter());

  // Initialize the theme service
  ThemeService themeService = ThemeService();
  await themeService.load();

  // Create a ProviderContainer
  final container = riverpod.ProviderContainer();
  await dotenv.load(fileName: ".env");
  Env env = Env(dotenv.env["BACKEND_URL"]);

  if (kDebugMode) {
    print(env.backendURL);
  }

  // Register the state providers in the container for use in this file
  container
    ..read(locationStateProvider.notifier)
    ..read(userStateProvider.notifier);

  // Read the state providers from the container for use in this file
  final userNotifier = container.read(userStateProvider.notifier);
  final locationNotifier = container.read(locationStateProvider.notifier);

  // Initialize the route stack
  List<MaterialPageRoute> routeStack = [];

  // Checks if the user has location services enabled for their device.
  bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  await locationNotifier.load();

  // Add the home screen to the route stack if the user is logged in.
  // Otherwise, add the auth screen to the route stack.
  bool loggedIn = await userNotifier.verifyTokens();
  if (loggedIn) {
    routeStack
        .add(MaterialPageRoute(builder: (context) => const IndexScreen()));
  } else {
    routeStack.add(MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  if (!loggedIn) {
    // Add the getting started screen to the route stack
    routeStack.add(
        MaterialPageRoute(builder: (context) => const GettingStartedScreen()));
  }

  if (locationServiceEnabled) {
    if (await GeolocatorService.isPermissionOnlyDenied() &&
        locationNotifier.lastKnownLocation == null) {
      routeStack
          .add(MaterialPageRoute(builder: (context) => const LocationScreen()));
    }
  } else {
    routeStack
        .add(MaterialPageRoute(builder: (context) => const LocationScreen()));
  }

  runApp(
    riverpod.ProviderScope(
      overrides: [
        userStateProvider.overrideWith((ref) => userNotifier),
        locationStateProvider.overrideWith((ref) => locationNotifier)
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeService),
        ],
        child: App(
          darkTheme: await ThemeHelper.getDarkTheme(),
          theme: await ThemeHelper.getLightTheme(),
          routeStack: routeStack,
          navigatorKey: navigatorKey,
        ),
      ),
    ),
  );
}

class App extends riverpod.ConsumerWidget {
  final ThemeData theme;
  final ThemeData darkTheme;
  final List<MaterialPageRoute> routeStack;
  final GlobalKey<NavigatorState> navigatorKey;
  const App(
      {super.key,
      required this.darkTheme,
      required this.theme,
      required this.routeStack,
      required this.navigatorKey});

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    // Create the theme service
    return Consumer<ThemeService>(
      builder: (context, ThemeService themeService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Curb Companion',
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeService.themeMode,
          routes: Routes.buildRoutes(),
          initialRoute: Routes.gettingStartedScreen,
          navigatorKey: navigatorKey,
          onGenerateInitialRoutes: (String initialRoute) => routeStack,
        );
      },
    );
  }
}
