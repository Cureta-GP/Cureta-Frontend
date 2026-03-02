import 'package:cureta/features/authentcation/widgets/login_form.dart';
import 'package:cureta/features/authentcation/widgets/login_container.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            //color: AppColors.background,
          ),
          child: Center(
            child: LoginContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: spacing.xxl),
                    const LoginForm(),
                    SizedBox(height: spacing.xxl + spacing.sm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
