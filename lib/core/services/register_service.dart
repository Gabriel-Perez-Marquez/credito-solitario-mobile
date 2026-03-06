import 'dart:convert';

import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';


  Future<void> register({
    required String name,
    required String apellidos,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String telefono,
    required int saldo,
    required String dni,
    required String municipio,
    required String calle,
    required String numCasa,
    required String provincia,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "apellidos": apellidos,
          "telefono": telefono,
          "saldo": saldo,
          "dni": dni,
          "municipio": municipio,
          "calle": calle,
          "numCasa": numCasa,
          "provincia": provincia,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        if (token != null) {
          final AuthStorageService authStorageService = AuthStorageService();
          await authStorageService.saveToken(token);
        }
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Error al registrarse. Revisa los datos.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }




}