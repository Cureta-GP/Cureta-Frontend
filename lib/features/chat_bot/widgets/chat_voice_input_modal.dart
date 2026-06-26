import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatVoiceInputModal extends StatefulWidget {
  const ChatVoiceInputModal({super.key});

  @override
  State<ChatVoiceInputModal> createState() => _ChatVoiceInputModalState();
}

class _ChatVoiceInputModalState extends State<ChatVoiceInputModal> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    // Release the microphone/recognition session if the sheet is dismissed
    // (scrim tap, back gesture, Cancel) while still listening.
    _speech.cancel();
    super.dispose();
  }

  Future<void> _startListening() async {
    final status = await Permission.microphone.request();
    if (!mounted) return;
    if (status != PermissionStatus.granted) {
      setState(() => _error = 'chat_mic_permission_required'.tr());
      return;
    }

    try {
      final available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            if (!mounted) return;
            setState(() => _isListening = false);
            // Optionally auto-send when done, but let user confirm to avoid mistakes
          }
        },
        onError: (val) {
          if (!mounted) return;
          setState(() => _error = 'chat_mic_error'.tr(namedArgs: {'error': val.errorMsg}));
        },
      );
      if (!mounted) return;

      if (available) {
        setState(() {
          _isListening = true;
          _error = null;
        });
        _speech.listen(
          onResult: (val) {
            if (!mounted) return;
            setState(() {
              _text = val.recognizedWords;
            });
          },
          localeId: context.locale.languageCode == 'ar' ? 'ar_EG' : 'en_US',
          pauseFor: const Duration(seconds: 4),
          listenFor: const Duration(seconds: 60),
          listenOptions: stt.SpeechListenOptions(listenMode: stt.ListenMode.dictation),
        );
      } else {
        setState(() => _error = 'chat_mic_init_failed'.tr());
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _stopListening() {
    _speech.stop();
    if (!mounted) return;
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final colors = context.colors;
    final typo = context.typography;

    return Container(
      padding: EdgeInsets.only(
        left: sp.lg,
        right: sp.lg,
        top: sp.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + sp.xl,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.radius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: sp.lg),
          Text(
            _isListening ? 'copilot_listening'.tr() : 'copilot_tap_to_speak'.tr(),
            style: typo.label.copyWith(
              color: _isListening ? colors.primary : colors.textPrimary,
            ),
          ),
          SizedBox(height: sp.lg),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 100),
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(context.radius.md),
            ),
            child: Text(
              _text.isEmpty ? 'chat_speak_now'.tr() : _text,
              style: typo.body.copyWith(
                color: _text.isEmpty ? colors.textHint : colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_error != null) ...[
            SizedBox(height: sp.sm),
            Text(
              _error!,
              style: typo.label.copyWith(color: colors.error),
            ),
          ],
          SizedBox(height: sp.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('chat_cancel'.tr(), style: typo.label.copyWith(color: colors.textSecondary)),
              ),
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  padding: EdgeInsets.all(sp.md),
                  decoration: BoxDecoration(
                    color: _isListening ? colors.primary : colors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.primary),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? colors.surface : colors.primary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _text.trim().isEmpty
                    ? null
                    : () {
                        _stopListening();
                        Navigator.of(context).pop(_text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.surface,
                ),
                child: Text('chat_send'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
