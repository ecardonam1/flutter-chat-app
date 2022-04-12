import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String content;
  final String account;
  const Labels(
      {Key? key,
      required this.ruta,
      required this.content,
      required this.account})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          content,
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            account,
            style:
                TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
