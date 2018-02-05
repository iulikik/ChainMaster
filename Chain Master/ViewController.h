//
//  ViewController.h
//  Chain Master
//
//  Created by IULIAN MORARI on 1/31/18.
//  Copyright © 2018 Ik Moraru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate>

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lightToggle;

- (IBAction)ToggleLight:(id)sender;
- (IBAction)goButtonPressed:(id)sender;

@end

