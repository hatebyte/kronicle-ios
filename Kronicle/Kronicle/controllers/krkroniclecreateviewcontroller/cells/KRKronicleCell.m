//
//  KRKronicleCell.m
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleCell.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"


@interface KRKronicleCell () {
    @private
    UITextField *_titleField;
    UITextView *_descriptionView;
    UIImageView *_imageView;
    
}

@end

@implementation KRKronicleCell

+ (CGFloat)returnHeight {
    return [UIScreen mainScreen].bounds.size.height - 120.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
        _imageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_imageView];
        
        
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x,
                                                                    _imageView.frame.origin.y + _imageView.frame.size.height,
                                                                    280,
                                                                    40)];
        _titleField.backgroundColor = [UIColor grayColor];
        _titleField.placeholder = @"Kronicle Title";
        [self.contentView addSubview:_titleField];
        
        
        _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(_titleField.frame.origin.x,
                                                                        _titleField.frame.origin.y + _titleField.frame.size.height + 20,
                                                                        _titleField.frame.size.width,
                                                                        100)];
        _descriptionView.backgroundColor = [UIColor grayColor];
        _descriptionView.text = @"Kronicle Description";
        [self.contentView addSubview:_descriptionView];
        
        
    }
    return self;
}



- (void)prepareForUseWithKronicle:(KRKronicle*)kronicle {
    self.kronicle = kronicle;
    
    
}

- (void)collapse {

}

- (void)expand {

}


#pragma textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.kronicle.title = _titleField.text;
}


#pragma textview delegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.kronicle.description = _descriptionView.text;
}

@end



































