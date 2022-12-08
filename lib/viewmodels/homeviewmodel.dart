
import 'view_model_template.dart';

enum HomeViewState {
  showLoading,
  showSubscriptions,
  showHome,
  showRetry,
}

//------------------------------------------------------------------------------
class HomeViewModel extends ViewModelTemplate {
  /// State on what page should be shown in home.
  HomeViewState get state => _state;
  HomeViewState _state = HomeViewState.showLoading;

  /// Current bottom nav bar index.
  int get index => _index;
  int _index = 0;

  /// Callback when bottom nav bar item is pressed.
  void onIndexSelected(int i) {
    _index = i;
    if (index == 3) {
      return;
    }
    notifyListeners();
  }
}
