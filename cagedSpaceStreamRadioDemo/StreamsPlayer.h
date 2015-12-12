//
//  StreamsPlayer.h
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamPlayerDelegate.h"

@interface StreamsPlayer : NSObject
@property (nonatomic, weak) id<StreamPlayerDelegate> delegate;
+ (id)sharedManager;
- (void)startRangingCagedSpaceBeacons;

@end
