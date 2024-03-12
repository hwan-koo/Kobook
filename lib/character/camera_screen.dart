import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _hasPermission = false;
  late FlashMode _flashMode;
  bool _isSelfieMode = false;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0], ResolutionPreset.medium,
      // imageFormatGroup: ImageFormatGroup.yuv420
    );

    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    if (!cameraDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  var isLoading = false;
  void _onTakePicture() async {
    setState(() {
      isLoading = true;
    });
    final image = await _cameraController.takePicture();

    Navigator.pop(context, image);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: !_hasPermission || !_cameraController.value.isInitialized
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator.adaptive()],
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CameraPreview(_cameraController)),
                          Positioned(
                            right: 20,
                            child: Column(
                              children: [
                                IconButton(
                                  color: Colors.white,
                                  onPressed: _toggleSelfieMode,
                                  icon: const Icon(
                                    Icons.cameraswitch,
                                  ),
                                ),
                                IconButton(
                                  color: _flashMode == FlashMode.off
                                      ? Colors.amber.shade200
                                      : Colors.white,
                                  onPressed: () => _setFlashMode(FlashMode.off),
                                  icon: const Icon(
                                    Icons.flash_off_rounded,
                                  ),
                                ),
                                IconButton(
                                  color: _flashMode == FlashMode.always
                                      ? Colors.amber.shade200
                                      : Colors.white,
                                  onPressed: () =>
                                      _setFlashMode(FlashMode.always),
                                  icon: const Icon(
                                    Icons.flash_on_rounded,
                                  ),
                                ),
                                IconButton(
                                  color: _flashMode == FlashMode.auto
                                      ? Colors.amber.shade200
                                      : Colors.white,
                                  onPressed: () =>
                                      _setFlashMode(FlashMode.auto),
                                  icon: const Icon(
                                    Icons.flash_auto_rounded,
                                  ),
                                ),
                                IconButton(
                                  color: _flashMode == FlashMode.torch
                                      ? Colors.amber.shade200
                                      : Colors.white,
                                  onPressed: () =>
                                      _setFlashMode(FlashMode.torch),
                                  icon: const Icon(
                                    Icons.flashlight_on_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 1 / 2 - 50,
                      bottom: MediaQuery.of(context).size.height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _onTakePicture();
                            },
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              alignment: Alignment.center,
                              width: 100,
                              height: 100,
                              child: const FaIcon(
                                FontAwesomeIcons.camera,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? Stack(
                            children: [
                              const Opacity(
                                opacity: 0.5,
                                child: ModalBarrier(
                                    dismissible: false, color: Colors.black),
                              ),
                              Center(
                                child: SpinKitSpinningCircle(
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Image.asset("assets/turtle.png"),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
        ),
      ),
    );
  }
}
