//
//  Musician.h
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Musician : NSObject

@property (strong, nonatomic) NSString *musicianName;
@property (strong, nonatomic) NSString *musicianCaption;
@property (strong, nonatomic) NSString *musicianImageURLString;

- (id)initWithMusicianName:(NSString*) musicianName
             caption:(NSString *)musicianCaption
          image:(NSString*) musicianImageURLString;

@end
