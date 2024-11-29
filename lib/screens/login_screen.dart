import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/login_cubit.dart';
import 'package:inovokasi_rebuild/Theme.dart'; // Asumsikan ini file custom theme Anda

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigasi ke halaman Dashboard
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (state is LoginFailure) {
              // Tampilkan pesan error jika login gagal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(
                  top: 100,
                  bottom: 50,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/duck.png')),
                ),
              ),
              Text(
                'Halo',
                textAlign: TextAlign.center,
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan masuk untuk melanjutkan',
                textAlign: TextAlign.center,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: regular,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Email',
                textAlign: TextAlign.left,
                style: blackTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: regular,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  fillColor: greyColor,
                  iconColor: greyColor,
                  hoverColor: greenColor,
                  focusColor: greyColor,
                  prefixIconColor: greyColor,
                  suffixIconColor: greyColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Password',
                textAlign: TextAlign.left,
                style: blackTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: regular,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  fillColor: greyColor,
                  iconColor: greyColor,
                  focusColor: greyColor,
                  prefixIconColor: greyColor,
                  suffixIconColor: greyColor,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        final email = emailController.text;
                        final password = passwordController.text;
                        // Panggil login method dari Cubit
                        context.read<LoginCubit>().login(email, password);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: whitekTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
