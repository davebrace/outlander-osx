//
//  TextViewController.m
//  Outlander
//
//  Created by Joseph McBride on 1/27/14.
//  Copyright (c) 2014 Joe McBride. All rights reserved.
//

#import "TextViewController.h"
#import "NSString+Categories.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (id)init {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
	if(self == nil) return nil;
    return self;
}

- (NSString *)text {
    return _TextView.string;
}

- (BOOL)endsWith:(NSString*)value {
    NSString *trimmed = [_TextView.string trimNewLine];
    NSString *val = [[trimmed substringFromIndex:trimmed.length - 2] trimNewLine];
    return [val isEqualToString:value];
}

- (void)clear {
    [_TextView setString:@""];
}

- (void)append:(TextTag *)text {
    [self append:text toTextView:_TextView];
}

- (void)append:(TextTag*)text toTextView:(NSTextView *) textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSScroller *scroller = [[textView enclosingScrollView] verticalScroller];
        BOOL shouldScrollToBottom = [scroller doubleValue] == 1.0;
        
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:[text text]];
        NSRange range = [[attr string] rangeOfString:text.text];
        
        NSColor *color = nil;
        
        if(text.color != nil && [text.color length] > 0){
            color = [NSColor colorWithHexString:text.color];
        }
        else {
            color = [NSColor colorWithHexString:@"#cccccc"];
        }
        
        [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
        NSString *fontName = @"Verdana";
        int fontSize = 12;
        if(text.mono){
            fontName = @"Courier New";
            fontSize = 13;
        }
        [attr addAttribute:NSFontAttributeName value:[NSFont fontWithName:fontName size:fontSize] range:range];
        [[textView textStorage] appendAttributedString:attr];
        
        if(shouldScrollToBottom) {
            [textView scrollRangeToVisible:NSMakeRange([[textView string] length], 0)];
        }
    });
}

@end
