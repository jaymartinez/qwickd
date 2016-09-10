//
//  NearbyViewController.m
//  Qwickd
//
//  Created by Jay on 12/7/13.
//  Copyright (c) 2013 Jay. All rights reserved.
//

#import "NearbyViewController.h"
#import "LandingPageViewController.h"
#import "DefaultSurveyViewController.h"
#import "PlacesData.h"
#import "LocationData.h"
#import "PlacesHelper.h"
#import "PlacesTableViewCell.h"
#import "SettingsViewController.h"

@interface NearbyViewController ()

@end


@implementation NearbyViewController

@synthesize placeNames;
@synthesize placesData;
@synthesize placesDictionary;
@synthesize placesDictionaryArray;
@synthesize refreshControl;
@synthesize placesInformation;
@synthesize placesInformationArray, myToolbarItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        coreDataHelper = [[CoreDataHelper alloc] init];
        locationHelper = [[LocationHelper alloc] init];
        activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        self.placesInformation = [[PlacesInformation alloc] init];
        //self.toolbarItems = [[NSArray alloc] init];
        //self.placesInformationArray = [[NSArray alloc] init];
        //placeNames = [[NSMutableArray alloc] init];
        
        //[self.view setBackgroundColor:[UIColor colorWithRed:202.0f/255.0f green:237.0f/255.0f blue:1.0 alpha:1.0]];
        
        placesHelper = [[PlacesHelper alloc] init];
    }
    return self;
}

/*
- (void)goFetchPlaces:(NSMutableArray *)responseArray
{
    self.placesDictionaryArray = [[NSMutableArray alloc] initWithArray:responseArray];
    self.placeNames = [[NSMutableArray alloc] initWithArray:[locationHelper placeNames]];
    
    //clear out the old places
    [coreDataHelper deleteManagedObject:PLACES_ENTITY];
    [coreDataHelper deleteManagedObject:PLACE_DETAILS_ENTITY];
    
    //save to CoreData
    for (int i = 0; i < self.placesDictionaryArray.count; i++) {
        [coreDataHelper savePlacesData:[self.placesDictionaryArray objectAtIndex:i]];
    }
    for (int i = 0; i < [[locationHelper placeDetailsDictionaryArray] count]; i++) {
        [coreDataHelper savePlaceDetailsData:[locationHelper.placeDetailsDictionaryArray objectAtIndex:i]];
    }

}
 */

- (void)fetchPlaces_callback:(PlacesInformation *)pPlacesInformation
{
    //save place information to core data
    [coreDataHelper deleteManagedObject:PLACES_ENTITY];
    [coreDataHelper deleteManagedObject:PLACE_DETAILS_ENTITY];
    
    //save to core data
    [coreDataHelper savePlacesData:pPlacesInformation];
    
    //update our array that populates the table view
    [self loadPlaceNamesArrayFromStorage];
    
    [[activityView activityIndicator] stopAnimating];
    [activityView removeFromSuperview];
    
    [[self tableView] reloadData];
    //[self.refreshControl endRefreshing];
}

- (void)updatePlaces
{
    //Create serial dispatch queue
    //dispatch_queue_t queue;
    //queue = dispatch_queue_create(DISPATCH_QUEUE_1, NULL);
    //if (queue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //dispatch_async(queue, ^{
            
            //start our activity indicator
            //[self.navigationController.view addSubview:activityView];
            
            //Do our main places web service call
            //placesInformation = [locationHelper fetchPlaces];
            placesInformation = [placesHelper fetchPlaces];
            [self performSelectorOnMainThread:@selector(fetchPlaces_callback:)
                                   withObject:placesInformation
                                waitUntilDone:YES];
        });
    //}
}

- (void)refreshTableView
{
    //[self.refreshControl beginRefreshing];
    //Grab our current location
    //[locationHelper turnOnLocationService];
    
    //Start activity indicator
    activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    //UILabel *messageLabel = [[UILabel alloc] init];
    //[messageLabel setText:@"Updating place list, please wait..."];
    //[activityView setLabel:messageLabel];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    [self.navigationController.view addSubview:activityView];
    
    
    [self updatePlaces];

}

- (void)viewWillAppear:(BOOL)animated
{
    //self.toolbarItems = myToolbarItems;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(refreshTableView)];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    NSArray *viewControllers = [[self navigationController] viewControllers];
    NSLog(@"ViewController Count: %d", viewControllers.count);
    //for (int i = 0; i < viewControllers.count; i++) {
    //
    /*
    UIViewController *targetViewController;
    BOOL willPop = NO;
    for (UIBarButtonItem *item in self.toolbarItems) {
        if (item.tag == kHomeButton) {
            for (int i = 0; i < viewControllers.count; i++) {
                id vc = [viewControllers objectAtIndex:i];
                if ([vc isKindOfClass:[LandingPageViewController class]]) {
                    targetViewController = vc;
                    willPop = YES;
                    break;
                }
            }
        }
        
    }
     */
    
    
//    activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
//    [activityView layoutSubviews];
//    [activityView.activityIndicator startAnimating];
//    [self.view addSubview:activityView];

}

