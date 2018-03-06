#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSStreamDelegate>

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;






@end

