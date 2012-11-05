//
//  sqlite3db.m
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import "sqlite3db.h"

#define DATABASE_NAME @"combos.sqlite"
#define DATABASE_TITLE @"combos"

static int loadTimesCallback(void *context, int count, char **values, char **columns)
{
    NSMutableArray *times = (NSMutableArray *)context;
    for (int i=0; i < count; i++) {
        const char *comboCString = values[i];
        [times addObject:[NSString stringWithUTF8String:comboCString]];
    }
    return SQLITE_OK;
}

#pragma mark Private Interface
@interface sqlite3db(Private)
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)saveData:(NSString *)data;
-(void)loadTimesFromDatabase;
-(void)updateTextViewContents;
@end

#pragma mark Public Implementation
@implementation sqlite3db

@synthesize textView;
@synthesize textField;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Setup the array
	combosArray = [[NSMutableArray alloc] init];
	
    [self loadTimesFromDatabase];
    [self updateTextViewContents];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[combosArray release];
    [super dealloc];
}

- (void)updateTextViewContents {
	// Update text
	NSMutableString *content = [[NSMutableString alloc] init];
	for (int i = 0; i < [combosArray count]; i++) {
		NSString *data = [combosArray objectAtIndex:i];
        [content appendString:data];
		[content appendString:@"\n"];
        
	}
	
	textView.text = content;
	[content release];
}


-(IBAction)insertCombo:(id)sender {
	
	if(textField.text != @"") {
		// Insert into the database (Change to table?)
		[self saveData:textField.text];
	}
    [self loadTimesFromDatabase];
}

- (NSString *) getWritableDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
}

- (void)loadTimesFromDatabase
{
    NSString *file = [self getWritableDBPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:file]; 
    
	// If its not a local copy set it to the bundle copy
	if(!success) {
		//file = [[NSBundle mainBundle] pathForResource:DATABASE_TITLE ofType:@"db"];
		[self createEditableCopyOfDatabaseIfNeeded];
	}
    
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, "SELECT * FROM COMBOS", loadTimesCallback, combosArray, NULL);
    }
    sqlite3_close(database);
}

- (void)saveData:(NSString *)data {
	
	// Copy the database if needed
	[self createEditableCopyOfDatabaseIfNeeded];
	
	NSString *filePath = [self getWritableDBPath];
	
	sqlite3 *database;
	
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "INSERT TO COMBOS (ID, DATE, NAME, INPUT, CPERM, SESSION) VALUES (?,?,?,?,?,?)";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
			sqlite3_bind_text( compiledStatement, 1, [data UTF8String], -1, SQLITE_TRANSIENT);			
		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			//NSLog( @"Save Error: %s", sqlite3_errmsg(database) );
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);	
}

-(void)createEditableCopyOfDatabaseIfNeeded 
{
    // Testing for existence
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
	
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
	
    // The writable database does not exist, so copy the default to
    // the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
							   stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath
								   toPath:writableDBPath
									error:&error];
    if(!success)
    {
        NSAssert1(0,@"Failed to create writable database file with Message : '%@'.",
				  [error localizedDescription]);
    }
}

@end