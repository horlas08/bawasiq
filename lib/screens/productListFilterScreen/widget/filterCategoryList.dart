import 'package:flutter/cupertino.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/productListFilterScreen/widget/filterSubCategoryList.dart';

final GlobalKey<NavigatorState> categoryNavigatorKey =
    GlobalKey<NavigatorState>();
const String subCategoryRouteName = 'subcategory';

class FilterCategoryList extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;

  const FilterCategoryList({
    Key? key,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  @override
  State<FilterCategoryList> createState() => _FilterCategoryListState();
}

class _FilterCategoryListState extends State<FilterCategoryList> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

    // _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<CategoryListProvider>().hasMoreData) {
          callApi(false);
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) async {
      await callApi(true);
    });
  }

  callApi(bool isReset) {
    if (isReset == true) {
      context.read<CategoryListProvider>().offset = 0;
      context.read<CategoryListProvider>().categories.clear();
    }
    return context
        .read<CategoryListProvider>()
        .getCategoryApiProvider(context: context, params: {
      ApiAndParams.categoryId:
          widget.categoryId == null ? "0" : widget.categoryId.toString()
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: categoryNavigatorKey,
      onGenerateRoute: (settings) {
        if (settings.name == subCategoryRouteName) {
          return CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => CategoryListProvider(),
              child: FilterSubCategoryList.getRouteInstance(settings),
            ),
          );
        }
        return PageRouteBuilder(
          pageBuilder: (context, _, __) {
            return categoryWidget();
          },
        );
      },
    );
    // child:
  }

// categoryList ui
  Widget categoryWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          if (widget.categoryName != null)
            Container(
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      categoryNavigatorKey.currentState?.pop();
                    },
                    child: Container(
                      color: ColorsRes.appColorTransparent,
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: SizedBox(
                          child: defaultImg(
                            boxFit: BoxFit.contain,
                            image: AppAssets.icArrowBackIcon,
                            iconColor: ColorsRes.mainTextColor,
                          ),
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomTextLabel(
                      text: widget.categoryName,
                    ),
                  )
                ],
              ),
            ),
          Expanded(
            child: Consumer<ProductFilterProvider>(
                builder: (context, productFilterProvider, child) {
              return Consumer<CategoryListProvider>(
                builder: (context, categoryListProvider, _) {
                  if (categoryListProvider.categoryState ==
                          CategoryState.loaded ||
                      categoryListProvider.categoryState ==
                          CategoryState.loadingMore) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: categoryListProvider.categories.length,
                      itemBuilder: (context, index) {
                        CategoryItem category =
                            categoryListProvider.categories[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (category.hasChild == false) {
                                  productFilterProvider.addRemoveCategories(
                                      category.id.toString());
                                } else {
                                  categoryNavigatorKey.currentState?.push(
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (context) {
                                            return CategoryListProvider();
                                          },
                                          child: FilterSubCategoryList(
                                            categoryName:
                                                category.name.toString(),
                                            categoryId: category.id.toString(),
                                          ),
                                        );
                                      },
                                    ),
                                  );

                                  ChangeNotifierProvider(
                                    create: (context) {
                                      return CategoryListProvider();
                                    },
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, end: 10, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: productFilterProvider
                                              .selectedCategories
                                              .contains(
                                                  category.id.toString()) ==
                                          true
                                      ? ColorsRes.appColorLightHalfTransparent
                                      : Theme.of(context).cardColor,
                                ),
                                child: Row(
                                  children: [
                                    getSizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextLabel(
                                        text: category.name,
                                        style: TextStyle(
                                            color: ColorsRes.mainTextColor,
                                            fontSize: 16),
                                      ),
                                    ),
                                    if (category.hasChild == false &&
                                        productFilterProvider.selectedCategories
                                            .contains(category.id.toString()))
                                      Icon(
                                        Icons.check_rounded,
                                        size: 19,
                                        color: ColorsRes.appColor,
                                      ),
                                    if (category.hasChild == true)
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 17,
                                        color: ColorsRes.mainTextColor,
                                      ),
                                    getSizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            getDivider(height: 0),
                          ],
                        );
                      },
                    );
                  } else if (categoryListProvider.categoryState ==
                      CategoryState.loading) {
                    return getCategoryShimmer();
                  } else {
                    return NoInternetConnectionScreen(
                      height: context.height * 0.65,
                      message: categoryListProvider.message,
                      callback: () {
                        callApi(true);
                      },
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget getCategoryShimmer() {
    return ListView(
      children: List.generate(
        10,
        (index) => CustomShimmer(
          height: 30,
          width: context.width,
          margin: EdgeInsets.only(top: 5, bottom: 5),
        ),
      ),
    );
  }
}
