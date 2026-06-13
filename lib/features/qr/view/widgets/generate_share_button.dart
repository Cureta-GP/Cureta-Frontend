import 'package:cureta/features/qr/view_model/qr_generate_token_cubit.dart';
import 'package:cureta/features/qr/view_model/qr_generate_token_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateShareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ValueChanged<String> onTokenGenerated;

  const GenerateShareButton({
    super.key,
    required this.onPressed,
    required this.onTokenGenerated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrGenerateTokenCubit, QrGenerateTokenState>(
      listener: (context, state) {
        if (state is QrGenerateTokenSuccess) {
          onTokenGenerated(state.token);
        }
        if (state is QrGenerateTokenError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is QrGenerateTokenLoading;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.qr_code_2_rounded),
            label: Text(
              isLoading ? 'Generating link...' : 'Generate share link',
            ),
          ),
        );
      },
    );
  }
}
