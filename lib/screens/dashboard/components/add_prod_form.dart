import '../../../models/category.dart';
import '../../../models/prod.dart';
import '../../../models/sub_category.dart';
import '../provider/dash_board_provider.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/prod_image_card.dart';

class ProdSubmitForm extends StatelessWidget {
  final Product? product;

  const ProdSubmitForm({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.dashBoardProvider.setDataForUpdateProduct(product);
    return SingleChildScrollView(
      child: Form(
        key: context.dashBoardProvider.addProductFormKey,
        child: Container(
          width: size.width * 0.7,
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<DashBoardProvider>(
                    builder: (context, dashProvider, child) {
                      return ProductImageCard(
                        labelText: 'Main Image',
                        imageFile: dashProvider.selectedMainImage,
                        imageUrlForUpdateImage: product?.images.safeElementAt(0)?.url,
                        onTap: () {
                          dashProvider.pickImage(imageCardNumber: 1);
                        },
                        onRemoveImage: () {
                          dashProvider.selectedMainImage = null;
                          dashProvider.updateUI();
                        },
                      );
                    },
                  ),
                  Consumer<DashBoardProvider>(
                    builder: (context, dashProvider, child) {
                      return ProductImageCard(
                        labelText: 'Second image',
                        imageFile: dashProvider.selectedSecondImage,
                        imageUrlForUpdateImage: product?.images.safeElementAt(1)?.url,
                        onTap: () {
                          dashProvider.pickImage(imageCardNumber: 2);
                        },
                        onRemoveImage: () {
                          dashProvider.selectedSecondImage = null;
                          dashProvider.updateUI();
                        },
                      );
                    },
                  ),
                  Consumer<DashBoardProvider>(
                    builder: (context, dashProvider, child) {
                      return ProductImageCard(
                        labelText: 'Third image',
                        imageFile: dashProvider.selectedThirdImage,
                        imageUrlForUpdateImage: product?.images.safeElementAt(2)?.url,
                        onTap: () {
                          dashProvider.pickImage(imageCardNumber: 3);
                        },
                        onRemoveImage: () {
                          dashProvider.selectedThirdImage = null;
                          dashProvider.updateUI();
                        },
                      );
                    },
                  ),


                ],
              ),
              SizedBox(height: defaultPadding),
              CustomTextField(
                controller: context.dashBoardProvider.prodNameCtrl,
                labelText: 'Product Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding),
              CustomTextField(
                controller: context.dashBoardProvider.prodDescCtrl,
                labelText: 'Product Description',
                lineNumber: 3,
                onSave: (val) {},
              ),
              SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(child: Consumer<DashBoardProvider>(
                    builder: (context, dashProvider, child) {
                      return CustomDropdown(
                        key: ValueKey(dashProvider.selectedCategory?.sId),
                        initialValue: dashProvider.selectedCategory,
                        hintText: dashProvider.selectedCategory?.name ?? 'Select category',
                        items: context.dataProvider.categories,
                        displayItem: (Category? category) => category?.name ?? '',
                        onChanged: (newValue) {
                          if (newValue != null) {
                              context.dashBoardProvider.filterSubcategory(newValue);
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      );
                    },
                  )),
                  // Expanded(child: Consumer<DashBoardProvider>(
                  //   builder: (context, dashProvider, child) {
                  //     return CustomDropdown(
                  //       key: ValueKey(dashProvider.selectedSubCategory?.sId),
                  //       hintText: dashProvider.selectedSubCategory?.name ?? 'Sub category',
                  //       items: dashProvider.subCategoriesByCategory,
                  //       initialValue: dashProvider.selectedSubCategory,
                  //       displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                  //       onChanged: (newV alue) {
                  //         if (newValue != null) {
                  //           //TODO: should complete call filterBrand
                  //         }
                  //       },
                  //       validator: (value) {
                  //         if (value == null) {
                  //           return 'Please select sub category';
                  //         }
                  //         return null;
                  //       },
                  //     );
                  //   },
                  // )),

                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: context.dashBoardProvider.prodPriceCtrl,
                      labelText: 'Price',
                      inputType: TextInputType.number,
                      onSave: (val) {},
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: context.dashBoardProvider.prodOffPriceCtrl,
                      labelText: 'Offer price',
                      inputType: TextInputType.number,
                      onSave: (val) {},
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: context.dashBoardProvider.prodQntCtrl,
                      labelText: 'Quantity',
                      inputType: TextInputType.number,
                      onSave: (val) {},
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: defaultPadding),
              Row(
                children: [

                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.dashBoardProvider.addProductFormKey.currentState!.validate()) {
                          context.dashBoardProvider.addProductFormKey.currentState!.save();
                          context.dashBoardProvider.submitProduct();
                          Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the popup
void showAddProdForm(BuildContext context, Product? prod) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(child: Text('Add Product'.toUpperCase(), style: TextStyle(color: primaryColor))),
        content: ProdSubmitForm(product: prod),
      );
    },
  );
}

extension SafeList<T> on List<T>? {
  T? safeElementAt(int index) {
    // Check if the list is null or if the index is out of range
    if (this == null || index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }
}




