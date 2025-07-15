class Kehadiran {
  final int id;
  final int userId;
  final String date;
  final String checkIn;
  final String? checkOut;
  final String status;

  Kehadiran({
    required this.id,
    required this.userId,
    required this.date,
    required this.checkIn,
    this.checkOut,
    required this.status,
  });

  factory Kehadiran.fromJson(Map<String, dynamic> json) {
    return Kehadiran(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      checkIn: json['check_in'],
      checkOut: json['check_out'], // bisa null
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'check_in': checkIn,
      'check_out': checkOut,
      'status': status,
    };
  }
}
