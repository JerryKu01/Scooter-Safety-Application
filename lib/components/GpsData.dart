  class GpsData {
  final double latitude;
  final double longitude;
  final DateTime timeStamp;
  GpsData({required this.latitude, required this.longitude, required this.timeStamp});

  factory GpsData.fromMap(Map<dynamic, dynamic> map){
    return GpsData(
        latitude: map['latitude'],
        longitude: map['longitude'],
        timeStamp: DateTime.parse(map['timeStamp']),
    );
  }
}