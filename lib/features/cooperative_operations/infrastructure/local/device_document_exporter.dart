import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';

/// The system save dialog and share sheet. Neither needs a storage permission: the manager
/// picks the folder, or the app that receives the file. Any error of the system reads as an
/// unexpected failure, so the screen never stays waiting.
class DeviceDocumentExporter implements DocumentExporter {
  const DeviceDocumentExporter();

  static const _pdf = 'application/pdf';

  @override
  Future<bool> save(DossierFile file) async {
    try {
      final path = await FilePicker.platform.saveFile(
        fileName: file.fileName,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: file.bytes,
      );
      return path != null;
    } on Exception {
      throw const CooperativeUnexpected();
    }
  }

  @override
  Future<void> share(DossierFile file, {required String subject}) async {
    try {
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(file.bytes, mimeType: _pdf, name: file.fileName)],
        fileNameOverrides: [file.fileName],
        subject: subject,
      ));
    } on Exception {
      throw const CooperativeUnexpected();
    }
  }
}
