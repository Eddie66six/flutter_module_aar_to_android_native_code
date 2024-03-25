import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ModulePageTest(),
    );
  }
}
class ModulePageTest extends StatefulWidget {
  const ModulePageTest({super.key});

  @override
  State<ModulePageTest> createState() => _ModulePageTestState();
}

class _ModulePageTestState extends State<ModulePageTest> {
  var parametro = "";
  static const platform = MethodChannel('abcevo.channel.modulename/openmodule');
  @override
  void initState() {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "param") {
        parametro = call.arguments;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("aar flutter parametro recebido: $parametro")),
    );
  }
}