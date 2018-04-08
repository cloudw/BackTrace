# BackTrace
An iOS application that makes diary keeping very easy will be built. The fundamental diary keeping requires interface for conveniently adding and retrieving user-friendly records. The app supplies extra location data and data management.

The user of this app should expect the following sequentially:
1. The app automatically collects user’s location every unit of time (configurable by user)
    + User should be allowed to manually add location record at will
    + User should be allowed to remove any location record (non-recoverable)
    + User should be allowed to set time range when this function is active every day
    + The functionality detect wether user allows app to use location info, and react accordingly

2. Dairy Keeping
    + A Google map with location records pin-pointed should be displayed to help user recall what happened at the time
    + At any time after the location record is made, user should be able to associate it with photos and text informations. Specifically:
      + One photo per record allowed. Multiple photos would be nice but is not required for project.
      + No format required for text info. Ideally user should be allowed to add text of arbitrary length. 
        + (Only if time allowed) specialized fields for text info, such as attendants, weather etc. This is not a priority feature because user can still record these as text, at cost of harder info retrieval.
    + One summary of the day in text allowed

3. Display of Record
    + Summary of the day
      + Text summary record
      + Google map with routes constructed from location records
    + Each record that has text or photo displayed sequentially

4. Map overlay
    + Display routes of different days on a single map.
    + Display a list of days whose routes are drawn on map
      + Selecting a day from list results in highlight for its route (i.e. color differentiation)
        + A potential difficulty is when google cannot calculate a route between some specific locations. In worst case dots are connected with line segments, so that app at least works when locations are close enough.
      + User can “dive in” for the day, reviewing record of that day as designed in (3) above
