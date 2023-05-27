import 'package:flutter/material.dart';

class JoinGroupForm extends StatefulWidget {
  final void Function(
      String emailUserAjoute,
      BuildContext context,
      ) _submitForm;

  const JoinGroupForm(this._submitForm, {Key? key}) : super(key: key);

  @override
  State<JoinGroupForm> createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {

  final _key = GlobalKey<FormState>();
  TextEditingController _emailUserAjoute = TextEditingController();

  void _submit() {
    final isValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _key.currentState?.save();
    }
    _emailUserAjoute.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  key: const ValueKey("email"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email address"),
                  controller: _emailUserAjoute,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 8) {
                      return 'Au moins 7 caracteres.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      widget._submitForm(val!, context);
                    });
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Ajouter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
