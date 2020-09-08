import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/Models/AppDrawer.dart';
import 'package:shopapp/Models/GradientAppBar.dart';

import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/products_provider.dart';
import '../Providers/products.dart';

class EditProductsScreen extends StatefulWidget {
  static final String pageroutes = "editpage";
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final pricFocusNode = FocusNode();
  final descFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final formkey = GlobalKey<FormState>();

  var editedProduct =
      Products(id: null, desc: "", imageUrl: "", price: 0, title: "");
  @override
  void initState() {
    // TODO: implement initState

    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  bool showTheToast = true;
  var _isloading = false;
  var didchange = true;
  bool isdefaultfun() {
    if (editedProduct.price != 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    //RUN BEFORE BUILD LIKE INITSTATE BUT WE USE IT BEC INITSTATE DIDN'T WORK//
    if (didchange) {
      final proId = ModalRoute.of(context).settings.arguments as String;
      if (proId != null) {
        editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(proId);

        imageUrlController.text = isdefaultfun() ? editedProduct.imageUrl : "";
      }
    }
    didchange = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pricFocusNode.dispose();
    imageUrlFocusNode.removeListener(updateImageUrl);
    descFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveForm() async {
    final productsprovide =
        Provider.of<ProductsProvider>(context, listen: false);
    if (!formkey.currentState.validate()) {
      setState(() {
        _isloading = false;
      });
      return;
    }
    formkey.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (editedProduct.id == null) {
      try {
        await productsprovide.addProduct(editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error occured !"),
            content: Text("Something went wrong !"),
            actions: [
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  setState(() {
                    showTheToast = false;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isloading = false;

          Navigator.of(context).pop();
          showTheToast
              ? showToast("Added Successfully !")
              : showToast("Failed to add an item .");
        });
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(editedProduct.id, editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error occured !"),
            content: Text("Something went wrong !"),
            actions: [
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  setState(() {
                    showTheToast = false;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }

      setState(() {
        _isloading = false;
      });
      showToast("Updated Successfully !");
      Navigator.of(context).pop();
    }
  }

  void updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.red, Colors.blue])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: AppDrawer(),
          appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            title: Text('Edit Products'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.save,
                    size: 29,
                  ),
                  onPressed: () {
                    saveForm();
                  },
                ),
              )
            ],
          ),
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: formkey,
                    child: ListView(
                      children: [
                        ///title////
                        //
                        TextFormField(
                          initialValue:
                              isdefaultfun() ? editedProduct.title : null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a title ! ";
                            }
                            return null; // NULL MEANS NO ERROR
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(pricFocusNode),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1)),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            editedProduct = new Products(
                                isFavourite: editedProduct.isFavourite,
                                id: editedProduct.id,
                                title: newValue,
                                desc: editedProduct.desc,
                                price: editedProduct.price,
                                imageUrl: editedProduct.imageUrl);
                          },
                        ),
                        //
                        //PRICE///
                        TextFormField(
                          initialValue: isdefaultfun()
                              ? editedProduct.price.toString()
                              : null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a price  ! ";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid price !";
                            }
                            if (double.parse(value[0]) <= 0) {
                              return "Please enter a number greater than zero !";
                            }
                            return null; // NULL MEANS NO ERROR
                          },
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(descFocusNode),
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                          focusNode: pricFocusNode,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            editedProduct = new Products(
                                isFavourite: editedProduct.isFavourite,
                                id: editedProduct.id,
                                title: editedProduct.title,
                                desc: editedProduct.desc,
                                price: double.parse(newValue),
                                imageUrl: editedProduct.imageUrl);
                          },
                        ),

                        //
                        //
                        //DESC//
                        TextFormField(
                          initialValue:
                              isdefaultfun() ? editedProduct.desc : null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a description ! ";
                            }
                            return null; // NULL MEANS NO ERROR
                          },
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                          ),
                          focusNode: descFocusNode,
                          onSaved: (newValue) {
                            editedProduct = new Products(
                                isFavourite: editedProduct.isFavourite,
                                id: editedProduct.id,
                                title: editedProduct.title,
                                desc: newValue,
                                price: editedProduct.price,
                                imageUrl: editedProduct.imageUrl);
                          },
                        ),

                        /////////image////
                        ///
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: imageUrlController.text.isEmpty
                                  ? Text('Enter a URL !')
                                  : Image.network(
                                      imageUrlController.text,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter a url first ! ";
                                    }
                                    if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return "Wrong URL !";
                                    }
                                    if (!value.endsWith('.png') &&
                                        (!value.endsWith('.jpg') &&
                                            (!value.endsWith('.jpeg')))) {
                                      return "Please enter a valid URL !";
                                    }
                                    return null; // NULL MEANS NO ERROR
                                  },
                                  focusNode: imageUrlFocusNode,
                                  decoration:
                                      InputDecoration(labelText: 'Image Url'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (newValue) {
                                    editedProduct = new Products(
                                        title: editedProduct.title,
                                        desc: editedProduct.desc,
                                        price: editedProduct.price,
                                        isFavourite: editedProduct.isFavourite,
                                        id: editedProduct.id,
                                        imageUrl: newValue);
                                  },
                                  onFieldSubmitted: (_) {
                                    saveForm();
                                  },
                                  controller: imageUrlController),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}
