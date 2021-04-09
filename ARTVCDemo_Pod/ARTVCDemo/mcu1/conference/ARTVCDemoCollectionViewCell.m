//
//  AMCollectionViewCell.m
//  AntMedia
//
//  Created by aspling on 2017/7/20.
//  Copyright © 2017年 aspling. All rights reserved.
//
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "ARTVCDemoCollectionViewCell.h"
#import <APMUtils/APMLog.h>
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "
@implementation ARTVCDemoCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        APM_INFO(@"cell frame:%@",NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor whiteColor];
        //UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100,100)];
        //view.image = [UIImage imageNamed:@"callvideo_answer@2x.PNG"];
        //[self.contentView addSubview:view];
        self.contentView.hidden = NO;
    }
    return self;
}
-(void)dealloc{
    APM_INFO(@"ARTVCDemoCollectionViewCell dealloc");
}
@end
#endif
#endif
