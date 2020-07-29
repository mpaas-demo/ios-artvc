//
//  DemoViewController.m
//  ARTVCDemo_Plugin
//
//  Created by 阔悬 on 2020/07/29.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Hello World!";
    label.font = [UIFont systemFontOfSize:26];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    label.center = CGPointMake(self.view.frame.size.width / 2, 0.4 * self.view.frame.size.height);
    [self.view addSubview:label];
}


@end
