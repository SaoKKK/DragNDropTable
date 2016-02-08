//
//  TableController.m
//  DragNDropTable
//
//  Created by 河野 さおり on 2016/02/08.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import "TableController.h"
#import "AppDelegate.h"

#define MyTVDragNDropPboardType @"MyTVDragNDropPboardType"

@implementation TableController

- (void)awakeFromNib{
    [_tableview registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,MyTVDragNDropPboardType,nil]];
    //他アプリケーションからのドラッグアンドドロップを許可
    [_tableview setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
}

#pragma mark - Table data controll

- (IBAction)btnAdd:(id)sender {
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:appD.tableData.count + 1],@"id",@"New Student",@"name",@"9h",@"class",nil];
    [appD.tableData addObject:data];
    [_tableview reloadData];
    [_tableview editColumn:1 row:appD.tableData.count-1 withEvent:nil select:YES];
}

- (IBAction)btnRemove:(id)sender {
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    NSIndexSet *indexes = [_tableview selectedRowIndexes];
    [appD.tableData removeObjectsAtIndexes:indexes];
    [_tableview reloadData];
    [btnRemove setEnabled:NO];
}

//行の選択状態の変更
- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    if ([[_tableview selectedRowIndexes]count] != 0) {
        [btnRemove setEnabled:YES];
    } else {
        [btnRemove setEnabled:NO];
    }
}

#pragma mark - NSTableView data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    return appD.tableData.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    NSString *identifier = tableColumn.identifier;
    NSDictionary *data = [appD.tableData objectAtIndex:row];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    cellView.objectValue = [data objectForKey:identifier];
    return cellView;
}

//ユーザによる更新の受付
- (IBAction)comboClass:(id)sender {
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    if ([sender indexOfSelectedItem] == 0 || [sender indexOfSelectedItem] == 1) {
        [sender setStringValue:[sender objectValueOfSelectedItem]];
        [appD.window makeFirstResponder:nil];
        [sender setEditable:NO];
    } else if ([sender indexOfSelectedItem] == 2){
        [sender setStringValue:@""];
        [sender setEditable:YES];
        [appD.window makeFirstResponder:sender];
    }
    NSInteger row = [_tableview rowForView:sender];
    NSDictionary *data = [appD.tableData objectAtIndex:row];
    [data setValue:[sender stringValue] forKey:@"class"];
    [appD.tableData replaceObjectAtIndex:row withObject:data];
}

- (IBAction)txtName:(id)sender {
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    NSInteger row = [_tableview rowForView:sender];
    NSDictionary *data = [appD.tableData objectAtIndex:row];
    NSString *name = [sender stringValue];
    [data setValue:name forKey:@"name"];
    [appD.tableData replaceObjectAtIndex:row withObject:data];
}

#pragma mark - Drag Operation Method

//ドラッグを開始（ペーストボードに書き込む）
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    dragRows = rowIndexes;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:MyTVDragNDropPboardType] owner:self];
    [pboard setData:data forType:MyTVDragNDropPboardType];
    return YES;
}

//ドロップを確認
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    //間へのドロップのみ認証
    [tv setDropRow:row dropOperation:NSTableViewDropAbove];
    if ([info draggingSource] == tv) {
        return NSDragOperationMove;
    }
    return NSDragOperationEvery;
}

//ドロップ受付開始
- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op {
    AppDelegate *appD = (AppDelegate*)[[NSApplication sharedApplication]delegate];
    if (dragRows) {
        //テーブルのコンテンツの移動
        NSUInteger index = [dragRows firstIndex];
        while(index != NSNotFound) {
            //ドロップ先にドラッグ元のオブジェクトを挿入する
            if (row > appD.tableData.count) {
                [appD.tableData addObject:[appD.tableData objectAtIndex:index]];
            }else{
                [appD.tableData insertObject:[appD.tableData objectAtIndex:index] atIndex:row];
            }
            //ドラッグ元のオブジェクトを削除する
            if (index > row) {
                //indexを後ろにずらす
                [appD.tableData removeObjectAtIndex:index + 1];
            }else{
                [appD.tableData removeObjectAtIndex:index];
            }
            index = [dragRows indexGreaterThanIndex:index];
            row ++;
            dragRows = nil;
        }
    } else {
        //ファインダからのドロップオブジェクトからPDFリストを作成
        NSPasteboard *pasteboard = [info draggingPasteboard];
        NSArray *dropDataList = [pasteboard propertyListForType:NSFilenamesPboardType];
        for (id path in dropDataList) {
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setObject:[NSNumber numberWithInteger:appD.tableData.count + 1]  forKey:@"id"];
            [data setObject:[path lastPathComponent] forKey:@"name"];
            [data setObject:@"9h" forKey:@"class"];
            [appD.tableData insertObject:data atIndex:row];
        }
    }
    [tv reloadData];
    return YES;
}

@end
