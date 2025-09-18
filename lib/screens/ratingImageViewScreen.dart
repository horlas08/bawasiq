import 'package:project/helper/utils/generalImports.dart';


class RatingImageViewScreen extends StatefulWidget {
  final String productId;

  const RatingImageViewScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<RatingImageViewScreen> createState() => _RatingImageScreenState();
}

class _RatingImageScreenState extends State<RatingImageViewScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //fetch RatingImage from api
    Future.delayed(Duration.zero).then((value) {
      context.read<RatingListProvider>().getRatingImagesApiProvider(
          params: {ApiAndParams.productId: widget.productId.toString()},
          context: context);
    });
    scrollController.addListener(scrollListener);
  }

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<RatingListProvider>().hasMoreImages) {
          return context.read<RatingListProvider>().getRatingImagesApiProvider(
              params: {ApiAndParams.productId: widget.productId.toString()},
              context: context);
        }
      }
    }
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
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: customerPhotosLabel,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: setRefreshIndicator(
        refreshCallback: () async {
          context.read<CartListProvider>().getAllCartItems(context: context);
          context.read<RatingListProvider>().images.clear();
          context.read<RatingListProvider>().offset = 1;

          context.read<RatingListProvider>().getRatingImagesApiProvider(
              params: {ApiAndParams.productId: widget.productId.toString()},
              context: context);
        },
        child: ratingImageListWidget(),
      ),
    );
  }

//RatingImage ui
  Widget ratingImageListWidget() {
    return Consumer<RatingListProvider>(
      builder: (context, ratingListProvider, _) {
        if (ratingListProvider.ratingImagesState == RatingImagesState.loaded ||
            ratingListProvider.ratingImagesState ==
                RatingImagesState.loadingMore) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  itemCount: ratingListProvider.images.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.size10, vertical: Constant.size10),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    String image = ratingListProvider.images[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          fullScreenProductImageScreen,
                          arguments: [index, ratingListProvider.images],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: setNetworkImg(
                          image: image,
                          boxFit: BoxFit.cover,
                          width: context.width,
                          height: context.height,
                        ),
                      ),
                    );
                  },
                  addAutomaticKeepAlives: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
              if (ratingListProvider.ratingImagesState ==
                  RatingImagesState.loadingMore)
                getRatingPhotosShimmer(context: context, count: 3),
            ],
          );
        } else if (ratingListProvider.ratingImagesState ==
            RatingImagesState.loading) {
          return getRatingPhotosShimmer(context: context, count: 21);
        } else {
          return NoInternetConnectionScreen(
            height: context.height * 0.65,
            message: ratingListProvider.message,
            callback: () {
              context.read<RatingListProvider>().getRatingImagesApiProvider(
                  params: {ApiAndParams.productId: widget.productId.toString()},
                  context: context);
            },
          );
        }
      },
    );
  }
}
