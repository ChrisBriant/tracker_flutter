import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/db_provider.dart';
import '../widgets/card_header.dart';
import '../validators/validators.dart';

class AddRouteScreen extends StatelessWidget {
  static String routeName = '/addroute';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    

    final Map<String,dynamic> _form = {
      'name' : '',
      'description' : '',
    };
    final _dbProvider = Provider.of<DBProvider>(context,listen: true);

    Future<void> _saveForm() async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        print('Form is invalid');
        return;
      } else {
        print('Form is valid');
        var uuid = Uuid();
        _formKey.currentState!.save();
        
        print(uuid.v4());
        print(_form);
        print(DateTime.now().toIso8601String());


        try {
          bool _success = await _dbProvider.insertRoute('route',{
            'id' : uuid.v4(),
            'name' : _form['name'],
            'description' : _form['description'],
            'dateadded' : DateTime.now().toIso8601String()
          });
          print('Did it work');
          // print(_success);
          if(_success) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Successfully added a route'),
            ));
          }
        } catch(err) {
          print(err);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err.toString()),
          ));
        }
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Route'),
      ),
      body: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.82,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 12,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(labelText: 'Name'),
                                      keyboardType: TextInputType.text,
                                      validator: (value) => Validators.validText(value),
                                      onSaved: (value) { _form['name'] = value; },
                                      onTap: () {},
                                    ),
                                    SizedBox(height: 10,),
                                    TextFormField(
                                      decoration: InputDecoration(labelText: 'Description',border: OutlineInputBorder()),
                                      maxLines: 3,
                                      keyboardType: TextInputType.text,
                                      onSaved: (value) { _form['description'] = value; },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      //onPressed: _saveForm, 
                                      onPressed: _saveForm,
                                      child: Text('Add Route'))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CardHeader(title:'Add Route'),
                        ]
                      ),
                    )
                  ),
                ),
              ]
            ),
      ),
    );
  }
}