//
//  LYCustomSegmentSelectView.m
//  feelMixingSight
//
//  Created by LiYan on 15/12/28.
//  Copyright © 2015年 LiYan. All rights reserved.
//

#define DEFAULT_TITLE_FONT 20.0f
#define DEFAULT_DURATION 3.0f

#import "LYCustomSegmentSelectView.h"

@interface LYCustomSegmentSelectView ()

@property (nonatomic, assign)CGFloat viewWidth;  //组件宽度
@property (nonatomic, assign)CGFloat viewHeight; //组件高度
@property (nonatomic, assign)CGFloat labelWidth; //label宽度

@property (nonatomic, retain)UIView *highLightView;
@property (nonatomic, retain)UIView *highTopView;
@property (nonatomic, retain)UIView *highColorView;

@property (nonatomic, strong) NSMutableArray *labelMutableArray;
@property (nonatomic, strong) ButtonOnClickBlock buttonBlock;

@end

@implementation LYCustomSegmentSelectView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        _duration = DEFAULT_DURATION;
    }
    return self;
}

-(void)layoutSubviews {
    
    [self customData];
    
    [self createBottomLabels];
    
    [self createTopLabels];
    
    [self createTopButtons];
}

-(void)setButtonOnClickBlock:(ButtonOnClickBlock)block {
    
    if (block) {
        _buttonBlock = block;
    }
    
}

/**
 *  默认值
 */
-(void)customData {
    if (_titles == nil) {
        _titles = @[@"aaa",@"bbb",@"ccc"];
    }
    if (_titlesCustomColor == nil) {
        _titlesCustomColor = [UIColor blackColor];
    }
    if (_titlesHighLightColor == nil) {
        _titlesHighLightColor = [UIColor whiteColor];
    }
    if (_backgroundHighLightColor == nil) {
        _backgroundHighLightColor = [UIColor redColor];
    }
    if (_titlesFont == nil) {
        _titlesFont = [UIFont systemFontOfSize:DEFAULT_TITLE_FONT];
    }
    if (_labelMutableArray == nil) {
        _labelMutableArray = [[NSMutableArray alloc]initWithCapacity:_titles.count];
    }
    _labelWidth = _viewWidth / _titles.count;
}

/**
 *  计算当前高亮frame
 *
 *  @param index 当前点击按钮的index
 *
 *  @return 返回当前点击按钮的frame
 */
-(CGRect)countCurrentRectWithIndex:(NSInteger)index {
    return CGRectMake(_labelWidth * index, 0, _labelWidth, _viewHeight);
}

/**
 *  根据index创建label
 *
 *  @param index     索引
 *  @param textColor label字体颜色
 *
 *  @return 返回label
 */
-(UILabel *)createLabelWithTitlesIndex:(NSInteger)index
                             textColor:(UIColor*)textColor {
    CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
    UILabel *label = [[UILabel alloc]initWithFrame:currentLabelFrame];
    label.textColor = textColor;
    label.text = _titles[index];
    label.font = _titlesFont;
    label.minimumScaleFactor = 0.1f;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

/**
 *  创建最下边的label
 */
-(void)createBottomLabels {
    for (int i = 0; i<_titles.count; i++) {
        //black
        UILabel *label = [self createLabelWithTitlesIndex:i textColor:_titlesCustomColor];
        [self addSubview:label];
        [_labelMutableArray addObject:label];
    }
}

/**
 *  创建上边高亮的label
 */
-(void)createTopLabels {
    CGRect highLightViewFrame = CGRectMake(0, 0, _labelWidth, _viewHeight);
    _highLightView = [[UIView alloc]initWithFrame:highLightViewFrame];
    _highLightView.clipsToBounds = YES;
    
    _highColorView = [[UIView alloc]initWithFrame:highLightViewFrame];
    //red
    _highColorView.backgroundColor = _backgroundHighLightColor;
    _highColorView.layer.cornerRadius = 20.0f;
    [_highLightView addSubview:_highColorView];
    
    _highTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    for (int i = 0; i< _titles.count; i++) {
        //white
        UILabel *label = [self createLabelWithTitlesIndex:i textColor:_titlesHighLightColor];
        [_highTopView addSubview:label];
    }
    [_highLightView addSubview:_highTopView];
    [self addSubview:_highLightView];
}

/**
 *  创建按钮
 */
-(void)createTopButtons {
    for (int i = 0; i< _titles.count; i++) {
        CGRect frame = [self countCurrentRectWithIndex:i];
        UIButton *button = [[UIButton alloc]initWithFrame:frame];
        button.tag = i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

/**
 *  点击事件
 *
 *  @param sender button
 */
-(void)tapButton:(UIButton *)sender {
    if (_buttonBlock && sender.tag < _titles.count) {
        _buttonBlock(sender.tag, _titles[sender.tag]);
    }
    
    CGRect frame = [self countCurrentRectWithIndex:sender.tag];
    CGRect changeFrame = [self countCurrentRectWithIndex:-sender.tag];
    
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:_duration animations:^{
        _highLightView.frame = frame;
        _highTopView.frame = changeFrame;
    } completion:^(BOOL finished) {
        [weak_self shakeAnimationForView:_highColorView];
    }];
}

/**
 *  抖动效果
 *
 *  @param view 要抖的view
 */
-(void)shakeAnimationForView:(UIView*)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 1, position.y);
    CGPoint y = CGPointMake(position.x - 1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}













































/* my code didn't work well */
/*
-(void)setNeedsDisplay {
    [super setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    [self configTitlesWithColor:self.titlesCustomColor level:1];
    
    _backSelectedView = [self configSelectedViewWithColor:self.backgroundHighLightColor level:2];
    
    _middleView = [[UIView alloc]initWithFrame:rect];
    
    _middleView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_middleView];
    
    [self configTitlesWithColor:self.titlesHighLightColor level:3];
    
//    _foreSelectedView = [self configSelectedViewWithColor:[UIColor clearColor] level:4];
}

-(void)configTitlesWithColor:(UIColor*)color level:(int)level{
    for (int i = 0; i< self.titles.count; i++) {
        NSString *title = [self.titles objectAtIndex:i];
        CGFloat titleWidth = _totalWidth / self.titles.count;
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(10+titleWidth*i, 0, titleWidth, _totalHeight);
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.titlesFont;
        label.textColor = color;
        if (level == 3) {
            label.tag = 100 + i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
            [tapGes addTarget:self action:@selector(didTapLabel:)];
            [label addGestureRecognizer:tapGes];
            [_middleView addSubview:label];
        }
        else {
            [self insertSubview:label atIndex:level];
        }
    }
}

-(UIView *)configSelectedViewWithColor:(UIColor *)color level:(int)level {
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(10, 0, _totalWidth/self.titles.count, _totalHeight);
    view.backgroundColor = color;
    view.layer.cornerRadius = 20;
    if (level == 4) {
        [_middleView addSubview:view];
    }
    else {
        [self addSubview:view   ];
    }
    return view;
}

-(void)didTapLabel:(UITapGestureRecognizer *)tapGes {
    UILabel *label = (UILabel*)tapGes.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.duration];
    _backSelectedView.frame = label.frame;
//    _foreSelectedView.frame = label.frame;
//    CGRect sameRect = CGRectUnion(_backSelectedView.frame, label.frame);
    [UIView commitAnimations];
}
*/
@end
