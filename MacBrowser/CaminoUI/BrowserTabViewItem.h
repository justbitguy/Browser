/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Simon Fraser <sfraser@netscape.com>
 *   Stuart Morgan <stuart.morgan@alumni.case.edu>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

#import <Cocoa/Cocoa.h>

// sent when the current tab will changed. The object is the tab that's being
// switched to. NSTabView does have a delegate method when the tab changes,
// but no notification and we don't want to take over the delegate for internal
// implementation.
extern NSString* const kTabWillChangeNotification;

// A subclass of NSTabViewItem that manages the custom Camino tabs.
@class TabButtonView;
@class TruncatingTextAndImageCell;

@interface BrowserTabViewItem : NSTabViewItem
{
  NSImage*                     mTabIcon;           // STRONG ref
  TabButtonView*               mTabButtonView;     // STRONG ref
  NSMenuItem*                  mMenuItem;          // STRONG ref
  BOOL                         mDraggable;
  int                          mTag;
}

- (NSImage *)tabIcon;
- (void)setTabIcon:(NSImage *)newIcon isDraggable:(BOOL)draggable;

- (BOOL)draggable;

- (TabButtonView*)buttonView;
- (int)tag;
// Note that this method may confirm the tab close (e.g., in the case of an
// onunload handler), and thus may not actually result in the tab being closed.
- (void)closeTab:(id)sender;

// call to start and stop the progress animation on this tab
- (void)startLoadAnimation;
- (void)stopLoadAnimation;

// call before removing to clean up close button and progress spinner
- (void)willBeRemoved;

- (NSMenuItem *)menuItem;
- (void) willDeselect;
- (void) willSelect;
- (void) selectTab:(id)sender;

+ (NSImage*)closeIcon;
+ (NSImage*)closeIconPressed;
+ (NSImage*)closeIconHover;

// Returns YES if |sender| is a valid drag for a tab, NO if not.
- (BOOL)shouldAcceptDrag:(id <NSDraggingInfo>)dragInfo;
// Handle drag and drop of one or more URLs; returns YES if the drop was valid.
- (BOOL)handleDrop:(id <NSDraggingInfo>)dragInfo;

@end
