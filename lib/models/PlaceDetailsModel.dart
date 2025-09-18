class PlaceDetailsModel {
  String? name;
  String? id;
  List<String>? types;
  String? formattedAddress;
  List<AddressComponents>? addressComponents;
  Location? location;
  Viewport? viewport;
  String? googleMapsUri;
  int? utcOffsetMinutes;
  String? adrFormatAddress;
  String? iconMaskBaseUri;
  String? iconBackgroundColor;
  DisplayName? displayName;
  DisplayName? primaryTypeDisplayName;
  String? primaryType;
  String? shortFormattedAddress;
  List<Photos>? photos;
  bool? pureServiceAreaBusiness;
  GoogleMapsLinks? googleMapsLinks;
  TimeZone? timeZone;

  PlaceDetailsModel({
    this.name,
    this.id,
    this.types,
    this.formattedAddress,
    this.addressComponents,
    this.location,
    this.viewport,
    this.googleMapsUri,
    this.utcOffsetMinutes,
    this.adrFormatAddress,
    this.iconMaskBaseUri,
    this.iconBackgroundColor,
    this.displayName,
    this.primaryTypeDisplayName,
    this.primaryType,
    this.shortFormattedAddress,
    this.photos,
    this.pureServiceAreaBusiness,
    this.googleMapsLinks,
    this.timeZone,
  });

  PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    types =
        (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            [];
    formattedAddress = json['formattedAddress'];
    addressComponents = (json['addressComponents'] as List<dynamic>?)
            ?.map((v) => AddressComponents.fromJson(v))
            .toList() ??
        [];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
    googleMapsUri = json['googleMapsUri'];
    utcOffsetMinutes = json['utcOffsetMinutes'];
    adrFormatAddress = json['adrFormatAddress'];
    iconMaskBaseUri = json['iconMaskBaseUri'];
    iconBackgroundColor = json['iconBackgroundColor'];
    displayName = json['displayName'] != null
        ? DisplayName.fromJson(json['displayName'])
        : null;
    primaryTypeDisplayName = json['primaryTypeDisplayName'] != null
        ? DisplayName.fromJson(json['primaryTypeDisplayName'])
        : null;
    primaryType = json['primaryType'];
    shortFormattedAddress = json['shortFormattedAddress'];
    photos = (json['photos'] as List<dynamic>?)
            ?.map((v) => Photos.fromJson(v))
            .toList() ??
        [];
    pureServiceAreaBusiness = json['pureServiceAreaBusiness'];
    googleMapsLinks = json['googleMapsLinks'] != null
        ? GoogleMapsLinks.fromJson(json['googleMapsLinks'])
        : null;
    timeZone =
        json['timeZone'] != null ? TimeZone.fromJson(json['timeZone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['id'] = this.id;
    data['types'] = this.types;
    data['formattedAddress'] = this.formattedAddress;
    if (this.addressComponents != null) {
      data['addressComponents'] = this.addressComponents!.map((v) => v.toJson()).toList();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    data['googleMapsUri'] = this.googleMapsUri;
    data['utcOffsetMinutes'] = this.utcOffsetMinutes;
    data['adrFormatAddress'] = this.adrFormatAddress;
    data['iconMaskBaseUri'] = this.iconMaskBaseUri;
    data['iconBackgroundColor'] = this.iconBackgroundColor;
    if (this.displayName != null) {
      data['displayName'] = this.displayName!.toJson();
    }
    if (this.primaryTypeDisplayName != null) {
      data['primaryTypeDisplayName'] = this.primaryTypeDisplayName!.toJson();
    }
    data['primaryType'] = this.primaryType;
    data['shortFormattedAddress'] = this.shortFormattedAddress;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['pureServiceAreaBusiness'] = this.pureServiceAreaBusiness;
    if (this.googleMapsLinks != null) {
      data['googleMapsLinks'] = this.googleMapsLinks!.toJson();
    }
    if (this.timeZone != null) {
      data['timeZone'] = this.timeZone!.toJson();
    }
    return data;
  }
}

class AddressComponents {
  String? longText;
  String? shortText;
  List<String>? types;
  String? languageCode;

  AddressComponents(
      {this.longText, this.shortText, this.types, this.languageCode});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longText = json['longText'];
    shortText = json['shortText'];
    types =
        (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            [];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longText'] = this.longText;
    data['shortText'] = this.shortText;
    data['types'] = this.types;
    data['languageCode'] = this.languageCode;
    return data;
  }
  
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Viewport {
  Location? low;
  Location? high;

  Viewport({this.low, this.high});

  Viewport.fromJson(Map<String, dynamic> json) {
    low = json['low'] != null ? Location.fromJson(json['low']) : null;
    high = json['high'] != null ? Location.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.low != null) {
      data['low'] = this.low!.toJson();
    }
    if (this.high != null) {
      data['high'] = this.high!.toJson();
    }
    return data;
  }
}

class DisplayName {
  String? text;
  String? languageCode;

  DisplayName({this.text, this.languageCode});

  DisplayName.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = this.text;
    data['languageCode'] = this.languageCode;
    return data;
  }
}

class Photos {
  String? name;
  int? widthPx;
  int? heightPx;
  List<AuthorAttributions>? authorAttributions;
  String? flagContentUri;
  String? googleMapsUri;

  Photos({
    this.name,
    this.widthPx,
    this.heightPx,
    this.authorAttributions,
    this.flagContentUri,
    this.googleMapsUri,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    widthPx = json['widthPx'];
    heightPx = json['heightPx'];
    authorAttributions = (json['authorAttributions'] as List<dynamic>?)
            ?.map((v) => AuthorAttributions.fromJson(v))
            .toList() ??
        [];
    flagContentUri = json['flagContentUri'];
    googleMapsUri = json['googleMapsUri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['widthPx'] = this.widthPx;
    data['heightPx'] = this.heightPx;
    if (this.authorAttributions != null) {
      data['authorAttributions'] = this.authorAttributions!.map((v) => v.toJson()).toList();
    }
    data['flagContentUri'] = this.flagContentUri;
    data['googleMapsUri'] = this.googleMapsUri;
    return data;
  }
}

class AuthorAttributions {
  String? displayName;
  String? uri;
  String? photoUri;

  AuthorAttributions({this.displayName, this.uri, this.photoUri});

  AuthorAttributions.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    uri = json['uri'];
    photoUri = json['photoUri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = this.displayName;
    data['uri'] = this.uri;
    data['photoUri'] = this.photoUri;
    return data;
  }
}

class GoogleMapsLinks {
  String? directionsUri;
  String? placeUri;
  String? photosUri;

  GoogleMapsLinks({this.directionsUri, this.placeUri, this.photosUri});

  GoogleMapsLinks.fromJson(Map<String, dynamic> json) {
    directionsUri = json['directionsUri'];
    placeUri = json['placeUri'];
    photosUri = json['photosUri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['directionsUri'] = this.directionsUri;
    data['placeUri'] = this.placeUri;
    data['photosUri'] = this.photosUri;
    return data;
  }
}

class TimeZone {
  String? id;

  TimeZone({this.id});

  TimeZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    return data;
  }
}
