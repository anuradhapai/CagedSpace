//
//  StreamsPlayerVC.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 10/28/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "StreamsPlayerVC.h"
#import "MediaPlayerData.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "NSURL+Additions.h"

NSString* const amazonURLString = @"http://52.26.164.148:8080/CagedSpaceWS/rest/grids";

static void *CurrentPlayerStatusObservationContext = &CurrentPlayerStatusObservationContext;
static void *NextPlayerStatusObservationContext = &NextPlayerStatusObservationContext;

@interface StreamsPlayerVC ()<ESTBeaconManagerDelegate>

@property(strong,nonatomic)NSMutableDictionary* mediaPlayers;
@property(strong,nonatomic)NSMutableArray* streams;
@property(strong,nonatomic)NSMutableDictionary* streamsDict;
@property (nonatomic) NSMutableDictionary *streamsByBeacons;
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconProximityCounter;
@property (weak, nonatomic) IBOutlet UILabel *streamNo;
@property (strong, nonatomic) NSMutableDictionary* avPlayers;
@property (strong, nonatomic) AVPlayer* currentPlayer;
@property (strong, nonatomic) NSURL* prevStreamURL;
@property (strong, nonatomic) AVPlayer* nextPlayer;



@end

@implementation StreamsPlayerVC

const int MINIMUM_NUMBER_OF_TIMES_SAME_BEACON = 3;
int currentStreamId=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *amazonURL = [NSURL URLWithString:amazonURLString];
    [self fetchStreamsByBeaconsFromURL:amazonURL];
    
    _avPlayers = [[NSMutableDictionary alloc] initWithCapacity:20];
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
    [self.beaconManager requestAlwaysAuthorization];
    
    
    _beaconProximityCounter = [NSMutableDictionary new];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] identifier:@"ICE BEACON"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

                    NSURL *streamURL = [NSURL URLWithString:self.streamsByBeacons[nearestBeaconKey]];
                    if (self.currentPlayer == nil) {
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            self.currentPlayer = [AVPlayer playerWithURL:streamURL];
                            [self.currentPlayer addObserver:self forKeyPath:@"status" options:0 context:CurrentPlayerStatusObservationContext];
                            [self.currentPlayer play];
                        }];
                        self.prevStreamURL = streamURL;
                    }else if(![self.prevStreamURL isEquivalent:streamURL]){
                        self.nextPlayer = [AVPlayer playerWithURL:streamURL];

                        [self.nextPlayer addObserver:self forKeyPath:@"status" options:0 context:NextPlayerStatusObservationContext];
                        
                        self.prevStreamURL = streamURL;
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
    NSLog(@"---- called doVolumeFadeOutOnAVPlayer ----");
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
    NSLog(@"---- called doVolumeFadeInOnAVPlayer ----");
    
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * localFile, NSURLResponse * response, NSError * error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:localFile];
        
        NSMutableArray *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
     
        //NSLog(@"---printing JSON --- %@", resultJSON);
        
        for (NSDictionary *gridDetails in resultJSON) {
            NSString *streamURL =  gridDetails[@"streamURL"];
            NSString *beaconID = gridDetails[@"beaconId"];
            [self.streamsByBeacons setObject:streamURL forKey:beaconID];
        }
        NSLog(@"---streamsByBeacons---- %@",self.streamsByBeacons);
    }];
    
    [task resume];

}

@end
