import 'package:credito_solitario_mobile/core/services/shopping_cart_service.dart';
import 'package:credito_solitario_mobile/features/login_page/ui/login_page.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShoppingCartBloc>(
          create: (context) => ShoppingCartBloc(ShoppingCartService()), 
        ),
      ],
      child: MaterialApp(
        title: 'Crédito Solidario',
        debugShowCheckedModeBanner: false,
        home: const LoginPage(), 
      ),
    );
  }
}

