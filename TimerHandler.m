//
//  TimerHandler.m
//  Qwickd
//
//  Created by Jay on 12/8/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "TimerHandler.h"
#import "CoreDataHelper.h"
#import "PlacesData.h"
#import "AppDelegate.h"

@implementation TimerHandler

@synthesize timerInterval;
@synthesize repeatingTimer;

- (id)initWithTimeInterval:(NSInteger)interval {
    self = [super init];
    if (self) {
        self.timerInterval = interval;
    }
    
    return self;
}

- (void)timerTarget:(NSTimer *)timer {
    NSDate *dateNow = [NSDate date];
    NSLog(@"Timer fired at %@", dateNow);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMER_NOTIFICATION
                                                        object:nil
                                                      userInfo:self.userInfo];
}

- (NSDictionary *)userInfo {
    
    /*
    //Get the current location from core data
    CoreDataHelper *cdHelper = [[[CoreDataHelper alloc] init] autorelease];
    NSArray *currentLocation = [cdHelper fetchData:LOCATION_ENTITY];
    //NSArray *location = [cdHelper fetchData:LOCATION_ENTITY];
    //NSArray *lPlaces = [cdHelper fetchData:PLACES_ENTITY];
    if (currentLocation != nil && currentLocation.count > 0) {
        LocationData *locationData = [currentLocation objectAtIndex:[currentLocation count] - 1];
        //PlacesData *placesData = [lPlaces objectAtIndex:[lPlaces count] - 1];
        lUserInfo = [NSDictionary dictionaryWithObject:locationData
                                                forKey:LOCATION_KEY];
        [lUserInfo setValue:placesData
                     forKey:PLACES_KEY];
    }
         */
    
    return nil;
}

- (IBAction)startRepeatingTimer:(id)sender {
    
    //cancel preexisting timer
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                                                      target:self
                                                    selector:@selector(timerTarget:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.repeatingTimer = timer;
}

- (IBAction)stopRepeatingTimer:(id)sender {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
