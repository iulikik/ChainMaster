//
//  ViewController.m
//  Chain Master
//
//  Created by IULIAN MORARI on 1/31/18.
//  Copyright © 2018 Ik Moraru. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, CMMotorCommand) {
    CMMotorCommandUp = 0,
    CMMotorCommandStop = 1,
    CMMotorCommandDown = 2
};

typedef NS_ENUM(NSUInteger, CMMotorID) {
    CMMotorID1 = 1,
    CMMotorID2 = 2,
    CMMotorID3 = 3,
    CMMotorID4 = 4
};

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (strong, atomic) NSMutableDictionary *commands;

@end

@implementation ViewController

+ (NSString*) stringForCommand:(CMMotorCommand)command {
    NSString *string = @"STOP";
    
    switch (command) {
        case CMMotorCommandStop:
            string = @"STOP";
            break;
            
        case CMMotorCommandUp:
            string = @"UP";
            break;
            
        case CMMotorCommandDown:
            string = @"DOWN";
            break;
            
        default:
            break;
    }
    
    return string;
}

+ (NSString*) stringForMotorID:(CMMotorID)motorID {
    NSString *string = @"0";
    
    switch (motorID) {
        case CMMotorID1:
            string = @"Motor1";
            break;
            
        case CMMotorID2:
            string = @"Motor2";
            break;
            
        case CMMotorID3:
            string = @"Motor3";
            break;
            
        case CMMotorID4:
            string = @"Motor4";
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNetworkCommunication];
    
    NSString* stopCommand = [ViewController stringForCommand:CMMotorCommandStop];
    
    self.commands = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                    [ViewController stringForMotorID:CMMotorID1]: stopCommand,
                                                                    [ViewController stringForMotorID:CMMotorID1]: stopCommand,
                                                                    [ViewController stringForMotorID:CMMotorID1]: stopCommand,
                                                                    [ViewController stringForMotorID:CMMotorID1]: stopCommand,
                                                                    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.39", 7777, &readStream, &writeStream);
    _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}

- (IBAction)ToggleLight:(id)sender {
    
    UISegmentedControl *button = ((UISegmentedControl*)sender);
    CMMotorID motorID = button.tag;
    CMMotorCommand command = button.selectedSegmentIndex;
    NSString* commandString = [ViewController stringForCommand:command];
    NSString* motorIDString = [ViewController stringForMotorID:motorID];
    
    self.commands[motorIDString] = commandString;
}

- (void)sendCommand:(NSString*)command toMotor:(NSString*)motorID {
    NSString *response  = [NSString stringWithFormat:@"%@%@", motorID , command];
    
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    
    NSLog(@"%@", response);
}

- (IBAction)goButtonPressed:(id)sender {
    NSLog(@"Sending command to control unit...");
    
    for (NSString *key in _commands) {
        NSString *commandValue = _commands[key];
        
        [self sendCommand:commandValue toMotor:key];
    };
    
    NSLog(@"Commands were sent!");
}

@end

