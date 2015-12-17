//
//  StreamsPlayer.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "StreamsPlayer.h"

#import "MediaPlayerData.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "NSURL+Additions.h"
#import <MMDrawerController/MMDrawerController.h>
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "Parse/Parse.h"

NSString* const amazonURLString = @"http://52.26.164.148:8080/CagedSpaceWS/rest/grids";

//NSString* const amazonURLString = @"http://10.38.11.156:8081/CagedSpaceWS/rest/grids";

static void *CurrentPlayerStatusObservationContext = &CurrentPlayerStatusObservationContext;
static void *NextPlayerStatusObservationContext = &NextPlayerStatusObservationContext;

@interface StreamsPlayer()<ESTBeaconManagerDelegate>

@property(strong,nonatomic)NSMutableDictionary* mediaPlayers;
@property(strong,nonatomic)NSMutableArray* streams;
@property(strong,nonatomic)NSMutableDictionary* streamsDict;
@property (nonatomic) NSMutableDictionary *streamsByBeacons;
@property (nonatomic) NSMutableDictionary *BeaconIdsByGridIds;
@property (nonatomic) NSMutableDictionary *BeaconIdsByGridImages;
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconProximityCounter;
@property (weak, nonatomic) IBOutlet UILabel *streamNo;
@property (strong, nonatomic) AVPlayer* currentPlayer;
@property (strong, nonatomic) NSURL* prevStreamURL;
@property (strong, nonatomic) AVPlayer* nextPlayer;
@property (nonatomic) NSString* userId;


@end

@implementation StreamsPlayer

const int MINIMUM_NUMBER_OF_TIMES_SAME_BEACON = 3;
int currentStreamId=0;


+ (id)sharedManager {
    static StreamsPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        [self startRangingCagedSpaceBeacons];
    }
    return self;
}

