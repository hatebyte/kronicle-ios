//
//  KRViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ViewController.h"
#import "KRKronicle.h"

@interface KRViewController : UIViewController {
    @private
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *circleDiagram; // extended custom
    IBOutlet UIView *mediaViewA; // extend custom
    IBOutlet UIView *mediaViewB; // extend custom
    IBOutlet UIImageView *playpauseButton; // extend custom
    IBOutlet UIImageView *listViewButton;
    
    id activePlayer;
}

@property (nonatomic, strong) KRKronicle *kronicle;

- (IBAction)gotToKronicleListView:(id)sender;
- (IBAction)togglePlayPause:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;

@end
