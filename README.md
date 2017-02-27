# Event Attendance

Students and alumni can access this application to indicate that they are attending a particular event. The application will display upcoming events, and users can see who else is attending each event.

This app will replace the weekly 'events briefs' that are prepared by instructors.

## Tech Stack

The site is built in Sinatra and stores data in a CSV file.

## Stories

1. Susie should be able to go to the homepage and the events for the current week will be displayed. The current week will be the title and the events will be organized by weekday and then time, begins on Monday. 
2. Each event will link to an event page. Susie can click on the link of the event that interests her. This takes her to a new view that displays the event information: event name, group name, date of event, time of event, event location, link to original/meetup page.
3. Additionally, there is a list of all attendees, which are all the other people that have already rsvped. 
4. Lastly there is a form in which Susie can add her name to RSVP. Susie will type her name into the text input box hit submit and her name will be added to the attendee list.
5. Alex will be able to login as the admin. 
6. Then the main page will show an additional form field, an input for each piece of the event information (event name, group name, date of event, time of event, event location, link to original/meetup page). After inputting information into each text field, Alex hits submit. This adds a new event to the events csv file and if the event happens in the week displayed, it adds it to the current display.
7. Wilbur wants to RSVP to a second event held next week. He should be able to navigate to the homepage and click on a next week button. Then the events will be displayed for the next week. If there are no events for the week, display no events scheduled message. 
8. When he goes to RSVP he will have already rsvp to an event, so his name will be remembered and he can just simply rsvp without inputting his name.



