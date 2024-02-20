import 'dart:convert';

SshemsLatestDataModel sshemsLatestDataModelFromJson(String str) =>
    SshemsLatestDataModel.fromJson(json.decode(str));

String sshemsLatestDataModelToJson(SshemsLatestDataModel data) =>
    json.encode(data.toJson());

class SshemsLatestDataModel {
  final double? irms;
  final double? apparentPower;
  final int? batteryVoltage;
  final int? chargingCurrent;
  final double? dischargeCurrent;
  final double? powerFactor;
  final double? realPower;
  final double? supplyVoltage;
  final String? time;

  SshemsLatestDataModel({
    this.irms,
    this.apparentPower,
    this.batteryVoltage,
    this.chargingCurrent,
    this.dischargeCurrent,
    this.powerFactor,
    this.realPower,
    this.supplyVoltage,
    this.time,
  });

  SshemsLatestDataModel copyWith({
    double? irms,
    double? apparentPower,
    int? batteryVoltage,
    int? chargingCurrent,
    double? dischargeCurrent,
    double? powerFactor,
    double? realPower,
    double? supplyVoltage,
    String? time,
  }) =>
      SshemsLatestDataModel(
        irms: irms ?? this.irms,
        apparentPower: apparentPower ?? this.apparentPower,
        batteryVoltage: batteryVoltage ?? this.batteryVoltage,
        chargingCurrent: chargingCurrent ?? this.chargingCurrent,
        dischargeCurrent: dischargeCurrent ?? this.dischargeCurrent,
        powerFactor: powerFactor ?? this.powerFactor,
        realPower: realPower ?? this.realPower,
        supplyVoltage: supplyVoltage ?? this.supplyVoltage,
        time: time ?? this.time,
      );

  factory SshemsLatestDataModel.fromJson(Map<String, dynamic> json) =>
      SshemsLatestDataModel(
        irms: json["Irms"]?.toDouble(),
        apparentPower: json["apparentPower"]?.toDouble(),
        batteryVoltage: json["batteryVoltage"],
        chargingCurrent: json["chargingCurrent"],
        dischargeCurrent: json["dischargeCurrent"]?.toDouble(),
        powerFactor: json["powerFactor"]?.toDouble(),
        realPower: json["realPower"]?.toDouble(),
        supplyVoltage: json["supplyVoltage"]?.toDouble(),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "Irms": irms,
        "apparentPower": apparentPower,
        "batteryVoltage": batteryVoltage,
        "chargingCurrent": chargingCurrent,
        "dischargeCurrent": dischargeCurrent,
        "powerFactor": powerFactor,
        "realPower": realPower,
        "supplyVoltage": supplyVoltage,
        "time": time,
      };
}
