import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../models/prod.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../../models/sub_category.dart';


class DashBoardProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addProductFormKey = GlobalKey<FormState>();

  //?text editing controllers in dashBoard screen
  TextEditingController prodNameCtrl = TextEditingController();
  TextEditingController prodDescCtrl = TextEditingController();
  TextEditingController prodQntCtrl = TextEditingController();
  TextEditingController prodPriceCtrl = TextEditingController();
  TextEditingController prodOffPriceCtrl = TextEditingController();

  //? dropdown value
  Category? selectedCategory;
  SubCategory? selectedSubCategory;

  Product? selectedProd;


  Product? productForUpdate;
  File? selectedMainImage, selectedSecondImage, selectedThirdImage;
  XFile? mainImgXFile, secondImgXFile, thirdImgXFile;

  List<SubCategory> subCategoriesByCategory = [];


  DashBoardProvider(this._dataProvider);

  //TODO: should complete addProduct
  addProduct() async {
    try {
      if (selectedMainImage == null) {
        SnackBarHelper.showErrorSnackBar('Please choose an image');
        return;
      }

      Map<String, dynamic> formDataMap = {
        'name': prodNameCtrl.text,
        'description': prodDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'price': prodPriceCtrl.text,
        'offerPrice': prodOffPriceCtrl.text.isEmpty ? prodPriceCtrl.text : prodOffPriceCtrl.text,
        'quantity': prodQntCtrl.text,

      };
      final FormData form = await createFormDataForMultipleImage(imgXFiles: [
        {'image1': mainImgXFile},
        {'image2': secondImgXFile},
        {'image3': thirdImgXFile},
      ], formData: formDataMap);
      if (productForUpdate != null) {}
        final response = await service.addItem(endpointUrl: 'products', itemData: form);
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllProduct();
            log('Product added');
            clearFields();
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to add Product: ${apiResponse.message}');
          }
          } else {
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body?['message'] ?? response.statusText}');
        }

    }catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred $e');
      rethrow;
    }
  }


  //TODO: should complete updateProduct
  updateProduct() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': prodNameCtrl.text,
        'description': prodDescCtrl.text,
        'proCategoryId': selectedCategory?.sId ?? '',
        'price': prodPriceCtrl.text,
        'offerPrice': prodOffPriceCtrl.text.isEmpty ? prodPriceCtrl.text : prodOffPriceCtrl.text,
        'quantity': prodQntCtrl.text,
      };
      final FormData form = await createFormDataForMultipleImage(imgXFiles: [
        {'image1': mainImgXFile},
        {'image2': secondImgXFile},
        {'image3': thirdImgXFile},
      ], formData: formDataMap);
      if (productForUpdate != null) {}
      final response =
      await service.updateItem(endpointUrl: 'products', itemId: '${productForUpdate?.sId}', itemData: form);
        if(response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllProduct();
          log('Product added');
          clearFields();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Product: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }

    }catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred $e');
      rethrow;
    }
  }

  //TODO: should complete submitProduct
  submitProduct() {
    if (productForUpdate != null ){
      updateProduct();
    } else {
      addProduct();
    }
  }


  //TODO: should complete deleteProduct
  deleteProduct(Product product) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'products', itemId: product.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category deleted successfully');
          _dataProvider.getAllCategory();
        }
      }else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message']?? response.statusText}');
      }
    }catch (e){
      print(e);
      rethrow;
    }
  }


  void pickImage({required int imageCardNumber}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (imageCardNumber == 1) {
        selectedMainImage = File(image.path);
        mainImgXFile = image;
      } else if (imageCardNumber == 2) {
        selectedSecondImage = File(image.path);
        secondImgXFile = image;
      } else if (imageCardNumber == 3) {
        selectedThirdImage = File(image.path);
        thirdImgXFile = image;
      }
      notifyListeners();
    }
  }

  Future<FormData> createFormDataForMultipleImage({
    required List<Map<String, XFile?>>? imgXFiles,
    required Map<String, dynamic> formData,
  }) async {
    // Loop over the provided image files and add them to the form data
    if (imgXFiles != null) {
      for (int i = 0; i < imgXFiles.length; i++) {
        XFile? imgXFile = imgXFiles[i]['image' + (i + 1).toString()];
        if (imgXFile != null) {
          // Check if it's running on the web
          if (kIsWeb) {
            String fileName = imgXFile.name;
            Uint8List byteImg = await imgXFile.readAsBytes();
            formData['image' + (i + 1).toString()] = MultipartFile(byteImg, filename: fileName);
          } else {
            String filePath = imgXFile.path;
            String fileName = filePath.split('/').last;
            formData['image' + (i + 1).toString()] = await MultipartFile(filePath, filename: fileName);
          }
        }
      }
    }

    // Create and return the FormData object
    final FormData form = FormData(formData);
    return form;
  }


filterSubcategory(Category category){
    selectedSubCategory = null;
    selectedCategory = category;
    subCategoriesByCategory.clear();
    final newList = _dataProvider.subCategories.where((subcategory) => subcategory.categoryId?.sId == category.sId).toList();
    subCategoriesByCategory = newList;
    notifyListeners();
}
  //TODO: should complete filterBrand

  //TODO: should complete filterVariant



  setDataForUpdateProduct(Product? product) {
    if (product != null) {
      productForUpdate = product;

      prodNameCtrl.text = product.name ?? '';
      prodDescCtrl.text = product.description ?? '';
      prodPriceCtrl.text = product.price.toString();
      prodOffPriceCtrl.text = '${product.offerPrice}';
      prodQntCtrl.text = '${product.quantity}';

      selectedCategory = _dataProvider.categories.firstWhereOrNull((element) => element.sId == product.proCategoryId?.sId);


      final newListCategory = _dataProvider.subCategories
          .where((subcategory) => subcategory.categoryId?.sId == product.proCategoryId?.sId)
          .toList();
      subCategoriesByCategory = newListCategory;
      selectedSubCategory =
          _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == product.proSubCategoryId?.sId);

      // final newListBrand =
      // _dataProvider.brands.where((brand) => brand.subcategoryId?.sId == product.proSubCategoryId?.sId).toList();
      // brandsBySubCategory = newListBrand;
      // selectedBrand = _dataProvider.brands.firstWhereOrNull((element) => element.sId == product.proBrandId?.sId);
      //
      // selectedVariantType =
      //     _dataProvider.variantTypes.firstWhereOrNull((element) => element.sId == product.proVariantTypeId?.sId);
      //
      // final newListVariant = _dataProvider.variants
      //     .where((variant) => variant.variantTypeId?.sId == product.proVariantTypeId?.sId)
      //     .toList();
      // final List<String> variantNames = newListVariant.map((variant) => variant.name ?? '').toList();
      // variantsByVariantType = variantNames;
      // selectedVariants = product.proVariantId ?? [];

    } else {
      clearFields();
    }
  }

  clearFields() {
    prodNameCtrl.clear();
    prodDescCtrl.clear();
    prodPriceCtrl.clear();
    prodOffPriceCtrl.clear();
    prodQntCtrl.clear();

    selectedMainImage = null;
    selectedSecondImage = null;
    selectedThirdImage = null;


    mainImgXFile = null;
    secondImgXFile = null;
    thirdImgXFile = null;


    selectedCategory = null;
    selectedProd = null;


    productForUpdate = null;

    subCategoriesByCategory = [];

  }

  updateUI() {
    notifyListeners();
  }
}

