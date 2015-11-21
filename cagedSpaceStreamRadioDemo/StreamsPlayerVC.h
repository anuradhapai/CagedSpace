//
//  StreamsPlayerVC.h
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 10/28/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface StreamsPlayerVC :UIViewController
@property (nonatomic, strong) AVPlayer *audioPlayer1;
@property (nonatomic, strong) AVPlayer *audioPlayer2;
- (IBAction)stream1:(id)sender;
- (IBAction)stream2:(id)sender;
- (IBAction)stream3:(id)sender;
@end
