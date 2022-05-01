import 'package:chat/global/environment.dart';
import 'package:chat/models/usuario_model.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      final resp = await http.get(
          Uri.http(Environment.host, '${Environment.path}/usuarios'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
