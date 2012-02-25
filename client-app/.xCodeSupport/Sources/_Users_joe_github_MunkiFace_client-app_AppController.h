
@interface AppController : NSObject
{
    IBOutlet NSWindow* theWindow;
    IBOutlet NSView* rebuildCatalogsSheet;
}
- (IBAction)rebuildCatalogs:(id)aSender;
- (IBAction)dismissSheet:(id)aSender;
- (IBAction)toolbarButtonClicked:(id)aSender;
@end