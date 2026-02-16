import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:credito_solitario_mobile/features/login_page/ui/login_page.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:flutter/material.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  final ProfileService _profileService = ProfileService();
  final AuthStorageService _authStorageService = AuthStorageService();
  late Future<Map<String, dynamic>> _profileFuture;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.getMyProfile();
  }

  Future<void> _logout() async {
    await _authStorageService.clearToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductsPageView()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () {
                  setState(() {
                    _profileFuture = _profileService.getMyProfile();
                  });
                },
              );
            }

            final user = snapshot.data ?? {};
            final userName = _resolveUserName(user);
            final userEmail = _resolveUserEmail(user);
            final loyaltyPoints = _resolveLoyaltyPoints(user);

            return SingleChildScrollView(
              child: Column(
                children: [
                  _ProfileHeader(
                    userName: userName,
                    userEmail: userEmail,
                    loyaltyPoints: loyaltyPoints,
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: const [
                        _ProfileOptionCard(
                          icon: Icons.shield_outlined,
                          title: 'Seguridad',
                          subtitle: 'Contraseña y autenticación',
                        ),
                        SizedBox(height: 14),
                        _ProfileOptionCard(
                          icon: Icons.credit_card_outlined,
                          title: 'Historial de pagos',
                          subtitle: 'Ver transacciones anteriores',
                        ),
                        SizedBox(height: 14),
                        _ProfileOptionCard(
                          icon: Icons.storage_outlined,
                          title: 'Datos personales',
                          subtitle: 'Gestionar información de cuenta',
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(
                          Icons.logout,
                          color: Color(0xFFFF3B30),
                        ),
                        label: const Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Color(0xFFFF3B30),
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Crédito Solidario v1.0.0',
                    style: TextStyle(color: Color(0xFF8C9BB5), fontSize: 16),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF00B67A),
          unselectedItemColor: const Color(0xFF6C7A95),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: const [
                  Icon(Icons.shopping_cart_outlined),
                  Positioned(
                    right: -8,
                    top: -7,
                    child: _BadgeCounter(value: '3'),
                  ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: const [
                  Icon(Icons.shopping_cart),
                  Positioned(
                    right: -8,
                    top: -7,
                    child: _BadgeCounter(value: '3'),
                  ),
                ],
              ),
              label: 'Carrito',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Pedidos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  String _resolveUserName(Map<String, dynamic> user) {
    final rawName = user['name'] ?? user['nombre'];
    if (rawName == null || rawName.toString().trim().isEmpty) {
      return 'Usuario';
    }
    return rawName.toString();
  }

  String _resolveUserEmail(Map<String, dynamic> user) {
    final rawEmail = user['email'] ?? user['correo'];
    if (rawEmail == null || rawEmail.toString().trim().isEmpty) {
      return 'sin-correo@correo.com';
    }
    return rawEmail.toString();
  }

  int _resolveLoyaltyPoints(Map<String, dynamic> user) {
    final value =
        user['loyalty_points'] ?? user['puntos_fidelidad'] ?? user['points'];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 345;
    if (value is double) return value.toInt();
    return 345;
  }
}

class _ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int loyaltyPoints;

  const _ProfileHeader({
    required this.userName,
    required this.userEmail,
    required this.loyaltyPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileOptionCard({
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

class _BadgeCounter extends StatelessWidget {
  final String value;

  const _BadgeCounter({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF0BC081),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Color(0xFFD9534F)),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar el perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667A98)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
