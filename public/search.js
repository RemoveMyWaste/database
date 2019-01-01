// wait until the DOM before starting buttons
document.addEventListener('DOMContentLoaded', bindButtons);

function bindButtons() {

    let clear = document.getElementById('clear');
    clear.onclick = function() {
        mySearch.value = ""; 
        update();
    }

    let mySearch = document.getElementById('my-search');
    mySearch.addEventListener("keyup", update); 

    function update() {
        let query = mySearch.value;
        console.log(query);
        let selects = document.getElementsByClassName('select');
        for (let i = 0; i < selects.length; i++) {
            console.log(selects[i].innerHTML);
            if (selects[i].innerHTML.toLowerCase().includes(query.toLowerCase())) {
                selects[i].style.display = "block";
            }
            else {
                selects[i].style.display = "none";
            }
        }
    }
}


