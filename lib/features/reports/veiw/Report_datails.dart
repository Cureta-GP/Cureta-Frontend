import 'package:flutter/material.dart';

class ReportDetailsView extends StatelessWidget {
  const ReportDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 1687),
      child: Container(
        width: 390,
        decoration: BoxDecoration(color: const Color(0xFFF6F8F8)),
        child: Stack(
            children: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 448, minHeight: 1687),
                    child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
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
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 12,
                                    ),
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            Container(
                                                width: 48,
                                                height: 48,
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
                                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                left: 68.23,
                                                                top: -1,
                                                                child: SizedBox(
                                                                    width: 117.53,
                                                                    height: 23,
                                                                    child: Text(
                                                                        'Health Report',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF121716),
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
                                            Container(
                                                width: 48,
                                                child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        Container(
                                                            width: 48,
                                                            height: 48,
                                                            clipBehavior: Clip.antiAlias,
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
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                        ,
                                                                        ],
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 1607,
                                    child: Stack(
                                        children: [
                                            Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                    width: 390,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Container(
                                                                width: double.infinity,
                                                                padding: const EdgeInsets.all(20),
                                                                decoration: ShapeDecoration(
                                                                    color: const Color(0xFFF6F8F8),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width: 1,
                                                                            color: const Color(0xFFF3F4F6),
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(24),
                                                                    ),
                                                                ),
                                                                child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: 80,
                                                                            height: 80,
                                                                            decoration: ShapeDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage("https://placehold.co/80x80"),
                                                                                    fit: BoxFit.fill,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(9999),
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
                                                                        ),
                                                                        Expanded(
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        child: Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            spacing: 4.48,
                                                                                            children: [
                                                                                                Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                        SizedBox(
                                                                                                            width: 134.22,
                                                                                                            height: 25,
                                                                                                            child: Text(
                                                                                                                'Sarah Jenkins',
                                                                                                                style: TextStyle(
                                                                                                                    color: const Color(0xFF121716),
                                                                                                                    fontSize: 20,
                                                                                                                    fontFamily: 'Inter',
                                                                                                                    fontWeight: FontWeight.w700,
                                                                                                                    height: 1.25,
                                                                                                                    letterSpacing: -0.30,
                                                                                                                ),
                                                                                                            ),
                                                                                                        ),
                                                                                                    ],
                                                                                                ),
                                                                                                Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                                                                    decoration: ShapeDecoration(
                                                                                                        color: const Color(0x332A9D90),
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
                                                                                                                width: 49.30,
                                                                                                                height: 16,
                                                                                                                child: Text(
                                                                                                                    'STABLE',
                                                                                                                    style: TextStyle(
                                                                                                                        color: const Color(0xFF2A9D90),
                                                                                                                        fontSize: 12,
                                                                                                                        fontFamily: 'Inter',
                                                                                                                        fontWeight: FontWeight.w700,
                                                                                                                        height: 1.33,
                                                                                                                        letterSpacing: 0.60,
                                                                                                                    ),
                                                                                                                ),
                                                                                                            ),
                                                                                                        ],
                                                                                                    ),
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                    ),
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        padding: const EdgeInsets.only(top: 4),
                                                                                        child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                                Container(
                                                                                                    width: double.infinity,
                                                                                                    child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                            SizedBox(
                                                                                                                width: 212,
                                                                                                                child: Text(
                                                                                                                    'ID: #839210',
                                                                                                                    style: TextStyle(
                                                                                                                        color: const Color(0xFF678380),
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
                                                                                    ),
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                                SizedBox(
                                                                                                    width: 212,
                                                                                                    child: Text(
                                                                                                        'Age: 42 • Blood Type: O+',
                                                                                                        style: TextStyle(
                                                                                                            color: const Color(0xFF678380),
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
                                                top: 154,
                                                child: Container(
                                                    width: 390,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        spacing: 20,
                                                        children: [
                                                            Expanded(
                                                                child: ConstrainedBox(
                                                                    constraints: BoxConstraints(minWidth: 158),
                                                                    child: Container(
                                                                        height: double.infinity,
                                                                        padding: const EdgeInsets.all(20),
                                                                        decoration: ShapeDecoration(
                                                                            color: const Color(0xFFF1F4F3),
                                                                            shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                    width: 1,
                                                                                    color: Colors.black.withValues(alpha: 0),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(24),
                                                                            ),
                                                                        ),
                                                                        child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            spacing: 8,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        spacing: 8,
                                                                                        children: [
                                                                                            Container(
                                                                                                padding: const EdgeInsets.all(6),
                                                                                                decoration: ShapeDecoration(
                                                                                                    color: Colors.white,
                                                                                                    shape: RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                                    ),
                                                                                                ),
                                                                                                child: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                    ,
                                                                                                    ],
                                                                                                ),
                                                                                            ),
                                                                                            Container(
                                                                                                padding: const EdgeInsets.only(right: 40.80),
                                                                                                child: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                        SizedBox(
                                                                                                            width: 42.20,
                                                                                                            height: 42,
                                                                                                            child: Text(
                                                                                                                'Active\nMeds',
                                                                                                                style: TextStyle(
                                                                                                                    color: const Color(0xFF678380),
                                                                                                                    fontSize: 14,
                                                                                                                    fontFamily: 'Inter',
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    height: 1.50,
                                                                                                                ),
                                                                                                            ),
                                                                                                        ),
                                                                                                    ],
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    padding: const EdgeInsets.only(left: 4),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 119,
                                                                                                child: Text(
                                                                                                    '4',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 24,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        height: 1.25,
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
                                                            ),
                                                            Expanded(
                                                                child: ConstrainedBox(
                                                                    constraints: BoxConstraints(minWidth: 158),
                                                                    child: Container(
                                                                        height: double.infinity,
                                                                        padding: const EdgeInsets.all(20),
                                                                        decoration: ShapeDecoration(
                                                                            color: const Color(0xFFF1F4F3),
                                                                            shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                    width: 1,
                                                                                    color: Colors.black.withValues(alpha: 0),
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(24),
                                                                            ),
                                                                        ),
                                                                        child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            spacing: 8,
                                                                            children: [
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        spacing: 8,
                                                                                        children: [
                                                                                            Container(
                                                                                                padding: const EdgeInsets.all(6),
                                                                                                decoration: ShapeDecoration(
                                                                                                    color: Colors.white,
                                                                                                    shape: RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius.circular(16),
                                                                                                    ),
                                                                                                ),
                                                                                                child: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                    ,
                                                                                                    ],
                                                                                                ),
                                                                                            ),
                                                                                            Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                    SizedBox(
                                                                                                        width: 77.23,
                                                                                                        height: 21,
                                                                                                        child: Text(
                                                                                                            'Lab Results',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF678380),
                                                                                                                fontSize: 14,
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
                                                                                ),
                                                                                Container(
                                                                                    width: double.infinity,
                                                                                    padding: const EdgeInsets.only(left: 4),
                                                                                    child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 119,
                                                                                                child: Text(
                                                                                                    'Normal',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 24,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        height: 1.25,
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
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            Positioned(
                                                left: 0,
                                                top: 729.50,
                                                child: Container(
                                                    width: 390,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        spacing: 16,
                                                        children: [
                                                            Container(
                                                                width: double.infinity,
                                                                child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        SizedBox(
                                                                            width: 350,
                                                                            child: Text(
                                                                                'Top Conditions',
                                                                                style: TextStyle(
                                                                                    color: const Color(0xFF121716),
                                                                                    fontSize: 18,
                                                                                    fontFamily: 'Inter',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    height: 1.25,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                            Container(
                                                                width: double.infinity,
                                                                child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: double.infinity,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                spacing: 12,
                                                                                children: [
                                                                                    Expanded(
                                                                                        child: Container(
                                                                                            height: 16,
                                                                                            decoration: ShapeDecoration(
                                                                                                color: const Color(0xFFFF8A80),
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                                ),
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 112.53,
                                                                                                height: 20,
                                                                                                child: Text(
                                                                                                    'Hypertension 4x',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.43,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: double.infinity,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                spacing: 12,
                                                                                children: [
                                                                                    Container(
                                                                                        width: 157.50,
                                                                                        height: 16,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFFF8A80),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(9999),
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 96.53,
                                                                                                height: 20,
                                                                                                child: Text(
                                                                                                    'Arrhythmia 2x',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.43,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: double.infinity,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                spacing: 12,
                                                                                children: [
                                                                                    Container(
                                                                                        width: 87.50,
                                                                                        height: 16,
                                                                                        decoration: ShapeDecoration(
                                                                                            color: const Color(0xFFFF8A80),
                                                                                            shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(9999),
                                                                                            ),
                                                                                        ),
                                                                                    ),
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 67.64,
                                                                                                height: 20,
                                                                                                child: Text(
                                                                                                    'Fatigue 1x',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 14,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        height: 1.43,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ],
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
                                                top: 892,
                                                child: Container(
                                                    width: 390,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        spacing: 24,
                                                        children: [
                                                            Container(
                                                                width: double.infinity,
                                                                child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        SizedBox(
                                                                            width: 350,
                                                                            child: Text(
                                                                                'Medication Timeline',
                                                                                style: TextStyle(
                                                                                    color: const Color(0xFF121716),
                                                                                    fontSize: 18,
                                                                                    fontFamily: 'Inter',
                                                                                    fontWeight: FontWeight.w700,
                                                                                    height: 1.25,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                            Container(
                                                                width: double.infinity,
                                                                child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    spacing: 32,
                                                                    children: [
                                                                        Container(
                                                                            width: double.infinity,
                                                                            padding: const EdgeInsets.only(left: 12),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        padding: const EdgeInsets.only(left: 24),
                                                                                        decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                                side: BorderSide(
                                                                                                    width: 2,
                                                                                                    color: const Color(0xFFE5E7EB),
                                                                                                ),
                                                                                            ),
                                                                                        ),
                                                                                        child: Stack(
                                                                                            children: [
                                                                                                Container(
                                                                                                    width: double.infinity,
                                                                                                    child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        spacing: 16,
                                                                                                        children: [
                                                                                                            Container(
                                                                                                                width: double.infinity,
                                                                                                                child: Row(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    spacing: 108.64,
                                                                                                                    children: [
                                                                                                                        Column(
                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                            spacing: 2,
                                                                                                                            children: [
                                                                                                                                Container(
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: Column(
                                                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                            SizedBox(
                                                                                                                                                width: 86.27,
                                                                                                                                                height: 24,
                                                                                                                                                child: Text(
                                                                                                                                                    'Augmentin',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        color: const Color(0xFF121716),
                                                                                                                                                        fontSize: 16,
                                                                                                                                                        fontFamily: 'Inter',
                                                                                                                                                        fontWeight: FontWeight.w700,
                                                                                                                                                        height: 1.50,
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ],
                                                                                                                                    ),
                                                                                                                                ),
                                                                                                                                Container(
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: Column(
                                                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                            SizedBox(
                                                                                                                                                width: 119.63,
                                                                                                                                                height: 16,
                                                                                                                                                child: Text(
                                                                                                                                                    '875 mg • Twice daily',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        color: const Color(0xFF678380),
                                                                                                                                                        fontSize: 12,
                                                                                                                                                        fontFamily: 'Inter',
                                                                                                                                                        fontWeight: FontWeight.w400,
                                                                                                                                                        height: 1.33,
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ],
                                                                                                                                    ),
                                                                                                                                ),
                                                                                                                            ],
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                color: const Color(0x192A9D90),
                                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                                    side: BorderSide(
                                                                                                                                        width: 1,
                                                                                                                                        color: const Color(0x192A9D90),
                                                                                                                                    ),
                                                                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                                                                ),
                                                                                                                            ),
                                                                                                                            child: Column(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                children: [
                                                                                                                                    SizedBox(
                                                                                                                                        width: 57.73,
                                                                                                                                        height: 16,
                                                                                                                                        child: Text(
                                                                                                                                            'Day 5 of 7',
                                                                                                                                            style: TextStyle(
                                                                                                                                                color: const Color(0xFF2A9D90),
                                                                                                                                                fontSize: 12,
                                                                                                                                                fontFamily: 'Inter',
                                                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                                                height: 1.33,
                                                                                                                                            ),
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    ],
                                                                                                                ),
                                                                                                            ),
                                                                                                            Container(
                                                                                                                width: double.infinity,
                                                                                                                child: Column(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    spacing: 8,
                                                                                                                    children: [
                                                                                                                        Container(
                                                                                                                            width: double.infinity,
                                                                                                                            child: Row(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                spacing: 243.30,
                                                                                                                                children: [
                                                                                                                                    Container(
                                                                                                                                        height: double.infinity,
                                                                                                                                        child: Column(
                                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                                SizedBox(
                                                                                                                                                    width: 46.92,
                                                                                                                                                    height: 17,
                                                                                                                                                    child: Text(
                                                                                                                                                        'Progress',
                                                                                                                                                        style: TextStyle(
                                                                                                                                                            color: const Color(0xFF678380),
                                                                                                                                                            fontSize: 11,
                                                                                                                                                            fontFamily: 'Inter',
                                                                                                                                                            fontWeight: FontWeight.w500,
                                                                                                                                                            height: 1.50,
                                                                                                                                                        ),
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ],
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                        height: double.infinity,
                                                                                                                                        child: Column(
                                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                                SizedBox(
                                                                                                                                                    width: 21.78,
                                                                                                                                                    height: 17,
                                                                                                                                                    child: Text(
                                                                                                                                                        '71%',
                                                                                                                                                        style: TextStyle(
                                                                                                                                                            color: const Color(0xFF678380),
                                                                                                                                                            fontSize: 11,
                                                                                                                                                            fontFamily: 'Inter',
                                                                                                                                                            fontWeight: FontWeight.w500,
                                                                                                                                                            height: 1.50,
                                                                                                                                                        ),
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ],
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                            width: double.infinity,
                                                                                                                            height: 10,
                                                                                                                            clipBehavior: Clip.antiAlias,
                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                color: const Color(0xFFF3F4F6),
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
                                                                                                                                            width: 221.52,
                                                                                                                                            height: 10,
                                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                                color: const Color(0xFF2A9D90),
                                                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    ],
                                                                                                                ),
                                                                                                            ),
                                                                                                        ],
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: -11,
                                                                                                    top: -4,
                                                                                                    child: Container(
                                                                                                        width: 24,
                                                                                                        height: 24,
                                                                                                        decoration: ShapeDecoration(
                                                                                                            color: const Color(0xFF2A9D90),
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                side: BorderSide(width: 4, color: Colors.white),
                                                                                                                borderRadius: BorderRadius.circular(9999),
                                                                                                            ),
                                                                                                        ),
                                                                                                        child: Column(
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                                Container(
                                                                                                                    width: 16,
                                                                                                                    height: 16,
                                                                                                                    decoration: ShapeDecoration(
                                                                                                                        color: Colors.white.withValues(alpha: 0),
                                                                                                                        shape: RoundedRectangleBorder(
                                                                                                                            borderRadius: BorderRadius.circular(9999),
                                                                                                                        ),
                                                                                                                        shadows: [
                                                                                                                            BoxShadow(
                                                                                                                                color: Color(0xFF2A9D90),
                                                                                                                                blurRadius: 0,
                                                                                                                                offset: Offset(0, 0),
                                                                                                                                spreadRadius: 1,
                                                                                                                            )
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
                                                                        Container(
                                                                            width: double.infinity,
                                                                            padding: const EdgeInsets.only(left: 12),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        padding: const EdgeInsets.only(left: 24),
                                                                                        decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                                side: BorderSide(
                                                                                                    width: 2,
                                                                                                    color: const Color(0xFFE5E7EB),
                                                                                                ),
                                                                                            ),
                                                                                        ),
                                                                                        child: Stack(
                                                                                            children: [
                                                                                                Container(
                                                                                                    width: double.infinity,
                                                                                                    child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        spacing: 16,
                                                                                                        children: [
                                                                                                            Container(
                                                                                                                width: double.infinity,
                                                                                                                child: Row(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    spacing: 116.88,
                                                                                                                    children: [
                                                                                                                        Column(
                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                            spacing: 2,
                                                                                                                            children: [
                                                                                                                                Container(
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: Column(
                                                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                            SizedBox(
                                                                                                                                                width: 81.16,
                                                                                                                                                height: 24,
                                                                                                                                                child: Text(
                                                                                                                                                    'Metformin',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        color: const Color(0xFF121716),
                                                                                                                                                        fontSize: 16,
                                                                                                                                                        fontFamily: 'Inter',
                                                                                                                                                        fontWeight: FontWeight.w700,
                                                                                                                                                        height: 1.50,
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ],
                                                                                                                                    ),
                                                                                                                                ),
                                                                                                                                Container(
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: Column(
                                                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                        children: [
                                                                                                                                            SizedBox(
                                                                                                                                                width: 119.75,
                                                                                                                                                height: 16,
                                                                                                                                                child: Text(
                                                                                                                                                    '500 mg • With meals',
                                                                                                                                                    style: TextStyle(
                                                                                                                                                        color: const Color(0xFF678380),
                                                                                                                                                        fontSize: 12,
                                                                                                                                                        fontFamily: 'Inter',
                                                                                                                                                        fontWeight: FontWeight.w400,
                                                                                                                                                        height: 1.33,
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ],
                                                                                                                                    ),
                                                                                                                                ),
                                                                                                                            ],
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                color: const Color(0xFFEEF2FF),
                                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                                    side: BorderSide(
                                                                                                                                        width: 1,
                                                                                                                                        color: const Color(0xFFE0E7FF),
                                                                                                                                    ),
                                                                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                                                                ),
                                                                                                                            ),
                                                                                                                            child: Column(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                children: [
                                                                                                                                    SizedBox(
                                                                                                                                        width: 49.38,
                                                                                                                                        height: 16,
                                                                                                                                        child: Text(
                                                                                                                                            'Ongoing',
                                                                                                                                            style: TextStyle(
                                                                                                                                                color: const Color(0xFF6366F1),
                                                                                                                                                fontSize: 12,
                                                                                                                                                fontFamily: 'Inter',
                                                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                                                height: 1.33,
                                                                                                                                            ),
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    ],
                                                                                                                ),
                                                                                                            ),
                                                                                                            Container(
                                                                                                                width: double.infinity,
                                                                                                                child: Column(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    spacing: 8,
                                                                                                                    children: [
                                                                                                                        Container(
                                                                                                                            width: double.infinity,
                                                                                                                            child: Row(
                                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                spacing: 229.69,
                                                                                                                                children: [
                                                                                                                                    Container(
                                                                                                                                        height: double.infinity,
                                                                                                                                        child: Column(
                                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                                SizedBox(
                                                                                                                                                    width: 57.53,
                                                                                                                                                    height: 17,
                                                                                                                                                    child: Text(
                                                                                                                                                        'Adherence',
                                                                                                                                                        style: TextStyle(
                                                                                                                                                            color: const Color(0xFF678380),
                                                                                                                                                            fontSize: 11,
                                                                                                                                                            fontFamily: 'Inter',
                                                                                                                                                            fontWeight: FontWeight.w500,
                                                                                                                                                            height: 1.50,
                                                                                                                                                        ),
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ],
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                        height: double.infinity,
                                                                                                                                        child: Column(
                                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                            children: [
                                                                                                                                                SizedBox(
                                                                                                                                                    width: 24.78,
                                                                                                                                                    height: 17,
                                                                                                                                                    child: Text(
                                                                                                                                                        '98%',
                                                                                                                                                        style: TextStyle(
                                                                                                                                                            color: const Color(0xFF678380),
                                                                                                                                                            fontSize: 11,
                                                                                                                                                            fontFamily: 'Inter',
                                                                                                                                                            fontWeight: FontWeight.w500,
                                                                                                                                                            height: 1.50,
                                                                                                                                                        ),
                                                                                                                                                    ),
                                                                                                                                                ),
                                                                                                                                            ],
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                            width: double.infinity,
                                                                                                                            height: 10,
                                                                                                                            clipBehavior: Clip.antiAlias,
                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                color: const Color(0xFFF3F4F6),
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
                                                                                                                                            width: 305.75,
                                                                                                                                            height: 10,
                                                                                                                                            decoration: ShapeDecoration(
                                                                                                                                                color: const Color(0xFF2A9D90),
                                                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                                                    borderRadius: BorderRadius.circular(9999),
                                                                                                                                                ),
                                                                                                                                            ),
                                                                                                                                        ),
                                                                                                                                    ),
                                                                                                                                ],
                                                                                                                            ),
                                                                                                                        ),
                                                                                                                    ],
                                                                                                                ),
                                                                                                            ),
                                                                                                        ],
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: -11,
                                                                                                    top: -4,
                                                                                                    child: Container(
                                                                                                        width: 24,
                                                                                                        height: 24,
                                                                                                        decoration: ShapeDecoration(
                                                                                                            color: const Color(0xFF6366F1),
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                                side: BorderSide(width: 4, color: Colors.white),
                                                                                                                borderRadius: BorderRadius.circular(9999),
                                                                                                            ),
                                                                                                        ),
                                                                                                        child: Column(
                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                                Container(
                                                                                                                    width: 16,
                                                                                                                    height: 16,
                                                                                                                    decoration: ShapeDecoration(
                                                                                                                        color: Colors.white.withValues(alpha: 0),
                                                                                                                        shape: RoundedRectangleBorder(
                                                                                                                            borderRadius: BorderRadius.circular(9999),
                                                                                                                        ),
                                                                                                                        shadows: [
                                                                                                                            BoxShadow(
                                                                                                                                color: Color(0xFF6366F1),
                                                                                                                                blurRadius: 0,
                                                                                                                                offset: Offset(0, 0),
                                                                                                                                spreadRadius: 1,
                                                                                                                            )
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
                                                                    ],
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                            Positioned(
                                                left: 0,
                                                top: 1186.98,
                                                child: Container(
                                                    width: 390,
                                                    padding: const EdgeInsets.only(
                                                        left: 18.87,
                                                        right: 18.88,
                                                        bottom: 126.48,
                                                    ),
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Container(
                                                                transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(0.01),
                                                                width: 350,
                                                                padding: const EdgeInsets.all(24),
                                                                decoration: ShapeDecoration(
                                                                    color: const Color(0xFFFFF8E1),
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width: 1,
                                                                            color: const Color(0xFFFEF9C3),
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(24),
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
                                                                    spacing: 16,
                                                                    children: [
                                                                        Container(
                                                                            width: double.infinity,
                                                                            child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                spacing: 8,
                                                                                children: [
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 20.04,
                                                                                                height: 32.17,
                                                                                                child: Text(
                                                                                                    '✨',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 24,
                                                                                                        fontFamily: 'FreeSans',
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        height: 1.33,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                    Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            SizedBox(
                                                                                                width: 107.73,
                                                                                                height: 28.94,
                                                                                                child: Text(
                                                                                                    'AI Summary',
                                                                                                    style: TextStyle(
                                                                                                        color: const Color(0xFF121716),
                                                                                                        fontSize: 18,
                                                                                                        fontFamily: 'Inter',
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        height: 1.56,
                                                                                                    ),
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        Container(
                                                                            width: double.infinity,
                                                                            padding: const EdgeInsets.only(left: 20),
                                                                            child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                spacing: 12,
                                                                                children: [
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        height: 47.94,
                                                                                        child: Stack(
                                                                                            children: [
                                                                                                Positioned(
                                                                                                    left: 0.17,
                                                                                                    top: 2.61,
                                                                                                    child: SizedBox(
                                                                                                        width: 10.20,
                                                                                                        height: 23.09,
                                                                                                        child: Text(
                                                                                                            ' ',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4.20,
                                                                                                    top: -0.97,
                                                                                                    child: SizedBox(
                                                                                                        width: 273.18,
                                                                                                        height: 25.38,
                                                                                                        child: Text.rich(
                                                                                                            TextSpan(
                                                                                                                children: [
                                                                                                                    TextSpan(
                                                                                                                        text: 'Stable condition',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w700,
                                                                                                                            height: 1.63,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                    TextSpan(
                                                                                                                        text: ' maintained over the last',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w400,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                ],
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4,
                                                                                                    top: 21.78,
                                                                                                    child: SizedBox(
                                                                                                        width: 189.94,
                                                                                                        height: 24.65,
                                                                                                        child: Text(
                                                                                                            '7 days with consistent vitals.',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                                height: 1.63,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                    ),
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        height: 47.93,
                                                                                        child: Stack(
                                                                                            children: [
                                                                                                Positioned(
                                                                                                    left: 0.17,
                                                                                                    top: 2.61,
                                                                                                    child: SizedBox(
                                                                                                        width: 10.20,
                                                                                                        height: 23.09,
                                                                                                        child: Text(
                                                                                                            ' ',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4.21,
                                                                                                    top: -0.97,
                                                                                                    child: SizedBox(
                                                                                                        width: 249.84,
                                                                                                        height: 25.18,
                                                                                                        child: Text.rich(
                                                                                                            TextSpan(
                                                                                                                children: [
                                                                                                                    TextSpan(
                                                                                                                        text: 'Spike in blood pressure',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w700,
                                                                                                                            height: 1.63,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                    TextSpan(
                                                                                                                        text: ' detected this',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w400,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                ],
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4.01,
                                                                                                    top: 21.78,
                                                                                                    child: SizedBox(
                                                                                                        width: 167.47,
                                                                                                        height: 24.46,
                                                                                                        child: Text(
                                                                                                            'morning; monitor closely.',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                                height: 1.63,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                    ),
                                                                                    Container(
                                                                                        width: double.infinity,
                                                                                        height: 47.94,
                                                                                        child: Stack(
                                                                                            children: [
                                                                                                Positioned(
                                                                                                    left: 0.17,
                                                                                                    top: 2.61,
                                                                                                    child: SizedBox(
                                                                                                        width: 10.20,
                                                                                                        height: 23.09,
                                                                                                        child: Text(
                                                                                                            ' ',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4.20,
                                                                                                    top: -0.96,
                                                                                                    child: SizedBox(
                                                                                                        width: 225.70,
                                                                                                        height: 24.97,
                                                                                                        child: Text.rich(
                                                                                                            TextSpan(
                                                                                                                children: [
                                                                                                                    TextSpan(
                                                                                                                        text: 'Continue medication',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w700,
                                                                                                                            height: 1.63,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                    TextSpan(
                                                                                                                        text: ' schedule as',
                                                                                                                        style: TextStyle(
                                                                                                                            color: const Color(0xFF121716),
                                                                                                                            fontSize: 14,
                                                                                                                            fontFamily: 'Inter',
                                                                                                                            fontWeight: FontWeight.w400,
                                                                                                                        ),
                                                                                                                    ),
                                                                                                                ],
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 4.01,
                                                                                                    top: 21.79,
                                                                                                    child: SizedBox(
                                                                                                        width: 198.49,
                                                                                                        height: 24.73,
                                                                                                        child: Text(
                                                                                                            'prescribed for optimal results.',
                                                                                                            style: TextStyle(
                                                                                                                color: const Color(0xFF121716),
                                                                                                                fontSize: 14,
                                                                                                                fontFamily: 'Inter',
                                                                                                                fontWeight: FontWeight.w400,
                                                                                                                height: 1.63,
                                                                                                            ),
                                                                                                        ),
                                                                                                    ),
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                    ),
                                                                                ],
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
                    left: 199.24,
                    top: 1607,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 24,
                                    right: 32,
                                    bottom: 16,
                                ),
                                decoration: ShapeDecoration(
                                    color: const Color(0xFF121716),
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
                                                width: 167.09,
                                                height: 56,
                                                decoration: ShapeDecoration(
                                                    color: Colors.white.withValues(alpha: 0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(9999),
                                                    ),
                                                    shadows: [
                                                        BoxShadow(
                                                            color: Color(0x662A9D90),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 8),
                                                            spreadRadius: -6,
                                                        )BoxShadow(
                                                            color: Color(0x662A9D90),
                                                            blurRadius: 25,
                                                            offset: Offset(0, 10),
                                                            spreadRadius: -5,
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
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                SizedBox(
                                                    width: 84.09,
                                                    height: 24,
                                                    child: Text(
                                                        'Share PDF',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w700,
                                                            height: 1.50,
                                                            letterSpacing: 0.40,
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        ),
    ),
)