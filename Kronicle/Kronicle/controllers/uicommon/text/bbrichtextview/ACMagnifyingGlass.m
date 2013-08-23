//
//  ACMagnifyingGlass.m
//  MagnifyingGlass
//

#import "ACMagnifyingGlass.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kACMagnifyingGlassDefaultRadius = 50;
static CGFloat const kACMagnifyingGlassDefaultOffset = -120;
static CGFloat const kACMagnifyingGlassDefaultScale = 2;

@interface ACMagnifyingGlass ()
@end

@implementation ACMagnifyingGlass

@synthesize viewToMagnify, touchPoint, touchPointOffset, scale, scaleAtTouchPoint;

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, kACMagnifyingGlassDefaultRadius*2, kACMagnifyingGlassDefaultRadius*2)];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
        self.transform = transform;

		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = frame.size.width / 2;
		self.layer.masksToBounds = YES;
		self.touchPointOffset = CGPointMake(0, kACMagnifyingGlassDefaultOffset);
		self.scale = kACMagnifyingGlassDefaultScale;
		self.viewToMagnify = nil;
		self.scaleAtTouchPoint = YES;
        
		self.layer.borderWidth = 0;
		UIImageView *loupeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
		loupeImageView.image = [UIImage imageNamed:@"kb-loupe-hi"];
		//loupeImageView.backgroundColor = [UIColor clearColor];
        loupeImageView.transform = transform;
		[self addSubview:loupeImageView];
	}
	return self;
}

- (void)setFrame:(CGRect)f {
	super.frame = f;
	self.layer.cornerRadius = f.size.width / 2;
}

- (void)setTouchPoint:(CGPoint)point {
	touchPoint = point;
	self.center = CGPointMake(point.x + touchPointOffset.x, self.superview.frame.size.height - (point.y + touchPointOffset.y + 30));
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
	CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.height / 2);
	CGContextScaleCTM(context, scale, scale);
	CGContextTranslateCTM(context, -touchPoint.x, -touchPoint.y);
	[self.viewToMagnify.layer renderInContext:context];
}

@end
