class DatabaseRepository {
  List<String> items = [];

  void addItem(String item) {
    items.add(item);
  }

  void deleteItem(int index) {
    items.removeAt(index);
  }

  void editItem(int index, String newItem) {
    items[index] = newItem;
  }
}
