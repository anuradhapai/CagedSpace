//
//  JSONParsingDelegate.h
//  Homework 01
//
//  Created by Anu on 11/07/15.
//  Copyright (c) 2015 Anuradha Pai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONParsingDelegate <NSObject>
@optional
-(void) didFinishFetchingStreamsAndBeacons;
@optional
-(void) didFinishFetchingOrchestraDetails: (NSMutableArray *) musicians;

//@optional
//-(void) didFinishFetchingFloorMap: (NSData *) floorMapImageData;

@end
