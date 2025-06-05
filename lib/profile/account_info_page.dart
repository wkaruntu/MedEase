import 'dart:io'; // Untuk File
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      if (displayName != null && displayName != user.displayName) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null && photoURL != user.photoURL) {
        await user.updatePhotoURL(photoURL);
      }
      await user.reload();
    } catch (e) {
      print("Error updating profile: $e");
      throw e;
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$userId.jpg');
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }

  Future<void> updateEmail(String newEmail, BuildContext context) async {
    try {
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email verifikasi telah dikirim ke $newEmail. Silakan cek email Anda untuk menyelesaikan perubahan."), backgroundColor: Colors.green, duration: const Duration(seconds: 5)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui email: ${e.message}"), backgroundColor: Colors.red),
      );
      print("Error updating email: $e");
    }
  }
}

class AccountInfoPage extends StatefulWidget {
  final String initialName;
  final String initialPhoneNumber;
  final String initialEmail;

  const AccountInfoPage({
    super.key,
    required this.initialName,
    required this.initialPhoneNumber,
    required this.initialEmail,
  });

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  File? _selectedImageFile;
  String? _currentPhotoURL;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _firebaseService.currentUser?.displayName ?? widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
    _emailController = TextEditingController(text: _firebaseService.currentUser?.email ?? widget.initialEmail);
    _currentPhotoURL = _firebaseService.currentUser?.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_isEditing) return;
    try {
      final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80, maxWidth: 800);
      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memilih gambar: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfileChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploadingPhoto = _selectedImageFile != null;
    });

    String? newPhotoURL;
    User? currentUser = _firebaseService.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengguna tidak ditemukan. Silakan login ulang."), backgroundColor: Colors.red),
      );
      setState(() { _isUploadingPhoto = false; });
      return;
    }

    try {
      if (_selectedImageFile != null) {
        newPhotoURL = await _firebaseService.uploadProfileImage(_selectedImageFile!, currentUser.uid);
        if (newPhotoURL != null) {
          setState(() {
            _currentPhotoURL = newPhotoURL;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gagal mengunggah foto profil."), backgroundColor: Colors.red),
            );
          }
          setState(() { _isUploadingPhoto = false; });
          return;
        }
      }

      String newDisplayName = _nameController.text;
      bool nameChanged = newDisplayName != currentUser.displayName;
      bool photoChanged = newPhotoURL != null && newPhotoURL != currentUser.photoURL;

      if (nameChanged || photoChanged) {
        await _firebaseService.updateProfile(
          displayName: nameChanged ? newDisplayName : null,
          photoURL: photoChanged ? newPhotoURL : null,
        );
      }

      if (_emailController.text != currentUser.email) {
        bool confirmUpdate = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Konfirmasi Perubahan Email"),
            content: Text("Email verifikasi akan dikirim ke ${_emailController.text}. Anda perlu memverifikasi email baru untuk menyelesaikan perubahan. Lanjutkan?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Batal")),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Lanjutkan")),
            ],
          ),
        ) ?? false;

        if (confirmUpdate) {
          await _firebaseService.updateEmail(_emailController.text, context);
        }
      }

      setState(() {
        _isEditing = false;
        _selectedImageFile = null;
        _isUploadingPhoto = false;
        _nameController.text = _firebaseService.currentUser?.displayName ?? widget.initialName;
        _emailController.text = _firebaseService.currentUser?.email ?? widget.initialEmail;
        _currentPhotoURL = _firebaseService.currentUser?.photoURL;

      });

      if (mounted) {
        String message = "Perubahan profil disimpan.";
        if (nameChanged && photoChanged) message = "Nama dan foto profil berhasil diperbarui.";
        else if (nameChanged) message = "Nama berhasil diperbarui.";
        else if (photoChanged) message = "Foto profil berhasil diperbarui.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
      }

    } catch (e) {
       print("Error saving profile: $e");
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan perubahan: $e"), backgroundColor: Colors.red),
        );
      }
       setState(() { _isUploadingPhoto = false; });
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Informasi Akun",
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _selectedImageFile != null
                        ? FileImage(_selectedImageFile!)
                        : (_currentPhotoURL != null && _currentPhotoURL!.isNotEmpty
                            ? NetworkImage(_currentPhotoURL!)
                            : null) as ImageProvider?,
                    child: _selectedImageFile == null && (_currentPhotoURL == null || _currentPhotoURL!.isEmpty)
                        ? Icon(Icons.person, size: 60, color: Colors.grey.shade700)
                        : null,
                  ),
                  if (_isEditing)
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.primaryColor.withOpacity(0.9),
                          child: _isUploadingPhoto
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader("Data Profil", theme),
            _buildInfoField(
              label: "Nama Lengkap",
              controller: _nameController,
              isEditing: _isEditing,
              theme: theme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                if (value.length < 3) {
                  return 'Nama minimal 3 karakter';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: "Nomor Telepon",
              controller: _phoneController,
              isEditing: _isEditing,
              theme: theme,
              keyboardType: TextInputType.phone,
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (!RegExp(r'^[0-9,-]{10,15}$').hasMatch(value)) {
                  return 'Format nomor telepon tidak valid';
                }
                return null;
              },
            ),
            _buildInfoField(
              label: "Email",
              controller: _emailController,
              isEditing: _isEditing,
              theme: theme,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (!_isEditing)
              Center(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.edit_outlined, size: 20, color: theme.primaryColor),
                  label: Text("Edit Profil", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    side: BorderSide(color: theme.primaryColor.withOpacity(0.7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            if (_isEditing)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _isUploadingPhoto ? null : _saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: _isUploadingPhoto
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Text("Simpan"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextButton(
                      onPressed: (){
                          setState(() {
                            _isEditing = false;
                            _selectedImageFile = null;
                            _nameController.text = _firebaseService.currentUser?.displayName ?? widget.initialName;
                            _phoneController.text = widget.initialPhoneNumber;
                            _emailController.text = _firebaseService.currentUser?.email ?? widget.initialEmail;
                          });
                        },
                      child: Text("Batal", style: TextStyle(color: Colors.grey[700])),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnlyWhileNotEditing = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          isEditing
              ? TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: TextStyle(fontSize: 15, color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: validator,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[200]?.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    controller.text.isEmpty && label == "Nomor Telepon" ? "-" : (controller.text.isEmpty ? "-" : controller.text),
                    style: TextStyle(fontSize: 15, color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
                  ),
                ),
        ],
      ),
    );
  }
}