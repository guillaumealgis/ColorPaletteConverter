//
//  GAWindowController.h
//  ColorPaletteConverter
//
//  Created by Guillaume Algis on 02/05/2014.
//  Copyright (c) 2014 Guillaume Algis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GAWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *saveAsNameTextField;
@property (strong) NSString *saveAsName;

@end
