//
//  StreamPlayerDelegate.h
//  cagedSpaceStreamRadioDemo
//
//  Created by  on 12/11/15.
//  Copyright © 2015 kpai.vgone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StreamPlayerDelegate <NSObject>
@optional
- (void) streamDidChange:(NSURL*)streamURL;
- (void) didEnterRegion:(NSString*)regionName;
-(void) updateGridImage:(NSString*)gridImageUrl;
- (void) showAlertWithErrorMessage: (NSString *) errorMessage;
@end
