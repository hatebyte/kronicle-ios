//
//  DescriptionView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "DescriptionView.h"
#import "KRFontHelper.h"
#import "KRClockManager.h"
#import "KronicleBlockTableViewCell.h"
#import "Kronicle+Helper.h"
#import "KRKronicleStartViewController.h"
#import "KRGlobals.h"


@interface DescriptionView () <UITableViewDataSource, UITableViewDelegate, KronicleBlockTableViewCellDelegate> {
    @private
    UILabel *_clockLabel;
    UITableView *_tableView;
    NSArray *_kroniclesModuloed;
}

@end

@implementation DescriptionView

+ (CGFloat)playbackHeight {
    return 310.f;
}

+ (CGFloat)finishedHeight {
    return 80 + (55.f + [KronicleBlockTableViewCell cellHeight]);
}

- (id)initWithFrame:(CGRect)frame andStep:(Step*)step {
    self = [super initWithFrame:frame];
    if (self) {
        self.step = step;
        [self layout];
        _clockLabel.text = @"00:00";
        _subClockLabel.text = @"until next step";
        _titleLabel.text = self.step.title;
        [_titleLabel sizeToFit];

        _description.text = self.step.desc;
        
        NSLog(@"self.step.title : %@", self.step.title);
    }
    return self;
}

- (id)initAsFinishedWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        _clockLabel.text                    = @"Finished!";
        _clockLabel.frame                   = CGRectMake(0, (_description.frame.origin.y - 82) * .5, 320, 30);
        [_titleLabel removeFromSuperview];
        _titleLabel                         = nil;
        [_description removeFromSuperview];
        _description                        = nil;
        
        NSInteger tableHeight               = 55.f + [KronicleBlockTableViewCell cellHeight];
        NSInteger tableY                    = 80;
        
        _tableView                          = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, 320, tableHeight)];
        _tableView.delegate                 = self;
        _tableView.dataSource               = self;
        _tableView.backgroundColor          = [KRColorHelper grayLight];
        _tableView.bounces                  = NO;
        _tableView.scrollEnabled            = NO;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layout {
    self.backgroundColor = [UIColor clearColor];
    
    _clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 30)];
    _clockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:38];
    _clockLabel.textColor = [UIColor whiteColor];
    _clockLabel.backgroundColor = [UIColor clearColor];
    _clockLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_clockLabel];
    
    _subClockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               _clockLabel.frame.origin.y + _clockLabel.frame.size.height+4,
                                                               320,
                                                               17)];
    _subClockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:17];
    _subClockLabel.textColor = [UIColor whiteColor];
    _subClockLabel.backgroundColor = [UIColor clearColor];
    _subClockLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subClockLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,
                                                            _subClockLabel.frame.origin.y + _subClockLabel.frame.size.height + 20,
                                                            292,
                                                            50)];
    _titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:28];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
//    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    int titleHeight = _titleLabel.frame.size.height + _titleLabel.frame.origin.y;
    _description = [[UITextView alloc] initWithFrame:CGRectMake(7,
                                                                titleHeight-5,
                                                                306,
                                                                self.frame.size.height - titleHeight)];
    _description.font = [KRFontHelper getFont:KRMinionProRegular withSize:16];
    _description.scrollEnabled = NO;
    _description.textColor = [UIColor blackColor];
    _description.editable = NO;
    _description.backgroundColor = [UIColor clearColor];
    [self addSubview:_description];
}

- (void)updateClock:(NSString *)timeString {
    _clockLabel.text = timeString;
}

- (void)resetClock {
    if (_step) {
        _clockLabel.text = [KRClockManager stringTimeForInt:_step.time];
    }
}

- (void)updateForFinished {
    _clockLabel.text = @"Finished!";
        
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
        _kroniclesModuloed = [NSArray arrayWithObject:[[Kronicle moduloKronicleList:kronicles] objectAtIndex:0]];
        [_tableView reloadData];
    }
                       onFailure:^(NSDictionary *error) {
                           if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                               [Kronicle getRemoteKronicles:^(NSArray *kronicles) {
                                   _kroniclesModuloed = [NSArray arrayWithObject:[[Kronicle moduloKronicleList:kronicles] objectAtIndex:0]];
                                   [_tableView reloadData];
                               }
                                                  onFailure:^(NSError *error) {
                                                      NSLog(@"Cant get remote kronicle : %@", error);
                                                  }];
                           }
                       }];
}




#pragma tableview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *suggestionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55.f)];
//    suggestionView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.6f];
    suggestionView.backgroundColor          = [KRColorHelper grayLight];

    
    UILabel *suggestionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, 320-(2*kPadding), 55.f)];
    suggestionsLabel.text = NSLocalizedString(@"You might also like", @"suggestionsLabel title");
    suggestionsLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:20];
    suggestionsLabel.textColor = [KRColorHelper grayDark];
    suggestionsLabel.textAlignment = NSTextAlignmentLeft;
    suggestionsLabel.backgroundColor = [UIColor clearColor];
    [suggestionView addSubview:suggestionsLabel];
    
    return suggestionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KronicleBlockTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_kroniclesModuloed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KronicleBlockTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"KronicleCell"];
    if (!cell) {
        cell = [[KronicleBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KronicleCell"];
    }
    [cell prepareForReuseWithArray: [_kroniclesModuloed objectAtIndex:indexPath.row] ];
    cell.delegate = self;
    return cell;
}


#pragma kronicleblocktableviewcell
- (void)kronicleDeletionRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle {
}

- (void)kroniclePlaybackRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle {
    if (kronicle.steps.count > 0) {
        [self navigateToKronicle:kronicle];
    } else {
        [Kronicle populateLocalKronicleWithRemoteSteps:kronicle
                                           withSuccess:^(Kronicle *k) {
                                               [self navigateToKronicle:k];
                                           }
                                             onFailure:^(NSDictionary *error) {
                                             }];
    }
}

- (void)navigateToKronicle:(Kronicle*)kronicle {
//    KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
//    [self.navigationController pushViewController:kronicleStartViewController animated:YES];
}

@end
