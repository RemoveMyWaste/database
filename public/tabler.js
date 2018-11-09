/*
liam beckman
06 may 2018
dom and events
*/


// wait until the DOM before starting buttons
document.addEventListener('DOMContentLoaded', bindButtons);

function bindButtons(){

    let buttonsSubmit = document.getElementsByClassName('submit');

    for (let i = 0; i < buttonsSubmit.length; i++) {
        buttonsSubmit[i].addEventListener('click', function(event){;
            //console.log("adding ev to submit button");
            var req = new XMLHttpRequest();
            event.preventDefault();

            let userName = document.getElementById("name").value;
            //console.log("@@ userName:", userName);

            let userpurpose = document.getElementById("purpose").value;
            //console.log("@@ userpurpose:", userpurpose);
            
            let userurl = document.getElementById("url").value;

            let userversion = document.getElementById("version").value;
            //console.log("@@ userversion:", userversion);

            let userlicense = document.getElementById("license").value;
            //console.log("@@ userlicense:", userlicense);

            //let userretrieved = document.getElementById("retrieved").value;
            //console.log("@@ userretrieved:", userretrieved);
            //console.log('/insert?name=' + userName + "&purpose=" + userpurpose + "&version=" + userversion + "&license=" + userlicense + "&retrieved=" + userretrieved);
            req.open('GET', '/insert?name= ' + userName + "&purpose=" + userpurpose + "&url=" + userurl + "&version=" + userversion + "&license=" + userlicense, true);
            req.onload = function() {
                let res = req.responseText;
                update();
            }

            event.preventDefault();
            req.send(null);

            
        });
    }
}


function update() {
    var req = new XMLHttpRequest();
    req.open('GET', '/update', true);
    req.onload = function() {
        let res = req.responseText;
        console.log("bind response:", res);
        document.getElementById('results').innerHTML = res;
        
        // create table and selection
        let oldTable = document.getElementById("myTable");
        document.querySelector("#table").replaceChild(tabler(), oldTable);
        bindButtons();
        insert();
    }
    req.send(null);
}


function insert() {
    let formPast = document.getElementById("formPast");
    
    if (formPast) {
        formPast.parentNode.removeChild(formPast);
    }

    let formInsert = document.createElement("form");
    formInsert.id="formPast";
    //formInsert.action = "https://liambeckman.com/code/webdev/getpost";
    formInsert.action = "/insert";
    formInsert.method = "get";


    let fieldset = document.createElement("fieldset");
    formInsert.appendChild(fieldset);

    let legend = document.createElement("legend");
    fieldset.appendChild(legend);
    legend.innerHTML = "add new entity";

    let jsonData = document.getElementById("results").innerHTML;
    jsonData = JSON.parse(jsonData);
    console.log("jsonData:", jsonData);

    // generate table
    let table = document.createElement("table");
    table.id = "myTable";
    let tableHead = document.createElement("tr");
    
    // generate header
    //while (headCount <= col) {
    let jsonObject = jsonData[0];
    console.log("jsonObject:", jsonObject);
    for (let n in jsonObject) {
        if (n != "id") {
        let label = document.createElement("label");
        fieldset.appendChild(label);

        let input = document.createElement("input");
        input.size=20;
        input.maxlength=50;
        
        let textSpan = document.createElement("span");
        textSpan.className = "name";
        label.appendChild(textSpan);

        let decSpan = document.createElement("span");
        decSpan.innerHTML = " ⇢ ";
        decSpan.textContent = " ⇢ ";
        label.appendChild(decSpan);

                textSpan.textContent = n;
                input.name = n;

                if (n == "name")
                    input.placeholder="Coolbot";
                else if (n == "purpose")
                    input.placeholder="To be a cool robot.";
                else if (n == "url")
                    input.placeholder="www.coolbot.com";
                else if (n == "version")
                    input.placeholder="0.0.1";
                else if (n == "license")
                    input.placeholder="MIT";
                else if (n == "type")
                    input.placeholder="git";

                input.type="text_input";
                input.id = n;

        console.log("input:", input);
        label.appendChild(input);


                /*
            let tableHeadCell = document.createElement("th");
            tableHeadCell.textContent = n;
            console.log("json data:", jsonObject[n]);
            tableHead.appendChild(tableHeadCell);
            */
        }
    }

    /*
    for (let i = 0; i < 5; i++) {
        let label = document.createElement("label");
        fieldset.appendChild(label);

        let input = document.createElement("input");
        input.size=20;
        input.maxlength=50;
        
        let textSpan = document.createElement("span");
        textSpan.className = "name";
        label.appendChild(textSpan);


        let decSpan = document.createElement("span");
        decSpan.innerHTML = " ⇢ ";
        decSpan.textContent = " ⇢ ";
        label.appendChild(decSpan);

        switch (i) {
            case 0:
                textSpan.textContent = "name";
                input.name="name";
                input.placeholder="Coolbot";
                input.type="text_input";
                input.id = "name"
                break;

            case 1:
                textSpan.textContent = "purpose";
                input.name="purpose";
                input.placeholder="To be cool.";
                input.type="text_input";
                input.id = "purpose"
                break;

            case 2:
                textSpan.textContent = "url";
                input.name="url";
                input.placeholder="www.coolbot.com";
                input.type="text_input";
                input.id = "url"
                break;

            case 3:
                textSpan.textContent = "version";
                input.name="version";
                input.placeholder="0.0.1";
                input.type="text_input";
                input.id = "version"
                break;

            case 4:
                textSpan.textContent = "license";
                input.name="license";
                input.placeholder="MIT";
                input.type="text_input";
                input.id = "license"
                break;
        }

        console.log("input:", input);
        label.appendChild(input);
        */

        

    //}
        document.getElementById("add").appendChild(formInsert);

        let names = document.getElementsByClassName("name");
        let maxWidth = 0;

        for (let i = 0; i < names.length; i++) {
            console.log("names: " + names[i].offsetWidth);
            if (names[i].offsetWidth > maxWidth) {
                maxWidth = names[i].offsetWidth;
            }
        }

        for (let i = 0; i < names.length; i++) {
            names[i].style.width = maxWidth + "px";
        }


    let submit = document.createElement("input");
    submit.className = "submit";
    submit.value = "Submit";
    submit.type = "submit";
    submit.action = "/insert";
    fieldset.appendChild(submit);
    bindButtons();

    
}



