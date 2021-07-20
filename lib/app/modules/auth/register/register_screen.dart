import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/auth/auth_controller.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Modular.get<AuthController>();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
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
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  validator: (value) {
                    if (value != null && value.isEmpty) return 'Campo necessário';
                  },
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  validator: (value) {
                    if (value != null && value.isEmpty) return 'Campo necessário';
                  },
                  decoration: InputDecoration(labelText: 'Usuário'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo necessário';

                    if (!EmailValidator.validate(value)) return 'E-mail inválido';
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: !visiblePassword,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.isEmpty) return 'Campo necessário';
                  },
                  onFieldSubmitted: (_) {
                    _register();
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
                ),
                SizedBox(height: 32),
                RxBuilder(
                  builder: (context) {
                    if (controller.stateRegister.value == RequestState.LOADING)
                      return Center(child: CircularProgressIndicator());

                    return SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _register,
                        child: Text('REGISTRAR'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: TextButton(
                    onPressed: () {
                      Modular.to.pop();
                    },
                    child: Text('VOLTAR'),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    Unifier.hideKeyboard(context);

    if (_formKey.currentState?.validate() ?? false)
      controller.register(
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
  }
}
