//
//  KRCreateStepViewController.m
//  Kronicle
//
//  Created by Scott on 6/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCreateStepViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "CreateStepTimeView.h"
#import "KRNavigationViewController.h"
#import "AddMediaTableViewCell.h"
#import "AddTitleTableViewCell.h"
#import "AddDescriptionTableViewCell.h"
#import "AddTimeCell.h"

@interface KRCreateStepViewController () <CreateStepTimeViewDelegate, AddMediaTableViewCellDelegate, KRFormFieldCellDelegate, AddDescriptionTableViewCellDelegate> {
    UIButton *_backButton;
    UIButton *_doneButton;
    UIButton *_addStepButton;
    CreateStepTimeView *_createStepTimeView;
    UITableView *_tableView;
    NSInteger _buttonHeight;
    CGRect _bounds;
    __weak KRStep *_step;
    BOOL _tableIsExpanded;
}

@end

@implementation KRCreateStepViewController

- (id)initWithStep:(KRStep *)step {
    self = [super initWithNibName:@"KRCreateStepViewController" bundle:nil];
    if (self) {
        _step = step;
        
    }
    return self;
}

- (void)viewDidLoad {
    _buttonHeight                               = 35;
    _bounds                                     = [UIScreen mainScreen].bounds;
    
    _tableView                                  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _bounds.size.width, _bounds.size.height-20 )];
    _tableView.dataSource                       = self;
    _tableView.delegate                         = self;
    _tableView.separatorStyle                   = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor                  = [UIColor clearColor];
    [self.view addSubview:_tableView];

    _backButton                                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.backgroundColor                 = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.7f];
    _backButton.frame                           = CGRectMake(5, 5, 26, 26);
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"x-button"] forState:UIControlStateNormal];
    [self.view addSubview:_backButton];

    _doneButton                                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.backgroundColor                 = [KRColorHelper turquoise];
    _doneButton.titleLabel.font                 = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(kPadding, _bounds.size.height-(_buttonHeight+20), 70, _buttonHeight);
    [_doneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];
   
    _addStepButton                              = [UIButton buttonWithType:UIButtonTypeCustom];
    _addStepButton.backgroundColor              = [KRColorHelper orange];
    _addStepButton.titleLabel.font              = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    [_addStepButton setTitle:@"Add another step" forState:UIControlStateNormal];
    [_addStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addStepButton.frame = CGRectMake(_bounds.size.width - (160 + kPadding), _bounds.size.height-(_buttonHeight+20), 160, _buttonHeight);
//    [_addStepButton addTarget:self action:@selector(addAnotherStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addStepButton];

    _createStepTimeView = [[CreateStepTimeView alloc] initWithFrame:_tableView.frame];
    _createStepTimeView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCreatorRequested:) name:kRequestTimeUnitEdit object:nil];

    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma time creator methods
- (void)animateInCreator {
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];

    _createStepTimeView.alpha = 0;
    [self.view addSubview:_createStepTimeView];

    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _createStepTimeView.alpha = 1;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)animateOutCreator {    
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _createStepTimeView.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         [_createStepTimeView removeFromSuperview];
                     }];
}

#pragma createStepTimeView methods
-(void)timeCreatorRequested:(NSNotification *)anote {
    NSDictionary *dict                      = [anote userInfo];
    NSInteger unit                          = [[dict objectForKey:@"unit"] integerValue];
    NSInteger currentValue                  = [[dict objectForKey:@"currentValue"] integerValue];

    [_createStepTimeView setUnit:unit withValue:currentValue];
    [self animateInCreator];

}


- (void)createStepTimeView:(CreateStepTimeView *)durationCreatorView finishedWithValue:(NSInteger)value {

//    switch (durationCreatorView.unit) {
//        case CreateStepTimeUnitHours:
//            [self.hours setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
//            break;
//        case CreateStepTimeUnitMinutes:
//            [self.minutes setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
//            break;
//        case CreateStepTimeUnitSeconds:
//            [self.seconds setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
//            break;
//    }

    NSDictionary *aDictionary                                 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger:durationCreatorView.unit], @"unit",
                                                                 [NSNumber numberWithInteger:value], @"currentValue",
                                                                 nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimeUnitCompleted object:nil userInfo:aDictionary];
    [self animateOutCreator];
}


#pragma addMedia
- (void)addMediaRequested:(AddMediaTableViewCell *)addItemsCell {

}

