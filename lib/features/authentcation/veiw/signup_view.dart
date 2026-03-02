import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/authentcation/widgets/signup_form.dart';
import 'package:cureta/features/authentcation/widgets/signup_header.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(),
          child: Center(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.xl * 2),
                ),
                shadows: [
                  /*BoxShadow(
                    //color: Color(0x3F000000),
                    blurRadius: 50,
                    offset: Offset(0, 25),
                    spreadRadius: -12,
                  ),*/
                ],
              ),
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 0),
                  decoration: const BoxDecoration(
                    /*gradient: LinearGradient(
                      begin: Alignment(0.50, 0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [Colors.white, Colors.white],
                    ),*/
                  ),
                  child: Column(
                    children: [
                      const SignupHeader(),
                      SizedBox(height: spacing.xl),
                      const SignupForm(),
                      SizedBox(height: spacing.xxl + spacing.sm),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
