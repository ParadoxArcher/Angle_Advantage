###### A prerequisite of [[_boost]] that tapers the release value of #MoveInputY 
- Pass in #MoveInputY from [[_boost]]
- Create a script-wide variable #BoostStorage 
- Determine if we are increasing or decreasing #BoostStorage by checking:
	- `if` a predetermined #StorageReleaseScaler divided from #MoveInputY is `>=` #BoostStorage 
		- `if` `true`; 
- 