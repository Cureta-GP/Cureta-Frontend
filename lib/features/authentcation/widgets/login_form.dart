import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_state.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/features/authentcation/veiw_model/rive_animation_manager.dart';
import 'package:cureta/features/authentcation/widgets/login_fields.dart';
import 'package:cureta/features/authentcation/widgets/animated_login_header.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  late final RiveAnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    _animationManager = RiveAnimationManager();
    _animationManager.initialize();
    _setupPasswordFocusListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationManager.updateDirection(Directionality.of(context));
  }

  void _setupPasswordFocusListener() {
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _animationManager.playHandsUp();
      } else {
        _animationManager.playHandsDown();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    _passwordFocusNode.unfocus();
    final cubit = context.read<AuthCubit>();

    if (_formKey.currentState!.validate()) {
      cubit.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Play success animation and navigate
          _animationManager.playSuccess();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              GoRouter.of(context).go(AppRoutes.home);
            }
          });
        } else if (state is AuthError) {
          // Play fail animation and show error
          _animationManager.playFail();
          if (state.exception != null) {
            ErrorHandler.show(context, state.exception!);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
        child: Column(
          children: [
            AnimatedLoginHeader(animationManager: _animationManager),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: LoginFields(
                emailController: _emailController,
                passwordController: _passwordController,
                passwordFocusNode: _passwordFocusNode,
                onEmailChanged: _animationManager.handleEmailChange,
                onSubmit: _handleSubmit,
                isLoading: context.select<AuthCubit, bool>(
                  (cubit) => cubit.state is AuthLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
