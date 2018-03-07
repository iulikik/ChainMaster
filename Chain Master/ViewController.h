#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate>

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lightToggle;

- (IBAction)ToggleLight:(id)sender;
- (IBAction)goButtonPressed:(id)sender;





@end

