//
//  CRProCarTypeView.m
//  CarAutoRepair
//
//  Created by minfo019 on 17/6/20.
//  Copyright © 2017年 Tracy. All rights reserved.
//

#import "CRProCarTypeView.h"

@interface CRProCarTypeView () <UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation CRProCarTypeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    /** 添加手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction)];
    
    [self.backView addGestureRecognizer:tap];
}

#pragma mark - tableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = KFont(15);
    cell.textLabel.textColor = ColorForRGB(0x828282);
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}


- (IBAction)cancelBtnAction {
    
    self.hidden = YES;
    
}

- (IBAction)makeSureBtnAction {
    
    self.hidden = YES;
}

@end
