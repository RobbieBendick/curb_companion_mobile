class Env {
  late String backendURL;

  Env(String? backendURL) {
    if (backendURL == null) {
      throw Exception("BACKEND_URL not set");
    } else {
      this.backendURL = backendURL;
    }
  }
}
