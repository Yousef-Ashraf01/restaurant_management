import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;
  final bool showLottieDialogIfOffline;
  const NetworkListener({
    required this.child,
    this.showLottieDialogIfOffline = false,
    super.key,
  });

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  bool _lottieShown = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, bool>(
      listener: (context, connected) async {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger == null) return; // لو مفيش Scaffold، مانعملش حاجة

        if (!connected) {
          messenger.showMaterialBanner(
            MaterialBanner(
              content: const Text(
                'No internet connection — please connect to the internet',
              ),
              leading: const Icon(Icons.wifi_off, color: Colors.white),
              backgroundColor: Colors.redAccent,
              actions: [
                TextButton(
                  onPressed: () => messenger.hideCurrentMaterialBanner(),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );

          if (widget.showLottieDialogIfOffline && !_lottieShown) {
            _lottieShown = true;
            showDialog(
              context: context,
              barrierDismissible: true,
              builder:
                  (_) => Center(
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/noInternetConnection.json',
                            width: 140,
                            height: 140,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No internet connection',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
            ).then((_) => _lottieShown = false);
          }
        } else {
          messenger.hideCurrentMaterialBanner();
          messenger.clearSnackBars();
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Back online'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: widget.child,
    );
  }
}
