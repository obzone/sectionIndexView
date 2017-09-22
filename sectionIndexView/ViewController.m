//
//  ViewController.m
//  sectionIndexView
//
//  Created by yecheng.shao on 2017/9/19.
//  Copyright © 2017年 obzone.shao. All rights reserved.
//

#import "SectionIndexVIew.h"
#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbvMain;

@end

@implementation ViewController {
    
    NSArray <NSArray<NSString *> *> *_dataArray;
    NSArray <NSString *> *_sectionIndexArray;
}

- (void)makeData {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *sectionIndexArray = [NSMutableArray array];
    for (int i = 0; i < 26; i ++) {
        [sectionIndexArray addObject:[NSString stringWithFormat:@"%c", i+65]];
        NSMutableArray *sectionDataArray = [NSMutableArray array];
        int j = arc4random()%4+1;
        for (; j > 0; j --) {
            [sectionDataArray addObject:[NSString stringWithFormat:@"%c", i+97]];
        }
        [dataArray addObject:sectionDataArray];
    }
    _dataArray = dataArray;
    _sectionIndexArray = sectionIndexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    SectionIndexVIew *sectionIndexView = [[SectionIndexVIew alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40, 50, 0, 0)];
    [self.view addSubview:sectionIndexView];
    sectionIndexView.sectionIndexArray = _sectionIndexArray;
    
    [RACObserve(sectionIndexView, selectedIndex)
     subscribeNext:^(NSNumber *x) {
         [_tbvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:x.integerValue] atScrollPosition:UITableViewScrollPositionTop animated:NO];
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionIndexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table_view_cell_identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_view_cell_identifier"];
    }
    
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"icon_uk"];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionIndexArray[section];
}

@end
