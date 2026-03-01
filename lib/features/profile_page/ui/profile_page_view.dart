import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:credito_solitario_mobile/core/services/shopping_cart_service.dart';
import 'package:credito_solitario_mobile/features/login_page/ui/login_page.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_header.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_option_card.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/ui/shopping_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ShoppingCartBloc(ShoppingCartService()),
            child: const ShoppingCartView(),
          ),
        ),
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
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00BFA5),
              ),
            );
          }

          

          final user = snapshot.data ?? {};
          final userName = _resolveUserName(user);
          final userEmail = _resolveUserEmail(user);
          final loyaltyPoints = _resolveLoyaltyPoints(user);

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  userName: userName,
                  userEmail: userEmail,
                  loyaltyPoints: loyaltyPoints,
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: const [
                      ProfileOptionCard(
                        icon: Icons.shield_outlined,
                        title: 'Seguridad',
                        subtitle: 'Contraseña y autenticación',
                      ),
                      SizedBox(height: 14),
                      ProfileOptionCard(
                        icon: Icons.credit_card_outlined,
                        title: 'Historial de pagos',
                        subtitle: 'Ver transacciones anteriores',
                      ),
                      SizedBox(height: 14),
                      ProfileOptionCard(
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
          selectedItemColor: const Color(0xFF00BFA5),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
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