- (void) startRangingCagedSpaceBeacons{
    NSURL *amazonURL = [NSURL URLWithString:amazonURLString];
    [self fetchStreamsByBeaconsFromURL:amazonURL];
    
    //    self.streamsByBeacons = @{
    //                              //                             @"57673:45085": @"http://listen.radionomy.com/blacklabelfm",
    //                              //                             @"44642:44519": @"http://cms.stream.publicradio.org/cms.mp3",
    //                              //                             @"16079:18304": @"http://streaming.radionomy.com/ABC-Piano"
    //                              //
    //                              @"3667:41637": @"http://listen.radionomy.com/blacklabelfm",
    //                              @"3787:10809": @"http://cms.stream.publicradio.org/cms.mp3",
    //                              @"43499:60906": @"http://streaming.radionomy.com/ABC-Piano"
    //                              //                             @"20256:28960": [NSNumber numberWithInt:0],
    //                              //                             @"35131:24072": [NSNumber numberWithInt:2],
    //                              //                             @"34567:20852":[NSNumber numberWithInt:1]
    //                              };
    //
    
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    [self.beaconManager requestWhenInUseAuthorization];
    
    
    _beaconProximityCounter = [NSMutableDictionary new];
    
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] identifier:@"ICE BEACON"];
    
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc]initWithUUIDString:@"7455EF5F-50AE-5EC6-ACD9-6EE22A52A0AA"] identifier:@"ICE BEACON"];
    if([PFUser currentUser]==nil){
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Anonymous login failed.");
            } else {
                self.userId =[NSString stringWithFormat:@"%@",user.objectId ];
                NSLog(@"****%@",self.userId);
                NSLog(@"Anonymous user logged in.");
            }
        }];
        
        
        
        
    }
    else{
        PFUser* user=[PFUser currentUser];
        self.userId =[NSString stringWithFormat:@"%@",user.objectId ];
        NSLog(@"****%@",self.userId);

        
    }
   
}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        
        NSString* stream = [self streamForBeacon:nearestBeacon];
        NSArray *allKeys = [_beaconProximityCounter allKeys];
        
        NSString *previousStream = nil;
        
        if ([allKeys count] > 0) {
            previousStream = [_beaconProximityCounter allKeys][0];
        }
        
        NSString *nearestBeaconKey = [NSString stringWithFormat:@"%@:%@",
                                      nearestBeacon.major, nearestBeacon.minor];
        
        if (stream != nil) {
            if (previousStream == nil) {
                //first time
                NSNumber* count = [NSNumber numberWithInt:1];
                [_beaconProximityCounter setObject:count forKey:stream];
                
            } else if ([previousStream isEqualToString:stream]) {
                
                NSNumber *count = [_beaconProximityCounter objectForKey:stream];
                
                int value = [count intValue];
                if (value >= MINIMUM_NUMBER_OF_TIMES_SAME_BEACON) {
                    //do your action
                    [_delegate didEnterRegion:nearestBeaconKey];
                    NSURL *streamURL = [NSURL URLWithString:self.streamsByBeacons[nearestBeaconKey]];
                    if (self.currentPlayer == nil) {
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            self.currentPlayer = [AVPlayer playerWithURL:streamURL];
                            [self.currentPlayer addObserver:self forKeyPath:@"status" options:0 context:CurrentPlayerStatusObservationContext];
                            [self.currentPlayer play];
                        }];
                        [_delegate updateGridImage:self.BeaconIdsByGridImages[nearestBeaconKey]];
                        //Parse logic
                        PFQuery *query = [PFUser query];
                              NSLog(@"***ppppp*%@",query);
                        // Retrieve the object by id
                        [query getObjectInBackgroundWithId:self.userId
                                                     block:^(PFObject *userObject, NSError *error) {
                                                         NSLog(@"***ppppp*%@",userObject);
                                                         userObject[@"currentGrid"] = self.BeaconIdsByGridIds[nearestBeaconKey];
                                                         [userObject saveInBackground];
                                                     }];
                        self.prevStreamURL = streamURL;
                    }else if(![self.prevStreamURL isEquivalent:streamURL]){
                        self.nextPlayer = [AVPlayer playerWithURL:streamURL];
                        
                        [self.nextPlayer addObserver:self forKeyPath:@"status" options:0 context:NextPlayerStatusObservationContext];
                        
                        self.prevStreamURL = streamURL;
                        
                        [_delegate updateGridImage:self.BeaconIdsByGridImages[nearestBeaconKey]];
                        //Parse logic
                        PFQuery *query = [PFQuery queryWithClassName:@"User"];
                        
                        // Retrieve the object by id
                        [query getObjectInBackgroundWithId:self.userId
                                                     block:^(PFObject *userObject, NSError *error) {
                                                         
                                                         userObject[@"currentGrid"] = self.BeaconIdsByGridIds[nearestBeaconKey];
                                                         [userObject saveInBackground];
                                                     }];

                        
                    }
                    
                    NSLog(@"----------------At Stream %@-------------------",stream);
                    
                    [_beaconProximityCounter removeAllObjects];
                }else{
                    count = [NSNumber numberWithInt:value + 1];
                    [_beaconProximityCounter setObject:count forKey:stream];
                }
            }else{
                [_beaconProximityCounter removeAllObjects];
                
                NSNumber* count = [NSNumber numberWithInt:1];
                [_beaconProximityCounter setObject:count forKey:stream];
            }
            
        }else{
            
            NSLog(@"----------------Someone elses beacon nearby---------%@-----------",nearestBeaconKey);
        }
    }
}


-(void) doVolumeFadeOutOnAVPlayer:(AVPlayer *) avPlayer
{
    //NSLog(@"---- called doVolumeFadeOutOnAVPlayer ----");
    if ([avPlayer respondsToSelector:@selector(setVolume:)]) {
        if (avPlayer.volume > 0.2) {
            avPlayer.volume = avPlayer.volume - 0.05;
            [NSThread sleepForTimeInterval:0.25];
            [self performSelectorOnMainThread:@selector(doVolumeFadeOutOnAVPlayer:) withObject:avPlayer waitUntilDone:YES];
        }else{
            NSLog(@"--------fade out completely done -----------");
            [avPlayer pause];
        }
    }else {
        NSLog(@"---- Does not respond to set volume ----");
    }
    
}

