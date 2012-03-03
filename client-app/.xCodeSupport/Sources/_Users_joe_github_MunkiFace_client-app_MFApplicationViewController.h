
@interface MFApplicationViewController : NSObject
{
    IBOutlet NSView* sheet;
    IBOutlet NSView* mainView;
    IBOutlet NSOutlineView* mainOutlineView;
    IBOutlet MFManifestsOutlineDataSource* manifestsOutlineDataSource;
    IBOutlet MFPkgsInfoOutlineDataSource* pkgsInfoOutlineDataSource;
}
- (IBAction)dismissSheet:(id)aSender;
@end