import 'package:graphql/client.dart';

import 'nhost_service.dart';

abstract class INhostGraphQLService {
  final GraphQLClient _graphqlClient = NHostService().graphqlClient;

  Future<R> query<R>({
    required String document,
    Map<String, dynamic> variables = const <String, dynamic>{},
    required R Function(Map<String, dynamic>?) decoder,
  }) async {
    final QueryResult result = await _graphqlClient.query(
      QueryOptions(
        document: gql(
          document,
        ),
        variables: variables,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }
    return decoder(result.data);
  }

  Future<R> mutation<R>({
    required String document,
    Map<String, dynamic> variables = const <String, dynamic>{},
    required R Function(Map<String, dynamic>?) decoder,
  }) async {
    final QueryResult result = await _graphqlClient.mutate(
      MutationOptions(
        document: gql(
          document,
        ),
        variables: variables,
      ),
    );
    if (result.hasException) {
      throw result.exception!;
    }
    return decoder(result.data);
  }

  Future<Stream<QueryResult>> subscription({
    required String document,
    Map<String, dynamic> variables = const <String, dynamic>{},
  }) async {
    final Stream<QueryResult> result = await _graphqlClient.subscribe(
      SubscriptionOptions(
        document: gql(
          document,
        ),
        variables: variables,
      ),
    );
    // if (result.hasException) {
    //   throw result.exception!;
    // }
    return result;
  }
}
