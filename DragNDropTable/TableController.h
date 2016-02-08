//
//  TableController.h
//  DragNDropTable
//
//  Created by 河野 さおり on 2016/02/08.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TableController : NSObjectController <NSTableViewDelegate,NSTableViewDataSource>{
    @private
    IBOutlet NSTableView *_tableview;
    IBOutlet NSButton *btnRemove;
    NSIndexSet *dragRows; //ドラッグ中の行インデクスを保持
}

@end
