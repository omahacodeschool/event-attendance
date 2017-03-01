window.addEventListener("load", function (){

	var ourRequest = new XMLHttpRequest();
	ourRequest.open('GET', "/eventlist", true);
	ourRequest.onload = addEvents;
	ourRequest.send();

	function addEvents(event) {
		var result = event.target.responseText;
		data = JSON.parse(result);
		createHTML(data);		
	}

	function createHTML(data){
		htmlToInsert = "";
		for (var i=0;i<data.length;i++) {
			time = data[i]['time'];
			groupName = data[i]['group'];
			eventName = data[i]['title'];
			htmlToInsert += "<p>"+time;
			htmlToInsert += " - " + groupName;
			htmlToInsert += " <a href='#'>"+eventName+"</a></p>";
		}
		// document.getElementsByTagName("body")[0].innerHTML = htmlToInsert;
	}
});





