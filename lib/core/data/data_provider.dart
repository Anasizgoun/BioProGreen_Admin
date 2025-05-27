import 'dart:convert';

import '../../models/api_response.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/prod.dart';
import '../../models/sub_category.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';


class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;

  DataProvider() {
    getAllProduct();
    getAllCategory();
    getAllPosters();
    getAllOrders();
    getAllNotifications();
    getAllOrders();
  }




  //TODO: should complete getAllProduct
  Future <void> getAllProduct({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');
      ApiResponse<List<Product>> apiResponse = ApiResponse<List<Product>>.fromJson(
        response.body,
            (json) => (json as List).map((item) => Product.fromJson(item)).toList(),
      );
      _allProducts = apiResponse.data ?? [];
      _filteredProducts = List.from(_allProducts);
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    } catch (e) {
      rethrow;
      if (showSnack) SnackBarHelper.showErrorSnackBar((e.toString()));
    }
  }


  //getAllCategory
Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try{
      Response response = await service.getItems(endpointUrl: 'categories');
      if(response.isOk) {
        ApiResponse<List<Category>> apiResponse = ApiResponse<List<Category>>.fromJson(
          response.body,
            (json) => (json as List).map((item) =>Category.fromJson(item)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
}

  //TODO: should complete filterProducts
  void filterProducts(String keyword){
    if (keyword.isEmpty){
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        return (product.name ?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyword = product.proSubCategoryId?.name?.toLowerCase().contains(lowerKeyword) ?? false;
        // final subCategoryNameContainsKeyword = product.proSubCategoryId?name?.toLowerCase().contains(lowerKeyword) ?? false;
        // return productNameContainsKeyword ; // subCategoryNameContainsKeyword || subCategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  void filteredCategories(String keyword){
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();

  }



//TODO: should complete getAllSubCategory


  //TODO: should complete filterSubCategories


  //TODO: should complete getAllBrands


  //TODO: should complete filterBrands


  //TODO: should complete getAllVariantType


  //TODO: should complete filterVariantTypes



  //TODO: should complete getAllVariant


  //TODO: should complete filterVariants





  //TODO: should complete getAllCoupons


  //TODO: should complete filterCoupons


  //TODO: should complete getAllPosters
  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse = ApiResponse<List<Poster>>.fromJson(
          response.body,
            (json) => (json as List).map((item) => Poster.fromJson(item)).toList(),
    );
    _allPosters = apiResponse.data ?? [];
    _filteredPosters = List.from(_allPosters);
    notifyListeners();
    if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    }
    } catch (e) {
    if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
    rethrow;
    }
    return _filteredPosters;
  }

  // filterPosters
  void filterPosters(String keyword){
    if (keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();

  }





  // getAllNotifications
  Future<List<MyNotification>> getAllNotifications({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'notification/all-notification');
      if (response.isOk) {
        ApiResponse<List<MyNotification>> apiResponse = ApiResponse<List<MyNotification>>.fromJson(
          response.body, (json) => (json as List).map((item) => MyNotification.fromJson(item)).toList(),
        );
      _allNotifications = apiResponse.data ?? [];
      _filteredNotifications = List.from(_allNotifications);
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
    }
    } catch (e) {
    if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
    rethrow;
    }
    return _filteredNotifications;
  }

// filterNotifications
  void filterNotifications(String keyword) {
    if (keyword.isEmpty) {
      _filteredNotifications = List.from(_allNotifications);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredNotifications = _allNotifications.where((notification) {
        return (notification.title ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }


// getAllOrders
  Future<List<Order>> getAllOrders({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'orders');
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse = ApiResponse<
            List<Order>>.fromJson(
          response.body,
              (json) =>
              (json as List).map((item) => Order.fromJson(item)).toList(),
        );
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch(e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredOrders;
  }


// filterOrders
  void filterOrders(String keyword){
    if (keyword.isEmpty) {
      _filteredOrders = List.from(_allOrders);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredOrders = _allOrders.where((order) {
        bool nameMatches = (order.userID?.name ?? '').toLowerCase().contains(lowerKeyword);
        bool statusMatches = (order.orderStatus ?? '').toLowerCase().contains(lowerKeyword);
        return nameMatches || statusMatches;
      }).toList();
    }
    notifyListeners();
  }




//  calculateOrdersWithStatus
int calculateOrdersWithStatus({String? status}) {
    int totalOrders = 0;

    if (status == null) {
      totalOrders = _allOrders.length;
    } else {
      for (Order order in _allOrders) {
        if (order.orderStatus == status) {
          totalOrders += 1;
        }
      }
     }
    return totalOrders;
}

  // filterProductsByQuantity
  void filterProductsByQuantity(String productQntType) {
    if (productQntType == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQntType == 'Out of Stock') {
      _filteredProducts = _allProducts.where((product) => product.quantity == 0).toList();
    } else if (productQntType == 'Limited Stock') {
      _filteredProducts = _allProducts.where((product) => product.quantity == 1).toList();
    } else if (productQntType == 'Other Stock') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity != 0 && product.quantity != 1;
      }).toList();
    }
    notifyListeners();
  }


  // calculateProductWithQuantity
int calculateProductWithQuantity({int? quantity}) {
    int totalProduct = 0;
    //? if targetQuantity is null it return total product
  if  (quantity == null) {
    totalProduct = _allProducts.length;
  } else {
    for (Product product in _allProducts){
      if (product.quantity != null && product.quantity == quantity) {
        totalProduct += 1;
      }
    }
  }
    return totalProduct;
}

}
