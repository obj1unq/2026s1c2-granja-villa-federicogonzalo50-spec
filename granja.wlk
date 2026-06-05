import cultivos.*
import personaje.*
import wollok.game.*

object granja {
    const property cultivos = []
    const property mercados =  []
    const property aspersores = []

    method existencias() = cultivos + mercados + aspersores

    method hayAlgo(posicion) = self.existencias().findOrDefault({o => o.position() == posicion}, null)

    method parcelaOcupada(posicion)=self.hayAlgo(posicion)!=null

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
    method agregarAspersor(aspersor){
        aspersores.add(aspersor)
        game.addVisual(aspersor)
    }

}