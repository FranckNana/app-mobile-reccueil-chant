import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  final BuildContext Parentcontext;
  const SearchForm({required this.Parentcontext, Key? key}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right:8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Recherche',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Ecrivez quelque chose...';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextButton(
                child: const Icon(Icons.search_rounded),
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                    ScaffoldMessenger.of(Parentcontext).showSnackBar(
                      const SnackBar(content: Text('Recherche en cours...')),
                    );
                  }
                }
              ),
            ],
          ),
        ),
    );
  }
}