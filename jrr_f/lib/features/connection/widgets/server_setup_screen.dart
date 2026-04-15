import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_view.dart';
import '../providers/last_server_provider.dart';
import '../providers/server_setup_provider.dart';

@RoutePage()
class ServerSetupScreen extends ConsumerStatefulWidget {
  const ServerSetupScreen({super.key});

  @override
  ConsumerState<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends ConsumerState<ServerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '52199');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _prefill() async {
    if (!mounted || _prefilled) return;
    final data = await ref.read(lastServerProvider.future);
    if (!mounted || data == null) return;
    _prefilled = true;
    _hostController.text = data.host;
    _portController.text = data.port.toString();
    _usernameController.text = data.username;
    if (data.password != null) _passwordController.text = data.password!;
  }

  Future<void> _connect() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(serverSetupFormProvider.notifier)
        .connect(
          host: _hostController.text.trim(),
          port: int.parse(_portController.text.trim()),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final connectState = ref.watch(serverSetupFormProvider);
    final isLoading = connectState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Connect to JRiver')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _hostController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Host',
                      hintText: '192.168.1.100',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(labelText: 'Port'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 1 || n > 65535) {
                        return 'Port must be 1–65535';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(labelText: 'Username'),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _connect(),
                  ),
                  const SizedBox(height: 24),
                  if (connectState is AsyncError) ...[
                    ErrorView(error: connectState.error),
                    const SizedBox(height: 16),
                  ],
                  FilledButton(
                    onPressed: isLoading ? null : _connect,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Connect'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
