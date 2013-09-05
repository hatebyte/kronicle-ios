//
//  KRItemsViewController.m
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRItemsViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "AddTitleTableViewCell.h"
#import "KRTextButton.h"

@interface KRItemsViewController () {
    @private
    UIButton *_cancelXButton;
    KRTextButton *_emailButton;
}

@end

@implementation KRItemsViewController

- (id)initWithItems:(NSArray *)items andState:(KRItemsListType)type {
    self = [super initWithNibName:@"KRItemsViewController" bundle:nil];
    if (self) {
        _items = items;
        _type = type;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _cancelXButton                                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelXButton.backgroundColor                                  = [KRColorHelper turquoise];
    _cancelXButton.frame                                            = CGRectMake(320 - 40, 0, 40, 40);
    [_cancelXButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
    [_cancelXButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelXButton];
    
    NSInteger emailButtonHeight = 42;
    _emailButton = [[KRTextButton alloc] initWithFrame:CGRectMake(0,
                                                                  _bounds.size.height - (emailButtonHeight + 20),
                                                                  160,
                                                                  emailButtonHeight)
                                               andType:KRTextButtonTypeHomeScreen
                                               andIcon:[UIImage imageNamed:@"itemsemail"]];
    [_emailButton setTitle:NSLocalizedString(@"Email Itemlist", @"View items this kronicle button") forState:UIControlStateNormal];
    [_emailButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_emailButton setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
//    [_emailButton addTarget:self action:@selector(viewItemsRequested:) forControlEvents:UIControlEventTouchUpInside];
    _emailButton.titleEdgeInsets                    = UIEdgeInsetsMake(0, 14, 0, 0);
    _emailButton.imageEdgeInsets                    = UIEdgeInsetsMake(0, 10, 0, 0);
    _emailButton.backgroundColor                    = [UIColor whiteColor];
    _emailButton.titleLabel.font                    = [KRFontHelper getFont:KRBrandonRegular withSize:18];
    [self.view addSubview:_emailButton];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popViewController:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma uitableview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = [AddTitleTableViewCell cellHeightForStep];
            break;
        default:
            height = [KRItemsTableViewCell cellHeight];
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            AddTitleTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                cell = [[AddTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            }
            [cell prepareForUseAsLabelWithText:@"Items needed"];
            return cell;
        }   break;
            
        default:{
            KRItemsTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
            if (!cell) {
                cell = [[KRItemsTableViewCell alloc] initWithType:_type reuseIdentifier:@"ItemCell"];
            }
            [cell prepareForUseWith:[_items objectAtIndex:indexPath.row - 1]];
            //[(KRItemsTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0 && indexPath.row < ([_items count] + 2)) {
        KRItemsTableViewCell *cell = (KRItemsTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        cell.acquired = !cell.acquired;
    }
}




- (void)positionTableViewCellInLieuOfKeyboard:(KRFormFieldCell*)cell {
    CGFloat cellBottomY = [self returnHeightForCellType:cell.type] + cell.frame.origin.y + 20;
    CGFloat keyboardY = _bounds.size.height - [KeyboardNavigationToolBar height];
    CGFloat offsetY =  cellBottomY - keyboardY;
    offsetY =(offsetY < 0) ? 0 : offsetY;
    CGPoint offset = CGPointMake(0, offsetY);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView setContentOffset:offset animated:YES];
    });
}

#pragma mark KRFormFieldCell delegate
- (void)formFieldCellDidRequestPreviousResponder:(KRFormFieldCell *)formFieldCell {

}

- (void)formFieldCellDidRequestNextResponder:(KRFormFieldCell *)formFieldCell {
}
- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell andShouldExpand:(BOOL)shouldExpand {
    
}

@end
