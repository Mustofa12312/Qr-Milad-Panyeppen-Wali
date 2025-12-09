import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController fade;

  @override
  void initState() {
    super.initState();

    fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ==========================
          // DEEP BLUR BACKGROUND (iOS)
          // ==========================
          GlassEffects.dynamicGlass(
            animation: fade,
            maxBlur: 40,
            minBlur: 10,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B1220),
                    Color(0xFF111827),
                    Color(0xFF1E293B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // BOKEH LIGHT EFFECT
          Positioned(
            top: -40,
            left: -30,
            child: _bokeh(
              const Color.fromARGB(255, 7, 52, 132).withOpacity(0.35),
              160,
            ),
          ),
          Positioned(
            bottom: -40,
            right: -20,
            child: _bokeh(
              const Color.fromARGB(255, 7, 52, 132).withOpacity(0.32),
              180,
            ),
          ),

          // LOGIN CARD FADE-IN
          FadeTransition(
            opacity: fade,
            child: Center(child: const _GlassLoginCard()),
          ),
        ],
      ),
    );
  }
}

Widget _bokeh(Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.6),
          blurRadius: 60,
          spreadRadius: 30,
        ),
      ],
    ),
  );
}

class _GlassLoginCard extends StatefulWidget {
  const _GlassLoginCard();

  @override
  State<_GlassLoginCard> createState() => _GlassLoginCardState();
}

class _GlassLoginCardState extends State<_GlassLoginCard>
    with TickerProviderStateMixin {
  late AnimationController glassPulse;
  late AnimationController ripple;

  @override
  void initState() {
    super.initState();

    glassPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    ripple = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    glassPulse.dispose();
    ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginController>();

    return GlassEffects.dynamicGlass(
      animation: glassPulse,
      maxBlur: 28,
      minBlur: 10,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.82,
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LOGO
            SizedBox(
              height: 90,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),

            const Text(
              "Sistem Absensi Wisuda",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 26),

            // EMAIL
            _glassField(
              hint: "Email",
              icon: Icons.person_rounded,
              onChanged: (v) => c.emailC.value = v,
            ),
            const SizedBox(height: 14),

            // PASSWORD
            _glassField(
              hint: "Password",
              icon: Icons.lock_rounded,
              obscure: true,
              onChanged: (v) => c.passC.value = v,
            ),

            const SizedBox(height: 28),

            // LOGIN BUTTON (Ripple)
            GestureDetector(
              onTap: () {
                ripple.forward(from: 0);
                c.login();
              },
              child: AnimatedBuilder(
                animation: ripple,
                builder: (context, child) {
                  final scale = 1 + (ripple.value * 0.12);
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Obx(
                    () => c.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          )
                        : const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "© 2025 Sistem Absensi • PPMU Panyeppen",
              style: TextStyle(color: Colors.black, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// TEXT FIELD
Widget _glassField({
  required String hint,
  required IconData icon,
  required Function(String v) onChanged,
  bool obscure = false,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.black.withOpacity(0.12),
      border: Border.all(color: Colors.white.withOpacity(0.40)),
    ),
    child: TextField(
      onChanged: onChanged,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}
