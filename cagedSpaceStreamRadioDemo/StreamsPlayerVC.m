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
#import <CoreMotion/CoreMotion.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface StreamsPlayerVC ()<StreamPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *streamNo;
@property (weak, nonatomic) IBOutlet UIImageView *gridImage;


@end

@implementation StreamsPlayerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    StreamsPlayer *sharedPlayer = [StreamsPlayer sharedManager];
    sharedPlayer.delegate = self;
    
    [self setupLeftMenuButton];
    [self setup];
    self.streamNo.text=@"#";
  
}

-(void)showAlertWithErrorMessage:(NSString *)errorMessage {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                   message:errorMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateStepLabel
{
    NSInteger numberOfSteps = [[NSUserDefaults standardUserDefaults] integerForKey:@"steps"];
    // doing %li and (long) so that we're safe for 64-bit
    self.streamNo.text = [NSString stringWithFormat:@"%li", (long)numberOfSteps];
}
- (void)setup
{
    // the if statement checks whether the device supports step counting (ie whether it has an M7 chip)
    if ([CMStepCounter isStepCountingAvailable]) {
        // the step counter needs a queue, so let's make one
        NSLog(@"Inside isStepCunting");
        NSOperationQueue *queue = [NSOperationQueue new];
        // call it something appropriate
        queue.name = @"Step Counter Queue";
        // now to create the actual step counter
        CMStepCounter *stepCounter = [CMStepCounter new];
        // this is where the brunt of the action happens
        [stepCounter startStepCountingUpdatesToQueue:queue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            // save the numberOfSteps value to standardUserDefaults, and then update the step label
            [[NSUserDefaults standardUserDefaults] setInteger:numberOfSteps forKey:@"steps"];
            [self updateStepLabel];
        }];
    }
    else{
        NSLog(@"outside");
    }
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
-(void) updateGridImage:(NSString*)gridImageUrl{
    NSLog(@"*******%@",gridImageUrl);
     UIImage *noImage = [UIImage imageNamed:@"no_image_available.png"];
    [self.gridImage sd_setImageWithURL:[NSURL URLWithString:gridImageUrl] placeholderImage:noImage completed:nil];
    
    
    
}
@end
