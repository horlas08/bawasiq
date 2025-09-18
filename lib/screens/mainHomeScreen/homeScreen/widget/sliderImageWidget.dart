import 'package:project/helper/utils/generalImports.dart';

class SliderImageWidget extends StatefulWidget {
  final List<Sliders> sliders;

  const SliderImageWidget({Key? key, required this.sliders}) : super(key: key);

  @override
  State<SliderImageWidget> createState() => _SliderImageWidgetState();
}

class _SliderImageWidgetState extends State<SliderImageWidget> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (mounted) {
          if (context.read<SliderImagesProvider>().currentSliderImageIndex <
              (widget.sliders.length - 1)) {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(
                (context.read<SliderImagesProvider>().currentSliderImageIndex +
                    1));
          } else {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(0);
          }
          _pageController.animateToPage(
            context.read<SliderImagesProvider>().currentSliderImageIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.sliders.length != 0)
        ? Column(
            children: [
              SizedBox(
                height: context.height * 0.28,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.sliders.length,
                  itemBuilder: (context, index) {
                    Sliders sliderData = widget.sliders[index];
                    return Padding(
                      padding: EdgeInsetsDirectional.all(10),
                      child: GestureDetector(
                        onTap: () {
                          callMethod(context
                              .read<SliderImagesProvider>()
                              .currentSliderImageIndex);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: Constant.borderRadius10,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: setNetworkImg(
                              image: sliderData.imageUrl ?? "",
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onPageChanged: (value) {
                    context
                        .read<SliderImagesProvider>()
                        .setSliderCurrentIndexImage(value);
                  },
                ),
              ),
              getSizedBox(
                height: Constant.size2,
              ),
              Consumer<SliderImagesProvider>(
                builder: (context, sliderImagesProvider, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.sliders.length,
                        (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: Constant.size8,
                            width:
                                sliderImagesProvider.currentSliderImageIndex ==
                                        index
                                    ? 20
                                    : 8,
                            margin: EdgeInsets.symmetric(
                                horizontal: Constant.size2),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: sliderImagesProvider
                                            .currentSliderImageIndex ==
                                        index
                                    ? Theme.of(context).primaryColor
                                    : ColorsRes.mainTextColor,
                                shape: BoxShape.rectangle),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : SizedBox.shrink();
  }

  Future<void> callMethod(int index) async {
    {
      if (mounted) {
        if (widget.sliders[index].type == "slider_url") {
          if (await canLaunchUrl(
              Uri.parse(widget.sliders[index].sliderUrl ?? ""))) {
            await launchUrl(Uri.parse(widget.sliders[index].sliderUrl ?? ""),
                mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch ${widget.sliders[index].sliderUrl}';
          }
        } else if (widget.sliders[index].type == "category") {
          /* Navigator.pushNamed(context, productListScreen, arguments: [
            "category",
            widget.sliders[index].typeId.toString(),
            widget.sliders[index].typeName
          ]); */
          if (widget.sliders[index].category!.hasChild!) {
            Navigator.pushNamed(context, categoryListScreen, arguments: [ScrollController(), widget.sliders[index].typeName, widget.sliders[index].typeId.toString()]);
          } else {
            Navigator.pushNamed(context, productListScreen, arguments: ["category", widget.sliders[index].typeId.toString(), widget.sliders[index].typeName]);
          }
        } else if (widget.sliders[index].type == "product") {
          Navigator.pushNamed(context, productDetailScreen, arguments: [
            widget.sliders[index].typeId.toString(),
            widget.sliders[index].typeName,
            null
          ]);
        }
      }
    }
  }
}
