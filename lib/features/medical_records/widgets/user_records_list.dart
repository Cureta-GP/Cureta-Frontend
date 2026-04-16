import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/user_record_card.dart';
import 'package:flutter/material.dart';

class UserRecordsList extends StatelessWidget {
  const UserRecordsList({super.key, required this.records});

  final List<MedicalRecordModel> records;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ListView.builder(
      addAutomaticKeepAlives: false, // لا تحتفظ تلقائيًا بالحالة
      addRepaintBoundaries: false, // قلل إنشاء الطبقات الزائدة
      cacheExtent: 250, // مسافة التحميل المسبق
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xxl * 2,
      ),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.lg),
          child: _AnimatedRecordItem(
            index: index,
            child: UserRecordCard(record: record),
          ),
        );
      },
    );
  }
}

class _AnimatedRecordItem extends StatefulWidget {
  const _AnimatedRecordItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_AnimatedRecordItem> createState() => _AnimatedRecordItemState();
}

class _AnimatedRecordItemState extends State<_AnimatedRecordItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(curve);

    _fade = Tween<double>(begin: 0, end: 1).animate(curve);

    final delay = Duration(milliseconds: (widget.index * 60).clamp(0, 420));
    Future<void>.delayed(delay, () {
      if (!mounted) return;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
