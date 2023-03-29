import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const apiUrl = "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";
  final Web3Client _client = Web3Client(apiUrl,Client());

  static const privateKey = "";
  final EthPrivateKey _credentials = EthPrivateKey.fromHex(privateKey);

  static final EthereumAddress contractAddr = EthereumAddress.fromHex("0x69ede90d7B38c3263752A9c3cAdB971ceB58C1Ad");
  DeployedContract? _contract;

  ContractFunction? _initializeFunction;
  ContractFunction? _incrementFunction;
  ContractFunction? _decrementFunction;
  ContractFunction? _getFunction;

  int _counter = 0;

  @override
  void initState(){
    super.initState();

    readAbi().then((String value) {
      _contract = DeployedContract(
        ContractAbi.fromJson(value, 'Counter'),contractAddr
      );
      _initializeFunction = _contract?.function('intialize');
      _incrementFunction = _contract?.function('increment');
      _decrementFunction = _contract?.function('decremet');
      _getFunction = _contract?.function('get');

      _getCounter();
    });
  }

  Future<String> readAbi() async {
    return await rootBundle.loadString('abi.json');
  }

  Future<void> _getCounter() async {
    await _client.call(
      contract: _contract!,
      function: _getFunction!,
      params: []).then((List result){
        setState(() {
          _counter =result.first.toInt();
        });
      });
  }
  Future<void> _decrementCounter() async {
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
       contract: _contract!,
       function: _decrementFunction!, 
       parameters: [BigInt.from(1)],
     ),
     chainId: 5,
    );
  }

  Future<void> _incrementCounter() async {
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract!,
        function: _incrementFunction!,
        parameters: [BigInt.from(1)],
      ),
      chainId: 5,
      );
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // 값을 내리는 함수
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decrementCounter, // null disables the button
                  ),
                  // Expanded expands its child to fill the available space.
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // 값을 추가하는 함수
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _incrementCounter,
                  ),
                ],
              ),
              // 현재 값을 확인하는 버튼
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _getCounter,
              )
            ],
          ),
        ));
  }
}
