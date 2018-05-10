

#import <UIKit/UIKit.h>

@protocol ADAppointmentTableViewCellDelegate;


@interface ADAppointmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *appointmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueOnTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateTextLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryColorBadgeView;
@property (weak, nonatomic) IBOutlet UIButton *taskCompletedButton;
@property (weak, nonatomic) id <ADAppointmentTableViewCellDelegate>delegate;

@end

@protocol ADAppointmentTableViewCellDelegate <NSObject>

- (void)didchangeTaskCompletionStatusAtCell:(ADAppointmentTableViewCell*)cell toComplete:(BOOL)completionStatus;

@end
