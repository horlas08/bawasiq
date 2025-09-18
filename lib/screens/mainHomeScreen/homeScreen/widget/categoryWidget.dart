import 'package:project/helper/utils/generalImports.dart';


class CategoryWidget extends StatelessWidget {
  final List<CategoryItem>? categories;
  final Color? color;

  CategoryWidget({super.key, this.categories, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      padding: EdgeInsetsDirectional.only(top: 10),
      margin: EdgeInsetsDirectional.only(bottom: 10, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleHeaderWithViewAllOption(
            title: getTranslatedValue(context, shopByCategoriesLabel),
            onTap: () {
              context.read<HomeMainScreenProvider>().selectBottomMenu(1);
            },
          ),
          GridView.builder(
            itemCount: categories?.length,
            padding: EdgeInsets.symmetric(
                horizontal: Constant.size10, vertical: Constant.size10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              CategoryItem category = categories![index];
              return CategoryItemContainer(
                  category: category,
                  voidCallBack: () {
                    if (category.hasChild!) {
                      Navigator.pushNamed(context, categoryListScreen,
                          arguments: [
                            ScrollController(),
                            category.name,
                            category.id.toString()
                          ]);
                    } else {
                      Navigator.pushNamed(context, productListScreen,
                          arguments: [
                            "category",
                            category.id.toString(),
                            category.name
                          ]);
                    }
                  });
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          ),
          getSizedBox(height: 10),
        ],
      ),
    );
  }
}
