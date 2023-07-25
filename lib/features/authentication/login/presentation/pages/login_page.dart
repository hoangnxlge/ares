import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../shared/widgets/app_snack_bar.dart';
import '../../../../../shared/widgets/loading_dialog.dart';
import '../../../../../utils/di/injections.dart';
import '../../../../../utils/navigator/app_routing.dart';
import '../bloc/login_bloc.dart';

class LoginRoute {
  static Widget get route => BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(loginUseCase: getIt()),
        child: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final bloc = context.read<LoginBloc>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          LoadingDialog.hide();
          state.whenOrNull(
            loading: LoadingDialog.show,
            success: () {
              Navigator.pushReplacementNamed(context, Routes.homePage.name);
            },
            error: (e) => AppSnackBar.show(message: e),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              TextField(
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  bloc.add(
                    LoginEvent.login(
                      username: usernameController.text,
                      password: passwordController.text,
                    ),
                  );
                },
                child: const Text(LocaleKeys.login).tr(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
