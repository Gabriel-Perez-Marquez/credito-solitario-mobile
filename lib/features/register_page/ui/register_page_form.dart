import 'package:credito_solitario_mobile/features/products_page/ui/products_page_view.dart';
import 'package:credito_solitario_mobile/features/register_page/bloc/register_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RegisterPageForm extends StatefulWidget {
  const RegisterPageForm({super.key});

  @override
  State<RegisterPageForm> createState() => _RegisterPageFormState();
}

class _RegisterPageFormState extends State<RegisterPageForm> {
  // Controladores de texto
  final _nameCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passConfCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _saldoCtrl = TextEditingController(text: "1000"); 
  final _dniCtrl = TextEditingController();
  final _municipioCtrl = TextEditingController();
  final _calleCtrl = TextEditingController();
  final _numCasaCtrl = TextEditingController();
  final _provinciaCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _apellidosCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _passConfCtrl.dispose();
    _telefonoCtrl.dispose();
    _saldoCtrl.dispose();
    _dniCtrl.dispose();
    _municipioCtrl.dispose();
    _calleCtrl.dispose();
    _numCasaCtrl.dispose();
    _provinciaCtrl.dispose();
    super.dispose();
  }

  void _submitRegister() {
    // Validaciones básicas
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena los campos principales'), backgroundColor: Colors.orange)
      );
      return;
    }

    if (_passCtrl.text != _passConfCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden'), backgroundColor: Colors.red)
      );
      return;
    }

    // Disparamos el evento al nuevo RegisterPageBloc
    context.read<RegisterPageBloc>().add(
      RegisterSubmitted(
        name: _nameCtrl.text.trim(),
        apellidos: _apellidosCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        passwordConfirmation: _passConfCtrl.text,
        telefono: _telefonoCtrl.text.trim(),
        saldo: int.tryParse(_saldoCtrl.text) ?? 1000,
        dni: _dniCtrl.text.trim(),
        municipio: _municipioCtrl.text.trim(),
        calle: _calleCtrl.text.trim(),
        numCasa: _numCasaCtrl.text.trim(),
        provincia: _provinciaCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterPageBloc, RegisterPageState>(
      listener: (context, state) {
        if (state is RegisterPageSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Cuenta creada con éxito!'), backgroundColor: Color(0xFF00BFA5)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductsPageView()),
          );
        } else if (state is RegisterPageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterPageLoading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón de retroceso
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 1, 46, 89)),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 10),
                  
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/Logo-CreditoSolidario.svg',
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Crea tu cuenta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 1, 46, 89)),
                  ),
                  const SizedBox(height: 20),

                  // Campos de texto
                  _buildTextField(_nameCtrl, 'Nombre', enabled: !isLoading),
                  _buildTextField(_apellidosCtrl, 'Apellidos', enabled: !isLoading),
                  _buildTextField(_dniCtrl, 'DNI / NIE', enabled: !isLoading),
                  _buildTextField(_emailCtrl, 'Correo Electrónico', keyboardType: TextInputType.emailAddress, enabled: !isLoading),
                  _buildTextField(_telefonoCtrl, 'Teléfono', keyboardType: TextInputType.phone, enabled: !isLoading),
                  _buildTextField(_passCtrl, 'Contraseña', isPassword: true, enabled: !isLoading),
                  _buildTextField(_passConfCtrl, 'Confirmar Contraseña', isPassword: true, enabled: !isLoading),
                  
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text('Dirección', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  
                  _buildTextField(_calleCtrl, 'Calle', enabled: !isLoading),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_numCasaCtrl, 'Número', enabled: !isLoading)),
                      Expanded(flex: 2, child: _buildTextField(_municipioCtrl, 'Municipio', enabled: !isLoading)),
                    ],
                  ),
                  _buildTextField(_provinciaCtrl, 'Provincia', enabled: !isLoading),
                  _buildTextField(_saldoCtrl, 'Saldo Inicial (pts)', keyboardType: TextInputType.number, enabled: !isLoading),

                  const SizedBox(height: 30),

                  // Botón de acción principal
                  SizedBox(
                    width: double.infinity,
                    height: 55, 
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitRegister,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 1, 46, 89), 
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Registrarse',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget auxiliar para mantener el estilo de los inputs del Login
  Widget _buildTextField(
    TextEditingController controller, 
    String hintText, 
    {bool isPassword = false, 
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}