import 'package:flutter/material.dart';

class ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileOptionCard({
    super.key, 
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F7FA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0D3462), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D2F57),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF667A98),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF6C7A95), size: 28),
        ],
      ),
    );
  }
}

