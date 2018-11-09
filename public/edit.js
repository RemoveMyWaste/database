/*
liam beckman
06 may 2018
dom and events
*/


// wait until the DOM before starting buttons
document.addEventListener('DOMContentLoaded', bindButtons);

function bindButtons(){
    let hiddens = document.getElementsByClassName('hidden');
    let buttonsDelete = document.getElementsByClassName('buttonDelete');
console.log("delete buttons:", buttonsDelete);

    for (let i = 0; i < buttonsDelete.length; i++) {
        buttonsDelete[i].addEventListener('click', function(event){;
            event.preventDefault();
            var req = new XMLHttpRequest();

            req.open('GET', '/delete?id=' + hiddens[i].value, true);
            req.onload = function() {
                let res = req.responseText;
                update();
            }

            req.send(null);
        });
    }
}



function edit(id, name, purpose, url, version, license) {
    let formEdit = document.createElement("form");
    let results = document.getElementById("results")
    let add = document.getElementById("add")
    
    if (formOld) {
        formOld.parentNode.removeChild(formOld);
    }
    
    formEdit.id = "formOld";
    formEdit.action = "/safe-update";
    formEdit.method = "get";

    add.appendChild(formEdit);

    let fieldset = document.createElement("fieldset");
    formEdit.appendChild(fieldset);

    let legend = document.createElement("legend");
    fieldset.appendChild(legend);
    legend.innerHTML = "edit";

    let jsonData = document.getElementById("results").innerHTML;
    jsonData = JSON.parse(jsonData);
    console.log("jsonData:", jsonData);

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
                    input.value = name;
                else if (n == "purpose")
                    input.value = purpose;
                else if (n == "url")
                    input.value = url;
                else if (n == "version")
                    input.value = version;
                else if (n == "license")
                    input.value = license;
                else if (n == "type")
                    input.value = type;

                input.type="text_input";
                input.id = n;

        console.log("input:", input);
        label.appendChild(input);


        }
    }

    // hidden row id
    let buttonHidden = document.createElement("input");
    buttonHidden.name = "id";
    buttonHidden.value = id;
    buttonHidden.type = "hidden";
    buttonHidden.className = "hidden";

    // add hidden row id to buttons
    fieldset.appendChild(buttonHidden);

    let formData = document.getElementById("formOld");
    let data = new FormData(formData);
    let submit = document.createElement("input");
    submit.className = "submit";
    submit.value = "Submit";
    submit.type = "submit";
    submit.id = "submit";
    submit.action = "/safe-update";
    fieldset.appendChild(submit);

    submit.addEventListener('click', function(event){;
        let userName = document.getElementById("name").value;
        let userpurpose = document.getElementById("purpose").value;
        let userurl = document.getElementById("url").value;
        let userversion = document.getElementById("version").value;
        let userlicense = document.getElementById("license").value;

        event.preventDefault();
        var req = new XMLHttpRequest();

        req.open('GET', '/safe-update?id=' + buttonHidden.value + "&name=" + userName + "&purpose=" + userpurpose + "&url=" + userurl + "&userversion=" + userversion + "&license=" + userlicense, true);

        req.onload = function() {
            let res = req.responseText;
            window.location.href = '/program';
        }

        req.send(null);
    });

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
    for (let n in jsonObject) {
        if (n != "id") {
            let tableHeadCell = document.createElement("th");
            tableHeadCell.textContent = n;
            tableHead.appendChild(tableHeadCell);
        }
    }


    // append table
    table.appendChild(tableHead);
    table.style.borderSpacing = "0em";

    rows(jsonData, table);

    return table;
}


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

    };
}


// create table and selection
let table = document.querySelector("#table")
table.appendChild(tabler());

let formOld = document.createElement("form");
formOld.id = "formOld";
table.appendChild(formOld);

let results = document.getElementById("results")
let editRow = JSON.parse(results.innerHTML);
for (let i = 0; i < editRow.length; i++)
{
    for (let n in editRow[i])
    {
        if (n == "id") {
            var id = editRow[i][n];
        }
        if (n == "name") {
            var name = editRow[i][n];
        }
        else if (n == "purpose") {
            var purpose = editRow[i][n];
        }
        else if (n == "url") {
            var url = editRow[i][n];
        }
        else if (n == "version") {
            var version = editRow[i][n];
        }
        else if (n == "license") {
            var license = editRow[i][n];
        }
    }
}

edit(id, name, purpose, url, version, license);
