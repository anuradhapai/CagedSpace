//
//  StreamsPlayerVC.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 10/28/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "StreamsPlayerVC.h"
#import <MMDrawerController/MMDrawerController.h>
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "StreamsPlayer.h"
#import "StreamPlayerDelegate.h"


@interface StreamsPlayerVC ()<StreamPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *streamNo;


@end

@implementation StreamsPlayerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    StreamsPlayer *sharedPlayer = [StreamsPlayer sharedManager];
    sharedPlayer.delegate = self;
    
    [self setupLeftMenuButton];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma MMDrawerController

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"-----deallocating------");
}

- (void) didEnterRegion:(NSString*)regionName{
    
    NSLog(@"------did Enter Region %@--------",regionName);
}
@end