-(void) doFadeInFadeOutOfPlayers:(NSArray *) avPlayers{
    AVPlayer *fadeOutPlayer = self.currentPlayer;
    AVPlayer *fadeInPLayer = self.nextPlayer;
    
    if ([fadeOutPlayer respondsToSelector:@selector(setVolume:)] && [fadeInPLayer respondsToSelector:@selector(setVolume:)]) {
        if (fadeOutPlayer.volume > 0.1) {
            fadeOutPlayer.volume = fadeOutPlayer.volume - 0.05;
            fadeInPLayer.volume = fadeInPLayer.volume + 0.05;
            [NSThread sleepForTimeInterval:0.25];
            [self performSelectorOnMainThread:@selector(doVolumeFadeOutOnAVPlayer:) withObject:@[fadeInPLayer,fadeOutPlayer] waitUntilDone:YES];
        }else{
            NSLog(@"--------fade out completely done -----------");
            [fadeOutPlayer pause];
        }
    }else {
        NSLog(@"---- Does not respond to set volume ----");
    }
    
}

-(void) doVolumeFadeInOnAVPlayer: (AVPlayer *) avPlayer
{
    //NSLog(@"---- called doVolumeFadeInOnAVPlayer ----");
    
    if ([avPlayer respondsToSelector:@selector(setVolume:)]) {
        if (avPlayer.volume < 1.0) {
            avPlayer.volume = avPlayer.volume + 0.05;
            [NSThread sleepForTimeInterval:0.25];
            [self performSelectorOnMainThread:@selector(doVolumeFadeInOnAVPlayer:) withObject:avPlayer waitUntilDone:YES];
        }else{
            NSLog(@"-------- fade In completely done --------");
        }
    }
}


- (NSString *)streamForBeacon:(CLBeacon *)beacon {
    NSString *beaconKey = [NSString stringWithFormat:@"%@:%@",
                           beacon.major, beacon.minor];
    NSString *stream = [self.streamsByBeacons objectForKey:beaconKey];
    return stream;
    
}

- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == NextPlayerStatusObservationContext) {
        if (self.nextPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"------next player ready to play--------");
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                [self doVolumeFadeOutOnAVPlayer:self.currentPlayer];
                [self.currentPlayer removeObserver:self forKeyPath:@"status"];
                self.currentPlayer = self.nextPlayer;
                [self.currentPlayer play];
                self.currentPlayer.volume = 0.0;
                [self doVolumeFadeInOnAVPlayer:self.currentPlayer];
                
            }];
            
            
        }
    }else if (context == CurrentPlayerStatusObservationContext){
        if (self.currentPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"------player ready to play--------");
            
        }
    }
}


- (void) fetchStreamsByBeaconsFromURL: (NSURL *) url
{
    self.streamsByBeacons = [[NSMutableDictionary alloc] initWithCapacity:6];
    self.BeaconIdsByGridIds = [[NSMutableDictionary alloc] initWithCapacity:6];
    self.BeaconIdsByGridImages = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * localFile, NSURLResponse * response, NSError * error) {
        if (!error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:localFile];
            
            if (data) {
                NSMutableArray *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                
                //NSLog(@"---printing JSON --- %@", resultJSON);
                
                for (NSDictionary *gridDetails in resultJSON) {
                    NSString *streamURL =  gridDetails[@"streamURL"];
                    NSString *beaconID = gridDetails[@"beaconId"];
                    NSString *gridId = gridDetails[@"id"];
                    NSString *gridImage = gridDetails[@"gridImageURL"];
                    [self.streamsByBeacons setObject:streamURL forKey:beaconID];
                    [self.BeaconIdsByGridIds setObject:gridId forKey:beaconID];
                    [self.BeaconIdsByGridImages setObject:gridImage forKey:beaconID];
                }
                //NSLog(@"---streamsByBeacons---- %@",self.streamsByBeacons);
                //NSLog(@"---streamsByBeacons---- %@",self.BeaconIdsByGridImages);
                
                //start ranging as soon as fetched
                [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

            } else {
                //alert no data.. turn on internet
                NSLog(@"---fetchStreamsByBeaconsFromURL--- no data--- ");

            }
        } else {
            NSLog(@"---fetchStreamsByBeaconsFromURL--- error--- %@", error.localizedDescription);
            NSString *errorMessage = [error.localizedDescription stringByAppendingString:@" Please turn on your Wi-Fi"];
            [_delegate showAlertWithErrorMessage:errorMessage];
        }
        
            }];
    
    [task resume];
    
}

-(void)dealloc{
    NSLog(@"-----deallocating Streams Player------");
}
@end
