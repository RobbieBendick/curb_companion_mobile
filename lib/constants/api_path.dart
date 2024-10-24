import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Holds all the API paths used by the app.
class ApiPath {
  String apiPath;

  /// Dynamically constructs the proper API path to be used for the current
  /// platform the app is being ran on.
  ApiPath(this.apiPath);
}

final String apiPath = dotenv.env["BACKEND_URL"]!;
