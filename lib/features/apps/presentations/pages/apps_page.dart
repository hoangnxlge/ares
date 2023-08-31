import 'package:ares/features/apps/presentations/shared/widgets/app_card.dart';
import 'package:ares/shared/widgets/app_snack_bar.dart';
import 'package:ares/shared/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/apps_bloc.dart';
import '../shared/widgets/add_device_form.dart';

class AppsRoute {
  static Widget get route => BlocProvider(
        create: (context) => AppsBloc(),
        child: BlocListener<AppsBloc, AppsState>(
          listener: (context, state) {
            LoadingDialog.hide();
            state.whenOrNull(
              loading: LoadingDialog.show,
              error: (err) => AppSnackBar.show(message: err, duration: 40),
            );
          },
          child: const AppsPage(),
        ),
      );
}

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage>
    with AutomaticKeepAliveClientMixin {
  late final bloc = context.read<AppsBloc>();
  @override
  void initState() {
    bloc
        // ..add(const AppsEvent.getAppList())
        .add(const AppsEvent.getDeviceList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              bloc.add(const AppsEvent.activateDevMode());
            },
            child: const Text('Get locale'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  bloc.add(const AppsEvent.activateDevMode());
                },
                child: const Text('Enable dev mode'),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  bloc.add(const AppsEvent.getAppList());
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Devices'),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddDeviceDialog(
                    onAddDevice: (device) {
                      bloc.add(AppsEvent.addDevice(device));
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<AppsBloc, AppsState>(
            buildWhen: (_, current) => current.maybeWhen(
              getDeviceListSuccess: (_) => true,
              orElse: () => false,
            ),
            builder: (context, state) {
              return state.maybeWhen(
                getDeviceListSuccess: (devicies) => Wrap(
                  children: devicies
                      .map((device) => AppCard(
                            '${device.name}\n${device.ipAddress}:${device.port}',
                            onTap: () => bloc.add(
                              AppsEvent.selectDevice(device.name),
                            ),
                            onRemove: () => bloc.add(
                              AppsEvent.removeDevice(device.name),
                            ),
                            isSelected: device.isSelected,
                            width: 150,
                          ))
                      .toList(),
                ),
                orElse: () => const SizedBox(),
              );
            },
          ),
          const Divider(height: 40),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Apps'),
          ),
          BlocBuilder<AppsBloc, AppsState>(
            buildWhen: (_, current) => current.maybeWhen(
              getAppListSuccess: (_) => true,
              orElse: () => false,
            ),
            builder: (context, state) {
              return state.maybeWhen(
                getAppListSuccess: (appList) => Wrap(
                  children: appList
                      .map(
                        (appId) => AppCard(
                          appId,
                          onTap: () => bloc.add(
                            AppsEvent.launchApp(appId),
                          ),
                          onClose: () => bloc.add(
                            AppsEvent.closeApp(appId),
                          ),
                        ),
                      )
                      .toList(),
                ),
                orElse: () => const SizedBox(),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SliverSizeBox extends SliverToBoxAdapter {
  final double? width, height;
  SliverSizeBox({
    super.key,
    this.height,
    this.width,
  }) : super(
          child: SizedBox(
            width: width,
            height: height,
          ),
        );
}

//  Padding(
//   padding: const EdgeInsets.all(16),
//   child: Column(
//     children: [
//       ListTile(
//         contentPadding: EdgeInsets.zero,
//         title: const Text('Apps'),
//         trailing: IconButton(
//           onPressed: () {
//             bloc.add(const AppsEvent.getAppList());
//           },
//           icon: const Icon(Icons.refresh),
//         ),
//       ),
//       Expanded(
//         child: Column(
//           children: [
//             BlocBuilder<AppsBloc, AppsState>(
//               buildWhen: (_, current) => current.maybeWhen(
//                 getAppListSuccess: (_) => true,
//                 orElse: () => false,
//               ),
//               builder: (context, state) {
//                 return state.maybeWhen(
//                   getAppListSuccess: (appList) => Wrap(
//                     children: appList
//                         .map(
//                           (appId) => AppCard(
//                             appId,
//                             onTap: () => bloc.add(
//                               AppsEvent.launchApp(appId),
//                             ),
//                             onClose: () => bloc.add(
//                               AppsEvent.closeApp(appId),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                   orElse: () => const SizedBox(),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     ],
//   ),
// ),
