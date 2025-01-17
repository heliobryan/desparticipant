// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> userLogin(String email, String password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = Uri.parse('https://api.des.versatecnologia.com.br/api/login');

  var restAwnser = await http.post(
    url,
    body: {
      'email': email,
      'password': password,
    },
  );

  if (restAwnser.statusCode == 200) {
    final decode = jsonDecode(restAwnser.body);
    String token = decode['token'];

    print('Token recebido da API: $token');

    await sharedPreferences.setString(
      'token',
      token,
    );

    return true;
  } else {
    print('Erro na resposta da API: ${restAwnser.body}');
    return false;
  }
}
