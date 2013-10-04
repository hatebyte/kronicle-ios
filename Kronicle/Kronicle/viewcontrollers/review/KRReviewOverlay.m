//
//  KRReviewOverlay.m
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRReviewOverlay.h"
#import "CreateReviewView.h"
#import "UIHelper.h"
#import "KRGlobals.h"
#import "KeyboardNavigationToolBar.h"

@interface KRReviewOverlay () <UITextViewDelegate, KeyboardNavigationToolBarDelegate> {
    @private
    CreateReviewView *_reviewCreatorView;
    UITextField *_titleField;
    UIButton *_cancelXButton;
    UIButton *_saveButton;
    UITextView *_textArea;
    UILabel *_placeholderLabel;
    UIButton *_clearTextViewButton;
}

@end

@implementation KRReviewOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                        = [UIColor blackColor];
        
        _titleField                                 = [UIHelper titleTextField];
        _titleField.frame                           = CGRectMake(kPadding, 20, kPaddingWidth, 90);
        _titleField.enabled                         = NO;
        _titleField.placeholder                     = NSLocalizedString(@"My Review", @"Title of review view controller");
        [_titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

        _reviewCreatorView = [[CreateReviewView alloc] initWithFrame:CGRectMake((self.frame.size.width - [CreateReviewView size]) * .5,
                                                                                _titleField.frame.origin.y + _titleField.frame.size.height - 20,
                                                                                [CreateReviewView size],
                                                                                [CreateReviewView size]) andType:CreateReviewViewCreate];

//        [_reviewCreatorView setReviewWithValue:.3/*kronicle.rating*/];
        [self addSubview:_reviewCreatorView];
        [self addSubview:_titleField];
        
        _textArea                               = [[UITextView alloc] initWithFrame:CGRectMake(kPadding-8,
                                                                                               _reviewCreatorView.frame.origin.y + _reviewCreatorView.frame.size.height,
                                                                                               kPaddingWidth,
                                                                                               115)];
        _textArea.font                          = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _textArea.delegate                      = self;
        _textArea.scrollEnabled                 = YES;
        _textArea.textColor                     = [UIColor whiteColor];
        _textArea.backgroundColor               = [UIColor clearColor];
        _textArea.returnKeyType                 = UIReturnKeyDone;
        [self addSubview:_textArea];

        _placeholderLabel                       = [[UILabel alloc] initWithFrame: CGRectMake(_textArea.frame.origin.x + 8,
                                                                                             _textArea.frame.origin.y + 7,
                                                                                             _textArea.frame.size.width,
                                                                                             30)];
        _placeholderLabel.font                  = [KRFontHelper getFont:KRMinionProRegular withSize:20];
        _placeholderLabel.textColor             = [UIColor whiteColor];
        _placeholderLabel.text                  = NSLocalizedString(@"You can give some details here", @"placeholder text for review overlay textview");
        _placeholderLabel.backgroundColor       = [UIColor clearColor];
        _placeholderLabel.userInteractionEnabled = NO;
        [self addSubview:_placeholderLabel];
        
        _clearTextViewButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearTextViewButton setImage:[UIImage imageNamed:@"close-x"] forState:UIControlStateNormal];
        [_clearTextViewButton addTarget:self action:@selector(clearTextArea) forControlEvents:UIControlEventTouchUpInside];
        _clearTextViewButton.hidden             = YES;
        _clearTextViewButton.frame              = CGRectMake((_textArea.frame.origin.x + _textArea.frame.size.width) - 30,
                                                             (_textArea.frame.origin.y + _textArea.frame.size.height) - 30,
                                                             30,
                                                             30);
        [self addSubview:_clearTextViewButton];
        
        KeyboardNavigationToolBar *toolbar = [[KeyboardNavigationToolBar alloc] initWithPreviousAndNext:YES :YES];
        toolbar.delegate = self;
        [toolbar setNextEnabled:NO];
        [toolbar setPreviousEnabled:NO];
        [_textArea setInputAccessoryView:toolbar];


        _cancelXButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelXButton.frame = CGRectMake(self.frame.size.width - 35, 0, 35, 35);
        _cancelXButton.backgroundColor = [UIColor clearColor];
        [_cancelXButton setImage:[UIImage imageNamed:@"cancel_x"] forState:UIControlStateNormal];
        [_cancelXButton addTarget:self action:@selector(exitPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelXButton];
        
        NSInteger saveButtonHeight = 42;
        _saveButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = [KRColorHelper turquoise];
        [_saveButton setTitle:@"Post Review" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:14];
        _saveButton.frame = CGRectMake(kPadding, self.frame.size.height-(saveButtonHeight+kPadding), 82, saveButtonHeight);
        [_saveButton addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
    }
    return self;
}


- (IBAction)exitPressed:(id)sender {
    [self.delegate reviewOverlayCancelled];
}

- (IBAction)savePressed:(id)sender {
    [self.delegate reviewOverlay:self finishedWithValue:_reviewCreatorView.percent];
}

- (void)clearTextArea {
    _textArea.text = @"";
    _placeholderLabel.hidden = NO;
    _clearTextViewButton.hidden = YES;
    [_textArea performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}

- (void)setReviewWithValue:(CGFloat)value {
    [_reviewCreatorView setReviewWithValue:value];
}

#pragma UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self animateUp];
    if ( textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self animateDown];
    if ( textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = YES;
    }
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location > 0 || text.length != 0) {
        _placeholderLabel.hidden = YES;
        _clearTextViewButton.hidden = NO;
    } else {
        _placeholderLabel.hidden = NO;
        _clearTextViewButton.hidden = YES;
    }
    return YES;
}


#pragma mark animate 
- (void)animateUp {
    CGFloat bottomY = _textArea.frame.size.height + _textArea.frame.origin.y + 20;
    CGFloat keyboardY = self.frame.size.height - (216.f + 44.f);
    CGFloat offsetY =  bottomY - keyboardY;

    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, -offsetY, self.frame.size.width, self.frame.size.height);

                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)animateDown {
    [UIView animateWithDuration:.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL fin){
                     }];
}


#pragma keyboard toolbar
- (void)customToolBar:(KeyboardNavigationToolBar*)toolbar buttonClicked:(KeyboardNavigationToolBarButton)selectedId {
    [_textArea resignFirstResponder];
    [self animateDown];
}
@end



















