
#import "UIImage+PDF.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIImage (PDF)
+ (UIImage *)imageWithPDFDocument:(CGPDFDocumentRef)pdfDocument scale:(float)scale page:(int)pageNumber
{
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNumber);
    
    CGRect boxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    int width = (int)roundf(boxRect.size.width * scale);
    int height = (int)roundf(boxRect.size.height * scale);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextScaleCTM(context, scale, scale);
    CGContextDrawPDFPage(context, page);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)imageWithContentsOfPDF:(NSString *)pdfPath width:(int)width
{
    if(pdfPath == nil)
        return [[UIImage alloc] init];
    
    NSURL *url = [NSURL fileURLWithPath:pdfPath];
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    if(pdfDocument == NULL)
        return [[UIImage alloc] init];
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, 1);
    if(page == nil)
        return [[UIImage alloc] init];
    
    CGRect boxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    float scale = (float)width / boxRect.size.width;
    
    UIImage *image = [UIImage imageWithPDFDocument:pdfDocument scale:scale page:1];
    CGPDFDocumentRelease(pdfDocument);
    pdfDocument = NULL;

    return image;
}
+ (UIImage *)imageWithContentsOfPDF:(NSString *)pdfPath height:(int)height
{
    if(pdfPath == nil)
        return [[UIImage alloc] init];
    
    NSURL *url = [NSURL fileURLWithPath:pdfPath];
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    if(pdfDocument == NULL)
        return [[UIImage alloc] init];
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, 1);
    if(page == nil)
        return [[UIImage alloc] init];
    
    CGRect boxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    float scale = (float)height / boxRect.size.height;
    
    UIImage *image = [UIImage imageWithPDFDocument:pdfDocument scale:scale page:1];
    CGPDFDocumentRelease(pdfDocument);
    pdfDocument = NULL;
    
    return image;
}
@end
