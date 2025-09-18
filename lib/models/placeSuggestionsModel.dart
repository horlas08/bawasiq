/* class PlaceSuggestionsModel {
  final bool error;
  final String message;
  final SearchLocationData data;

  PlaceSuggestionsModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory PlaceSuggestionsModel.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestionsModel(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: SearchLocationData.fromJson(json['data'] ?? {}),
    );
  }
}

class SearchLocationData {
  final List<SuggestionItem> suggestions;

  SearchLocationData({required this.suggestions});

  factory SearchLocationData.fromJson(Map<String, dynamic> json) {
    List<SuggestionItem> suggestions = [];
    if (json['suggestions'] != null) {
      suggestions = List<SuggestionItem>.from(
        json['suggestions'].map((x) => SuggestionItem.fromJson(x)),
      );
    }
    return SearchLocationData(suggestions: suggestions);
  }
}

class SuggestionItem {
  final PlacePrediction placePrediction;

  SuggestionItem({required this.placePrediction});

  factory SuggestionItem.fromJson(Map<String, dynamic> json) {
    return SuggestionItem(
      placePrediction: PlacePrediction.fromJson(json['placePrediction'] ?? {}),
    );
  }
}

class PlacePrediction {
  final String place;
  final String placeId;
  final TextItem text;
  final StructuredFormat structuredFormat;
  final List<String> types;

  PlacePrediction({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
    required this.types,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      place: json['place'] ?? '',
      placeId: json['placeId'] ?? '',
      text: TextItem.fromJson(json['text'] ?? {}),
      structuredFormat:
          StructuredFormat.fromJson(json['structuredFormat'] ?? {}),
      types: List<String>.from(json['types'] ?? []),
    );
  }
}

class TextItem {
  final String text;
  final List<Match> matches;

  TextItem({required this.text, required this.matches});

  factory TextItem.fromJson(Map<String, dynamic> json) {
    List<Match> matches = [];
    if (json['matches'] != null) {
      matches = List<Match>.from(
        json['matches'].map((x) => Match.fromJson(x)),
      );
    }
    return TextItem(text: json['text'] ?? '', matches: matches);
  }
}

class Match {
  final int endOffset;

  Match({required this.endOffset});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(endOffset: json['endOffset'] ?? 0);
  }
}

class StructuredFormat {
  final TextItem mainText;
  final TextItem secondaryText;

  StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromJson(Map<String, dynamic> json) {
    return StructuredFormat(
      mainText: TextItem.fromJson(json['mainText'] ?? {}),
      secondaryText: TextItem.fromJson(json['secondaryText'] ?? {}),
    );
  }
}
 */
class PlaceSuggestionsModel {
  bool? error;
  String? message;
  Data? data;

  PlaceSuggestionsModel({this.error, this.message, this.data});

  PlaceSuggestionsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Suggestions>? suggestions;

  Data({this.suggestions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['suggestions'] != null) {
      suggestions = <Suggestions>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(new Suggestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggestions != null) {
      data['suggestions'] = this.suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestions {
  PlacePrediction? placePrediction;

  Suggestions({this.placePrediction});

  Suggestions.fromJson(Map<String, dynamic> json) {
    placePrediction = json['placePrediction'] != null ? new PlacePrediction.fromJson(json['placePrediction']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.placePrediction != null) {
      data['placePrediction'] = this.placePrediction!.toJson();
    }
    return data;
  }
}

class PlacePrediction {
  String? place;
  String? placeId;
  Text? text;
  StructuredFormat? structuredFormat;
  List<String>? types;

  PlacePrediction({this.place, this.placeId, this.text, this.structuredFormat, this.types});

  PlacePrediction.fromJson(Map<String, dynamic> json) {
    place = json['place'];
    placeId = json['placeId'];
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
    structuredFormat = json['structuredFormat'] != null ? new StructuredFormat.fromJson(json['structuredFormat']) : null;
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place'] = this.place;
    data['placeId'] = this.placeId;
    if (this.text != null) {
      data['text'] = this.text!.toJson();
    }
    if (this.structuredFormat != null) {
      data['structuredFormat'] = this.structuredFormat!.toJson();
    }
    data['types'] = this.types;
    return data;
  }
}

class Text {
  String? text;
  List<Matches>? matches;

  Text({this.text, this.matches});

  Text.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(new Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.matches != null) {
      data['matches'] = this.matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matches {
  int? endOffset;

  Matches({this.endOffset});

  Matches.fromJson(Map<String, dynamic> json) {
    endOffset = json['endOffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['endOffset'] = this.endOffset;
    return data;
  }
}

class StructuredFormat {
  Text? mainText;
  SecondaryText? secondaryText;

  StructuredFormat({this.mainText, this.secondaryText});

  StructuredFormat.fromJson(Map<String, dynamic> json) {
    mainText = json['mainText'] != null ? new Text.fromJson(json['mainText']) : null;
    secondaryText = json['secondaryText'] != null ? new SecondaryText.fromJson(json['secondaryText']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mainText != null) {
      data['mainText'] = this.mainText!.toJson();
    }
    if (this.secondaryText != null) {
      data['secondaryText'] = this.secondaryText!.toJson();
    }
    return data;
  }
}

class SecondaryText {
  String? text;

  SecondaryText({this.text});

  SecondaryText.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}
/* class Autogenerated {
  int? status;
  String? message;
  int? total;
  Data? data;

  Autogenerated({this.status, this.message, this.total, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Predictions>? predictions;
  String? status;

  Data({this.predictions, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(new Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.predictions != null) {
      data['predictions'] = this.predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Predictions {
  String? placeId;
  String? description;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;
  List<MatchedSubstrings>? matchedSubstrings;

  Predictions({this.placeId, this.description, this.structuredFormatting, this.terms, this.types, this.matchedSubstrings});

  Predictions.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    description = json['description'];
    structuredFormatting = json['structured_formatting'] != null ? new StructuredFormatting.fromJson(json['structured_formatting']) : null;
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) {
        terms!.add(new Terms.fromJson(v));
      });
    }
    types = json['types'].cast<String>();
    if (json['matched_substrings'] != null) {
      matchedSubstrings = <MatchedSubstrings>[];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings!.add(new MatchedSubstrings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_id'] = this.placeId;
    data['description'] = this.description;
    if (this.structuredFormatting != null) {
      data['structured_formatting'] = this.structuredFormatting!.toJson();
    }
    if (this.terms != null) {
      data['terms'] = this.terms!.map((v) => v.toJson()).toList();
    }
    data['types'] = this.types;
    if (this.matchedSubstrings != null) {
      data['matched_substrings'] = this.matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];
    if (json['main_text_matched_substrings'] != null) {
      mainTextMatchedSubstrings = <MainTextMatchedSubstrings>[];
      json['main_text_matched_substrings'].forEach((v) {
        mainTextMatchedSubstrings!.add(new MainTextMatchedSubstrings.fromJson(v));
      });
    }
    secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_text'] = this.mainText;
    if (this.mainTextMatchedSubstrings != null) {
      data['main_text_matched_substrings'] = this.mainTextMatchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['secondary_text'] = this.secondaryText;
    return data;
  }
}

class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({this.length, this.offset});

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['offset'] = this.offset;
    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['offset'] = this.offset;
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['value'] = this.value;
    return data;
  }
} */
