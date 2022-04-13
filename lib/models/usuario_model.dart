class UsuarioModel {
  bool online;
  String email;
  String nombre;
  String uid;

  UsuarioModel(
      {this.online = false,
      required this.email,
      required this.nombre,
      this.uid = 'no-uid'});
}
