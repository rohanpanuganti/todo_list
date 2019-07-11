import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
        ),
        home: new ListApp());
  }
}

class Assignment {
  String title;
  String content;
  DateTime due;
  Assignment(String t, String c, DateTime d) {
    title = t;
    content = c;
    due = d;
  }
}

class ListApp extends StatefulWidget {
  @override
  _ListAppState createState() => _ListAppState();
}

class _ListAppState extends State<ListApp> {
  List<Assignment> _items = [];

  void _addItem(String t, String c, DateTime d) {
    setState(() {
      _items.add(Assignment(t, c, d));
      _items.sort((a, b) => a.due.isAfter(b.due) ? 1 : 0);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _items.sort((a, b) => a.due.isAfter(b.due) ? 1 : 0);
    });
  }

  var time = DateFormat('jm');
  var date = DateFormat('MM-dd-yyyy');

  void _infoBox(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text(_items[index].title),
              content: Text(
                  "${_items[index].content} \n ${time.format(_items[index].due)} | ${date.format(_items[index].due)}"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Complete'),
                  onPressed: () {
                    _removeItem(index);
                    Navigator.pop(context);
                  },
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                  isDefaultAction: true,
                )
              ]),
    );
  }

  Widget _buildList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return new Container(
            child: new ListTile(
                title: Text(_items[index].title),
                trailing: Text(date.format(_items[index].due)),
                onTap: () => _infoBox(index)),
            decoration: new BoxDecoration(
                border: new Border(
              bottom: BorderSide(
                color: Colors.redAccent,
              ),
            )),
          );
        }
      },
    );
  }

  void _addingPage() {
    String _title = 'TITLE';
    String _content = 'CONTENT';
    DateTime _due = DateTime.now().add(new Duration(days: 1));

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text('New Assignment'),
        ),
        body: Column(
          children: <Widget>[
            Text('Enter Title'),
            TextField(
              maxLength: 50,
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              cursorColor: Colors.redAccent,
              autofocus: true,
              autocorrect: true,
              onChanged: (text) {
                _title = text;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                border: OutlineInputBorder(),
              ),
            ),
            Text('Enter Information'),
            TextField(
              maxLength: 150,
              style: TextStyle(
                fontSize: 17,
                color: Colors.redAccent,
                fontWeight: FontWeight.w400,
              ),
              autofocus: true,
              autocorrect: true,
              onChanged: (text) {
                _content = text;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                border: OutlineInputBorder(),
              ),
            ),
            Text('Enter Submission Date'),
            Container(
              height: 50,
              child: CupertinoDatePicker(
                onDateTimeChanged: (date) {
                  _due = date;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CupertinoButton(
                child: Text('Submit'),
                color: Colors.red,
                onPressed: () {
                  _addItem(_title, _content, _due);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('Assigments'),
        ),
        body: _buildList(),
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Add',
          child: new Icon(Icons.assignment),
          onPressed: () => _addingPage(),
        ));
  }
}
