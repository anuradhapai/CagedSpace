//
//  JSONParser.m
//  Homework 01
//
//  Created by Anu on 11/07/15.
//  Copyright (c) 2015 Anuradha Pai. All rights reserved.
//

#import "JSONParser.h"
#import "Musician.h"


NSString* const orchestraDetailsURLString = @"http://52.26.164.148:8080/CagedSpaceWS/rest/grids/orchestra";
//NSString* const floorMapURLString = @"http://52.26.164.148:8080/CagedSpaceWS/rest/grids/floorMap";


@interface JSONParser ()
@end

@implementation JSONParser

-(void) fetchOrchestraDetails
{
    self.musiciansArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSURL *url = [NSURL URLWithString:orchestraDetailsURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest: request
                                                    completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                        
                                                        NSData *data = [[NSData alloc] initWithContentsOfURL:localfile];
                                                        NSMutableArray *orchestraJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                                        
                                                        //NSLog(@"---printing orchestra details JSON --- %@", orchestraJSON);
                                                        
                                                        for (NSDictionary *musicianDetails in orchestraJSON) {
                                                            
                                                            NSString *name = musicianDetails[@"playerName"];
                                                            NSString *image =  musicianDetails[@"playerPhoto"];
                                                            NSString *caption = musicianDetails[@"playerCaption"];
                                                            
                                                            Musician *musician = [[Musician alloc]initWithMusicianName:name caption:caption image:image];
                                                            [self.musiciansArray addObject:musician];
                                                            NSLog(@"-----%@ --- musicians array---",self.musiciansArray);
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.parsingDelegate didFinishFetchingOrchestraDetails:self.musiciansArray];
                                                            
                                                        });
                                                        
                                                    }];
    
    
    [task resume];
}

//- (void) fetchFloorMap {
//    
//    NSURL *url = [NSURL URLWithString:floorMapURLString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
//        
//        NSLog(@"---%@ data ---- ", data);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.parsingDelegate didFinishFetchingFloorMap:imageURL];
//            
//        });
//
//    }];
//    [dataTask resume];
//    
//}
@end
