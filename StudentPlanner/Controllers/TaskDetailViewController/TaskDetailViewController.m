
#import "TaskDetailViewController.h"
#import <EventKit/EventKit.h>


@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *customNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *customNavigationItem;
@property (weak, nonatomic) IBOutlet UIDatePicker *UIDatePickerControl;

@property (nonatomic,strong)NSMutableDictionary *categoriesDictionary;

@property (strong, nonatomic) NSArray *cA;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.taskNotificationCheckbox setBackgroundImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.taskNotificationCheckbox setBackgroundImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];
    
    [self setupNavigationBar];
    [self setupView];
    
}

//-(void) createCalendarEventWithTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)sDate EndDate:(NSDate *)eDate allDay:(BOOL)isAllDay remindAlarm:(NSArray *)alarmArray{
//    
//    EKEventStore *store = [[EKEventStore alloc]init];
//    
//    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
//        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"add calendar error");
//            }else if(!granted){
//                NSLog(@"can't access calandar");
//            }else{
//                EKEvent *event  = [EKEvent eventWithEventStore:store];
//                event.title     = title;
//                event.location  = location;
//                event.startDate = sDate;
//                event.endDate   = eDate;
//                event.allDay    = isAllDay;
//                
//                if (alarmArray && alarmArray.count > 0) {
//                    for (NSString *timeString in alarmArray) {
//                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
//                    }
//                }
//                
//                [event setCalendar:[store defaultCalendarForNewEvents]];
//                NSError *err;
//                [store saveEvent:event span:EKSpanThisEvent error:&err];
//                NSLog(@"added the event to calendar");
//            }
//        }];
//    }
//    
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - Methods to setup the UI initially
- (void)setupNavigationBar {
    UIBarButtonItem *leftSideButton;
    UIBarButtonItem *rightSideButton;
    
    if (self.isAddingTask) {
        self.customNavigationItem.title = @"Add Task";
        leftSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        
        rightSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    }else {
        self.customNavigationItem.title = @"Task";
        leftSideButton = [[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
        
        rightSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    }
    
    self.customNavigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSideButton, nil];
    self.customNavigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightSideButton, nil];
}


- (void)setupView {
    self.tasknameTextField.text = [self.currentTask name];
    self.subjectTextField.text = [self.currentTask category];
    self.notesTextView.text = [self.currentTask notes];
    [self.subjectTextField setDelegate:self];
    
    NSDate *currentdate=[ NSDate date];
    [_UIDatePickerControl setMinimumDate:currentdate];
    
    NSDate *date = [NSDate date];
    self.UIDatePickerControl.date = date;
    if ([[self.currentTask notifyTask] boolValue]) {
        [self.taskNotificationCheckbox setSelected:YES];
    }
    
    if (!self.isAddingTask) {
        self.tasknameTextField.enabled = NO;
        self.subjectTextField.enabled = NO;
        self.notesTextView.editable = NO;
        [self.taskNotificationCheckbox setUserInteractionEnabled:NO];
        
        self.UIDatePickerControl.date = [self.currentTask dueDate];
        self.UIDatePickerControl.userInteractionEnabled = NO;
        self.UIDatePickerControl.alpha = 0.4f;
    }
}


#pragma mark - BarButtonItem methods
- (void)cancelButtonPressed {
    [self.delegate addTaskDidCancelTask:self.currentTask editAttempted:NO];
}


