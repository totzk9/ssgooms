import 'package:graphql/client.dart';
import 'package:nhost_graphql_adapter/nhost_graphql_adapter.dart';
import 'package:nhost_sdk/nhost_sdk.dart';

import '../models/exceptions.dart';
import 'shared_preference_auth_store.dart';

class NHostService {
  factory NHostService() {
    if (_instance == null) {
      throw NHostServiceNotSetupException();
    }
    return _instance!;
  }

  NHostService._(String backendUrl) {
    _client = NhostClient(
      backendUrl: backendUrl,
      authStore: SharedPreferencesAuthStore(),
    );
    _graphqlClient = createNhostGraphQLClient(_client);


  }

  static NHostService? _instance;
  late final NhostClient _client;
  late final GraphQLClient _graphqlClient;
  bool _isUploadingMedia = false;

  NhostClient get client => _client;

  GraphQLClient get graphqlClient => _graphqlClient;

  bool get isUploadingMedia => _isUploadingMedia;

  set isUploadingMedia(bool value) {
    if (_isUploadingMedia == value) {
      return;
    }
    _isUploadingMedia = true;
  }

  static void init({
    required String backendUrl,
  }) {
    _instance ??= NHostService._(backendUrl);
  }

  void dispose() {
    _client.close();
    _instance = null;
  }
}
