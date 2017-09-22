//
//  SectionIndexVIew.h
//  sectionIndexView
//
//  Created by yecheng.shao on 2017/9/19.
//  Copyright © 2017年 obzone.shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionIndexVIew : UIView

@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSArray<NSString *> *sectionIndexArray;

@end
