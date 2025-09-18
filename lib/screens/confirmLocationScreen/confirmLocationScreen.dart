import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/provider/placeDetailsProvider.dart';
import 'package:project/provider/placeSuggestionsProvider.dart';

class ConfirmLocation extends StatefulWidget {
  final GeoAddress? address;
  final String from;

  const ConfirmLocation({Key? key, this.address, required this.from}) : super(key: key);

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {
  late GoogleMapController controller;
  late CameraPosition kGooglePlex;
  late LatLng kMapCenter;
  double mapZoom = 14.4746;

  List<Marker> customMarkers = [];
  String googleMapCurrentStyle = "[]";
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

/*   void _onSearchChanged(String input, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (input.trim().isNotEmpty) {
        context.read<PlaceSuggestionsProvider>().fetchSuggestions(
              context: context,
              input: input.trim(),
            );
      } else {
        context.read<PlaceSuggestionsProvider>().clearSuggestions();
      }
    });
  } */

String _lastQuery = '';

  void _onSearchChanged(String input, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      input = input.trim();

      // Skip if less than 3 chars, empty, or same as last query
      if (input.length < 3 || input == _lastQuery) return;

      _lastQuery = input;

      context.read<PlaceSuggestionsProvider>().fetchSuggestions(
            context: context,
            input: input,
          );
    });
  }

  @override
  void initState() {
    super.initState();

    kMapCenter = LatLng(0.0, 0.0);
    Future.delayed(Duration.zero).then((value) async {
      googleMapCurrentStyle = Constant.session.getBoolData(SessionManager.isDarkTheme)
          ? await rootBundle.loadString(Constant.getAssetsPath(5, "nightMode"))
          : await rootBundle.loadString(Constant.getAssetsPath(5, "dayMode"));
      // await checkPermission();
    });

    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );

    if (widget.address != null) {
      kMapCenter = LatLng(double.parse(widget.address!.lattitud!), double.parse(widget.address!.longitude!));

      kGooglePlex = CameraPosition(
        target: kMapCenter,
        zoom: mapZoom,
      );
    } else {
      checkPermission();
    }

    setMarkerIcon();
    placeSearchData();
  }

  placeSearchData() async {
    await context.read<SessionManager>().loadAutocompleteSuggestions();
    await context.read<SessionManager>().loadPlaceDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkPermission() async {
    await hasLocationPermissionGiven().then(
      (value) async {
        if (value is PermissionStatus) {
          if (value.isGranted) {
            await Geolocator.getCurrentPosition().then((value) async {
              updateMap(value.latitude, value.longitude);
            });
          } else if (value.isDenied) {
            await Permission.location.request();
          } else if (value.isPermanentlyDenied) {
            if (!Constant.session.getBoolData(SessionManager.keyPermissionLocationHidePromptPermanently)) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      PermissionHandlerBottomSheet(
                        titleJsonKey: locationPermissionTitleLabel,
                        messageJsonKey: locationPermissionMessageLabel,
                        sessionKeyForAskNeverShowAgain: SessionManager.keyPermissionLocationHidePromptPermanently,
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      },
    );
  }

  updateMap(double latitude, double longitude) {
    kMapCenter = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: kMapCenter,
      zoom: mapZoom,
    );
    setMarkerIcon();
    controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  }

  setMarkerIcon() async {
    MarkerGenerator(
      const MapDeliveredMarker(),
      (bitmaps) {
        setState(
          () {
            bitmaps.asMap().forEach(
              (i, bmp) {
                customMarkers.add(
                  Marker(
                    markerId: MarkerId("$i"),
                    position: kMapCenter,
                    icon: BitmapDescriptor.bytes(
                      bmp,
                      height: 24,
                      width: 24,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).generate(context);

    Constant.cityAddressMap = await getCityNameAndAddress(kMapCenter, context, setState);

    if (widget.from == "location") {
      Map<String, dynamic> params = {};
      // params[ApiAndParams.cityName] = Constant.cityAddressMap["city"];

      params[ApiAndParams.longitude] = kMapCenter.longitude.toString();
      params[ApiAndParams.latitude] = kMapCenter.latitude.toString();

      await context.read<CityByLatLongProvider>().getCityByLatLongApiProvider(context: context, params: params);
    }

    setState(() {});
  }

  void showSearchDialog(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      useSafeArea: true,
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      backgroundColor: Theme.of(parentContext).cardColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: Provider.of<PlaceSuggestionsProvider>(parentContext, listen: false),
              ),
              ChangeNotifierProvider(
                create: (_) => PlaceDetailsProvider(),
              ),
            ],
            child: Consumer2<PlaceSuggestionsProvider, PlaceDetailsProvider>(
              builder: (context, suggestionProvider, detailsProvider, _) {
                return Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    children: [
                      /// Header
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: defaultImg(
                              image: AppAssets.icArrowBackIcon,
                              iconColor: ColorsRes.mainTextColor,
                              height: 15,
                              width: 15,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: CustomTextLabel(
                                jsonKey: locationsLabel,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium!.merge(
                                      TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      /// Search Field
                      TextField(textAlignVertical: TextAlignVertical.center,
                        controller: _searchController,
                        onChanged: (val) => _onSearchChanged(val, context),
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ),
                        decoration: InputDecoration(
                          // prefix: Icon(Icons.search_rounded, color: ColorsRes.appColor),
                          alignLabelWithHint: true,
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                          suffixIcon: GestureDetector(onTap:(){
                            _searchController.clear();
                            suggestionProvider.clearSuggestions();
                          },child: Icon(Icons.close, color: ColorsRes.appColor)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: ColorsRes.appColor,
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.5),
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: ColorsRes.appColorRed,
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor,
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: ColorsRes.subTitleMainTextColor.withValues(alpha: 0.5),
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          labelText: getTranslatedValue(context, searchLocationHintLabel),
                          labelStyle: TextStyle(color: ColorsRes.subTitleMainTextColor),
                          isDense: true,
                          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                            (Set<WidgetState> states) {
                              final Color color =
                                  states.contains(WidgetState.error) ? Theme.of(context).colorScheme.error : ColorsRes.appColor;
                              return TextStyle(color: color, letterSpacing: 1.3);
                            },
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      const SizedBox(height: 10),
                  
                      /// Suggestions List
                      if (suggestionProvider.placeSuggestionsState == PlaceSuggestionsState.loading)
                        const Center(child: CircularProgressIndicator())
                      else if (suggestionProvider.placeSuggestionsState == PlaceSuggestionsState.empty)
                        const Text("No suggestions found.")
                      else if (suggestionProvider.suggestions.isNotEmpty)
                        Column(
                          children: List.generate(
                            suggestionProvider.suggestions.length,
                            (index) {
                              final prediction = suggestionProvider.suggestions[index];
                              return GestureDetector(
                                onTap: () async {
                                  await detailsProvider.fetchPlaceDetails(
                                    context: context,
                                    placeId: prediction.placePrediction!.placeId!,
                                  ).then((onValue){
                                    if (detailsProvider.placeDetailsState == PlaceDetailsState.loaded) {
                                      Navigator.pop(context); // Close bottom sheet
                  
                                      final selectedLocation = detailsProvider.placeDetails;
                                      print("Selected place: ${selectedLocation?.name}");
                                      displayPrediction(prediction.placePrediction!, context, selectedLocation!).then(
                                        (value) {
                                          if (value != null) {
                                            updateMap(
                                              double.parse(value.lattitud ?? "0.0"),
                                              double.parse(
                                                value.longitude ?? "0.0",
                                              ),
                                            );
                                          }
                                        },
                                      );
                                      suggestionProvider.clearSuggestions();
                                      _searchController.clear();
                                    } else {
                                      showMessage(context, detailsProvider.message, MessageType.warning);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.all(10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Theme.of(context).brightness == Brightness.light ? ColorsRes.appColorBlack45 : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextLabel(
                                          text: prediction.placePrediction?.text!.text! ?? '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((onValue){
      _searchController.clear();
      context.read<PlaceSuggestionsProvider>().clearSuggestions();
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              Navigator.pop(context, false);
            });
          }
        },
        child: Scaffold(
          appBar: getAppBar(
            context: context,
            title: CustomTextLabel(
              jsonKey: confirmLocationLabel,
            ),
            showBackButton: Navigator.of(context).canPop(),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      start: 0,
                      bottom: 0,
                      child: mapWidget(),
                    ),
                    PositionedDirectional(
                      top: 15,
                      end: 15,
                      start: 15,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            /* Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: Constant.googleApiKey,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              textStyle: TextStyle(
                                color: ColorsRes.mainTextColor,
                              ));
      
                          displayPrediction(p, context).then(
                            (value) {
                              if (value != null) {
                                updateMap(
                                  double.parse(value.lattitud ?? "0.0"),
                                  double.parse(
                                    value.longitude ?? "0.0",
                                  ),
                                );
                              }
                            },
                          ); */
                          showSearchDialog(context);
                          },
                          child: Container(
                            decoration: DesignConfig.boxDecoration(
                              Theme.of(context).scaffoldBackgroundColor,
                              10,
                            ),
                            child: ListTile(
                              title: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: getTranslatedValue(context, searchLocationHintLabel),
                                  hintStyle: TextStyle(
                                    color: ColorsRes.subTitleMainTextColor,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.only(
                                start: Constant.size12,
                              ),
                              trailing: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.search,
                                  color: ColorsRes.mainTextColor,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        )),
                        SizedBox(width: Constant.size10),
                        GestureDetector(
                          onTap: () async {
                            await checkPermission();
                          },
                          child: Container(
                            decoration: DesignConfig.boxGradient(10),
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                            child: defaultImg(
                              image: AppAssets.myLocationIcon,
                              iconColor: ColorsRes.mainIconColor,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              confirmBtnWidget(),
            ],
          ),
        ));
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      onTap: (argument) async {
        updateMap(argument.latitude, argument.longitude);
      },
      onMapCreated: _onMapCreated,
      markers: customMarkers.toSet(),
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      style: googleMapCurrentStyle,
      onCameraMove: (position) {
        mapZoom = position.zoom;
      },
      // markers: markers,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controllerParam) async {
    controller = controllerParam;
  }

  confirmBtnWidget() {
    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.from == "location" && !context.read<CityByLatLongProvider>().isDeliverable)
              ? CustomTextLabel(
                  jsonKey: doesNotDeliveryLongMessageLabel,
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                        color: ColorsRes.appColorRed,
                      ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20, end: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultImg(
                  image: AppAssets.addressIcon,
                  iconColor: ColorsRes.appColor,
                  height: 25,
                  width: 25,
                ),
                getSizedBox(
                  width: 20,
                ),
                Expanded(
                  child: CustomTextLabel(
                    text: Constant.cityAddressMap["address"] ?? "",
                  ),
                ),
              ],
            ),
          ),
          if ((widget.from == "location" && context.read<CityByLatLongProvider>().isDeliverable) || widget.from == "address")
            ConfirmButtonWidget(
              voidCallback: () {
                Constant.session.setData(SessionManager.keyLongitude, kMapCenter.longitude.toString(), false);
                Constant.session.setData(SessionManager.keyLatitude, kMapCenter.latitude.toString(), false);
                if (widget.from == "location" && context.read<CityByLatLongProvider>().isDeliverable) {
                  context.read<CartListProvider>().getAllCartItems(context: context);
                  Constant.session.setData(SessionManager.keyAddress, Constant.cityAddressMap["address"], true);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    mainHomeScreen,
                    (Route<dynamic> route) => false,
                  );
                } else if (widget.from == "address") {
                  Future.delayed(const Duration(milliseconds: 500)).then(
                    (value) {
                      Navigator.pop(context, true);
                    },
                  );
                }
              },
            )
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    googleMapCurrentStyle = Constant.session.getBoolData(SessionManager.isDarkTheme)
        ? await rootBundle.loadString(Constant.getAssetsPath(5, "nightMode"))
        : await rootBundle.loadString(Constant.getAssetsPath(5, "dayMode"));
    setState(() {});
    super.didChangeDependencies();
  }
}
