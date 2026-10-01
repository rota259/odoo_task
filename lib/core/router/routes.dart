abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const settings = '/settings';
  static const customers = '/customers';
  static const orders = '/orders';
  static const idParam = 'id';

  static String customer(int id) => '$customers/$id';
  static String order(int id) => '$orders/$id';
}
