import cultivos.*
import personaje.*
import wollok.game.*

object granja {
    const property cultivos = []
    const property cosechados = []
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

    method sembrarMaiz(posicion){
        self.validarSiembra(posicion)
        self.registrarCultivo(new Maiz(position = posicion))
    }
    method sembrarTrigo(posicion) {
        self.validarSiembra(posicion)
        self.registrarCultivo(new Trigo(position = posicion))
    }

    method sembrarTomaco(posicion){
        self.validarSiembra(posicion)
        self.registrarCultivo(new Tomaco(position = posicion))
    }
    method validarSiembra(posicion){
        if(self.parcelaOcupada(posicion)){
            self.error("No puedo plantar aca")
        }
    }
    method registrarCultivo(cultivo){
        cultivos.add(cultivo)
        game.addVisual(cultivo)
    }
    method regarPlantaEn(posicion){
        const planta = self.plantaEn(posicion)
        if(planta != null){
            planta.regar()
        }else{
            self.error("No hay planta que regar")
        }
    }
    method cosecharPlanta(posicion){
        const planta = self.plantaEn(posicion)

        if (planta==null){
            self.error("No hay planta que cosechar")
        }else if (planta.esCosechable()){
            game.removeVisual(planta)
            cultivos.remove(planta)
            cosechados.add(planta)
        }
    }
    method cantidadAVender() = cosechados.size()
    method valorVentaCosechados() = cosechados.sum({planta => planta.precio()})
    method vaciarCosechados(){
        cosechados.clear()
    }
    method regarPlantaDeAspersor(posicion) {
      const planta = self.plantaEn(posicion)
      if (planta != null){
        planta.regar()
      }
    }
    method agregarMercado(mercado){
        mercados.add(mercado)
        game.addVisual(mercado)        
    }
    method hayMercadoAca(posicion) = mercados.findOrDefault({m => m.position()==posicion}, null)
    method agregarAspersor(aspersor){
        aspersores.add(aspersor)
        game.addVisual(aspersor)
    }

}