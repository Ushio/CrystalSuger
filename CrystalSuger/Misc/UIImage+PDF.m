/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */


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
