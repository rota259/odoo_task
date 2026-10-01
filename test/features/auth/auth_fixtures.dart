import 'package:odoo_task/core/storage/stored_credentials.dart';
import 'package:odoo_task/features/auth/domain/entities/auth_user.dart';
import 'package:odoo_task/features/auth/domain/entities/login_request.dart';

const authUser = AuthUser(
  uid: 2,
  name: 'Mitchell Admin',
  login: 'admin',
  database: 'odoo_demo',
  baseUrl: 'http://odoo:8069',
  isInternal: true,
);
const authRequest = LoginRequest(
  baseUrl: 'http://odoo:8069',
  database: 'odoo_demo',
  login: 'admin',
  password: 'admin',
);

const portalRequest = LoginRequest(
  baseUrl: 'http://odoo:8069/',
  database: 'odoo_demo',
  login: 'portal',
  password: 'portal',
);

const portalStored = StoredCredentials(
  baseUrl: 'http://odoo:8069',
  database: 'odoo_demo',
  login: 'portal',
  password: 'portal',
);
