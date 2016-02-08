//
//  AppDelegate.m
//  DragNDropTable
//
//  Created by 河野 さおり on 2016/02/08.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize tableData;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (id)init{
    self = [super init];
    if (self) {
        //テーブル表示データ初期化
        tableData = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"myArray" ofType:@"array"]];
    }
    return self;
}

@end