#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    switch (indexPath.row) {
        case 0:
            height = [AddMediaTableViewCell cellHeight];
            break;
        case 1:
            height = [AddTimeCell cellHeight];
            break;
        case 2:
            height = [AddTitleTableViewCell cellHeightForStep];
            break;
        case 3:
            if (_tableIsExpanded) {
                height = [AddDescriptionTableViewCell cellHeightExpanded];
            } else {
                height = [AddDescriptionTableViewCell cellHeightStep];
            }
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            AddMediaTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MediaCell"];
            if (cell == nil) {
                cell = [[AddMediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaCell"];
            }
            [cell prepareForUseWithImage:_step.imageUrl];
            [(AddMediaTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
        case 1:{
            AddTimeCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AddTimeCell"];
            if (cell == nil) {
                cell = [[AddTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddTimeCell"];
            }
            [cell prepareForUserWithTime:_step.time];
            [(AddTimeCell *)cell setDelegate:self];
            return cell;
        }   break;
        case 2:{
            AddTitleTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (cell == nil) {
                cell = [[AddTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            }
            [cell prepareForUseWithTitle:_step.title andType:AddTitleStep];
            [(AddTitleTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
        case 3:
        default:{
            AddDescriptionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
            if (!cell) {
                cell = [[AddDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"];
            }
            [cell prepareForUseWithDescription:_step.description andType:AddTitleStep];
            [(AddDescriptionTableViewCell *)cell setDelegate:self];
            return cell;
        }   break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (_tableIsExpanded) ? 240 : 54;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}

- (CGFloat)returnHeightForCellType:(KRFormFieldCellType)cellType {
    CGFloat height = 0;
    
    switch (cellType) {
        case KRFormFieldCellTypeTitle:
            height = [AddTitleTableViewCell cellHeight];
            break;
        case KRFormFieldCellTypeDescription: {
            if (_tableIsExpanded) {
                height = [AddDescriptionTableViewCell cellHeightExpanded];
            } else {
                height = [AddDescriptionTableViewCell cellHeightStep];
            }
        }   break;
        case KRFormFieldCellTypeAddItems:
        case KRFormFieldCellTypeStep:
        default:
            height = 0;
            break;
    }
    return height;
}

- (void)positionTableViewCellInLieuOfKeyboard:(KRFormFieldCell*)cell {
    CGFloat cellBottomY = [self returnHeightForCellType:cell.type] + cell.frame.origin.y;
    NSLog(@"cellY : %f", cellBottomY);
    CGFloat keyboardY = _bounds.size.height - [KeyboardNavigationToolBar height];
    CGFloat offsetY =  cellBottomY - keyboardY;
    offsetY =(offsetY < 0) ? 0 : offsetY;
    
    CGPoint offset = CGPointMake(0, offsetY);
    NSLog(@"offsetY : %f", offsetY);

    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView setContentOffset:offset animated:YES];
    });
}


#pragma mark KRFormFieldCell delegate
- (void)formFieldCellDidRequestPreviousResponder:(KRFormFieldCell *)formFieldCell {
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeTitle: {
        }   break;
        case KRFormFieldCellTypeDescription: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:2 inSection:0];
            [(AddTitleTableViewCell *)[_tableView cellForRowAtIndexPath:ip] setAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeAddItems: {
        }   break;
        case KRFormFieldCellTypeStep:{
        }   break;
            
    }
}

- (void)formFieldCellDidRequestNextResponder:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = YES;
    switch (formFieldCell.type) {
        case KRFormFieldCellTypeTitle: {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:3 inSection:0];
            [(AddDescriptionTableViewCell *)[_tableView cellForRowAtIndexPath:ip] setAsFirstResponder];
        }   break;
        case KRFormFieldCellTypeDescription: {
        }   break;
        case KRFormFieldCellTypeAddItems: {
        }   break;
        case KRFormFieldCellTypeStep:{
        }   break;
    }
}

- (void)formFieldCellDidBecomeFirstResponder:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = YES;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    [self positionTableViewCellInLieuOfKeyboard:formFieldCell];
}

- (void)formFieldCellDidResignFirstResponder:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = YES;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
}

- (void)formFieldCellDone:(KRFormFieldCell *)formFieldCell {
    _tableIsExpanded = NO;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView setContentOffset:CGPointZero animated:YES];
    });
}


#pragma mark AddDescriptionTableViewCell delegate
- (void)formFieldCellDidBecomeFirstResponderWithExpansion:(AddDescriptionTableViewCell *)addDescriptionTableViewCell {
    _tableIsExpanded = YES;
    [_tableView beginUpdates];
    [_tableView endUpdates];
    [self positionTableViewCellInLieuOfKeyboard:addDescriptionTableViewCell];
}

@end
