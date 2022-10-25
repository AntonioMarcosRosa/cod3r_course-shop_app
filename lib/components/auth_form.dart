import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

enum AuthMode { signUp, signIn }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.signUp;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isSingIn() => _authMode == AuthMode.signIn;
  bool _isSingUp() => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(() {
      _authMode = _isSingIn() ? AuthMode.signUp : AuthMode.signIn;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of<Auth>(context, listen: false);

    if (_isSingIn()) {
      await auth.singIn(_authData['email']!, _authData['password']!);
    } else {
      await auth.singUp(_authData['email']!, _authData['password']!);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: _isSingIn() ? 310 : 400,
        width: (deviceSize.width * 0.75),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: _isSingIn()
                      ? null
                      : (_email) {
                          final email = _email ?? '';
                          if (email.trim().isEmpty || !email.contains('@')) {
                            return 'E-mail inválido';
                          }
                        },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.text,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  obscureText: true,
                  controller: _passwordController,
                  validator: (_passswor) {
                    final password = _passswor ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Password inválido';
                    }
                  },
                ),
                if (_isSingUp())
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirme a senha'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (_passswor) {
                      final password = _passswor ?? '';
                      if (password != _passwordController.text) {
                        return 'Password diferente';
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: 24,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        )),
                    child: Text(
                      _isSingUp() ? 'REGISTAR' : 'ENTRAR',
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => _switchAuthMode(),
                  child: Text(
                    _isSingUp() ? 'Fazer Login' : 'Registrar-se',
                  ),
                )
              ],
            )),
      ),
    );
  }
}
