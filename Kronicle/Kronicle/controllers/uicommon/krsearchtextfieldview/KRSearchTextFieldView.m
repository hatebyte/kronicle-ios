//
//  KRSearchTextFieldView.m
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRSearchTextFieldView.h"
#import "KRFontHelper.h"
#import "KRColorHelper.h"
#import "UIView+GCLibrary.h"
#import "KRDefaultButton.h"
#import <QuartzCore/QuartzCore.h>

@interface KRSearchTextFieldView()

@property(nonatomic, strong) UILabel *placeHolderLabel;
@property(nonatomic, strong) KRDefaultButton *cancelButton;

@end

@implementation KRSearchTextFieldView {
}

NSString *const MyPlaceHolderString     = @"Search";
float const kSearchFieldTopInset        = 3.0f;
float const kSearchFieldLeftInset       = 10.0f;
float const kCancelButtonAnimateTime    = 0.3f;


#pragma mark - build stuff

- (void)buildSearchPlaceHolderTextField
{
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSearchFieldLeftInset, kSearchFieldTopInset, self.frame.size.width - (2 * kSearchFieldLeftInset), self.frame.size.height - (2 * kSearchFieldTopInset))];
    _placeHolderLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge-2];
    _placeHolderLabel.text = MyPlaceHolderString;
    _placeHolderLabel.textColor = [KRColorHelper grayDark];
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeHolderLabel];
}

- (void)buildSearchTextField
{
    _searchTextField = [[UITextField alloc] initWithFrame:_placeHolderLabel.frame];
    [_searchTextField setY:_searchTextField.y + 3.0f];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.font = _placeHolderLabel.font;
    [self addSubview:_searchTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSearchFieldTextUpdate:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
}

- (void)buildMagnifyingGlassIcon
{
    UIImage *magnifyingGlass = [UIImage imageNamed:@"magnifying-glass-black"];
    UIImageView *magnifyingGlassImageView = [[UIImageView alloc] initWithImage:magnifyingGlass];
    [magnifyingGlassImageView setX:self.width - magnifyingGlassImageView.width - 8.0f];
    [magnifyingGlassImageView setY:(self.height / 2) - (magnifyingGlassImageView.height / 2)];
    [self addSubview:magnifyingGlassImageView];
}

- (void)buildCancelButton
{
    float buttonWidth = 80.0f;
    CGRect buttonRect = CGRectMake(self.width, 0, buttonWidth, self.height);
    _cancelButton = [[KRDefaultButton alloc] initWithFrame:buttonRect andType:KRDefaultButtonTypeCancelSearch];
    [self addSubview:_cancelButton];
}

#pragma mark - search field interactions

- (void)onSearchFieldTextUpdate:(id)sender
{
    if (_searchTextField.text.length == 0) {
        _placeHolderLabel.text = MyPlaceHolderString;
    } else {
        _placeHolderLabel.text = @"";
    }
}

- (void)showCancelButton
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kCancelButtonAnimateTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cancelButtonFinishedAnimatingIn:finished:context:)];
    [self.delegate animateControlButtonsIn];
    [_cancelButton setX:self.width - _cancelButton.width];
    [UIView commitAnimations];
}

- (void)hideCancelButton
{
    [_cancelButton removeTarget:self action:@selector(cancelButtonFinishedAnimatingIn:finished:context:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kCancelButtonAnimateTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cancelButtonFinishedAnimatingOut:finished:context:)];
    [self.delegate animateControlButtonsOut];
    [_cancelButton setX:self.width];
    [UIView commitAnimations];
}

- (void)cancelButtonFinishedAnimatingIn:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [_cancelButton addTarget:self action:@selector(onCancelPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelButtonFinishedAnimatingOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
}

- (void)onCancelPress:(id)sender
{
    [_searchTextField resignFirstResponder];
    [self hideCancelButton];
    _searchTextField.text = @"";
    [self onSearchFieldTextUpdate:nil];
}

#pragma mark - init stuff

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self buildSearchPlaceHolderTextField];
        [self buildSearchTextField];
        [self buildMagnifyingGlassIcon];
        [self buildCancelButton];
    }
    return self;
}

#pragma mark - textfield delegate stuff

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showCancelButton];
}

@end
