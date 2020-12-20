import 'package:api_to_sqlite_flutter/src/providers/db_provider.dart';
import 'package:api_to_sqlite_flutter/src/providers/programmer_api_provider.dart';
import 'package:flutter/material.dart';

const double spaceBetweenRows = 10;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to sqlite'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildProgrammerListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ProgrammerApiProvider();
    await apiProvider.getAllProgrammers();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllProgrammers();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All programmers deleted');
  }

  _buildProgrammerListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllProgrammers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Color(0xffdce6e0),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: Text("${index + 1}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                    title: Column(
                      children: [
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Name",
                          value: snapshot.data[index].firstName,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Surname",
                          value: snapshot.data[index].lastName,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Email",
                          value: snapshot.data[index].email,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Technology",
                          value: snapshot.data[index].technologies,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Years of experience",
                          value:
                              snapshot.data[index].yearsExperience.toString(),
                        ),
                      ],
                    ),
                  ),
                );
                // return ListTile(
                //   leading: Text(
                //     "${index + 1}",
                //     style: TextStyle(fontSize: 20.0),
                //   ),
                //   title: Text(
                //       "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} "),
                //   subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
                // );
              },
            ),
          );
        }
      },
    );
  }
}

class FormattedRow extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int index;
  final String title;
  final String value;

  FormattedRow({this.snapshot, this.index, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          value,
          style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 18),
        ),
      ],
    );
  }
}
