#import <Foundation/Foundation.h>
#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg4;

@property (nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [self initNetworkCommunication];
}

#pragma mark connection
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

#pragma mark Touch interaction
- (IBAction)theTouchDown:(id)sender {
  NSLog(@"start touch");
  _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startControllerActions) userInfo:nil repeats:true];
}

- (IBAction)theTouchUpInside:(id)sender {
  NSLog(@"end touch");
  [_timer invalidate];
  _timer = nil;
  
  [self stopControllerActions];
}

- (void)startControllerActions {
  [self sendMovementActionToController:_seg1];
  [self sendMovementActionToController:_seg2];
  [self sendMovementActionToController:_seg3];
  [self sendMovementActionToController:_seg4];
}

- (void)stopControllerActions {
  [self writeOutputStreamWithTag:_seg1.tag command:@"STOP"];
  [self writeOutputStreamWithTag:_seg2.tag command:@"STOP"];
  [self writeOutputStreamWithTag:_seg3.tag command:@"STOP"];
  [self writeOutputStreamWithTag:_seg4.tag command:@"STOP"];
}

#pragma mark formatting methods
- (void)sendMovementActionToController:(UISegmentedControl *) segmentedControl {
  UISegmentedControl *button = ((UISegmentedControl*)segmentedControl);
  long tag = button.tag;
//  NSLog(@"hshshhs %ld tag-> %ld", button.selectedSegmentIndex, tag );
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

@end
