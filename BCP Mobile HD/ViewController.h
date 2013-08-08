//
//  ViewController.h
//  BCP Mobile HD
//
//  Created by Sony Theakanath on 8/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CommonCrypto/CommonCryptor.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIWebViewDelegate>
{
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic) CGRect screenRect;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic, retain) NSArray *mainArray;
@property (nonatomic, retain) NSArray *sizearray;
@property (nonatomic) int lastViewGrades;
@property (nonatomic) bool tabStop;
@property (nonatomic) int lastViewAnnouncements;
@property (nonatomic) NSArray *theDate;
@property (nonatomic) int theDay;
@property (nonatomic) NSDate *theCalendarDate;

@end
