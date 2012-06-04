
@interface MFApplicationViewController : NSObject
{
    IBOutlet NSView* sheet;
    IBOutlet NSView* mainView;
    IBOutlet NSOutlineView* mainOutlineView;
    IBOutlet MFOutlineDataSource* outlineDataSource;
}
- (IBAction)dismissSheet:(id)aSender;
@end