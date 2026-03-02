import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:flutter/material.dart';

class PersonalDataPageView extends StatefulWidget {
  const PersonalDataPageView({super.key});

  @override
  State<PersonalDataPageView> createState() => _PersonalDataPageViewState();
}

class _PersonalDataPageViewState extends State<PersonalDataPageView> {
  // Estado para controlar si estamos en modo edición o no
  bool _isEditing = false;
  bool _isLoading = false;
  final ProfileService _profileService = ProfileService();


  // Controladores para los campos
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    // TODO: Aquí deberías inicializar los controladores con los datos reales de tu usuario
    // provenientes de tu API o de tu estado global (Bloc)
    _nameCtrl = TextEditingController(text: 'Gabriel Pérez');
    _emailCtrl = TextEditingController(text: 'pepito@email.com');
    _phoneCtrl = TextEditingController(text: '+34 600 000 000');
    _addressCtrl = TextEditingController(text: 'Calle Falsa 123, Madrid');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // Función para guardar los datos
  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    try {
      await _profileService.updateProfile(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        address: _addressCtrl.text,
      );
      
      
      // Simulamos un retraso de red
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      
      setState(() {
        _isEditing = false; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Información actualizada correctamente'),
          backgroundColor: Color(0xFF00BFA5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Datos Personales',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() => _isEditing = false);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF004B93),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                if (_isEditing)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () {
                        // Acción para cambiar la foto de perfil
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Campos de datos
            _buildDataField(
              label: 'Nombre Completo',
              controller: _nameCtrl,
              icon: Icons.person_outline,
            ),
            _buildDataField(
              label: 'Correo Electrónico',
              controller: _emailCtrl,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildDataField(
              label: 'Teléfono',
              controller: _phoneCtrl,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _buildDataField(
              label: 'Dirección',
              controller: _addressCtrl,
              icon: Icons.location_on_outlined,
            ),
            
            const SizedBox(height: 30),
            
            // Botón principal (Alterna entre Editar y Guardar)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_isEditing) {
                          _saveData(); // Si está editando, guarda
                        } else {
                          setState(() => _isEditing = true); // Si no, activa la edición
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? const Color(0xFF00BFA5) : const Color(0xFF004B93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isEditing ? 'Guardar Cambios' : 'Editar Información',
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget dinámico: Si _isEditing es true muestra un TextField, si es false muestra un Text
  Widget _buildDataField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: _isEditing ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isEditing ? const Color(0xFF00BFA5) : Colors.grey[200]!),
        boxShadow: _isEditing
            ? [BoxShadow(color: const Color(0xFF00BFA5).withOpacity(0.1), blurRadius: 8)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: _isEditing ? 4 : 8),
          if (_isEditing)
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            )
          else
            Text(
              controller.text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
            ),
        ],
      ),
    );
  }
}