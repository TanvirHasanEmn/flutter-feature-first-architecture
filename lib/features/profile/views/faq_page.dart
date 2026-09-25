import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/faq_controller.dart';

class FaqView extends ConsumerWidget {
  const FaqView({super.key});

  static const List<Map<String, String>> faqs = [
    {
      "question": "¿Qué es ManosPro?",
      "answer": "ManosPro es una aplicación que conecta trabajadores de distintos oficios con personas que necesitan sus servicios. Buscamos simplificar la forma de contratar profesionales de confianza en toda Argentina."
    },
    {
      "question": "¿Qué oficios puedo encontrar en la app?",
      "answer": "Podés encontrar albañiles, plomeros, electricistas, pintores, carpinteros, jardineros, mecánicos, gasistas, cerrajeros, personal de limpieza, fletes y técnicos en refrigeración/aire acondicionado."
    },
    {
      "question": "¿Cómo me registro como trabajador?",
      "answer": "Solo necesitás completar tu perfil con tus datos personales, seleccionar tus oficios y aceptar los términos de uso. Una vez registrado, obtenés 120 días gratis (4 meses) antes de pagar la suscripción mensual."
    },
    {
      "question": "¿Cuánto cuesta la suscripción para trabajadores?",
      "answer": "El plan se llama “Plan ManosPro”, cuesta 2.999 ARS por mes y ofrece 4 meses gratuitos desde el registro."
    },
    {
      "question": "¿Qué pasa si no pago la suscripción?",
      "answer": "Si no abonás la suscripción, tu cuenta se suspende automáticamente hasta que se regularice el pago."
    },
    {
      "question": "¿Cómo puede un cliente pagar un servicio?",
      "answer": "El cliente puede pagar directamente al trabajador en efectivo o por transferencia, según acuerden entre ambos. ManosPro no cobra comisión ni interfiere en los pagos entre cliente y trabajador."
    },
    {
      "question": "¿Cómo califico a un trabajador?",
      "answer": "Después de finalizar el trabajo, el cliente puede dejar una calificación y comentario. Las mejores calificaciones ayudan a los trabajadores a destacarse dentro de la app."
    },
    {
      "question": "¿Qué hago si tengo un problema con un trabajador o cliente?",
      "answer": "Podés comunicarte con nuestro soporte desde el correo soporte@manospro.app y el equipo revisará tu caso para ayudarte a resolverlo."
    },
    {
      "question": "¿Dónde funciona ManosPro?",
      "answer": "Actualmente, ManosPro funciona en toda Argentina. Nuestro objetivo es expandirnos próximamente a otros países de Latinoamérica."
    },
    {
      "question": "¿Por qué elegir ManosPro?",
      "answer": "Porque es una comunidad pensada para trabajadores reales, sin intermediarios, sin comisiones, y con una plataforma simple, transparente y confiable."
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIndex = ref.watch(faqControllerProvider);
    final controller = ref.read(faqControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Preguntas Frecuentes',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final isExpanded = expandedIndex == index;
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => controller.toggleFaq(index),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${index + 1}. ${faqs[index]["question"]}",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                        color: const Color(0xFF64748B),
                        size: 20,
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 10),
                    Text(
                      faqs[index]["answer"]!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}