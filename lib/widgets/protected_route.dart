import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../provider/auth_provider.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();

    return authProvider.user != null ? child : LoginPage();
  }
}