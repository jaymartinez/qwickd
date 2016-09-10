//
//  LandingPageViewController.h
//  Qwickd
//
//  Created by Jay on 10/21/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "User.h"
#import "ViewController.h"
#import "Settings.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "QWLocation.h"
#import "NearbyViewController.h"
#import "CoreDataHelper.h"
#import "PlacesHelper.h"
#import "PlacesInformation.h"
#import "ActivityView.h"

@interface LandingPageViewController : UIViewController <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>
{
    IBOutlet UIButton *nearbyButton;
    LocationHelper *locationHelper;
    CoreDataHelper *coreDataHelper;
    PlacesHelper *placesHelper;
    PlacesInformation *placesInformation;
    ActivityView *activityView;
    NSArray *myToolbarItems;
}

//@property (nonatomic, strong) User *lUser;
//@property (nonatomic, strong) PFUser *lCurrentUser;
@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) Settings *mSettings;
//@property (nonatomic, strong) TimerHandler *timerHandler;
//@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) QWLocation *qwLocation;
//@property (nonatomic, retain) CoreDataHelper *coreDataHelper;

//- (IBAction)logout:(id)sender;
- (IBAction)go_home:(id)sender;
- (IBAction)settings_click:(id)sender;
- (IBAction)nearbyButton_click:(id)sender;


// CLLocationManagerDelegate methods:
/*
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
 */

@end
