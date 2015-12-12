//
//  LaunchViewController.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "LaunchViewController.h"
#import "MMDrawerController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSegueWithIdentifier:@"DRAWER_SEGUE" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"]) {
        MMDrawerController *destinationViewController = (MMDrawerController *) segue.destinationViewController;
        
        // Instantitate and set the center view controller.
        UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HOME_VIEW_CONTROLLER"];
        [destinationViewController setCenterViewController:centerViewController];
        
        // Instantiate and set the left drawer controller.
        UIViewController *leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDE_DRAWER_CONTROLLER"];
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
        
    }
}
@end
