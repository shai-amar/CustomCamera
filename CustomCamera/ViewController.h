//
//  ViewController.h
//  CustomCamera
//
//  Created by Shai Amar on 26/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACustomCamera.h"

@interface ViewController : UIViewController<SACustomCameraDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;



@end

