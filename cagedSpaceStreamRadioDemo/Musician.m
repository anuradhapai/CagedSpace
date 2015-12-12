//
//  Musician.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "Musician.h"

@implementation Musician

@synthesize musicianName = _musicianName;
@synthesize musicianCaption = _musicianCaption;
@synthesize musicianImageURLString = _musicianImageURLString;


-(id)initWithMusicianName:(NSString *)musicianName caption:(NSString *)musicianCaption image:(NSString *)musicianImageURLString {
    
    self = [super init];
    
    if(self){
        _musicianName = musicianName;
        _musicianCaption = musicianCaption;
        _musicianImageURLString = musicianImageURLString;
    }
    
    return self;
    
}

@end
