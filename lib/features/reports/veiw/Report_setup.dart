import 'package:flutter/material.dart';
Container(
    width: double.infinity,
    padding: const EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: 24,
    ),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 182.31,
                    children: [
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                SizedBox(
                                    width: 127.67,
                                    height: 25,
                                    child: Text(
                                        'Report Setup',
                                        style: TextStyle(
                                            color: const Color(0xFF111817),
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            height: 1.25,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                                color: const Color(0xFFF3F4F6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                ),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
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
            ),
            Container(
                width: double.infinity,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(
                                        width: 350,
                                        child: Text(
                                            'Select Family Member',
                                            style: TextStyle(
                                                color: const Color(0xFF111817),
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                letterSpacing: -0.24,
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 80,
                            child: Stack(
                                children: [
                                    Positioned(
                                        left: 50,
                                        top: 12,
                                        child: Container(
                                            width: 62,
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                side: BorderSide(
                                                                    width: 2,
                                                                    color: Colors.black.withValues(alpha: 0),
                                                                ),
                                                                borderRadius: BorderRadius.circular(9999),
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        left: 112,
                                        top: 12,
                                        child: Container(
                                            width: 62,
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                side: BorderSide(
                                                                    width: 2,
                                                                    color: Colors.black.withValues(alpha: 0),
                                                                ),
                                                                borderRadius: BorderRadius.circular(9999),
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        left: 174,
                                        top: 12,
                                        child: Container(
                                            width: 62,
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Container(
                                                        width: 56,
                                                        height: 56,
                                                        decoration: ShapeDecoration(
                                                            color: const Color(0xFFF3F4F6),
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 2,
                                                                    color: Colors.black.withValues(alpha: 0),
                                                                ),
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
                                                ],
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        left: 4,
                                        top: 12,
                                        child: Container(
                                            width: 46,
                                            child: Stack(
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
                                                                side: BorderSide(
                                                                    width: 4,
                                                                    color: const Color(0xFF13ECD3),
                                                                ),
                                                                borderRadius: BorderRadius.circular(9999),
                                                            ),
                                                        ),
                                                    ),
                                                    Positioned(
                                                        left: 30,
                                                        top: 40,
                                                        child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: ShapeDecoration(
                                                                color: const Color(0xFF13ECD3),
                                                                shape: RoundedRectangleBorder(
                                                                    side: BorderSide(width: 2, color: Colors.white),
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
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(
                                        width: 350,
                                        child: Text(
                                            'Time Period',
                                            style: TextStyle(
                                                color: const Color(0xFF111817),
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                letterSpacing: -0.24,
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 88,
                            child: Stack(
                                children: [
                                    Positioned(
                                        left: 4,
                                        top: 0,
                                        child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: ShapeDecoration(
                                                color: const Color(0x3313ECD3),
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: const Color(0x6613ECD3),
                                                    ),
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
                                                            SizedBox(
                                                                width: 77.56,
                                                                height: 21,
                                                                child: Text(
                                                                    'Last 7 Days',
                                                                    style: TextStyle(
                                                                        color: const Color(0xFF111817),
                                                                        fontSize: 14,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w600,
                                                                        height: 1.50,
                                                                    ),
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        left: 131.56,
                                        top: 0,
                                        child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: ShapeDecoration(
                                                color: const Color(0xFFF3F4F6),
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
                                                            SizedBox(
                                                                width: 74.77,
                                                                height: 21,
                                                                child: Text(
                                                                    'Last Month',
                                                                    style: TextStyle(
                                                                        color: const Color(0xFF111817),
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
                                    ),
                                    Positioned(
                                        left: 4,
                                        top: 48,
                                        child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: ShapeDecoration(
                                                color: const Color(0xFFF3F4F6),
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
                                                            SizedBox(
                                                                width: 94.81,
                                                                height: 21,
                                                                child: Text(
                                                                    'Last 3 Months',
                                                                    style: TextStyle(
                                                                        color: const Color(0xFF111817),
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
                                    ),
                                    Positioned(
                                        left: 146.81,
                                        top: 48,
                                        child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: ShapeDecoration(
                                                color: const Color(0xFFF3F4F6),
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
                                                            SizedBox(
                                                                width: 54.05,
                                                                height: 21,
                                                                child: Text(
                                                                    'All Time',
                                                                    style: TextStyle(
                                                                        color: const Color(0xFF111817),
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
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(
                                        width: 350,
                                        child: Text(
                                            'Included Metrics',
                                            style: TextStyle(
                                                color: const Color(0xFF111817),
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                letterSpacing: -0.24,
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
                                spacing: 12,
                                children: [
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: const Color(0xFFF3F4F6),
                                                ),
                                                borderRadius: BorderRadius.circular(48),
                                            ),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 154,
                                            children: [
                                                Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 12,
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
                                                                    width: 85.98,
                                                                    height: 20,
                                                                    child: Text(
                                                                        'Vitals & Labs',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF374151),
                                                                            fontSize: 14,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.43,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                                Container(
                                                    width: 40,
                                                    height: 24,
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    decoration: ShapeDecoration(
                                                        color: const Color(0xFF13ECD3),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(9999),
                                                        ),
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Container(
                                                                width: 16,
                                                                height: 16,
                                                                decoration: ShapeDecoration(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(9999),
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
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: const Color(0xFFF3F4F6),
                                                ),
                                                borderRadius: BorderRadius.circular(48),
                                            ),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 98.48,
                                            children: [
                                                Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    spacing: 12,
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
                                                                    width: 141.50,
                                                                    height: 20,
                                                                    child: Text(
                                                                        'AI Symptom Analysis',
                                                                        style: TextStyle(
                                                                            color: const Color(0xFF374151),
                                                                            fontSize: 14,
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            height: 1.43,
                                                                        ),
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                                Container(
                                                    width: 40,
                                                    height: 24,
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    decoration: ShapeDecoration(
                                                        color: const Color(0xFF13ECD3),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(9999),
                                                        ),
                                                    ),
                                                    child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Container(
                                                                width: 16,
                                                                height: 16,
                                                                decoration: ShapeDecoration(
                                                                    color: Colors.white,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(9999),
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
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: ShapeDecoration(
                                color: const Color(0xFF13ECD3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48),
                                ),
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8.01,
                                children: [
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            SizedBox(
                                                width: 13.17,
                                                height: 24,
                                                child: Text(
                                                    '✨',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color(0xFF111817),
                                                        fontSize: 16,
                                                        fontFamily: 'FreeSans',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.50,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            SizedBox(
                                                width: 118.86,
                                                height: 24,
                                                child: Text(
                                                    'Analyze Health',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: const Color(0xFF111817),
                                                        fontSize: 16,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    SizedBox(
                                        width: 298.36,
                                        height: 32,
                                        child: Text(
                                            'Powered by Medical AI. This report provides insights\nbut is not a clinical diagnosis.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(0xFF6B7280),
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
            ),
        ],
    ),
)