import 'package:serena_client/serena_client.dart';

/// Instancia única del cliente de Serverpod, compartida por toda la app.
/// Cambiar _serverUrl si cambia la IP de la compu donde corre el backend.
class ServerClient {
  static const String _serverUrl = 'http://192.168.100.31:8080/';

  static final Client instance = Client(_serverUrl);
}