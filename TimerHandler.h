//
//  TimerHandler.h
//  Qwickd
//
//  Created by Jay on 12/8/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

static NSInteger const ONE_MINUTE_INTERVAL = 60;
static NSInteger const TEN_MINUTE_INTERVAL = 600;
static NSInteger const FIFTEEN_MINUTE_INTERVAL = 900;


#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface TimerHandler : NSObject

@property (unsafe_unretained) NSTimer *repeatingTimer;
@property NSInteger timerInterval;

- (IBAction)startRepeatingTimer:(id)sender;
- (IBAction)stopRepeatingTimer:(id)sender;

- (void)timerTarget:(NSTimer *)theTimer;

- (id)initWithTimeInterval:(NSInteger)interval;

- (NSDictionary *)userInfo;

@end
