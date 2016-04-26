//
//  ViewController.h
//  CustomCamera
//
//  Created by Shai Amar on 26/04/2016.
//  Copyright © 2016 Shai Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;



@end

