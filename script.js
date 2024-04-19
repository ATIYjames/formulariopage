let usuarios = []; 

function agregarUsuario(event) {
    event.preventDefault(); // evita que no se envie al iniciar
    //constantes por id 
    const nombreInput = document.getElementById('nombre');
    const apellidoInput = document.getElementById('apellido');
    const generoInput = document.querySelector('input[name="genero"]:checked');
    const emailInput = document.getElementById('email');
    const poblacionInput = document.getElementById('poblacion');
    const descripcionInput = document.getElementById('descripcion');
    const op1Input = document.getElementById('op1');
    const op2Input = document.getElementById('op2');
    usuarios.push({ // al final del arreglo
        nombre: nombreInput.value.trim(),
        apellido: apellidoInput.value.trim(),
        genero: generoInput ? generoInput.value : '',
        email: emailInput.value.trim(),
        poblacion: poblacionInput.value,
        descripcion: descripcionInput.value.trim(),
        op1: op1Input.checked,
        op2: op2Input.checked
    });
    mostrarUsuarios();  
    // vaciar el formulario cada q se envia
    nombreInput.value = '';
    apellidoInput.value = '';
    generoInput.checked = false;
    emailInput.value = '';
    poblacionInput.value = 'comas'; 
    descripcionInput.value = '';
    op1Input.checked = true; 
    op2Input.checked = false; 
}
function mostrarUsuarios() {
    const usuariosParrafo = document.getElementById('usuariosParrafo');
    usuariosParrafo.innerHTML = ''; // limbpia el parrafo
    usuarios.forEach(usuario => { // busca en el arreglo
        const p = document.createElement('p');
        p.innerHTML = // innerhtml para usar la funcion de saltar linea del html :D
        `<b>Nombre:</b> ${usuario.nombre} ${usuario.apellido}<br> 
        <b>Género:</b> ${usuario.genero}<br>
        <b>Email:</b> ${usuario.email}<br>
        <b>Población:</b> ${usuario.poblacion}<br>
        <b>Descripción:</b> ${usuario.descripcion}`;
        usuariosParrafo.appendChild(p);
    });
}
function eliminarUltimoUsuario() {
    if (usuarios.length > 0) {
        usuarios.pop(); // ELIMINA EL ultimo de la lista en el arreglo
        mostrarUsuarios(); 
    } else {
        alert('No hay usuarios para eliminar.');
    }
}