import 'package:project/helper/utils/generalImports.dart';

Widget OtherImagesViewWidget(
    BuildContext context, Axis scrollDirection, BoxConstraints constraints) {
  return (context.read<ProductDetailProvider>().productData.images.length > 1)
      ? Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: 10, start: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  width: scrollDirection == Axis.vertical
                      ? (constraints.maxWidth * 0.2 - 20)
                      : constraints.maxWidth,
                  height: scrollDirection == Axis.vertical
                      ? ((constraints.maxWidth * 0.8) - 10)
                      : constraints.maxWidth * 0.20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: scrollDirection,
                    child: scrollDirection == Axis.horizontal
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: OtherImagesList(
                                context, scrollDirection, constraints),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: OtherImagesList(
                                context, scrollDirection, constraints),
                          ),
                  ),
                ),
              ),
            ),
            if (scrollDirection == Axis.vertical)
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: Container(
                  width: constraints.maxWidth * 0.15,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: (scrollDirection == Axis.vertical)
                        ? LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withValues(alpha:0.5),
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withValues(alpha:0),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            PositionedDirectional(
              top: 10,
              start: 0,
              end: 0,
              child: Container(
                width: constraints.maxWidth * 0.15,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: (scrollDirection == Axis.vertical)
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha:0.5),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha:0),
                          ],
                        )
                      : null,
                ),
              ),
            ),
          ],
        )
      : SizedBox.shrink();
}

List<Widget> OtherImagesList(
    BuildContext context, Axis scrollDirection, BoxConstraints constraints) {
  return List.generate(
    context.read<ProductDetailProvider>().productData.images.length + 1,
    (index) {
      return GestureDetector(
        onTap: () {
          context.read<ProductDetailProvider>().setCurrentImageIndex(index);
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(
            end: scrollDirection == Axis.horizontal ? 10 : 0,
            bottom: scrollDirection == Axis.vertical ? 10 : 0,
            start: (index == 0 && scrollDirection == Axis.horizontal) ? 10 : 0,
            top: (index == 0 && scrollDirection == Axis.vertical) ? 10 : 0,
          ),
          decoration: getOtherImagesBoxDecoration(
            isActive:
                context.read<ProductDetailProvider>().currentImage == index,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: setNetworkImg(
              height: constraints.maxWidth * 0.15,
              width: constraints.maxWidth * 0.15,
              image: context.read<ProductDetailProvider>().images[index],
              boxFit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
