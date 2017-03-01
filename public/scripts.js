window.addEventListener("load", function (){

	function bodyHasClass(className){
		body = document.getElementsByTagName("body")[0];
		return body.classList.contains(className);
	};

	if (bodyHasClass("index_page")){ 

		var ourRequest = new XMLHttpRequest();
		ourRequest.open('GET', "/eventlist", true);
		ourRequest.onload = addEvents;
		ourRequest.send();

		// Add all events to the homepage.
		// event - get request for events.
		// Adds the html to index for list of the week of events.
		function addEvents(event) {
			var result = event.target.responseText;
			data = JSON.parse(result);
			createHTML(data);		
		};

		// Creates html for events for the week and add to index.erb.
		// data - json data as a hash organized as weekday -> array of events.
		// html added to index.erb.
		function createHTML(data){
			htmlToInsert = "";
			weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
			createHTMLForEachWeekday(data);
			document.getElementsByClassName("events")[0].insertAdjacentHTML('beforeend',htmlToInsert);
		}

		// Creates html for events by each weekday.
		// data - json data as a hash organized as weekday -> array of events.
		// html created as a string for all weekdays.
		function createHTMLForEachWeekday(data) {
			for (var i=0;i<weekdays.length;i++) {
				if (data[weekdays[i]]){
					htmlToInsert += "<div class='event-item'>";
					htmlToInsert += "<h2>" + weekdays[i] + "</h2><ul>";
					createHTMLForEachEvent(data[weekdays[i]])
					htmlToInsert += "</ul></div>";
				}
			}
		}

		// Creates html for events for a single weekday.
		// daysEvents - an array of events for a single weekday.
		// html created as a string for one weekday.
		function createHTMLForEachEvent(daysEvents) {
			for (var j=0; j<daysEvents.length;j++) {
				htmlToInsert += "<li>";
				htmlToInsert += daysEvents[j]["time"] + " - ";
				htmlToInsert += daysEvents[j]["group"] + " - ";
				htmlToInsert += "<a href='/event?id=" + daysEvents[j]["id"] + "'>"
				htmlToInsert += daysEvents[j]["title"]
				htmlToInsert += "</a></li>";
			}
		}
	};

	if (bodyHasClass("event_page")){

		rsvpButton = document.getElementsByClassName("reservations")[0].children[1];
		submit = document.getElementsByName("Submit")[0];

		rsvpButton.addEventListener("click", showModal);
		submit.addEventListener("click", sendReservation);

		function showModal(){
			modalWindow = document.getElementsByClassName("modal")[0];
			modalWindow.style.display = "block";
		};

		function sendReservation(e){
			e.preventDefault();
			// Get form field name
			findName()
			// Get event id | returns as a string ie "10000"
			findEventId()
		};

		function findName(){
			return document.getElementsByName("newAttendeeName")[0];
		}


		function findEventId(){
			params = window.location.search
			return parseParams(params)["id"];
		};

		function parseParams(parameters){
			parameters = parameters.replace("?","");
			peices = parameters.split("&");
			hash = {};
			for (i = 0; i < peices.length; i++){
				hash[peices[i].split("=")[0]] = peices[i].split("=")[1];
			}
			return hash;
		};



	};



});





