import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _SigilLints();

class _SigilLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [];
}
