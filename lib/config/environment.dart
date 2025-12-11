class Env {
  static const baseURL = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:9000/api',
  );
}
