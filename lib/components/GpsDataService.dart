import 'package:firebase_database/firebase_database.dart';
import 'package:scooter_safety_application/components/GpsData.dart';

class GpsDataService{
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('gps-data');

  Stream<GpsData> getGpsData(){
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return GpsData.fromMap(data);
    });
  }
}