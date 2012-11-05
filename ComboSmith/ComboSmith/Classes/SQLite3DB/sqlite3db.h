//
//  sqlite3db.h
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface sqlite3db : UIViewController {

	
	NSMutableArray *combosArray;
}

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UITextField *textField;

// Actions
-(IBAction)insertCombo:(id)sender;

@end