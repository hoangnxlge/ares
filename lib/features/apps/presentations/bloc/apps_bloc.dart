import 'dart:async';
import 'dart:io';

import 'package:ares/features/apps/data/models/custom_device.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'apps_event.dart';
part 'apps_state.dart';
part 'apps_bloc.freezed.dart';

class AppsBloc extends Bloc<AppsEvent, AppsState> {
  String defaultDeviceName = '';
  AppsBloc() : super(const _Initial()) {
    on<_GetAppList>(_onGetAppList);
    on<_LaunchApp>((event, emit) async {
      final result = await Process.run(
        'ares-launch.cmd',
        ['-d', defaultDeviceName, event.appId],
      );
    });
    on<_CloseApp>((event, emit) async {
      emit(const _Loading());
      final result = await Process.run(
        'ares-launch.cmd',
        ['-d', defaultDeviceName, '--close', event.appId],
      );
      emit(const _CloseAppSuccess());
    });
    on<_AddDevice>(_onAddDevice);
    on<_GetDeviceList>(_onGetDeviceList);
    on<_SelectDevice>(_onSelectDevice);
    on<_RemoveDevice>(_onRemoveDevice);
    on<_ActivateDevMode>(_onActivateDevMode);
  }

  Future<void> callLunaApi(
    String endpoint, {
    String? param,
  }) async {
    final process = await Process.start(
      'ares-shell.cmd',
      [
        '-r',
        'luna-send -n 1 -f $endpoint \'$param\'',
      ],
    );
    await stdout.addStream(process.stdout);
    process.kill();
  }

  FutureOr<void> _onAddDevice(_AddDevice event, Emitter<AppsState> emit) async {
    try {
      emit(const _Loading());
      final device = event.device;
      final result = await Process.run('ares-setup-device.cmd', [
        '-a',
        event.device.name,
        '-i',
        'host=${device.ipAddress}',
        '-i',
        'port=${device.port}'
      ]);
      final deviceList = _getListDeviceFromDevicesString(result.stdout);
      emit(_GetDeviceListSuccess(deviceList));
    } catch (e) {
      emit(_Error(e.toString()));
    }
  }

  List<CustomDevice> _getListDeviceFromDevicesString(String devicesString) {
    List<String> rawData = devicesString.split('\n')
      ..removeRange(0, 2)
      ..removeLast();
    final data = rawData
        .map((e) => e.trim().replaceAll(RegExp(r'\s+'), ' ').split(' '))
        .toList()
      ..removeLast();

    final List<CustomDevice> deviceList = data.map(
      (e) {
        final bool defaultDevice = e.contains('(default)');
        final data = e[defaultDevice ? 2 : 1].split('@').last.split(':');
        return CustomDevice(
          isSelected: defaultDevice,
          ipAddress: data.first,
          name: e.first,
          port: int.tryParse(data.last) ?? 0,
        );
      },
    ).toList();
    return deviceList;
  }

  FutureOr<void> _onGetDeviceList(
      _GetDeviceList event, Emitter<AppsState> emit) async {
    try {
      emit(const _Loading());
      final result = await Process.run('ares-setup-device.cmd', ['-l']);
      final deviceList = _getListDeviceFromDevicesString(result.stdout);
      emit(_GetDeviceListSuccess(deviceList));
    } catch (e) {
      print(e.toString());
      emit(_Error(e.toString()));
    }
  }

  FutureOr<void> _onSelectDevice(event, Emitter<AppsState> emit) async {
    emit(const _Loading());
    final result =
        await Process.run('ares-setup-device.cmd', ['-f', event.deviceName]);
    final deviceList = _getListDeviceFromDevicesString(result.stdout);
    defaultDeviceName = event.deviceName;
    emit(_GetDeviceListSuccess(deviceList));
    add(const _GetAppList());
  }

  FutureOr<void> _onRemoveDevice(event, Emitter<AppsState> emit) async {
    emit(const _Loading());
    final result =
        await Process.run('ares-setup-device.cmd', ['-r', event.deviceName]);
    final deviceList = _getListDeviceFromDevicesString(result.stdout);
    emit(_GetDeviceListSuccess(deviceList));
  }

  FutureOr<void> _onGetAppList(
      _GetAppList event, Emitter<AppsState> emit) async {
    final result = await Process.run(
      'ares-install.cmd',
      ['-d', defaultDeviceName, '-l'],
    );
    if (result.stderr != null) {
      emit(_Error(result.stderr));
    }
    final appList = result.stdout.toString().split('\n')
      ..removeAt(0)
      ..removeLast();
    emit(AppsState.getAppListSuccess(appList));
  }

  FutureOr<void> _onActivateDevMode(
      _ActivateDevMode event, Emitter<AppsState> emit) async {
// ares-shell -r "luna-send -n 1 luna://com.webos.settingsservice/getSystemSettings '{\`"keys\`":[\`"localeInfo\`"]}'"
    await callLunaApi(
      'luna://com.webos.settingsservice/getSystemSettings',
      param: '{"keys": ["localeInfo"]}',
    );

    // emit(const _Loading());
    // final args = [
    //   '-r',
    //   "luna-send -n 1 luna://com.webos.service.devmode/setDevMode '{\"enabled\":true}'"
    // ];
    // final result = Process.runSync('Powershell.exe', ['pwd']);
    // debugPrint('AppLog: ${result.stderr}');
    // debugPrint('AppLog: ${result.stdout}');
    // if (![null, ''].contains(result.stderr)) {
    //   emit(_Error(result.stderr));
    // } else {
    //   emit(const _ActivateDevModeSuccess());
    // }
  }
}

// ares-shell -r 'luna-send -n 1 luna://com.webos.service.devmode/setDevMode ''{\"enabled\":true}'''