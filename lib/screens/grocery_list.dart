import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final grocery_item = groceryItems.elementAt(index);
          final category = grocery_item.category;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 24, // Ширина цветного квадрата
                  height: 24, // Высота цветного квадрата
                  decoration: BoxDecoration(
                    color: category.color, // Цвет категории
                    shape: BoxShape.rectangle, // Форма круга
                  ),
                ),

                const SizedBox(width: 8), // Отступ между цветом и текстом
                Text(
                  grocery_item.name, // Название категории
                  style: const TextStyle(fontSize: 16),
                ),

                const Spacer(), // Добавляет пустое пространство
                Text(
                  '${[grocery_item.quantity]}', // Количество элементов
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
          
    )
    );
  }

}