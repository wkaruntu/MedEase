import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoCallPage extends StatefulWidget {
  final String doctorImageUrl;
  const VideoCallPage({
    super.key,
    required this.doctorImageUrl,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isFrontCameraSelected = true;
  bool _isPermissionGranted = false;
  bool _isMicMuted = false;
  bool _isVideoOff = false;

  String _currentUserName = "Nama Saya";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchCurrentUserNameAndInitialize();
  }

  Future<void> _fetchCurrentUserNameAndInitialize() async {
    await _fetchCurrentUserName();
    _requestPermissionsAndInitializeCamera();
  }

  Future<void> _fetchCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
          _currentUserName = user.displayName!;
        } else if (user != null && user.email != null) {
          _currentUserName = user.email!.split('@').first;
        } else {
          _currentUserName = "Pengguna";
        }
      });
    }
  }

  Future<void> _requestPermissionsAndInitializeCamera() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
        });
      }
      _initializeCamera();
    } else {
      if (mounted) {
        setState(() {
          _isPermissionGranted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin kamera dan mikrofon diperlukan untuk panggilan video.")),
        );
      }
    }
  }

  Future<void> _initializeCamera() async {
    if (!_isPermissionGranted) return;

    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada kamera yang ditemukan.")),
        );
      }
      return;
    }

    CameraDescription selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first);
    _isFrontCameraSelected = selectedCamera.lensDirection == CameraLensDirection.front;

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error inisialisasi kamera: ${e.toString()}")),
        );
      }
      print("Error initializing camera: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  void _toggleMic() {
    setState(() {
      _isMicMuted = !_isMicMuted;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isMicMuted ? "Mikrofon Dimatikan" : "Mikrofon Dinyalakan"), duration: const Duration(seconds: 1)),
      );
    });
  }

  void _toggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isVideoOff ? "Kamera Dimatikan" : "Kamera Dinyalakan"), duration: const Duration(seconds: 1)),
      );
    });
  }

  void _endCall() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.doctorImageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                  color: Colors.black38,
                ),
                child: Image.network(
                  widget.doctorImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black54,
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.width * 0.5,
                          color: Colors.white60,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white38, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: (_isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized && !_isVideoOff && _isPermissionGranted)
                      ? CameraPreview(_cameraController!)
                      : Container(
                          color: Colors.black54,
                          child: Center(
                            child: Icon(
                              _isVideoOff ? Icons.videocam_off_outlined : Icons.no_photography_outlined,
                              color: Colors.white70,
                              size: 40,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: 175,
              right: 20,
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)
                  )
                ),
                child: Text(
                  _currentUserName,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: _toggleVideo,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isVideoOff ? Icons.videocam_off : Icons.videocam,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _endCall,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _toggleMic,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isMicMuted ? Icons.mic_off : Icons.mic,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!_isPermissionGranted && !_isCameraInitialized)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Izin Kamera & Mikrofon Diperlukan",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Untuk menggunakan panggilan video, izinkan akses ke kamera dan mikrofon Anda.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          openAppSettings();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        child: const Text("Buka Pengaturan", style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Batalkan", style: TextStyle(color: Colors.white70)),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}