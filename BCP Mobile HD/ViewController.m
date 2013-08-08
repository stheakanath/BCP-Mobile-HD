//
//  ViewController.m
//  BCP Mobile HD
//
//  Created by Sony Theakanath on 8/18/12.
//  Copyright (c) 2012 Sony Theakanath. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize mainArray, lastViewGrades, tabStop, lastViewAnnouncements, theDate, theDay, theCalendarDate, screenHeight, screenRect, screenWidth, sizearray;

- (void) makesizearray {
    NSString *device = [UIDevice currentDevice].model;
    if([device isEqualToString:@"iPad"]) {
        sizearray = [[NSArray alloc] initWithObjects:
                        [NSValue valueWithCGRect:CGRectMake(0, 0, 768, 1024)],
                     [NSValue valueWithCGRect:CGRectMake(334, 462, 100, 100)],
                     [NSValue valueWithCGRect:CGRectMake(224, 459, 320, 106)],
                     [NSValue valueWithCGRect:CGRectMake(239, 459, 290, 106)],
                     [NSValue valueWithCGRect:CGRectMake(0, 0, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(762, 0, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(0, 1018, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(762, 1018, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(224, 600, 320, 54)],
                     [NSValue valueWithCGRect:CGRectMake(254, 472, 260, 31)],
                     [NSValue valueWithCGRect:CGRectMake(254, 520, 260, 31)],
                     [NSNumber numberWithInt:448],
                     [NSNumber numberWithInt:400],
                     [NSValue valueWithCGRect:CGRectMake(10, 0, 400, 50)],
                     [NSNumber numberWithInt:428],
                     [NSNumber numberWithInt:768],
                     
                     nil];
    } else {
        sizearray = [[NSArray alloc] initWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(0, 0, 320, screenHeight-20)],
                     [NSValue valueWithCGRect:CGRectMake(110, 180, 100, 100)],
                     [NSValue valueWithCGRect:CGRectMake(0, 177, 320, 106)],
                     [NSValue valueWithCGRect:CGRectMake(15, 177, 290, 106)],
                     [NSValue valueWithCGRect:CGRectMake(0, 0, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(314, 0, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(0, 454, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(314, 454, 6, 6)],
                     [NSValue valueWithCGRect:CGRectMake(0, 300, 320, 54)],
                     [NSValue valueWithCGRect:CGRectMake(30, 190, 260, 31)],
                     [NSValue valueWithCGRect:CGRectMake(30, 241, 260, 31)],
                     [NSNumber numberWithInt:320],
                     [NSNumber numberWithInt:150],
                     [NSValue valueWithCGRect:CGRectMake(160, 0, 150, 50)],
                     [NSNumber numberWithInt:300],
                     [NSNumber numberWithInt:300],
                     nil];
    }
}

- (BOOL)connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return ( URLString != NULL ) ? YES : NO;
}

- (void)aboutButtonClicked:(id) sender{
    int tag = [sender tag];
    if(tag==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://itunes.apple.com/us/app/bcp-mobile-hd/id566968383?ls=1&mt=8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    else if(tag==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:Sony.Theakanath14@bcp.org"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    else if(tag==3) {
        [[[NSArray alloc] initWithObjects:@"",@"",@"",nil] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"] atomically:YES];
        for(int i=0;i<4;i++)
            [[mainArray objectAtIndex:0] replaceObjectAtIndex:i withObject:@""];
        [self loggedOut];
    }
}

- (void)gradesTabClicked:(id) sender{
    int tag = [sender tag];
    for(int x = 0; x < 4; x++)
    {
        if (x == tag)
            [[[mainArray objectAtIndex:1] objectAtIndex:tag+38] setSelected:YES];
        else
            [[[mainArray objectAtIndex:1] objectAtIndex:x+38] setSelected:NO];
    }
    if(tag != 4) {
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:tag]];
        [self arrowClicked];
        lastViewGrades = tag;
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
        NSString *desc = @"Grades";
        if(tag%2)
            desc = @"Schedule";
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[NSString stringWithFormat:@"Semester %i %@",(tag>1)+1,desc]];
        [self loadNewData];
    } 
}

//For the grades tab

- (void)animateReload {
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setTransform:CGAffineTransformMakeRotation(M_PI-0.0001)];
    } completion:NULL];
}

- (void)arrowClicked {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view>9) {
        NSString *device = [UIDevice currentDevice].model;
        if([device isEqualToString:@"iPad"]) 
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
        else
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:(view%10)*2]];
        for(int x = 0; x < 4; x++)
        {
            [[[mainArray objectAtIndex:1] objectAtIndex:x+38] setHidden:NO];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:25] setContentOffset:[[[mainArray objectAtIndex:1] objectAtIndex:25] contentOffset] animated:NO];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
            [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(0)];
        } completion:NULL];
    }
   else if(view==4) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
            [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(0)];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
            
        } completion:NULL];
  } else if(view == 6) {
      if(theDay != 0)
      {
          theDay--;
          theCalendarDate = [theCalendarDate addTimeInterval:-60*60*24];
          NSDateFormatter *df = [[NSDateFormatter alloc] init];
          [df setDateFormat:@"MMMM d, y"];
          [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[df stringFromDate:theCalendarDate]];
          [[[mainArray objectAtIndex:1] objectAtIndex:18] reloadData];
          [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
          [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:1];
          if (theDay == 0)
              [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
      } else {
          [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:1];
      }
  }     else {
      UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Semester 1 Grades", @"Semester 1 Schedule", @"Semester 2 Grades", @"Semester 2 Schedule", nil];
      [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
      [actionSheet showInView:[self view]];
  }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != 4) {
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:buttonIndex]];
        lastViewGrades = buttonIndex;
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
        NSString *desc = @"Grades";
        if(buttonIndex%2)
            desc = @"Schedule";
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[NSString stringWithFormat:@"Semester %i %@",(buttonIndex>1)+1,desc]];
        [self loadNewData];
    }
}
-(void)calendarRightArrowClicked {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view == 6)
    {
        NSDate *curDate = [NSDate date];
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSRange daysRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:curDate];
        if(theDay+1 != daysRange.length) {
            theDay++;
            theCalendarDate = [theCalendarDate addTimeInterval:60*60*24];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMMM d, y"];
            [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[df stringFromDate:theCalendarDate]];
            [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:1];
            if(theDay+1 == daysRange.length)
                [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:0];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
            [[[mainArray objectAtIndex:1] objectAtIndex:18] reloadData];
        } else {
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
        }
    }
}

//Done
- (void)backgroundClicked:(id) sender {
    [[[mainArray objectAtIndex:1] objectAtIndex:9] resignFirstResponder];
	[[[mainArray objectAtIndex:1] objectAtIndex:10] resignFirstResponder];
    [self hideKeyboard];
}

//Done
- (void)changeWebView:(NSString *)url {
    [[[mainArray objectAtIndex:1] objectAtIndex:29] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}

//Done

- (NSString *)decode: (NSString *)convert {
    NSUInteger myLength = [convert length];
    NSUInteger ampIndex = [convert rangeOfString:@"&" options:NSLiteralSearch].location;
    if (ampIndex == NSNotFound)
        return convert;
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    NSScanner *scanner = [NSScanner scannerWithString:convert];
    [scanner setCharactersToBeSkipped:nil];
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    do {
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];}
        if ([scanner isAtEnd]) {
            goto finish;}
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"\n" intoString:NULL])
            [result appendString:@""];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&nbsp" intoString:NULL])
            [result appendString:@""];
        else if ([scanner scanString:@"&rsquo;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber; unsigned charCode; NSString *xForHex = @"";
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];}
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];}
            if (gotNumber) {
                unsigned short newChar = charCode;
                [result appendFormat:@"%C", newChar];
                [scanner scanString:@";" intoString:NULL];}
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];}}
        else {
            NSString *amp;
            [scanner scanString:@"&" intoString:&amp];
            [result appendString:amp];}
    }
    while (![scanner isAtEnd]);
finish:
    return [[result stringByReplacingOccurrencesOfString:@"â" withString:@"'"] stringByReplacingOccurrencesOfString:@"â" withString:@"'"];
}

- (void)hideKeyboard {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
        NSString *device = [UIDevice currentDevice].model;
        if([device isEqualToString:@"iPad"]) {
        [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(334, 300, 100, 100)];
         while([[[mainArray objectAtIndex:1] objectAtIndex:1] frame].origin.y!=300) {}
        [[[mainArray objectAtIndex:1] objectAtIndex:2] setFrame:[[sizearray objectAtIndex:2]CGRectValue]];
        [[[mainArray objectAtIndex:1] objectAtIndex:3] setFrame:CGRectMake(239, 459, 290, 106)];
        [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(224, 600, 320, 54)];
        for(int i=0;i<2;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:9+i] setFrame:CGRectMake(254, 472+(i*48), 260, 31)];
        } } else {
            [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(110, 40, 100, 100)];
            [[[mainArray objectAtIndex:1] objectAtIndex:2] setFrame:CGRectMake(0, 177, 320, 106)];
            [[[mainArray objectAtIndex:1] objectAtIndex:3] setFrame:CGRectMake(15, 177, 290, 106)];
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(0, 300, 320, 54)];
            for(int i=0;i<2;i++) {
                [[[mainArray objectAtIndex:1] objectAtIndex:9+i] setFrame:CGRectMake(30, 190+(i*48), 260, 31)];
            }
        }
    } completion:^(BOOL finished){
        
    }];
}

