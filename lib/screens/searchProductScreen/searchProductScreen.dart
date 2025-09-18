import 'package:project/helper/utils/generalImports.dart';


class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductSearchScreen> {
  // search provider controller
  final TextEditingController edtSearch = TextEditingController();

  //give delay to live search
  Timer? delayTimer;

  ScrollController scrollController = ScrollController();

  scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      if (context.read<ProductSearchProvider>().hasMoreData) {
        Map<String, String> params = await Constant.getProductsDefaultParams();

        params[ApiAndParams.search] = edtSearch.text.trim();

        await context.read<ProductSearchProvider>().getProductSearchProvider(context: context, params: params);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    edtSearch.addListener(searchTextListener);
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void searchTextListener() {
    if (edtSearch.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 500), () {
      if (edtSearch.text.isNotEmpty) {
        if (edtSearch.text.length != context.read<ProductSearchProvider>().searchedTextLength) {
          callApi(isReset: true);
          context.read<ProductSearchProvider>().setSearchLength(edtSearch.text);
        }
      }
    });
  }

  callApi({required bool isReset}) async {
    if (isReset) {
      context.read<ProductSearchProvider>().offset = 0;

      context.read<ProductSearchProvider>().products = [];
    }

    Map<String, String> params = await Constant.getProductsDefaultParams();

    params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[context.read<ProductSearchProvider>().currentSortByOrderIndex];
    params[ApiAndParams.search] = edtSearch.text.trim().toString();

    await context.read<ProductSearchProvider>().getProductSearchProvider(context: context, params: params);
  }

