import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041618),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xFFF9FAFB)),
        child: Center(
          child: Container(
            width: 390,
            height: 844,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 50,
                  offset: Offset(0, 25),
                  spreadRadius: -12,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Container(
                height: 844,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Colors.white, Colors.white], // Fixed: Added second color
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      top: 164,
                      child: SizedBox(
                        width: 360,
                        height: 660,
                        child: Stack(
                          children: [
                            // Full Name Field
                            Positioned(
                              left: 32,
                              top: 0,
                              child: SizedBox(
                                width: 296,
                                height: 92,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 24,
                                      child: Text(
                                        'Full Name',
                                        style: TextStyle(
                                          color: const Color(0xFF354152),
                                          fontSize: 16,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 296,
                                      height: 56,
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 48,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFEDF7F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Enter your full name',
                                            style: TextStyle(
                                              color: const Color(0x7F0A0A0A),
                                              fontSize: 16,
                                              fontFamily: 'Arimo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Email Field
                            Positioned(
                              left: 32,
                              top: 112,
                              child: SizedBox(
                                width: 296,
                                height: 92,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 24,
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          color: const Color(0xFF354152),
                                          fontSize: 16,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 296,
                                      height: 56,
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 48,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFEDF7F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Enter your email',
                                            style: TextStyle(
                                              color: const Color(0x7F0A0A0A),
                                              fontSize: 16,
                                              fontFamily: 'Arimo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Password Field
                            Positioned(
                              left: 32,
                              top: 224,
                              child: SizedBox(
                                width: 296,
                                height: 92,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 24,
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                          color: const Color(0xFF354152),
                                          fontSize: 16,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 296,
                                      height: 56,
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 48,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFEDF7F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Create a password',
                                            style: TextStyle(
                                              color: const Color(0x7F0A0A0A),
                                              fontSize: 16,
                                              fontFamily: 'Arimo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Address Field
                            Positioned(
                              left: 32,
                              top: 336,
                              child: SizedBox(
                                width: 296,
                                height: 92,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 24,
                                      child: Text(
                                        'Address (Optional)',
                                        style: TextStyle(
                                          color: const Color(0xFF354152),
                                          fontSize: 16,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 296,
                                      height: 56,
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 48,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFEDF7F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Enter your address',
                                            style: TextStyle(
                                              color: const Color(0x7F0A0A0A),
                                              fontSize: 16,
                                              fontFamily: 'Arimo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Create Account Button
                            Positioned(
                              left: 32,
                              top: 448,
                              child: Container(
                                width: 296,
                                height: 56,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF00A1A9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                      spreadRadius: -4,
                                    ),
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 15,
                                      offset: Offset(0, 10),
                                      spreadRadius: -3,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Create Account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Google Button
                            Positioned(
                              left: 32,
                              top: 520,
                              child: Container(
                                width: 296,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: const Color(0xFFD0D5DB),
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                      spreadRadius: -1,
                                    ),
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Continue with Google',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF354152),
                                      fontSize: 16,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Already have account text
                            Positioned(
                              left: 32,
                              top: 604,
                              child: SizedBox(
                                width: 296,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF495565),
                                        fontSize: 16,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                    Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF00A1A9),
                                        fontSize: 16,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Header
                    Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        width: 390,
                        height: 164,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 64),
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF133A3E),
                                fontSize: 32,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w400,
                                height: 1.03,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Join Cureta today',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF495565),
                                fontSize: 16,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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