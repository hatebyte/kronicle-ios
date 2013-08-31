//
//  KRKronicleStartViewController.m
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleStartViewController.h"
#import "KRPlaybackViewController.h"
#import "KRNavigationViewController.h"


#import "KRFontHelper.h"
#import "KRColorHelper.h"
#import "KRGlobals.h"
#import "KRTextButton.h"
#import <QuartzCore/QuartzCore.h>
#import "KRClockManager.h"
#import "KRRatingModuleView.h"

@interface KRKronicleStartViewController () {
    @private
    UIButton *_backButton;
    UIImageView *_hamburgerImageView;
    UIButton *_addItemCatcher;
    UIButton *_startButton;
    UIImageView *_coverImage;
    UIView *_coverImageContainer;
//    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UITextView *_description;
    UITextView *_titleLabel;
    KRRatingModuleView *_ratingView;
}

@end

@implementation KRKronicleStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(Kronicle *)kronicle;
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.kronicle = kronicle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    // Do any additional setup after loading the view from its nib.    
    NSInteger height = 205;
    _coverImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0, 320, height)];
    _coverImageContainer.backgroundColor = [UIColor blackColor];
    _coverImageContainer.clipsToBounds = YES;
    [self.view addSubview:_coverImageContainer];
    _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(320 - height) * .5, 320, 320)];
    _coverImage.image = [UIImage imageWithContentsOfFile:_kronicle.fullCoverURL];
    _coverImage.alpha = .7;
    [_coverImageContainer addSubview:_coverImage];
    
    
    NSMutableParagraphStyle *paragraphStyle         = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple               = 42.f;
    paragraphStyle.maximumLineHeight                = 42.f;
    paragraphStyle.minimumLineHeight                = 42.f;
    
    //        NSFont *font = [KRFontHelper getFont:KRBrandonMedium withSize:16];
    NSString *string                     = self.kronicle.title; //@"This is a long title for a kronicle";
    NSDictionary *attribute              = @{ NSParagraphStyleAttributeName : paragraphStyle, };
    _titleLabel                          = [[UITextView alloc] initWithFrame:CGRectMake(kPadding, 54, 300, 50)];
    _titleLabel.attributedText           = [[NSAttributedString alloc] initWithString:string attributes:attribute];
    //_title.text                        = descriptionString;
    _titleLabel.font                     = [KRFontHelper getFont:KRBrandonLight withSize:46];
    _titleLabel.textColor                = [UIColor whiteColor];
    _titleLabel.backgroundColor          = [UIColor clearColor];
    _titleLabel.editable                 = NO;
    _titleLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
    _titleLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
    _titleLabel.layer.shadowOpacity      = .7f;
    _titleLabel.layer.shadowRadius       = .7f;
    _titleLabel.backgroundColor          = [UIColor clearColor];
    CGSize titleSize                     = [_titleLabel sizeThatFits:CGSizeMake(320 - (2 * kPadding), 2000)];
    _titleLabel.frame                    = CGRectMake(_titleLabel.frame.origin.x,
                                                      _titleLabel.frame.origin.y,
                                                      _titleLabel.frame.size.width,
                                                      titleSize.height);
    [self.view addSubview:_titleLabel];


    NSString *time = [KRClockManager stringTimeForInt:_kronicle.totalTime];
    time =([[time substringToIndex:1] isEqualToString:@"0"]) ? [time substringFromIndex:1] : time;

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, _titleLabel.frame.size.height + _titleLabel.frame.origin.y, 320 - kPadding, 50)];
    _timeLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:32];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = time;
    _timeLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
    _timeLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
    _timeLabel.layer.shadowOpacity      = .7f;
    _timeLabel.layer.shadowRadius       = .7f;
    [self.view addSubview:_timeLabel];
    
    NSInteger timeWidth = [time sizeWithFont:[KRFontHelper getFont:KRBrandonLight withSize:32]].width + _timeLabel.frame.origin.x + 15;
    _ratingView = [[KRRatingModuleView alloc] initWithPoint:CGPointMake(timeWidth, _timeLabel.frame.origin.y + 4) andStyle:KRRatingModuleStart andRating:.7];
    [self.view addSubview:_ratingView];
    
    _description = [[UITextView alloc] initWithFrame:CGRectMake(kPadding,
                                                                _coverImageContainer.frame.size.height + kPadding,
                                                                306,
                                                                150)];
    _description.font = [KRFontHelper getFont:KRMinionProRegular withSize:16];
    _description.text = self.kronicle.desc;
    _description.scrollEnabled = NO;
    _description.textColor = [UIColor blackColor];
    _description.editable = NO;
    _description.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_description];
    
    _backButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];

    [_backButton setBackgroundImage:[UIImage imageNamed:@"backward"] forState:UIControlStateNormal];
    _backButton.backgroundColor                 = [UIColor clearColor];
    _backButton.frame                           = CGRectMake(0, 0, 40, 40);
    [self.view addSubview:_backButton];
    
    
    _startButton                         = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setImage:[UIImage imageNamed:@"start_button"] forState:UIControlStateNormal];
    _startButton.frame                   = CGRectMake(bounds.size.width - (kPadding + 121),
                                                      bounds.size.height - (60 + kPadding),
                                                      121,
                                                      41);
    [_startButton addTarget:self action:@selector(startKronicle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    
    _addItemCatcher                             = [UIButton buttonWithType:UIButtonTypeCustom];
    _addItemCatcher.frame                       = CGRectMake(kPadding,
                                                             _startButton.frame.origin.y,
                                                             _startButton.frame.size.width,
                                                             _startButton.frame.size.height);
    _addItemCatcher.titleLabel.font             = [KRFontHelper getFont:KRBrandonRegular withSize:16];
    _addItemCatcher.backgroundColor             = [UIColor clearColor];
    [_addItemCatcher setTitleColor:[KRColorHelper turquoise] forState:UIControlStateNormal];
    [_addItemCatcher setTitle:@"Items" forState:UIControlStateNormal];
    [_addItemCatcher addTarget:self action:@selector(itemsNeeded) forControlEvents:UIControlEventTouchUpInside];

    _hamburgerImageView                         = [[UIImageView alloc] init];
    _hamburgerImageView.image                   = [UIImage imageNamed:@"hamburger_50px"];
    _hamburgerImageView.frame                   = CGRectMake(kPadding,
                                                             _startButton.frame.origin.y + 12,
                                                             15,
                                                             15);
    [self.view addSubview:_hamburgerImageView];
    [self.view addSubview:_addItemCatcher];
    
    [self layoutPicture];
}

- (void)layoutPicture {
    NSInteger height                            = _titleLabel.frame.size.height + ((320 - _titleLabel.frame.size.height) * .5) + kPadding;
    _coverImageContainer.frame                  = CGRectMake(0,0, 320, height);
    _coverImage.frame                           = CGRectMake(0, -(320 - height) * .5, 320, 320);
    NSInteger titleHeight                       = _titleLabel.frame.size.height + _titleLabel.frame.origin.y;
    _titleLabel.frame                           = CGRectMake(kPadding-8, ((320 - titleHeight) * .5) - 20, 320 - kPadding, _titleLabel.frame.size.height);

    NSString *time                              = [KRClockManager stringTimeForInt:_kronicle.totalTime];
    time                                        =([[time substringToIndex:1] isEqualToString:@"0"]) ? [time substringFromIndex:1] : time;
    
    _timeLabel.frame                            = CGRectMake(kPadding, _titleLabel.frame.size.height + _titleLabel.frame.origin.y, 320 - kPadding, 50);

    NSInteger timeWidth                         = [time sizeWithFont:[KRFontHelper getFont:KRBrandonLight withSize:32]].width + _timeLabel.frame.origin.x + 15;
    _ratingView.frame                           = CGRectMake(timeWidth, _timeLabel.frame.origin.y + 4, _ratingView.frame.size.width, _ratingView.frame.size.height);

    _description.frame                          = CGRectMake(kPadding - 6,
                                                             _ratingView.frame.origin.y + _ratingView.frame.size.height + (2 * kPadding),
                                                             306,
                                                             150);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
    
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)itemsNeeded {
    [self viewListItems:_kronicle];
}

- (void)startKronicle {
    KRPlaybackViewController *playbackViewController = [[KRPlaybackViewController alloc] initWithKronicle:self.kronicle];
    [self.navigationController pushViewController:playbackViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
