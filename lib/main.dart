import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* p1 - adicionar a biblioteca shared_preferences
//* p2 - criar classe User
//* p3 - criar um método que converte um objeto em um map
//* p4 - criar um método construtor que converte um map em um objeto
//* p5 - criar função para salvar o usuário no disco
//* p6 - instanciar a classe que salva os dados em disco
//* p7 - criar um objeto da classe User
//* p8 - salvar o objeto user em disco
//* p9 - chamar função para salvar usuário
//* p10 - conferir na local storage
//* p11 - criar função para recuperar o usuário armazenado em disco
//* p12 - instanciar a classe que recupera os dados em disco
//* p13 - recuperar a string de um usuário armazenado em disco
//* p14 - instanciar o objeto User
//* jsonDecode converte a string em um map
//* fromMap cria a instância do objeto
//* p15 - atualizar a tela
//* p17 - criar função para limpar armazenamento
//* await prefs.clear();
//* p18 - chamar função para limpar armazenamento
//* p19 - criar card para mostrar o nome e a idade

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  //* p3 - criar um método que converte um objeto em um map
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
      };

  //* p4 - criar um método construtor que converte um map em um objeto
  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        age = map['age'];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Shared Preferences Tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nomeTextEditingController =
      TextEditingController();
  final TextEditingController _idadeTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    User user = User(
      name: _nomeTextEditingController.text,
      age: int.parse(_idadeTextEditingController.text),
    );

    await prefs.setString('user', jsonEncode(user.toJson()));
    setState(() {});
  }

  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      User user = User.fromMap(jsonDecode(userString));
      setState(() {
        _nomeTextEditingController.text = user.name;
        _idadeTextEditingController.text = user.age.toString();
      });
    }
  }

  void _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _nomeTextEditingController.text = '';
    _idadeTextEditingController.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Text(
                'Digite seu nome:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                controller: _nomeTextEditingController,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Digite sua idade:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                controller: _idadeTextEditingController,
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUser,
                  child: const Text("Salvar"),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _removeUser,
                  child: const Text("Limpar"),
                ),
              ),
              SizedBox(
                height: 100,
                width: 300,
                child: Card(
                  color: Colors.blue.shade100,
                  child: Center(
                    child: Text(
                        'Você é o ${_nomeTextEditingController.text} e tem ${_idadeTextEditingController.text} anos.'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
