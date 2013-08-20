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

@interface KRCreateStepViewController () <CreateStepTimeViewDelegate, AddMediaTableViewCellDelegate> {
    UIButton *_doneButton;
    UIButton *_addStepButton;
    CreateStepTimeView *_createStepTimeView;
    __weak KRStep *_step;
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
    [super viewDidLoad];

    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"x-button"] forState:UIControlStateNormal];
    _cancelButton.backgroundColor                   = [UIColor clearColor];
    [self.view addSubview:_cancelButton];

    _doneButton                                     = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.backgroundColor                     = [KRColorHelper turquoise];
    _doneButton.titleLabel.font                     = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(kPadding, _bounds.size.height-(_buttonHeight+20), 70, _buttonHeight);
    [_doneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];
   
    _addStepButton                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _addStepButton.backgroundColor                  = [KRColorHelper orange];
    _addStepButton.titleLabel.font                  = [KRFontHelper getFont:KRBrandonRegular withSize:17];
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

- (void)popViewController:(id)sender {
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (_tableIsExpanded) ? 300 : 64;
}

- (CGFloat)returnHeightForCellType:(KRFormFieldCellType)cellType {
    CGFloat height = 0;
    
    switch (cellType) {
        case KRFormFieldCellTypeAddTitle:
            height = [AddTitleTableViewCell cellHeight];
            break;
        case KRFormFieldCellTypeAddDescription: {
            if (_tableIsExpanded) {
                height = [AddDescriptionTableViewCell cellHeightExpanded];
            } else {
                height = [AddDescriptionTableViewCell cellHeightStep];
            }
        }   break;
        case KRFormFieldCellTypeAddItems:
        case KRFormFieldCellTypeAddStep:
        default:
            height = 0;
            break;
    }
    return height;
}


@end
