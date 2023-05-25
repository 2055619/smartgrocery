
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liste_epicerie/widgets/user_picker_image.dart';

class ArticleForm extends StatefulWidget {
  ArticleForm(this.submitForm, {Key? key}) : super(key: key);

  final void Function(
    String product_name,
    String allergens,
    String brands,
    String categories,
    String creator,
    String nutriscore_grade,
    String url,
    XFile image,
  ) submitForm;

  @override
  State<ArticleForm> createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {

  final _key = GlobalKey<FormState>();

  String product_name = "";
  String allergens = "";
  String brands = "";
  String categories = "";
  String creator = "";
  String nutriscore_grade = "";
  String url = "";
  var _myUserImageFile;

  void submit(){
    final isValid = _key.currentState!.validate();

    if (_myUserImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SVP Ajouter une image"),
        ),
      );
      return;
    }

    if (isValid) {
      _key.currentState!.save();
    }

    widget.submitForm(
      product_name,
      allergens,
      brands,
      categories,
      creator,
      nutriscore_grade,
      url,
      _myUserImageFile
    );
  }

  void _myPickImage(XFile pickedImage) {
    _myUserImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    UserImagePicker(_myPickImage),
                    TextFormField(
                      decoration: InputDecoration(labelText: "nom du produit"),
                      key: ValueKey("product_name"),
                      validator: (val) {
                        if (val!.isEmpty || val.length < 3) {
                          return 'Au moins 2 caracteres.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product_name = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "allergens"),
                      key: ValueKey("allergens"),
                      onSaved: (value) {
                        allergens = value!;
                        },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Compagnies"),
                      key: ValueKey("brands"),
                      onSaved: (value) {
                        brands = value!;
                        },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "categories"),
                      key: ValueKey("categories"),
                      onSaved: (value) {
                        categories = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "creator"),
                      key: ValueKey("creator"),
                      onSaved: (value) {
                        creator = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "nutriscore_grade"),
                      key: ValueKey("nutriscore_grade"),
                      onSaved: (value) {
                        nutriscore_grade = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "url"),
                      key: ValueKey("url"),
                      onSaved: (value) {
                        url = value!;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text("Cancel"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: submit,
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ]),
                ),
              )),
        )
    );
  }
}
