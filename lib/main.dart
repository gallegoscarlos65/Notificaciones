import 'package:flutter/material.dart';
import 'package:notificaciones/screens/home_screen.dart';
import 'package:notificaciones/screens/message_screen.dart';
import 'package:notificaciones/services/push_notifications_service.dart';

void main() async {

  //Es para que no de ningun error de que no ha sido inicializado nada y de perdido el siguiente metodo tenga un contexto
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();

  runApp(MyApp());

}

//Se convierte a Stateful para hacer el init state
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService.messagesStream.listen((message) { 
      // print('MyApp: $message');

      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackBar = SnackBar(content: Text(message));
      //Que solo continue si ya esta inicializado
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: messengerKey, //Snacks
      routes: {
        'home'  :   ( _ ) => HomeScreen(),
        'message':  ( _ ) => MessageScreen()
      },
    );
  }
}