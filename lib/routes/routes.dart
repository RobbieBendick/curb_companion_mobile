import 'package:curb_companion/features/location/presentation/location_cancel_screen.dart';
import 'package:curb_companion/features/user/presentation/account_screen.dart';
import 'package:curb_companion/features/user/presentation/settings_screen.dart';
import 'package:curb_companion/features/forgot_password/presentation/forgot_password_screen.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_screen.dart';
import 'package:curb_companion/pages/auth_screen.dart';
import 'package:curb_companion/pages/catering_request_screen.dart';
import 'package:curb_companion/features/getting_started/presentation/getting_started.dart';
import 'package:curb_companion/features/home/presentation/hero_search_screen.dart';
import 'package:curb_companion/features/home/presentation/search_list_view.dart';
import 'package:curb_companion/features/home/presentation/see_more_recent_search_screen.dart';
import 'package:curb_companion/features/home/presentation/vendor_more_info_screen.dart';
import 'package:curb_companion/pages/index_screen.dart';
import 'package:curb_companion/features/location/presentation/location_screen.dart';
import 'package:curb_companion/features/registration/presentation/registration_screen.dart';
import 'package:curb_companion/features/notifications/presentation/notifications_screen.dart';
import 'package:curb_companion/features/review/presentation/create_review_screen.dart';
import 'package:curb_companion/features/review/presentation/review_vendor_screen.dart';
import 'package:curb_companion/features/vendor/vendor_profile_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String gettingStartedScreen = 'getting-started';
  static const String locationServicesScreen = 'location-services';
  static const String locationServicesCancelScreen = 'location-services-cancel';
  static const String authScreen = 'auth';
  static const String registrationScreen = 'registration';
  static const String forgotPasswordScreen = 'forgot-password';
  static const String homeScreen = 'home';
  static const String searchScreen = 'search';
  static const String heroSearchScreen = 'hero-search';
  static const String notificationScreen = 'user-notifications';
  static const String vendorScreen = 'vendor';
  static const String searchListScreen = 'search-list';
  static const String accountScreen = 'account';
  static const String settingsScreen = 'settings';
  static const String vendorMoreInfoScreen = 'vendor-more-info';
  static const String cateringRequestScreen = 'catering-request';
  static const String seeMoreRecentSearchesScreen = 'see-more-recent-searches';
  static const String reviewVendorScreen = 'review-vendor';
  static const String createReviewScreen = 'create-review';
  static const String autoCompleteScreen = 'autocomplete';

  static Map<String, WidgetBuilder> buildRoutes() {
    return {
      gettingStartedScreen: (context) => const GettingStartedScreen(),
      locationServicesScreen: (context) => const LocationScreen(),
      locationServicesCancelScreen: (context) => const LocationCancelScreen(),
      authScreen: (context) => const AuthScreen(),
      registrationScreen: (context) => const RegistrationScreen(),
      forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
      homeScreen: (context) => const IndexScreen(),
      heroSearchScreen: (context) => const HeroSearchScreen(),
      notificationScreen: (context) => const NotificationScreen(),
      vendorScreen: (context) => const VendorProfileScreen(),
      searchListScreen: (context) => const SearchListScreen(),
      accountScreen: (context) => const AccountScreen(),
      vendorMoreInfoScreen: (context) => const VendorMoreInfoScreen(),
      cateringRequestScreen: (context) => const CateringRequestScreen(),
      seeMoreRecentSearchesScreen: (context) =>
          const SeeMoreRecentSearchesScreen(),
      reviewVendorScreen: (context) => const ReviewVendorScreen(),
      settingsScreen: (context) => const SettingsScreen(),
      createReviewScreen: (context) => const CreateReviewScreen(),
      autoCompleteScreen: (context) => const AutocompleteScreen(),
    };
  }
}
