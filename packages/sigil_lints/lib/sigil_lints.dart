import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Creates the sigil custom lint plugin.
PluginBase createPlugin() => _SigilLints();

class _SigilLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        NoMaterialOrCupertino(configs.rules['no_material_or_cupertino']),
        ValueObjectHasFrom(options: configs.rules['value_object_has_from']),
        AvoidNullable(configs.rules['avoid_nullable']),
      ];
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

/// Parses `excludes` from a rule's [LintOptions] YAML config.
///
/// Expected format in `analysis_options.yaml`:
/// ```yaml
/// custom_lint:
///   rules:
///     - my_rule:
///       excludes:
///         - "**/infrastructure/**"
///         - "**/*.g.dart"
/// ```
List<RegExp> parseExcludes(LintOptions? options) {
  final raw = options?.json['excludes'];
  if (raw is! List) return const [];
  return raw.whereType<String>().map(_globToRegExp).toList();
}

/// Converts a simple glob pattern to a [RegExp] that matches absolute paths.
///
/// Supports `**` (any path segments) and `*` (any non-separator chars).
RegExp _globToRegExp(String glob) {
  final buffer = StringBuffer();
  for (var i = 0; i < glob.length; i++) {
    final char = glob[i];
    if (char == '*') {
      if (i + 1 < glob.length && glob[i + 1] == '*') {
        buffer.write('.*');
        i++; // skip second *
        // Also skip trailing `/` after `**`
        if (i + 1 < glob.length && glob[i + 1] == '/') i++;
      } else {
        buffer.write('[^/]*');
      }
    } else if (char == '?') {
      buffer.write('[^/]');
    } else {
      buffer.write(RegExp.escape(char));
    }
  }
  return RegExp('$buffer\$');
}

/// Returns `true` if [path] matches any of the [excludes] patterns.
bool isExcluded(String path, List<RegExp> excludes) =>
    excludes.any((re) => re.hasMatch(path));

// ---------------------------------------------------------------------------
// no_material_or_cupertino
// ---------------------------------------------------------------------------

/// Bans `material.dart` and `cupertino.dart` imports.
class NoMaterialOrCupertino extends DartLintRule {
  NoMaterialOrCupertino(LintOptions? options)
      : _excludes = parseExcludes(options),
        super(code: _code);

  final List<RegExp> _excludes;

  static const _code = LintCode(
    name: 'no_material_or_cupertino',
    problemMessage: 'Do not import Material or Cupertino. '
        'Use flutter/widgets.dart instead.',
  );

  static const _banned = [
    'package:flutter/material.dart',
    'package:flutter/cupertino.dart',
  ];

  @override
  void run(
    CustomLintResolver resolver,
    // ignore: deprecated_member_use, custom_lint_builder API requires this type
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExcluded(resolver.path, _excludes)) return;

    context.registry.addImportDirective((node) {
      final uri = node.uri.stringValue;
      if (uri == null) return;
      if (_banned.contains(uri)) {
        reporter.atNode(node, _code);
      }
    });
  }
}

// ---------------------------------------------------------------------------
// value_object_has_from
// ---------------------------------------------------------------------------

class ValueObjectHasFrom extends DartLintRule {
  ValueObjectHasFrom({
    LintOptions? options,
    TypeChecker? valueObjectChecker,
  })  : _excludes = parseExcludes(options),
        _valueObjectChecker =
            valueObjectChecker ?? _defaultValueObjectChecker,
        super(code: _code);

  static const _defaultValueObjectChecker = TypeChecker.fromName(
    'ValueObject',
    packageName: 'sigil_flutter',
  );

  final List<RegExp> _excludes;
  final TypeChecker _valueObjectChecker;

  static const _code = LintCode(
    name: 'value_object_has_from',
    problemMessage:
        "Classes extending ValueObject must define a static 'from' method.",
  );

  static const _paramCountCode = LintCode(
    name: 'value_object_from_single_param',
    problemMessage: "The 'from' method must have exactly one parameter.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    // ignore: deprecated_member_use, custom_lint_builder API requires this type
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExcluded(resolver.path, _excludes)) return;

    context.registry.addClassDeclaration((node) {
      final element = node.declaredFragment?.element;
      if (element == null) return;
      if (!_valueObjectChecker.isSuperOf(element)) return;

      // Check no public constructors.
      final hasPublicConstructor = element.constructors.any(
        (c) => c.isPublic && !c.isFactory,
      );
      if (hasPublicConstructor) {
        reporter.atToken(
          node.name,
          const LintCode(
            name: 'value_object_no_public_constructor',
            problemMessage:
                'ValueObject subclasses must not have public '
                'constructors. Use a private constructor '
                '(e.g. const ClassName._(super.value)).',
          ),
        );
      }

      final fromMethod = element.methods
          .where((m) => m.isStatic && m.name == 'from')
          .firstOrNull;

      if (fromMethod == null) {
        reporter.atToken(node.name, code);
        return;
      }

      // Check exactly 1 parameter.
      final params = fromMethod.formalParameters;
      if (params.length != 1) {
        reporter.atToken(node.name, _paramCountCode);
        return;
      }

      // Resolve the T type argument from the ValueObject<T, F> supertype.
      final supertype = element.allSupertypes.firstWhere(
        _valueObjectChecker.isExactlyType,
      );
      final expectedType = supertype.typeArguments.first;
      final actualType = params.first.type;

      if (actualType != expectedType) {
        reporter.atToken(
          node.name,
          LintCode(
            name: 'value_object_from_param_type',
            problemMessage:
                "The 'from' parameter type must match the ValueObject's "
                'type argument T ($expectedType expected, got $actualType).',
          ),
        );
      }

      // Check return type is Either<F, SubClass>.
      final returnType = fromMethod.returnType;
      final expectedFailure = supertype.typeArguments[1];
      final className = element.name;

      if (returnType.element?.name != 'Either') {
        reporter.atToken(
          node.name,
          LintCode(
            name: 'value_object_from_return_type',
            problemMessage:
                "The 'from' method must return "
                'Either<$expectedFailure, $className> '
                '(got $returnType).',
          ),
        );
        return;
      }

      final returnTypeArgs =
          (returnType as ParameterizedType).typeArguments;
      final actualLeft = returnTypeArgs[0];
      final actualRight = returnTypeArgs[1];

      if (actualLeft != expectedFailure || actualRight.element != element) {
        reporter.atToken(
          node.name,
          LintCode(
            name: 'value_object_from_return_type',
            problemMessage:
                "The 'from' method must return "
                'Either<$expectedFailure, $className> '
                '(got Either<$actualLeft, $actualRight>).',
          ),
        );
      }
    });
  }
}

