class Env {
  static const baseURL = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://localhost:5000/api',
  );
}
