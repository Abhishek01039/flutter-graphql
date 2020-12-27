import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttergraphql/helper/graphql_helper.dart';
import 'package:meta/meta.dart';

part 'graphql_event.dart';
part 'graphql_state.dart';

class GraphqlBloc extends Bloc<GraphqlEvent, GraphqlState> {
  GraphqlBloc() : super(GraphqlInitial());

  GraphQLServiceImplRepo graphQLServiceImplRepo = new GraphQLServiceImplRepo();

  @override
  Stream<GraphqlState> mapEventToState(
    GraphqlEvent event,
  ) async* {
    if (event is CountryGraphQL) {
      yield* _mapFetchHomeDataToStates(event);
    }
  }

  Stream<GraphqlState> _mapFetchHomeDataToStates(CountryGraphQL event) async* {
    final query = event.query;
    final variables = event.variables ?? null;

    try {
      yield Loading();
      final result = await graphQLServiceImplRepo.performQuery(
        query,
        variables: variables,
      );

      if (result.hasException) {
        print('graphQLErrors: ${result.exception.graphqlErrors.toString()}');
        print('clientErrors: ${result.exception.clientException.toString()}');
        yield LoadDataFail(result.exception.graphqlErrors[0]);
      } else {
        yield LoadDataSuccess(result.data);
      }
    } catch (e) {
      print(e);
      yield LoadDataFail(e.toString());
    }
  }
}
