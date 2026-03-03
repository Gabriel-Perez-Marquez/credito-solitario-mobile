import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:credito_solitario_mobile/core/services/orders_service.dart';
import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:credito_solitario_mobile/features/login_page/ui/login_page.dart';
import 'package:credito_solitario_mobile/features/orders_page/bloc/orders_page_bloc.dart';
import 'package:credito_solitario_mobile/features/orders_page/ui/orders_page_view.dart';
import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/help_center_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/history_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/personal_data_page_view.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_header.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/profile_option_card.dart';
import 'package:credito_solitario_mobile/features/profile_page/ui/security_page_view.dart';
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
        MaterialPageRoute(builder: (_) => const ShoppingCartView()),
      );
      return;
    }

    if(index == 2){
      Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OrdersPageBloc(OrdersService()),
            child: const OrdersPageView(),
          )
        )
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
            );
          }

          final user = snapshot.data ?? {};
          final userName = _resolveUserName(user);
          final loyaltyPoints = _resolveLoyaltyPoints(user);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(userName: userName, loyaltyPoints: loyaltyPoints),

                // SECCIÓN CUENTA
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    'CUENTA',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                // SECCIÓN CUENTA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ProfileOptionCard(
                        icon: Icons.lock_outline,
                        title: 'Seguridad',
                        subtitle: 'Contraseña, 2FA',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecurityPageView(),
                            ),
                          );
                        },
                      ),
                      ProfileOptionCard(
                        icon: Icons.history,
                        title: 'Historial',
                        subtitle: 'Transacciones recientes',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPageView(),
                            ),
                          );
                        },
                      ),
                      ProfileOptionCard(
                        icon: Icons.badge_outlined,
                        title: 'Datos Personales',
                        subtitle: 'Gestión de perfil',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PersonalDataPageView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // SECCIÓN SOPORTE
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 24, bottom: 10),
                  child: Text(
                    'SOPORTE',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProfileOptionCard(
                    icon: Icons.help_outline,
                    title: 'Centro de Ayuda',
                    subtitle: 'Preguntas frecuentes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpCenterPageView(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Botón Cerrar Sesión (Estilo fantasma/Outlined rojo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red[100]!, width: 1.5),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: Color(0xFFFF3B30),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),

            BottomNavigationBarItem(
              icon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  int cantidadEnCarrito = state.items.length;

                  if (cantidadEnCarrito > 0) {
                    return Badge(
                      label: Text('$cantidadEnCarrito'),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.shopping_bag_outlined),
                    );
                  }
                  return const Icon(Icons.shopping_bag_outlined);
                },
              ),
              activeIcon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  int cantidadEnCarrito = state.items.length;

                  if (cantidadEnCarrito > 0) {
                    return Badge(
                      label: Text('$cantidadEnCarrito'),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.shopping_bag),
                    );
                  }
                  return const Icon(Icons.shopping_bag);
                },
              ),
              label: 'Cesta',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
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

  int _resolveLoyaltyPoints(Map<String, dynamic> user) {
    if (user.containsKey('cliente') && user['cliente'] != null) {
      final saldo = user['cliente']['saldo'];
      
      if (saldo is int) return saldo;
      if (saldo is String) return int.tryParse(saldo) ?? 0;
      if (saldo is double) return saldo.toInt();
    }
    return 0;
  }
}
