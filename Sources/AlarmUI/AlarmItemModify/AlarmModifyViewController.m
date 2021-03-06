    //
//  AlarmModifyViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmModifyViewController.h"
#import "IAAlarm.h"



@implementation AlarmModifyViewController
@synthesize alarm;

/*
-(id)alarm
{
	return alarm;
}
-(void)setAlarm:(id)newObj
{
	[newObj retain];
	[alarm release];
	alarm = newObj;
}
 */


-(IBAction)doneButtonPressed:(id)sender
{	
	//子类覆盖
	//改变了，发送通知
	/*
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:IAAlarmItemsDidChangeNotification object:self];
	 */
	/*
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmItemsDidChangeNotification object:self];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	*/
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		alarm = theAlarm;
		[alarm retain];
	}
	return self;
}

-(id)initWithAlarm:(IAAlarm*)theAlarm{
	return [self initWithNibName:nil bundle:nil alarm:theAlarm];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil alarm:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								   target:self 
								   action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = NO;
    [doneButton release];
	 */
	 
}

//代码难看，为了省事不用修改其他代码
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self doneButtonPressed:self]; //其实会调用到子类的这个方法
}


- (void)dealloc {
	[alarm release];
	alarm = nil;
    [super dealloc];
}


@end
