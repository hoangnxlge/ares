import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../utils/di/injections.dart';
import '../../settings_exports.dart';

class SettingsRoute {
  static Widget get route => BlocProvider(
        create: (context) => SettingsBloc(
          getSettingsUseCase: getIt(),
          saveSettingsUseCase: getIt(),
        ),
        child: const SettingsPage(),
      );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final bloc = context.read<SettingsBloc>();
  @override
  void initState() {
    bloc.add(const SettingsEvent.getSettings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ListTile(
              title: const Text(LocaleKeys.darkTheme).tr(),
              trailing: BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (_, current) => current.maybeWhen(
                  getSettingsSuccess: (_) => true,
                  orElse: () => false,
                ),
                builder: (context, state) {
                  return state.maybeWhen(
                    getSettingsSuccess: (settings) => Switch.adaptive(
                      value: settings.isDarkTheme,
                      onChanged: (val) {
                        bloc.add(
                          SettingsEvent.saveSettings(
                            settings.copyWith(isDarkTheme: val),
                          ),
                        );
                      },
                    ),
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text(LocaleKeys.language).tr(),
              trailing: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    getSettingsSuccess: (settings) => ToggleButtons(
                      isSelected: context.supportedLocales
                          .map((locale) => locale == context.locale)
                          .toList(),
                      onPressed: (index) {
                        final locale = context.supportedLocales[index];
                        setState(() {
                          context.setLocale(locale);
                        });
                        bloc.saveSettingsUseCase(SaveSettingsParams(settings
                            .copyWith(languageCode: locale.languageCode)));
                      },
                      children: context.supportedLocales
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(e.languageCode.toUpperCase()),
                            ),
                          )
                          .toList(),
                    ),
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
