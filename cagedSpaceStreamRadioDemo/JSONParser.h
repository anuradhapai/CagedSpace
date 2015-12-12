//
//  JSONParser.h
//  Homework 01
//
//  Created by Anu on 11/07/15.
//  Copyright (c) 2015 Anuradha Pai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParsingDelegate.h"

@interface JSONParser : NSObject

@property (nonatomic, strong) NSMutableArray *musiciansArray;
@property (nonatomic, strong) NSMutableArray *storiesArray;

@property (weak) id<JSONParsingDelegate> parsingDelegate;

-(void) fetchOrchestraDetails;
//- (void) fetchFloorMap;

@end
