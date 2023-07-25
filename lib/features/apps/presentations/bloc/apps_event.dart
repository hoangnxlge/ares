part of 'apps_bloc.dart';

@freezed
class AppsEvent with _$AppsEvent {
  const factory AppsEvent.started() = _Started;
  const factory AppsEvent.getAppList() = _GetAppList;
  const factory AppsEvent.launchApp(String appId) = _LaunchApp;
  const factory AppsEvent.closeApp(String appId) = _CloseApp;
  const factory AppsEvent.addDevice(CustomDevice device) = _AddDevice;
  const factory AppsEvent.getDeviceList() = _GetDeviceList;
  const factory AppsEvent.selectDevice(String deviceName) = _SelectDevice;
  const factory AppsEvent.removeDevice(String deviceName) = _RemoveDevice;
  const factory AppsEvent.activateDevMode() = _ActivateDevMode;
}
