import 'package:flutter/material.dart';
import "package:realm/realm.dart";
import "package:local/car.model.dart";

void main() {
  var config = Configuration.local([Car.schema]);
  var realm = Realm(config);
  final car = Car(ObjectId(), 'Tesla', model: 'Model S', miles: 42);
  realm.write(() {
    realm.add(car);
  });
  realm.write(() {
    realm.add(Car(ObjectId(), '1231231', model: '1231231', miles: 42));
  });
  var cars = realm.all<Car>();
  Car myCar = cars[0];
  print("My car is ${myCar.make} model ${myCar.model}");
  print(cars.length);
  cars = realm.all<Car>().query("make == 'Tesla'");
  final carsTesla = realm.all<Car>().query(r"make == $0", ["Tesla"]);
  cars.changes.listen((changes) {
    print("Inserted indexes: ${changes.inserted}");
    print("Deleted indexes: ${changes.deleted}");
    print("Modified indexes: ${changes.modified}");
  });
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
