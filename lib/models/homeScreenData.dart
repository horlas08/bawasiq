import 'package:project/helper/utils/generalImports.dart';

class Shop {
  String? status;
  String? message;
  String? total;
  HomeScreenData? data;

  Shop({this.status, this.message, this.total, this.data});

  Shop.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data =
        json['data'] != null ? new HomeScreenData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeScreenData {
  List<Sliders>? sliders;
  List<OfferImages>? offers;
  List<Sections>? sections;
  String? isCategorySectionInHomepage;
  String? isBrandSectionInHomepage;
  String? isSellerSectionInHomepage;
  String? isCountrySectionInHomepage;
  List<CategoryItem>? categories;
  List<BrandItem>? brands;
  List<SellerItem>? sellers;
  List<CountryItem>? countries;

  HomeScreenData(
      {this.sliders,
      this.offers,
      this.sections,
      this.isCategorySectionInHomepage,
      this.isBrandSectionInHomepage,
      this.isSellerSectionInHomepage,
      this.isCountrySectionInHomepage,
      this.categories,
      this.brands,
      this.sellers,
      this.countries});

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <OfferImages>[];
      json['offers'].forEach((v) {
        offers!.add(new OfferImages.fromJson(v));
      });
    }
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(new Sections.fromJson(v));
      });
    }
    isCategorySectionInHomepage =
        json['is_category_section_in_homepage'].toString();
    isBrandSectionInHomepage = json['is_brand_section_in_homepage'].toString();
    isSellerSectionInHomepage =
        json['is_seller_section_in_homepage'].toString();
    isCountrySectionInHomepage =
        json['is_country_section_in_homepage'].toString();
    if (json['categories'] != null) {
      categories = <CategoryItem>[];
      json['categories'].forEach((v) {
        categories!.add(new CategoryItem.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <BrandItem>[];
      json['brands'].forEach((v) {
        brands!.add(new BrandItem.fromJson(v));
      });
    }
    if (json['sellers'] != null) {
      sellers = <SellerItem>[];
      json['sellers'].forEach((v) {
        sellers!.add(new SellerItem.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      countries = <CountryItem>[];
      json['countries'].forEach((v) {
        countries!.add(new CountryItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    data['is_category_section_in_homepage'] = this.isCategorySectionInHomepage;
    data['is_brand_section_in_homepage'] = this.isBrandSectionInHomepage;
    data['is_seller_section_in_homepage'] = this.isSellerSectionInHomepage;
    data['is_country_section_in_homepage'] = this.isCountrySectionInHomepage;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.sellers != null) {
      data['sellers'] = this.sellers!.map((v) => v.toJson()).toList();
    }
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  String? id;
  String? type;
  String? typeId;
  String? sliderUrl;
  String? typeName;
  String? imageUrl;
  CategoryItem? category;

  Sliders(
      {this.id,
      this.type,
      this.typeId,
      this.sliderUrl,
      this.typeName,
      this.imageUrl,
      this.category});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    typeId = json['type_id'].toString();
    sliderUrl = json['slider_url'].toString();
    typeName = json['type_name'].toString();
    imageUrl = json['image_url'].toString();
    category = json['category_data'] != null? CategoryItem.fromJson(json['category_data']): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    data['slider_url'] = this.sliderUrl;
    data['type_name'] = this.typeName;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class OfferImages {
  String? id;
  String? position;
  String? sectionPosition;
  String? type;
  String? typeId;
  String? offerUrl;
  String? imageUrl;
  String? typeName;
  String? sectionTitle;
  String? section;
  CategoryItem? category;

  OfferImages(
      {this.id,
      this.position,
      this.sectionPosition,
      this.type,
      this.typeId,
      this.offerUrl,
      this.imageUrl,
      this.typeName,
      this.sectionTitle,
      this.section,
      this.category});

  OfferImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    position = json['position'].toString();
    sectionPosition = json['section_position'].toString();
    type = json['type'].toString();
    typeId = json['type_id'].toString();
    offerUrl = json['offer_url'].toString();
    imageUrl = json['image_url'].toString();
    typeName = json['type_name'].toString();
    sectionTitle = json['section_title'].toString();
    section = json['section'].toString();
    category = json['category'] != null? CategoryItem.fromJson(json['category']): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['section_position'] = this.sectionPosition;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    data['offer_url'] = this.offerUrl;
    data['image_url'] = this.imageUrl;
    data['type_name'] = this.typeName;
    data['section_title'] = this.sectionTitle;
    data['section'] = this.section;
    return data;
  }
}

class CategoryItem {
  String? id;
  String? name;
  String? imageUrl;
  bool? hasChild;
  bool? hasActiveChild;

  CategoryItem({
    this.id,
    this.name,
    this.imageUrl,
    this.hasChild,
  });

  CategoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    imageUrl = json['image_url'].toString();
    hasChild = json['has_child'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['has_child'] = this.hasChild;
    return data;
  }
}

class Sections {
  String? id;
  String? title;
  String? shortDescription;
  String? productType;
  String? position;
  String? styleApp;
  String? styleWeb;
  String? backgroundColorForLightTheme;
  String? backgroundColorForDarkTheme;
  String? bannerApp;
  String? bannerWeb;
  List<ProductListItem>? products;

  Sections({
    this.id,
    this.title,
    this.shortDescription,
    this.productType,
    this.position,
    this.styleApp,
    this.styleWeb,
    this.backgroundColorForLightTheme,
    this.backgroundColorForDarkTheme,
    this.bannerApp,
    this.bannerWeb,
  });

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    shortDescription = json['short_description'].toString();
    productType = json['product_type'].toString();
    position = json['position'].toString();
    styleApp = json['style_app'].toString();
    styleWeb = json['style_web'].toString();
    backgroundColorForLightTheme = json['background_color_for_light_theme'].toString();
    backgroundColorForDarkTheme = json['background_color_for_dark_theme'].toString();
    bannerApp = json['banner_app'].toString();
    bannerWeb = json['banner_web'].toString();
    if (json['products'] != null) {
      products = <ProductListItem>[];
      json['products'].forEach((v) {
        products!.add(new ProductListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['product_type'] = this.productType;
    data['position'] = this.position;
    data['style_app'] = this.styleApp;
    data['style_web'] = this.styleWeb;
    data['background_color_for_light_theme'] =
        this.backgroundColorForLightTheme;
    data['background_color_for_dark_theme'] = this.backgroundColorForDarkTheme;
    data['banner_app'] = this.bannerApp;
    data['banner_web'] = this.bannerWeb;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandItem {
  String? id;
  String? name;
  String? imageUrl;

  BrandItem({this.id, this.name, this.imageUrl});

  BrandItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class SellerItem {
  String? id;
  String? name;
  String? storeName;
  String? distance;
  String? maxDeliverableDistance;
  String? logoUrl;

  SellerItem({
    this.id,
    this.name,
    this.storeName,
    this.distance,
    this.maxDeliverableDistance,
    this.logoUrl,
  });

  SellerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    storeName = json['store_name'].toString();
    distance = json['distance'].toString();
    maxDeliverableDistance = json['max_deliverable_distance'].toString();
    logoUrl = json['logo_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['store_name'] = this.storeName;
    data['distance'] = this.distance;
    data['max_deliverable_distance'] = this.maxDeliverableDistance;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}

class CountryItem {
  String? id;
  String? name;
  String? dialCode;
  String? code;
  String? logo;

  CountryItem({this.id, this.name, this.dialCode, this.code, this.logo});

  CountryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    dialCode = json['dial_code'].toString();
    code = json['code'].toString();
    logo = json['logo'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['code'] = this.code;
    data['logo'] = this.logo;
    return data;
  }
}
