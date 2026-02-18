import 'package:cureta/features/authentcation/veiw_model/rive_animation_manager.dart';
import 'package:cureta/features/authentcation/widgets/login_fields.dart';
import 'package:cureta/features/authentcation/widgets/animated_login_header.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

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
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        _animationManager.playSuccess();
      } else {
        _animationManager.playFail();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxl + spacing.lg),
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
            ),
          ),
        ],
      ),
    );
  }
}