// create table with given number of rows and columns
function tabler() {
    let fields = "Header";
    let headCount = 1;

    let jsonData = document.getElementById("results").innerHTML;
    jsonData = JSON.parse(jsonData);
    console.log("jsonData:", jsonData);

    // generate table
    let table = document.createElement("table");
    table.id = "myTable";
    let tableHead = document.createElement("tr");
    
    // generate header
    //while (headCount <= col) {
    let jsonObject = jsonData[0];
    console.log("jsonObject:", jsonObject);
    for (let n in jsonObject) {
        if (n != "id") {
            let tableHeadCell = document.createElement("th");
            tableHeadCell.textContent = n;
            console.log("json data:", jsonObject[n]);
            tableHead.appendChild(tableHeadCell);
        }
    }

    // append table
    table.appendChild(tableHead);
    table.style.borderSpacing = "0em";

    // use the returned JSON data to construct the rows in the table
    rows(jsonData, table);

    return table;
}


// create the rows in the table
function rows(jsonData, table)
{
    let rowCount = 1;
    let colCount = 1;

    // create rows
    for (let i = 0; i < jsonData.length; i++) {
        let tableRow = document.createElement("tr");
        //tableRow.style.backgroundColor = "lavender";

        // create cells in rows
        let jsonObject = jsonData[i];
        console.log("jsonObject:", jsonObject);
        for (let n in jsonObject) {

            if (n != "id") {
                let cell = document.createElement("td");
                cell.textContent = jsonObject[n];
                tableRow.appendChild(cell);
                colCount += 1;
            }
        }

        // add row to table
        table.appendChild(tableRow);

        // cell to hold edit and delte buttons
        let cell = document.createElement("td");

        tableRow.appendChild(cell);

        // edit form and button
        let formEdit = document.createElement("form");
        //formEdit.action = "/safe-update";
        formEdit.action = "/edit";
        formEdit.method = "get";
        cell.appendChild(formEdit);

        let buttonEdit = document.createElement("input");
        buttonEdit.value = "Edit";
        buttonEdit.type = "submit";
        buttonEdit.className = "buttonEdit";
        formEdit.appendChild(buttonEdit);


        // delete form and button
        let formDelete = document.createElement("form");
        formDelete.action = "/delete";
        formDelete.method = "get";
        cell.appendChild(formDelete);

        let buttonDelete = document.createElement("input");
        buttonDelete.value = "Delete";
        buttonDelete.type = "submit";
        buttonDelete.className = "buttonDelete";
        formDelete.appendChild(buttonDelete);



        // hidden row id
        let buttonHidden = document.createElement("input");
        buttonHidden.name = "id";
        buttonHidden.value = jsonObject.id;
        console.log("jsonObject.id:", jsonObject.id);
        buttonHidden.type = "hidden";
        buttonHidden.className = "hidden";
        
        // add hidden row id to buttons
        formDelete.appendChild(buttonHidden);
        formEdit.appendChild(buttonHidden.cloneNode(true));

        buttonDelete.addEventListener('click', function(event){;
            console.log("adding ev to delete button");
            event.preventDefault();
            var req = new XMLHttpRequest();

            console.log("/delete?id=" + buttonHidden.value);
            req.open('GET', '/delete?id=' + buttonHidden.value, true);

            req.onload = function() {
                let res = req.responseText;
                update();
            }

            req.send(null);
        });
    };
}


// create table and selection
let table = document.querySelector("#table")
table.appendChild(tabler());


insert();
