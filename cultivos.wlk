import wollok.game.*
import granja.*

class Aspersor {
	var property position

	method image() ="aspersor.png"  

	method activar() {
		game.onTick(1000, "aspersor_riega_" + self.identity().toString(), { self.regarAlrededor() })
	}
	method regarAlrededor(){
		const vecinas = self.posicionesVecinas()
		vecinas.forEach({pos => granja.regarPlantaDeAspersor(pos)})	
	}
	method posicionesVecinas(){
		return [position.up(1), position.down(1), position.left(1), position.right(1),
            position.up(1).left(1), position.up(1).right(1), position.down(1).left(1), position.down(1).right(1)]
	}
}
class Trigo {
	var property position 
	var evolucion = 0
	method image() = "wheat_" + evolucion +".png" 
	method regar(){
		if (evolucion==3){
			evolucion = 0
		}else{
			evolucion = evolucion + 1
		}
	}
	method esCosechable() = evolucion >= 2
	method precio() = (evolucion - 1) * 100
}
class Tomaco {
	var property position
	method image() = "tomaco.png"
	method regar(){
		const proximaPosicion = self.calcularProximaPosicion()
		if(not granja.parcelaOcupada(proximaPosicion)){
			position = proximaPosicion
		}
	}
	method calcularProximaPosicion() {
	const posicionYDelTomaco = position.y()
	const bordeSuperior = game.height()-1
	return if (posicionYDelTomaco==bordeSuperior){
		game.at(position.x(),0)
		}else{
			position.up(1)
		}
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
	method comprarCosecha(plantas, monto) {
	  monedas = monedas - monto
	  mercaderia.addAll(plantas)
	}     
}