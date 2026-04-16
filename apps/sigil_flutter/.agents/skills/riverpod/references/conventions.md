# Riverpod Conventions

## App Setup

```dart
void main() {
  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}
```

## Widget Base Class

Always use `HookConsumerWidget` — access to both hooks and providers:

```dart
class MyScreen extends HookConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for ephemeral state
    final counter = useState(0);

    // Providers for business state
    final user = ref.watch(userProvider);

    return Text('${user.name}: ${counter.value}');
  }
}
```

## Provider Types (hand-written, no codegen)

### Simple value

```dart
final greetingProvider = Provider<String>((ref) {
  return 'Hello';
});
```

### Async value

```dart
final userProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchUser();
});
```

### Notifier (sync state with methods)

```dart
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void reset() => state = 0;
}
```

### AsyncNotifier (async state with methods)

```dart
final todosProvider = AsyncNotifierProvider<TodosNotifier, List<Todo>>(
  TodosNotifier.new,
);

class TodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.fetchAll();
  }

  Future<void> add(Todo todo) async {
    state = const AsyncLoading<List<Todo>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).add(todo);
      return [...state.requireValue, todo];
    });
  }
}
```

### Family (parameterized)

```dart
final postProvider = FutureProvider.family<Post, int>((ref, postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.fetchPost(postId);
});

// Usage: ref.watch(postProvider(42))
```

## Hooks for Ephemeral State

Use hooks for UI-only state that doesn't need to be shared:

```dart
class MyForm extends HookConsumerWidget {
  const MyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isExpanded = useState(false);

    return TextField(controller: controller);
  }
}
```

## AsyncValue Pattern Matching

```dart
final asyncUser = ref.watch(userProvider);

asyncUser.when(
  data: (user) => Text(user.name),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

## Provider + fpdart

When a provider returns an `Either`:

```dart
final validationProvider = Provider.family<Either<Failure, ValidatedInput>, String>(
  (ref, input) {
    return validateInput(input);
  },
);
```
