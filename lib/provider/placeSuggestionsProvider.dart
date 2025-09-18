import 'package:flutter/material.dart';
import 'package:project/helper/sessionManager.dart';
import 'package:project/helper/utils/apiAndParams.dart';
import 'package:project/helper/utils/constant.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/models/placeSuggestionsModel.dart';
import 'package:project/repositories/getPlaceSuggestionsApi.dart';

enum PlaceSuggestionsState {
  initial,
  loading,
  loaded,
  empty,
  error,
}

class PlaceSuggestionsProvider extends ChangeNotifier {
  PlaceSuggestionsState placeSuggestionsState = PlaceSuggestionsState.initial;
  List<Suggestions> suggestions = [];
  String message = '';

  Future<void> fetchSuggestions({
    required BuildContext context,
    required String input,
  }) async {
    placeSuggestionsState = PlaceSuggestionsState.loading;
    suggestions = [];
    message = '';
    notifyListeners();

    try {

      final sessionManager = context.read<SessionManager>();

      // 1. Try from cache first
      if (Constant.autocompleteSuggestionsCache.containsKey(input)) {
        final cachedList = Constant.autocompleteSuggestionsCache[input] ?? [];
        suggestions = cachedList.map((e) => Suggestions.fromJson(e)).toList();

        if (suggestions.isNotEmpty) {
          placeSuggestionsState = PlaceSuggestionsState.loaded;
          notifyListeners();
          return;
        }
      }else{
        // 2. If not cached, call API
      final response = await getPlaceSuggestionsApi(
        context: context,
        input: input,
      );

      if (response[ApiAndParams.error] == true) {
        message = response[ApiAndParams.message] ?? Constant.somethingWentWrong;
        placeSuggestionsState = PlaceSuggestionsState.error;
      } else {
        final dataList = response[ApiAndParams.data][ApiAndParams.suggestions] as List;
        suggestions = dataList.map((item) => Suggestions.fromJson(item)).toList();

        if (suggestions.isEmpty) {
          placeSuggestionsState = PlaceSuggestionsState.empty;
        } else {
          placeSuggestionsState = PlaceSuggestionsState.loaded;
          // Save in Constant & session
            Constant.autocompleteSuggestionsCache[input] = suggestions.map((e) => e.toJson()).toList();
            await sessionManager.saveAutocompleteSuggestions();
        }
      }
      }
    } catch (e) {
      message = e.toString();
      placeSuggestionsState = PlaceSuggestionsState.error;
    }

    notifyListeners();
  }

  void clearSuggestions() {
    suggestions = [];
    message = '';
    placeSuggestionsState = PlaceSuggestionsState.initial;
    notifyListeners();
  }
}
