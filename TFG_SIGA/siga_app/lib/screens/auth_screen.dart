import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final AuthService authService = AuthService();

  final codigoController = TextEditingController();

  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;

  bool isLoading = false;

  Future<void> submit() async {

    setState(() => isLoading = true);

    bool success;

    if (isLogin) {

      success = await authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

    } else {

      success = await authService.sendCode(
        nombre: nombreController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (success && mounted) {

        mostrarDialogoCodigo();

        setState(() => isLoading = false);

        return;
      }
    }

    setState(() => isLoading = false);

    if (success && mounted) {

      Navigator.pushReplacementNamed(context, '/home');

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error de autenticación"),
        ),
      );
    }
  }

  Future<void> mostrarDialogoCodigo() async {

  showDialog(
    context: context,
    barrierDismissible: false,

    builder: (_) {

      return AlertDialog(

        title: const Text(
          "Verificar correo",
        ),

        content: TextField(
          controller: codigoController,
          keyboardType: TextInputType.number,

          decoration: const InputDecoration(
            labelText: "Código",
          ),
        ),

        actions: [

          ElevatedButton(

            onPressed: () async {

              try {

                await authService.verifyCode(

                  email: emailController.text,

                  codigo: int.parse(
                    codigoController.text,
                  ),
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      "Cuenta verificada correctamente",
                    ),
                  ),
                );

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (route) => false,
                );

              } catch (e) {

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  SnackBar(
                    content: Text(
                      e.toString()
                          .replaceFirst('Exception: ', '')
                          .replaceFirst('400 - ', ''),
                    ),
                  ),
                );
              }
            },

            child: const Text(
              "Verificar",
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            if (!isLogin)
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isLoading ? null : submit,

              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      isLogin
                          ? 'Entrar'
                          : 'Registrarse',
                    ),
            ),

            const SizedBox(height: 20),

            TextButton(

              onPressed: () {

                setState(() {
                  isLogin = !isLogin;
                });
              },

              child: Text(
                isLogin
                    ? 'Crear cuenta'
                    : 'Ya tengo cuenta',
              ),
            ),
          ],
        ),
      ),
    );
  }
}