//Done
- (void)loadCache: (NSNumber *) dataNum {
    NSInteger dataInt = [dataNum intValue];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.data.plist",dataInt]];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *values = [[NSArray alloc] initWithContentsOfFile:path];
        if([values count]>1&&![[values objectAtIndex:0] isEqualToString:@""]&&![[values objectAtIndex:1] isEqualToString:@""])
            [self performSelectorInBackground:@selector(loadData:) withObject:[[NSArray alloc] initWithObjects:dataNum, [values objectAtIndex:0], [values objectAtIndex:1], nil]];
    }
}



- (void)loadData: (NSArray *)data {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
     [[[mainArray objectAtIndex:1] objectAtIndex:26] setAlpha:1];
    [[[mainArray objectAtIndex:1] objectAtIndex:27] setAlpha:1];
    NSInteger dataInt = [[data objectAtIndex:0] intValue];
    NSString *resultPage = [data objectAtIndex:1];
    int arrayIndex = dataInt+4;
    if(dataInt==2||dataInt==3)
        arrayIndex = dataInt+2;
    else if(dataInt==6)
        arrayIndex = 6;
    int offset = 0;
    if([resultPage isEqualToString:@""]) {
        [self performSelectorOnMainThread:@selector(animateReload) withObject:nil waitUntilDone:NO];
        NSString *url = @"https://brycepauken.com/api/0/";
        bool isAnnouncements = false;
        if(dataInt==0||dataInt==2)
            url = [url stringByAppendingString:[NSString stringWithFormat:@"grades.php?username=%@&password=%@",[[mainArray objectAtIndex:0] objectAtIndex:0],[[mainArray objectAtIndex:0] objectAtIndex:1]]];
        else if(dataInt==1||dataInt==3)
            url = [url stringByAppendingString:[NSString stringWithFormat:@"schedule.php?username=%@&password=%@",[[mainArray objectAtIndex:0] objectAtIndex:0],[[mainArray objectAtIndex:0] objectAtIndex:1]]];
        else if(dataInt==4)
            url = [url stringByAppendingString:@"news.php"];
        else if(dataInt==6) {
           // NSArray *theDate = [[[[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]]] componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"];
            NSInteger theMonth = ([[theDate objectAtIndex:0] intValue]*12)+([[theDate objectAtIndex:1] intValue]-1);
            url = [NSString stringWithFormat:@"%@calendar.php?month=%i",url,theMonth];
        }
        else if(dataInt>9) {
            int i=0;
            //int goal = (dataInt-(dataInt%10))/10-1;
            int goal;
            if(dataInt%10 == 0)
                goal = 0;
            else {
                goal = 1;
            }
            int classnum = dataInt/5-2;
            while(i<goal+offset+1) {
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(dataInt%10)*2+1] isEqualToString:@"-"])
                    offset++;
                i++;
            }
            if(dataInt == 10)
            {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"gradedetails.php?username=%@&password=%@&class=%@&semester=%i",[[mainArray objectAtIndex:0] objectAtIndex:0],[[mainArray objectAtIndex:0] objectAtIndex:1],[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:dataInt%10],dataInt%10+1]];
            } else {
                url = [url stringByAppendingString:[NSString stringWithFormat:@"gradedetails.php?username=%@&password=%@&class=%@&semester=%i",[[mainArray objectAtIndex:0] objectAtIndex:0],[[mainArray objectAtIndex:0] objectAtIndex:1],[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum],dataInt%10+1]];
            }

        }
        else {
            isAnnouncements = true;
            url = [url stringByAppendingString:[NSString stringWithFormat:@"announcements.php"]];
        }
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        /*if(dataInt<10&&[[[mainArray objectAtIndex:0] objectAtIndex:arrayIndex] count]==0)
            [self loadCache:[NSNumber numberWithInt:arrayIndex-4]];*/
        NSError *error;
        NSURLResponse *response=nil;
        if(!isAnnouncements)
        {
            url = [url stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            resultPage = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:200] returningResponse:&response error:&error] encoding:NSUTF8StringEncoding];
        } else {
            resultPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSASCIIStringEncoding error:&error];
        }
    }
    if([resultPage length]>5&&[[resultPage substringFromIndex:[resultPage length]-5] isEqualToString:@">>>>>"]) {
        int goal;
        if(dataInt%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"M/d/YY"];
        NSString *dateString = [dateFormat stringFromDate:theDate];
        [dateFormat setDateFormat:@"h:mm a"];
        dateString = [NSString stringWithFormat:@"Updated %@ at %@",dateString,[dateFormat stringFromDate:theDate]];
        if(dataInt<10) {
            [[[NSArray alloc] initWithObjects:resultPage,dateString,nil] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.data.plist",dataInt]] atomically:YES];
            
            [[mainArray objectAtIndex:0] replaceObjectAtIndex:arrayIndex withObject:[[NSMutableArray alloc] init]];
            
            if([resultPage rangeOfString:@"<"].location!=NSNotFound) {
                NSArray *tempArray = [[resultPage substringToIndex:[resultPage length]-5] componentsSeparatedByString:@"<"];
                for (int i=0;i<[tempArray count];i++) {
                    [[[mainArray objectAtIndex:0] objectAtIndex:arrayIndex] addObject:[[NSMutableArray alloc] init]];
                    NSArray *tempArray2 = [[tempArray objectAtIndex:i] componentsSeparatedByString:@">"];
                    for (NSString *tempString in tempArray2)
                        [[[[mainArray objectAtIndex:0] objectAtIndex:arrayIndex] objectAtIndex:i] addObject:tempString];
                }
            }
            else {
                NSArray *tempArray = [[resultPage substringToIndex:[resultPage length]-5] componentsSeparatedByString:@">"];
                for (NSString *tempString in tempArray)
                    [[[mainArray objectAtIndex:0] objectAtIndex:arrayIndex] addObject:[self decode:tempString]];
            }
        }
        else {
            NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal] objectAtIndex:dataInt/5-2];
            [[[NSArray alloc] initWithObjects:resultPage,dateString,[NSString stringWithFormat:@"%@%i",className,dataInt%10],nil] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.data.plist",dataInt]] atomically:YES];
            int newIndex = [[[mainArray objectAtIndex:0] objectAtIndex:10] count];
            for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++)
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,dataInt%10]]) {
                    newIndex = i;
                    break;
                }
            if(newIndex==[[[mainArray objectAtIndex:0] objectAtIndex:10] count])
                [[[mainArray objectAtIndex:0] objectAtIndex:10] addObject:[[NSMutableArray alloc] init]];
            else
                [[[mainArray objectAtIndex:0] objectAtIndex:10] replaceObjectAtIndex:newIndex withObject:[[NSMutableArray alloc] init]];
            [[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] addObject:[NSString stringWithFormat:@"%@%i",className,dataInt%10]];
            NSArray *tempArray = [[resultPage substringToIndex:[resultPage length]-5] componentsSeparatedByString:@"<"];
            for (int i=0;i<[tempArray count];i++) {
                [[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] addObject:[[NSMutableArray alloc] init]];
                NSArray *tempArray2 = [[tempArray objectAtIndex:i] componentsSeparatedByString:@">"];
                for (NSString *tempString in tempArray2)
                    [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:i+1] addObject:tempString];
            }
        }
        [self reloadTable];
    }
    if([[data objectAtIndex:1] isEqualToString:@""]&&dataInt==[[[mainArray objectAtIndex:0] objectAtIndex:3] intValue])
        [self performSelectorOnMainThread:@selector(stopReloadAnimation) withObject:nil waitUntilDone:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [[[mainArray objectAtIndex:1] objectAtIndex:26] setAlpha:0];
    [[[mainArray objectAtIndex:1] objectAtIndex:27] setAlpha:0];
}

//Done
- (void)loadNewData {
    [self performSelectorInBackground:@selector(loadData:) withObject:[[NSArray alloc] initWithObjects:[[mainArray objectAtIndex:0] objectAtIndex:3], @"", @"", nil]];
}

