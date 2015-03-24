//
//  ScheduleViewController.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UIColor+CRCAdditions.h"
#import "JTCalendar.h"
#import "DayViewController.h"
#import "WeekViewController.h"

@interface ScheduleViewController()<JTCalendarDataSource>
// Declare class variables, in objective-c they're called properties
@property (weak, nonatomic) IBOutlet UIView *greenUnderbar;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *scheduleView;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendar *calendar;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITableView *monthDetailTableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSMutableDictionary *eventsByDate;
@end

@implementation ScheduleViewController

// Called upon loading the view before anything is displayed
- (void)viewDidLoad {
    [super viewDidLoad];

    // Add calendar view and set appearance
    self.calendar = [JTCalendar new];
    self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 2.;
    self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;

    // Customize the text for each month
    self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
        NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;

        static NSDateFormatter *dateFormatter;
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
        }
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
        return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
    };

    // Set up content for calendar view
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];

    // Set up basic layout including touch events for bottom buttons
    self.navigationController.navigationBarHidden = NO;
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor CRCGreenColor], NSForegroundColorAttributeName, nil];

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Requests >" style:UIBarButtonItemStyleDone target:self action:@selector(requestButtonTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor CRCGreenColor];

    // Add gestures to bottom labels so they act like buttons
    UITapGestureRecognizer *dayTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    UITapGestureRecognizer *weekTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    UITapGestureRecognizer *monthTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.todayLabel addGestureRecognizer:dayTapped];
    [self.weekLabel addGestureRecognizer:weekTapped];
    [self.monthLabel addGestureRecognizer:monthTapped];

    // Animate to the current bottom label
    [self animateGreenUnderbarToLabel:self.todayLabel];

    // Will be replaced with events from the API, but this creates the events that the calendar will display
    [self createRandomEvents];

    // Hide month view when view appears
    self.calendarContentView.hidden = YES;
    self.calendarMenuView.hidden = YES;
}

// Called once the view is ready to display
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Reload data to be displayed on calendar
    [self.calendar reloadData];
}

// When the button is tapped this is called and the app transitions to the request page
- (void)requestButtonTapped {
    [self performSegueWithIdentifier:@"requestSegue" sender:self];
}

// When any of the three bottom labels are tapped, the green underbar then animates to the tapped label
- (void)labelTapped:(UITapGestureRecognizer *) gesture {
    UILabel *label = (UILabel *)gesture.view;
    [self animateGreenUnderbarToLabel:label];
}

// A basic UI animation moving the green bar to the passed in label
- (void)animateGreenUnderbarToLabel:(UILabel *)label {
    CGRect frame = label.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.greenUnderbar.frame = CGRectMake(frame.origin.x, self.greenUnderbar.frame.origin.y, frame.size.width, self.greenUnderbar.frame.size.height);
    }];
    // Display appropriate view
    [self showScheduleViewForSelection:label];
}

#pragma mark - JTCalendarDataSource

// Adds an indicator on the calendar if an event is found for the specific date
- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];

    if(self.eventsByDate[key] && [self.eventsByDate[key] count] > 0){
        return YES;
    }

    return NO;
}

// Called upon selecting a day on the calendar view, this then displays data in the bottom tableview
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = self.eventsByDate[key];

    NSLog(@"Date: %@ - %ld events", date, (unsigned long)[events count]);
}

// Called when the next month is selected
- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

// Called when the previous month is selected
- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
}

// This method toggles which view is being presented based on which button/label has been selected
- (void)showScheduleViewForSelection:(UILabel *)label {
    DayViewController *dvc = [DayViewController new];
    WeekViewController *wvc = [WeekViewController new];
    // Display the today view and hide the others
    if (label == self.todayLabel) {
        [wvc removeFromParentViewController];
        self.containerView.hidden = NO;
        [self addChildViewController:dvc];
        dvc.view.frame = self.containerView.frame;
        [self.containerView addSubview:dvc.view];
        [dvc didMoveToParentViewController:self];

    } else if (label == self.weekLabel) {
        // Display the week view and hide the others
        [dvc removeFromParentViewController];
        self.containerView.hidden = NO;
        [self addChildViewController:wvc];
        wvc.view.frame = self.containerView.frame;
        [self.containerView addSubview:wvc.view];
        [wvc didMoveToParentViewController:self];
    } else {
        // Display the month view and hide the others
        [dvc removeFromParentViewController];
        [wvc removeFromParentViewController];
        self.containerView.hidden = YES;
        self.calendarContentView.hidden = NO;
        self.calendarMenuView.hidden = NO;
        self.monthDetailTableView.hidden = NO;
    }
}

#pragma mark - Temporary data for calendar
// return a formatted date
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}

// Creates events to be displayed on the calendar
- (void)createRandomEvents
{
    self.eventsByDate = [NSMutableDictionary new];

    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 10)) sinceDate:[NSDate date]];

        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];

        if(!self.eventsByDate[key]){
            self.eventsByDate[key] = [NSMutableArray new];
        }

        [self.eventsByDate[key] addObject:randomDate];
    }
}

@end
