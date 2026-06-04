import cultivos.*
import personaje.*
import wollok.game.*

object granja {
    const property cultivos = []
    const property mercados =  []
    const property aspersores = []

    method plantaEn(posicion)= cultivos.findOrDefault({ c => c.position() == posicion }, null)

    method mercadoEn(posicion)=mercados.findOrDefault({m => m.position()== posicion}, null)

    method aspersorEn(posicion)=aspersores.findOrDefault({a => a.position()== posicion}, null)

    method parcelaOcupada(posicion){
        return self.plantaEn(posicion)      != null
            or self.mercadoEn(posicion)     != null
            or self.aspersorEn(posicion)    != null
    }

    method sembrarEn(posicion, claseDelCultivo){
        self.validarSiembra(posicion)
        const nuevoCultivo = claseDelCultivo.apply()
        self.registrarCultivo(nuevoCultivo)
        game.addVisual(nuevoCultivo)
    }
    method validarSiembra(posicion){
        if(self.parcelaOcupada(posicion)){
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
    method registrarAspersor(aspersor){
        aspersores.add(aspersor)
        game.addVisual(aspersor)
    }
    method hayMercadoAca(posicion) = mercados.findOrDefault({m => m.position()==posicion}, null)
    method agregarAspersor(aspersor){
        aspersores.add(aspersor)
        game.addVisual(aspersor)
    }

}