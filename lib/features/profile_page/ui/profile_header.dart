import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int loyaltyPoints;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.loyaltyPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF002B62), Color(0xFF003E7A)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 38),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF17BA8B),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF43D4A8), width: 4),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42 / 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFC3D4EC),
                  fontSize: 28 / 2,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A548B),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: const Color(0xFF5F7FA5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.military_tech_outlined,
                      color: Color(0xFF00D9A0),
                      size: 23,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Puntos de fidelidad',
                          style: TextStyle(
                            color: Color(0xFFB5C6DD),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$loyaltyPoints pts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

