import 'package:chat/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    UsuarioModel(
        uid: '1', email: 'test1@test.com', nombre: 'Maria', online: true),
    UsuarioModel(
        uid: '2', email: 'test2@test.com', nombre: 'Melissa', online: false),
    UsuarioModel(
        uid: '3', email: 'test3@test.com', nombre: 'Fernando', online: true)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mi Nombre',
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ),
            )
          ],
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.exit_to_app, color: Colors.black87)),
        ),
        body: SmartRefresher(
            onRefresh: _cargarUsuario,
            controller: _refreshController,
            header: WaterDropHeader(
              complete: Icon(
                Icons.check,
                color: Colors.blue[400],
              ),
              waterDropColor: Colors.blue[400]!,
            ),
            enablePullDown: true,
            child: _listViewUsuarios()));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => _usuarioListTile(usuarios[index]),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(UsuarioModel usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(usuario.nombre.substring(0, 2))),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  _cargarUsuario() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
