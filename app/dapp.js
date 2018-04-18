/**
 * Created by ramiro on 11/04/18.
 */
import $ from 'jquery';
import pintarCasa from 'Embark/contracts/pintarCasa';
import fabricPainter from 'Embark/contracts/fabricPainter';
import EmbarkJS from 'Embark/EmbarkJS';
//0xfbaf82a227dcebd2f9334496658801f63299ba24
var arrayPintores = [];
// var toDeploy = new web3.eth.Contract( pintarCasa.options.jsonInterface, function(err, value){
//     debugger;
//     console.log(err)
//     console.log(value)
// });
var defaultPintor = {};
function loadPinter(){
  var printerContent = $(".pinterContent");
  console.log("defaultPintor", defaultPintor);


}

function instantiatePintor(address, price, day, Time){
    var a = $(".cuatro");
    var resultado = fabricPainter.methods.createPainter(address, day,Time).call({from:web3.eth.defaultAccount, value:price, gas:800000}).then(function(value, res){
        if(value){
            console.log("value", value)
            arrayPintores.push(value);
            var defaultPintor = new web3.eth.Contract(pintarCasa.options.jsonInterface, value);
            defaultPintor.methods.getPinterInfo().call().then(function(val){
                console.log(val);
                debugger;
                return true;
            })
        }
    })
}

$(document).ready(function() {
    $(".instantiate-contract").click(function() {
        var address = $("#address").val();
        var price = $("#price").val();
        var day = $("#day").val();
        var Time = $("#Time").val();
        instantiatePintor(address, price, day, Time);
    })
});