- (void)saveButtonPressed {
    if (([self.tasknameTextField.text length] != 0) && ([self.subjectTextField.text length] != 0)) {
        [self.currentTask setName:self.tasknameTextField.text];
        [self.currentTask setCategory:self.subjectTextField.text];
        [self.currentTask setNotes:self.notesTextView.text];
        //    [self.currentTask setIsTaskCompleted:0];
        //    [self.currentTask setNotifyTask:0];
        //    [self.currentTask setCategoryColor:@""];
        
        NSDate *date = self.UIDatePickerControl.date;
        [self.currentTask setDueDate:date];
        
        
        EKEventStore *store = [[EKEventStore alloc]init];
        
        if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"add calendar error");
                }else if(!granted){
                    NSLog(@"can't access calandar");
                }else{
                    EKEvent *event  = [EKEvent eventWithEventStore:store];
                    event.title     = self.currentTask.name;
                    event.startDate = self.currentTask.dueDate;
                    event.endDate   = self.currentTask.dueDate;
                    event.notes = self.currentTask.notes;
                   // event.allDay    = self.currentTask.dueDate;
//                    
//                    if (alarmArray && alarmArray.count > 0) {
//                        for (NSString *timeString in alarmArray) {
//                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
//                        }
//                    }
                    
                    [event setCalendar:[store defaultCalendarForNewEvents]];
                    NSError *err;
                    [store saveEvent:event span:EKSpanThisEvent error:&err];
                    NSLog(@"added the event to calendar");
                }
            }];
        }
        
        
        [self.currentTask setCategory:self.subjectTextField.text];
        self.categoriesDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"TC"]];
        
        [self.currentTask setCategoryColor:[self.categoriesDictionary objectForKey:self.subjectTextField.text]];
        
        [self.currentTask setNotifyTask:[NSNumber numberWithBool:self.taskNotificationCheckbox.selected]];
        if (self.taskNotificationCheckbox.selected) {
            if ([self.tasknameTextField.text length] != 0) {
                UILocalNotification *localNotification = [[UILocalNotification alloc]init];
                localNotification.fireDate = date;
                localNotification.alertBody = self.tasknameTextField.text;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                
                localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@%lu",date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]], @"uniqueSig", self.tasknameTextField.text, @"alertText", nil];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
                NSMutableArray *localNotificationBackupArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"localNotificationBackup"]];
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
                [localNotificationBackupArray addObject:data];
                [[NSUserDefaults standardUserDefaults]setObject:localNotificationBackupArray forKey:@"localNotificationBackup"];
            }
        }

        if (self.isAddingTask) {
            [self.delegate addTaskDidSaveOnEdit:NO];
        } else {
            [self.delegate addTaskDidSaveOnEdit:YES];
        }
    } else {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill in all the details before saving your task" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
}


#pragma mark - Download Data (Saving Locally)

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate addTaskDidCancelTask:self.currentTask editAttempted:YES];
}


- (void)editButtonPressed {
    self.tasknameTextField.enabled = YES;
    self.subjectTextField.enabled = YES;
    self.notesTextView.editable = YES;
    [self.taskNotificationCheckbox setUserInteractionEnabled:YES];
    self.UIDatePickerControl.userInteractionEnabled = YES;
    self.UIDatePickerControl.alpha = 1.0f;
    
    self.customNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    
    NSString *uniqueID = [NSString stringWithFormat:@"%@%@%lu",self.UIDatePickerControl.date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]];
    
    NSMutableArray *Arr=[[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
    for (int k=0;k<[Arr count];k++) {
        UILocalNotification *not=[Arr objectAtIndex:k];
        NSString *uniqueString=[not.userInfo valueForKey:@"uniqueSig"];
        if([uniqueString isEqualToString:uniqueID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"localNotificationBackup"] removeObject:not];
            [self.currentTask setNotifyTask:[NSNumber numberWithBool:NO]];
            [self.taskNotificationCheckbox setSelected:NO];
        }
    }
}


#pragma mark - Functionality methods for UI elements
- (IBAction)notifyTaskButtonPressed:(id)sender {
    if (self.taskNotificationCheckbox.selected) {
        [self.taskNotificationCheckbox setSelected:NO];
    }else {
        [self.taskNotificationCheckbox setSelected:YES];
    }
}


#pragma mark - UITextField Delegate methods
- (IBAction)categoryTextFieldEditingDidBegin:(id)sender {
    UIActionSheet *categoryActionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose a Course" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    self.cA = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults]objectForKey:@"TC"] allKeys]];
    
    
    for (NSString *key in self.cA) {
        [categoryActionSheet addButtonWithTitle:key];
    }
    
    [categoryActionSheet showInView:self.view];
    [self.subjectTextField resignFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.subjectTextField resignFirstResponder];
}


#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.subjectTextField setText:[self.cA objectAtIndex:buttonIndex]];
    
    //Not working when called on category textField for some reason
    [self.tasknameTextField becomeFirstResponder];
    [self.tasknameTextField resignFirstResponder];
}


@end
