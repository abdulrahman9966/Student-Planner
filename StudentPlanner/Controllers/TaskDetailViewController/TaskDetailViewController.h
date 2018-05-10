

#import <UIKit/UIKit.h>
#import "Task.h"


@protocol TaskDetailViewControllerDelegate;


@interface TaskDetailViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic,assign) BOOL isAddingTask;
@property (nonatomic,strong) Task *currentTask;
@property (nonatomic,weak) id <TaskDetailViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *tasknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UIButton *taskNotificationCheckbox;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)notifyTaskButtonPressed:(id)sender;
//-(void) createCalendarEventWithTitle:(NSString*) title location:(NSString*)location startDate:(NSDate*)sDate EndDate:(NSDate*)eDate allDay:(BOOL) isAllDay remindAlarm:(NSArray*) alarmArray;
@end

@protocol TaskDetailViewControllerDelegate <NSObject>

-(void)addTaskDidSaveOnEdit:(BOOL)editingMode;
-(void)addTaskDidCancelTask:(Task*)taskToCancel editAttempted:(BOOL)editAttempted;

@end
