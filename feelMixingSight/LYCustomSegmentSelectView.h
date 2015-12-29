//
//  LYCustomSegmentSelectView.h
//  feelMixingSight
//
//  Created by LiYan on 15/12/28.
//  Copyright © 2015年 LiYan. All rights reserved.
//

/**
 *  可用的轮子
 *
 *  自定义的segmentControl
 *  参考自: https://github.com/lizelu/ZLCustomeSegmentControlView
 */

#import <Foundation/Foundation.h>
typedef void(^ButtonOnClickBlock)(NSInteger tag, NSString *title);

#import <UIKit/UIKit.h>

@interface LYCustomSegmentSelectView : UIView

@property (nonatomic, strong) NSArray *titles;                      //标题数组
@property (nonatomic, strong) UIColor *titlesCustomColor;          //标题的常规颜色
@property (nonatomic, strong) UIColor *titlesHighLightColor;      //标题高亮颜色
@property (nonatomic, strong) UIColor *backgroundHighLightColor;  //高亮时的颜色
@property (nonatomic, strong) UIFont *titlesFont;                   //标题的字号
@property (nonatomic, assign) CGFloat duration;

/**
 *  点击按钮的回调
 *
 *  @param block 点击按钮的Block
 */
-(void) setButtonOnClickBlock: (ButtonOnClickBlock) block;


@end
