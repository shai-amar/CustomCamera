//
//  ViewController.m
//  CustomCamera
//
//  Created by Shai Amar on 26/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import "ViewController.h"
#import "SACustomCamera.h"
#import "SACustomCameraException.h"


@interface ViewController ()

@property(nonatomic, strong) SACustomCamera *customCamera;

@end

@implementation ViewController

@synthesize customCamera = _customCamera;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customCamera = [[SACustomCamera alloc] initWithCameraContainerView:self.containerView
                                                            frameForCapture:self.frameForCapture];
    self.customCamera.delegate = self;
    [self.customCamera buildCustomCamera];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
}


- (IBAction)takePhoto:(id)sender {
    
    //self.imageView.image = [self.customCamera takePhoto];
    [self.customCamera takePhoto];
    
}

- (void)handleCameraPhotoWithImage:(UIImage *)image
{
    self.imageView.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
