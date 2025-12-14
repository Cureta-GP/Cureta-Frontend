// widgets/signup_form.dart
import 'package:cureta/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import 'google_button.dart';
import 'login_link.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Creating account...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 47),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameController,
              validator: (value) => Validators.fullName(value),
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hint: 'Create a password',
              controller: _passwordController,
              isPassword: true,
              validator: (value) => Validators.password(value),
              prefixIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Phone Number (Optional)',
              hint: 'Enter your phone number',
              controller: _addressController,
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Create Account', onPressed: _handleSubmit),
            const SizedBox(height: 16),
            const GoogleButton(),
            const SizedBox(height: 24),
            const LoginLink(),
          ],
        ),
      ),
    );
  }
}
