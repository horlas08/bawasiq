import 'package:project/helper/utils/generalImports.dart';


class AddressListScreen extends StatefulWidget {
  final String? from;

  const AddressListScreen({Key? key, this.from = ""}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<AddressProvider>().hasMoreData) {
          context.read<AddressProvider>().getAddressProvider(context: context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //fetch cartList from api
    Future.delayed(Duration.zero).then((value) async {
      await context
          .read<AddressProvider>()
          .getAddressProvider(context: context);

      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          if (widget.from == "checkout" &&
              context.read<AddressProvider>().addresses.isEmpty) {
            Navigator.pop(context, null);
          } else if (widget.from == "checkout" &&
              context.read<AddressProvider>().addresses.length == 1) {
            Navigator.pop(
                context, context.read<AddressProvider>().addresses[0]);
          } else if (widget.from == "quick_widget") {
            Navigator.pop(context);
          } else {
            Navigator.pop(context, "");
          }
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: addressLabel,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          onTap: () {
            if (widget.from == "checkout" &&
                context.read<AddressProvider>().addresses.isEmpty) {
              Navigator.pop(context, null);
            } else if (widget.from == "checkout" &&
                context.read<AddressProvider>().addresses.length == 1) {
              Navigator.pop(
                  context, context.read<AddressProvider>().addresses[0]);
            } else if (widget.from == "quick_widget") {
              Navigator.pop(context);
            } else {
              try {
                Navigator.pop(
                    context, context.read<CheckoutProvider>().selectedAddress);
              } catch (e) {
                Navigator.pop(
                    context, context.read<AddressProvider>().addresses[0]);
              }
            }
          },
        ),
        body: Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            return Stack(
              children: [
                setRefreshIndicator(
                    refreshCallback: () async {
                      context
                          .read<CartListProvider>()
                          .getAllCartItems(context: context);
                      context.read<AddressProvider>().offset = 0;
                      context.read<AddressProvider>().addresses = [];
                      await context
                          .read<AddressProvider>()
                          .getAddressProvider(context: context);
                    },
                    child: Column(
                      children: [
                        Expanded(
                            child: (addressProvider.addressState ==
                                        AddressState.loaded ||
                                    addressProvider.addressState ==
                                        AddressState.editing)
                                ? ListView(
                                    controller: scrollController,
                                    children: [
                                      Column(
                                        children: List.generate(
                                            addressProvider.addresses.length,
                                            (index) {
                                          UserAddressData address =
                                              addressProvider.addresses[index];
                                          return GestureDetector(
                                            onTap: () {
                                              if (widget.from == "checkout") {
                                                Navigator.pop(context, address);
                                              } else {
                                                addressProvider
                                                    .setSelectedAddress(
                                                        int.parse(address.id
                                                            .toString()));
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  EdgeInsetsDirectional.all(10),
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      start: 10,
                                                      end: 10,
                                                      top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    addressProvider.selectedAddressId ==
                                                            int.parse(address.id
                                                                .toString())
                                                        ? Icons
                                                            .radio_button_on_outlined
                                                        : Icons
                                                            .radio_button_off_rounded,
                                                    color: addressProvider
                                                                .selectedAddressId ==
                                                            int.parse(address.id
                                                                .toString())
                                                        ? ColorsRes.appColor
                                                        : ColorsRes.grey,
                                                  ),
                                                  getSizedBox(
                                                    width: Constant.size5,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CustomTextLabel(
                                                              text: address
                                                                      .name ??
                                                                  "",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    addressDetailScreen,
                                                                    arguments: [
                                                                      address,
                                                                      context
                                                                    ]);
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration:
                                                                    DesignConfig
                                                                        .boxGradient(
                                                                            5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                margin:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child:
                                                                    defaultImg(
                                                                  image:
                                                                      AppAssets.editIcon,
                                                                  iconColor:
                                                                      ColorsRes
                                                                          .mainIconColor,
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        getSizedBox(
                                                          height:
                                                              Constant.size7,
                                                        ),
                                                        CustomTextLabel(
                                                          text:
                                                              "${address.area},${address.landmark}, ${address.address}, ${address.state}, ${address.city}, ${address.country} - ${address.pincode} ",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              /*fontSize: 18,*/
                                                              color: ColorsRes
                                                                  .subTitleMainTextColor),
                                                        ),
                                                        getSizedBox(
                                                          height:
                                                              Constant.size7,
                                                        ),
                                                        CustomTextLabel(
                                                          text:
                                                              address.mobile ??
                                                                  "",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              /*fontSize: 18,*/
                                                              color: ColorsRes
                                                                  .subTitleMainTextColor),
                                                        ),
                                                        getSizedBox(
                                                          height:
                                                              Constant.size7,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    AddressProvider>()
                                                                .deleteAddress(
                                                                    address:
                                                                        address,
                                                                    context:
                                                                        context);
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        Constant
                                                                            .size5,
                                                                    horizontal:
                                                                        Constant
                                                                            .size7),
                                                            decoration:
                                                                DesignConfig
                                                                    .boxDecoration(
                                                              ColorsRes
                                                                  .appColorRed,
                                                              5,
                                                              isboarder: false,
                                                            ),
                                                            child:
                                                                CustomTextLabel(
                                                                    text:
                                                                        getTranslatedValue(
                                                                      context,
                                                                      deleteAddressLabel,
                                                                    ),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelSmall
                                                                        ?.copyWith(
                                                                            color:
                                                                                ColorsRes.appColorWhite)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                      if (addressProvider.addressState ==
                                          AddressState.loadingMore)
                                        getAddressShimmer(),
                                    ],
                                  )
                                : addressProvider.addressState ==
                                        AddressState.loading
                                    ? getAddressListShimmer()
                                    : addressProvider.addressState ==
                                            AddressState.error
                                        ? DefaultBlankItemMessageScreen(
                                            image: "no_address_icon",
                                            title: noAddressFoundTitleLabel,
                                            description:
                                                noAddressFoundDescriptionLabel,
                                          )
                                        : const SizedBox.shrink()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constant.size10,
                              vertical: Constant.size10),
                          child: gradientBtnWidget(
                            context,
                            10,
                            callback: () {
                              Navigator.pushNamed(context, addressDetailScreen,
                                  arguments: [null, context]);
                            },
                            title: getTranslatedValue(
                              context,
                              addNewAddressLabel,
                            ),
                          ),
                        ),
                      ],
                    )),
                if (addressProvider.addressState == AddressState.editing)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: Container(
                        color: ColorsRes.appColorBlack.withValues(alpha: 0.2),
                        child:
                            const Center(child: CircularProgressIndicator())),
                  )
              ],
            );
          },
        ),
      ));
  }

  getAddressShimmer() {
    return CustomShimmer(
      borderRadius: Constant.size10,
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.all(Constant.size5),
    );
  }

  getAddressListShimmer() {
    return ListView(
      children: List.generate(10, (index) => getAddressShimmer()),
    );
  }
}