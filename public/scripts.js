indow.addEventListener("load", function (){

	var ourRequest = new XMLHttpRequest();
	ourRequest.open('GET', "/eventlist", true);
	ourRequest.onload = function() {
		var result = ourRequest.responseText;
		onloadfunction(result);
		}
	}
	ourRequest.send();

	function onloadfunction(result) {
		data = JSON.parse(result);
		
		createHTML(data);
		
	}

	function createHTML(data){
		htmlToInsert = "<h1>People Information List</h1>";
		for (var i=0;i<data.length;i++) {
			htmlToInsert += "<div><h3>Person #" + parseInt(i + 1) + "</h3>";
			htmlToInsert += "<p>First name: " + data[i]["fname"] + "</p>";
			htmlToInsert += "<p>Last name: " + data[i]["lname"] + "</p>";

			htmlToInsert += "<p>Address: " + data[i]["address"] + "</p>";
			htmlToInsert += "<p>           " + data[i]["city"] + ", " + data[i]["state"]

			htmlToInsert += " " + data[i]["zip"] + "</p>";
			htmlToInsert += "<p>Telephone number: " + data[i]["tel"] + "</p></div>";
		}
	}

});
