class IPModel {
  String? ip;
  String? countryCode;
  String? countryName;
  String? regionName;
  String? cityName;
  double? latitude;
  double? longitude;
  String? zipCode;
  String? timezone;
  String? asn;
  String? as;
  bool? isProxy;

  IPModel({
    this.as,
    this.asn,
    this.cityName,
    this.countryCode,
    this.countryName,
    this.ip,
    this.isProxy,
    this.latitude,
    this.longitude,
    this.regionName,
    this.timezone,
    this.zipCode,
  });

  IPModel.fromJson(Map<String, dynamic> json) {
    as = json['as'];
    asn = json['asn'];
    cityName = json['city_name'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    ip = json['ip'];
    isProxy = json['is_proxy'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    regionName = json['region_name'];
    timezone = json['time_zone'];
    zipCode = json['zip_code'];
  }
}
