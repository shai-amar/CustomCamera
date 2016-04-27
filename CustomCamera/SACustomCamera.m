//
//  SACustomCamera.m
//  CustomCamera
//
//  Created by Shai Amar on 27/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import "SACustomCamera.h"
#import "SACustomCameraException.h"

@interface SACustomCamera()

@property(nonatomic, getter=isInitComplete)              BOOL isInitComplete;
@property(nonatomic, getter=isBuildCustomCameraComplete) BOOL isBuildCustomCameraComplete;

@end

@implementation SACustomCamera

@synthesize session             = _session;
@synthesize stillImageOutput    = _stillImageOutput;
@synthesize cameraContainerView = _cameraContainerView;
@synthesize frameForCapture     = _frameForCapture;

@synthesize delegate = _delegate;

@synthesize isInitComplete      = _isInitComplete;
@synthesize isBuildCustomCameraComplete = _isBuildCustomCameraComplete;

- (id) initWithCameraContainerView:(UIView *)cameraContainerView frameForCapture:(UIView *)frameForCapture
{
    self = [super init];
    
    if(self)
    {
        self.session                = [[AVCaptureSession alloc] init];
        self.stillImageOutput       = [[AVCaptureStillImageOutput alloc] init];
        self.cameraContainerView    = cameraContainerView;
        self.frameForCapture        = frameForCapture;
        self.isInitComplete              = YES;
        self.isBuildCustomCameraComplete = NO;
    }
    
    return self;
}

- (void)buildCustomCamera
{
    if(!self.isInitComplete)
    {
        SACustomCameraException *e = [[SACustomCameraException alloc] initWithName:@"init process did not finished" reason:@"please init the method first" userInfo:nil];
        @throw e;
    }
    
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError              *error;
    AVCaptureDevice      *inputDevice   = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput   = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([self.session canAddInput:deviceInput]) {
        [self changeCameraSource];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [self.cameraContainerView layer];
    
    [rootLayer setMasksToBounds:YES];
    
    CGRect frame = self.frameForCapture.frame;
    [previewLayer setFrame:frame];
    
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
    
    self.isBuildCustomCameraComplete = YES;
}


- (void) changeCameraSource {
    
    //  Indicate that some changes will be made to the session
    [self.session beginConfiguration];
        
    //  Get the new input
    AVCaptureDevice *newCamera = nil;
    newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    
    //Add input to session
    NSError *err = nil;
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
    if(!newVideoInput || err)
    {
        NSLog(@"Error creating capture device input: %@", err.localizedDescription);
    }
    else
    {
        [self.session addInput:newVideoInput];
    }
    
    
    //  Commit all the configuration changes at once
    [self.session commitConfiguration];
}


/**
 Find a camera with the specified AVCaptureDevicePosition, returning nil 
 if one is not found
**/
 - (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}


/**
 This method takes a photo and return back a JPEG image
 
 **/
- (void)takePhoto
{
    if(self.isBuildCustomCameraComplete == NO)
    {
        SACustomCameraException *e = [[SACustomCameraException alloc] initWithName:@"Build Custom Camera is not complete"
                                                                            reason:@"Please check if you activate the buildCustomCamera method"
                                                                          userInfo:nil];
        @throw e;
    }
    
    AVCaptureConnection *videoConnection = nil;
    
    //  This loop is essentially for error checking. It actually does not know if it has more than 1 connection so it verifies it.
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        
        if(videoConnection) {
            break;
        }
    }
    
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //  If there is some error for some reason...
        if(error) {
            SACustomCameraException *e = [[SACustomCameraException alloc] initWithName:@"Error while creating image"
                                                                               reason:[error localizedDescription]
                                                                             userInfo:nil];
            @throw e;
        }
        
        //  In case there is an image
        if(imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [UIImage imageWithData:imageData];

            [self.delegate handleCameraPhotoWithImage:image];
        }
        else {
            SACustomCameraException *e = [[SACustomCameraException alloc] initWithName:@"Image is nil"
                                                                                reason:@"The data sampler buffer does not contain any image"
                                                                              userInfo:nil];
            @throw e;
        }
        
    }];
    
    
}





@end
