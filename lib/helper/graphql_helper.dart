import 'package:graphql/client.dart';

abstract class _GraphQLService {
  Future<QueryResult> performQuery(String query,
      {Map<String, dynamic> variables});

  Future<QueryResult> performMutation(String query,
      {Map<String, dynamic> variables});
}

class GraphQLServiceImplRepo extends _GraphQLService {
  GraphQLClient _client;
  GraphQLServiceImplRepo() {
    HttpLink link = HttpLink(uri: 'https://countries.trevorblades.com/');

    _client = GraphQLClient(
      link: link,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    );
  }
  @override
  Future<QueryResult> performQuery(String query,
      {Map<String, dynamic> variables}) async {
    QueryOptions options =
        QueryOptions(documentNode: gql(query), variables: variables);

    final result = await _client.query(options);

    return result;
  }

  @override
  Future<QueryResult> performMutation(String query,
      {Map<String, dynamic> variables}) async {
    MutationOptions options =
        MutationOptions(documentNode: gql(query), variables: variables);

    final result = await _client.mutate(options);

    print(result);

    return result;
  }
}
