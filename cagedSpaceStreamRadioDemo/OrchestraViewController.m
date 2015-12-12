//
//  OrchestraViewController.m
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import "OrchestraViewController.h"
#import "JSONParser.h"
#import "JSONParsingDelegate.h"
#import "Musician.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface OrchestraViewController () <JSONParsingDelegate>

@property (strong, nonatomic) NSMutableArray *musicians;
@property (nonatomic, strong) UIImageView *currentCellImageView;
@property (nonatomic, strong) SDImageCache *imageCache;
@property (strong, nonatomic) Musician *currentMusician;

@end

@implementation OrchestraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];

        _imageCache = [[SDImageCache alloc] initWithNamespace:@"edu.uncc.mobidev.groupa.cagedSpaceStreamRadioDemo"];
    
        JSONParser *parser = [[JSONParser alloc] init];
        parser.parsingDelegate = self;
        [parser fetchOrchestraDetails];
}

-(void) didFinishFetchingOrchestraDetails:(NSMutableArray *)musicians{
    self.musicians = musicians;
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.musicians count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"MusicianDetails" forIndexPath:indexPath];
    _currentMusician = self.musicians[indexPath.row];
    
    _currentCellImageView = (UIImageView *) [cell.contentView viewWithTag:1];
    
    UIImage *noImage = [UIImage imageNamed:@"no_image_available.png"];
    [_currentCellImageView sd_setImageWithURL:[NSURL URLWithString:_currentMusician.musicianImageURLString] placeholderImage:noImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"------Set image for story:%@ URL:%@ cachetype: %ld-----",_currentMusician.musicianName,imageURL,(long)cacheType);
    }];

    UILabel * titleLabel;
    titleLabel = (UILabel *) [cell.contentView viewWithTag:2];
    titleLabel.text = _currentMusician.musicianName;
    
    UILabel * captionLabel;
    captionLabel = (UILabel *) [cell.contentView viewWithTag:3];
    captionLabel.text = _currentMusician.musicianCaption;
    
    return cell;
}

#pragma mark - MMDrawerController

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
