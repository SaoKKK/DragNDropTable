//
//  AppDelegate.h
//  DragNDropTable
//
//  Created by 河野 さおり on 2016/02/08.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (readwrite,nonatomic) NSMutableArray* tableData;

@end

