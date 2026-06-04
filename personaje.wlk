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
		const plantaAca = granja.plantaEn(self.position())
		if(plantaAca==null){
			self.error("No hay ninguna planta aca para regar")
		}
		plantaAca.regar()
	}
	method reportarEstado(){
		const mensaje = "tengo " + oroTotal + " monedas, y " + self.cantidadCosechada() + " plantas por vender"
		game.say(self, mensaje)
	}
	method venderCosecha() {
	  const mercadoActual = granja.hayMercadoAca(self.position())
	  const ganancias = self.valorDeLaMochila()
	  self.validarVenta(mercadoActual,ganancias)
	  self.realizarVenta(mercadoActual)
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
	method realizarVenta(mercado) {
		const ganancias = self.valorDeLaMochila()
		mercado.acreditarCompra(cosechados, ganancias)
		oroTotal = oroTotal + ganancias
		self.vaciarMochila()
	}
	method cosechar() {
	  const plantaACosechar = granja.plantaEn(self.position())
	  if (plantaACosechar == null){
		self.error("no hay nada para cosechar")
	  }
	  if (not plantaACosechar.esCosechable()){
		self.error("Todavia no es cosechable")
	  }
	  granja.extraerCultivo(plantaACosechar)
	  self.cosecharPlanta(plantaACosechar)
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
		if(granja.parcelaOcupada(self.position())){
			self.error("No se puede colocar un aspersor aca")
		}
		const nuevoAspersor = new Aspersor(position = self.position())
		nuevoAspersor.activar()
		granja.registrarAspersor(nuevoAspersor)
	}
}