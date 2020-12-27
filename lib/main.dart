import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String _link = 'https://countries.trevorblades.com/';
void main() {
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: _link,
    );
    ValueNotifier<GraphQLClient> _client = ValueNotifier(
      GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: httpLink,
      ),
    );
    return GraphQLProvider(
      client: _client,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: _MyHomePage(),
      ),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphql Flutter'),
      ),
      body: Query(
        options: QueryOptions(
          documentNode: gql(
            r'''
            query GetCountry($ID : ID!){
              continent(code:$ID){
                name
                countries{
                  name
                }
              }
            }
          ''',
          ),
          variables: <String, dynamic>{
            'ID': 'AF',
          },
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.loading) {
            return const Text('Loading');
          }
          final List _repositories = result.data['continent']['countries'];
          return ListView.builder(
            itemCount: _repositories.length,
            itemBuilder: (context, _index) {
              return Text(
                _repositories[_index]['name'],
              );
            },
          );
        },
      ),
    );
  }
}
