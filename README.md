# View Model

A ViewModel and Flow based state management package (inspired by Android ViewModel) make it easy to implement the MVVM pattern.

## Features

- Android Like View Model
- Easy to implement
- Powerful
- StateFlow (equivalent to LiveData)
- SharedFlow

## Getting started
```
flutter pub add viewmodel
```

## Usage

### my_view_model.dart
```

```
OR
```
final controller = MultiImagePickerController(
  maxImages: 15,
  allowedImageTypes: ['png', 'jpg', 'jpeg'],
  images: <ImageFile>[] // array of pre/default selected images
);
```

### UI Implementation
```
MultiImagePickerView(
  controller: controller,
  padding: const EdgeInsets.all(10),
);
```
OR
```
MultiImagePickerView(
  controller: controller,
  initialContainerBuilder: (context, pickerCallback) {
    // return custom initial widget which should call the pickerCallback when user clicks on it
  },
  itemBuilder: (context, image, removeCallback) {
    // return custom card for image and remove button which also calls removeCallback on click
  },
  addMoreBuilder: (context, pickerCallback) {
    // return custom card or item widget which should call the pickerCallback when user clicks on it
  },
  gridDelegate: /* Your SliverGridDelegate */,
  draggable: /* true or false, images can be reorderd by dragging by user or not, default true */,
  onDragBoxDecoration: /* BoxDecoration when item is dragging */,
  onChange: (images) {
    // callback to update images
  },
);
```

### Get Picked Images
Picked Images can be get from controller.
```
final images = controller.images; // return Iterable<ImageFile>
for (final image in images) {
  if (image.hasPath)
    request.addFile(File(image.path!));
  else 
    request.addFile(File.fromRawPath(image.bytes!));
}
request.send();
```
Also contoller can perform more actions.
```
controller.pickImages();
controller.hasNoImages; // return bool
controller.maxImages; // return maxImages
controller.allowedImageTypes; // return allowedImageTypes
controller.removeImage(imageFile); // remove image from the images
controller.reOrderImage(oldIndex, newIndex); // reorder the image
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


