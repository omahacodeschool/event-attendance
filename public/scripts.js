window.addEventListener("load", function (){
	var ourRequest = new XMLHttpRequest();
	ourRequest.open('GET', "/eventlist", true);
	ourRequest.onload = addEvents;
	ourRequest.send();

	function addEvents(event) {
		var result = event.target.responseText;
		data = JSON.parse(result);
		createHTML(data);		
	};

	function createHTML(data){
		htmlToInsert = "";
		weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
		createHTMLForEachWeekday(data);
		document.getElementsByClassName("events")[0].insertAdjacentHTML('beforeend',htmlToInsert);
	}

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


});
