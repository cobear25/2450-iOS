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
#import "MonthDetailTableViewCell.h"
#import "WeekViewController.h"
#import "JTCalendarDayView.h"
#import "APIClient.h"
#import "Shift.h"
#import "Role.h"

@interface ScheduleViewController()<JTCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
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
@property (strong, nonatomic) NSDate *selectedDate;

@property (strong, nonatomic) NSMutableDictionary *eventsByDate;

@property (strong, nonatomic) NSMutableArray *shifts;
@property (strong, nonatomic) NSMutableArray *selectedDayShifts;

@property (strong, nonatomic) NSMutableArray *roles;
@end

@implementation ScheduleViewController

// Called upon loading the view before anything is displayed
- (void)viewDidLoad {
    [super viewDidLoad];
    self.roles = [[NSMutableArray alloc] init];
    [[APIClient sharedClient] getRoles:^(id json) {
        NSLog(@"%@", json);
        NSArray *jsonArray = json;
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *title = [obj valueForKey:@"title"];
            NSString *color = [obj valueForKey:@"color"];
            NSString *desc = [obj valueForKey:@"description"];
            Role *role = [[Role alloc] init];
            role.colorString = color;
            role.title = title;
            role.descriptionString = desc;
            [self.roles addObject:role];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure: ");
    }];

    self.monthDetailTableView.delegate = self;
    self.monthDetailTableView.dataSource = self;
    [self.monthDetailTableView registerNib:[UINib nibWithNibName:@"MonthDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.selectedDayShifts = [[NSMutableArray alloc] init];
    self.shifts = [[NSMutableArray alloc] init];
    [[APIClient sharedClient] getShiftsOnSuccess:^(id json){
        NSLog(@"%@", json);
        NSArray *jsonArray = json;
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Shift *shift = [[Shift alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = self.calendar.calendarAppearance.calendar.timeZone;
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
            NSDate *startDate = [dateFormatter dateFromString:[obj objectForKey:@"start_time"]];
            NSDate *endDate = [dateFormatter dateFromString:[obj objectForKey:@"end_time"]];

            NSTimeInterval timeZoneSeconds = 60*60*6;//[[NSTimeZone localTimeZone] secondsFromGMT];
            NSDate *startTimeInLocalTimezone = [startDate dateByAddingTimeInterval:timeZoneSeconds];
            NSDate *endTimeInLocalTimezone = [endDate dateByAddingTimeInterval:timeZoneSeconds];

            shift.startTime = startTimeInLocalTimezone;
            shift.endTime = endTimeInLocalTimezone;
//            shift.startTime = [dateFormatter dateFromString:[obj objectForKey:@"start_time"]];
//            shift.endTime = [dateFormatter dateFromString:[obj objectForKey:@"end_time"]];
            NSArray *roles = [obj objectForKey:@"roles"];
            if (roles.count > 0) {
                shift.role = [[(NSArray *)[obj objectForKey:@"roles"] objectAtIndex:0] integerValue];
            }
            shift.user = [[obj objectForKey:@"user"] integerValue];
            [self.shifts addObject:shift];
        }];
        for (Shift *shift in self.shifts) {
            NSLog(@"%@", shift.startTime);
        }
        [self showScheduleViewForSelection:self.todayLabel];
        [self addShifts];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];

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
    [self.navigationItem setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
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
//    [self createRandomEvents];

    // Hide month view when view appears
    self.calendarContentView.hidden = YES;
    self.calendarMenuView.hidden = YES;
    [self calendarDidDateSelected:self.calendar date:[NSDate date]];
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
    self.selectedDate = date;
    [self.selectedDayShifts removeAllObjects];
    for (Shift *shift in self.shifts) {
        NSString *shiftDate = [[self dateFormatter] stringFromDate:shift.startTime];
        NSString *selectedDate = [[self dateFormatter] stringFromDate:self.selectedDate];
        if ([shiftDate isEqualToString:selectedDate]) {
            [self.selectedDayShifts addObject:shift];
        }
    }
    NSString *key = [[self dateFormatter] stringFromDate:date];
    NSArray *events = self.eventsByDate[key];

    NSLog(@"Date: %@ - %ld events", date, (unsigned long)[events count]);
    [self.monthDetailTableView reloadData];
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
        dvc.roles = self.roles;
        dvc.view.frame = self.containerView.frame;
        [self.containerView addSubview:dvc.view];
        for (Shift *shift in self.shifts) {
            NSString *shiftDate = [[self dateFormatter] stringFromDate:shift.startTime];
            NSString *todayDate = [[self dateFormatter] stringFromDate:[NSDate date]];
            NSLog(@"shift: %@", shiftDate);
            NSLog(@"today: %@", todayDate);
            NSLog(@" ");
            if ([shiftDate isEqualToString:todayDate]) {
                [dvc.shifts addObject:shift];
            }
        }

        [dvc didMoveToParentViewController:self];

    } else if (label == self.weekLabel) {
        // Display the week view and hide the others
        [dvc removeFromParentViewController];
        self.containerView.hidden = NO;
        [self addChildViewController:wvc];
        wvc.view.frame = self.containerView.frame;
        [self.containerView addSubview:wvc.view];
        [wvc didMoveToParentViewController:self];
        wvc.roles = self.roles;
        for (Shift *shift in self.shifts) {
            NSString *shiftDate = [[self dateFormatter] stringFromDate:shift.startTime];
            NSString *todayDate = [[self dateFormatter] stringFromDate:[NSDate date]];

            NSDateFormatter *dowFormatter = [[NSDateFormatter alloc] init];
            [dowFormatter setDateFormat:@"EEEE"];
            NSString *dayOfWeek = [dowFormatter stringFromDate:shift.startTime];
            NSString *today = [dowFormatter stringFromDate:[NSDate date]];

            NSInteger shiftDay = [self intForDayOfWeek:dayOfWeek];
            NSInteger todayDay = [self intForDayOfWeek:today];

            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *dateToday = [NSDate date];

            NSDateComponents *todaysComponents =
            [gregorian components:NSWeekCalendarUnit fromDate:dateToday];

            NSUInteger todaysWeek = [todaysComponents week];


            NSDate *anotherDate = shift.startTime;

            NSDateComponents *otherComponents =
            [gregorian components:NSWeekCalendarUnit fromDate:anotherDate];
            
            NSUInteger anotherWeek = [otherComponents week];
            if (todaysWeek == anotherWeek) {
                [wvc.shifts addObject:shift];
                [wvc.shiftDays addObject:[NSNumber numberWithInteger:shiftDay]];
            }

//            if ([shiftDate isEqualToString:todayDate]) {
//            }
        }
    } else {
        // Display the month view and hide the others
        [dvc removeFromParentViewController];
        [wvc removeFromParentViewController];
        self.containerView.hidden = YES;
        self.calendarContentView.hidden = NO;
        self.calendarMenuView.hidden = NO;
        self.monthDetailTableView.hidden = NO;
        [self calendarDidDateSelected:self.calendar date:[NSDate date]];
    }
}

- (NSInteger)intForDayOfWeek:(NSString *)day {
    if ([day isEqualToString:@"Monday"]) {
        return 0;
    } else if ([day isEqualToString:@"Tuesday"]) {
        return 1;
    } else if ([day isEqualToString:@"Wednesday"]) {
        return 2;
    } else if ([day isEqualToString:@"Thursday"]) {
        return 3;
    } else if ([day isEqualToString:@"Friday"]) {
        return 4;
    } else if ([day isEqualToString:@"Saturday"]) {
        return 5;
    } else {
        return 6;
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

- (void)addShifts {
    self.eventsByDate = [NSMutableDictionary new];
    for (Shift *shift in self.shifts) {
        NSDate *date = shift.startTime;
        NSString *key = [[self dateFormatter] stringFromDate:date];
        if(!self.eventsByDate[key]){
            self.eventsByDate[key] = [NSMutableArray new];
        }

        [self.eventsByDate[key] addObject:date];
    }
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

#pragma mark - TableView Delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MonthDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row <= self.selectedDayShifts.count) {
        Shift *shift = [self.selectedDayShifts objectAtIndex:indexPath.row];
        
        UIView *shiftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-2)];
        Role *role;
        if (shift.role) {
            role = [self.roles objectAtIndex:shift.role - 1];
        } else {
            role = [[Role alloc] init];
            role.colorString = @"#ffffff";
            role.title = @"";
            role.descriptionString = @"";
        }
        NSString *colorString = role.colorString;
        UIColor *roleColor = [UIColor colorFromHexString:colorString];
        shiftView.backgroundColor = roleColor;
        
        UILabel *shiftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width/2, shiftView.frame.size.height)];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        NSString *startTime = [timeFormatter stringFromDate:shift.startTime];
        NSString *endTime = [timeFormatter stringFromDate:shift.endTime];
        shiftLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        shiftLabel.font = [UIFont systemFontOfSize:20];
        [shiftView addSubview:shiftLabel];

        UILabel *roleTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(shiftView.frame), 0, cell.frame.size.width/2, shiftView.frame.size.height)];
        roleTitle.text = role.title;
        roleTitle.font = [UIFont systemFontOfSize:20];
        [shiftView addSubview:roleTitle];

        [cell addSubview:shiftView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)rowForTime:(NSInteger)hour Minute:(NSInteger)minute {
    BOOL firstHalfHour = YES;
    if (minute >= 30) {
        firstHalfHour = NO;
    }
    if (firstHalfHour) {
        return hour * 2;
    } else {
        return hour * 2 + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedDayShifts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

@end
