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

@implementation ViewController {
    NSDictionary* allStopDict;
}

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
                                                                    [ViewController stringForMotorID:CMMotorID2]: stopCommand,
                                                                    [ViewController stringForMotorID:CMMotorID3]: stopCommand,
                                                                    [ViewController stringForMotorID:CMMotorID4]: stopCommand,
                                                                    }];
    
    allStopDict = @{
                    [ViewController stringForMotorID:CMMotorID1]: stopCommand,
                    [ViewController stringForMotorID:CMMotorID2]: stopCommand,
                    [ViewController stringForMotorID:CMMotorID3]: stopCommand,
                    [ViewController stringForMotorID:CMMotorID4]: stopCommand,
                    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.0.199", 7777, &readStream, &writeStream);
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
    NSString *commandToSend  = [NSString stringWithFormat:@"%@%@", motorID , command];
    
    NSData *data = [[NSData alloc] initWithData:[commandToSend dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    
    NSLog(@"%@", commandToSend);
}

- (IBAction)goButtonPressed:(id)sender {
    for (NSString *key in allStopDict) {
        NSString *commandValue = allStopDict[key];
        
        [self sendCommand:commandValue toMotor:key];
    };
}

- (IBAction)goPressed:(id)sender {
    
    for (NSString *key in self.commands) {
        NSString *commandValue = self.commands[key];
        
        [self sendCommand:commandValue toMotor:key];
    };
}

- (IBAction)goUnpressed:(id)sender {
    [self goButtonPressed:self];
}


@end

