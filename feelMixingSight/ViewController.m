//
//  ViewController.m
//  feelMixingSight
//
//  Created by LiYan on 15/12/28.
//  Copyright © 2015年 LiYan. All rights reserved.
//

#import "ViewController.h"
#import "LYCustomSegmentSelectView.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LYCustomSegmentSelectView *ss = [[LYCustomSegmentSelectView alloc]initWithFrame:CGRectMake(0, 50, 320, 50)];
    ss.backgroundColor = [UIColor whiteColor];
    ss.backgroundHighLightColor = [UIColor blueColor];
    ss.titlesCustomColor = [UIColor blackColor];
    ss.titles = @[@"aaa",@"bbb",@"ccc",@"ddd"];
    ss.titlesHighLightColor = [UIColor whiteColor];
    ss.titlesFont = [UIFont systemFontOfSize:19];
    ss.duration = 3.0f;
    
    [ss setButtonOnClickBlock:^(NSInteger tag, NSString *title) {
        NSLog(@"index = %ld, title = %@", (long)tag, title);
    }];
    
    [self.view addSubview:ss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
