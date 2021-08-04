import 'dart:convert';


class MyTime {
  String? mytime;
  MyTime({
    this.mytime,
  });

  MyTime copyWith({
    String? mytime,
  }) {
    return MyTime(
      mytime: mytime ?? this.mytime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mytime': mytime,
    };
  }

  factory MyTime.fromMap(Map<String, dynamic> map) {
    return MyTime(
      mytime: map['mytime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyTime.fromJson(String source) => MyTime.fromMap(json.decode(source));

  @override
  String toString() => 'MyTime(mytime: $mytime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyTime &&
      other.mytime == mytime;
  }

  @override
  int get hashCode => mytime.hashCode;
}
