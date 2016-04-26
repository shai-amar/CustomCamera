//
//  ViewController.m
//  CustomCamera
//
//  Created by Shai Amar on 26/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated {
    //  TODO: See how to handle this variable as in an API
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    
    NSError *error;
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([session canAddInput:deviceInput]) {
        //[session addInput:deviceInput];
        [self changeCameraSource];
    }
    
    AVCaptureVideoPreviewLayer *previewLauer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    [previewLauer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    
    //  TODO: See how to add this variable to the method
    CGRect frame = self.frameForCapture.frame;
    [previewLauer setFrame:frame];
    
    [rootLayer insertSublayer:previewLauer atIndex:0];
    
    //  TODO: See how to handle this variable as in an API
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
    
    
}

- (void) changeCameraSource {
    
    //  Indicate that some changes will be made to the session
    [session beginConfiguration];
    
    //  Remove existing input
    //AVCaptureInput* currentCameraInput = [session.inputs objectAtIndex:0];
    
    //  Get the new input
    AVCaptureDevice *newCamera = nil;
//    if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
//    {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }
//    else
//    {
//        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }
    
    //Add input to session
    NSError *err = nil;
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
    if(!newVideoInput || err)
    {
        NSLog(@"Error creating capture device input: %@", err.localizedDescription);
    }
    else
    {
        [session addInput:newVideoInput];
    }
    
    
    //  Commit all the configuration changes at once
    [session commitConfiguration];
}


// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (IBAction)takePhoto:(id)sender {
    
    AVCaptureConnection *videoConnection = nil;
    
    //  This loop is essentially for error checking. It actually does not know if it has more than 1 connection so it verifies it.
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
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
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //  If there is some error for some reason...
        if(error) {
            
        }
        
        //  In case there is an image
        if(imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            //  TODO: See how to handle this variable as in an API
            self.imageView.image = image;

        }
        
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/****************************************************************/
//-(IBAction)switchCameraTapped:(id)sender
//{
//    //Change camera source
//    if(_captureSession)
//    {
//        //Indicate that some changes will be made to the session
//        [_captureSession beginConfiguration];
//        
//        //Remove existing input
//        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
//        [_captureSession removeInput:currentCameraInput];
//        
//        //Get new input
//        AVCaptureDevice *newCamera = nil;
//        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
//        {
//            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//        }
//        else
//        {
//            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//        }
//        
//        //Add input to session
//        NSError *err = nil;
//        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
//        if(!newVideoInput || err)
//        {
//            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
//        }
//        else
//        {
//            [_captureSession addInput:newVideoInput];
//        }
//        
//        //Commit all the configuration changes at once
//        [_captureSession commitConfiguration];
//    }
//}
/****************************************************************/




@end
