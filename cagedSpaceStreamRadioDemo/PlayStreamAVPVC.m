//
//  PlayStreamAVPVC.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 10/26/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "PlayStreamAVPVC.h"

@interface PlayStreamAVPVC ()

@end

@implementation PlayStreamAVPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
//    http://www.pandora.com/station/play/2866932224309101112
//    AVPlayer *sharedplayer = [AVPlayer playerWithURL:url];
//    
//    self.player = sharedplayer;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSLog(@"mp3 stream URL fetched %@",response.URL);
                                                
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    AVPlayer *sharedplayer = [AVPlayer playerWithURL:url];
                                                    self.player = sharedplayer;
                                                });
                                                
                                                
                                            }];
    
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
