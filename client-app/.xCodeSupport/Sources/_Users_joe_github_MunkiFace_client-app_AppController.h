
@interface AppController : NSObject
{
    IBOutlet MFApplicationViewController* appViewController;
    IBOutlet NSWindow* theWindow;
}
- (IBAction)rebuildCatalogs:(id)aSender;
- (IBAction)dismissSheet:(id)aSender;
- (IBAction)toolbarButtonClicked:(id)aSender;
@end