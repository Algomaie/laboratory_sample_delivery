import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showform(title, BuildContext context, formKey, nameController,
    ageController, deptController, gradeController) {
  return showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            scrollable: true,
            title: Text(title),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                // onWillPop: () {
                //   return  nu;
                // },
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Please enter a name  name short';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ageController,
                      obscureText: false,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[1-9]'))
                      ],
                      decoration: InputDecoration(
                        labelText: 'Age',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an age';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: gradeController,
                      decoration: InputDecoration(
                        labelText: 'Grade',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a grade';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: deptController,
                      decoration: InputDecoration(
                        labelText: 'Department:',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Department';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // _saveStudent();
                            }
                          },
                          child: Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //   _showStudents();
                          },
                          child: Text('تراجع'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      });
}
