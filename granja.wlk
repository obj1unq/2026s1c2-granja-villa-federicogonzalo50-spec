import cultivos.*
import personaje.*
import wollok.game.*

object granja {
    const property cultivos = []
    const property mercados =  []
    const property aspersores = []

    method hayAlgo(posicion) {
        return cultivos.any({c => c.position() == posicion}) or
        mercados.any({m => m.position() == posicion}) or
        aspersores.any({a => a.position() == posicion})
    }
    method obtenerEn(posicion){
        const todos = cultivos + mercados + aspersores
        return todos.find({obj => obj.position() == posicion})
    }

    method sembrarEn(posicion, nuevoCultivo){
        self.validarSiembra(posicion)
        self.registrarCultivo(nuevoCultivo)
        game.addVisual(nuevoCultivo)
    }

    method validarSiembra(posicion){
        if(self.hayAlgo(posicion)){
            self.error("No puedo plantar aca")
        }
    }
    method registrarCultivo(cultivo){
        cultivos.add(cultivo)
    }
    method extraerCultivo(cultivo){
        cultivos.remove(cultivo)
        game.removeVisual(cultivo)
    }
    method agregarMercado(mercado){
        mercados.add(mercado)
        game.addVisual(mercado)        
    }
    method agregarAspersor(aspersor){
        aspersores.add(aspersor)
        game.addVisual(aspersor)
    }

}