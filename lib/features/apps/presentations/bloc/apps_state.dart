part of 'apps_bloc.dart';

@freezed
class AppsState with _$AppsState {
  const factory AppsState.initial() = _Initial;
  const factory AppsState.loading() = _Loading;
  const factory AppsState.activateDevModeSuccess() = _ActivateDevModeSuccess;
  const factory AppsState.launchAppSuccess() = _LaunchAppSuccess;
  const factory AppsState.closeAppSuccess() = _CloseAppSuccess;
  const factory AppsState.getAppListSuccess(List<String> appList) =
      _GetAppListSuccess;
  const factory AppsState.error(String err) = _Error;
  const factory AppsState.getDeviceListSuccess(List<CustomDevice> devicies) =
      _GetDeviceListSuccess;
}
