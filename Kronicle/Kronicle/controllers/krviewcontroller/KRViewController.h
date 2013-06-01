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

@interface KRViewController : UIViewController <KRSwipeUpScrollViewDelegate, KRDiagramViewDelegate> {
    @private
    CGRect _bounds;
    KRSwipeUpScrollView *_scrollView;
    KRDiagramView *_circleDiagram; 
//    UIImageView *_circleDiagramBackup; 
    MediaView *_mediaViewA; 
    MediaView *_mediaViewB;  
    MediaView *_activeMedia;  
    IBOutlet UIImageView *_playpauseButton;  
    IBOutlet UIImageView *_listViewButton;
    
    id activePlayer;
}

@property (nonatomic, strong) KRKronicle *kronicle;

- (IBAction)gotToKronicleListView:(id)sender;
- (IBAction)togglePlayPause:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;

@end
