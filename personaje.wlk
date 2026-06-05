import wollok.game.*
import cultivos.*
import granja.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	var oroTotal = 0
	const property cosechados = [] 

	method sembrar(cultivo){
		granja.sembrarEn(self.position(), cultivo)
	}
	method regar(){
		self.validarParcela()
		granja.hayAlgo(self.position()).regar()
	}
	method reportarEstado(){
		const mensaje = "tengo " + oroTotal + " monedas, y " + self.cantidadCosechada() + " plantas por vender"
		game.say(self, mensaje)
	}
	method venderCosecha() {
		self.validarParcela()
		granja.hayAlgo(self.position()).vender(self)
	}
	method entregarMercaderia(mercado){
    mercado.acreditarCompra(cosechados, self.valorDeLaMochila())
	}
	method recibirPago(ganancias){
		oroTotal = oroTotal + ganancias
		cosechados.clear()
	}
	method cosechar() {
		self.validarParcela()
		granja.hayAlgo(self.position()).cosechar(self)
	}
	method cosecharPlanta(planta){
		cosechados.add(planta)
	}
	method vaciarMochila(){
		cosechados.clear()
	}
	method valorDeLaMochila() = cosechados.sum({planta => planta.precio()})
	method cantidadCosechada() = cosechados.size()
	method colocarAspersor(){
		self.validarParcelaLibre()
		const nuevoAspersor = new Aspersor(position = self.position())
		nuevoAspersor.activar()
		granja.agregarAspersor(nuevoAspersor)
	}
	method validarParcela(){
		if(not granja.parcelaOcupada(self.position())) self.error("no hay nada aca")
	}
	method validarParcelaLibre(){
		if( granja.parcelaOcupada(self.position())) self.error("No se puede colocar aca")
	}
}