import wollok.game.*
import granja.*

class Aspersor {
	var property position

	method image() ="aspersor.png"  

	method activar() {
		game.onTick(1000, "aspersor_riega_" + self.identity().toString(), { self.regarAlrededor() })
	}
	method regarAlrededor(){
		const parcelasVecinas = [position.up(1),position.down(1),position.left(1),position.right(1),position.up(1).left(1), position.up(1).right(1),
			position.down(1).left(1), position.down(1).right(1)]
		parcelasVecinas.forEach({pos => game.getObjectsIn(pos).forEach({objeto => objeto.regar()})
		})
	}
	method regar(){}
	method cosechar(personaje){}
	method vender(personaje){}
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
	method vender(personaje){}
	method cosechar(personaje){
		if(self.esCosechable()){
			personaje.cosecharPlanta(self)
        	granja.extraerCultivo(self)
			}
		}
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
		if(not granja.hayAlgo(self.posicionSig())){
			position = self.posicionSig()
		}	
	}
	method posicionSig(){
		return if (position.y() == game.height()-1) game.at(position.x(), 0) else position.up(1)
	}
	method esCosechable() = true
	method precio() = 80
	method vender(personaje){}
	method cosechar(personaje){
		if(self.esCosechable()){
			personaje.cosecharPlanta(self)
        	granja.extraerCultivo(self)
		}
	}
}
class Maiz {
	var property position 
	var etapa = maizBebe
	method image() {
		return etapa.image()
	}
	method esCosechable() = etapa.esCosechable()

	method regar(){ 
		etapa = etapa.siguienteEtapa() 
	}
	method precio() = 150
	method vender(personaje){}
	method cosechar(personaje){
		if(self.esCosechable()){
			personaje.cosecharPlanta(self)
        	granja.extraerCultivo(self)
		}
	}
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
	method vender(personaje){
		const ganancias = personaje.valorDeLaMochila()
		self.validarGanancias(ganancias)
		self.validarPago(ganancias)
		personaje.entregarMercaderia(self)
		personaje.recibirPago(ganancias)
	}
	method validarGanancias(ganancias){
		if(ganancias==0){
			self.error("No tenes cosecha para vender")
		}
	}
	method validarPago(ganancias){
		if(not self.tieneDineroSuficiente(ganancias)){
			self.error("El mercado no tiene dinero suficiente")
		}
	}
	method cosechar(personaje){}
	method regar(){}
}