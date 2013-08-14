#import <UIKit/UIKit.h>

@interface UIImage (PDF)
+ (UIImage *)imageWithContentsOfPDF:(NSString *)pdfPath width:(int)width;
+ (UIImage *)imageWithContentsOfPDF:(NSString *)pdfPath height:(int)height;
@end
