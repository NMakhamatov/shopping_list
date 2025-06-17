import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
    List<GroceryItem> _groceryItems = [];
    var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('fir-backend-example-8c942-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> _loadedItems = [];
    for(final item in listData.entries) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.name == item.value['category']).value;

      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = _loadedItems;
      _isLoading = false;
    });
    
  }


  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });

  //  _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'No items added yet!',
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } 

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              // direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                setState(() {
                  _groceryItems.removeAt(index);
                });
              },
              child: ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: content,
    );
  }
}
