import wollok.game.*
import granja.*

class Aspersor {
	var property position

	method image() ="aspersor.png"  

	method activar() {
		game.onTick(1000, "aspersor_riega_" + self.identity().toString(), { self.regarAlrededor() })
	}
	method regarAlrededor(){
		const vecinos = game.colliders(self)
		vecinos.forEach({vecino => vecino.regar()})
	}
}
class Trigo {
	var property position 
	var etapa = trigoRecienSembrado
	method image() = etapa.image()
	method regar(){
		etapa = etapa.siguienteEtapa()
	}
	method esCosechable() = etapa.esCosechable()
	method precio() = etapa.precio()
}
object trigoRecienSembrado {
	method image() = "wheat_0.png"
	method esCosechable() = false
	method precio() = 0
	method siguienteEtapa() = trigoCreciendo   
}
object trigoCreciendo {
	method image() = "wheat_1.png"
	method esCosechable() = false
	method precio() = 0
	method siguienteEtapa() = trigoMaduro
}
object trigoMaduro {
	method image() = "wheat_2.png"
	method esCosechable() = false
	method precio() = (2-1)*100
	method siguienteEtapa() = trigoPasado
}
object trigoPasado{
	method image() = "wheat_3.png"
	method esCosechable() = true
	method precio() = (3-1)*100
	method siguienteEtapa() = trigoRecienSembrado
}

class Tomaco {
	var property position
	method image() = "tomaco.png"
	method regar(){
		if(not granja.parcelaOcupada(self.posicionDeArriba())){
			position = self.posicionDeArriba()
		}	
	}
	method posicionDeArriba(){
		return if (position.y() == game.height()-1) game.at(position.x(), 0) else position.up(1)
	}
	method esCosechable() = true
	method precio() = 80
}
class Maiz {
	var property position 
	var etapa = maizBebe
	method image() {
		return etapa.image()
	}
	method crecer() {
	  etapa = maizAdulto
	}
	method esCosechable() = etapa.esCosechable()

	method regar(){ 
		etapa = etapa.siguienteEtapa() 
	}
	method precio() = 150
}
object maizBebe {
	method image() = "corn_baby.png"
	method esCosechable() = false
	method siguienteEtapa() = maizAdulto
}
object maizAdulto {
	method image() = "corn_adult.png"
	method esCosechable() = true  
	method siguienteEtapa() = self
}

class Mercado {
	var property position 
	var property monedas = 500
	const property mercaderia = []
	method image() = "market.png"
	method tieneDineroSuficiente(monto) = monedas >= monto
	method acreditarCompra(plantas, monto) {
	  monedas = monedas - monto
	  mercaderia.addAll(plantas)
	}
	method regar(){
	} 
}