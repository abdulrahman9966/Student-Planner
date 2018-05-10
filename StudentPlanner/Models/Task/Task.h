

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * categoryColor;
@property (nonatomic, retain) NSNumber * notifyTask;
@property (nonatomic, retain) NSNumber * isTaskCompleted;

@end
