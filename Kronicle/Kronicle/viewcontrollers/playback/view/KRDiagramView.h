//
//  KRDiagramView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRDiagramView;

@protocol KRDiagramViewDelegate <NSObject>

- (void)diagramView:(KRDiagramView*)diagramView withDegree:(CGFloat)percent;

@end

@interface KRDiagramView : UIView {
    @private
    UIImageView *_imageView;
}

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, weak) id<KRDiagramViewDelegate> delegate;

@end
