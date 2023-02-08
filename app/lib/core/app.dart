import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:rally_app/generated/api.pbgrpc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _echo(EchoRequest req) async {
    final channel = getChannel();

    try {
      final response =
          await ApiServiceClient(channel).echo(req, options: CallOptions());

      print('Greeter client received: ${response.message}');
    } catch (e) {
      print('Caught error: $e');
    }

    await channel.shutdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            child: const Text('Test'),
            onPressed: () {
              _echo(EchoRequest()..message = 'aaaaaaaaaaa');
            },
          ),
        ],
      ),
    );
  }
}

ClientChannel getChannel() {
  return ClientChannel(
    'localhost',
    port: 3000,
    options: ChannelOptions(
      credentials: const ChannelCredentials.insecure(),
      codecRegistry: CodecRegistry(codecs: const [IdentityCodec()]),
    ),
  );
}