- (void)login {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if([self connectedToInternet])
    {
    for(int i=8;i<11;i++) {
      [[[mainArray objectAtIndex:1] objectAtIndex:i] setEnabled:NO];
    }
        
        //-----------------------------
    NSString *user, *pass;

    if(![[[mainArray objectAtIndex:0] objectAtIndex:0] isEqualToString:@""]&&![[[mainArray objectAtIndex:0] objectAtIndex:1] isEqualToString:@""]){
        user = [[mainArray objectAtIndex:0] objectAtIndex:0];
        pass = [[mainArray objectAtIndex:0] objectAtIndex:1];
    }
    else {
        user = [[[[mainArray objectAtIndex:1] objectAtIndex:9] text] lowercaseString];
        if([user rangeOfString:@"@bcp.org"].location==NSNotFound) {
            user = [user stringByAppendingString:@"@bcp.org"];
        }
        pass = [[[mainArray objectAtIndex:1] objectAtIndex:10] text];
    }
    NSError *error;
    NSURLResponse *response=nil;
    NSString *url = [NSString stringWithFormat:@"https://brycepauken.com/api/0/login.php?username=%@&password=%@",user,pass];
    url = [url stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString* resultPage = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:200] returningResponse:&response error:&error] encoding:NSUTF8StringEncoding];
    NSString *device = [UIDevice currentDevice].model;
    if([device isEqualToString:@"iPad"]) 
        while([[[mainArray objectAtIndex:1] objectAtIndex:8] frame].origin.y!=600) {}
    else
        while([[[mainArray objectAtIndex:1] objectAtIndex:8] frame].origin.y!=300) {}
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitle:@"Login" forState:UIControlStateNormal];
    for(int i=9;i<11;i++) {
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setEnabled:YES];
    }
    
    if(![resultPage isEqualToString:@""]&&![resultPage isEqualToString:@"0"]) {
        NSArray *passDiv = [resultPage componentsSeparatedByString:@">"];
        [[[NSArray alloc] initWithObjects:user,[passDiv objectAtIndex:1],[passDiv objectAtIndex:0],nil] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"] atomically:YES];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:0 withObject:user];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:[passDiv objectAtIndex:1]];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:[passDiv objectAtIndex:0]];
        [self loggedIn];
    } else {
        [[[NSArray alloc] initWithObjects:@"",@"",@"",nil] writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"] atomically:YES];
        for(int i=0;i<4;i++)
            [[mainArray objectAtIndex:0] replaceObjectAtIndex:i withObject:@""];
        [[[UIAlertView alloc] initWithTitle:@"Incorrect Password/Username!" message: @"You entered an incorrect password/username!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
        [self loginFailedAnimate:0];
    }
    //----------------------------------------
    
    } else  {
        [[[UIAlertView alloc] initWithTitle:@"No Internet!" message: @"You aren't connected to the internet! Go to System Prefrences > Network to solve the issue." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

}

- (void)loginButtonClicked {
	[[[mainArray objectAtIndex:1] objectAtIndex:9] resignFirstResponder];
	[[[mainArray objectAtIndex:1] objectAtIndex:10] resignFirstResponder];
    [self hideKeyboard];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitle:@"Logging In..." forState:UIControlStateNormal];
    [self performSelectorInBackground:@selector(login) withObject:nil];
}

- (void)loginFailedAnimate: (NSInteger) runNumber {
    CGFloat duration = 0.08;
    if(runNumber == 0 || runNumber == 6) {
        duration = 0.04;
    }
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationCurveLinear animations:^ {
        if(runNumber==6) {
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(224, 600, 320, 54)];
        }
        else if(runNumber==0||runNumber==2||runNumber==4) {
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(219, 600, 320, 54)];
        }
        else {
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(224, 600, 320, 54)];
        }
    } completion:^(BOOL finished) {
        if(runNumber!=6)
            [self loginFailedAnimate:(runNumber+1)];
        else
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setEnabled:YES];
    }];
}

- (void)loggedIn {
    [self loadNewData];
    NSString *studentname = [[mainArray objectAtIndex:0] objectAtIndex:0];
    studentname = [studentname stringByReplacingOccurrencesOfString:@"." withString:@" "];
    studentname = [[studentname substringToIndex:[studentname length] - 10] capitalizedString];
    studentname = [NSString stringWithFormat:@"Account: %@", studentname];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setTitle:studentname forState:UIControlStateNormal];
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveLinear animations:^ {
     //[[self view] bringSubviewToFront:[[mainArray objectAtIndex:1] objectAtIndex:17]];
        for(int i=0;i<11;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setAlpha:0];
            if(i==3)
                i=5;
        }
    } completion:^(BOOL finished){
        for(int i=0;i<11;i++) {
            [[self view] sendSubviewToBack:[[mainArray objectAtIndex:1] objectAtIndex:i]];
            if(i==3)
                i=5;
        }
    }];
}

- (void)loggedOut {
    NSString *extension = @"plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setEnabled:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:10] setText:@""];
    for(int i=0;i<11;i++) {
        [[self view] bringSubviewToFront:[[mainArray objectAtIndex:1] objectAtIndex:i]];
        if(i==3)
            i=5;
    }
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveLinear animations:^ {
        for(int i=0;i<11;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setAlpha:1];
            if(i==3)
                i=5;
        }
    } completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:tableView
{
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view>9) {
        int newIndex = -1;
        int offset=0;
        int i=0;
        int goal;
        int classnum = view/5-2;
         // goal = (view-(view%10))/10-1;
        if(view%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        
        while(i<goal+offset+1) {
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                offset++;
            i++;
        }
        NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
        for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++) {
            if([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] count]>0)
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,view%10]]) {
                    newIndex = i;
                    break;
                }
        }
        
        if(newIndex>-1&&[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count]>1)
            return [[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] count]-1;
    }
    else if(view==5)
        return [[[mainArray objectAtIndex:0] objectAtIndex:9] count];
    return 1;
}

- (void)reloadTable {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view<10)
        [[[mainArray objectAtIndex:1] objectAtIndex:18] reloadData];
    else
    {
        if([[[mainArray objectAtIndex:0] objectAtIndex:10] count] == 2)
            [[[mainArray objectAtIndex:0] objectAtIndex:10] removeObjectAtIndex: 0];
        [[[mainArray objectAtIndex:1] objectAtIndex:25] reloadData];
    }
}

