import 'package:admin_ssgooms/models/failures.dart';
import 'package:flutter/foundation.dart';

import '../models/message.dart';
import '../models/result_type.dart';

class ViewModelTemplate with ChangeNotifier {
  /// Listener when error occurs.
  ValueChanged<Message>? onErrorListener;

  /// State if viewmodel is processing something or not.
  bool get isLoading => _isLoading;
  bool _isLoading = false;
  bool _isDisposed = false;

  /// Start loading state.
  /// This will set the [isLoading] to TRUE.
  ///
  /// NOTE: This will notify the listeners of this viewmodel.
  @protected
  void startLoading() {
    if (isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();
  }

  /// Stop loading state.
  /// This will set the [isLoading] to FALSE.
  ///
  /// NOTE: This will notify the listeners of this viewmodel.
  @protected
  void stopLoading() {
    if (!isLoading) {
      return;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Failure handler.
  ///
  /// This will call the callback set via [onErrorListener].
  @protected
  @mustCallSuper
  void failureHandler(Failure failure) {
    if (failure.message == 'Subscription Failed') {
      return;
    }
    onErrorListener?.call(Message(
      type: ResultType.error,
      text: failure.message,
    ));
  }

  @override
  void notifyListeners() {
    if (_isDisposed) {
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
