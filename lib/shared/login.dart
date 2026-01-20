import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/Logo-CreditoSolidario.svg',
        width: 350,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Usuario',
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              hintText: 'Contraseña',
            ),
          ),
        ),
        SizedBox(height: 20,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 1, 46, 89))), child: Text('Inicion Sesiar', style: TextStyle(fontSize: 20, color: Colors.white),),),
        )
        
      ]);
  }
}