- (void)startInterface {
    [[[mainArray objectAtIndex:1] objectAtIndex:0] setImage:[UIImage imageNamed:@"Background"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:1] setImage:[UIImage imageNamed:@"Crest"]];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    [[[mainArray objectAtIndex:1] objectAtIndex:0] setUserInteractionEnabled:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:0] addGestureRecognizer:tapRecognizer];
    [[[mainArray objectAtIndex:1] objectAtIndex:2] setImage:[UIImage imageNamed:@"Textbox"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:2] setAlpha:0];
    
    [[[mainArray objectAtIndex:1] objectAtIndex:3] setImage:[UIImage imageNamed:@"TextboxDivider"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:3] setAlpha:0];
    for(int i=0;i<4;i++) {
        [[[mainArray objectAtIndex:1] objectAtIndex:i+4] setImage:[UIImage imageNamed:@"Corner"]];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+4] setTransform:CGAffineTransformMakeScale((i%2)*(-2)+1,(i/2)*(-2)+1)];
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setBackgroundImage:[UIImage imageNamed:@"Button"] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setAlpha:0];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitle:@"Login" forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setFont:[UIFont boldSystemFontOfSize:15]];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] setAdjustsImageWhenDisabled:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:8] addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    for(int i=9;i<11;i++) {
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setDelegate:self];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setEnabled:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:9] setPlaceholder:@"Username @bcp.org"];
    [[[mainArray objectAtIndex:1] objectAtIndex:10] setPlaceholder:@"Password"];
    [[[mainArray objectAtIndex:1] objectAtIndex:10] setSecureTextEntry:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:11] setImage:[UIImage imageNamed:@"TopBar"]];
    NSArray *tabs = [[NSArray alloc] initWithObjects:@"News",@"Announcements",@"Classes",@"Calendar",@"More",nil];
    
    //For le tabs
    NSString *device = [UIDevice currentDevice].model;
    if([device isEqualToString:@"iPad"]) {
    for(int i=12;i<16;i++) {
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"Tab" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateNormal];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"TabDown" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateHighlighted];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"TabDown" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateSelected];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"TabDown" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateSelected|UIControlStateHighlighted];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setAdjustsImageWhenHighlighted:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setTag:i-12];
        [[[mainArray objectAtIndex:1] objectAtIndex:i] addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
    } } else {
        for(int i=12;i<17;i++) {
            //CGRect screenRect = [[UIScreen mainScreen] bounds];
            //CGFloat screenWidth = screenRect.size.width;
            //CGFloat screenHeight = screenRect.size.height;
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setFrame:CGRectMake(64*(i-12), screenHeight-69, 64, 49)];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateNormal];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"Down" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateHighlighted];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"Down" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateSelected];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:[@"Down" stringByAppendingString:[tabs objectAtIndex:i-12]]] forState:UIControlStateSelected|UIControlStateHighlighted];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setAdjustsImageWhenHighlighted:NO];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setTag:i-12];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchDown];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:17] setFrame:CGRectMake(0, 0, 320, screenHeight-69)];
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setFrame:CGRectMake(0, 44, 320, screenHeight-113)];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setFrame:CGRectMake(320, 44, 320, screenHeight-112)];
        [[[mainArray objectAtIndex:1] objectAtIndex:28] setFrame:CGRectMake(360, 0, 240, 44)];
        [[[mainArray objectAtIndex:1] objectAtIndex:27] setFrame:CGRectMake(141, 209, 37, 37)];
        [[[mainArray objectAtIndex:1] objectAtIndex:26] setFrame:CGRectMake(461, 209, 37, 37)];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setFrame:CGRectMake(6, 6, 32, 32)];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setFrame:CGRectMake(276, 0, 44, 44)];
        [[[mainArray objectAtIndex:1] objectAtIndex:25] setFrame:CGRectMake(320, 44, 320, screenHeight-112)];
        [[[mainArray objectAtIndex:1] objectAtIndex:37] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setFrame:CGRectMake(282, 6, 32, 32)];
        
        [[[mainArray objectAtIndex:1] objectAtIndex:30] setFrame:CGRectMake(0, 54, 320, 130)];
        [[[mainArray objectAtIndex:1] objectAtIndex:31] setFrame:CGRectMake(0, 199, 320, 54)];
        [[[mainArray objectAtIndex:1] objectAtIndex:32] setFrame:CGRectMake(0, 268, 320, 54)];
        [[[mainArray objectAtIndex:1] objectAtIndex:33] setFrame:CGRectMake(0, 337, 320, 54)];
         [[[mainArray objectAtIndex:1] objectAtIndex:9] setFrame:CGRectMake(30, 395, 260, 31)];
         [[[mainArray objectAtIndex:1] objectAtIndex:10] setFrame:CGRectMake(30, 443, 260, 31)];
         [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(0, 540, 320, 54)];
         [[[mainArray objectAtIndex:1] objectAtIndex:45] setAlpha:0];
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:14] setSelected:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] setScrollEnabled:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] setScrollsToTop:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentSize:CGSizeMake(640, 980)];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setDataSource:self];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setDelegate:self];
    UIImageView *footerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellShadow"]];
    [footerView setTransform:CGAffineTransformMakeScale(1, -1)];
    [footerView setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 10)];
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellShadow"]];
    [headerView setFrame:CGRectMake(0, -10, [[sizearray objectAtIndex:11] intValue], 10)];
    UIView *footerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 0)];
    [footerSpace addSubview:footerView];
    UIView *headerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 0)];
    [headerSpace addSubview:headerView];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setTableFooterView:footerSpace];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setTableHeaderView:headerSpace];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[[mainArray objectAtIndex:1] objectAtIndex:18] setBackgroundColor:[UIColor clearColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] addSubview:[[mainArray objectAtIndex:1] objectAtIndex:18]];
    [[[mainArray objectAtIndex:1] objectAtIndex:19] setImage:[UIImage imageNamed:@"Background"]];
    for(int i=20;i<22;i++)
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setImage:[UIImage imageNamed:@"Shadow"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:21] setTransform:CGAffineTransformMakeScale(1, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setTextAlignment:UITextAlignmentCenter];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setFont:[UIFont boldSystemFontOfSize:20]];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setBackgroundColor:[UIColor clearColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setTextColor:[UIColor whiteColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setShadowColor:[UIColor blackColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setShadowOffset:CGSizeMake(0, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:@"Semester 1 Grades"];
    [self.view bringSubviewToFront:(UILabel *) [[mainArray objectAtIndex:1] objectAtIndex:22]];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] addSubview:[[mainArray objectAtIndex:1] objectAtIndex:22]];
    [[[mainArray objectAtIndex:1] objectAtIndex:23] setBackgroundImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:23] setAdjustsImageWhenHighlighted:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:23] addTarget:self action:@selector(arrowClicked) forControlEvents:UIControlEventTouchDown];
    if([device isEqualToString:@"iPad"])
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
    else
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
    [[[mainArray objectAtIndex:1] objectAtIndex:24] setBackgroundImage:[UIImage imageNamed:@"Reload"] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:24] setAdjustsImageWhenHighlighted:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:24] addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventTouchDown];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setDataSource:self];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setTag:1];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setDelegate:self];
    UIImageView *footerView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellShadow"]];
    [footerView2 setTransform:CGAffineTransformMakeScale(1, -1)];
    [footerView2 setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 10)];
    UIImageView *headerView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellShadow"]];
    [headerView2 setFrame:CGRectMake(0, -10, [[sizearray objectAtIndex:11] intValue], 10)];
    UIView *footerSpace2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 0)];
    [footerSpace2 addSubview:footerView2];
    UIView *headerSpace2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 0)];
    [headerSpace2 addSubview:headerView2];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setTableFooterView:footerSpace];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setTableHeaderView:headerSpace];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[[mainArray objectAtIndex:1] objectAtIndex:25] setBackgroundColor:[UIColor clearColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] addSubview:[[mainArray objectAtIndex:1] objectAtIndex:25]];
    for(int i=26;i<28;i++) {
        [[[mainArray objectAtIndex:1] objectAtIndex:i] setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[[mainArray objectAtIndex:1] objectAtIndex:17] insertSubview:[[mainArray objectAtIndex:1] objectAtIndex:i] atIndex:0];
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setTextAlignment:UITextAlignmentCenter];
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setFont:[UIFont boldSystemFontOfSize:20]];
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setBackgroundColor:[UIColor clearColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setTextColor:[UIColor whiteColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setShadowColor:[UIColor blackColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:28] setShadowOffset:CGSizeMake(0, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] addSubview:[[mainArray objectAtIndex:1] objectAtIndex:28]];
    [[[mainArray objectAtIndex:1] objectAtIndex:29] setDelegate:self];
    [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:29] setScalesPageToFit:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:17] addSubview:[[mainArray objectAtIndex:1] objectAtIndex:29]]; 
    NSArray *buttonTitles = [[NSArray alloc] initWithObjects:@"Programmed and Designed By\nKuriakose Sony Theakanath\nServer Programming By\nBryce Pauken",@"Rate This App!",@"Contact Me",@"Log Out", nil];
    for(int i=0;i<4;i++) {
        if(i==0) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setBackgroundImage:[UIImage imageNamed:@"ButtonLarge"] forState:UIControlStateNormal];
            [[[[mainArray objectAtIndex:1] objectAtIndex:i+30] titleLabel] setNumberOfLines:0];
            [[[[mainArray objectAtIndex:1] objectAtIndex:i+30] titleLabel] setLineBreakMode:UILineBreakModeWordWrap];
            [[[mainArray objectAtIndex:1] objectAtIndex:i+30] titleLabel].textAlignment = UITextAlignmentCenter;
            [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setEnabled: NO];
            [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setHidden:NO];
        }
        else
            [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setBackgroundImage:[UIImage imageNamed:@"Button"] forState:UIControlStateNormal];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setFont:[UIFont boldSystemFontOfSize:15]];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setAdjustsImageWhenDisabled:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] setTag:i];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+30] addTarget:self action:@selector(aboutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    [[[mainArray objectAtIndex:1] objectAtIndex:34] setImage:[UIImage imageNamed:@"buttonsections"]];
    [self.view insertSubview:[[mainArray objectAtIndex:1] objectAtIndex:34] atIndex:17];
    [[[mainArray objectAtIndex:1] objectAtIndex:35] setImage:[UIImage imageNamed:@"CellShadow"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:35] setTransform:CGAffineTransformMakeScale(1, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:36] setImage:[UIImage imageNamed:@"ShadowOptions"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:36] setTransform:CGAffineTransformMakeScale(1, 1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setTextAlignment:UITextAlignmentCenter];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setFont:[UIFont boldSystemFontOfSize:20]];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setBackgroundColor:[UIColor clearColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setTextColor:[UIColor whiteColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setShadowColor:[UIColor blackColor]];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setShadowOffset:CGSizeMake(0, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:37] setText:@"Sections"];
    
    
    //Grades TabBar
    for(int i = 0; i < 4; i++)
    {
        NSArray *gradetabs = [[NSArray alloc] initWithObjects:@"TabGrades1",@"TabSchedule1",@"TabGrades2",@"TabSchedule2",nil];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] setBackgroundImage:[UIImage imageNamed:[@"" stringByAppendingString:[NSString stringWithFormat:@"%@%@",[gradetabs objectAtIndex:i], @"Up"]]] forState:UIControlStateNormal];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] setBackgroundImage:[UIImage imageNamed:[@"" stringByAppendingString:[NSString stringWithFormat:@"%@%@",[gradetabs objectAtIndex:i], @"Down"]]] forState:UIControlStateHighlighted];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] setBackgroundImage:[UIImage imageNamed:[@"" stringByAppendingString:[NSString stringWithFormat:@"%@%@",[gradetabs objectAtIndex:i], @"Down"]]] forState:UIControlStateSelected];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] setBackgroundImage:[UIImage imageNamed:[@"" stringByAppendingString:[NSString stringWithFormat:@"%@%@",[gradetabs objectAtIndex:i], @"Down"]]] forState:UIControlStateSelected|UIControlStateHighlighted];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] setAdjustsImageWhenHighlighted:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38]  setTag:i];
        [[[mainArray objectAtIndex:1] objectAtIndex:i+38] addTarget:self action:@selector(gradesTabClicked:) forControlEvents:UIControlEventTouchDown];
    }
    [[[mainArray objectAtIndex:1] objectAtIndex:40] setSelected:YES];
    [[[mainArray objectAtIndex:1] objectAtIndex:42] setImage:[UIImage imageNamed:@"TopDivider"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:43] setImage:[UIImage imageNamed:@"CellShadow"]];
    [[[mainArray objectAtIndex:1] objectAtIndex:43] setTransform:CGAffineTransformMakeScale(1, -1)];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] setBackgroundImage:[UIImage imageNamed:@"Button"] forState:UIControlStateNormal];
    [[[[mainArray objectAtIndex:1] objectAtIndex:44] titleLabel] setNumberOfLines:0];
    [[[[mainArray objectAtIndex:1] objectAtIndex:44] titleLabel] setLineBreakMode:UILineBreakModeWordWrap];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] titleLabel].textAlignment = UITextAlignmentCenter;
    [[[mainArray objectAtIndex:1] objectAtIndex:44] setTitle:@"Our Website" forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] setFont:[UIFont boldSystemFontOfSize:15]];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] setAdjustsImageWhenDisabled:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:44] addTarget:self action:@selector(websiteclicked) forControlEvents:UIControlEventTouchUpInside];
    
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setBackgroundImage:[UIImage imageNamed:@"Button"] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setHidden:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setFont:[UIFont boldSystemFontOfSize:15]];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setAdjustsImageWhenDisabled:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:45] setUserInteractionEnabled:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:46] setHidden:YES];
    for (UIView *view in [mainArray objectAtIndex:1])
        if(![view superview])
            [[self view] addSubview:view];
    
    for(int i=0;i<11;i++) {
        [[self view] bringSubviewToFront:[[mainArray objectAtIndex:1] objectAtIndex:i]];
    }
    
    for(int i=21;i>18;i--) {
        [[self view] sendSubviewToBack:[[mainArray objectAtIndex:1] objectAtIndex:i]];
    }
    
    
    [[[mainArray objectAtIndex:1] objectAtIndex:46] setBackgroundImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    [[[mainArray objectAtIndex:1] objectAtIndex:46] setAdjustsImageWhenHighlighted:NO];
    [[[mainArray objectAtIndex:1] objectAtIndex:46] addTarget:self action:@selector(calendarRightArrowClicked) forControlEvents:UIControlEventTouchDown];
    [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha: 0];
    
    if(![device isEqualToString:@"iPad"]) {
        for(int x = 0; x< 4; x++)
            [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:YES];
    }
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSArray *values = [[NSArray alloc] initWithContentsOfFile:path];
        if([values count]>2&&![[values objectAtIndex:0] isEqualToString:@""]&&![[values objectAtIndex:1] isEqualToString:@""]&&![[values objectAtIndex:2] isEqualToString:@""]) {
            for(int i=0;i<3;i++) {
                [[mainArray objectAtIndex:0] replaceObjectAtIndex:i withObject:[values objectAtIndex:i]];
            }
            [[[mainArray objectAtIndex:1] objectAtIndex:9] setText:[values objectAtIndex:0]];
            NSString *newText = @"";
            for(int i=0;i<[[values objectAtIndex:2] intValue];i++) {
                newText = [newText stringByAppendingString:@" "];
            }
            [[[mainArray objectAtIndex:1] objectAtIndex:10] setText:newText];
            [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitle:@"Logging In..." forState:UIControlStateNormal];
            [self performSelectorInBackground:@selector(login) withObject:nil];
        }
	}
  //  NSString *device = [UIDevice currentDevice].model;
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveLinear animations:^ {
        if([device isEqualToString:@"iPad"]) {
        [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(334, 300, 100, 100)];
        } else {
            [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(110, 40, 100, 100)];
        }
       [[[mainArray objectAtIndex:1] objectAtIndex:2] setFrame:[[sizearray objectAtIndex:2]CGRectValue]];
        [[[mainArray objectAtIndex:1] objectAtIndex:2] setAlpha:1];
        [[[mainArray objectAtIndex:1] objectAtIndex:3] setFrame:[[sizearray objectAtIndex:3]CGRectValue]];
        [[[mainArray objectAtIndex:1] objectAtIndex:3] setAlpha:0.5];
        [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:[[sizearray objectAtIndex:8]CGRectValue]];
        [[[mainArray objectAtIndex:1] objectAtIndex:8] setAlpha:1];
        for(int i=0;i<2;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i+9] setAlpha:1];
            [[[mainArray objectAtIndex:1] objectAtIndex:i+9] setFrame:[[sizearray objectAtIndex:i+9]CGRectValue]];
        }
    } completion:^(BOOL finished){
        for(int i=9;i<11;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setEnabled:YES];
        }
    }];
}
- (void)startVariables {
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    theDate = [[[[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]]] componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"];
    theDay = [[theDate objectAtIndex:2] intValue]-1;
    [self makesizearray];
    mainArray = [[NSArray alloc] initWithObjects:
                 
                 
                 [[NSMutableArray alloc] initWithObjects:
                  @"",@"",@"",[NSNumber numberWithInt:0],[[NSMutableArray alloc] init],[[NSMutableArray alloc] init],[[NSMutableArray alloc] init],@"",[[NSMutableArray alloc] init],[[NSMutableArray alloc] init],[[NSMutableArray alloc] init], nil],
                 
                 
                 [[NSArray alloc] initWithObjects:
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:0]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:1]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:2]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:3]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:4]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:5]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:6]CGRectValue]],
                  [[UIImageView alloc] initWithFrame:[[sizearray objectAtIndex:7]CGRectValue]],
                  [[UIButton alloc] initWithFrame:CGRectMake(224, 600, 320, 54)],
                  [[UITextField alloc] initWithFrame:CGRectMake(254, 472, 260, 31)],
                  [[UITextField alloc] initWithFrame:CGRectMake(254, 520, 260, 31)],
                  //Done with top 11
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 44)], //Top Bar
                  
                  //tab bars 12
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 44, 320, 98)], //All are tab bars
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 142, 320, 98)],
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 240, 320, 98)],
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 338, 320, 98)],
                  
                  //Modify this to be nothing
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 284, 320, 49)],
                  
                  //17
                  [[UIScrollView alloc] initWithFrame:CGRectMake(320, 0, 448, 1004)],
                  [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 448, 960)],
                  //19
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)],
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 768, 25)],
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 979, 768, 25)],
                  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 44)],
                  [[UIButton alloc] initWithFrame:CGRectMake(326, 6, 32, 32)],
                  //24
                  [[UIButton alloc] initWithFrame:CGRectMake(724, 0, 44, 44)],
                  [[UITableView alloc] initWithFrame:CGRectMake(768, 44, 448, 980)],
                  [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(206, 494, 37, 37)],
                  [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(974, 494, 37, 37)],
                  [[UILabel alloc] initWithFrame:CGRectMake(832, 0, 320, 44)],
                  //29
                  [[UIWebView alloc] initWithFrame:CGRectMake(768, 44, 448, 960)],
                  
                  //Buttons in more section 30
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 574, 320, 130)], //2
                   [[UIButton alloc] initWithFrame:CGRectMake(0, 788, 320, 54)], //4
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 857, 320, 54)], //5
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 926, 320, 54)], //6
                  
                  //about section backgrounds index:34
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 960)],
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 25)],
                  [[UIImageView alloc] initWithFrame:CGRectMake(295, 44, 25, 980)],
                  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)],
                  
                  //tab bars for grades index 38
                  [[UIButton alloc] initWithFrame:CGRectMake(320, 955, 112, 49)],
                  [[UIButton alloc] initWithFrame:CGRectMake(432, 955, 112, 49)],
                  [[UIButton alloc] initWithFrame:CGRectMake(544, 955, 112, 49)],
                  [[UIButton alloc] initWithFrame:CGRectMake(656, 955, 112, 49)],
                  
                  //Top Bar divider index 42
                  [[UIImageView alloc] initWithFrame:CGRectMake(319, 0, 1, 44)],
                  
                  //Shadow
                  [[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight-64, 320, 25)],
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 719, 320, 54)], //3
                  [[UIButton alloc] initWithFrame:CGRectMake(0, 505, 320, 54)], //1
                  
                  //Calendar Right arrow 46
                  [[UIButton alloc] initWithFrame:CGRectMake(730, 6, 32, 32)],
                  nil],
                 nil];
    lastViewGrades = 0;
    tabStop = false;
    lastViewAnnouncements = -1;
}


