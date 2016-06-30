//
//  ScrollLabelView.m
//  NewOncon-EasyAsk
//
//  Created by heer on 16/6/13.
//  Copyright © 2016年 heer. All rights reserved.
//

#import "ScrollLabelView.h"

#define kWIDTH [UIScreen mainScreen].bounds.size.width
@implementation ScrollLabelView 

-(UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [UILabel new];
        _showLabel.textAlignment = NSTextAlignmentLeft;
        _showLabel.font = [UIFont systemFontOfSize:20];
        _showLabel.backgroundColor = [UIColor clearColor];
        _showLabel.text = @"暂无新的公告";
        _showLabel.textColor = [UIColor colorWithRed:88/255.f green:197/255.f blue:199/255.f alpha:1];
        _showLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
    return _showLabel;
}

-(void)layoutSubviews {
    [super layoutSubviews];

}

-(instancetype)initWithFrame:(CGRect)frame andScrollData:(NSArray *)showLabelArr {
    if (self = [super initWithFrame:frame]) {
       // self.backgroundColor = [UIColor lightGrayColor];
        self.showLabelsIndex = 0;
        self.showLabelArr = showLabelArr;
        self.pagingEnabled = NO;

        [self setDelaysContentTouches:NO];
        self.canCancelContentTouches = NO;
        
        if (showLabelArr.count == 0) {
            [self addSubview:self.showLabel];
            self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        } else {
            for (int i=0;i<=showLabelArr.count;i++) {
                UILabel *label = [UILabel new];
                label.textAlignment = NSTextAlignmentLeft;
                label.font = [UIFont systemFontOfSize:20];
                label.numberOfLines = 1;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor colorWithRed:88/255.f green:197/255.f blue:199/255.f alpha:1];
                
                if (i == showLabelArr.count) {
                    label.text = [NSString stringWithFormat:@"%@  ",showLabelArr[0]];
                } else {
                    label.text = [NSString stringWithFormat:@"%@  ",showLabelArr[i]];
                  
                }
                  label.tag = 10000 + i;
                CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
                
                if (size.width < 200) {
                    size = CGSizeMake(200, size.height);
                }
                
                if (i>0) {
                    UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+i-1) ];
                    label.frame = CGRectMake(beforeLabel.frame.size.width+beforeLabel.frame.origin.x, 0, size.width, size.height);
                    
                } else {
                    
                    label.frame = CGRectMake(0,0, size.width, size.height);
                }
              
                [self addSubview:label];
                [self addTapForView:label];
                
            }
            
            UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+self.showLabelArr.count) ];
            self.contentSize = CGSizeMake(beforeLabel.frame.origin.x+beforeLabel.frame.size.width, self.bounds.size.height);
           
        }
    }
    return self;
}

-(void)changeTitleLabelWithNewTitles:(NSArray *)newTitles {
    [self stopScroll];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.showLabelArr = newTitles;
    if (self.showLabelArr.count == 0) {
        [self addSubview:self.showLabel];
        self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    } else {
        for (int i=0;i<=self.showLabelArr.count;i++) {
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:20];
            label.numberOfLines = 1;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:88/255.f green:197/255.f blue:199/255.f alpha:1];
            
            if (i == self.showLabelArr.count) {
                label.text = [NSString stringWithFormat:@"%@  ",self.showLabelArr[0]];
            } else {
                label.text = [NSString stringWithFormat:@"%@  ",self.showLabelArr[i]];
                
            }
            label.tag = 10000 + i;
            CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
            
            if (size.width < 200) {
                size = CGSizeMake(200, size.height);
            }
            
            if (i>0) {
                UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+i-1) ];
                label.frame = CGRectMake(beforeLabel.frame.size.width+beforeLabel.frame.origin.x, 0, size.width, size.height);
                
            } else {
                
                label.frame = CGRectMake(0,0, size.width, size.height);
            }
            
            [self addSubview:label];
            [self addTapForView:label];
            
        }
        
        UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+self.showLabelArr.count) ];
        self.contentSize = CGSizeMake(beforeLabel.frame.origin.x+beforeLabel.frame.size.width, self.bounds.size.height);
        
    }

}

- (void)addTapForView:(UILabel *)label {
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNoticeDetail:)];
    tap.delegate = self;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:tap];

}

-(void)gotoNoticeDetail:(UITapGestureRecognizer *)sender {
    NSInteger tapTitleLbTag = sender.view.tag -10000;
    if (tapTitleLbTag == self.showLabelArr.count) {
        tapTitleLbTag = 0;
    }
    
    if (self.scrollLabelDelegate ) {
        if([self.scrollLabelDelegate respondsToSelector:@selector(gotoNoticeDetail:)]){
            
            [self.scrollLabelDelegate gotoNoticeDetail:tapTitleLbTag];
        }
    }
    
}

-(void)beginScroll {
    [self stopScroll];
    if (self.showLabelArr.count == 0) {
        return;
    }
     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(refreshScrollLabel) userInfo:nil repeats:YES];

   
}

-(void)refreshScrollLabel {
    CGPoint point = self.contentOffset;
       UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+self.showLabelArr.count) ];
    if (point.x > beforeLabel.frame.origin.x) {
        [self setContentOffset:CGPointMake(point.x-beforeLabel.frame.origin.x+2,point.y) animated:NO];
    }else {
         self.contentOffset = CGPointMake(point.x+2, point.y);
    }
   
   
}

-(void)stopScroll {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/*

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

//父视图是否可以将消息传递给子视图，yes是将事件传递给子视图，则不滚动，no是不传递则继续滚动
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([view isKindOfClass:[UILabel class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"MyScrollView touch Began");
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging)
    {
        [[self nextResponder]touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)gestureRecognizer :(UIGestureRecognizer  *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer{
    
    return YES ;
}

//-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
//    
//}


//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView* result = [super hitTest:point withEvent:event];
//    if (result) {
//       // [self.layer removeAllAnimations];
//        for (int i=0; i<=self.showLabelArr.count; i++) {
//            UILabel *beforeLabel =  (UILabel *)[self viewWithTag:(10000+i) ];
//            // CGPoint labelPoint = [beforeLabel convertPoint:point fromView:self];
//            if ([beforeLabel pointInside:point withEvent:event]) {
//                
//                return beforeLabel;
//            }
//        }
//    }
//    
//   
//    return result;
//}

 */
@end
