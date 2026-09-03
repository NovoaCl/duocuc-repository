

const table = new DataTable('#myTable');

function checkear_formulario(){
    var formulario = document.getElementsByClassName('formulario')

    //console.log(formulario)
    
    for (form in formulario){
        //console.log(form)
        if(formulario[form].value == ''){
            console.log(formulario[form].id)
        }
    }
}