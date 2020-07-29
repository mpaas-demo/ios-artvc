//
//  AMImageSaver.h
//  AntMedia
//
//  Created by klaus zhang on 2018/7/12.
//  Copyright © 2018年 aspling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMImageSaver : NSObject
+ (void)save:(UIImage*)image toAlbum:(NSString*)album;
@end
