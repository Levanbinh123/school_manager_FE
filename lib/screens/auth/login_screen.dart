import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/screens/home/home_screen.dart';

import '../../viewmodels/auth/auth_cubit.dart';
import '../../viewmodels/auth/auth_state.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();


  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }


  void login() {

    final email =
    emailController.text.trim();

    final password =
        passwordController.text;


    if (email.isEmpty ||
        password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập đầy đủ thông tin',
          ),
        ),
      );

      return;
    }


    context.read<AuthCubit>().login(
      email: email,
      password: password,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: BlocListener<AuthCubit, AuthState>(

        listener: (context, state) {

          if (state is AuthLoginSuccess) {

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Đăng nhập thành công',
                ),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const HomeScreen(),
              ),
            );
          }


          if (state is AuthFailure) {

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },


        child: BlocBuilder<AuthCubit, AuthState>(

          builder: (context, state) {

            final isLoading =
            state is AuthLoading;


            return Padding(

              padding:
              const EdgeInsets.all(24),

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  TextField(
                    controller:
                    emailController,

                    keyboardType:
                    TextInputType.emailAddress,

                    decoration:
                    const InputDecoration(
                      labelText: 'Email',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                    passwordController,

                    obscureText: true,

                    decoration:
                    const InputDecoration(
                      labelText: 'Password',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  SizedBox(

                    width:
                    double.infinity,

                    child:
                    ElevatedButton(

                      onPressed:
                      isLoading
                          ? null
                          : login,

                      child:

                      isLoading

                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )

                          : const Text(
                        'Login',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}