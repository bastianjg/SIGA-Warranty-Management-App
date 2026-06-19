import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {

  final AuthService authService = AuthService();  

  final ApiService apiService = ApiService();
  
  Future<void> mostrarDialogoEliminarCuenta() async {

    final TextEditingController passwordController =
        TextEditingController();

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Eliminar cuenta"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(
                "Esta acción eliminará permanentemente tu cuenta y todas tus boletas.\n\nIngresa tu contraseña para continuar.",
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,

                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () async {

                try {

                  await apiService.deleteUsuario(
                    passwordController.text,
                  );

                  await authService.logout();

                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Cuenta eliminada correctamente",
                      ),
                    ),
                  );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth',
                    (route) => false,
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Error eliminando cuenta",
                      ),
                    ),
                  );
                }
              },

              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  bool notificaciones = true;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();

    cargarPreferencias();
  }

  Future<void> cargarPreferencias() async {

    final notif =
        await PreferencesService
            .obtenerNotificaciones();

    final dark =
        await PreferencesService
            .obtenerDarkMode();

    setState(() {
      notificaciones = notif;
      darkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Perfil"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          // HEADER
          
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              "Mi cuenta",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // PREFERENCIAS

          const Text(
            "Preferencias",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          SwitchListTile(
            value: notificaciones,

            title: const Text("Notificaciones"),

            subtitle: const Text(
              "Recibir avisos de garantías próximas a vencer",
            ),

            secondary: const Icon(Icons.notifications),

            onChanged: (value) async {

              setState(() {
                notificaciones = value;
              });

              await PreferencesService
                  .guardarNotificaciones(value);
            },
          ),

          SwitchListTile(
            value: darkMode,

            title: const Text("Modo oscuro"),

            secondary: const Icon(Icons.dark_mode),

            onChanged: (value) {

              setState(() {
                darkMode = value;
              });
            },
          ),

          const SizedBox(height: 30),

          // CUENTA

          const Text(
            "Cuenta",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          ListTile(

            leading: const Icon(Icons.logout),

            title: const Text("Cerrar sesión"),

            onTap: () async {

              await authService.logout();

              if (context.mounted) {

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (route) => false,
                );
              }
            },
          ),

          ListTile(

            leading: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),

            title: const Text(
              "Eliminar cuenta",
              style: TextStyle(
                color: Colors.red,
              ),
            ),

            subtitle: const Text(
              "Eliminar permanentemente la cuenta y sus boletas",
            ),

            onTap: () {
              mostrarDialogoEliminarCuenta();
              // luego agregamos diálogo
            },
          ),
        ],
      ),
    );
  }
}