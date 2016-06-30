//
//  ScrollLabelView.h
//  NewOncon-EasyAsk
//
//  Created by heer on 16/6/13.
//  Copyright © 2016年 heer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollLabelViewDelegate <NSObject>

-(void)gotoNoticeDetail:(NSInteger)tapTitleTag;

@end

@interface ScrollLabelView : UIScrollView <UIGestureRecognizerDelegate>
@property (nonatomic,strong) UILabel *showLabel;
@property (nonatomic,strong) NSArray *showLabelArr;
@property (nonatomic) NSInteger showLabelsIndex;
@property (nonatomic) double scrollTimeInterval;
@property (nonatomic,strong) NSTimer *timer;

-(void)beginScroll;
-(void)stopScroll;

-(instancetype)initWithFrame:(CGRect)frame andScrollData:(NSArray *)showLabelArr;

-(void)changeTitleLabelWithNewTitles:(NSArray *)newTitles;

@property (nonatomic,weak)id<ScrollLabelViewDelegate>scrollLabelDelegate;


@end

