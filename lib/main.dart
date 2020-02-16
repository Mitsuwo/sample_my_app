import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<TextModel>(
      create: (_) => TextModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TextList()
      )
    );
  }
}

class TextList extends StatefulWidget {
  @override
  createState() => TextListState();
}

class TextListState extends State<TextList> {
  void pushFormPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  Widget buildTextList() {
    final textModel = Provider.of<TextModel>(context);
    final _textItems = textModel.getTextItems();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return buildTextItem(_textItems[index]);
      },
      itemCount: _textItems.length,
    );
  }

  Widget buildTextItem(String text) {
    return Text("Added Text is: $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List')
      ),
      body: buildTextList(),
      floatingActionButton: FloatingActionButton(
        onPressed: pushFormPage, // _addTodoItem,
        tooltip: 'Add task',
        child: Icon(Icons.add)
      ),
    );
  }
}

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: MyCustomForm()
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String text;

  void handleAdd(value) {
    Provider.of<TextModel>(context).setTextItems(value);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (String value) {
              handleAdd(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  print('Form is not valid!  Please review and correct.');
                } else {
                  _formKey.currentState.save();
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class TextModel {
  List<String> _textItems = [];
  getTextItems() => _textItems;
  setTextItems(String text) {
    _textItems.add(text);
  }
}
