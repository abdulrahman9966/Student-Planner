
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TaskDetailViewController.h"


@interface TaskTableViewController : UITableViewController<TaskDetailViewControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end