- (void)loadPlaceNamesArrayFromStorage
{
    //NSArray *lPlacesData = [coreDataHelper fetchData:PLACES_ENTITY];
    NSArray *lPlaceDetails = [[NSArray alloc] initWithArray:[coreDataHelper fetchData:PLACE_DETAILS_ENTITY]];
    NSMutableArray *lPlacesInformationArray = [[NSMutableArray alloc] init];
    //load up our place names
    //self.placeNames = [[NSMutableArray alloc] init];
    //for (PlacesData *lData in lPlacesData) {
        //NSLog(@"place %@", lData.name);
      //  [self.placeNames addObject:lData.name];
    //}
    
    //Get the place details
    //PlacesInformation *lPlacesInformation = [[PlacesInformation alloc] init];
    //NSMutableArray *lPlaceAddresses = [[NSMutableArray alloc] init];
    //NSMutableArray *lPlaceImages = [[NSMutableArray alloc] init];
    //NSMutableArray *lPlaceNames = [[NSMutableArray alloc] init];
    UIImage *lImage = [[UIImage alloc] init];
   
    for (PlaceDetails *lDetails in lPlaceDetails) {
        PlacesInformation *lPlacesInformation = [[PlacesInformation alloc] init];
        PlacesData *lParentPlace = lDetails.placesData;
        [lPlacesInformation setPlaceName:lParentPlace.name];
        [lPlacesInformation setPlaceAddress:lDetails.formattedAddress];
        [lPlacesInformation setPhoneNumber:lDetails.formattedPhoneNumber];
        [lPlacesInformation setWebsiteUrl:lDetails.website];
        [lPlacesInformation setPlaceId:lDetails.placeId];
        
        if (lDetails.imageData == nil && lParentPlace.defaultImageData != nil) {
            lImage = [UIImage imageWithData:lParentPlace.defaultImageData];
        }
        /*
        if (lDetails.photoReference == nil || lDetails.photoReference.length == 0) {
            
            NSURL *imageUrl = [NSURL URLWithString:lParentPlace.iconUrl];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
            lImage = [UIImage imageWithData:imageData];
        }*/
        else {
            NSMutableArray *lPhotoRefs = [[NSMutableArray alloc] init];
            int lOldIndex = 0;
            int lNewIndex = 0;
            BOOL hasComma = false;
            for (int i = 0; i < lDetails.photoReference.length; i++) {
                char lChar = [lDetails.photoReference characterAtIndex:i];
                if (lChar == ',') {
                    hasComma = true;
                    NSRange lRange;
                    lRange.location = lOldIndex;
                    lRange.length = lNewIndex;
                    NSString *lTempRef = [lDetails.photoReference substringWithRange:lRange];
                    [lPhotoRefs addObject:lTempRef];
                    lOldIndex = ++lNewIndex;
                }
                lNewIndex++;
            }
            
            if (!hasComma) {
                //lImage = [placesHelper getPlacePhoto:lDetails.photoReference];
                lImage = [UIImage imageWithData:lDetails.imageData];
            } else {
                for (NSString *lRef in lPhotoRefs) {
                    //find one and then drop out
                    lImage = [placesHelper getPlacePhoto:lRef];
                    break;
                }
            }
        }
        
        if (lImage == nil) {
            UIImage *lDefaultImage = [UIImage imageNamed:@"luau1_sm.png"];
            [lPlacesInformation setPlaceImage:lDefaultImage];
        } else {
            [lPlacesInformation setPlaceImage:lImage];
        }
        
        [lPlacesInformationArray addObject:lPlacesInformation];
        
    }
    self.placesInformationArray = [[NSArray alloc] initWithArray:lPlacesInformationArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    UIRefreshControl *lRefreshControl = [[UIRefreshControl alloc] init];
    [lRefreshControl setTintColor:[UIColor magentaColor]];
    [lRefreshControl addTarget:self
                        action:@selector(refreshTableView)
              forControlEvents:UIControlEventValueChanged];
    self.refreshControl = lRefreshControl;
    */
    [self loadPlaceNamesArrayFromStorage];
}

- (void)savePlaces
{
    //clear out the old places
    [coreDataHelper deleteManagedObject:PLACES_ENTITY];
    [coreDataHelper deleteManagedObject:PLACE_DETAILS_ENTITY];
    
    //save to core data
    [coreDataHelper savePlacesData:placesInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.placesInformationArray != nil && self.placesInformationArray.count > 0) {
        NSLog(@"NumberOfRowsInSection PLACENAMES: %lu", (unsigned long)[self.placesInformationArray count]);
        return [self.placesInformationArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    PlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //PlacesInformation *lPlacesInformation = self.placesInformation;

    if (!cell)
    {
        cell = [[PlacesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Cell"];
    }
    
    //[[cell textLabel] setText:[self.placeNames objectAtIndex:[indexPath row]]];
    //[cell setBackgroundColor:[UIColor clearColor]];
    //[cell setAccessoryType:UITableViewCellAccessoryNone];
    
    PlacesInformation *lPlacesInformation = [self.placesInformationArray objectAtIndex:[indexPath row]];
    [[cell placeNameLabel] setText:[lPlacesInformation placeName]];
    [[cell addressLabel] setText:[lPlacesInformation placeAddress]];
    [[cell imageView] setImage:[lPlacesInformation placeImage]];
    
    //[[cell placeNameLabel] setText:[lPlacesInformation.placeNames objectAtIndex:[indexPath row]]];
    //[[cell addressLabel] setText:[lPlacesInformation.placesAddresses objectAtIndex:[indexPath row]]];
    //[[cell imageView] setImage:[lPlacesInformation.placesImages objectAtIndex:[indexPath row]]];
    
    return cell;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefaultSurveyViewController *svc = [[DefaultSurveyViewController alloc] init];
    //NSString *place = [locationHelper.placeNames objectAtIndex:[indexPath row]];
    NSString *place = [self.placeNames objectAtIndex:[indexPath row]];
    [svc setTitle:place];
    [svc setCurrentPlace:place];
    PlacesInformation *lPlacesInformation = [self.placesInformationArray objectAtIndex:indexPath.row];
    [svc setPlacesInformation:lPlacesInformation];
    [self.navigationController pushViewController:svc
                                         animated:YES];
}

@end
