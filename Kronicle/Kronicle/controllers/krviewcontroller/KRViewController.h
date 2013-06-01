//
//  KRViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ViewController.h"
#import "KRKronicle.h"
#import "KRSwipeUpScrollView.h"
#import "MediaView.h"
#import "KRDiagramView.h"

@interface KRViewController : UIViewController <KRSwipeUpScrollViewDelegate> {
    @private
    CGRect _bounds;
    KRSwipeUpScrollView *_scrollView;
    KRDiagramView *_circleDiagram; // extended custom
    MediaView *_mediaViewA; // extend custom
    MediaView *_mediaViewB; // extend custom
    MediaView *_activeMedia; // extend custom
    IBOutlet UIImageView *_playpauseButton; // extend custom
    IBOutlet UIImageView *_listViewButton;
    
    id activePlayer;
}

@property (nonatomic, strong) KRKronicle *kronicle;

- (IBAction)gotToKronicleListView:(id)sender;
- (IBAction)togglePlayPause:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;

@end
