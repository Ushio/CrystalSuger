#import <GLKit/GLKit.h>
@protocol USKCameraProtocol <NSObject>
@required
@property (nonatomic, readonly) GLKMatrix4 view;
@property (nonatomic, readonly) GLKMatrix4 proj;
@property (nonatomic, readonly) GLKVector3 position;
@end
