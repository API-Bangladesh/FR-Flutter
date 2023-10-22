import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Connection_Checker extends StatefulWidget
{
  const Connection_Checker({Key? key}) : super(key: key);
  @override
  State<Connection_Checker> createState()=> _Connection_Checker();

  }

class _Connection_Checker extends State<Connection_Checker>
{
  late ConnectivityResult result;
  late StreamSubscription streamSubscription;
  var isConneted=false;
  @override
 void initState()
  {
    super.initState();
    startStreaming();
  }

  checkInternet() async{
    result= await Connectivity().checkConnectivity();
    if(result !=ConnectivityResult.none)
      {
        isConneted=true;
      }
    else
      {
        isConneted=false;
        showDialogBox();
      }
    setState(() {

    });
  }

  showDialogBox(){
    showDialog(context: context,
        builder: (context) =>CupertinoAlertDialog(
      title: const Text("No Internet"),
      content: const Text("Please Check Your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: const Text("Retry"), onPressed: (){}),

      ],
    ));
  }

  startStreaming()
  {
    streamSubscription= Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connection"),

      ),
    );
  }
}
