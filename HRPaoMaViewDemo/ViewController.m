//
//  ViewController.m
//  HRPaoMaViewDemo
//
//  Created by heer on 16/6/20.
//  Copyright © 2016年 heer. All rights reserved.
//

#import "ViewController.h"
#import "ScrollLabelView.h"

@interface ViewController ()<ScrollLabelViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) ScrollLabelView *scrollLabelView;

@property (nonatomic,strong) NSArray *testArray;
@end

@implementation ViewController

-(NSArray *)testArray {
    if (!_testArray) {
        _testArray = [[NSArray alloc]initWithObjects:@"测试测试测试测试测试测试测试测试测试1",@"2测试测试测试测试测试测试2",@"测试测试测试3", nil];
    }
    return _testArray;
}

-(ScrollLabelView *)scrollLabelView {
    if (!_scrollLabelView) {
        _scrollLabelView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(30, 40, 200, 40) andScrollData:self.testArray];
        _scrollLabelView.delegate = self;
        _scrollLabelView.scrollLabelDelegate = self;
        _scrollLabelView.userInteractionEnabled = YES;
    }
    return _scrollLabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollLabelView];
    [self.scrollLabelView beginScroll];
    
    //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeMessage) userInfo:nil repeats:YES];
}

-(void)changeMessage {
    [self.scrollLabelView changeTitleLabelWithNewTitles:nil];
    self.scrollLabelView.showLabel.text = @"hahahha";
    [self.scrollLabelView beginScroll];
}

-(void)gotoNoticeDetail:(NSInteger)tapTitleTag {
    NSLog(@"%ld",tapTitleTag);
}


@end
