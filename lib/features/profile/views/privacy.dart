import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Política de Privacidad',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'POLÍTICA DE PRIVACIDAD – MANOSPRO',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Última actualización: octubre de 2025',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Información que recopilamos',
              'Recopilamos la información necesaria para ofrecer un servicio seguro y funcional. '
                  'Esto incluye: datos personales al registrarte (nombre, correo electrónico, teléfono, contraseña), '
                  'información de perfil (oficios, ubicación general, foto) y datos técnicos del dispositivo.',
            ),
            _buildSection(
              '2. Uso de la información',
              'Usamos la información para gestionar cuentas, permitir la búsqueda de servicios, '
                  'facilitar la comunicación entre usuarios y mejorar la plataforma. '
                  'No utilizamos datos con fines publicitarios sin tu consentimiento.',
            ),
            _buildSection(
              '3. Suscripciones y pagos',
              'Los pagos entre clientes y trabajadores se realizan directamente entre ambas partes fuera de la app. '
                  'ManosPro no cobra comisiones por trabajos realizados ni almacena datos de tarjetas.',
            ),
            _buildSection(
              '4. Contacto',
              'Para consultas o ejercer tus derechos sobre tus datos, comunicate con nosotros en soporte@manospro.app.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569), height: 1.5),
          ),
        ],
      ),
    );
  }
}