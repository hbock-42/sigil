# UI Conventions

## Widget Library: Forui

This project uses [Forui](https://pub.dev/packages/forui) — a minimalist Flutter UI library with 40+ widgets and built-in theming.

## App Setup

```dart
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // .touch for mobile, .desktop for desktop — picks platform-appropriate sizing
    final theme = FThemes.zinc.dark.touch; // or FThemes.zinc.light.touch

    return WidgetsApp(
      color: theme.colors.background,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      builder: (_, __) => FTheme(
        data: theme,
        child: const FToaster(child: MyHomePage()),
      ),
    );
  }
}
```

Key points:
- Uses `WidgetsApp` (not `MaterialApp` or `CupertinoApp`) — no Material dependency
- `FTheme` in the builder provides Forui theme data to all descendants
- `FToaster` enables toast notifications
- `FLocalizations` for i18n support

## Component Mapping (Material → Forui)

| Material | Forui | Notes |
|----------|-------|-------|
| `Scaffold` | `FScaffold` | Accepts `header`, `footer`, `sidebar`, `child` |
| `AppBar` | `FHeader` | Use `title`, `prefixes`, `suffixes` for actions |
| `Card` | `FCard` | Accepts `title`, `subtitle`, `child`, `image` |
| `ElevatedButton` | `FButton` | Variants: `primary`, `secondary`, `destructive`, `outline`, `ghost` |
| `IconButton` | `FButton.icon` | Icon-only button |
| `BottomNavigationBar` | `FBottomNavigationBar` | With `FBottomNavigationBarItem` children |
| `TextField` | `FTextField` | With `label`, `hint` |
| `Divider` | `FDivider` | — |
| `CircleAvatar` | `FAvatar` | — |
| `Dialog` | `FDialog` | — |
| `NavigationRail` / `Drawer` | `FSidebar` | With `FSidebarGroup` + `FSidebarItem` |

## Theming

### Built-in themes
- `FThemes.zinc.dark.touch` / `FThemes.zinc.light.touch` — zinc palette for mobile
- `FThemes.zinc.dark.desktop` / `FThemes.zinc.light.desktop` — zinc palette for desktop
- Custom themes via CLI: `dart run forui theme create [template]`

### Accessing theme in widgets
```dart
// Via context extension
final colors = context.theme.colors;
final typography = context.theme.typography;

// Colors
context.theme.colors.foreground
context.theme.colors.mutedForeground
context.theme.colors.background

// Typography (Tailwind-style sizes)
context.theme.typography.xs   // extra small
context.theme.typography.sm   // small
context.theme.typography.md   // medium (default body)
context.theme.typography.lg   // large
context.theme.typography.xl   // extra large
// Also: xs2, xs3, xl2..xl8
```

## FScaffold Structure

```dart
FScaffold(
  header: FHeader(
    title: const Text('Dashboard'),
    suffixes: [
      FHeaderAction(icon: const Icon(FIcons.ellipsis), onPress: () {}),
    ],
  ),
  footer: FBottomNavigationBar(...),  // optional
  sidebar: FSidebar(...),             // optional
  child: const MyContent(),
)
```

## FButton Variants

```dart
// Primary (default)
FButton(onPress: () {}, child: const Text('Primary'))

// With icon prefix
FButton(
  onPress: () {},
  prefix: const Icon(FIcons.plus),
  child: const Text('Add'),
)

// Variants: primary, secondary, destructive, outline, ghost
FButton(variant: FButtonVariant.outline, onPress: () {}, child: const Text('Outline'))

// Icon-only
FButton.icon(onPress: () {}, child: const Icon(FIcons.settings))
```

## Icons

Forui provides `FIcons` — a set of Lucide icons:
```dart
const Icon(FIcons.house)
const Icon(FIcons.settings)
const Icon(FIcons.search)
const Icon(FIcons.plus)
const Icon(FIcons.ellipsis)
```

## Layout Patterns

- Use `SingleChildScrollView` + `Column` for scrollable pages
- Use `Wrap` or `Row` with `Expanded`/`Flexible` for responsive layouts
- Keep widget tree depth ≤ 5 levels — extract helper widgets
- Use `const` constructors wherever possible
