// Mocks generated by Mockito 5.1.0 from annotations
// in spacex_web_project/test/providers/upcoming_launches_provider_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:localstorage/localstorage.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:spacex_web_project/services/local_storage_api_service.dart'
    as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeLocalStorage_1 extends _i1.Fake implements _i3.LocalStorage {}

/// A class which mocks [LocalStorageApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorageApiService extends _i1.Mock
    implements _i7.LocalStorageApiService {
  MockLocalStorageApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.LocalStorage get upcomingLaunchesStorage =>
      (super.noSuchMethod(Invocation.getter(#upcomingLaunchesStorage),
          returnValue: _FakeLocalStorage_1()) as _i3.LocalStorage);
  @override
  set upcomingLaunchesStorage(_i3.LocalStorage? _upcomingLaunchesStorage) =>
      super.noSuchMethod(
          Invocation.setter(#upcomingLaunchesStorage, _upcomingLaunchesStorage),
          returnValueForMissingStub: null);
  @override
  _i5.Future<List<String>> getFavouriteLaunchIds() =>
      (super.noSuchMethod(Invocation.method(#getFavouriteLaunchIds, []),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i5.Future<List<String>>);
  @override
  dynamic setFavouriteLaunchIds(List<String>? favouriteUpcomingLaunchIds) =>
      super.noSuchMethod(Invocation.method(
          #setFavouriteLaunchIds, [favouriteUpcomingLaunchIds]));
}
