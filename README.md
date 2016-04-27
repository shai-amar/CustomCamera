# CustomCamera
Learn how to create a custom Camera UI and manipulate it

The basic characteristics are that it works currently only on the front camera. In the future I'll add a selection option for the user between the front and back camera.

## Setup

Add the following to the viewDidLoad method:

self.customCamera = [[SACustomCamera alloc] initWithCameraContainerView:self.containerView
                                                            frameForCapture:self.frameForCapture];
    self.customCamera.delegate = self;
    [self.customCamera buildCustomCamera];


Implement the custom camera delegated method:

- (void)handleCameraPhotoWithImage:(UIImage *)image
{
    // Do whatever you want to do with the image...
}