// ---------------------------------------------------------------------------
// avoid_nullable
// ---------------------------------------------------------------------------

class AvoidNullable extends DartLintRule {
  AvoidNullable(LintOptions? options)
      : _excludes = parseExcludes(options),
        super(code: _code);

  final List<RegExp> _excludes;

  static const _code = LintCode(
    name: 'avoid_nullable',
    problemMessage: 'Avoid nullable types. '
        'Use Option<T> from fpdart instead of T?.',
  );

  static const _returnCode = LintCode(
    name: 'avoid_nullable',
    problemMessage: 'Avoid nullable return types. '
        'Use Option<T> from fpdart instead of T?.',
  );

  static const _paramCode = LintCode(
    name: 'avoid_nullable',
    problemMessage: 'Avoid nullable parameter types. '
        'Use Option<T> from fpdart instead of T?.',
  );

  static const _fieldCode = LintCode(
    name: 'avoid_nullable',
    problemMessage: 'Avoid nullable field types. '
        'Use Option<T> from fpdart instead of T?.',
  );

  static const _variableCode = LintCode(
    name: 'avoid_nullable',
    problemMessage: 'Avoid nullable variable types. '
        'Use Option<T> from fpdart instead of T?.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    // ignore: deprecated_member_use, custom_lint_builder API requires this type
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isExcluded(resolver.path, _excludes)) return;

    context.registry.addMethodDeclaration((node) {
      if (_hasOverride(node.metadata)) return;

      final returnType = node.returnType;
      if (returnType != null && _containsNullable(returnType)) {
        reporter.atNode(returnType, _returnCode);
      }

      _checkParameters(node.parameters, reporter);
    });

    context.registry.addFunctionDeclaration((node) {
      if (_hasOverride(node.metadata)) return;

      final returnType = node.returnType;
      if (returnType != null && _containsNullable(returnType)) {
        reporter.atNode(returnType, _returnCode);
      }

      _checkParameters(
        node.functionExpression.parameters,
        reporter,
      );
    });

    context.registry.addFieldDeclaration((node) {
      if (_hasOverride(node.metadata)) return;

      final type = node.fields.type;
      if (type == null) return;
      if (!_containsNullable(type)) return;

      reporter.atNode(type, _fieldCode);
    });

    // Local variables (inside methods/functions).
    context.registry.addVariableDeclarationList((node) {
      // Skip if not a local variable (fields and top-level are handled above).
      if (node.parent is! VariableDeclarationStatement) return;

      final type = node.type;
      if (type != null) {
        // Explicit type annotation: `String? x = ...`
        if (_containsNullable(type)) {
          reporter.atNode(type, _variableCode);
        }
        return;
      }

      // Inferred type: `final x = expr` — check resolved type for nullability.
      for (final variable in node.variables) {
        final resolvedType = variable.declaredFragment?.element.type;
        if (resolvedType != null &&
            resolvedType.nullabilitySuffix == NullabilitySuffix.question) {
          reporter.atNode(variable, _variableCode);
        }
      }
    });

    context.registry.addTopLevelVariableDeclaration((node) {
      final type = node.variables.type;
      if (type == null) return;
      if (!_containsNullable(type)) return;

      reporter.atNode(type, _variableCode);
    });
  }

  void _checkParameters(
    FormalParameterList? parameterList,
    // ignore: deprecated_member_use, custom_lint_builder API requires this type
    ErrorReporter reporter,
  ) {
    if (parameterList == null) return;
    for (final param in parameterList.parameters) {
      // Unwrap DefaultFormalParameter (optional/named params) to get the
      // underlying SimpleFormalParameter.
      final actual = param is DefaultFormalParameter ? param.parameter : param;
      final type = switch (actual) {
        SimpleFormalParameter(:final type?) => type,
        _ => null,
      };
      if (type != null && _containsNullable(type)) {
        reporter.atNode(type, _paramCode);
      }
    }
  }

  static bool _hasOverride(NodeList<Annotation> metadata) {
    return metadata.any((a) => a.name.name == 'override');
  }

  /// Returns true if the type annotation contains any nullable type,
  /// including nested type arguments (e.g. `List<T?>`, `Future<List<T?>>`).
  static bool _containsNullable(TypeAnnotation type) {
    if (type.question != null) return true;

    if (type is NamedType) {
      final typeArgs = type.typeArguments?.arguments;
      if (typeArgs != null) {
        return typeArgs.any(_containsNullable);
      }
    }

    return false;
  }
}