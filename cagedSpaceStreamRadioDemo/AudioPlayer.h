//
//  AudioPlayer.h
//  Homework1
//
//  Created by student on 7/14/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject
@property (nonatomic, retain) AVPlayer *audioPlayer;

// Public methods
- (void)initPlayer:(NSString*) audioURL;



@end