-(void) websiteclicked
{
    NSString *url = @"http://www.sonytheakanath.com";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
}

- (void)stopReloadAnimation {
    [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setTransform:CGAffineTransformMakeRotation(0.0001)];
    } completion:NULL];
}

- (void)tabButtonClicked:(id) sender{
    int tag = [sender tag];
             NSString *device = [UIDevice currentDevice].model;
    for(int i=0;i<5;i++) {
        if(i==tag) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i+12] setSelected:YES];
        }
        else {
            [[[mainArray objectAtIndex:1] objectAtIndex:i+12] setSelected:NO];
        }
    }
    if(tag==0) {
        if(![device isEqualToString:@"iPad"]) {
            for(int x = 0; x< 4; x++)
                [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:YES];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:@"News"];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:25] setHidden:YES];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:4]];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
        for(int x = 38; x < 42; x++)
            [[[mainArray objectAtIndex:1] objectAtIndex:x] setHidden:YES];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
        [self loadNewData];
    }
    else if(tag==1) {
        if(![device isEqualToString:@"iPad"]) {
            for(int x = 0; x< 4; x++)
                [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:YES];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:@"Announcements"];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:5]];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setHidden:NO];
        for(int x = 38; x < 42; x++)
            [[[mainArray objectAtIndex:1] objectAtIndex:x] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
        [self loadNewData];
    }
    else if(tag==2) {
        if(![device isEqualToString:@"iPad"]) {
            for(int x = 0; x< 4; x++)
                [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:YES];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:25] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        NSString *desc = @"Grades";
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setHidden:NO];
        if(lastViewGrades%2)
            desc = @"Schedule";
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[NSString stringWithFormat:@"Semester %i %@",(lastViewGrades>1)+1,desc]];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:lastViewGrades]];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setHidden:NO];
        for(int x = 38; x < 42; x++)
        {
            [[[mainArray objectAtIndex:1] objectAtIndex:x] setHidden:NO];
        }
        if(![device isEqualToString:@"iPad"]) {
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha: 1];
        } else {
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha: 0];
        }
        [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
        [self loadNewData];
    }
    else if(tag==3) {
        if(![device isEqualToString:@"iPad"]) {
            for(int x = 0; x< 4; x++)
                [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:YES];
        }
        theCalendarDate  = [NSDate date];
         [[[mainArray objectAtIndex:1] objectAtIndex:18] setHidden:NO];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMMM d, y"];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:[df stringFromDate:theCalendarDate]];
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:6]];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setAlpha:1];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setHidden:NO];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setHidden:YES];
        for(int x = 38; x < 42; x++)
            [[[mainArray objectAtIndex:1] objectAtIndex:x] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(0, 0)];
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
        [self loadNewData];
    } else if(tag == 4) {
        [[[mainArray objectAtIndex:1] objectAtIndex:22] setText:@"BCP Mobile Details"];
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:0];
        [[[mainArray objectAtIndex:1] objectAtIndex:24] setHidden:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:46] setHidden:YES];
         if(![device isEqualToString:@"iPad"]) {
        for(int x = 0; x< 4; x++)
            [[[mainArray objectAtIndex:1] objectAtIndex:30+x] setHidden:NO];
         }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *device = [UIDevice currentDevice].model;
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view<4||view>9) {
        if(indexPath.row%2)
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (cell == nil) {
            if(indexPath.row%2) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                [[cell contentView] setBackgroundColor:[UIColor blackColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
                [cell setOpaque:YES];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                UIView *cellBackground = [[UIView alloc] init];
                [cellBackground setBackgroundColor:[UIColor whiteColor]];
                [cellBackground setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 50)];
                [cell setBackgroundView:cellBackground];
                UIView *cellDivider = [[UIView alloc] init];
                [cellDivider setBackgroundColor:[UIColor darkGrayColor]];
                [cellDivider setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex: 11] intValue], 1)];
                [cell addSubview:cellDivider];
                UILabel *classLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [[sizearray objectAtIndex:12] intValue], 50)];
                [classLabel setBackgroundColor:[UIColor clearColor]];
                [classLabel setFont:[UIFont boldSystemFontOfSize:18]];
                [classLabel setTag:0];
                [cell addSubview:classLabel];
                UILabel *gradeLabel = [[UILabel alloc] initWithFrame:[[sizearray objectAtIndex:13]CGRectValue]];
                [gradeLabel setTextAlignment:UITextAlignmentRight];
                [gradeLabel setBackgroundColor:[UIColor clearColor]];
                [gradeLabel setFont:[UIFont boldSystemFontOfSize:18]];
                [gradeLabel setTag:1];
                [cell addSubview:gradeLabel];
            }
        }
        int newIndex = 0;
        if(view>9) {
            int offset=0;
            int i=0;
            int goal;
            int classnum;
            if(view%10 == 0)
                goal = 0;
            else {
                goal = 1;
            }
            classnum = view/5-2;
            
            while(i<goal+offset+1) {
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                    offset++;
                i++;
            }
            NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
            for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++)
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,view%10]]) {
                    newIndex = i;
                    break;
                }
        }
        for(UILabel *label in [cell subviews])
            if([label isKindOfClass:[UILabel class]]) {
                int tag = [label tag];
                if(view%2==0&&view<10) {
                    int gradeslol = 0;
                    if(view == 2)
                        gradeslol = 1;
                    if(tag==0) {
                        
                     [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:gradeslol] objectAtIndex:indexPath.row]];
                        if([device isEqualToString:@"iPad"]) {
                        [label setFrame:CGRectMake(10, 0, 300, 50)];
                        } else {
                            [label setFrame:CGRectMake(10, 0, 215, 50)];
                        }
                        cell.userInteractionEnabled = YES;
                    }
                    else if(tag==1) {
                        NSString *grade = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:gradeslol] objectAtIndex:indexPath.row+1];
                        bool aGrade = [grade isEqualToString:@"/"];
                        if(!aGrade)
                        {
                             if([device isEqualToString:@"iPad"]) {
                            [label setFrame:CGRectMake(413, 0, 25, 50)];
                             } else {
                                 [label setFrame:CGRectMake(285, 0, 25, 50)];
                             }
                            [label setTextAlignment:UITextAlignmentLeft];
                            cell.userInteractionEnabled = YES;
                            [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:gradeslol] objectAtIndex:indexPath.row+1]];
                        }
                        else
                        {
                            if([device isEqualToString:@"iPad"]) {
                            [label setFrame:CGRectMake(353, 0, 85, 50)];
                            } else {
                                 [label setFrame:CGRectMake(225, 0, 85, 50)];
                            }
                            [label setTextAlignment:UITextAlignmentRight];
                            cell.userInteractionEnabled = NO;
                            [label setText:@"No Grade"];
                        }
                    }
                }
                else if(view<10) {
                    if(tag==0) {
                        [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+2]];
                        cell.userInteractionEnabled = YES;
                        if([device isEqualToString:@"iPad"]) {
                        [label setFrame:CGRectMake(10, 0, 378, 50)];
                        } else {
                            [label setFrame:CGRectMake(10, 0, 220, 50)];
                        }
                    }
                    else if(tag==1) {
                        [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+4]];
                        if([device isEqualToString:@"iPad"]) {
                        [label setFrame:CGRectMake(10, 0, 428, 50)];
                        } else  {
                            [label setFrame:CGRectMake(10, 0, 300, 50)];
                        }
                        cell.userInteractionEnabled = YES;
                        [label setTextAlignment:UITextAlignmentRight];
                    }
                    else {
                        [label setText:@""];
                        cell.userInteractionEnabled = YES;
                    }
                }
                else {
                    if(indexPath.section==0) {
                        //The actual letter for the assignment
                        NSString *grade = [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*6];
                        NSString *letter;
                        if((indexPath.row/2)*6+5 >= [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] count])
                            letter = @"/";
                        else
                            letter = [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*6+5];
                        bool aGrade = (![letter isEqualToString:@"/"]&&![letter isEqualToString:@"X"]&&![letter isEqualToString:@"-"]&&![letter isEqualToString:@""]);
                        if(tag==0) {
                            [label setText:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*6]];
                           //Label of the class in gradedetails
                        if([device isEqualToString:@"iPad"]) {
                           [label setFrame:CGRectMake(10, 0, 270, 50)];
                        } else {
                            [label setFrame:CGRectMake(10, 0, 175, 50)];
                        }
                        }
                        else if(tag==1) {
                            if(aGrade) {
                                 if([device isEqualToString:@"iPad"]) {
                                [label setFrame:CGRectMake(413, 0, 25, 50)];
                                 } else {
                                     [label setFrame:CGRectMake(285, 0, 25, 50)];
                                 }
                                [label setTextAlignment:UITextAlignmentLeft];
                                [label setText:letter];
                            }
                            else
                            {
                                 if([device isEqualToString:@"iPad"]) {
                                [label setFrame:CGRectMake(353, 0, 85, 50)];
                                 } else {
                                     [label setFrame:CGRectMake(225, 0, 85, 50)];
                                 }
                                [label setTextAlignment:UITextAlignmentRight];
                                [label setText:@"No Grade"];
                            }
                        }
                        else {
                            if(aGrade)
                                [label setText:grade];
                            else
                                [label setText:@""];
                        }
                    }
                    else {
                        //The category
                        NSString *letter;
                        if((indexPath.row/2)*5+4 >= [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] count])
                            letter = @"/";
                        else
                            letter = [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*5+4];
                        

                        

                            bool aGrade = (![letter isEqualToString:@"/"]&&![letter isEqualToString:@"X"]&&![letter isEqualToString:@"-"]&&![letter isEqualToString:@""]);
                        
                        if(tag==0) {
                            if(([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count] == 3) && indexPath.section == 1)
                                [label setText: @"Grade"];
                            else if(([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count] == 4) && indexPath.section == 2)
                                [label setText: @"Grade"];
                            else {
                            [label setText:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*5]];
                                if([device isEqualToString:@"iPad"]) { 
                            [label setFrame:CGRectMake(10, 0, 300, 50)];
                                } else {
                                     [label setFrame:CGRectMake(10, 0, 175, 50)];
                                }
                            }
                        }
                        else if(tag==1) {
                            if(([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count] == 3) && indexPath.section == 1)
                            {
                                 if([device isEqualToString:@"iPad"]) {
                                [label setFrame:CGRectMake(353, 0, 85, 50)];
                                 } else {
                                     [label setFrame:CGRectMake(225, 0, 85, 50)];
                                 }
                                [label setTextAlignment:UITextAlignmentRight];
                                cell.userInteractionEnabled = NO;
                                [label setText:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*5]];
                            } else if(([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count] == 4) && indexPath.section == 2) {
                                 if([device isEqualToString:@"iPad"]) { 
                                [label setFrame:CGRectMake(353, 0, 85, 50)];
                                 } else {
                                     [label setFrame:CGRectMake(225, 0, 85, 50)];
                                 }
                                cell.userInteractionEnabled = NO;
                                [label setTextAlignment:UITextAlignmentRight];
                                [label setText:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:indexPath.section+1] objectAtIndex:(indexPath.row/2)*5]];
                            } else {
                                cell.userInteractionEnabled = YES;
                                if(aGrade)
                                {    if([device isEqualToString:@"iPad"]) { 
                                    [label setFrame:CGRectMake(413, 0, 25, 50)];
                                } else {
                                     [label setFrame:CGRectMake(285, 0, 25, 50)];
                                }
                                    [label setTextAlignment:UITextAlignmentLeft];
                                    [label setText:letter];
                                }
                                else
                                {
                                    if([device isEqualToString:@"iPad"]) {
                                        [label setFrame:CGRectMake(353, 0, 85, 50)];
                                    } else {
                                        [label setFrame:CGRectMake(225, 0, 85, 50)];
                                    }
                                    [label setTextAlignment:UITextAlignmentRight];
                                    [label setText:@"No Grade"];
                                }
                            }
                        }
                        else {
                            if(aGrade)
                                [label setText:letter];
                            else
                                [label setText:@""];
                        }
                    }
                }
            }
    }
    else if(view==4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
            [cell setOpaque:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            UIView *cellBackground = [[UIView alloc] init];
            [cellBackground setBackgroundColor:[UIColor whiteColor]];
            [cellBackground setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 50)];
            [cell setBackgroundView:cellBackground];
            UIView *cellDivider = [[UIView alloc] init];
            [cellDivider setBackgroundColor:[UIColor darkGrayColor]];
            [cellDivider setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 1)];
            [cell addSubview:cellDivider];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [[sizearray objectAtIndex:14] intValue], 50)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [titleLabel setTag:0];
            [titleLabel setNumberOfLines:0];
            [titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
            [cell addSubview:titleLabel];
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [[sizearray objectAtIndex:14] intValue], 50)];
            [dateLabel setBackgroundColor:[UIColor clearColor]];
            [dateLabel setFont:[UIFont systemFontOfSize:14]];
            [dateLabel setTag:1];
            [cell addSubview:dateLabel];
        }
        
        CGSize sizeTitle = [[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3] sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        CGSize sizeDate = [[@"Posted on " stringByAppendingString:[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3+2]] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        
        for(UILabel *label in [cell subviews])
            if([label isKindOfClass:[UILabel class]]) {
                if([label tag]==0) {
                    [label setFrame:CGRectMake(10, 10, [[sizearray objectAtIndex:14] intValue], sizeTitle.height)];
                    [label setText:[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3]];
                }
                else {
                    [label setFrame:CGRectMake(10, sizeTitle.height+20, 300, sizeDate.height)];
                    [label setText:[@"Posted on " stringByAppendingString:[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3+2]]];
                }
            }
    }
    else if(view==5) {
        bool selected = (indexPath.section*100+indexPath.row==lastViewAnnouncements);
        if(selected)
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5"];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
        if (cell == nil) {
            if(selected)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell5"];
            else
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell4"];
            [cell setOpaque:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            UIView *cellBackground = [[UIView alloc] init];
            [cellBackground setBackgroundColor:[UIColor whiteColor]];
            [cellBackground setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 50)];
            [cell setBackgroundView:cellBackground];
            UIView *cellDivider = [[UIView alloc] init];
            [cellDivider setBackgroundColor:[UIColor darkGrayColor]];
            [cellDivider setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 1)];
            [cell addSubview:cellDivider];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], 45)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [titleLabel setTag:0];
            [titleLabel setNumberOfLines:0];
            [titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
            [cell addSubview:titleLabel];
            if(selected) {
                UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], 45)];
                [infoLabel setBackgroundColor:[UIColor clearColor]];
                [infoLabel setFont:[UIFont systemFontOfSize:18]];
                [infoLabel setTag:1];
                [infoLabel setNumberOfLines:0];
                [infoLabel setLineBreakMode:UILineBreakModeTailTruncation];
                [cell addSubview:infoLabel];
            }
        }
        
        if(selected)
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CGSize sizeTitle = [[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1] sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        
        for(UILabel *label in [cell subviews])
            if([label isKindOfClass:[UILabel class]]) {
                if([label tag]==0) {
                    [label setFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], sizeTitle.height)];
                    [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1]];
                }
                else {
                    CGSize sizeInfo = [[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+2] sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
                    [label setFrame:CGRectMake(10, sizeTitle.height+24, [[sizearray objectAtIndex:14] intValue], sizeInfo.height)];
                    [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+2]];
                }
            }
    }
    else if(view==6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell6"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell6"];
            [cell setOpaque:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            UIView *cellBackground = [[UIView alloc] init];
            [cellBackground setBackgroundColor:[UIColor whiteColor]];
            [cellBackground setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 50)];
            [cell setBackgroundView:cellBackground];
            UIView *cellDivider = [[UIView alloc] init];
            [cellDivider setBackgroundColor:[UIColor darkGrayColor]];
            [cellDivider setFrame:CGRectMake(0, 0, [[sizearray objectAtIndex:11] intValue], 1)];
            [cell addSubview:cellDivider];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], 45)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [titleLabel setTag:0];
            [titleLabel setNumberOfLines:0];
            [titleLabel setLineBreakMode:UILineBreakModeTailTruncation];
            [cell addSubview:titleLabel];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        

        
        if([[[mainArray objectAtIndex:0] objectAtIndex:6] count]==0||[[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] count]<2||([[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] count]==2&&[[[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] objectAtIndex:1] isEqualToString:@"&nbsp;"])) {
            CGSize sizeTitle = [@"Nothing to display for today!" sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
            
            for(UILabel *label in [cell subviews])
                if([label isKindOfClass:[UILabel class]]) {
                    [label setFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], sizeTitle.height)];
                    [label setText:@"Nothing to display for today!"];
                }
        }
        else {
            CGSize sizeTitle = [[[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] objectAtIndex:indexPath.row+1] sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
            for(UILabel *label in [cell subviews])
                if([label isKindOfClass:[UILabel class]]) {
                    [label setFrame:CGRectMake(10, 12, [[sizearray objectAtIndex:14] intValue], sizeTitle.height)];
                    [label setText:[[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] objectAtIndex:indexPath.row+1]];
                }
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view==0||view==2) {

            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha: 1];
    
        [[mainArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:view/2+((indexPath.row/2+1)*10)]];
        view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
        [self reloadTable];
        [self loadNewData];
        int offset=0;
        int i=0;
        int goal;
        int classnum = view/5-2;
        if(view%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        while(i<goal+offset+1) {
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                offset++;
            i++;
        }
        for(int x = 0; x < 4; x++)
        {
            [[[mainArray objectAtIndex:1] objectAtIndex:x+38] setHidden:YES];
        }
        NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
        [[[mainArray objectAtIndex:1] objectAtIndex:28] setText:className];
        NSString *device = [UIDevice currentDevice].model;
        if([device isEqualToString:@"iPad"]) {
        [[[mainArray objectAtIndex:1] objectAtIndex:18] setContentOffset:[[[mainArray objectAtIndex:1] objectAtIndex:18] contentOffset] animated:NO];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
            [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(768, 0)];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        } completion:NULL];
        } else {
            [[[mainArray objectAtIndex:1] objectAtIndex:18] setContentOffset:[[[mainArray objectAtIndex:1] objectAtIndex:18] contentOffset] animated:NO];
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
                [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(320, 0)];
                [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
            } completion:NULL];
        }
    }
    else if(view==1||view==3) {
        [[[UIAlertView alloc] initWithTitle:[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+2] message:[NSString stringWithFormat:@"Teacher: %@\n\nPeriod: %@\nRoom: %@\nCourse-Section: %@",[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+3],[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5],[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+4],[[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] objectAtIndex:(indexPath.row/2)*5+1]] delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
    }
    else if(view>9) {
        int newIndex = -1;
        int offset=0;
        int i=0;
        int goal;
        int classnum = view/5-2;
        // goal = (view-(view%10))/10-1;
        if(view%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        while(i<goal+offset+1) {
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                offset++;
            i++;
        }
        NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
        for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++)
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,view%10]]) {
                newIndex = i;
                break;
            }
        if(indexPath.section==0) {
            [[[UIAlertView alloc] initWithTitle:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6] message:[NSString stringWithFormat:@"Score: %@ / %@\nPercentage: %@%%\nGrade: %@\n\nCategory: %@\nDue Date: %@",[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6+3],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6+4],[NSString stringWithFormat: @"%.2lf", ([[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:(indexPath.row/2)*6+3] doubleValue]/[[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:(indexPath.row/2)*6+4] doubleValue])*100],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6+5],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6+2],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:1] objectAtIndex:indexPath.row/2*6+1]] delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:2] objectAtIndex:indexPath.row/2*5] message:[NSString stringWithFormat:@"Score: %@\nPercentage: %@\nGrade: %@\n\nWeight: %@%%",[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:2] objectAtIndex:indexPath.row/2*5+2],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:2] objectAtIndex:indexPath.row/2*5+3],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:2] objectAtIndex:indexPath.row/2*5+4],[[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:2] objectAtIndex:indexPath.row/2*5+1]] delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
        }
    }
    else if(view==4) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        NSString *url = [[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3+1];
        if([url rangeOfString:@"http"].location==NSNotFound)
            url = [@"https://brycepauken.com/api/0/newsview.php?id=" stringByAppendingString:url];
        [self performSelectorOnMainThread:@selector(changeWebView:) withObject:url waitUntilDone:YES];
        [[[mainArray objectAtIndex:1] objectAtIndex:28] setText:[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3]];
        [[[mainArray objectAtIndex:1] objectAtIndex:29] setHidden:YES];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
            NSString *device = [UIDevice currentDevice].model;
            if([device isEqualToString:@"iPad"]) {
            [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake(768, 0)];
             } else {
                 [[[mainArray objectAtIndex:1] objectAtIndex:17] setContentOffset:CGPointMake([[sizearray objectAtIndex:11] intValue], 0)];
             }
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
            [[[mainArray objectAtIndex:1] objectAtIndex:23] setAlpha:1];
        } completion:NULL];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

    }
    else if(view==5) {
        bool singleCell = (indexPath.section*100+indexPath.row==lastViewAnnouncements);
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        if(singleCell) {
            lastViewAnnouncements = -1;
        }
        else {
            oldIndex = [NSIndexPath indexPathForRow:-1 inSection:0];
            int oldRow = lastViewAnnouncements%100;
            oldIndex = [NSIndexPath indexPathForRow:oldRow inSection:(lastViewAnnouncements-oldRow)/100];
            lastViewAnnouncements = indexPath.section*100+indexPath.row;
        }
        [tableView beginUpdates];
        if(singleCell)
        {
            [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            if(oldIndex.row == -1 && oldIndex.section == 0)
                [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            else
               [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, oldIndex, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
       [tableView endUpdates];
        [[[mainArray objectAtIndex:1] objectAtIndex:18] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//Done
- (CGFloat)tableView:tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view<4||view>9) {
        if(indexPath.row%2)
            return 0;
        return 50;
    }
    else if(view==4) {
        CGSize sizeTitle = [[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3] sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        CGSize sizeDate = [[@"Posted on " stringByAppendingString:[[[mainArray objectAtIndex:0] objectAtIndex:8] objectAtIndex:indexPath.row*3+2]] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        return sizeTitle.height+sizeDate.height+30;
    }
    else if(view==5) {
        CGSize sizeTitle = [[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1] sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        if(indexPath.section*100+indexPath.row!=lastViewAnnouncements)
            return sizeTitle.height+24;
        else {
            
            CGSize sizeInfo = [[[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+2] sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
            return sizeTitle.height+sizeInfo.height+36;
        }
    }
    else if(view==6) {
       // NSArray *theDate = [[[[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]]] componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSString *theText = @"Empty";
        if([[[mainArray objectAtIndex:0] objectAtIndex:6] count]>0&&[[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:indexPath.section] count]>1)
            theText = [[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] objectAtIndex:indexPath.row+1];
        CGSize sizeTitle = [theText sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake([[sizearray objectAtIndex:14] intValue], 20000) lineBreakMode:UILineBreakModeTailTruncation];
        return sizeTitle.height+24;
    }
    return 45;
}

- (NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section {
    int returnVal = 0;
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view<4) {
        int j=0;
        if(view%2==0) {
            if([[[mainArray objectAtIndex:0] objectAtIndex:4] count] > 0)
            {
                for(int i=0;i< [[[mainArray objectAtIndex:0] objectAtIndex:4] count];i++)
                {   
                    for(int x = 0; x < [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex: i] count]; x+=2)
                    {
                        if(![[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:x] isEqualToString:@"-"])
                            j++;
                    }
                }
            }
            if(j>0)
                returnVal = j-1;
        }
        else {
            if([[[mainArray objectAtIndex:0] objectAtIndex:5] count]>0)
                j = [[[[mainArray objectAtIndex:0] objectAtIndex:5] objectAtIndex:(view-1)/2] count]/5;
            if(j>0)
                returnVal = j*2-1;
        }

    }
    else if(view==4)
        returnVal = [[[mainArray objectAtIndex:0] objectAtIndex:8] count]/3;
    else if(view==5)
        returnVal = ([[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:section] count]-1)/2;
    else if(view==6) {
       // NSArray *theDate = [[[[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]]] componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"];
        if([[[mainArray objectAtIndex:0] objectAtIndex:6] count]==0)
            returnVal=1;
        else
            returnVal = MAX([[[[mainArray objectAtIndex:0] objectAtIndex:6] objectAtIndex:theDay] count]-1, 1);
    }
    else if(view>9) {
        int offset=0;
        int i=0;
        int goal;
        int classnum;
        // goal = (view-(view%10))/10-1;
        if(view%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        classnum = view/5-2;
        while(i<goal+offset+1) {
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                offset++;
            i++;
        }
        NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
        int newIndex = -1;
        for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++)
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,view%10]]) {
                newIndex = i;
                break;
            }
        if(newIndex>-1) {
            returnVal = [[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:newIndex] objectAtIndex:section+1] count]/3+section;
        }
    }
    if(returnVal==0&&view!=7)
        [[[mainArray objectAtIndex:1] objectAtIndex:26+[tableView tag]] startAnimating];
    else
        [[[mainArray objectAtIndex:1] objectAtIndex:26+[tableView tag]] stopAnimating];
    
    return returnVal;
}

- (NSString *)tableView:tableView titleForHeaderInSection:(NSInteger)section {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view>9) {

        int newIndex = -1;
        int offset=0;
        int i=0;
        int goal;
        int classnum = view/5-2;
        // goal = (view-(view%10))/10-1;
        if(view%10 == 0)
            goal = 0;
        else {
            goal = 1;
        }
        
        
        
        while(i<goal+offset+1) {
            if([[[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:i] objectAtIndex:(view%10)*2+1] isEqualToString:@"-"])
                offset++;
            i++;
        }
        NSString *className = [[[[mainArray objectAtIndex:0] objectAtIndex:4] objectAtIndex:goal+offset] objectAtIndex:classnum];
        for(int i=0;i<[[[mainArray objectAtIndex:0] objectAtIndex:10] count];i++) {
            if([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] count]>0)
                if([[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:i] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%@%i",className,view%10]]) {
                    newIndex = i;
                    break;
                }
        }
        if(newIndex>-1&&[[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count]>2) {
            if([[[[mainArray objectAtIndex:0] objectAtIndex:10] objectAtIndex:0] count] == 3)
            {
                if(section == 0)
                   return @"Grades";
               else
                   return @"Total Grade";
            } else {
                if(section == 0)
                    return @"Grades";
                else if(section == 1)
                    return @"Categories";
                else
                    return @"Total Grade";
            }
        }
    }
    else if(view==5) {
        return [[[[mainArray objectAtIndex:0] objectAtIndex:9] objectAtIndex:section] objectAtIndex:0];
    }
	return @"";
}


//Done
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSString *device = [UIDevice currentDevice].model;

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveLinear animations:^ {
         if([device isEqualToString:@"iPad"]) {
        [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(334, 300, 100, 100)];
         while([[[mainArray objectAtIndex:1] objectAtIndex:1] frame].origin.y!=300) {}
        [[[mainArray objectAtIndex:1] objectAtIndex:2] setFrame:[[sizearray objectAtIndex:2]CGRectValue]];
        [[[mainArray objectAtIndex:1] objectAtIndex:3] setFrame:CGRectMake(239, 459, 290, 106)];
        [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(224, 600, 320, 54)];
        for(int i=0;i<2;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:9+i] setFrame:CGRectMake(254, 472+(i*48), 260, 31)];
        }
         } else {
             [[[mainArray objectAtIndex:1] objectAtIndex:1] setFrame:CGRectMake(110, 10, 100, 100)];
             [[[mainArray objectAtIndex:1] objectAtIndex:2] setFrame:CGRectMake(0, 53, 320, 106)];
             [[[mainArray objectAtIndex:1] objectAtIndex:3] setFrame:CGRectMake(15, 53, 290, 106)];
             [[[mainArray objectAtIndex:1] objectAtIndex:8] setFrame:CGRectMake(0, 173, 320, 54)];
             for(int i=0;i<2;i++) {
                 [[[mainArray objectAtIndex:1] objectAtIndex:9+i] setFrame:CGRectMake(30, 66+(i*48), 260, 31)];
             }
         }
    } completion:^(BOOL finished){
        for(int i=9;i<11;i++) {
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setEnabled:YES];
            [[[mainArray objectAtIndex:1] objectAtIndex:i] setAlpha:1];
        }
    }];
}

//Done
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	if (textField==[[mainArray objectAtIndex:1] objectAtIndex:9]) {
        [[[mainArray objectAtIndex:1] objectAtIndex:10] becomeFirstResponder];
	}
	else {
        [self hideKeyboard];
        [[[mainArray objectAtIndex:1] objectAtIndex:8] setTitle:@"Logging In..." forState:UIControlStateNormal];
		[self performSelectorInBackground:@selector(login) withObject:nil];
	}
    return YES;
}

//Done
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    int view = [[[mainArray objectAtIndex:0] objectAtIndex:3] intValue];
    if(view == 0 || view == 2 || view > 9)
        [webView setHidden:YES];
    else
        [webView setHidden:NO];
}


//Done
- (void)viewDidLoad {
    [super viewDidLoad];
    [self startVariables];
    [self startInterface];
}

//Done
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
