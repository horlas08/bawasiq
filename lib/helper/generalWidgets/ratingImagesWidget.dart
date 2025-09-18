import 'package:project/helper/utils/generalImports.dart';

class RatingImagesWidget extends StatelessWidget {
  final List<String> images;
  final String from;
  final String productId;
  final int totalImages;

  const RatingImagesWidget(
      {super.key,
      required this.images,
      required this.from,
      required this.productId,
      required this.totalImages});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        runSpacing: 5,
        spacing: constraints.maxWidth * 0.01,
        children: List.generate(
          images.length,
          (index) {
            if (images.isEmpty) {
              return SizedBox.shrink();
            } else if (totalImages > 5 &&
                images.length == index + 1 &&
                from == "productDetails") {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ratingImageViewScreen,
                    arguments: productId,
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.192,
                      height: constraints.maxWidth * 0.192,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: Constant.borderRadius10,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: setNetworkImg(
                            image: images[index].toString(),
                            width: constraints.maxWidth * 0.192,
                            height: constraints.maxWidth * 0.192,
                            boxFit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      top: 0,
                      end: 0,
                      start: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsRes.appColorBlack.withValues(alpha:0.6),
                          borderRadius: Constant.borderRadius10,
                        ),
                        width: constraints.maxWidth * 0.192,
                        height: constraints.maxWidth * 0.192,
                        child: Center(
                            child: CustomTextLabel(
                          text: "+${(totalImages.toInt() - 5)}",
                          style: TextStyle(
                            color: ColorsRes.appColorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxWidth * 0.045,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    fullScreenProductImageScreen,
                    arguments: [index, images],
                  );
                },
                child: Container(
                  width: constraints.maxWidth * 0.192,
                  height: constraints.maxWidth * 0.192,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: Constant.borderRadius10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: setNetworkImg(
                        image: images[index].toString(),
                        width: constraints.maxWidth * 0.192,
                        height: constraints.maxWidth * 0.192,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
