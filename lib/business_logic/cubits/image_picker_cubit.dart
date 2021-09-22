import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<XFile?> {
  ImagePickerCubit({required this.picker}) : super(null);

  final ImagePicker picker;

  getFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 520,
      maxHeight: 520,
    );
    emit(image);
  }

  getFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 520,
      maxHeight: 520,
    );
    emit(image);
  }
}
