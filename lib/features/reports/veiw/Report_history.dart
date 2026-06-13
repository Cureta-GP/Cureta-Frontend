import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/profile/veiw_model/profile_cubit.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/reports/veiw_model/Report_cubit.dart';
import 'package:cureta/features/reports/veiw_model/Report_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getUserInfo(),
      child: const HistoryScreenContent(),
    );
  }
}

class HistoryScreenContent extends StatelessWidget {
  const HistoryScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color(0xFFF6F8F8),
        body: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 908),
            child: Container(
                width: 390,
                decoration: BoxDecoration(color: const Color(0xFFF6F8F8)),
                child: Stack(
            children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 908),
                    child: Container(
                        width: double.infinity,
                        height: 908,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(
                            children: [
                                Positioned(
                                    left: 0,
                                    top: 73,
                                    child: Container(
                                        width: 390,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Container(
                                                    width: double.infinity,
                                                    child: Stack(
                                                        children: [
                                                            Expanded(
                                                                child: Container(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 13,
                                                                        left: 40,
                                                                        right: 12,
                                                                        bottom: 14,
                                                                    ),
                                                                    clipBehavior: Clip.antiAlias,
                                                                    decoration: ShapeDecoration(
                                                                        color: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(48),
                                                                        ),
                                                                        shadows: [
                                                                            BoxShadow(
                                                                                color: Color(0x0C000000),
                                                                                blurRadius: 2,
                                                                                offset: Offset(0, 1),
                                                                                spreadRadius: 0,
                                                                            )
                                                                        ],
                                                                    ),
                                                                    child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                            Container(
                                                                                width: double.infinity,
                                                                                clipBehavior: Clip.antiAlias,
                                                                                decoration: BoxDecoration(),
                                                                                child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                        SizedBox(
                                                                                            width: 306,
                                                                                            child: Text(
                                                                                                'Search reports...',
                                                                                                style: TextStyle(
                                                                                                    color: const Color(0xFF6B7280),
                                                                                                    fontSize: 14,
                                                                                                    fontFamily: 'Inter',
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                            ),
                                                                                        ),
                                                                                    ],
                                                                                ),
                                                                            ),
                                                                        ],
                                                                    ),
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                                Positioned(
                                    left: 0,
                                    top: 149,
                                    child: Container(
                                        width: 390,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 12,
                                            children: [
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: 88),
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                                        decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: const Color(0xFFF9FAFB),
                                                                ),
                                                                borderRadius: BorderRadius.circular(48),
                                                            ),
                                                            shadows: [
                                                                BoxShadow(
                                                                    color: Color(0x0C000000),
                                                                    blurRadius: 2,
                                                                    offset: Offset(0, 1),
                                                                    spreadRadius: 0,
                                                                )
                                                            ],
                                                        ),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            spacing: 95.67,
                                                            children: [
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 56,
                                                                            height: 56,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/56x56"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 73.39,
                                                                                                height: 24,
                                                                                                child: Text(
                                                                                                    'John Doe',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF111817),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 86.64,
                                                                                                height: 21,
                                                                                                child: Text(
                                                                                                    'Oct 24, 2023',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF618985),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                                Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    spacing: 8,
                                                                    children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                            decoration: ShapeDecoration(
                                                                                color: const Color(0xFFDCFCE7),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    SizedBox(
                                                                                        width: 45.69,
                                                                                        height: 16,
                                                                                        child: Text(
                                                                                            'STABLE',
                                                                                            style: TextStyle(
                                                                                                color: const Color(0xFF15803D),
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w700,
                                                                                                height: 1.33,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: 28,
                                                                            height: 28,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                        ,
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: 88),
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                                        decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: const Color(0xFFF9FAFB),
                                                                ),
                                                                borderRadius: BorderRadius.circular(48),
                                                            ),
                                                            shadows: [
                                                                BoxShadow(
                                                                    color: Color(0x0C000000),
                                                                    blurRadius: 2,
                                                                    offset: Offset(0, 1),
                                                                    spreadRadius: 0,
                                                                )
                                                            ],
                                                        ),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            spacing: 102.43,
                                                            children: [
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 56,
                                                                            height: 56,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/56x56"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 86.22,
                                                                                                height: 24,
                                                                                                child: Text(
                                                                                                    'Jane Smith',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF111817),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 86.63,
                                                                                                height: 21,
                                                                                                child: Text(
                                                                                                    'Oct 23, 2023',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF618985),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                                Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    spacing: 8,
                                                                    children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                            decoration: ShapeDecoration(
                                                                                color: const Color(0xFFFFEDD5),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    SizedBox(
                                                                                        width: 38.94,
                                                                                        height: 16,
                                                                                        child: Text(
                                                                                            'ALERT',
                                                                                            style: TextStyle(
                                                                                                color: const Color(0xFFC2410C),
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w700,
                                                                                                height: 1.33,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: 28,
                                                                            height: 28,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                        ,
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: 88),
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                                        decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: const Color(0xFFF9FAFB),
                                                                ),
                                                                borderRadius: BorderRadius.circular(48),
                                                            ),
                                                            shadows: [
                                                                BoxShadow(
                                                                    color: Color(0x0C000000),
                                                                    blurRadius: 2,
                                                                    offset: Offset(0, 1),
                                                                    spreadRadius: 0,
                                                                )
                                                            ],
                                                        ),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            spacing: 77.29,
                                                            children: [
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 56,
                                                                            height: 56,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/56x56"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 105.02,
                                                                                                height: 24,
                                                                                                child: Text(
                                                                                                    'Robert Brown',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF111817),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 86.83,
                                                                                                height: 21,
                                                                                                child: Text(
                                                                                                    'Oct 22, 2023',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF618985),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                                Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    spacing: 8,
                                                                    children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                            decoration: ShapeDecoration(
                                                                                color: const Color(0xFFDCFCE7),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    SizedBox(
                                                                                        width: 45.69,
                                                                                        height: 16,
                                                                                        child: Text(
                                                                                            'STABLE',
                                                                                            style: TextStyle(
                                                                                                color: const Color(0xFF15803D),
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w700,
                                                                                                height: 1.33,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: 28,
                                                                            height: 28,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                        ,
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: 88),
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                                        decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: const Color(0xFFF9FAFB),
                                                                ),
                                                                borderRadius: BorderRadius.circular(48),
                                                            ),
                                                            shadows: [
                                                                BoxShadow(
                                                                    color: Color(0x0C000000),
                                                                    blurRadius: 2,
                                                                    offset: Offset(0, 1),
                                                                    spreadRadius: 0,
                                                                )
                                                            ],
                                                        ),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            spacing: 97.75,
                                                            children: [
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 56,
                                                                            height: 56,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/56x56"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 91.31,
                                                                                                height: 24,
                                                                                                child: Text(
                                                                                                    'Emily White',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF111817),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 83.98,
                                                                                                height: 21,
                                                                                                child: Text(
                                                                                                    'Oct 21, 2023',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF618985),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                                Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    spacing: 8,
                                                                    children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                            decoration: ShapeDecoration(
                                                                                color: const Color(0xFFFFEDD5),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    SizedBox(
                                                                                        width: 38.94,
                                                                                        height: 16,
                                                                                        child: Text(
                                                                                            'ALERT',
                                                                                            style: TextStyle(
                                                                                                color: const Color(0xFFC2410C),
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w700,
                                                                                                height: 1.33,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: 28,
                                                                            height: 28,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                        ,
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: 88),
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                                        decoration: ShapeDecoration(
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: const Color(0xFFF9FAFB),
                                                                ),
                                                                borderRadius: BorderRadius.circular(48),
                                                            ),
                                                            shadows: [
                                                                BoxShadow(
                                                                    color: Color(0x0C000000),
                                                                    blurRadius: 2,
                                                                    offset: Offset(0, 1),
                                                                    spreadRadius: 0,
                                                                )
                                                            ],
                                                        ),
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            spacing: 76.72,
                                                            children: [
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 56,
                                                                            height: 56,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/56x56"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                        Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 105.59,
                                                                                                height: 24,
                                                                                                child: Text(
                                                                                                    'Michael Scott',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF111817),
                                                                                                        fontSize: 16,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: BoxDecoration(),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 86.77,
                                                                                                height: 21,
                                                                                                child: Text(
                                                                                                    'Oct 20, 2023',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF618985),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.50,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                                Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    spacing: 8,
                                                                    children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                            decoration: ShapeDecoration(
                                                                                color: const Color(0xFFDCFCE7),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                ),
                                                                            ),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    SizedBox(
                                                                                        width: 45.69,
                                                                                        height: 16,
                                                                                        child: Text(
                                                                                            'STABLE',
                                                                                            style: TextStyle(
                                                                                                color: const Color(0xFF15803D),
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'Inter',
                                                                                                fontWeight: FontWeight.w700,
                                                                                                height: 1.33,
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: 28,
                                                                            height: 28,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                        ,
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                                Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                        width: 390,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                            color: const Color(0xCCF6F8F8),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: const Color(0xFFE5E7EB),
                                                ),
                                            ),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: ShapeDecoration(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(9999),
                                                        ),
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                ,
                                                                ],
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                        height: 22.50,
                                                        child: Stack(
                                                            children: [
                                                                Positioned(
                                                                    left: 72.27,
                                                                    top: -1,
                                                                    child: SizedBox(
                                                                        width: 133.47,
                                                                        height: 23,
                                                                        child: Text(
                                                                            'Reports History',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                color: const Color(0xFF111817),
                                                                                fontSize: 18,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w700,
                                                                                height: 1.25,
                                                                                letterSpacing: -0.27,
                                                                            ),
                                                                        ),
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
                                Positioned(
                                    left: 0,
                                    top: 828,
                                    child: Container(
                                        width: 390,
                                        height: 80,
                                        padding: const EdgeInsets.only(left: 43.38, right: 43.39),
                                        decoration: ShapeDecoration(
                                            color: Colors.white.withValues(alpha: 0.90),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: const Color(0xFFE5E7EB),
                                                ),
                                            ),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 54.80,
                                            children: [
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 4,
                                                    children: [
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                            ,
                                                            ],
                                                        ),
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                SizedBox(
                                                                    width: 28.03,
                                                                    height: 15,
                                                                    child: Text(
                                                                        'Home',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF9CA3AF),
                                                                            fontSize: 10,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w400,
                                                                            height: 1.50,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 4,
                                                    children: [
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                            ,
                                                            ],
                                                        ),
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                SizedBox(
                                                                    width: 34.48,
                                                                    height: 15,
                                                                    child: Text(
                                                                        'History',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF13ECD3),
                                                                            fontSize: 10,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.50,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 4,
                                                    children: [
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                            ,
                                                            ],
                                                        ),
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                SizedBox(
                                                                    width: 37.89,
                                                                    height: 15,
                                                                    child: Text(
                                                                        'Patients',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF9CA3AF),
                                                                            fontSize: 10,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w400,
                                                                            height: 1.50,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 4,
                                                    children: [
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                            ,
                                                            ],
                                                        ),
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                SizedBox(
                                                                    width: 38.53,
                                                                    height: 15,
                                                                    child: Text(
                                                                        'Settings',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF9CA3AF),
                                                                            fontSize: 10,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w400,
                                                                            height: 1.50,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
                SizedBox(
                    width: 15.50,
                    height: 24,
                    child: Text(
                        '```',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                        ),
                    ),
                ),
                Positioned(
                    left: 302,
                    top: 812,
                    child: Container(
                        width: 64,
                        height: 64,
                        decoration: ShapeDecoration(
                            color: const Color(0xFF13ECD3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                            ),
                        ),
                        child: Stack(
                            children: [
                                Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                        width: 64,
                                        height: 64,
                                        decoration: ShapeDecoration(
                                            color: Colors.white.withValues(alpha: 0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(9999),
                                            ),
                                            shadows: [
                                                BoxShadow(
                                                    color: Color(0x19000000),
                                                    blurRadius: 6,
                                                    offset: Offset(0, 4),
                                                    spreadRadius: -4,
                                                )BoxShadow(
                                                    color: Color(0x19000000),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 10),
                                                    spreadRadius: -3,
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                    ,
                                    ],
                                ),
                            ],
                        ),
                    ),
                ),
            ],
        ),
)