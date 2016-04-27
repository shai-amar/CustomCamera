//
//  SACustomCamera.h
//  CustomCamera
//
//  Created by Shai Amar on 27/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class SACustomCamera;
@protocol SACustomCameraDelegate

- (void)handleCameraPhotoWithImage:(UIImage *)image;

@end

@interface SACustomCamera : NSObject

@property(strong, nonatomic) AVCaptureSession           *session;
@property(strong, nonatomic) AVCaptureStillImageOutput  *stillImageOutput;
@property(strong, nonatomic) UIView                     *cameraContainerView;
@property(strong, nonatomic) UIView                     *frameForCapture;

@property(assign, nonatomic) id delegate;

- (id) initWithCameraContainerView:(UIView *)cameraContainerView
                   frameForCapture:(UIView *)frameForCapture;

- (void) buildCustomCamera;
- (void)takePhoto;

@end
