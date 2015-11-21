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

NSString* const nsStream0 = @"http://listen.radionomy.com/blacklabelfm";
NSString* const nsStream1 = @"http://cms.stream.publicradio.org/cms.mp3";
NSString* const nsStream2 = @"http://streaming.radionomy.com/ABC-Piano";

@interface StreamsPlayerVC ()<ESTBeaconManagerDelegate>

@property(strong,nonatomic)NSMutableDictionary* mediaPlayers;
@property(strong,nonatomic)NSMutableArray* streams;
@property(strong,nonatomic)NSMutableDictionary* streamsDict;
@property (nonatomic) NSDictionary *placesByBeacons;
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconProximityCounter;
@property (weak, nonatomic) IBOutlet UILabel *streamNo;
@property(retain,nonatomic) AVPlayer* avPlayer;


@end

@implementation StreamsPlayerVC

const int MINIMUM_NUMBER_OF_TIMES_SAME_BEACON = 3;
int currentStreamId=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    _avPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:nsStream0]];
    self.placesByBeacons = @{
                             @"57673:45085": @"http://listen.radionomy.com/blacklabelfm",
                             @"44642:44519": @"http://cms.stream.publicradio.org/cms.mp3",
                             @"16079:18304":@"http://streaming.radionomy.com/ABC-Piano"
                             //                             @"20256:28960": [NSNumber numberWithInt:0],
                             //                             @"35131:24072": [NSNumber numberWithInt:2],
                             //                             @"34567:20852":[NSNumber numberWithInt:1]
                             };
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    [self.beaconManager requestAlwaysAuthorization];
    
    
    _beaconProximityCounter = [NSMutableDictionary new];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] identifier:@"ICE BEACON"];
    
    currentStreamId = 0;
//    self.mediaPlayers = [[NSMutableDictionary alloc]init];
//    
//    self.streams = [[NSMutableArray alloc] init];
//    [self.streams addObject:nsStream0];
//    [self.streams addObject:nsStream1];
//    [self.streams addObject:nsStream2];
    
//    for(int i=0;i<3;i++){
//        MediaPlayerData* data =[[MediaPlayerData alloc]init];
//        //AVPlayer *player =[[AVPlayer alloc] init];
//        data.avplayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.streams[i]]];
//        // data.avplayer = [[AVPlayer alloc]init];
//        // data.avplayer = player;
//        [self.mediaPlayers setObject:data forKey:[NSNumber numberWithInt:i]];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons
             inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        NSNumber* place = [self placeNearBeacon:nearestBeacon];
//        NSArray *allKeys = [_beaconProximityCounter allKeys];
        
        if(place !=nil){
            
            
            //NSNumber *previousPlace = nil;
            
            if ([allKeys count] > 0) {
                //previousPlace = [_beaconProximityCounter allKeys][0];
//                for(id key in _beaconProximityCounter)
//                    NSLog(@"key=%@ value=%@", key, [_beaconProximityCounter objectForKey:key]);
                if([_beaconProximityCounter objectForKey:place] != nil){
                    NSNumber *counter = [_beaconProximityCounter objectForKey:place];
                    if([counter intValue] >= MINIMUM_NUMBER_OF_TIMES_SAME_BEACON){
                        currentStreamId = [place intValue];
                        [_avPlayer ]
//                        MediaPlayerData * data = [self.mediaPlayers objectForKey:place];
                        // NSLog(@"%ld",(long)data.avplayer.status) ;
                        //[data.avplayer addObserver:self forKeyPath:@"status" options:0 context:nil];
                        //[data.avplayer play];

                        NSArray *keys = [self.mediaPlayers allKeys];
                        MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:currentStreamId]];
                                                        [data.avplayer play];
                                                        //[data.avplayer setVolume:0.1];
                                                        //[self doVolumeFadeInOnMediaPlayerData:data];
                                                        [self.streamNo setText:[NSString stringWithFormat:@"%d",currentStreamId]];
                        
                        
//                        for(int k = 0;k<[keys count];k++){
//                            
//                            
//                            if(k==currentStreamId){
//                                MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:k]];
//                                [data.avplayer play];
//                                [data.avplayer setVolume:0.1];
//                                [self doVolumeFadeInOnMediaPlayerData:data];
//                                [self.streamNo setText:[NSString stringWithFormat:@"%d",currentStreamId]];
//                            }
//                            else{
//                                MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:k]];
//                                [self doVolumeFadeOutOnMediaPlayerData:data];
//                                [data.avplayer pause];
//                                
//                            }
//                        }
                        
                        NSLog(@"At place %d",[place intValue]);
                        [_beaconProximityCounter removeAllObjects];
                        
                    }
                    else{
                        int value = [counter intValue];
                        [_beaconProximityCounter setObject:[NSNumber numberWithInt:value+1] forKey:place];
                    }
                    
                }
                else{
                    [_beaconProximityCounter setObject:[NSNumber numberWithInt:1] forKey:place];
                }
                
            }
            else{
                [_beaconProximityCounter setObject:[NSNumber numberWithInt:1] forKey:place];
            }
            
            //                NSLog(@"%@",[NSString stringWithFormat:@"%@:%@",
            //                     nearestBeacon.major, nearestBeacon.minor]);
        }
    }
    
}

-(void) doVolumeFadeOutOnMediaPlayerData: (MediaPlayerData *) mediaPlayerData
{
    if (mediaPlayerData.avplayer.volume > 0.1) {
        mediaPlayerData.avplayer.volume = mediaPlayerData.avplayer.volume - 0.1;
        [self performSelector:@selector(doVolumeFadeOutOnMediaPlayerData:) withObject:nil afterDelay:5];
    }
}

-(void) doVolumeFadeInOnMediaPlayerData: (MediaPlayerData *) mediaPlayerData
{
    if (mediaPlayerData.avplayer.volume < 1.0) {
        mediaPlayerData.avplayer.volume = mediaPlayerData.avplayer.volume + 0.1;
        [self performSelector:@selector(doVolumeFadeInOnMediaPlayerData:) withObject:nil afterDelay:5];
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
- (NSNumber *)placeNearBeacon:(CLBeacon *)beacon {
    NSString *beaconKey = [NSString stringWithFormat:@"%@:%@",
                           beacon.major, beacon.minor];
    NSNumber *place = [self.placesByBeacons objectForKey:beaconKey];
    //    if (place==nil) {
    //        return 0;
    //    }
    return place;
    
}
@end
