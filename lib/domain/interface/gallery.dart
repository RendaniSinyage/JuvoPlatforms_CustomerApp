import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/response/multi_gallery_upload_response.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

abstract class GalleryRepositoryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
      String file, UploadType uploadType);

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
      List<String?> filePaths,
      UploadType uploadType,
      );
}
