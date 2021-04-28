import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/auth/auth_controller.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ModularState<LoginScreen, AuthController> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/image.png'),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Usuário'),
                  validator: (value) {
                    if (value != null && value.isEmpty) return 'Campo necessário';
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: !visiblePassword,
                  controller: _passwordController,
                  onFieldSubmitted: (_) {
                    _login();
                  },
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        visiblePassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          visiblePassword = !visiblePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) return 'Campo necessário';
                  },
                ),
                SizedBox(height: 40),
                RxBuilder(
                  builder: (context) {
                    if (controller.stateLogin.value == RequestState.LOADING) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: _login,
                      child: Text('ENTRAR'),
                    );
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Modular.to.pushNamed('register');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: UnifierColors.tertiaryColor,
                    onPrimary: UnifierColors.secondaryColor,
                  ),
                  child: Text('CRIAR CONTA'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    Unifier.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false)
      controller.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
  }
}
