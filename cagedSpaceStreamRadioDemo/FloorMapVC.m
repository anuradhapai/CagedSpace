//
//  FloorMapVC.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "FloorMapVC.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "JSONParser.h"
#import "JSONParsingDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString* const floorMapURLString = @"http://52.26.164.148:8080/CagedSpaceWS/images/floorMap.jpg";

@interface FloorMapVC () <JSONParsingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *floorMapImageView;
@property (nonatomic, strong) SDImageCache *floorImageCache;

@end

@implementation FloorMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    _floorImageCache = [[SDImageCache alloc] initWithNamespace:@"edu.uncc.mobidev.groupa.cagedSpaceStreamRadioDemo"];
    
    NSURL *floorMapImageURL = [NSURL URLWithString:floorMapURLString];
    UIImage *noImage = [UIImage imageNamed:@"No_image_available.png"];
    
    [_floorMapImageView sd_setImageWithURL:floorMapImageURL placeholderImage:noImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"------Set image for floor---URL:%@ cachetype: %ld-----",imageURL,(long)cacheType);
    }];
    
    //    JSONParser *parser = [[JSONParser alloc] init];
    //    parser.parsingDelegate = self;
    //    [parser fetchFloorMap];
    
}

//- (void) didFinishFetchingFloorMap:(NSData *) floorMapImageData {
//
//    UIImage *noImage = [UIImage imageNamed:@"no_image_available.png"];
//    NSLog(@"------ image URL for floor map---URL:%@ -----",floorMapImageData);
//    [_floorMapImageView sd_setImageWithURL:floorMapImageURL placeholderImage:noImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"------Set image for floor---URL:%@ cachetype: %ld-----",imageURL,(long)cacheType);
//    }];
//
//}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
