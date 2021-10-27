/*
 * SPDX-FileCopyrightText: 2021 Vishesh Handa <me@vhanda.in>
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:gitjournal/analytics/analytics.dart';
import 'package:gitjournal/generated/locale_keys.g.dart';
import 'package:gitjournal/settings/app_settings.dart';

class SettingsAnalytics extends StatelessWidget {
  const SettingsAnalytics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appSettings = context.watch<AppSettings>();
    var list = ListView(
      children: [
        const _AnalyticsSwitchListTile(),
        SwitchListTile(
          title: Text(tr(LocaleKeys.settings_crashReports)),
          value: appSettings.collectCrashReports,
          onChanged: (bool val) {
            appSettings.collectCrashReports = val;
            appSettings.save();

            logEvent(
              Event.CrashReportingLevelChanged,
              parameters: {"state": val.toString()},
            );
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_list_analytics_title.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: list,
    );
  }
}

class _AnalyticsSwitchListTile extends StatefulWidget {
  const _AnalyticsSwitchListTile({
    Key? key,
  }) : super(key: key);

  @override
  State<_AnalyticsSwitchListTile> createState() =>
      _AnalyticsSwitchListTileState();
}

class _AnalyticsSwitchListTileState extends State<_AnalyticsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    if (Analytics.instance == null) {
      return const SizedBox();
    }
    var analytics = Analytics.instance!;

    return SwitchListTile(
      title: Text(tr(LocaleKeys.settings_usageStats)),
      value: analytics.enabled,
      onChanged: (bool val) {
        analytics.enabled = val;
        setState(() {}); // Remove this once Analytics.instace is not used
      },
    );
  }
}
