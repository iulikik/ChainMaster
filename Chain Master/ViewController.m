#import <Foundation/Foundation.h>
#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNetworkCommunication];
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

- (void)sendMovementActionToController:(UISegmentedControl *) segmentedControl {
    UISegmentedControl *button = ((UISegmentedControl*)segmentedControl);
    long tag = button.tag;
    
    if(button.selectedSegmentIndex == 0) {
        [self writeOutputStreamWithTag:tag command:@"UP"];
    } else if(button.selectedSegmentIndex == 2) {
        [self writeOutputStreamWithTag:tag command:@"DOWN"];
    }
}

- (void)writeOutputStreamWithTag:(long)tag command:(NSString *)command {
    NSString *response  = [NSString stringWithFormat:@"Motor%ld%@", tag , command];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
    NSLog(@"%@", response);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)eventt {
    // TODO we should collect all data from seg controller when the touch was initiated
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_goButton.frame, touchLocation)) {
        //this should be called continously while keeping go button pressed
        NSLog(@" touched");
        [self sendMovementActionToController:_seg1];
        [self sendMovementActionToController:_seg2];
        [self sendMovementActionToController:_seg3];
        [self sendMovementActionToController:_seg4];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self writeOutputStreamWithTag:_seg1.tag command:@"STOP"];
    [self writeOutputStreamWithTag:_seg2.tag command:@"STOP"];
    [self writeOutputStreamWithTag:_seg3.tag command:@"STOP"];
    [self writeOutputStreamWithTag:_seg4.tag command:@"STOP"];
}

@end
