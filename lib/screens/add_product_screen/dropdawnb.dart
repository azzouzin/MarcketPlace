import 'package:e_commerce/screens/add_product_screen/add_product_screen.dart';
import 'package:flutter/material.dart';

import '../../controller/product_controller.dart';

const List<String> list = <String>[
  'All',
  'Sport',
  'Men',
  'women',
  'child',
  'House',
  'Clothes',
  'Phones',
  'Computers',
  'Fornutur',
  'Garden',
  'Accesoir',
  'Cars',
  'Plans',
];

class DropdownButtonExample extends StatefulWidget {
  DropdownButtonExample(this.controller);
  ProductController controller;
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  void initState() {
    Add_product_Screen().controller.cahngecategory('All');
    print(widget.controller.category.value);
    // TODO: implement initState
    super.initState();
  }

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        Add_product_Screen().controller.cahngecategory(value!);
        print(widget.controller.category.value);
        setState(() {
          dropdownValue = value;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
