import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'forgot_password_state.dart';
import '../data/repo/auth_repository.dart'; 

class ForgotPasswordViewModel extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;
  
  // Store OTP for the flow
  late String _currentOtp;

  ForgotPasswordViewModel(this.authRepository) : super(ForgotPasswordInitial());

  Future<void> sendOTP(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await authRepository.forgotPassword(email: email);
      emit(ForgotPasswordEmailSentSuccess());
    } on AppException catch (e) {
      emit(ForgotPasswordError(e.message));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> verifyOTP(String otp) async {
    emit(ForgotPasswordLoading());
    try {
      _currentOtp = otp;
      // OTP verification happens during resetPassword
      emit(ForgotPasswordEmailSentSuccess()); // Move to password reset step
    } on AppException catch (e) {
      emit(ForgotPasswordError(e.message));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    emit(ForgotPasswordLoading());
    try {
      // Use stored OTP if not provided
      final finalOtp = otp.isNotEmpty ? otp : _currentOtp;
      await authRepository.resetPassword(
        otp: finalOtp,
        newPassword: newPassword,
      );
      emit(ResetPasswordSuccess());
    } on AppException catch (e) {
      emit(ForgotPasswordError(e.message));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}