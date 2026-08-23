import 'package:serena_poc_client/serena_poc_client.dart';

extension BlockSeverityLabel on BlockSeverity {
  String get label {
    switch (this) {
      case BlockSeverity.leve:
        return 'Leve';
      case BlockSeverity.moderado:
        return 'Moderado';
      case BlockSeverity.fuerte:
        return 'Fuerte';
    }
  }
}

extension BlockContextLabel on BlockContext {
  String get label {
    switch (this) {
      case BlockContext.llamada:
        return 'En llamada';
      case BlockContext.publico:
        return 'Hablando en público';
      case BlockContext.desconocidos:
        return 'Con desconocidos';
      case BlockContext.conocidos:
        return 'Con conocidos';
      case BlockContext.trabajoEscuela:
        return 'Trabajo/escuela';
      case BlockContext.otro:
        return 'Otro';
    }
  }
}