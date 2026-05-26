import wollok.game.*
import cultivos.*
import granja.*

object personaje {
	var property position = game.center()
	const property image = "fplayer.png"
	var oroTotal = 0

	method sembrarMaiz(){
		granja.sembrarMaiz(self.position())
	}
	method sembrarTrigo() {
		granja.sembrarTrigo(self.position())
	}
	method sembrarTomaco(){
		granja.sembrarTomaco(self.position())
	}
	method regar(){
		granja.regarPlantaEn(self.position())
	}
	method reportarEstado(){
		const mensaje = "tengo " + oroTotal + " monedas, y " + granja.cantidadAVender() + " plantas por vender"
		game.say(self, mensaje)
	}
	method colocarAspersor(){
		if(granja.parcelaOcupada(self.position())){
			self.error("No se puede colocar un aspersor")
		}
		const nuevoAspersor = new Aspersor(position= self.position())
		granja.agregarAspersor(nuevoAspersor)
		nuevoAspersor.activar()
	}
	method venderCosecha() {
	  const mercadoActual = granja.hayMercadoAca(self.position())
	  const ganancias = granja.valorVentaCosechados()
	  self.validarVenta(mercadoActual,ganancias)
	  self.realizarVenta(mercadoActual,ganancias)
	}
	method validarVenta(mercado,ganancias) {
	  if (mercado==null){
		self.error("no estas en un mercado")
	  }
	  if(ganancias==0){
		self.error("No tenes cosecha para vender")
	  }
	  if(not mercado.tieneDineroSuficiente(ganancias)){
		self.error("el mercado no tiene dinero para pagarte")
	  }
	}
	method realizarVenta(mercado,ganancias) {
	  oroTotal = oroTotal + ganancias
	  mercado.comprarCosecha(granja.cosechados(), ganancias)
	  granja.vaciarCosechados()
	}
}