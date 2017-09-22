//
//  SectionIndexVIew.m
//  sectionIndexView
//
//  Created by yecheng.shao on 2017/9/19.
//  Copyright © 2017年 obzone.shao. All rights reserved.
//

#import "SectionIndexVIew.h"
#import "ReactiveCocoa.h"

#define BUTTON_WIDTH 20

@interface SectionIndexVIew ()

/// x = a*y^2+by+c 使用抛物线方程
@property (assign, nonatomic) float a;
@property (assign, nonatomic) float b;
@property (assign, nonatomic) float c;

@end

@implementation SectionIndexVIew {
}

- (void)setSectionIndexArray:(NSArray<NSString *> *)sectionIndexArray {
    _sectionIndexArray = sectionIndexArray;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BUTTON_WIDTH*2, _sectionIndexArray.count*BUTTON_WIDTH);
    @weakify(self)
    UIButton *preBtn = nil;
    for (int i = 0; i < _sectionIndexArray.count; i ++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:_sectionIndexArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = BUTTON_WIDTH/2.0f;
        btn.layer.masksToBounds = YES;
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self)
             self.selectedIndex = i;
         }];
        
        [RACObserve(self, selectedIndex)
         subscribeNext:^(NSNumber *x) {
             if (x.integerValue == i) {
                 btn.backgroundColor = [UIColor blueColor];
             } else {
                 btn.backgroundColor = [UIColor clearColor];
             }
         }];
        
        [[RACObserve(self, c)
          skip:1]
         subscribeNext:^(id xx) {
             @strongify(self)
             float x = BUTTON_WIDTH*(i+0.5)*BUTTON_WIDTH*(i+0.5)*self.a+BUTTON_WIDTH*(i+0.5)*self.b+self.c;
            
             x = x > CGRectGetWidth(self.frame)-BUTTON_WIDTH/2.0f ? CGRectGetWidth(self.frame)-BUTTON_WIDTH/2.0f : x;
             btn.center = CGPointMake(x, CGRectGetMidY(btn.frame));
             
        }];
        
        [self addSubview:btn];
        
        if (i == 0) {
            btn.frame = CGRectMake(CGRectGetWidth(self.frame)-BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_WIDTH);
            preBtn = btn;
            continue;
        }
        
        btn.frame = CGRectMake(CGRectGetWidth(self.frame)-BUTTON_WIDTH, CGRectGetMaxY(preBtn.frame), BUTTON_WIDTH, BUTTON_WIDTH);
        preBtn = btn;
    }
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureHandler:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
    
}

- (void)longPressGestureHandler:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(point));
    
    int i = (point.y)/BUTTON_WIDTH;
    i = i < 0 ? 0 : i;
    i = i > _sectionIndexArray.count-1 ? (int)_sectionIndexArray.count-1 : i;
    self.selectedIndex = i;
    
    /// 求开口向右的抛物线方程
    point = CGPointMake(point.x, point.y+50);
    CGPoint x0_y0 = CGPointMake(CGRectGetWidth(self.frame)+BUTTON_WIDTH*5, point.y-BUTTON_WIDTH*6);
    CGPoint x1_y1 = CGPointMake(CGRectGetWidth(self.frame)+BUTTON_WIDTH*5, point.y+BUTTON_WIDTH*6);
    CGPoint x2_y2 = CGPointMake(0, point.y);
    float a = (x2_y2.x/(x2_y2.y-x0_y0.y)-x1_y1.x/(x1_y1.y-x0_y0.y))/(x2_y2.y-x1_y1.y);
    float b = x2_y2.x/(x2_y2.y-x0_y0.y)-a*(x2_y2.y+x0_y0.y);
    float c = -a*x0_y0.y*x0_y0.y-b*x0_y0.y;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.c = MAXFLOAT;
    } else {
        self.a = a;
        self.b = b;
        self.c = c;
    }
}

@end
