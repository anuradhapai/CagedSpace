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
@property (nonatomic) NSDictionary *streamsByBeacons;
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSMutableDictionary *beaconProximityCounter;
@property (weak, nonatomic) IBOutlet UILabel *streamNo;
@property (strong, nonatomic) NSMutableDictionary* avPlayers;
@property (strong, nonatomic) AVPlayer* currentPlayer;


@end

@implementation StreamsPlayerVC

const int MINIMUM_NUMBER_OF_TIMES_SAME_BEACON = 3;
int currentStreamId=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avPlayers = [[NSMutableDictionary alloc] initWithCapacity:20];
    self.streamsByBeacons = @{
//                             @"57673:45085": @"http://listen.radionomy.com/blacklabelfm",
//                             @"44642:44519": @"http://cms.stream.publicradio.org/cms.mp3",
//                             @"16079:18304": @"http://streaming.radionomy.com/ABC-Piano"
//                             
                             @"3667:41637": @"http://listen.radionomy.com/blacklabelfm",
                             @"3787:10809": @"http://cms.stream.publicradio.org/cms.mp3",
                             @"43499:60906": @"http://streaming.radionomy.com/ABC-Piano"
                             //                             @"20256:28960": [NSNumber numberWithInt:0],
                             //                             @"35131:24072": [NSNumber numberWithInt:2],
                             //                             @"34567:20852":[NSNumber numberWithInt:1]
                             };
    
    for(NSString *beacon in [self.streamsByBeacons allKeys]){
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:_streamsByBeacons[beacon]]];
        [avPlayer pause];
        _avPlayers[beacon] = avPlayer;
    }
        
        
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
//        NSString* streamStringURL = [self streamForBeacon:nearestBeacon];
////        NSArray *allKeys = [_beaconProximityCounter allKeys];
//        
//        if(place !=nil){
//            
//            
//            //NSNumber *previousPlace = nil;
//            
//            if ([allKeys count] > 0) {
//                //previousPlace = [_beaconProximityCounter allKeys][0];
////                for(id key in _beaconProximityCounter)
////                    NSLog(@"key=%@ value=%@", key, [_beaconProximityCounter objectForKey:key]);
//                if([_beaconProximityCounter objectForKey:place] != nil){
//                    NSNumber *counter = [_beaconProximityCounter objectForKey:place];
//                    if([counter intValue] >= MINIMUM_NUMBER_OF_TIMES_SAME_BEACON){
//                        currentStreamId = [place intValue];
//                        [_avPlayer ]
////                        MediaPlayerData * data = [self.mediaPlayers objectForKey:place];
//                        // NSLog(@"%ld",(long)data.avplayer.status) ;
//                        //[data.avplayer addObserver:self forKeyPath:@"status" options:0 context:nil];
//                        //[data.avplayer play];
//
//                        NSArray *keys = [self.mediaPlayers allKeys];
//                        MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:currentStreamId]];
//                                                        [data.avplayer play];
//                                                        //[data.avplayer setVolume:0.1];
//                                                        //[self doVolumeFadeInOnMediaPlayerData:data];
//                                                        [self.streamNo setText:[NSString stringWithFormat:@"%d",currentStreamId]];
//                        
//                        
////                        for(int k = 0;k<[keys count];k++){
////                            
////                            
////                            if(k==currentStreamId){
////                                MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:k]];
////                                [data.avplayer play];
////                                [data.avplayer setVolume:0.1];
////                                [self doVolumeFadeInOnMediaPlayerData:data];
////                                [self.streamNo setText:[NSString stringWithFormat:@"%d",currentStreamId]];
////                            }
////                            else{
////                                MediaPlayerData * data = [self.mediaPlayers objectForKey:[NSNumber numberWithInt:k]];
////                                [self doVolumeFadeOutOnMediaPlayerData:data];
////                                [data.avplayer pause];
////                                
////                            }
////                        }
//                        
//                        NSLog(@"At place %d",[place intValue]);
//                        [_beaconProximityCounter removeAllObjects];
//                        
//                    }
//                    else{
//                        int value = [counter intValue];
//                        [_beaconProximityCounter setObject:[NSNumber numberWithInt:value+1] forKey:place];
//                    }
//                    
//                }
//                else{
//                    [_beaconProximityCounter setObject:[NSNumber numberWithInt:1] forKey:place];
//                }
//                
//            }
//            else{
//                [_beaconProximityCounter setObject:[NSNumber numberWithInt:1] forKey:place];
//            }
//            
//            //                NSLog(@"%@",[NSString stringWithFormat:@"%@:%@",
//            //                     nearestBeacon.major, nearestBeacon.minor]);
//        }
        
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
                    
                    if (self.currentPlayer == nil) {
                        self.currentPlayer = _avPlayers[nearestBeaconKey];
                        [self.currentPlayer play];
                    }
                    //do your action
                    if (self.currentPlayer != _avPlayers[nearestBeaconKey]) {
                        float prevVolume = self.currentPlayer.volume;
                        [self doVolumeFadeOutOnAVPlayer:self.currentPlayer];
//                        NSLog(@"-- after fade out --");
                        //[self.currentPlayer pause];
//                        NSLog(@"-- after pause--");
                        self.currentPlayer = _avPlayers[nearestBeaconKey];
                        self.currentPlayer.volume = 0.1;
//                        NSLog(@"previous volume %f-----",prevVolume);
                        [self.currentPlayer play];
                        [self doVolumeFadeInOnAVPlayer:self.currentPlayer];
//                        NSLog(@"-- after fade in --");
                        //[self.currentPlayer play];
//                        NSLog(@"-- after play fade in--");
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
        if (avPlayer.volume > 0.1) {
            avPlayer.volume = avPlayer.volume - 0.05;
           //[self performSelector:@selector(doVolumeFadeOutOnAVPlayer:) withObject:avPlayer afterDelay:0.5];
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
    AVPlayer *fadeOutPlayer = avPlayers[0];
    AVPlayer *fadeInPLayer = avPlayers[1];

    if ([fadeOutPlayer respondsToSelector:@selector(setVolume:)] && [fadeInPLayer respondsToSelector:@selector(setVolume:)]) {
        if (fadeOutPlayer.volume > 0.1) {
            fadeOutPlayer.volume = fadeOutPlayer.volume - 0.05;
            fadeInPLayer.volume = fadeInPLayer.volume + 0.05;
            //[self performSelector:@selector(doVolumeFadeOutOnAVPlayer:) withObject:avPlayer afterDelay:0.5];
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
//        if (avPlayer.volume == 0.0) {
//            [avPlayer play];
//        }
        if (avPlayer.volume < 1.0) {
            avPlayer.volume = avPlayer.volume + 0.05;
            //[self performSelector:@selector(doVolumeFadeInOnAVPlayer:) withObject:avPlayer afterDelay:0.5];
            
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

- (void)fadeOutVolume
{
    NSLog(@"------fading sound-------");
    // AVPlayerObject is a property which points to an AVPlayer
//    AVPlayerItem *myAVPlayerItem = _currentPlayer.currentItem;
    AVPlayerItem *myAVPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://listen.radionomy.com/blacklabelfm"]];
    AVAsset *myAVAsset = myAVPlayerItem.asset;
//    NSArray *audioTracks = [myAVAsset tracksWithMediaType:AVMediaTypeAudio];
//    
//    NSMutableArray *allAudioParams = [NSMutableArray array];
//    for (AVAssetTrack *track in audioTracks) {
//        
//        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
//        [audioInputParams setVolumeRampFromStartVolume:1.0 toEndVolume:0 timeRange:CMTimeRangeMake(CMTimeMake(0, 1), CMTimeMake(5, 1))];
//        [allAudioParams addObject:audioInputParams];
//        
//    }
//    
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    [audioMix setInputParameters:allAudioParams];
    
    id audioMix = [[AVAudioMix alloc] init];
    id volumeMixInput = [[AVMutableAudioMixInputParameters alloc] init];
    
    //fade volume from muted to full over a period of 3 seconds
    [volumeMixInput setVolumeRampFromStartVolume:0 toEndVolume:1 timeRange:
     CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(3, 1))];
    [volumeMixInput setTrackID:[[myAVAsset.tracks objectAtIndex:0] trackID]];
    
    [audioMix setInputParameters:[NSArray arrayWithObject:volumeMixInput]];
    
    [myAVPlayerItem setAudioMix:audioMix];
    
}

@end