  @override
  Widget build(BuildContext context) {
    List lblSortingDisplayList = [
      sortingDefaultLabel,
      sortingNewestFirstLabel,
      sortingOldestFirstLabel,
      sortingPriceHighToLowLabel,
      sortingPriceLowToHighLabel,
      sortingDiscountHighToLowLabel,
      sortingPopularityLabel,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: searchLabel,
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [
            if (context.watch<ProductSearchProvider>().products.length > 0)
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        productListFilterScreen,
                        arguments: [
                          context.read<ProductSearchProvider>().productList.brands,
                          double.parse(context.read<ProductSearchProvider>().productList.totalMaxPrice),
                          double.parse(context.read<ProductSearchProvider>().productList.totalMinPrice),
                          context.read<ProductSearchProvider>().productList.sizes,
                          Constant.selectedCategories,
                        ],
                      ).then((value) async {
                        if (value == true) {
                          context.read<ProductSearchProvider>().offset = 0;
                          context.read<ProductSearchProvider>().products = [];

                          callApi(isReset: true);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(end: 5),
                      padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: ColorsRes.grey.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultImg(
                              image: AppAssets.filterIcon,
                              height: 14,
                              width: 14,
                              padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 2),
                              iconColor: Theme.of(context).primaryColor),
                          CustomTextLabel(
                            jsonKey:filterLabel,
                            softWrap: true,
                            style: TextStyle(
                              color: ColorsRes.appColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                        builder: (BuildContext context1) {
                          return Wrap(
                            children: [
                              Container(
                                decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        PositionedDirectional(
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: defaultImg(
                                                image: AppAssets.icArrowBackIcon,
                                                iconColor: ColorsRes.mainTextColor,
                                                height: 15,
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: CustomTextLabel(
                                            jsonKey: sortByLabel,
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
                                      ],
                                    ),
                                    getSizedBox(height: 10),
                                    Column(
                                      children: List.generate(
                                        ApiAndParams.productListSortTypes.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              context.read<ProductSearchProvider>().products = [];

                                              context.read<ProductSearchProvider>().offset = 0;

                                              context.read<ProductSearchProvider>().currentSortByOrderIndex = index;

                                              callApi(isReset: true);
                                            },
                                            child: Container(
                                              padding: EdgeInsetsDirectional.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  context.read<ProductSearchProvider>().currentSortByOrderIndex == index
                                                      ? Icon(
                                                          Icons.radio_button_checked,
                                                          color: ColorsRes.appColor,
                                                        )
                                                      : Icon(
                                                          Icons.radio_button_off,
                                                          color: ColorsRes.appColor,
                                                        ),
                                                  getSizedBox(width: 10),
                                                  Expanded(
                                                    child: CustomTextLabel(
                                                      jsonKey: lblSortingDisplayList[index],
                                                      softWrap: true,
                                                      style: Theme.of(context).textTheme.titleMedium!.merge(
                                                            TextStyle(
                                                              letterSpacing: 0.5,
                                                              fontSize: 16,
                                                              color: ColorsRes.mainTextColor,
                                                            ),
                                                          ),
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
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(end: 10),
                      padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: ColorsRes.grey.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultImg(
                              image: AppAssets.sortingIcon,
                              height: 14,
                              width: 14,
                              padding: const EdgeInsetsDirectional.only(top: 7, bottom: 7, end: 2),
                              iconColor: Theme.of(context).primaryColor),
                          CustomTextLabel(
                            jsonKey: sortByLabel,
                            softWrap: true,
                            style: TextStyle(
                              color: ColorsRes.appColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ]),
      body: Stack(
        children: [
          Column(
            children: [
              searchWidget(),
              getSizedBox(
                height: Constant.size5,
              ),
              Expanded(
                child: setRefreshIndicator(
                  refreshCallback: () async {
                    context.read<CartListProvider>().getAllCartItems(context: context);
                    if (context.read<ProductSearchProvider>().searchedTextLength > 0) {
                      context.read<ProductSearchProvider>().offset = 0;
                      context.read<ProductSearchProvider>().products = [];
                    }

                    callApi(isReset: true);
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    child: Consumer<ProductSearchProvider>(
                      builder: (context, productSearchProvider, _) {
                        List<ProductListItem> products = productSearchProvider.products;

                        if (productSearchProvider.productSearchState == ProductSearchState.loading) {
                          return getProductListShimmer(context: context, isGrid: true);
                        } else if (productSearchProvider.productSearchState == ProductSearchState.loaded ||
                            productSearchProvider.productSearchState == ProductSearchState.loadingMore) {
                          return ProductGridViewListingWidget(products: products);
                        } else if (productSearchProvider.productSearchState == ProductSearchState.initial ||
                            context.read<ProductSearchProvider>().searchedTextLength == 0) {
                          return DefaultBlankItemMessageScreen(
                            title: "",
                            description: enterTextToSearchTheProductsLabel,
                            image: "no_search_found_icon",
                          );
                        } else if (productSearchProvider.productSearchState == ProductSearchState.empty) {
                          return DefaultBlankItemMessageScreen(
                            title: emptyProductListMessageLabel,
                            description: emptyProductListDescriptionLabel,
                            image: "no_product_icon",
                          );
                        } else {
                          return NoInternetConnectionScreen(
                              height: context.height * 0.65,
                              message: productSearchProvider.message,
                              callback: () {
                                callApi(isReset: false);
                              });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (context.watch<CartProvider>().totalItemsCount > 0)
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CartOverlay(),
            ),
        ],
      ),
    );
  }

  //Start search widget
  searchWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(
          horizontal: Constant.size10, vertical: Constant.size10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: TextField(
                  autofocus: true,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                  ),
                  controller: edtSearch,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText:
                        getTranslatedValue(context, productSearchHintLabel),
                    hintStyle: TextStyle(
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),
                ),
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.search,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                    onPressed: null,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    if (Platform.isIOS) {
                      // Request microphone permission directly
                      final result = await Permission.microphone.request();
                      if (result.isGranted) {
                        bottomSheetVoiceRecognition();
                      } else if (result.isPermanentlyDenied) {
                        if (!Constant.session.getBoolData(SessionManager
                            .keyPermissionMicrophoneHidePromptPermanently)) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  PermissionHandlerBottomSheet(
                                    titleJsonKey: microphonePermissionTitleLabel,
                                    messageJsonKey:
                                        microphonePermissionMessageLabel,
                                    sessionKeyForAskNeverShowAgain: SessionManager
                                        .keyPermissionMicrophoneHidePromptPermanently,
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            if (value == true) {
                              openAppSettings();
                            }
                          });
                        }
                      } else if (result.isDenied) {
                        // If denied, show a message to enable in settings
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                PermissionHandlerBottomSheet(
                                  titleJsonKey: microphonePermissionTitleLabel,
                                  messageJsonKey:
                                      microphonePermissionMessageLabel,
                                  sessionKeyForAskNeverShowAgain: SessionManager
                                      .keyPermissionMicrophoneHidePromptPermanently,
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          if (value == true) {
                            openAppSettings();
                          }
                        });
                      }
                    } else {
                      await hasMicrophonePermissionGiven().then((value) async {
                        if (value is PermissionStatus) {
                          if (value.isGranted) {
                            bottomSheetVoiceRecognition();
                          } else if (value.isDenied) {
                            await Permission.microphone.request();
                          } else if (value.isPermanentlyDenied) {
                            if (!Constant.session.getBoolData(SessionManager
                                .keyPermissionMicrophoneHidePromptPermanently)) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      PermissionHandlerBottomSheet(
                                        titleJsonKey:
                                            microphonePermissionTitleLabel,
                                        messageJsonKey:
                                            microphonePermissionMessageLabel,
                                        sessionKeyForAskNeverShowAgain:
                                            SessionManager
                                                .keyPermissionMicrophoneHidePromptPermanently,
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) {
                                if (value == true) {
                                  openAppSettings();
                                }
                              });
                            }
                          }
                        }
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: defaultImg(
                      image: AppAssets.voiceSearchIcon,
                      iconColor: ColorsRes.subTitleMainTextColor,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: Constant.size10),
          ChangeNotifierProvider<ProductDetailProvider>(
            create: (context) => ProductDetailProvider(),
            builder: (context, child) {
              return GestureDetector(
                onTap: () async {
                  if (Platform.isIOS) {
                    // Request camera permission directly
                    final result = await Permission.camera.request();
                    if (result.isGranted) {
                      Navigator.pushNamed(context, barCodeScanner)
                          .then((value) {
                        if (value != "-1") {
                          Navigator.pushNamed(
                            context,
                            productDetailScreen,
                            arguments: [
                              value.toString(),
                              getTranslatedValue(
                                  navigatorKey.currentContext!, appNameLabel),
                              null,
                              "barcode",
                            ],
                          );
                        }
                      });
                    } else if (result.isPermanentlyDenied) {
                      if (!Constant.session.getBoolData(SessionManager
                          .keyPermissionCameraHidePromptPermanently)) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                PermissionHandlerBottomSheet(
                                  titleJsonKey: cameraPermissionTitleLabel,
                                  messageJsonKey: cameraPermissionMessageLabel,
                                  sessionKeyForAskNeverShowAgain: SessionManager
                                      .keyPermissionCameraHidePromptPermanently,
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          if (value == true) {
                            openAppSettings();
                          }
                        });
                      }
                    } else if (result.isDenied) {
                      // If denied, show a message to enable in settings
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              PermissionHandlerBottomSheet(
                                titleJsonKey: cameraPermissionTitleLabel,
                                messageJsonKey: cameraPermissionMessageLabel,
                                sessionKeyForAskNeverShowAgain: SessionManager
                                    .keyPermissionCameraHidePromptPermanently,
                              ),
                            ],
                          );
                        },
                      ).then((value) {
                        if (value == true) {
                          openAppSettings();
                        }
                      });
                    }
                  } else {
                    await hasCameraPermissionGiven(context).then((value) async {
                      if (value.isGranted) {
                        Navigator.pushNamed(context, barCodeScanner)
                            .then((value) {
                          if (value != "-1") {
                            Navigator.pushNamed(
                              context,
                              productDetailScreen,
                              arguments: [
                                value.toString(),
                                getTranslatedValue(
                                    navigatorKey.currentContext!, appNameLabel),
                                null,
                                "barcode",
                              ],
                            );
                          }
                        });
                      } else if (value.isDenied) {
                        await Permission.camera.request();
                      } else if (value.isPermanentlyDenied) {
                        if (!Constant.session.getBoolData(SessionManager
                            .keyPermissionCameraHidePromptPermanently)) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  PermissionHandlerBottomSheet(
                                    titleJsonKey: cameraPermissionTitleLabel,
                                    messageJsonKey:
                                        cameraPermissionMessageLabel,
                                    sessionKeyForAskNeverShowAgain: SessionManager
                                        .keyPermissionCameraHidePromptPermanently,
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            if (value == true) {
                              openAppSettings();
                            }
                          });
                        }
                      }
                                        });
                  }
                },
                child: Container(
                  decoration: DesignConfig.boxGradient(10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: defaultImg(
                    image: AppAssets.barcodeScannerIcon,
                    iconColor: ColorsRes.appColorWhite,
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bottomSheetVoiceRecognition() {
    showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true,
        shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
        builder: (context) {
          return ChangeNotifierProvider<VoiceSearchProvider>(
            create: (context) => VoiceSearchProvider(),
            child: SpeechToTextSearch(),
          );
        }).then((value) {
      if (value != null && value.isNotEmpty) {
        edtSearch.text = value;
      }
    });
  }
}
