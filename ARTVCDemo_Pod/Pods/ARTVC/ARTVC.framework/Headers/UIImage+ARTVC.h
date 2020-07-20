//
//  UIImage+ARTVC.h
//  AntMedia
//
//  Created by klaus zhang on 2018/7/17.
//  Copyright © 2018年 aspling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ARTVC)
+(UIImage*)imageFromNV12CVPixelBufferRef:(CVPixelBufferRef)pbref rotation:(int)rotation mirror:(BOOL)mirror;
+ (UIImage *)fixOrientation_artvc:(UIImage *)aImage;
-(NSString*)jpegBase64EncodedString;
@end
