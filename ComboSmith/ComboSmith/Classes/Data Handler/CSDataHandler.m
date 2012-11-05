//
//  CSDataHandler.m
//  ComboSmith
//
//  Created by Erran Carey on 3/16/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import "CSDataHandler.h"

@implementation CSDataHandler
@synthesize name, combo, session, cperm, status;

- (void) saveData
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO combos (name, combo, session, cperm) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", name.text, combo.text, session.text, cperm.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(comboDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            status.text = @"Combo added";
            name.text = @"";
            combo.text = @"";
            session.text = @"";
            cperm.text = @"";
        } else {
            status.text = @"Failed to add combo";
        }
        sqlite3_finalize(statement);
        sqlite3_close(comboDB);
    }
}

- (void) findCombo
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT combo, session, cperm FROM combos WHERE name=\"%@\"", name.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(comboDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *comboField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                combo.text = comboField;
                
                NSString *sessionField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                session.text = sessionField;
                
                NSString *cpermField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                cperm.text = cpermField;
                
                status.text = @"Match found";
                
                [comboField release];
                [sessionField release];
            } else {
                status.text     = @"Match not found";
                combo.text      = @"";
                session.text    = @"";
                cperm.text      = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(comboDB);
    }
}

- (void)viewDidLoad {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"combos.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS COMBOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, combo TEXT, session TEXT. cperm TEXT)";
            
            if (sqlite3_exec(comboDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status.text = @"Failed to create table";
            }
            
            sqlite3_close(comboDB);
            
        } else {
            status.text = @"Failed to open/create database";
        }
    }
    
    [filemgr release];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.name = nil;
    self.combo = nil;
    self.session = nil;
    self.cperm = nil;
    self.status = nil;
}



- (void)dealloc {
    [name release];
    [combo release];
	[cperm release];
    [session release];
	[status release];
    [super dealloc];
}

@end