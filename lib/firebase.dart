import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class DB {
  static Future<void> insertar(Map<String, dynamic> rider) async {
    await baseRemota.collection("rider").add(rider);
  }

  static Future<List> mostrarTodos() async {
    List temporal = [];
    var query = await baseRemota.collection("rider").get();
    query.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data.addAll({
        'id': element.id
      });
      temporal.add(data);
    });
    return temporal;
  }

  static Future<void> eliminar(String id) async {
    await baseRemota.collection('rider').doc(id).delete();
  }

  static Future<void> actualizar(Map<String, dynamic> rider) async {
    String id = rider['id'];
    rider.remove(id);
    await baseRemota.collection('rider').doc(id).update(rider);
  }

  static Future<Map<String, dynamic>> mostrarUno(String id) async {
    var query = await baseRemota.collection("rider").doc(id).get();
    Map<String, dynamic> data = query.data()!;
    data.addAll({
      'id': query.id
    });
    return data;
  }

}